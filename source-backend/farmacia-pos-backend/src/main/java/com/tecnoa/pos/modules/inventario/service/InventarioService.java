package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoRequestDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.ProductoPrecioDTO;
import com.tecnoa.pos.modules.inventario.model.*;
import com.tecnoa.pos.modules.inventario.repository.*;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import com.tecnoa.pos.shared.security.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class InventarioService {

    private final InventarioRepository inventarioRepository;
    private final MovimientoRepository movimientoRepository;
    private final ParametroService parametroService;
    private final SucursalService sucursalService;
    private final ProductoService productoService;
    private final SecurityUtils securityUtils;

    @Transactional(readOnly = true)
    public List<InventarioResponseDTO> getStock(UUID productoId, UUID sucursalId, UUID loteId,
                                                String productoNombre, Boolean soloConStock) {
        String nombreFiltro = (productoNombre != null && !productoNombre.isBlank())
                ? productoNombre.trim() : null;

        List<Inventario> list = inventarioRepository.buscarStock(
                productoId, sucursalId, loteId, nombreFiltro);

        if (Boolean.TRUE.equals(soloConStock)) {
            list = list.stream().filter(i -> i.getStockActual() > 0).collect(Collectors.toList());
        }
        return list.stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Auditable(accion = "CREAR", modulo = "INVENTARIO", entidad = "MovimientoInventario",
            descripcion = "Entrada de stock")
    @Transactional
    public MovimientoResponseDTO registrarEntrada(MovimientoRequestDTO dto) {
        Inventario inventario = inventarioRepository.findById(dto.getInventarioId())
                .orElseThrow(() -> new ResourceNotFoundException("Inventario", dto.getInventarioId()));
        int stockAnterior = inventario.getStockActual();
        inventario.setStockActual(stockAnterior + dto.getCantidad());
        inventarioRepository.save(inventario);
        return registrarMovimiento(inventario, TipoMovimiento.ENTRADA, dto.getCantidad(),
                stockAnterior, inventario.getStockActual(), dto.getObservacion());
    }

    @Auditable(accion = "CREAR", modulo = "INVENTARIO", entidad = "MovimientoInventario",
            descripcion = "Salida manual de stock")
    @Transactional
    public MovimientoResponseDTO registrarSalida(MovimientoRequestDTO dto) {
        Inventario inventario = inventarioRepository.findById(dto.getInventarioId())
                .orElseThrow(() -> new ResourceNotFoundException("Inventario", dto.getInventarioId()));
        boolean permitirSinStock = parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK");
        if (!permitirSinStock && inventario.getStockActual() < dto.getCantidad()) {
            throw new BusinessException("Stock insuficiente. Stock actual: " + inventario.getStockActual());
        }
        int stockAnterior = inventario.getStockActual();
        inventario.setStockActual(stockAnterior - dto.getCantidad());
        inventarioRepository.save(inventario);
        return registrarMovimiento(inventario, TipoMovimiento.SALIDA, dto.getCantidad(),
                stockAnterior, inventario.getStockActual(), dto.getObservacion());
    }

    @Auditable(accion = "EDITAR", modulo = "INVENTARIO", entidad = "Inventario",
            descripcion = "Ajuste de stock")
    @Transactional
    public MovimientoResponseDTO registrarAjuste(MovimientoRequestDTO dto) {
        Inventario inventario = inventarioRepository.findById(dto.getInventarioId())
                .orElseThrow(() -> new ResourceNotFoundException("Inventario", dto.getInventarioId()));
        int stockAnterior = inventario.getStockActual();
        int stockNuevo = dto.getStockNuevo() != null ? dto.getStockNuevo() : dto.getCantidad();
        inventario.setStockActual(stockNuevo);
        inventarioRepository.save(inventario);
        return registrarMovimiento(inventario, TipoMovimiento.AJUSTE,
                Math.abs(stockNuevo - stockAnterior), stockAnterior, stockNuevo, dto.getObservacion());
    }

    public Page<MovimientoResponseDTO> listarMovimientos(UUID productoId, UUID sucursalId,
                                                         UUID loteId, TipoMovimiento tipo, UUID usuarioId,
                                                         LocalDate desde, LocalDate hasta, Pageable pageable) {
        LocalDateTime desdeX = (desde != null) ? LocalDateTime.of(desde, LocalTime.MIN) : null;
        LocalDateTime hastaX = (hasta != null) ? hasta.atTime(23, 59, 59) : null;
        return movimientoRepository.buscar(productoId, sucursalId, loteId, tipo, usuarioId, desdeX, hastaX, pageable)
                .map(this::toMovimientoResponse);
    }

    private MovimientoResponseDTO registrarMovimiento(Inventario inventario, TipoMovimiento tipo,
                                                      int cantidad, int stockAnterior, int stockResultante, String observacion) {
        MovimientoInventario mov = MovimientoInventario.builder()
                .inventario(inventario)
                .loteId(inventario.getLote().getId())
                .productoId(inventario.getLote().getProducto().getId())
                .sucursalId(inventario.getSucursal().getId())
                .tipo(tipo).cantidad(cantidad)
                .stockAnterior(stockAnterior).stockResultante(stockResultante)
                .usuarioId(securityUtils.getCurrentUserId())
                .observacion(observacion).build();

        return toMovimientoResponse(movimientoRepository.save(mov));
    }

    private InventarioResponseDTO toResponse(Inventario i) {
        LocalDateTime ahora = LocalDateTime.now();
        List<ProductoPrecioDTO> preciosVigentes = i.getLote().getProducto().getPrecios().stream()
                .filter(p -> Boolean.TRUE.equals(p.getActivo())
                        && !p.getVigenciaDesde().isAfter(ahora)
                        && (p.getVigenciaHasta() == null || !p.getVigenciaHasta().isBefore(ahora)))
                .map(p -> ProductoPrecioDTO.builder()
                        .id(p.getId())
                        .tipoPrecio(p.getTipoPrecio())
                        .precio(p.getPrecio())
                        .precioCompra(p.getPrecioCompra())
                        .vigenciaDesde(p.getVigenciaDesde())
                        .vigenciaHasta(p.getVigenciaHasta())
                        .activo(p.getActivo())
                        .build())
                .collect(Collectors.toList());

        return InventarioResponseDTO.builder()
                .id(i.getId())
                .loteId(i.getLote().getId())
                .numeroLote(i.getLote().getNumeroLote())
                .fechaVencimiento(i.getLote().getFechaVencimiento())
                .sucursalId(i.getSucursal().getId())
                .sucursalNombre(i.getSucursal().getNombre())
                .productoId(i.getLote().getProducto().getId())
                .productoNombre(i.getLote().getProducto().getNombre())
                .stockActual(i.getStockActual())
                .stockMinimo(i.getStockMinimo())
                .ubicacion(i.getUbicacion())
                .bajoStock(i.getStockActual() <= i.getStockMinimo())
                .precios(preciosVigentes)
                .build();
    }

    private MovimientoResponseDTO toMovimientoResponse(MovimientoInventario m) {
        return MovimientoResponseDTO.builder()
                .id(m.getId()).inventarioId(m.getInventario().getId())
                .loteId(m.getLoteId()).productoId(m.getProductoId())
                .sucursalId(m.getSucursalId()).tipo(m.getTipo())
                .sucursalNombre(sucursalService.obtener(m.getSucursalId()).getNombre())
                .productoNombre(productoService.obtener(m.getProductoId()).getNombre())
                .cantidad(m.getCantidad()).stockAnterior(m.getStockAnterior())
                .stockResultante(m.getStockResultante()).fecha(m.getFecha())
                .usuarioId(m.getUsuarioId()).observacion(m.getObservacion()).build();
    }
}

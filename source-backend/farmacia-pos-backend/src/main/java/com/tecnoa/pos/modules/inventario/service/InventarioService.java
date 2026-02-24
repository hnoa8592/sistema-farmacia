package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoRequestDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoResponseDTO;
import com.tecnoa.pos.modules.inventario.model.*;
import com.tecnoa.pos.modules.inventario.repository.*;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class InventarioService {

    private final InventarioRepository inventarioRepository;
    private final MovimientoRepository movimientoRepository;
    private final ParametroService parametroService;
    private final SucursalRepository sucursalRepository;

    public List<InventarioResponseDTO> getStock(UUID productoId, UUID sucursalId, UUID loteId) {
        List<Inventario> list;
        if (productoId != null) list = inventarioRepository.findByProductoId(productoId);
        else if (sucursalId != null) list = inventarioRepository.findBySucursalId(sucursalId);
        else if (loteId != null) list = inventarioRepository.findByLoteId(loteId);
        else list = inventarioRepository.findAll();
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
            LocalDateTime desde, LocalDateTime hasta, Pageable pageable) {
        return movimientoRepository.buscar(productoId, sucursalId, loteId, tipo, usuarioId, desde, hasta, pageable)
                .map(this::toMovimientoResponse);
    }

    private MovimientoResponseDTO registrarMovimiento(Inventario inventario, TipoMovimiento tipo,
            int cantidad, int stockAnterior, int stockResultante, String observacion) {
        String email = null;
        try {
            email = SecurityContextHolder.getContext().getAuthentication().getName();
        } catch (Exception ignored) {}

        MovimientoInventario mov = MovimientoInventario.builder()
                .inventario(inventario)
                .loteId(inventario.getLote().getId())
                .productoId(inventario.getLote().getProducto().getId())
                .sucursalId(inventario.getSucursal().getId())
                .tipo(tipo).cantidad(cantidad)
                .stockAnterior(stockAnterior).stockResultante(stockResultante)
                .observacion(observacion).build();

        return toMovimientoResponse(movimientoRepository.save(mov));
    }

    private InventarioResponseDTO toResponse(Inventario i) {
        return InventarioResponseDTO.builder()
                .id(i.getId()).loteId(i.getLote().getId())
                .numeroLote(i.getLote().getNumeroLote())
                .sucursalId(i.getSucursal().getId()).sucursalNombre(i.getSucursal().getNombre())
                .stockActual(i.getStockActual()).stockMinimo(i.getStockMinimo())
                .ubicacion(i.getUbicacion())
                .bajoPStock(i.getStockActual() <= i.getStockMinimo()).build();
    }

    private MovimientoResponseDTO toMovimientoResponse(MovimientoInventario m) {
        return MovimientoResponseDTO.builder()
                .id(m.getId()).inventarioId(m.getInventario().getId())
                .loteId(m.getLoteId()).productoId(m.getProductoId())
                .sucursalId(m.getSucursalId()).tipo(m.getTipo())
                .cantidad(m.getCantidad()).stockAnterior(m.getStockAnterior())
                .stockResultante(m.getStockResultante()).fecha(m.getFecha())
                .usuarioId(m.getUsuarioId()).observacion(m.getObservacion()).build();
    }
}

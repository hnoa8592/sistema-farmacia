package com.tecnoa.pos.modules.ventas.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.inventario.model.*;
import com.tecnoa.pos.modules.inventario.repository.*;
import com.tecnoa.pos.modules.inventario.service.ProductoPrecioService;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.modules.usuarios.model.Usuario;
import com.tecnoa.pos.modules.usuarios.repository.UsuarioRepository;
import com.tecnoa.pos.shared.security.SecurityUtils;
import com.tecnoa.pos.modules.ventas.dto.DetalleVentaDTO;
import com.tecnoa.pos.modules.ventas.dto.VentaRequestDTO;
import com.tecnoa.pos.modules.ventas.dto.VentaResponseDTO;
import com.tecnoa.pos.modules.ventas.model.DetalleVenta;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.model.Venta;
import com.tecnoa.pos.modules.ventas.repository.VentaRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VentaService {

    private final VentaRepository ventaRepository;
    private final InventarioRepository inventarioRepository;
    private final MovimientoRepository movimientoRepository;
    private final ProductoPrecioService productoPrecioService;
    private final ParametroService parametroService;
    private final SecurityUtils securityUtils;
    private final UsuarioRepository usuarioRepository;

    @Transactional(readOnly = true)
    public Page<VentaResponseDTO> listar(UUID usuarioId, EstadoVenta estado,
                                         LocalDate desde, LocalDate hasta,
                                         Pageable pageable) {
        LocalDateTime desdeDateTime = (desde != null) ? desde.atStartOfDay()          : null;
        LocalDateTime hastaDateTime = (hasta != null) ? hasta.atTime(23, 59, 59) : null;
        Usuario usuarioActual = getUsuarioActual();
        UUID usuarioFiltro = esAdmin(usuarioActual) ? usuarioId : usuarioActual.getId();
        Pageable pageableOrdenado = pageable.getSort().isSorted()
                ? pageable
                : PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), Sort.by(Sort.Direction.DESC, "fecha"));

        Specification<Venta> filtros = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (usuarioFiltro != null) {
                predicates.add(cb.equal(root.get("usuarioId"), usuarioFiltro));
            }
            if (estado != null) {
                predicates.add(cb.equal(root.get("estado"), estado));
            }
            if (desdeDateTime != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), desdeDateTime));
            }
            if (hastaDateTime != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), hastaDateTime));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return ventaRepository.findAll(filtros, pageableOrdenado)
                .map(this::toResponse);
    }

    public VentaResponseDTO obtener(UUID id) {
        Venta venta = ventaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Venta", id));
        validarAccesoVenta(venta);
        return toResponse(venta);
    }

    @Auditable(accion = "CREAR", modulo = "VENTAS", entidad = "Venta",
               descripcion = "Registro de venta")
    @Transactional
    public VentaResponseDTO registrarVenta(VentaRequestDTO request) {
        boolean permitirSinStock = parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK");
        BigDecimal maxDescuento = parametroService.getValorAsDecimal("MAX_DESCUENTO_PORCENTAJE");

        // Validar descuento
        if (request.getDescuento() != null && request.getDescuento().compareTo(BigDecimal.ZERO) > 0) {
            if (request.getDescuento().compareTo(maxDescuento) > 0) {
                throw new BusinessException("El descuento no puede superar el " + maxDescuento + "%");
            }
        }

        UUID usuarioId = securityUtils.getCurrentUserId();

        List<DetalleVenta> detalles = new ArrayList<>();
        BigDecimal subtotalTotal = BigDecimal.ZERO;

        for (DetalleVentaDTO dto : request.getDetalles()) {
            Inventario inventario = inventarioRepository.findById(dto.getInventarioId())
                    .orElseThrow(() -> new ResourceNotFoundException("Inventario", dto.getInventarioId()));

            if (!permitirSinStock && inventario.getStockActual() < dto.getCantidad()) {
                throw new BusinessException("Stock insuficiente para lote " +
                        inventario.getLote().getNumeroLote() + ". Stock: " + inventario.getStockActual());
            }

            ProductoPrecio precio = productoPrecioService.getPrecioVigente(
                    inventario.getLote().getProducto().getId(), dto.getTipoPrecio())
                    .orElseThrow(() -> new BusinessException("No hay precio vigente para tipo: " + dto.getTipoPrecio()));

            BigDecimal precioUnitario = precio.getPrecio();
            BigDecimal subtotal = precioUnitario.multiply(BigDecimal.valueOf(dto.getCantidad()));

            // Descontar stock
            int stockAnterior = inventario.getStockActual();
            inventario.setStockActual(stockAnterior - dto.getCantidad());
            inventarioRepository.save(inventario);

            // Registrar movimiento
            movimientoRepository.save(MovimientoInventario.builder()
                    .inventario(inventario)
                    .loteId(inventario.getLote().getId())
                    .productoId(inventario.getLote().getProducto().getId())
                    .sucursalId(inventario.getSucursal().getId())
                    .tipo(TipoMovimiento.SALIDA)
                    .cantidad(dto.getCantidad())
                    .stockAnterior(stockAnterior)
                    .stockResultante(inventario.getStockActual())
                    .usuarioId(usuarioId)
                    .observacion("Venta")
                    .build());

            detalles.add(DetalleVenta.builder()
                    .productoId(inventario.getLote().getProducto().getId())
                    .loteId(inventario.getLote().getId())
                    .inventarioId(inventario.getId())
                    .tipoPrecio(dto.getTipoPrecio())
                    .cantidad(dto.getCantidad())
                    .precioUnitario(precioUnitario)
                    .subtotal(subtotal)
                    .build());

            subtotalTotal = subtotalTotal.add(subtotal);
        }

        // Aplicar descuento
        BigDecimal total = subtotalTotal;
        BigDecimal descuentoPorc = request.getDescuento() != null ? request.getDescuento() : BigDecimal.ZERO;
        if (descuentoPorc.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal descuentoMonto = total.multiply(descuentoPorc)
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
            total = total.subtract(descuentoMonto);
        }

        Venta venta = Venta.builder()
                .total(total)
                .descuento(descuentoPorc)
                .usuarioId(usuarioId)
                .estado(EstadoVenta.COMPLETADA)
                .detalles(detalles)
                .build();

        detalles.forEach(d -> d.setVenta(venta));
        return toResponse(ventaRepository.save(venta));
    }

    @Auditable(accion = "ANULAR", modulo = "VENTAS", entidad = "Venta",
               descripcion = "Anulación de venta")
    @Transactional
    public VentaResponseDTO anularVenta(UUID id) {
        Venta venta = ventaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Venta", id));

        if (venta.getEstado() == EstadoVenta.ANULADA) {
            throw new BusinessException("La venta ya está anulada");
        }

        // Revertir stock
        for (DetalleVenta detalle : venta.getDetalles()) {
            Inventario inventario = inventarioRepository.findById(detalle.getInventarioId())
                    .orElseThrow(() -> new ResourceNotFoundException("Inventario", detalle.getInventarioId()));
            int stockAnterior = inventario.getStockActual();
            inventario.setStockActual(stockAnterior + detalle.getCantidad());
            inventarioRepository.save(inventario);

            movimientoRepository.save(MovimientoInventario.builder()
                    .inventario(inventario)
                    .loteId(detalle.getLoteId())
                    .productoId(detalle.getProductoId())
                    .sucursalId(inventario.getSucursal().getId())
                    .tipo(TipoMovimiento.ENTRADA)
                    .cantidad(detalle.getCantidad())
                    .stockAnterior(stockAnterior)
                    .stockResultante(inventario.getStockActual())
                    .usuarioId(securityUtils.getCurrentUserId())
                    .observacion("Anulación venta #" + venta.getId())
                    .build());
        }

        venta.setEstado(EstadoVenta.ANULADA);
        return toResponse(ventaRepository.save(venta));
    }

    private void validarAccesoVenta(Venta venta) {
        Usuario usuarioActual = getUsuarioActual();
        if (!esAdmin(usuarioActual) && !venta.getUsuarioId().equals(usuarioActual.getId())) {
            throw new BusinessException("No tiene permiso para ver ventas de otros usuarios");
        }
    }

    private Usuario getUsuarioActual() {
        UUID usuarioId = securityUtils.getCurrentUserId();
        if (usuarioId == null) {
            throw new BusinessException("Usuario autenticado no encontrado");
        }
        return usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario", usuarioId));
    }

    private boolean esAdmin(Usuario usuario) {
        return usuario.getPerfiles().stream()
                .anyMatch(p -> "ADMIN".equalsIgnoreCase(p.getNombre()));
    }

    private VentaResponseDTO toResponse(Venta v) {
        List<DetalleVentaDTO> detalles = v.getDetalles().stream()
                .map(d -> DetalleVentaDTO.builder()
                        .id(d.getId()).inventarioId(d.getInventarioId())
                        .productoId(d.getProductoId()).loteId(d.getLoteId())
                        .tipoPrecio(d.getTipoPrecio()).cantidad(d.getCantidad())
                        .precioUnitario(d.getPrecioUnitario()).subtotal(d.getSubtotal())
                        .build())
                .collect(Collectors.toList());
        VentaResponseDTO.UsuarioDTO usuario = usuarioRepository.findById(v.getUsuarioId())
                .map(u -> VentaResponseDTO.UsuarioDTO.builder()
                        .id(u.getId())
                        .nombre(u.getNombre())
                        .build())
                .orElse(null);

        return VentaResponseDTO.builder()
                .id(v.getId()).fecha(v.getFecha()).total(v.getTotal())
                .descuento(v.getDescuento()).usuarioId(v.getUsuarioId())
                .usuario(usuario)
                .estado(v.getEstado()).detalles(detalles).build();
    }
}

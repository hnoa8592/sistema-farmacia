package com.tecnoa.pos.modules.reportes.service;

import com.tecnoa.pos.modules.inventario.dto.MovimientoResponseDTO;
import com.tecnoa.pos.modules.inventario.model.Inventario;
import com.tecnoa.pos.modules.inventario.model.MovimientoInventario;
import com.tecnoa.pos.modules.inventario.model.TipoMovimiento;
import com.tecnoa.pos.modules.inventario.repository.InventarioRepository;
import com.tecnoa.pos.modules.inventario.repository.MovimientoRepository;
import com.tecnoa.pos.modules.inventario.repository.ProductoRepository;
import com.tecnoa.pos.modules.inventario.repository.SucursalRepository;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.modules.reportes.dto.ReporteStockDTO;
import com.tecnoa.pos.modules.reportes.dto.ReporteVentasDTO;
import com.tecnoa.pos.modules.usuarios.model.Usuario;
import com.tecnoa.pos.modules.usuarios.repository.UsuarioRepository;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.model.Venta;
import com.tecnoa.pos.modules.ventas.repository.VentaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReporteService {

    private final VentaRepository ventaRepository;
    private final InventarioRepository inventarioRepository;
    private final ProductoRepository productoRepository;
    private final MovimientoRepository movimientoRepository;
    private final SucursalRepository sucursalRepository;
    private final UsuarioRepository usuarioRepository;
    private final ParametroService parametroService;

    @Transactional(readOnly = true)
    public ReporteVentasDTO reporteVentas(LocalDateTime desde, LocalDateTime hasta) {
        List<Venta> ventas = ventaRepository
                .findByFechaBetween(desde, hasta, PageRequest.of(0, Integer.MAX_VALUE))
                .getContent();

        List<Venta> completadas = ventas.stream()
                .filter(v -> v.getEstado() == EstadoVenta.COMPLETADA)
                .collect(Collectors.toList());

        long ventasAnuladas = ventas.stream()
                .filter(v -> v.getEstado() == EstadoVenta.ANULADA)
                .count();

        BigDecimal totalVendido = completadas.stream()
                .map(Venta::getTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Acumular totales por dia
        Map<LocalDate, BigDecimal> totalesPorDia = new HashMap<>();
        Map<LocalDate, Long> cantidadPorDia = new HashMap<>();
        for (Venta v : completadas) {
            LocalDate dia = v.getFecha().toLocalDate();
            totalesPorDia.merge(dia, v.getTotal(), BigDecimal::add);
            cantidadPorDia.merge(dia, 1L, Long::sum);
        }

        // Construir lista completa de dias en el rango (rellena con 0 los dias sin ventas)
        List<ReporteVentasDTO.VentaPorDia> ventasPorDia = new ArrayList<>();
        for (LocalDate dia = desde.toLocalDate(); !dia.isAfter(hasta.toLocalDate()); dia = dia.plusDays(1)) {
            ventasPorDia.add(ReporteVentasDTO.VentaPorDia.builder()
                    .fecha(dia.toString())
                    .cantidadVentas(cantidadPorDia.getOrDefault(dia, 0L))
                    .totalVendido(totalesPorDia.getOrDefault(dia, BigDecimal.ZERO))
                    .build());
        }

        // Ultimas 5 ventas (mas recientes primero)
        List<ReporteVentasDTO.VentaResumen> ultimasVentas = ventas.stream()
                .sorted((a, b) -> b.getFecha().compareTo(a.getFecha()))
                .limit(5)
                .map(v -> ReporteVentasDTO.VentaResumen.builder()
                        .id(v.getId())
                        .fecha(v.getFecha())
                        .total(v.getTotal())
                        .estado(v.getEstado().name())
                        .build())
                .collect(Collectors.toList());

        return ReporteVentasDTO.builder()
                .desde(desde)
                .hasta(hasta)
                .cantidadVentas((long) completadas.size())
                .totalVendido(totalVendido)
                .ventasAnuladas(ventasAnuladas)
                .ventasPorDia(ventasPorDia)
                .ultimasVentas(ultimasVentas)
                .build();
    }

    @Transactional(readOnly = true)
    public Page<MovimientoResponseDTO> reporteMovimientos(LocalDate desde, LocalDate hasta,
                                                           TipoMovimiento tipo, UUID sucursalId,
                                                           Pageable pageable) {
        return movimientoRepository
                .buscar(null, sucursalId, null, tipo, null, toDesdeTs(desde), toHastaTs(hasta), pageable)
                .map(this::toMovimientoDTO);
    }

    @Transactional(readOnly = true)
    public byte[] exportarMovimientosCSV(LocalDate desde, LocalDate hasta,
                                          TipoMovimiento tipo, UUID sucursalId) {
        List<MovimientoInventario> todos = movimientoRepository
                .buscar(null, sucursalId, null, tipo, null,
                        toDesdeTs(desde), toHastaTs(hasta), Pageable.unpaged())
                .getContent();

        StringBuilder sb = new StringBuilder();
        sb.append('﻿'); // BOM UTF-8 para compatibilidad con Excel
        sb.append("Fecha,Producto,Sucursal,Tipo,Cantidad,Stock Anterior,Stock Resultante,Usuario,Observacion\n");

        for (MovimientoInventario m : todos) {
            MovimientoResponseDTO dto = toMovimientoDTO(m);
            sb.append(escapeCsv(dto.getFecha() != null ? dto.getFecha().toString() : "")).append(',');
            sb.append(escapeCsv(dto.getProductoNombre())).append(',');
            sb.append(escapeCsv(dto.getSucursalNombre())).append(',');
            sb.append(escapeCsv(dto.getTipo() != null ? dto.getTipo().name() : "")).append(',');
            sb.append(dto.getCantidad() != null ? dto.getCantidad() : "").append(',');
            sb.append(dto.getStockAnterior() != null ? dto.getStockAnterior() : "").append(',');
            sb.append(dto.getStockResultante() != null ? dto.getStockResultante() : "").append(',');
            sb.append(escapeCsv(dto.getUsuarioNombre())).append(',');
            sb.append(escapeCsv(dto.getObservacion())).append('\n');
        }

        return sb.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    private MovimientoResponseDTO toMovimientoDTO(MovimientoInventario m) {
        String productoNombre = productoRepository.findById(m.getProductoId())
                .map(p -> p.getNombre()).orElse("—");
        String sucursalNombre = sucursalRepository.findById(m.getSucursalId())
                .map(s -> s.getNombre()).orElse("—");
        String usuarioNombre = (m.getUsuarioId() != null)
                ? usuarioRepository.findById(m.getUsuarioId()).map(Usuario::getNombre).orElse("—")
                : "—";
        return MovimientoResponseDTO.builder()
                .id(m.getId())
                .inventarioId(m.getInventario().getId())
                .loteId(m.getLoteId())
                .productoId(m.getProductoId())
                .productoNombre(productoNombre)
                .sucursalId(m.getSucursalId())
                .sucursalNombre(sucursalNombre)
                .tipo(m.getTipo())
                .cantidad(m.getCantidad())
                .stockAnterior(m.getStockAnterior())
                .stockResultante(m.getStockResultante())
                .fecha(m.getFecha())
                .usuarioId(m.getUsuarioId())
                .usuarioNombre(usuarioNombre)
                .observacion(m.getObservacion())
                .build();
    }

    private LocalDateTime toDesdeTs(LocalDate d) {
        return d != null ? LocalDateTime.of(d, LocalTime.MIN) : null;
    }

    private LocalDateTime toHastaTs(LocalDate h) {
        return h != null ? LocalDateTime.of(h, LocalTime.MAX) : null;
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }

    @Transactional(readOnly = true)
    public List<ReporteStockDTO> reporteStock() {
        int diasAlerta = parametroService.getValorAsInteger("DIAS_ALERTA_VENCIMIENTO");
        LocalDate fechaAlerta = LocalDate.now().plusDays(diasAlerta);

        return inventarioRepository.findAll().stream()
                .collect(Collectors.groupingBy(i -> i.getLote().getProducto().getId()))
                .values().stream()
                .map(invs -> {
                    int stockTotal = invs.stream().mapToInt(Inventario::getStockActual).sum();
                    int stockMin = invs.stream().mapToInt(Inventario::getStockMinimo).max().orElse(0);
                    long lotesProximos = invs.stream()
                            .filter(i -> !i.getLote().getFechaVencimiento().isAfter(fechaAlerta))
                            .count();
                    var producto = invs.getFirst().getLote().getProducto();
                    return ReporteStockDTO.builder()
                            .productoId(producto.getId())
                            .productoNombre(producto.getNombre())
                            .codigo(producto.getCodigo())
                            .stockTotal(stockTotal)
                            .stockMinimo(stockMin)
                            .bajoStock(stockTotal <= stockMin)
                            .lotesProximosVencer(lotesProximos)
                            .build();
                })
                .collect(Collectors.toList());
    }
}

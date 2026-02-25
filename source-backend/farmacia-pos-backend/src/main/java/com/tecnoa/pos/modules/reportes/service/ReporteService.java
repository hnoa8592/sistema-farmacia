package com.tecnoa.pos.modules.reportes.service;

import com.tecnoa.pos.modules.inventario.model.Inventario;
import com.tecnoa.pos.modules.inventario.repository.InventarioRepository;
import com.tecnoa.pos.modules.inventario.repository.ProductoRepository;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.modules.reportes.dto.ReporteStockDTO;
import com.tecnoa.pos.modules.reportes.dto.ReporteVentasDTO;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.model.Venta;
import com.tecnoa.pos.modules.ventas.repository.VentaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReporteService {

    private final VentaRepository ventaRepository;
    private final InventarioRepository inventarioRepository;
    private final ProductoRepository productoRepository;
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
    public List<ReporteStockDTO> reporteStock() {
        int diasAlerta = parametroService.getValorAsInteger("DIAS_ALERTA_VENCIMIENTO");
        LocalDate fechaAlerta = LocalDate.now().plusDays(diasAlerta);

        return inventarioRepository.findAll().stream()
                .collect(Collectors.groupingBy(i -> i.getLote().getProducto().getId()))
                .entrySet().stream()
                .map(entry -> {
                    List<Inventario> invs = entry.getValue();
                    int stockTotal = invs.stream().mapToInt(Inventario::getStockActual).sum();
                    int stockMin = invs.stream().mapToInt(Inventario::getStockMinimo).max().orElse(0);
                    long lotesProximos = invs.stream()
                            .filter(i -> !i.getLote().getFechaVencimiento().isAfter(fechaAlerta))
                            .count();
                    var producto = invs.get(0).getLote().getProducto();
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

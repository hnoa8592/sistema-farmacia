package com.tecnoa.pos.modules.reportes.service;

import com.tecnoa.pos.modules.inventario.model.Inventario;
import com.tecnoa.pos.modules.inventario.repository.InventarioRepository;
import com.tecnoa.pos.modules.inventario.repository.ProductoRepository;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.modules.reportes.dto.ReporteStockDTO;
import com.tecnoa.pos.modules.reportes.dto.ReporteVentasDTO;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.repository.VentaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReporteService {

    private final VentaRepository ventaRepository;
    private final InventarioRepository inventarioRepository;
    private final ProductoRepository productoRepository;
    private final ParametroService parametroService;

    public ReporteVentasDTO reporteVentas(LocalDateTime desde, LocalDateTime hasta) {
        var ventas = ventaRepository.findByFechaBetween(desde, hasta, PageRequest.of(0, Integer.MAX_VALUE));
        long totalVentas = ventas.stream().filter(v -> v.getEstado() == EstadoVenta.COMPLETADA).count();
        long anuladas = ventas.stream().filter(v -> v.getEstado() == EstadoVenta.ANULADA).count();
        BigDecimal monto = ventas.stream()
                .filter(v -> v.getEstado() == EstadoVenta.COMPLETADA)
                .map(v -> v.getTotal())
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return ReporteVentasDTO.builder()
                .desde(desde).hasta(hasta)
                .totalVentas(totalVentas)
                .montoTotal(monto)
                .ventasAnuladas(anuladas)
                .build();
    }

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
                            .bajoPStock(stockTotal <= stockMin)
                            .lotesProximosVencer(lotesProximos)
                            .build();
                })
                .collect(Collectors.toList());
    }
}

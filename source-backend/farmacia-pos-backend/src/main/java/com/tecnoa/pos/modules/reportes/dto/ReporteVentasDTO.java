package com.tecnoa.pos.modules.reportes.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ReporteVentasDTO {
    private LocalDateTime desde;
    private LocalDateTime hasta;
    private Long cantidadVentas;
    private BigDecimal totalVendido;
    private Long ventasAnuladas;
    private List<VentaPorDia> ventasPorDia;
    private List<VentaResumen> ultimasVentas;

    @Data @Builder @NoArgsConstructor @AllArgsConstructor
    public static class VentaPorDia {
        private String fecha;            // "yyyy-MM-dd"
        private Long cantidadVentas;
        private BigDecimal totalVendido;
    }

    @Data @Builder @NoArgsConstructor @AllArgsConstructor
    public static class VentaResumen {
        private UUID id;
        private LocalDateTime fecha;
        private BigDecimal total;
        private String estado;
    }
}

package com.tecnoa.pos.modules.reportes.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data @Builder
public class ReporteVentasDTO {
    private LocalDateTime desde;
    private LocalDateTime hasta;
    private Long totalVentas;
    private BigDecimal montoTotal;
    private Long ventasAnuladas;
}

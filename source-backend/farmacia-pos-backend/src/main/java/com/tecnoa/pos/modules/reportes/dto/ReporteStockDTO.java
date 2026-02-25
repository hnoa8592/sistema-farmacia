package com.tecnoa.pos.modules.reportes.dto;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data @Builder
public class ReporteStockDTO {
    private UUID productoId;
    private String productoNombre;
    private String codigo;
    private Integer stockTotal;
    private Integer stockMinimo;
    private Boolean bajoStock;
    private Long lotesProximosVencer;
}

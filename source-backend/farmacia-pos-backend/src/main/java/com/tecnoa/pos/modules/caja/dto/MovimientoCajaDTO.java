package com.tecnoa.pos.modules.caja.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Data @Builder
public class MovimientoCajaDTO {
    private UUID id;
    private String tipo;
    private BigDecimal monto;
    private String descripcion;
    private LocalDateTime fecha;
    private UUID usuarioId;
}

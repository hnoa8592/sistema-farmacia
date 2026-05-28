package com.tecnoa.pos.modules.caja.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.util.UUID;

@Data @Builder
public class VentaCajeroDTO {
    private UUID usuarioId;
    private String nombreUsuario;
    private Long cantidadVentas;
    private BigDecimal totalVentas;
}

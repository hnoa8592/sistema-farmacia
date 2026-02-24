package com.tecnoa.pos.modules.ventas.dto;

import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data @Builder
public class VentaResponseDTO {
    private UUID id;
    private LocalDateTime fecha;
    private BigDecimal total;
    private BigDecimal descuento;
    private UUID usuarioId;
    private EstadoVenta estado;
    private List<DetalleVentaDTO> detalles;
}

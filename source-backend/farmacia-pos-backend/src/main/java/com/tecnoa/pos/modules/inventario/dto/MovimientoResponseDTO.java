package com.tecnoa.pos.modules.inventario.dto;

import com.tecnoa.pos.modules.inventario.model.TipoMovimiento;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data @Builder
public class MovimientoResponseDTO {
    private UUID id;
    private UUID inventarioId;
    private UUID loteId;
    private UUID productoId;
    private String productoNombre;
    private UUID sucursalId;
    private String sucursalNombre;
    private TipoMovimiento tipo;
    private Integer cantidad;
    private Integer stockAnterior;
    private Integer stockResultante;
    private LocalDateTime fecha;
    private UUID usuarioId;
    private String observacion;
}

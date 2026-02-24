package com.tecnoa.pos.modules.inventario.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class MovimientoRequestDTO {
    @NotNull(message = "El inventarioId es requerido")
    private UUID inventarioId;

    @NotNull(message = "La cantidad es requerida")
    @Min(value = 1, message = "La cantidad debe ser mayor a 0")
    private Integer cantidad;

    private String observacion;

    // Para ajuste
    private Integer stockNuevo;

    // Para transferencia
    private UUID sucursalDestinoId;
}

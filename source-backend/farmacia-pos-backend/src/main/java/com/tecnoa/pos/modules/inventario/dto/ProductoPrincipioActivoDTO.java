package com.tecnoa.pos.modules.inventario.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ProductoPrincipioActivoDTO {
    private UUID id;
    @NotNull(message = "El principio activo es requerido")
    private UUID principioActivoId;
    private String principioActivoNombre;
    private String concentracion;
}

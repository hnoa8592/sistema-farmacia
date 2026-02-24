package com.tecnoa.pos.modules.inventario.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CatalogoDTO {
    private UUID id;

    @NotBlank(message = "El nombre es requerido")
    private String nombre;

    private String descripcion;
    private Boolean activo;
}

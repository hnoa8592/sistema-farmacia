package com.tecnoa.pos.modules.tenant.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class TenantRequestDTO {
    @NotBlank(message = "El nombre es requerido")
    private String nombre;

    @NotBlank(message = "El schemaName es requerido")
    @Pattern(regexp = "^[a-z0-9_]+$",
             message = "El schemaName solo puede contener letras minúsculas, números y guiones bajos")
    private String schemaName;
}

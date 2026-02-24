package com.tecnoa.pos.modules.parametros.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ParametroRequestDTO {
    @NotBlank(message = "El valor es requerido")
    private String valor;
}

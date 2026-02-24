package com.tecnoa.pos.modules.usuarios.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
public class PerfilRequestDTO {
    @NotBlank(message = "El nombre del perfil es requerido")
    private String nombre;

    private String descripcion;

    private List<UUID> recursoIds;
}

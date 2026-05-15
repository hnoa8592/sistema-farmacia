package com.tecnoa.pos.modules.usuarios.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
public class UsuarioRequestDTO {
    @NotBlank(message = "El nombre es requerido")
    private String nombre;

    @NotBlank(message = "El email es requerido")
    @Email(message = "El email no es valido")
    private String email;

    @Size(min = 8, message = "La contrasena debe tener al menos 8 caracteres")
    private String password;

    private List<UUID> perfilIds;
}

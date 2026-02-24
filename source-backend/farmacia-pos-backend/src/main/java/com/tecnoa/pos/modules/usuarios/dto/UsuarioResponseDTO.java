package com.tecnoa.pos.modules.usuarios.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class UsuarioResponseDTO {
    private UUID id;
    private String nombre;
    private String email;
    private Boolean activo;
    private LocalDateTime createdAt;
    private List<PerfilResponseDTO> perfiles;
}

package com.tecnoa.pos.modules.usuarios.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
@Builder
public class PerfilResponseDTO {
    private UUID id;
    private String nombre;
    private String descripcion;
    private List<RecursoDTO> recursos;

    @Data
    @Builder
    public static class RecursoDTO {
        private UUID id;
        private String nombre;
        private String modulo;
    }
}

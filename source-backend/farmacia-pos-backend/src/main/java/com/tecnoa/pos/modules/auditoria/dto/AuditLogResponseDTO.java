package com.tecnoa.pos.modules.auditoria.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class AuditLogResponseDTO {
    private UUID id;
    private UUID usuarioId;
    private String usuarioEmail;
    private String accion;
    private String modulo;
    private String entidad;
    private String entidadId;
    private String valorAnterior;
    private String valorNuevo;
    private String descripcion;
    private String ipOrigen;
    private LocalDateTime fecha;
    private Boolean exitoso;
}

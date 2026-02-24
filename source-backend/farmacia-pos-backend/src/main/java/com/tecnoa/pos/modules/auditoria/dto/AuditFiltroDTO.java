package com.tecnoa.pos.modules.auditoria.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class AuditFiltroDTO {
    private UUID usuarioId;
    private String modulo;
    private String entidad;
    private String accion;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime desde;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime hasta;
}

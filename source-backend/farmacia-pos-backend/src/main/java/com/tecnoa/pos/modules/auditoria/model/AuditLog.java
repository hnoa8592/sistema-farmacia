package com.tecnoa.pos.modules.auditoria.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "audit_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "usuario_id")
    private UUID usuarioId;

    @Column(name = "usuario_email", length = 200)
    private String usuarioEmail;

    @Column(nullable = false, length = 50)
    private String accion;

    @Column(nullable = false, length = 100)
    private String modulo;

    @Column(nullable = false, length = 100)
    private String entidad;

    @Column(name = "entidad_id", length = 100)
    private String entidadId;

    @Column(name = "valor_anterior", columnDefinition = "TEXT")
    private String valorAnterior;

    @Column(name = "valor_nuevo", columnDefinition = "TEXT")
    private String valorNuevo;

    @Column(nullable = false, length = 500)
    private String descripcion;

    @Column(name = "ip_origen", length = 100)
    private String ipOrigen;

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    @Column(nullable = false)
    private LocalDateTime fecha;

    @Column(nullable = false)
    @Builder.Default
    private Boolean exitoso = true;

    @PrePersist
    void prePersist() {
        if (fecha == null) fecha = LocalDateTime.now();
    }
}

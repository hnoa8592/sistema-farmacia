package com.tecnoa.pos.modules.parametros.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "parametros")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Parametro {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(unique = true, nullable = false, length = 100)
    private String clave;

    @Column(nullable = false, length = 500)
    private String valor;

    @Column(length = 500)
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TipoParametro tipo;

    @Column(nullable = false, length = 50)
    private String modulo;

    @Column(nullable = false)
    @Builder.Default
    private Boolean editable = true;

    @Column(nullable = false)
    @Builder.Default
    private Boolean activo = true;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "updated_by", length = 200)
    private String updatedBy;
}

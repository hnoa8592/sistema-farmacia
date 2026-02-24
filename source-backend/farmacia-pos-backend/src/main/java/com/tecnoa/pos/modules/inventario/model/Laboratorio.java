package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "laboratorios")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class Laboratorio {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 200)
    private String nombre;

    @Column(length = 100)
    private String pais;

    @Column(length = 500)
    private String direccion;

    @Column(length = 50)
    private String telefono;

    @Column(length = 200)
    private String email;

    @Column(nullable = false) @Builder.Default
    private Boolean activo = true;
}

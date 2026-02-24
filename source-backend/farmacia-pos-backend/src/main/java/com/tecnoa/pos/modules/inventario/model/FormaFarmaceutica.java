package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "formas_farmaceuticas")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class FormaFarmaceutica {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(unique = true, nullable = false, length = 200)
    private String nombre;

    @Column(length = 500)
    private String descripcion;

    @Column(nullable = false) @Builder.Default
    private Boolean activo = true;
}

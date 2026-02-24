package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "sucursales")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class Sucursal {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 200)
    private String nombre;

    @Column(length = 500)
    private String direccion;

    @Column(length = 50)
    private String telefono;

    @Column(name = "es_matriz", nullable = false) @Builder.Default
    private Boolean esMatriz = false;

    @Column(nullable = false) @Builder.Default
    private Boolean activo = true;
}

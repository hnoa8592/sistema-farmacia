package com.tecnoa.pos.modules.usuarios.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "recursos")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Recurso {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(unique = true, nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 50)
    private String modulo;
}

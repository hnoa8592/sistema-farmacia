package com.tecnoa.pos.modules.usuarios.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "perfiles")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
@ToString(exclude = {"recursos", "usuarios"})
public class Perfil {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 255)
    private String descripcion;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "perfil_recursos",
        joinColumns = @JoinColumn(name = "perfil_id"),
        inverseJoinColumns = @JoinColumn(name = "recurso_id")
    )
    @Builder.Default
    private Set<Recurso> recursos = new HashSet<>();

    @ManyToMany(mappedBy = "perfiles")
    @Builder.Default
    private Set<Usuario> usuarios = new HashSet<>();
}

package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "producto_principios_activos",
       uniqueConstraints = @UniqueConstraint(columnNames = {"producto_id", "principio_activo_id"}))
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ProductoPrincipioActivo {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "producto_id", nullable = false)
    private Producto producto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "principio_activo_id", nullable = false)
    private PrincipioActivo principioActivo;

    @Column(length = 100)
    private String concentracion;
}

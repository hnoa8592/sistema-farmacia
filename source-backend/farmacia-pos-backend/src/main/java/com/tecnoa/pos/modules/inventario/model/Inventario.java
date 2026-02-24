package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "inventario",
       uniqueConstraints = @UniqueConstraint(columnNames = {"lote_id", "sucursal_id"}))
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class Inventario {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lote_id", nullable = false)
    private ProductoLote lote;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sucursal_id", nullable = false)
    private Sucursal sucursal;

    @Column(name = "stock_actual", nullable = false) @Builder.Default
    private Integer stockActual = 0;

    @Column(name = "stock_minimo", nullable = false) @Builder.Default
    private Integer stockMinimo = 5;

    @Column(length = 200)
    private String ubicacion;
}

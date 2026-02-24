package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "movimientos_inventario")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class MovimientoInventario {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inventario_id", nullable = false)
    private Inventario inventario;

    @Column(name = "lote_id", nullable = false)
    private UUID loteId;

    @Column(name = "producto_id", nullable = false)
    private UUID productoId;

    @Column(name = "sucursal_id", nullable = false)
    private UUID sucursalId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TipoMovimiento tipo;

    @Column(nullable = false)
    private Integer cantidad;

    @Column(name = "stock_anterior", nullable = false)
    private Integer stockAnterior;

    @Column(name = "stock_resultante", nullable = false)
    private Integer stockResultante;

    @Column(nullable = false)
    private LocalDateTime fecha;

    @Column(name = "usuario_id")
    private UUID usuarioId;

    @Column(length = 500)
    private String observacion;

    @PrePersist
    void prePersist() {
        if (fecha == null) fecha = LocalDateTime.now();
    }
}

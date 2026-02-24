package com.tecnoa.pos.modules.ventas.model;

import com.tecnoa.pos.modules.inventario.model.TipoPrecio;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "detalle_ventas")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class DetalleVenta {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "venta_id", nullable = false)
    private Venta venta;

    @Column(name = "producto_id", nullable = false)
    private UUID productoId;

    @Column(name = "lote_id", nullable = false)
    private UUID loteId;

    @Column(name = "inventario_id", nullable = false)
    private UUID inventarioId;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_precio", nullable = false, length = 20)
    private TipoPrecio tipoPrecio;

    @Column(nullable = false)
    private Integer cantidad;

    @Column(name = "precio_unitario", nullable = false, precision = 10, scale = 2)
    private BigDecimal precioUnitario;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal subtotal;
}

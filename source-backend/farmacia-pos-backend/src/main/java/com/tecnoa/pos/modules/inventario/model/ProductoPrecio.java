package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "producto_precios")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ProductoPrecio {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "producto_id", nullable = false)
    private Producto producto;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_precio", nullable = false, length = 20)
    private TipoPrecio tipoPrecio;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal precio;

    @Column(name = "precio_compra", precision = 10, scale = 2)
    private BigDecimal precioCompra;

    @Column(name = "vigencia_desde", nullable = false)
    private LocalDateTime vigenciaDesde;

    @Column(name = "vigencia_hasta")
    private LocalDateTime vigenciaHasta;

    @Column(nullable = false) @Builder.Default
    private Boolean activo = true;
}

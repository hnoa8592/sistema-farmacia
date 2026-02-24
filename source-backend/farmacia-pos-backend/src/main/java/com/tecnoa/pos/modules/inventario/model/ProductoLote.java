package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "producto_lotes",
       uniqueConstraints = @UniqueConstraint(columnNames = {"producto_id", "numero_lote"}))
@Data @Builder @NoArgsConstructor @AllArgsConstructor
@EqualsAndHashCode(of = "id")
@ToString(exclude = "inventarios")
public class ProductoLote {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "producto_id", nullable = false)
    private Producto producto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "laboratorio_id", nullable = false)
    private Laboratorio laboratorio;

    @Column(name = "numero_lote", nullable = false, length = 100)
    private String numeroLote;

    @Column(name = "fecha_fabricacion")
    private LocalDate fechaFabricacion;

    @Column(name = "fecha_vencimiento", nullable = false)
    private LocalDate fechaVencimiento;

    @Column(name = "cantidad_inicial", nullable = false)
    private Integer cantidadInicial;

    @Column(nullable = false) @Builder.Default
    private Boolean activo = true;

    @OneToMany(mappedBy = "lote", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Inventario> inventarios = new ArrayList<>();
}

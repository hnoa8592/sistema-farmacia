package com.tecnoa.pos.modules.inventario.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "productos")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
@EqualsAndHashCode(of = "id")
@ToString(exclude = {"principiosActivos", "lotes", "precios"})
public class Producto {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 300)
    private String nombre;

    @Column(name = "nombre_comercial", length = 300)
    private String nombreComercial;

    @Column(unique = true, nullable = false, length = 100)
    private String codigo;

    @Column(name = "codigo_barra", length = 100)
    private String codigoBarra;

    @Column(length = 1000)
    private String descripcion;

    @Column(length = 100)
    private String concentracion;

    @Column(length = 200)
    private String presentacion;

    @Column(name = "requiere_receta", nullable = false) @Builder.Default
    private Boolean requiereReceta = false;

    @Column(nullable = false) @Builder.Default
    private Boolean controlado = false;

    @Column(nullable = false) @Builder.Default
    private Boolean activo = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id")
    private CategoriaTerapeutica categoria;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "forma_farmaceutica_id")
    private FormaFarmaceutica formaFarmaceutica;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "via_administracion_id")
    private ViaAdministracion viaAdministracion;

    @OneToMany(mappedBy = "producto", cascade = CascadeType.ALL)
    @Builder.Default
    private List<ProductoPrincipioActivo> principiosActivos = new ArrayList<>();

    @OneToMany(mappedBy = "producto", cascade = CascadeType.ALL)
    @Builder.Default
    private List<ProductoLote> lotes = new ArrayList<>();

    @OneToMany(mappedBy = "producto", cascade = CascadeType.ALL)
    @Builder.Default
    private List<ProductoPrecio> precios = new ArrayList<>();
}

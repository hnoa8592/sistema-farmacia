package com.tecnoa.pos.modules.inventario.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data @Builder
public class ProductoResponseDTO {
    private UUID id;
    private String nombre;
    private String nombreComercial;
    private String codigo;
    private String codigoBarra;
    private String descripcion;
    private String concentracion;
    private String presentacion;
    private Boolean requiereReceta;
    private Boolean controlado;
    private Boolean activo;
    private CatalogoDTO categoria;
    private CatalogoDTO formaFarmaceutica;
    private CatalogoDTO viaAdministracion;
    private List<ProductoPrincipioActivoDTO> principiosActivos;
    private List<ProductoPrecioDTO> precios;
}

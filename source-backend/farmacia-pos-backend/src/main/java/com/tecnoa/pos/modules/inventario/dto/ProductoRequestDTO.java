package com.tecnoa.pos.modules.inventario.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.UUID;

@Data
public class ProductoRequestDTO {
    @NotBlank(message = "El nombre es requerido")
    private String nombre;
    private String nombreComercial;
    @NotBlank(message = "El código es requerido")
    private String codigo;
    private String codigoBarra;
    private String descripcion;
    private String concentracion;
    private String presentacion;
    private Boolean requiereReceta;
    private Boolean controlado;
    private UUID categoriaId;
    private UUID formaFarmaceuticaId;
    private UUID viaAdministracionId;
}

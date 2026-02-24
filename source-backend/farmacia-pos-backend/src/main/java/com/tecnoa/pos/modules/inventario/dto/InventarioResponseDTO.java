package com.tecnoa.pos.modules.inventario.dto;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data @Builder
public class InventarioResponseDTO {
    private UUID id;
    private UUID loteId;
    private String numeroLote;
    private UUID sucursalId;
    private String sucursalNombre;
    private Integer stockActual;
    private Integer stockMinimo;
    private String ubicacion;
    private Boolean bajoPStock;
}

package com.tecnoa.pos.modules.inventario.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data @Builder
public class InventarioResponseDTO {
    private UUID id;
    private UUID loteId;
    private String numeroLote;
    private LocalDate fechaVencimiento;
    private UUID sucursalId;
    private String sucursalNombre;
    private UUID productoId;
    private String productoNombre;
    private Integer stockActual;
    private Integer stockMinimo;
    private String ubicacion;
    private Boolean bajoStock;
    private List<ProductoPrecioDTO> precios;
}

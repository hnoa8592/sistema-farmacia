package com.tecnoa.pos.modules.inventario.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data @Builder
public class ProductoLoteResponseDTO {
    private UUID id;
    private UUID productoId;
    private String productoNombre;
    private UUID laboratorioId;
    private String laboratorioNombre;
    private String numeroLote;
    private LocalDate fechaFabricacion;
    private LocalDate fechaVencimiento;
    private Integer cantidadInicial;
    private Boolean activo;
    private List<InventarioResponseDTO> inventarios;
}

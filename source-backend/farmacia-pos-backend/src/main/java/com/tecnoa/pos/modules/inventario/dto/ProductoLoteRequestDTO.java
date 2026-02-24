package com.tecnoa.pos.modules.inventario.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
public class ProductoLoteRequestDTO {
    @NotNull(message = "El laboratorio es requerido")
    private UUID laboratorioId;

    @NotBlank(message = "El número de lote es requerido")
    private String numeroLote;

    private LocalDate fechaFabricacion;

    @NotNull(message = "La fecha de vencimiento es requerida")
    private LocalDate fechaVencimiento;

    @NotNull(message = "La cantidad inicial es requerida")
    private Integer cantidadInicial;

    private UUID sucursalId;
}

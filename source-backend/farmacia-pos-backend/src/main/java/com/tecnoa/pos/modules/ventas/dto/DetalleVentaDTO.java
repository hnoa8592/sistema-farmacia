package com.tecnoa.pos.modules.ventas.dto;

import com.tecnoa.pos.modules.inventario.model.TipoPrecio;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class DetalleVentaDTO {
    private UUID id;

    @NotNull(message = "El inventarioId es requerido")
    private UUID inventarioId;

    private UUID productoId;
    private UUID loteId;

    @NotNull(message = "El tipo de precio es requerido")
    private TipoPrecio tipoPrecio;

    @NotNull(message = "La cantidad es requerida")
    @Min(value = 1, message = "La cantidad debe ser mayor a 0")
    private Integer cantidad;

    private BigDecimal precioUnitario;
    private BigDecimal subtotal;
}

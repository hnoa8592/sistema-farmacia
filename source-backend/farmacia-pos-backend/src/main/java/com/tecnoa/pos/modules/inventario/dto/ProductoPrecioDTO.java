package com.tecnoa.pos.modules.inventario.dto;

import com.tecnoa.pos.modules.inventario.model.TipoPrecio;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ProductoPrecioDTO {
    private UUID id;
    @NotNull(message = "El tipo de precio es requerido")
    private TipoPrecio tipoPrecio;
    @NotNull(message = "El precio es requerido")
    private BigDecimal precio;
    private BigDecimal precioCompra;
    private LocalDateTime vigenciaDesde;
    private LocalDateTime vigenciaHasta;
    private Boolean activo;
}

package com.tecnoa.pos.modules.caja.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class CierreCajaRequestDTO {

    @NotNull(message = "El monto contado es requerido")
    @DecimalMin(value = "0.00", inclusive = true, message = "El monto contado no puede ser negativo")
    private BigDecimal montoContado;

    private String observacion;
}

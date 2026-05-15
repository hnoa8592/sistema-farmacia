package com.tecnoa.pos.modules.caja.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.UUID;

@Data
public class AperturaCajaRequestDTO {

    @NotNull(message = "La sucursal es requerida")
    private UUID sucursalId;

    @NotNull(message = "El monto de apertura es requerido")
    @DecimalMin(value = "0.00", inclusive = true, message = "El monto de apertura no puede ser negativo")
    private BigDecimal montoApertura;
}

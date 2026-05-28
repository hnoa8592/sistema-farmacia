package com.tecnoa.pos.modules.caja.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data @Builder
public class ReporteCierreCajaDTO {
    private UUID cajaId;
    private UUID sucursalId;
    private String nombreCajero;
    private LocalDateTime fechaApertura;
    private LocalDateTime fechaCierre;

    private BigDecimal montoApertura;

    private BigDecimal totalVentas;
    private Long cantidadVentas;
    private List<VentaCajeroDTO> ventasPorCajero;

    private BigDecimal totalRetiros;
    private List<MovimientoCajaDTO> retiros;

    private BigDecimal totalIngresosManuales;
    private List<MovimientoCajaDTO> ingresosManuales;

    private BigDecimal efectivoEsperado;
    private BigDecimal montoContado;
    private BigDecimal diferencia;
    private String estadoDiferencia;

    private String observacion;
    private String estadoCaja;
}

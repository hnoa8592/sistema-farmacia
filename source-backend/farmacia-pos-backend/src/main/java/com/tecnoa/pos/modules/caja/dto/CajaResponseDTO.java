package com.tecnoa.pos.modules.caja.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data @Builder
public class CajaResponseDTO {
    private UUID id;
    private UUID sucursalId;
    private UUID usuarioId;
    private String nombreUsuario;
    private LocalDateTime fechaApertura;
    private BigDecimal montoApertura;
    private LocalDateTime fechaCierre;
    private BigDecimal montoContado;
    private BigDecimal efectivoEsperado;
    private BigDecimal diferencia;
    private String observacion;
    private String estado;
    private List<MovimientoCajaDTO> movimientos;
}

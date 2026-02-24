package com.tecnoa.pos.modules.parametros.dto;

import com.tecnoa.pos.modules.parametros.model.TipoParametro;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class ParametroResponseDTO {
    private UUID id;
    private String clave;
    private String valor;
    private String descripcion;
    private TipoParametro tipo;
    private String modulo;
    private Boolean editable;
    private Boolean activo;
    private LocalDateTime updatedAt;
    private String updatedBy;
}

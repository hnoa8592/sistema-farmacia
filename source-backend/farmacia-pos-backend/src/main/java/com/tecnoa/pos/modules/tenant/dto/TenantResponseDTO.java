package com.tecnoa.pos.modules.tenant.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class TenantResponseDTO {
    private UUID id;
    private String nombre;
    private String schemaName;
    private Boolean activo;
    private LocalDateTime createdAt;
}

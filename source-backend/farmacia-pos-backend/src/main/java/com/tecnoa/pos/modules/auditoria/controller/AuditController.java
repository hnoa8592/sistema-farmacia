package com.tecnoa.pos.modules.auditoria.controller;

import com.tecnoa.pos.modules.auditoria.dto.AuditFiltroDTO;
import com.tecnoa.pos.modules.auditoria.dto.AuditLogResponseDTO;
import com.tecnoa.pos.modules.auditoria.model.AuditLog;
import com.tecnoa.pos.modules.auditoria.repository.AuditLogRepository;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/auditoria")
@RequiredArgsConstructor
@Tag(name = "Auditoría", description = "Consulta de logs de auditoría")
public class AuditController {

    private final AuditLogRepository auditLogRepository;

    @GetMapping
    @PreAuthorize("hasAuthority('auditoria:ver')")
    @Operation(summary = "Listar logs de auditoría con filtros")
    public ResponseEntity<ApiResponse<Page<AuditLogResponseDTO>>> listar(
            AuditFiltroDTO filtro, Pageable pageable) {
        Page<AuditLog> page = auditLogRepository.findByFiltros(
                filtro.getUsuarioId(), filtro.getModulo(), filtro.getEntidad(),
                filtro.getAccion(), filtro.getDesde(), filtro.getHasta(), pageable);
        return ResponseEntity.ok(ApiResponse.success(page.map(this::toResponse), "Logs obtenidos"));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('auditoria:ver')")
    @Operation(summary = "Obtener detalle de un log")
    public ResponseEntity<ApiResponse<AuditLogResponseDTO>> obtener(@PathVariable UUID id) {
        AuditLog log = auditLogRepository.findById(id)
                .orElseThrow(() -> new com.tecnoa.pos.shared.exception.ResourceNotFoundException("AuditLog", id));
        return ResponseEntity.ok(ApiResponse.success(toResponse(log), "Log obtenido"));
    }

    @GetMapping("/entidad/{entidad}/{entidadId}")
    @PreAuthorize("hasAuthority('auditoria:ver')")
    @Operation(summary = "Historial de un registro específico")
    public ResponseEntity<ApiResponse<List<AuditLogResponseDTO>>> historialEntidad(
            @PathVariable String entidad, @PathVariable String entidadId) {
        List<AuditLogResponseDTO> logs = auditLogRepository
                .findByEntidadAndEntidadIdOrderByFechaDesc(entidad, entidadId)
                .stream().map(this::toResponse).collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(logs, "Historial obtenido"));
    }

    @GetMapping("/usuario/{usuarioId}")
    @PreAuthorize("hasAuthority('auditoria:ver')")
    @Operation(summary = "Actividad de un usuario")
    public ResponseEntity<ApiResponse<Page<AuditLogResponseDTO>>> actividadUsuario(
            @PathVariable UUID usuarioId, Pageable pageable) {
        Page<AuditLogResponseDTO> page = auditLogRepository
                .findByUsuarioIdOrderByFechaDesc(usuarioId, pageable)
                .map(this::toResponse);
        return ResponseEntity.ok(ApiResponse.success(page, "Actividad obtenida"));
    }

    @GetMapping("/resumen")
    @PreAuthorize("hasAuthority('auditoria:ver')")
    @Operation(summary = "Resumen de acciones por módulo (dashboard)")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> resumen(AuditFiltroDTO filtro) {
        List<Object[]> raw = auditLogRepository.findResumenByFechas(filtro.getDesde(), filtro.getHasta());
        List<Map<String, Object>> result = raw.stream().map(row -> {
            Map<String, Object> m = new HashMap<>();
            m.put("modulo", row[0]);
            m.put("accion", row[1]);
            m.put("total", row[2]);
            return m;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(result, "Resumen obtenido"));
    }

    private AuditLogResponseDTO toResponse(AuditLog a) {
        return AuditLogResponseDTO.builder()
                .id(a.getId())
                .usuarioId(a.getUsuarioId())
                .usuarioEmail(a.getUsuarioEmail())
                .accion(a.getAccion())
                .modulo(a.getModulo())
                .entidad(a.getEntidad())
                .entidadId(a.getEntidadId())
                .valorAnterior(a.getValorAnterior())
                .valorNuevo(a.getValorNuevo())
                .descripcion(a.getDescripcion())
                .ipOrigen(a.getIpOrigen())
                .fecha(a.getFecha())
                .exitoso(a.getExitoso())
                .build();
    }
}

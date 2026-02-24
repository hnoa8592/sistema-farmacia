package com.tecnoa.pos.modules.tenant;

import com.tecnoa.pos.modules.tenant.dto.TenantRequestDTO;
import com.tecnoa.pos.modules.tenant.dto.TenantResponseDTO;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/admin/tenants")
@RequiredArgsConstructor
@Tag(name = "Tenants", description = "Administración de tenants (super-admin)")
public class TenantController {

    private final TenantService tenantService;

    @GetMapping
    @Operation(summary = "Listar todos los tenants")
    public ResponseEntity<ApiResponse<List<TenantResponseDTO>>> listar() {
        return ResponseEntity.ok(ApiResponse.success(tenantService.listar(), "Tenants obtenidos"));
    }

    @PostMapping
    @Operation(summary = "Crear nuevo tenant e inicializar su schema")
    public ResponseEntity<ApiResponse<TenantResponseDTO>> crear(
            @Valid @RequestBody TenantRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(tenantService.crear(dto), "Tenant creado exitosamente"));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar tenant")
    public ResponseEntity<ApiResponse<TenantResponseDTO>> actualizar(
            @PathVariable UUID id, @Valid @RequestBody TenantRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(tenantService.actualizar(id, dto), "Tenant actualizado"));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Desactivar tenant (soft delete)")
    public ResponseEntity<ApiResponse<Void>> desactivar(@PathVariable UUID id) {
        tenantService.desactivar(id);
        return ResponseEntity.ok(ApiResponse.success("Tenant desactivado"));
    }
}

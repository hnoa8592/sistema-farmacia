package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.SucursalDTO;
import com.tecnoa.pos.modules.inventario.service.InventarioService;
import com.tecnoa.pos.modules.inventario.service.SucursalService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/sucursales")
@RequiredArgsConstructor
@Tag(name = "Sucursales", description = "Gestión de sucursales")
public class SucursalController {

    private final SucursalService sucursalService;
    private final InventarioService inventarioService;

    @GetMapping
    @PreAuthorize("hasAuthority('sucursales:ver')")
    public ResponseEntity<ApiResponse<List<SucursalDTO>>> listar() {
        return ResponseEntity.ok(ApiResponse.success(sucursalService.listar(), "Sucursales obtenidas"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('sucursales:editar')")
    public ResponseEntity<ApiResponse<SucursalDTO>> crear(@Valid @RequestBody SucursalDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(sucursalService.crear(dto), "Sucursal creada"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('sucursales:editar')")
    public ResponseEntity<ApiResponse<SucursalDTO>> actualizar(
            @PathVariable UUID id, @Valid @RequestBody SucursalDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(sucursalService.actualizar(id, dto), "Sucursal actualizada"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('sucursales:editar')")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable UUID id) {
        sucursalService.eliminar(id);
        return ResponseEntity.ok(ApiResponse.success("Sucursal desactivada"));
    }

    @GetMapping("/{id}/inventario")
    @PreAuthorize("hasAuthority('inventario:ver')")
    public ResponseEntity<ApiResponse<List<InventarioResponseDTO>>> inventario(
            @RequestParam(required = false) UUID productoId,
            @RequestParam(required = false) UUID sucursalId,
            @RequestParam(required = false) UUID loteId,
            @RequestParam(required = false) Boolean soloConStock) {
        return ResponseEntity.ok(ApiResponse.success(
                inventarioService.getStock(productoId, sucursalId, loteId, null, soloConStock), "Inventario obtenido"));
    }
}

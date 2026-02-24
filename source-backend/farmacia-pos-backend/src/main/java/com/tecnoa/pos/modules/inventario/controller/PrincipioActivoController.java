package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.PrincipioActivoDTO;
import com.tecnoa.pos.modules.inventario.service.PrincipioActivoService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/principios-activos")
@RequiredArgsConstructor
@Tag(name = "Principios Activos", description = "Gestión de principios activos")
public class PrincipioActivoController {

    private final PrincipioActivoService service;

    @GetMapping
    @PreAuthorize("hasAuthority('principios-activos:ver')")
    public ResponseEntity<ApiResponse<Page<PrincipioActivoDTO>>> listar(
            @RequestParam(required = false) String nombre, Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(service.listar(nombre, pageable), "Principios activos obtenidos"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('principios-activos:editar')")
    public ResponseEntity<ApiResponse<PrincipioActivoDTO>> crear(@Valid @RequestBody PrincipioActivoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(service.crear(dto), "Principio activo creado"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('principios-activos:editar')")
    public ResponseEntity<ApiResponse<PrincipioActivoDTO>> actualizar(
            @PathVariable UUID id, @Valid @RequestBody PrincipioActivoDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(service.actualizar(id, dto), "Principio activo actualizado"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('principios-activos:editar')")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable UUID id) {
        service.eliminar(id);
        return ResponseEntity.ok(ApiResponse.success("Principio activo desactivado"));
    }
}

package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.LaboratorioDTO;
import com.tecnoa.pos.modules.inventario.service.LaboratorioService;
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
@RequestMapping("/laboratorios")
@RequiredArgsConstructor
@Tag(name = "Laboratorios", description = "Gestión de laboratorios fabricantes")
public class LaboratorioController {

    private final LaboratorioService service;

    @GetMapping
    @PreAuthorize("hasAuthority('laboratorios:ver')")
    public ResponseEntity<ApiResponse<Page<LaboratorioDTO>>> listar(
            @RequestParam(required = false) String nombre, Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(service.listar(nombre, pageable), "Laboratorios obtenidos"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('laboratorios:editar')")
    public ResponseEntity<ApiResponse<LaboratorioDTO>> crear(@Valid @RequestBody LaboratorioDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(service.crear(dto), "Laboratorio creado"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('laboratorios:editar')")
    public ResponseEntity<ApiResponse<LaboratorioDTO>> actualizar(
            @PathVariable UUID id, @Valid @RequestBody LaboratorioDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(service.actualizar(id, dto), "Laboratorio actualizado"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('laboratorios:editar')")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable UUID id) {
        service.eliminar(id);
        return ResponseEntity.ok(ApiResponse.success("Laboratorio desactivado"));
    }
}

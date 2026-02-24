package com.tecnoa.pos.modules.usuarios.controller;

import com.tecnoa.pos.modules.usuarios.dto.PerfilRequestDTO;
import com.tecnoa.pos.modules.usuarios.dto.PerfilResponseDTO;
import com.tecnoa.pos.modules.usuarios.service.PerfilService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
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
@RequestMapping("/perfiles")
@RequiredArgsConstructor
@Tag(name = "Perfiles", description = "Gestión de perfiles y recursos")
public class PerfilController {

    private final PerfilService perfilService;

    @GetMapping
    @PreAuthorize("hasAuthority('perfiles:ver')")
    @Operation(summary = "Listar perfiles")
    public ResponseEntity<ApiResponse<List<PerfilResponseDTO>>> listar() {
        return ResponseEntity.ok(ApiResponse.success(perfilService.listar(), "Perfiles obtenidos"));
    }

    @GetMapping("/recursos")
    @Operation(summary = "Listar todos los recursos disponibles")
    public ResponseEntity<ApiResponse<List<PerfilResponseDTO.RecursoDTO>>> listarRecursos() {
        return ResponseEntity.ok(ApiResponse.success(perfilService.listarRecursos(), "Recursos obtenidos"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('perfiles:crear')")
    @Operation(summary = "Crear perfil")
    public ResponseEntity<ApiResponse<PerfilResponseDTO>> crear(
            @Valid @RequestBody PerfilRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(perfilService.crear(dto), "Perfil creado exitosamente"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('perfiles:editar')")
    @Operation(summary = "Actualizar perfil")
    public ResponseEntity<ApiResponse<PerfilResponseDTO>> actualizar(
            @PathVariable UUID id, @Valid @RequestBody PerfilRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(perfilService.actualizar(id, dto), "Perfil actualizado"));
    }

    @PostMapping("/{id}/recursos")
    @PreAuthorize("hasAuthority('perfiles:editar')")
    @Operation(summary = "Asignar recursos al perfil")
    public ResponseEntity<ApiResponse<PerfilResponseDTO>> asignarRecursos(
            @PathVariable UUID id, @RequestBody List<UUID> recursoIds) {
        return ResponseEntity.ok(ApiResponse.success(
                perfilService.asignarRecursos(id, recursoIds), "Recursos asignados"));
    }
}

package com.tecnoa.pos.modules.usuarios.controller;

import com.tecnoa.pos.modules.usuarios.dto.UsuarioRequestDTO;
import com.tecnoa.pos.modules.usuarios.dto.UsuarioResponseDTO;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import com.tecnoa.pos.modules.usuarios.service.UsuarioService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/usuarios")
@RequiredArgsConstructor
@Tag(name = "Usuarios", description = "Gestión de usuarios del sistema")
public class UsuarioController {

    private final UsuarioService usuarioService;

    @GetMapping
    @PreAuthorize("hasAuthority('usuarios:ver')")
    @Operation(summary = "Listar usuarios paginado")
    public ResponseEntity<ApiResponse<Page<UsuarioResponseDTO>>> listar(Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(usuarioService.listar(pageable), "Usuarios obtenidos"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('usuarios:crear')")
    @Operation(summary = "Crear usuario")
    public ResponseEntity<ApiResponse<UsuarioResponseDTO>> crear(
            @Valid @RequestBody UsuarioRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(usuarioService.crear(dto), "Usuario creado exitosamente"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('usuarios:editar')")
    @Operation(summary = "Actualizar usuario")
    public ResponseEntity<ApiResponse<UsuarioResponseDTO>> actualizar(
            @PathVariable UUID id, @Valid @RequestBody UsuarioRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(usuarioService.actualizar(id, dto), "Usuario actualizado"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('usuarios:editar')")
    @Operation(summary = "Desactivar usuario (soft delete)")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable UUID id) {
        usuarioService.eliminar(id);
        return ResponseEntity.ok(ApiResponse.success("Usuario desactivado"));
    }

    @PostMapping("/{id}/perfiles")
    @PreAuthorize("hasAuthority('usuarios:editar')")
    @Operation(summary = "Asignar perfiles a usuario")
    public ResponseEntity<ApiResponse<UsuarioResponseDTO>> asignarPerfiles(
            @PathVariable UUID id, @RequestBody List<UUID> perfilIds) {
        return ResponseEntity.ok(ApiResponse.success(
                usuarioService.asignarPerfiles(id, perfilIds), "Perfiles asignados"));
    }
}

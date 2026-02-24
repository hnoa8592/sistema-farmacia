package com.tecnoa.pos.modules.parametros.controller;

import com.tecnoa.pos.modules.parametros.dto.ParametroRequestDTO;
import com.tecnoa.pos.modules.parametros.dto.ParametroResponseDTO;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/parametros")
@RequiredArgsConstructor
@Tag(name = "Parámetros", description = "Configuración del sistema por tenant")
public class ParametroController {

    private final ParametroService parametroService;

    @GetMapping
    @Operation(summary = "Listar todos los parámetros activos")
    public ResponseEntity<ApiResponse<List<ParametroResponseDTO>>> listar() {
        return ResponseEntity.ok(ApiResponse.success(parametroService.getAll(), "Parámetros obtenidos"));
    }

    @GetMapping("/modulo/{modulo}")
    @Operation(summary = "Listar parámetros de un módulo")
    public ResponseEntity<ApiResponse<List<ParametroResponseDTO>>> listarPorModulo(
            @PathVariable String modulo) {
        return ResponseEntity.ok(ApiResponse.success(
                parametroService.getByModulo(modulo), "Parámetros obtenidos"));
    }

    @GetMapping("/{clave}")
    @Operation(summary = "Obtener parámetro por clave")
    public ResponseEntity<ApiResponse<String>> obtener(@PathVariable String clave) {
        return ResponseEntity.ok(ApiResponse.success(parametroService.getValor(clave), "Parámetro obtenido"));
    }

    @PutMapping("/{clave}")
    @PreAuthorize("hasAuthority('parametros:editar')")
    @Operation(summary = "Actualizar valor de un parámetro")
    public ResponseEntity<ApiResponse<ParametroResponseDTO>> actualizar(
            @PathVariable String clave,
            @Valid @RequestBody ParametroRequestDTO dto,
            Authentication auth) {
        String email = auth != null ? auth.getName() : "sistema";
        return ResponseEntity.ok(ApiResponse.success(
                parametroService.actualizar(clave, dto.getValor(), email), "Parámetro actualizado"));
    }
}

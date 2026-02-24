package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.ProductoLoteRequestDTO;
import com.tecnoa.pos.modules.inventario.dto.ProductoLoteResponseDTO;
import com.tecnoa.pos.modules.inventario.service.ProductoLoteService;
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
@RequestMapping("/productos/{productoId}/lotes")
@RequiredArgsConstructor
@Tag(name = "Lotes de Producto", description = "Gestión de lotes por producto")
public class ProductoLoteController {

    private final ProductoLoteService loteService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<ProductoLoteResponseDTO>>> listar(@PathVariable UUID productoId) {
        return ResponseEntity.ok(ApiResponse.success(loteService.listarPorProducto(productoId), "Lotes obtenidos"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('inventario:lotes')")
    public ResponseEntity<ApiResponse<ProductoLoteResponseDTO>> crear(
            @PathVariable UUID productoId, @Valid @RequestBody ProductoLoteRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(loteService.crear(productoId, dto), "Lote registrado"));
    }

    @PutMapping("/{loteId}")
    @PreAuthorize("hasAuthority('inventario:lotes')")
    public ResponseEntity<ApiResponse<ProductoLoteResponseDTO>> actualizar(
            @PathVariable UUID productoId, @PathVariable UUID loteId,
            @Valid @RequestBody ProductoLoteRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(loteService.actualizar(loteId, dto), "Lote actualizado"));
    }

    @GetMapping("/proximos-vencer")
    public ResponseEntity<ApiResponse<List<ProductoLoteResponseDTO>>> proximosVencer(@PathVariable UUID productoId) {
        return ResponseEntity.ok(ApiResponse.success(loteService.listarProximosVencer(productoId), "Lotes próximos a vencer"));
    }

    @GetMapping("/vencidos")
    public ResponseEntity<ApiResponse<List<ProductoLoteResponseDTO>>> vencidos(@PathVariable UUID productoId) {
        return ResponseEntity.ok(ApiResponse.success(loteService.listarVencidos(productoId), "Lotes vencidos"));
    }
}

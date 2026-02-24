package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.ProductoPrecioDTO;
import com.tecnoa.pos.modules.inventario.service.ProductoPrecioService;
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
@RequestMapping("/productos/{productoId}/precios")
@RequiredArgsConstructor
@Tag(name = "Precios de Producto", description = "Gestión de precios por producto")
public class ProductoPrecioController {

    private final ProductoPrecioService precioService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<ProductoPrecioDTO>>> listar(@PathVariable UUID productoId) {
        return ResponseEntity.ok(ApiResponse.success(precioService.listarPorProducto(productoId), "Precios obtenidos"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('inventario:precios')")
    public ResponseEntity<ApiResponse<ProductoPrecioDTO>> crear(
            @PathVariable UUID productoId, @Valid @RequestBody ProductoPrecioDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(precioService.crear(productoId, dto), "Precio creado"));
    }

    @PutMapping("/{precioId}")
    @PreAuthorize("hasAuthority('inventario:precios')")
    public ResponseEntity<ApiResponse<ProductoPrecioDTO>> actualizar(
            @PathVariable UUID productoId, @PathVariable UUID precioId,
            @RequestBody ProductoPrecioDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(precioService.actualizar(precioId, dto), "Precio actualizado"));
    }

    @DeleteMapping("/{precioId}")
    @PreAuthorize("hasAuthority('inventario:precios')")
    public ResponseEntity<ApiResponse<Void>> desactivar(
            @PathVariable UUID productoId, @PathVariable UUID precioId) {
        precioService.desactivar(precioId);
        return ResponseEntity.ok(ApiResponse.success("Precio desactivado"));
    }
}

package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.*;
import com.tecnoa.pos.modules.inventario.service.*;
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

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/productos")
@RequiredArgsConstructor
@Tag(name = "Productos", description = "Gestión de productos del inventario")
public class ProductoController {

    private final ProductoService productoService;
    private final ProductoLoteService loteService;
    private final ProductoPrecioService precioService;

    @GetMapping
    @PreAuthorize("hasAuthority('inventario:ver')")
    public ResponseEntity<ApiResponse<Page<ProductoResponseDTO>>> listar(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) UUID categoriaId,
            @RequestParam(required = false) Boolean requiereReceta,
            Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(
                productoService.listar(nombre, categoriaId, requiereReceta, pageable), "Productos obtenidos"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('inventario:crear')")
    public ResponseEntity<ApiResponse<ProductoResponseDTO>> crear(@Valid @RequestBody ProductoRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(productoService.crear(dto), "Producto creado"));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('inventario:ver')")
    public ResponseEntity<ApiResponse<ProductoResponseDTO>> obtener(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(productoService.obtener(id), "Producto obtenido"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('inventario:editar')")
    public ResponseEntity<ApiResponse<ProductoResponseDTO>> actualizar(
            @PathVariable UUID id, @Valid @RequestBody ProductoRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(productoService.actualizar(id, dto), "Producto actualizado"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('inventario:editar')")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable UUID id) {
        productoService.eliminar(id);
        return ResponseEntity.ok(ApiResponse.success("Producto desactivado"));
    }

    // Principios activos
    @GetMapping("/{id}/principios-activos")
    public ResponseEntity<ApiResponse<List<ProductoPrincipioActivoDTO>>> listarPrincipios(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(
                productoService.obtener(id).getPrincipiosActivos(), "Principios activos obtenidos"));
    }

    @PostMapping("/{id}/principios-activos")
    @PreAuthorize("hasAuthority('inventario:editar')")
    public ResponseEntity<ApiResponse<ProductoPrincipioActivoDTO>> asociarPrincipio(
            @PathVariable UUID id, @Valid @RequestBody ProductoPrincipioActivoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(productoService.asociarPrincipioActivo(id, dto), "Principio activo asociado"));
    }

    @DeleteMapping("/{id}/principios-activos/{paId}")
    @PreAuthorize("hasAuthority('inventario:editar')")
    public ResponseEntity<ApiResponse<Void>> desasociarPrincipio(
            @PathVariable UUID id, @PathVariable UUID paId) {
        productoService.desasociarPrincipioActivo(id, paId);
        return ResponseEntity.ok(ApiResponse.success("Principio activo desasociado"));
    }

    // Precios
    @GetMapping("/{id}/precios")
    public ResponseEntity<ApiResponse<List<ProductoPrecioDTO>>> listarPrecios(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(precioService.listarPorProducto(id), "Precios obtenidos"));
    }

    @PostMapping("/{id}/precios")
    @PreAuthorize("hasAuthority('inventario:precios')")
    public ResponseEntity<ApiResponse<ProductoPrecioDTO>> crearPrecio(
            @PathVariable UUID id, @Valid @RequestBody ProductoPrecioDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(precioService.crear(id, dto), "Precio creado"));
    }

    @PutMapping("/{id}/precios/{precioId}")
    @PreAuthorize("hasAuthority('inventario:precios')")
    public ResponseEntity<ApiResponse<ProductoPrecioDTO>> actualizarPrecio(
            @PathVariable UUID id, @PathVariable UUID precioId, @RequestBody ProductoPrecioDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(precioService.actualizar(precioId, dto), "Precio actualizado"));
    }

    @DeleteMapping("/{id}/precios/{precioId}")
    @PreAuthorize("hasAuthority('inventario:precios')")
    public ResponseEntity<ApiResponse<Void>> desactivarPrecio(
            @PathVariable UUID id, @PathVariable UUID precioId) {
        precioService.desactivar(precioId);
        return ResponseEntity.ok(ApiResponse.success("Precio desactivado"));
    }

    // Lotes
    @GetMapping("/{id}/lotes")
    public ResponseEntity<ApiResponse<List<ProductoLoteResponseDTO>>> listarLotes(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(loteService.listarPorProducto(id), "Lotes obtenidos"));
    }

    @PostMapping("/{id}/lotes")
    @PreAuthorize("hasAuthority('inventario:lotes')")
    public ResponseEntity<ApiResponse<ProductoLoteResponseDTO>> crearLote(
            @PathVariable UUID id, @Valid @RequestBody ProductoLoteRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(loteService.crear(id, dto), "Lote registrado"));
    }

    @GetMapping("/{id}/lotes/proximos-vencer")
    public ResponseEntity<ApiResponse<List<ProductoLoteResponseDTO>>> lotesProximosVencer(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(loteService.listarProximosVencer(id), "Lotes próximos a vencer"));
    }

    @GetMapping("/{id}/lotes/vencidos")
    public ResponseEntity<ApiResponse<List<ProductoLoteResponseDTO>>> lotesVencidos(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(loteService.listarVencidos(id), "Lotes vencidos obtenidos"));
    }
}

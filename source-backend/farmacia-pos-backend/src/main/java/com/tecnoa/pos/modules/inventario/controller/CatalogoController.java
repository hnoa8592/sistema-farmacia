package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.CatalogoDTO;
import com.tecnoa.pos.modules.inventario.service.CatalogoService;
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
@RequestMapping("/catalogos")
@RequiredArgsConstructor
@Tag(name = "Catálogos", description = "Categorías, Formas Farmacéuticas y Vías de Administración")
public class CatalogoController {

    private final CatalogoService catalogoService;

    @GetMapping("/categorias")
    public ResponseEntity<ApiResponse<List<CatalogoDTO>>> listarCategorias() {
        return ResponseEntity.ok(ApiResponse.success(catalogoService.listarCategorias(), "Categorías obtenidas"));
    }

    @PostMapping("/categorias")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<CatalogoDTO>> crearCategoria(@Valid @RequestBody CatalogoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(catalogoService.crearCategoria(dto), "Categoría creada"));
    }

    @PutMapping("/categorias/{id}")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<CatalogoDTO>> actualizarCategoria(
            @PathVariable UUID id, @Valid @RequestBody CatalogoDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(catalogoService.actualizarCategoria(id, dto), "Categoría actualizada"));
    }

    @DeleteMapping("/categorias/{id}")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<Void>> eliminarCategoria(@PathVariable UUID id) {
        catalogoService.eliminarCategoria(id);
        return ResponseEntity.ok(ApiResponse.success("Categoría desactivada"));
    }

    @GetMapping("/formas-farmaceuticas")
    public ResponseEntity<ApiResponse<List<CatalogoDTO>>> listarFormas() {
        return ResponseEntity.ok(ApiResponse.success(catalogoService.listarFormas(), "Formas obtenidas"));
    }

    @PostMapping("/formas-farmaceuticas")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<CatalogoDTO>> crearForma(@Valid @RequestBody CatalogoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(catalogoService.crearForma(dto), "Forma creada"));
    }

    @PutMapping("/formas-farmaceuticas/{id}")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<CatalogoDTO>> actualizarForma(
            @PathVariable UUID id, @Valid @RequestBody CatalogoDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(catalogoService.actualizarForma(id, dto), "Forma actualizada"));
    }

    @DeleteMapping("/formas-farmaceuticas/{id}")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<Void>> eliminarForma(@PathVariable UUID id) {
        catalogoService.eliminarForma(id);
        return ResponseEntity.ok(ApiResponse.success("Forma desactivada"));
    }

    @GetMapping("/vias-administracion")
    public ResponseEntity<ApiResponse<List<CatalogoDTO>>> listarVias() {
        return ResponseEntity.ok(ApiResponse.success(catalogoService.listarVias(), "Vías obtenidas"));
    }

    @PostMapping("/vias-administracion")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<CatalogoDTO>> crearVia(@Valid @RequestBody CatalogoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(catalogoService.crearVia(dto), "Vía creada"));
    }

    @PutMapping("/vias-administracion/{id}")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<CatalogoDTO>> actualizarVia(
            @PathVariable UUID id, @Valid @RequestBody CatalogoDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(catalogoService.actualizarVia(id, dto), "Vía actualizada"));
    }

    @DeleteMapping("/vias-administracion/{id}")
    @PreAuthorize("hasAuthority('catalogos:editar')")
    public ResponseEntity<ApiResponse<Void>> eliminarVia(@PathVariable UUID id) {
        catalogoService.eliminarVia(id);
        return ResponseEntity.ok(ApiResponse.success("Vía desactivada"));
    }
}

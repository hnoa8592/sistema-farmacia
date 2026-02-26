package com.tecnoa.pos.modules.ventas.controller;

import com.tecnoa.pos.modules.ventas.dto.VentaRequestDTO;
import com.tecnoa.pos.modules.ventas.dto.VentaResponseDTO;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.service.VentaService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.UUID;

@RestController
@RequestMapping("/ventas")
@RequiredArgsConstructor
@Tag(name = "Ventas", description = "Gestión de ventas")
public class VentaController {

    private final VentaService ventaService;

    @GetMapping
    @PreAuthorize("hasAuthority('ventas:ver')")
    public ResponseEntity<ApiResponse<Page<VentaResponseDTO>>> listar(
            @RequestParam(required = false) UUID usuarioId,
            @RequestParam(required = false) EstadoVenta estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate hasta,
            Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(
                ventaService.listar(usuarioId, estado, desde, hasta, pageable), "Ventas obtenidas"));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('ventas:crear')")
    public ResponseEntity<ApiResponse<VentaResponseDTO>> registrar(
            @Valid @RequestBody VentaRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(ventaService.registrarVenta(request), "Venta registrada"));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('ventas:ver')")
    public ResponseEntity<ApiResponse<VentaResponseDTO>> obtener(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(ventaService.obtener(id), "Venta obtenida"));
    }

    @PutMapping("/{id}/anular")
    @PreAuthorize("hasAuthority('ventas:anular')")
    public ResponseEntity<ApiResponse<VentaResponseDTO>> anular(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(ventaService.anularVenta(id), "Venta anulada"));
    }
}

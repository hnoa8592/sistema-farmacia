package com.tecnoa.pos.modules.inventario.controller;

import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoRequestDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoResponseDTO;
import com.tecnoa.pos.modules.inventario.model.TipoMovimiento;
import com.tecnoa.pos.modules.inventario.service.InventarioService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/inventario")
@RequiredArgsConstructor
@Tag(name = "Inventario", description = "Movimientos y stock de inventario")
public class InventarioController {

    private final InventarioService inventarioService;

    @PostMapping("/entrada")
    @PreAuthorize("hasAuthority('inventario:movimientos')")
    public ResponseEntity<ApiResponse<MovimientoResponseDTO>> entrada(
            @Valid @RequestBody MovimientoRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(inventarioService.registrarEntrada(dto), "Entrada registrada"));
    }

    @PostMapping("/salida")
    @PreAuthorize("hasAuthority('inventario:movimientos')")
    public ResponseEntity<ApiResponse<MovimientoResponseDTO>> salida(
            @Valid @RequestBody MovimientoRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(inventarioService.registrarSalida(dto), "Salida registrada"));
    }

    @PostMapping("/ajuste")
    @PreAuthorize("hasAuthority('inventario:ajuste')")
    public ResponseEntity<ApiResponse<MovimientoResponseDTO>> ajuste(
            @RequestBody MovimientoRequestDTO dto) {
        return ResponseEntity.ok(ApiResponse.success(inventarioService.registrarAjuste(dto), "Ajuste registrado"));
    }

    @GetMapping("/stock")
    @PreAuthorize("hasAuthority('inventario:ver')")
    public ResponseEntity<ApiResponse<List<InventarioResponseDTO>>> stock(
            @RequestParam(required = false) UUID productoId,
            @RequestParam(required = false) UUID sucursalId,
            @RequestParam(required = false) UUID loteId,
            @RequestParam(required = false) Boolean soloConStock) {
        return ResponseEntity.ok(ApiResponse.success(
                inventarioService.getStock(productoId, sucursalId, loteId, soloConStock), "Stock obtenido"));
    }

    @GetMapping("/movimientos")
    @PreAuthorize("hasAuthority('inventario:movimientos')")
    public ResponseEntity<ApiResponse<Page<MovimientoResponseDTO>>> movimientos(
            @RequestParam(required = false) UUID productoId,
            @RequestParam(required = false) UUID sucursalId,
            @RequestParam(required = false) UUID loteId,
            @RequestParam(required = false) TipoMovimiento tipo,
            @RequestParam(required = false) UUID usuarioId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate hasta,
            Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(
                inventarioService.listarMovimientos(productoId, sucursalId, loteId, tipo, usuarioId, desde, hasta, pageable),
                "Movimientos obtenidos"));
    }
}

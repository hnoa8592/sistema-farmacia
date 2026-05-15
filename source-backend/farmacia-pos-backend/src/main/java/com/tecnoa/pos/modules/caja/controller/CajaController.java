package com.tecnoa.pos.modules.caja.controller;

import com.tecnoa.pos.modules.caja.dto.*;
import com.tecnoa.pos.modules.caja.service.CajaService;
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
@RequestMapping("/caja")
@RequiredArgsConstructor
@Tag(name = "Caja", description = "Gestión de apertura y cierre de caja")
public class CajaController {

    private final CajaService cajaService;

    @PostMapping("/abrir")
    @PreAuthorize("hasAuthority('caja:abrir')")
    public ResponseEntity<ApiResponse<CajaResponseDTO>> abrir(
            @Valid @RequestBody AperturaCajaRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(cajaService.abrir(request), "Caja abierta correctamente"));
    }

    @PostMapping("/{id}/cerrar")
    @PreAuthorize("hasAuthority('caja:cerrar')")
    public ResponseEntity<ApiResponse<ReporteCierreCajaDTO>> cerrar(
            @PathVariable UUID id,
            @Valid @RequestBody CierreCajaRequestDTO request) {
        return ResponseEntity.ok(ApiResponse.success(cajaService.cerrar(id, request), "Caja cerrada correctamente"));
    }

    @PostMapping("/{id}/retiro")
    @PreAuthorize("hasAuthority('caja:movimientos')")
    public ResponseEntity<ApiResponse<MovimientoCajaDTO>> retiro(
            @PathVariable UUID id,
            @Valid @RequestBody MovimientoCajaRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(cajaService.registrarRetiro(id, request), "Retiro registrado"));
    }

    @PostMapping("/{id}/ingreso")
    @PreAuthorize("hasAuthority('caja:movimientos')")
    public ResponseEntity<ApiResponse<MovimientoCajaDTO>> ingreso(
            @PathVariable UUID id,
            @Valid @RequestBody MovimientoCajaRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(cajaService.registrarIngreso(id, request), "Ingreso registrado"));
    }

    @GetMapping("/activa")
    @PreAuthorize("hasAuthority('caja:ver')")
    public ResponseEntity<ApiResponse<CajaResponseDTO>> getActiva(
            @RequestParam UUID sucursalId) {
        return ResponseEntity.ok(ApiResponse.success(cajaService.getActiva(sucursalId), "Caja activa"));
    }

    @GetMapping("/{id}/reporte")
    @PreAuthorize("hasAuthority('reportes:cierre-caja')")
    public ResponseEntity<ApiResponse<ReporteCierreCajaDTO>> getReporte(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(cajaService.getReporte(id), "Reporte de cierre"));
    }

    @GetMapping("/historial")
    @PreAuthorize("hasAuthority('reportes:cierre-caja')")
    public ResponseEntity<ApiResponse<Page<CajaResponseDTO>>> getHistorial(
            @RequestParam UUID sucursalId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate hasta,
            Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(
                cajaService.getHistorial(sucursalId, desde, hasta, pageable), "Historial de cierres"));
    }
}

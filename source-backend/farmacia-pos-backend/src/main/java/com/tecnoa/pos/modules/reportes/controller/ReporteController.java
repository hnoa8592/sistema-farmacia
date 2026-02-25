package com.tecnoa.pos.modules.reportes.controller;

import com.tecnoa.pos.modules.reportes.dto.ReporteStockDTO;
import com.tecnoa.pos.modules.reportes.dto.ReporteVentasDTO;
import com.tecnoa.pos.modules.reportes.service.ReporteService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@RestController
@RequestMapping("/reportes")
@RequiredArgsConstructor
@Tag(name = "Reportes", description = "Reportes y estadísticas del sistema")
public class ReporteController {

    private final ReporteService reporteService;

    @GetMapping("/ventas")
    @PreAuthorize("hasAuthority('reportes:ventas')")
    public ResponseEntity<ApiResponse<ReporteVentasDTO>> ventas(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate hasta) {
        LocalDateTime desdeTs = desde != null
                ? LocalDateTime.of(desde, LocalTime.MIN)
                : LocalDateTime.now().minusDays(6).with(LocalTime.MIN);
        LocalDateTime hastaTs = hasta != null
                ? LocalDateTime.of(hasta, LocalTime.MAX)
                : LocalDateTime.now().with(LocalTime.MAX);
        return ResponseEntity.ok(ApiResponse.success(
                reporteService.reporteVentas(desdeTs, hastaTs), "Reporte generado"));
    }

    @GetMapping("/stock")
    @PreAuthorize("hasAuthority('reportes:stock')")
    public ResponseEntity<ApiResponse<List<ReporteStockDTO>>> stock() {
        return ResponseEntity.ok(ApiResponse.success(
                reporteService.reporteStock(), "Reporte de stock generado"));
    }
}

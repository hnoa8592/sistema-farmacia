package com.tecnoa.pos.modules.caja.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.caja.dto.*;
import com.tecnoa.pos.modules.caja.model.*;
import com.tecnoa.pos.modules.caja.repository.CajaRepository;
import com.tecnoa.pos.modules.caja.repository.MovimientoCajaRepository;
import com.tecnoa.pos.modules.usuarios.model.Usuario;
import com.tecnoa.pos.modules.usuarios.repository.UsuarioRepository;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.model.Venta;
import com.tecnoa.pos.modules.ventas.repository.VentaRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import com.tecnoa.pos.shared.security.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CajaService {

    private final CajaRepository cajaRepository;
    private final MovimientoCajaRepository movimientoCajaRepository;
    private final VentaRepository ventaRepository;
    private final UsuarioRepository usuarioRepository;
    private final SecurityUtils securityUtils;

    @Auditable(accion = "ABRIR", modulo = "CAJA", entidad = "Caja", descripcion = "Apertura de caja")
    @Transactional
    public CajaResponseDTO abrir(AperturaCajaRequestDTO request) {
        if (cajaRepository.existsBySucursalIdAndEstado(request.getSucursalId(), EstadoCaja.ABIERTA)) {
            throw new BusinessException("Ya existe una caja abierta para esta sucursal");
        }
        UUID usuarioId = securityUtils.getCurrentUserId();
        Caja caja = Caja.builder()
                .sucursalId(request.getSucursalId())
                .usuarioId(usuarioId)
                .montoApertura(request.getMontoApertura())
                .estado(EstadoCaja.ABIERTA)
                .build();
        return toResponse(cajaRepository.save(caja));
    }

    @Auditable(accion = "CERRAR", modulo = "CAJA", entidad = "Caja", descripcion = "Cierre de caja")
    @Transactional
    public ReporteCierreCajaDTO cerrar(UUID cajaId, CierreCajaRequestDTO request) {
        Caja caja = getCajaAbierta(cajaId);

        List<MovimientoCaja> movimientos = movimientoCajaRepository.findByCajaIdOrderByFechaAsc(cajaId);
        BigDecimal totalRetiros = sumarPorTipo(movimientos, TipoMovimientoCaja.RETIRO);
        BigDecimal totalIngresos = sumarPorTipo(movimientos, TipoMovimientoCaja.INGRESO_MANUAL);

        List<Venta> ventas = ventaRepository.findByFechaBetween(
                caja.getFechaApertura(), LocalDateTime.now(),
                PageRequest.of(0, Integer.MAX_VALUE)).getContent()
                .stream().filter(v -> v.getEstado() == EstadoVenta.COMPLETADA).toList();

        BigDecimal totalVentas = ventas.stream()
                .map(Venta::getTotal).reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal efectivoEsperado = caja.getMontoApertura()
                .add(totalVentas)
                .add(totalIngresos)
                .subtract(totalRetiros);

        BigDecimal diferencia = request.getMontoContado().subtract(efectivoEsperado);

        caja.setFechaCierre(LocalDateTime.now());
        caja.setMontoContado(request.getMontoContado());
        caja.setEfectivoEsperado(efectivoEsperado);
        caja.setDiferencia(diferencia);
        caja.setObservacion(request.getObservacion());
        caja.setEstado(EstadoCaja.CERRADA);
        cajaRepository.save(caja);

        return buildReporte(caja, ventas, movimientos, totalVentas, totalRetiros, totalIngresos,
                efectivoEsperado, diferencia);
    }

    @Auditable(accion = "RETIRO", modulo = "CAJA", entidad = "MovimientoCaja", descripcion = "Retiro de caja")
    @Transactional
    public MovimientoCajaDTO registrarRetiro(UUID cajaId, MovimientoCajaRequestDTO request) {
        return registrarMovimiento(cajaId, request, TipoMovimientoCaja.RETIRO);
    }

    @Auditable(accion = "INGRESO", modulo = "CAJA", entidad = "MovimientoCaja", descripcion = "Ingreso manual a caja")
    @Transactional
    public MovimientoCajaDTO registrarIngreso(UUID cajaId, MovimientoCajaRequestDTO request) {
        return registrarMovimiento(cajaId, request, TipoMovimientoCaja.INGRESO_MANUAL);
    }

    @Transactional(readOnly = true)
    public CajaResponseDTO getActiva(UUID sucursalId) {
        return cajaRepository.findBySucursalIdAndEstado(sucursalId, EstadoCaja.ABIERTA)
                .map(this::toResponse)
                .orElse(null);
    }

    @Transactional(readOnly = true)
    public ReporteCierreCajaDTO getReporte(UUID cajaId) {
        Caja caja = cajaRepository.findById(cajaId)
                .orElseThrow(() -> new ResourceNotFoundException("Caja", cajaId));

        LocalDateTime fin = caja.getFechaCierre() != null ? caja.getFechaCierre() : LocalDateTime.now();
        List<Venta> ventas = ventaRepository.findByFechaBetween(
                caja.getFechaApertura(), fin,
                PageRequest.of(0, Integer.MAX_VALUE)).getContent()
                .stream().filter(v -> v.getEstado() == EstadoVenta.COMPLETADA).toList();

        List<MovimientoCaja> movimientos = movimientoCajaRepository.findByCajaIdOrderByFechaAsc(cajaId);
        BigDecimal totalRetiros  = sumarPorTipo(movimientos, TipoMovimientoCaja.RETIRO);
        BigDecimal totalIngresos = sumarPorTipo(movimientos, TipoMovimientoCaja.INGRESO_MANUAL);
        BigDecimal totalVentas   = ventas.stream().map(Venta::getTotal).reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal efectivoEsperado = caja.getEfectivoEsperado() != null
                ? caja.getEfectivoEsperado()
                : caja.getMontoApertura().add(totalVentas).add(totalIngresos).subtract(totalRetiros);

        BigDecimal diferencia = caja.getDiferencia() != null
                ? caja.getDiferencia()
                : (caja.getMontoContado() != null ? caja.getMontoContado().subtract(efectivoEsperado) : null);

        return buildReporte(caja, ventas, movimientos, totalVentas, totalRetiros, totalIngresos,
                efectivoEsperado, diferencia);
    }

    @Transactional(readOnly = true)
    public Page<CajaResponseDTO> getHistorial(UUID sucursalId, LocalDate desde, LocalDate hasta, Pageable pageable) {
        LocalDateTime desdeDateTime = desde != null ? desde.atStartOfDay() : null;
        LocalDateTime hastaDateTime = hasta != null ? hasta.atTime(23, 59, 59) : null;
        return cajaRepository.findHistorial(sucursalId, desdeDateTime, hastaDateTime, pageable)
                .map(this::toResponse);
    }

    // ─── privados ──────────────────────────────────────────────────────────────

    private MovimientoCajaDTO registrarMovimiento(UUID cajaId, MovimientoCajaRequestDTO request,
                                                   TipoMovimientoCaja tipo) {
        Caja caja = getCajaAbierta(cajaId);
        MovimientoCaja mov = MovimientoCaja.builder()
                .caja(caja)
                .tipo(tipo)
                .monto(request.getMonto())
                .descripcion(request.getDescripcion())
                .usuarioId(securityUtils.getCurrentUserId())
                .build();
        return toMovDTO(movimientoCajaRepository.save(mov));
    }

    private Caja getCajaAbierta(UUID cajaId) {
        Caja caja = cajaRepository.findById(cajaId)
                .orElseThrow(() -> new ResourceNotFoundException("Caja", cajaId));
        if (caja.getEstado() != EstadoCaja.ABIERTA) {
            throw new BusinessException("La caja ya está cerrada");
        }
        return caja;
    }

    private BigDecimal sumarPorTipo(List<MovimientoCaja> movimientos, TipoMovimientoCaja tipo) {
        return movimientos.stream()
                .filter(m -> m.getTipo() == tipo)
                .map(MovimientoCaja::getMonto)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private ReporteCierreCajaDTO buildReporte(Caja caja, List<Venta> ventas,
                                               List<MovimientoCaja> movimientos,
                                               BigDecimal totalVentas, BigDecimal totalRetiros,
                                               BigDecimal totalIngresos, BigDecimal efectivoEsperado,
                                               BigDecimal diferencia) {
        Map<UUID, String> nombres = resolverNombres(ventas, movimientos, caja.getUsuarioId());

        List<VentaCajeroDTO> ventasPorCajero = ventas.stream()
                .collect(Collectors.groupingBy(Venta::getUsuarioId))
                .entrySet().stream()
                .map(e -> VentaCajeroDTO.builder()
                        .usuarioId(e.getKey())
                        .nombreUsuario(nombres.getOrDefault(e.getKey(), e.getKey().toString()))
                        .cantidadVentas((long) e.getValue().size())
                        .totalVentas(e.getValue().stream().map(Venta::getTotal)
                                .reduce(BigDecimal.ZERO, BigDecimal::add))
                        .build())
                .collect(Collectors.toList());

        List<MovimientoCajaDTO> retiros = movimientos.stream()
                .filter(m -> m.getTipo() == TipoMovimientoCaja.RETIRO)
                .map(this::toMovDTO).collect(Collectors.toList());

        List<MovimientoCajaDTO> ingresos = movimientos.stream()
                .filter(m -> m.getTipo() == TipoMovimientoCaja.INGRESO_MANUAL)
                .map(this::toMovDTO).collect(Collectors.toList());

        String estadoDiferencia = null;
        if (diferencia != null) {
            estadoDiferencia = diferencia.compareTo(BigDecimal.ZERO) == 0 ? "CUADRADO"
                    : diferencia.compareTo(BigDecimal.ZERO) > 0 ? "SOBRANTE" : "FALTANTE";
        }

        return ReporteCierreCajaDTO.builder()
                .cajaId(caja.getId())
                .sucursalId(caja.getSucursalId())
                .nombreCajero(nombres.getOrDefault(caja.getUsuarioId(), caja.getUsuarioId().toString()))
                .fechaApertura(caja.getFechaApertura())
                .fechaCierre(caja.getFechaCierre())
                .montoApertura(caja.getMontoApertura())
                .totalVentas(totalVentas)
                .cantidadVentas((long) ventas.size())
                .ventasPorCajero(ventasPorCajero)
                .totalRetiros(totalRetiros)
                .retiros(retiros)
                .totalIngresosManuales(totalIngresos)
                .ingresosManuales(ingresos)
                .efectivoEsperado(efectivoEsperado)
                .montoContado(caja.getMontoContado())
                .diferencia(diferencia)
                .estadoDiferencia(estadoDiferencia)
                .observacion(caja.getObservacion())
                .estadoCaja(caja.getEstado().name())
                .build();
    }

    private Map<UUID, String> resolverNombres(List<Venta> ventas, List<MovimientoCaja> movimientos, UUID cajeroId) {
        Set<UUID> ids = new HashSet<>();
        ids.add(cajeroId);
        ventas.forEach(v -> ids.add(v.getUsuarioId()));
        movimientos.forEach(m -> ids.add(m.getUsuarioId()));

        Map<UUID, String> nombres = new HashMap<>();
        usuarioRepository.findAllById(ids).forEach(u -> nombres.put(u.getId(), u.getNombre()));
        return nombres;
    }

    private CajaResponseDTO toResponse(Caja caja) {
        String nombreUsuario = usuarioRepository.findById(caja.getUsuarioId())
                .map(Usuario::getNombre).orElse(null);
        List<MovimientoCajaDTO> movimientos = movimientoCajaRepository
                .findByCajaIdOrderByFechaAsc(caja.getId())
                .stream().map(this::toMovDTO).collect(Collectors.toList());
        return CajaResponseDTO.builder()
                .id(caja.getId())
                .sucursalId(caja.getSucursalId())
                .usuarioId(caja.getUsuarioId())
                .nombreUsuario(nombreUsuario)
                .fechaApertura(caja.getFechaApertura())
                .montoApertura(caja.getMontoApertura())
                .fechaCierre(caja.getFechaCierre())
                .montoContado(caja.getMontoContado())
                .efectivoEsperado(caja.getEfectivoEsperado())
                .diferencia(caja.getDiferencia())
                .observacion(caja.getObservacion())
                .estado(caja.getEstado().name())
                .movimientos(movimientos)
                .build();
    }

    private MovimientoCajaDTO toMovDTO(MovimientoCaja m) {
        return MovimientoCajaDTO.builder()
                .id(m.getId())
                .tipo(m.getTipo().name())
                .monto(m.getMonto())
                .descripcion(m.getDescripcion())
                .fecha(m.getFecha())
                .usuarioId(m.getUsuarioId())
                .build();
    }
}

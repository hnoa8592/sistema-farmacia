package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoRequestDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoResponseDTO;
import com.tecnoa.pos.modules.inventario.model.*;
import com.tecnoa.pos.modules.inventario.repository.InventarioRepository;
import com.tecnoa.pos.modules.inventario.repository.MovimientoRepository;
import com.tecnoa.pos.modules.inventario.repository.SucursalRepository;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Pruebas unitarias para {@link InventarioService}.
 * Se usan mocks para todos los repositorios y servicios externos,
 * de modo que se valida únicamente la lógica de negocio del servicio.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("InventarioService - Pruebas Unitarias")
class InventarioServiceTest {

    @Mock private InventarioRepository inventarioRepository;
    @Mock private MovimientoRepository movimientoRepository;
    @Mock private ParametroService parametroService;
    @Mock private SucursalRepository sucursalRepository;

    @InjectMocks
    private InventarioService inventarioService;

    // -----------------------------------------------------------------------
    // Helpers para construir objetos de prueba
    // -----------------------------------------------------------------------

    /**
     * Construye un {@link Inventario} con la cadena de relaciones completa
     * (Sucursal, ProductoLote → Producto) necesaria para que
     * {@code registrarMovimiento()} pueda leer los IDs requeridos.
     */
    private Inventario buildInventario(int stockActual) {
        Producto producto = new Producto();
        producto.setId(UUID.randomUUID());
        producto.setNombre("Paracetamol 500mg");
        producto.setCodigo("PARA-500");

        ProductoLote lote = new ProductoLote();
        lote.setId(UUID.randomUUID());
        lote.setNumeroLote("LOTE-001");
        lote.setProducto(producto);

        Sucursal sucursal = new Sucursal();
        sucursal.setId(UUID.randomUUID());
        sucursal.setNombre("Sucursal Central");

        return Inventario.builder()
                .id(UUID.randomUUID())
                .lote(lote)
                .sucursal(sucursal)
                .stockActual(stockActual)
                .stockMinimo(10)
                .build();
    }

    private MovimientoRequestDTO buildRequest(UUID inventarioId, int cantidad) {
        MovimientoRequestDTO dto = new MovimientoRequestDTO();
        dto.setInventarioId(inventarioId);
        dto.setCantidad(cantidad);
        dto.setObservacion("Prueba unitaria");
        return dto;
    }

    // -----------------------------------------------------------------------
    // registrarEntrada
    // -----------------------------------------------------------------------

    @Nested
    @DisplayName("registrarEntrada")
    class RegistrarEntrada {

        @Test
        @DisplayName("stock 100 + entrada 50 → stock resultante 150")
        void conInventarioValido_incrementaStock() {
            Inventario inventario = buildInventario(100);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            MovimientoResponseDTO response = inventarioService.registrarEntrada(buildRequest(invId, 50));

            assertThat(inventario.getStockActual()).isEqualTo(150);
            assertThat(response.getTipo()).isEqualTo(TipoMovimiento.ENTRADA);
            assertThat(response.getCantidad()).isEqualTo(50);
            assertThat(response.getStockAnterior()).isEqualTo(100);
            assertThat(response.getStockResultante()).isEqualTo(150);
        }

        @Test
        @DisplayName("inventario inexistente → lanza ResourceNotFoundException")
        void inventarioNoEncontrado_lanzaException() {
            UUID inventarioId = UUID.randomUUID();
            when(inventarioRepository.findById(inventarioId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> inventarioService.registrarEntrada(buildRequest(inventarioId, 10)))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Inventario");
        }

        @Test
        @DisplayName("guarda inventario y registra movimiento ENTRADA con datos correctos")
        void guardaInventarioYRegistraMovimientoEntrada() {
            Inventario inventario = buildInventario(30);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            inventarioService.registrarEntrada(buildRequest(invId, 20));

            verify(inventarioRepository).save(inventario);
            verify(movimientoRepository).save(argThat(m ->
                    m.getTipo() == TipoMovimiento.ENTRADA
                    && m.getCantidad() == 20
                    && m.getStockAnterior() == 30
                    && m.getStockResultante() == 50
            ));
        }

        @Test
        @DisplayName("entrada 0 desde stock 0 → stock sigue en 0")
        void entradaCeroBajoStockCero_stockSigueEnCero() {
            Inventario inventario = buildInventario(0);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            MovimientoResponseDTO response = inventarioService.registrarEntrada(buildRequest(invId, 0));

            assertThat(inventario.getStockActual()).isZero();
            assertThat(response.getStockResultante()).isZero();
        }
    }

    // -----------------------------------------------------------------------
    // registrarSalida
    // -----------------------------------------------------------------------

    @Nested
    @DisplayName("registrarSalida")
    class RegistrarSalida {

        @Test
        @DisplayName("stock suficiente y venta sin stock desactivada → decrementa correctamente")
        void conStockSuficiente_decrementa() {
            Inventario inventario = buildInventario(100);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            MovimientoResponseDTO response = inventarioService.registrarSalida(buildRequest(invId, 30));

            assertThat(inventario.getStockActual()).isEqualTo(70);
            assertThat(response.getTipo()).isEqualTo(TipoMovimiento.SALIDA);
            assertThat(response.getCantidad()).isEqualTo(30);
            assertThat(response.getStockAnterior()).isEqualTo(100);
            assertThat(response.getStockResultante()).isEqualTo(70);
        }

        @Test
        @DisplayName("stock insuficiente y PERMITIR_VENTA_SIN_STOCK=false → lanza BusinessException con mensaje de stock")
        void stockInsuficiente_noPermitido_lanzaBusinessException() {
            Inventario inventario = buildInventario(5);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);

            assertThatThrownBy(() -> inventarioService.registrarSalida(buildRequest(invId, 10)))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Stock insuficiente")
                    .hasMessageContaining("5");

            verify(inventarioRepository, never()).save(any());
        }

        @Test
        @DisplayName("stock insuficiente y PERMITIR_VENTA_SIN_STOCK=true → decrementa a negativo")
        void stockInsuficiente_permitido_decrementaANegativo() {
            Inventario inventario = buildInventario(3);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(true);
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            MovimientoResponseDTO response = inventarioService.registrarSalida(buildRequest(invId, 10));

            assertThat(inventario.getStockActual()).isEqualTo(-7);
            assertThat(response.getStockResultante()).isEqualTo(-7);
        }

        @Test
        @DisplayName("salida exacta al stock disponible → stock queda en 0")
        void salidaExactaAlStock_stockEnCero() {
            Inventario inventario = buildInventario(50);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            inventarioService.registrarSalida(buildRequest(invId, 50));

            assertThat(inventario.getStockActual()).isZero();
        }

        @Test
        @DisplayName("inventario inexistente → lanza ResourceNotFoundException")
        void inventarioNoEncontrado_lanzaException() {
            UUID inventarioId = UUID.randomUUID();
            when(inventarioRepository.findById(inventarioId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> inventarioService.registrarSalida(buildRequest(inventarioId, 5)))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    // -----------------------------------------------------------------------
    // registrarAjuste
    // -----------------------------------------------------------------------

    @Nested
    @DisplayName("registrarAjuste")
    class RegistrarAjuste {

        @Test
        @DisplayName("ajuste con stockNuevo explícito → establece ese valor y calcula diferencia")
        void conStockNuevoExplicito_estableceNuevoStock() {
            Inventario inventario = buildInventario(50);
            UUID invId = inventario.getId();

            MovimientoRequestDTO dto = buildRequest(invId, 0);
            dto.setStockNuevo(80);

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            MovimientoResponseDTO response = inventarioService.registrarAjuste(dto);

            assertThat(inventario.getStockActual()).isEqualTo(80);
            assertThat(response.getTipo()).isEqualTo(TipoMovimiento.AJUSTE);
            assertThat(response.getStockAnterior()).isEqualTo(50);
            assertThat(response.getStockResultante()).isEqualTo(80);
            assertThat(response.getCantidad()).isEqualTo(30); // |80 - 50|
        }

        @Test
        @DisplayName("ajuste sin stockNuevo → usa cantidad como nuevo stock")
        void sinStockNuevo_usaCantidadComoNuevoStock() {
            Inventario inventario = buildInventario(20);
            UUID invId = inventario.getId();

            MovimientoRequestDTO dto = buildRequest(invId, 45);
            dto.setStockNuevo(null);

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            inventarioService.registrarAjuste(dto);

            assertThat(inventario.getStockActual()).isEqualTo(45);
        }

        @Test
        @DisplayName("ajuste hacia abajo → cantidad del movimiento = diferencia absoluta")
        void ajusteHaciaAbajo_cantidadEsDiferenciaAbsoluta() {
            Inventario inventario = buildInventario(100);
            UUID invId = inventario.getId();

            MovimientoRequestDTO dto = buildRequest(invId, 0);
            dto.setStockNuevo(60);

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            MovimientoResponseDTO response = inventarioService.registrarAjuste(dto);

            assertThat(response.getCantidad()).isEqualTo(40); // |60 - 100|
            assertThat(response.getStockResultante()).isEqualTo(60);
        }
    }

    // -----------------------------------------------------------------------
    // getStock
    // -----------------------------------------------------------------------

    @Nested
    @DisplayName("getStock")
    class GetStock {

        @Test
        @DisplayName("filtro por productoId → delega a findByProductoId y retorna lista correcta")
        void porProductoId_delegaAlRepositorio() {
            UUID productoId = UUID.randomUUID();
            Inventario inv = buildInventario(10);
            when(inventarioRepository.findByProductoId(productoId)).thenReturn(List.of(inv));

            List<InventarioResponseDTO> result = inventarioService.getStock(productoId, null, null);

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getStockActual()).isEqualTo(10);
            verify(inventarioRepository).findByProductoId(productoId);
            verifyNoMoreInteractions(inventarioRepository);
        }

        @Test
        @DisplayName("filtro por sucursalId → delega a findBySucursalId")
        void porSucursalId_delegaAlRepositorio() {
            UUID sucursalId = UUID.randomUUID();
            when(inventarioRepository.findBySucursalId(sucursalId))
                    .thenReturn(List.of(buildInventario(20)));

            List<InventarioResponseDTO> result = inventarioService.getStock(null, sucursalId, null);

            assertThat(result).hasSize(1);
            verify(inventarioRepository).findBySucursalId(sucursalId);
        }

        @Test
        @DisplayName("filtro por loteId → delega a findByLoteId")
        void porLoteId_delegaAlRepositorio() {
            UUID loteId = UUID.randomUUID();
            when(inventarioRepository.findByLoteId(loteId))
                    .thenReturn(List.of(buildInventario(15)));

            List<InventarioResponseDTO> result = inventarioService.getStock(null, null, loteId);

            assertThat(result).hasSize(1);
            verify(inventarioRepository).findByLoteId(loteId);
        }

        @Test
        @DisplayName("sin filtros → delega a findAll y retorna todos")
        void sinFiltros_retornaTodos() {
            when(inventarioRepository.findAll())
                    .thenReturn(List.of(buildInventario(5), buildInventario(10), buildInventario(0)));

            List<InventarioResponseDTO> result = inventarioService.getStock(null, null, null);

            assertThat(result).hasSize(3);
            verify(inventarioRepository).findAll();
        }

        @Test
        @DisplayName("bajoPStock=true cuando stockActual <= stockMinimo")
        void bajoPStock_verdadero_cuandoStockActualMenorOigualMinimo() {
            Inventario inventario = buildInventario(8); // stockMinimo = 10 por defecto en buildInventario
            UUID productoId = UUID.randomUUID();
            when(inventarioRepository.findByProductoId(productoId)).thenReturn(List.of(inventario));

            List<InventarioResponseDTO> result = inventarioService.getStock(productoId, null, null);

            assertThat(result.get(0).getBajoPStock()).isTrue();
        }
    }
}

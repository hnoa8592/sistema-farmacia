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
 * Se usan mocks para todos los repositorios y servicios externos.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("InventarioService – Pruebas Unitarias")
class InventarioServiceTest {

    @Mock private InventarioRepository inventarioRepository;
    @Mock private MovimientoRepository  movimientoRepository;
    @Mock private ParametroService      parametroService;
    @Mock private SucursalRepository    sucursalRepository;

    @InjectMocks
    private InventarioService inventarioService;

    // ---------------------------------------------------------------
    // Fixtures
    // ---------------------------------------------------------------

    /** Construye un Inventario con la cadena de relaciones mínima para toResponse(). */
    private Inventario buildInventario(String productoNombre, int stockActual, int stockMinimo) {
        Producto producto = new Producto();
        producto.setId(UUID.randomUUID());
        producto.setNombre(productoNombre);
        producto.setCodigo("COD-TEST");
        producto.setPrecios(List.of()); // evita NPE en toResponse()

        ProductoLote lote = new ProductoLote();
        lote.setId(UUID.randomUUID());
        lote.setNumeroLote("LOT-001");
        lote.setProducto(producto);

        Sucursal sucursal = new Sucursal();
        sucursal.setId(UUID.randomUUID());
        sucursal.setNombre("Farmacia Central");

        return Inventario.builder()
                .id(UUID.randomUUID())
                .lote(lote)
                .sucursal(sucursal)
                .stockActual(stockActual)
                .stockMinimo(stockMinimo)
                .build();
    }

    private MovimientoRequestDTO buildRequest(UUID inventarioId, int cantidad) {
        MovimientoRequestDTO dto = new MovimientoRequestDTO();
        dto.setInventarioId(inventarioId);
        dto.setCantidad(cantidad);
        dto.setObservacion("Prueba unitaria");
        return dto;
    }

    // ---------------------------------------------------------------
    // getStock – filtro por productoNombre
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("getStock – filtro por productoNombre")
    class GetStockFiltroPorNombre {

        @Test
        @DisplayName("Retorna resultados cuando productoNombre coincide parcialmente")
        void conNombreParcial_retornaResultados() {
            Inventario inv = buildInventario("Paracetamol 500mg", 50, 10);
            when(inventarioRepository.buscarStock(null, null, null, "paracetamol"))
                    .thenReturn(List.of(inv));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, null, null, "paracetamol", null);

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getProductoNombre()).isEqualTo("Paracetamol 500mg");
            verify(inventarioRepository).buscarStock(null, null, null, "paracetamol");
        }

        @Test
        @DisplayName("Normaliza espacios antes de pasar el nombre al repositorio")
        void conEspacios_trimAntesDePasar() {
            when(inventarioRepository.buscarStock(null, null, null, "ibuprofeno"))
                    .thenReturn(List.of());

            inventarioService.getStock(null, null, null, "  ibuprofeno  ", null);

            verify(inventarioRepository).buscarStock(null, null, null, "ibuprofeno");
        }

        @Test
        @DisplayName("productoNombre solo espacios se convierte en null (sin filtro)")
        void conSoloEspacios_pasaNullAlRepositorio() {
            when(inventarioRepository.buscarStock(null, null, null, null))
                    .thenReturn(List.of());

            inventarioService.getStock(null, null, null, "   ", null);

            verify(inventarioRepository).buscarStock(null, null, null, null);
        }

        @Test
        @DisplayName("productoNombre=null pasa null al repositorio")
        void conNombreNull_pasaNullAlRepositorio() {
            when(inventarioRepository.buscarStock(null, null, null, null))
                    .thenReturn(List.of());

            inventarioService.getStock(null, null, null, null, null);

            verify(inventarioRepository).buscarStock(null, null, null, null);
        }

        @Test
        @DisplayName("Sin coincidencias por nombre retorna lista vacía")
        void sinCoincidencias_retornaListaVacia() {
            when(inventarioRepository.buscarStock(null, null, null, "xyz_inexistente"))
                    .thenReturn(List.of());

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, null, null, "xyz_inexistente", null);

            assertThat(result).isEmpty();
        }
    }

    // ---------------------------------------------------------------
    // getStock – combinación de filtros (caso de uso POS)
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("getStock – combinación de filtros")
    class GetStockCombinacionFiltros {

        @Test
        @DisplayName("productoNombre + sucursalId se delegan juntos al repositorio (caso POS)")
        void nombreYSucursal_delegaAmbos() {
            UUID sucursalId = UUID.randomUUID();
            Inventario inv  = buildInventario("Amoxicilina 500mg", 20, 5);
            when(inventarioRepository.buscarStock(null, sucursalId, null, "amoxicilina"))
                    .thenReturn(List.of(inv));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, sucursalId, null, "amoxicilina", null);

            assertThat(result).hasSize(1);
            verify(inventarioRepository).buscarStock(null, sucursalId, null, "amoxicilina");
        }

        @Test
        @DisplayName("productoId se pasa correctamente")
        void conProductoId_delegaCorrectamente() {
            UUID productoId = UUID.randomUUID();
            when(inventarioRepository.buscarStock(productoId, null, null, null))
                    .thenReturn(List.of(buildInventario("Losartan", 30, 10)));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(productoId, null, null, null, null);

            assertThat(result).hasSize(1);
            verify(inventarioRepository).buscarStock(productoId, null, null, null);
        }

        @Test
        @DisplayName("loteId se pasa correctamente")
        void conLoteId_delegaCorrectamente() {
            UUID loteId = UUID.randomUUID();
            when(inventarioRepository.buscarStock(null, null, loteId, null))
                    .thenReturn(List.of());

            inventarioService.getStock(null, null, loteId, null, null);

            verify(inventarioRepository).buscarStock(null, null, loteId, null);
        }

        @Test
        @DisplayName("Sin filtros, buscarStock se llama con todos null")
        void sinFiltros_buscarStockConTodosNull() {
            when(inventarioRepository.buscarStock(null, null, null, null))
                    .thenReturn(List.of(
                            buildInventario("Enalapril",  15, 5),
                            buildInventario("Metformina", 40, 10)));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, null, null, null, null);

            assertThat(result).hasSize(2);
            verify(inventarioRepository).buscarStock(null, null, null, null);
            verifyNoMoreInteractions(inventarioRepository);
        }
    }

    // ---------------------------------------------------------------
    // getStock – filtro soloConStock
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("getStock – filtro soloConStock")
    class GetStockSoloConStock {

        @Test
        @DisplayName("soloConStock=true excluye registros con stockActual=0")
        void soloConStockTrue_excluyeStockCero() {
            Inventario conStock = buildInventario("Ibuprofeno",  15, 5);
            Inventario sinStock = buildInventario("Loratadina",   0, 5);
            when(inventarioRepository.buscarStock(null, null, null, null))
                    .thenReturn(List.of(conStock, sinStock));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, null, null, null, true);

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getStockActual()).isPositive();
        }

        @Test
        @DisplayName("soloConStock=false devuelve todos incluyendo stock cero")
        void soloConStockFalse_retornaTodos() {
            when(inventarioRepository.buscarStock(null, null, null, null))
                    .thenReturn(List.of(
                            buildInventario("Ibuprofeno", 15, 5),
                            buildInventario("Loratadina",  0, 5)));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, null, null, null, false);

            assertThat(result).hasSize(2);
        }

        @Test
        @DisplayName("soloConStock=null no aplica filtro de stock")
        void soloConStockNull_sinFiltro() {
            when(inventarioRepository.buscarStock(null, null, null, null))
                    .thenReturn(List.of(buildInventario("Metformina", 0, 10)));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, null, null, null, null);

            assertThat(result).hasSize(1);
        }

        @Test
        @DisplayName("soloConStock=true + productoNombre combinados (flujo POS completo)")
        void posCompleto_nombreYSoloConStock() {
            UUID sucursalId = UUID.randomUUID();
            Inventario inv1 = buildInventario("Metformina 500mg", 30, 10);
            Inventario inv2 = buildInventario("Metformina 850mg",  0, 10);
            when(inventarioRepository.buscarStock(null, sucursalId, null, "metformina"))
                    .thenReturn(List.of(inv1, inv2));

            List<InventarioResponseDTO> result =
                    inventarioService.getStock(null, sucursalId, null, "metformina", true);

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getStockActual()).isEqualTo(30);
        }
    }

    // ---------------------------------------------------------------
    // getStock – mapeo DTO
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("getStock – mapeo del DTO")
    class GetStockMapeoDTO {

        @Test
        @DisplayName("DTO contiene todos los campos esperados correctamente mapeados")
        void dto_contieneCamposEsperados() {
            Inventario inv = buildInventario("Omeprazol 20mg", 70, 14);
            when(inventarioRepository.buscarStock(any(), any(), any(), any()))
                    .thenReturn(List.of(inv));

            InventarioResponseDTO dto =
                    inventarioService.getStock(null, null, null, "omeprazol", null).get(0);

            assertThat(dto.getProductoNombre()).isEqualTo("Omeprazol 20mg");
            assertThat(dto.getStockActual()).isEqualTo(70);
            assertThat(dto.getStockMinimo()).isEqualTo(14);
            assertThat(dto.getBajoStock()).isFalse();         // 70 > 14
            assertThat(dto.getSucursalNombre()).isEqualTo("Farmacia Central");
            assertThat(dto.getNumeroLote()).isEqualTo("LOT-001");
            assertThat(dto.getPrecios()).isNotNull().isEmpty();
        }

        @Test
        @DisplayName("bajoStock=true cuando stockActual <= stockMinimo")
        void bajoStock_cuandoStockInsuficiente() {
            Inventario inv = buildInventario("Insulina NPH", 5, 10);   // 5 <= 10
            when(inventarioRepository.buscarStock(any(), any(), any(), any()))
                    .thenReturn(List.of(inv));

            InventarioResponseDTO dto =
                    inventarioService.getStock(null, null, null, null, null).get(0);

            assertThat(dto.getBajoStock()).isTrue();
        }

        @Test
        @DisplayName("bajoStock=false cuando stockActual > stockMinimo")
        void bajoStock_cuandoStockSuficiente() {
            Inventario inv = buildInventario("Enalapril 10mg", 100, 20);  // 100 > 20
            when(inventarioRepository.buscarStock(any(), any(), any(), any()))
                    .thenReturn(List.of(inv));

            InventarioResponseDTO dto =
                    inventarioService.getStock(null, null, null, null, null).get(0);

            assertThat(dto.getBajoStock()).isFalse();
        }
    }

    // ---------------------------------------------------------------
    // registrarEntrada
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("registrarEntrada")
    class RegistrarEntrada {

        @Test
        @DisplayName("stock 100 + entrada 50 → stock resultante 150")
        void conInventarioValido_incrementaStock() {
            Inventario inventario = buildInventario("Paracetamol", 100, 10);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            MovimientoResponseDTO response =
                    inventarioService.registrarEntrada(buildRequest(invId, 50));

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

            assertThatThrownBy(() ->
                    inventarioService.registrarEntrada(buildRequest(inventarioId, 10)))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Inventario");
        }
    }

    // ---------------------------------------------------------------
    // registrarSalida
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("registrarSalida")
    class RegistrarSalida {

        @Test
        @DisplayName("stock suficiente → decrementa correctamente")
        void conStockSuficiente_decrementa() {
            Inventario inventario = buildInventario("Ibuprofeno", 100, 10);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            MovimientoResponseDTO response =
                    inventarioService.registrarSalida(buildRequest(invId, 30));

            assertThat(inventario.getStockActual()).isEqualTo(70);
            assertThat(response.getTipo()).isEqualTo(TipoMovimiento.SALIDA);
            assertThat(response.getStockAnterior()).isEqualTo(100);
            assertThat(response.getStockResultante()).isEqualTo(70);
        }

        @Test
        @DisplayName("stock insuficiente y PERMITIR_VENTA_SIN_STOCK=false → BusinessException")
        void stockInsuficiente_noPermitido_lanzaException() {
            Inventario inventario = buildInventario("Amoxicilina", 5, 10);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);

            assertThatThrownBy(() ->
                    inventarioService.registrarSalida(buildRequest(invId, 10)))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Stock insuficiente")
                    .hasMessageContaining("5");

            verify(inventarioRepository, never()).save(any());
        }

        @Test
        @DisplayName("stock insuficiente y PERMITIR_VENTA_SIN_STOCK=true → permite stock negativo")
        void stockInsuficiente_permitido_decrementaANegativo() {
            Inventario inventario = buildInventario("Morfina", 3, 5);
            UUID invId = inventario.getId();

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(true);
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            inventarioService.registrarSalida(buildRequest(invId, 10));

            assertThat(inventario.getStockActual()).isEqualTo(-7);
        }
    }

    // ---------------------------------------------------------------
    // registrarAjuste
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("registrarAjuste")
    class RegistrarAjuste {

        @Test
        @DisplayName("ajuste con stockNuevo explícito → establece ese valor")
        void conStockNuevoExplicito_estableceNuevoStock() {
            Inventario inventario = buildInventario("Insulina", 50, 10);
            UUID invId = inventario.getId();
            MovimientoRequestDTO dto = buildRequest(invId, 0);
            dto.setStockNuevo(80);

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            MovimientoResponseDTO response = inventarioService.registrarAjuste(dto);

            assertThat(inventario.getStockActual()).isEqualTo(80);
            assertThat(response.getTipo()).isEqualTo(TipoMovimiento.AJUSTE);
            assertThat(response.getCantidad()).isEqualTo(30); // |80-50|
            assertThat(response.getStockResultante()).isEqualTo(80);
        }

        @Test
        @DisplayName("ajuste sin stockNuevo → usa cantidad como nuevo stock")
        void sinStockNuevo_usaCantidadComoNuevoStock() {
            Inventario inventario = buildInventario("Digoxina", 20, 5);
            UUID invId = inventario.getId();
            MovimientoRequestDTO dto = buildRequest(invId, 45);
            dto.setStockNuevo(null);

            when(inventarioRepository.findById(invId)).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            inventarioService.registrarAjuste(dto);

            assertThat(inventario.getStockActual()).isEqualTo(45);
        }
    }
}

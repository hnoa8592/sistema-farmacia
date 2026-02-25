package com.tecnoa.pos.modules.inventario;

import com.tecnoa.pos.config.TenantContext;
import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoRequestDTO;
import com.tecnoa.pos.modules.inventario.dto.MovimientoResponseDTO;
import com.tecnoa.pos.modules.inventario.model.TipoMovimiento;
import com.tecnoa.pos.modules.inventario.service.InventarioService;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ActiveProfiles;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Pruebas de integración para los flujos de inventario: entrada, salida y ajuste.
 *
 * Levanta el contexto completo de Spring contra una base de datos PostgreSQL real.
 * {@link ParametroService} se mockea para aislar el test de la tabla de parámetros.
 *
 * Requiere: base de datos farmacia_pos corriendo en localhost:5432
 * con el tenant farmacia_noa inicializado.
 */
@SpringBootTest
@ActiveProfiles("test")
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("InventarioService - Pruebas de Integración")
class InventarioIntegrationTest {

    private static final String TENANT = "farmacia_noa";

    @Autowired private InventarioService inventarioService;
    @Autowired private DataSource dataSource;

    /** Se mockea para no depender del estado de la tabla de parámetros en la BD de test. */
    @MockBean private ParametroService parametroService;

    // IDs únicos para todos los objetos creados en este test (evitan colisiones)
    private final UUID sucursalId    = UUID.randomUUID();
    private final UUID laboratorioId = UUID.randomUUID();
    private final UUID productoId    = UUID.randomUUID();
    private final UUID loteId        = UUID.randomUUID();
    private final UUID inventarioId  = UUID.randomUUID();

    // -----------------------------------------------------------------------
    // Setup / Teardown
    // -----------------------------------------------------------------------

    @BeforeAll
    void crearDatosDeTest() throws Exception {
        System.out.println("\n=== [SETUP] Creando datos de inventario para integración en " + TENANT + " ===");
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {
            // 1. Sucursal
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO sucursales (id, nombre, es_matriz, activo) VALUES (?::uuid, ?, false, true)")) {
                ps.setString(1, sucursalId.toString());
                ps.setString(2, "Sucursal Integración Test");
                ps.executeUpdate();
            }
            // 2. Laboratorio
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO laboratorios (id, nombre, activo) VALUES (?::uuid, ?, true)")) {
                ps.setString(1, laboratorioId.toString());
                ps.setString(2, "Laboratorio Integración Test");
                ps.executeUpdate();
            }
            // 3. Producto
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO productos (id, nombre, codigo, requiere_receta, controlado, activo) " +
                    "VALUES (?::uuid, ?, ?, false, false, true)")) {
                ps.setString(1, productoId.toString());
                ps.setString(2, "Producto Integración Test");
                ps.setString(3, "INTG-TEST-" + productoId.toString().substring(0, 8));
                ps.executeUpdate();
            }
            // 4. Lote del producto
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO producto_lotes (id, producto_id, laboratorio_id, numero_lote, " +
                    "fecha_vencimiento, cantidad_inicial, activo) " +
                    "VALUES (?::uuid, ?::uuid, ?::uuid, ?, '2028-12-31', 200, true)")) {
                ps.setString(1, loteId.toString());
                ps.setString(2, productoId.toString());
                ps.setString(3, laboratorioId.toString());
                ps.setString(4, "LOTE-INTG-001");
                ps.executeUpdate();
            }
            // 5. Registro de inventario con stock inicial = 100
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO inventario (id, lote_id, sucursal_id, stock_actual, stock_minimo) " +
                    "VALUES (?::uuid, ?::uuid, ?::uuid, 100, 10)")) {
                ps.setString(1, inventarioId.toString());
                ps.setString(2, loteId.toString());
                ps.setString(3, sucursalId.toString());
                ps.executeUpdate();
            }
        }
        TenantContext.clear();
        System.out.println("Datos creados: sucursal=" + sucursalId + ", inventario=" + inventarioId);
    }

    @AfterAll
    void eliminarDatosDeTest() throws Exception {
        System.out.println("\n=== [TEARDOWN] Limpiando datos de inventario ===");
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {
            conn.createStatement().executeUpdate(
                    "DELETE FROM movimientos_inventario WHERE inventario_id = '" + inventarioId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM inventario WHERE id = '" + inventarioId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM producto_lotes WHERE id = '" + loteId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM producto_precios WHERE producto_id = '" + productoId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM productos WHERE id = '" + productoId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM laboratorios WHERE id = '" + laboratorioId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM sucursales WHERE id = '" + sucursalId + "'");
        }
        TenantContext.clear();
        System.out.println("Datos de integración eliminados.");
    }

    @BeforeEach
    void resetearStockYConfiguracion() throws Exception {
        // Reinicia el stock a 100 antes de cada test para garantizar aislamiento
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {
            conn.createStatement().executeUpdate(
                    "UPDATE inventario SET stock_actual = 100 WHERE id = '" + inventarioId + "'");
        }
        // Stub por defecto: no se permiten ventas sin stock
        when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);
    }

    @AfterEach
    void limpiarTenantContext() {
        TenantContext.clear();
    }

    // -----------------------------------------------------------------------
    // Tests de registrarEntrada
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("Entrada de stock: stock 100 + entrada 50 → stock queda en 150")
    void registrarEntrada_incrementaStockCorrectamente() {
        MovimientoRequestDTO request = new MovimientoRequestDTO();
        request.setInventarioId(inventarioId);
        request.setCantidad(50);
        request.setObservacion("Recepción de mercadería");

        MovimientoResponseDTO response = inventarioService.registrarEntrada(request);

        assertThat(response.getTipo()).isEqualTo(TipoMovimiento.ENTRADA);
        assertThat(response.getCantidad()).isEqualTo(50);
        assertThat(response.getStockAnterior()).isEqualTo(100);
        assertThat(response.getStockResultante()).isEqualTo(150);
        assertThat(response.getInventarioId()).isEqualTo(inventarioId);

        // Verifica que el stock quedó persistido en la BD
        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks).hasSize(1);
        assertThat(stocks.get(0).getStockActual()).isEqualTo(150);
    }

    @Test
    @DisplayName("Múltiples entradas acumulan el stock correctamente")
    void registrarEntrada_multiplesEntradas_acumulanStock() {
        MovimientoRequestDTO request1 = new MovimientoRequestDTO();
        request1.setInventarioId(inventarioId);
        request1.setCantidad(30);

        MovimientoRequestDTO request2 = new MovimientoRequestDTO();
        request2.setInventarioId(inventarioId);
        request2.setCantidad(20);

        inventarioService.registrarEntrada(request1);
        inventarioService.registrarEntrada(request2);

        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks.get(0).getStockActual()).isEqualTo(150); // 100 + 30 + 20
    }

    @Test
    @DisplayName("Entrada a inventario inexistente → lanza ResourceNotFoundException")
    void registrarEntrada_inventarioInexistente_lanzaException() {
        MovimientoRequestDTO request = new MovimientoRequestDTO();
        request.setInventarioId(UUID.randomUUID()); // ID que no existe
        request.setCantidad(10);

        assertThatThrownBy(() -> inventarioService.registrarEntrada(request))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Inventario");
    }

    // -----------------------------------------------------------------------
    // Tests de registrarSalida
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("Salida de stock: stock 100 - salida 30 → stock queda en 70")
    void registrarSalida_decrementaStockCorrectamente() {
        MovimientoRequestDTO request = new MovimientoRequestDTO();
        request.setInventarioId(inventarioId);
        request.setCantidad(30);
        request.setObservacion("Consumo interno");

        MovimientoResponseDTO response = inventarioService.registrarSalida(request);

        assertThat(response.getTipo()).isEqualTo(TipoMovimiento.SALIDA);
        assertThat(response.getCantidad()).isEqualTo(30);
        assertThat(response.getStockAnterior()).isEqualTo(100);
        assertThat(response.getStockResultante()).isEqualTo(70);

        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks.get(0).getStockActual()).isEqualTo(70);
    }

    @Test
    @DisplayName("Salida exacta al stock disponible → stock queda en 0")
    void registrarSalida_salidaExactaAlStock_stockEnCero() {
        MovimientoRequestDTO request = new MovimientoRequestDTO();
        request.setInventarioId(inventarioId);
        request.setCantidad(100);

        MovimientoResponseDTO response = inventarioService.registrarSalida(request);

        assertThat(response.getStockResultante()).isZero();
        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks.get(0).getStockActual()).isZero();
    }

    @Test
    @DisplayName("Salida con stock insuficiente y venta sin stock desactivada → lanza BusinessException")
    void registrarSalida_stockInsuficiente_noPermitido_lanzaException() {
        when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);

        MovimientoRequestDTO request = new MovimientoRequestDTO();
        request.setInventarioId(inventarioId);
        request.setCantidad(200); // supera el stock de 100

        assertThatThrownBy(() -> inventarioService.registrarSalida(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Stock insuficiente");

        // Stock no debe haberse modificado
        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks.get(0).getStockActual()).isEqualTo(100);
    }

    @Test
    @DisplayName("Salida con stock insuficiente y venta sin stock activada → permite stock negativo")
    void registrarSalida_stockInsuficiente_permitido_decrementa() {
        when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(true);

        MovimientoRequestDTO request = new MovimientoRequestDTO();
        request.setInventarioId(inventarioId);
        request.setCantidad(150); // supera el stock de 100

        MovimientoResponseDTO response = inventarioService.registrarSalida(request);

        assertThat(response.getStockResultante()).isEqualTo(-50);
        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks.get(0).getStockActual()).isEqualTo(-50);
    }

    // -----------------------------------------------------------------------
    // Tests de registrarAjuste
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("Ajuste a valor explícito: stock 100 → ajuste a 75 → stock queda en 75")
    void registrarAjuste_conStockNuevo_estableceNuevoStock() {
        MovimientoRequestDTO request = new MovimientoRequestDTO();
        request.setInventarioId(inventarioId);
        request.setCantidad(1); // requerido por @Min(1), no se usa en ajuste con stockNuevo
        request.setStockNuevo(75);
        request.setObservacion("Conteo físico");

        MovimientoResponseDTO response = inventarioService.registrarAjuste(request);

        assertThat(response.getTipo()).isEqualTo(TipoMovimiento.AJUSTE);
        assertThat(response.getStockAnterior()).isEqualTo(100);
        assertThat(response.getStockResultante()).isEqualTo(75);
        assertThat(response.getCantidad()).isEqualTo(25); // |75 - 100|

        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks.get(0).getStockActual()).isEqualTo(75);
    }

    // -----------------------------------------------------------------------
    // Tests de getStock y listarMovimientos
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("getStock filtrando por productoId retorna el inventario correcto")
    void getStock_porProductoId_retornaInventarioCorrecto() {
        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);

        assertThat(stocks).hasSize(1);
        InventarioResponseDTO stock = stocks.get(0);
        assertThat(stock.getStockActual()).isEqualTo(100);
        assertThat(stock.getStockMinimo()).isEqualTo(10);
        assertThat(stock.getSucursalId()).isEqualTo(sucursalId);
        assertThat(stock.getLoteId()).isEqualTo(loteId);
    }

    @Test
    @DisplayName("getStock filtrando por sucursalId retorna el inventario correcto")
    void getStock_porSucursalId_retornaInventarioCorrecto() {
        List<InventarioResponseDTO> stocks = inventarioService.getStock(null, sucursalId, null);

        assertThat(stocks).isNotEmpty();
        assertThat(stocks).anyMatch(s -> s.getStockActual() == 100);
    }

    @Test
    @DisplayName("listarMovimientos registra historial completo de entrada y salida")
    void listarMovimientos_registraHistorialCompleto() {
        // Registrar dos movimientos: una entrada y una salida
        MovimientoRequestDTO entrada = new MovimientoRequestDTO();
        entrada.setInventarioId(inventarioId);
        entrada.setCantidad(40);
        entrada.setObservacion("Entrada de test");
        inventarioService.registrarEntrada(entrada);

        MovimientoRequestDTO salida = new MovimientoRequestDTO();
        salida.setInventarioId(inventarioId);
        salida.setCantidad(15);
        salida.setObservacion("Salida de test");
        inventarioService.registrarSalida(salida);

        // Listar movimientos del producto
        var movimientos = inventarioService.listarMovimientos(
                productoId, null, null, null, null, null, null,
                PageRequest.of(0, 50));

        assertThat(movimientos.getContent())
                .extracting(m -> m.getTipo())
                .contains(TipoMovimiento.ENTRADA, TipoMovimiento.SALIDA);

        // Stock final debe ser 100 + 40 - 15 = 125
        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks.get(0).getStockActual()).isEqualTo(125);
    }
}

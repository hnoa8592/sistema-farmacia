package com.tecnoa.pos.modules.ventas;

import com.tecnoa.pos.config.TenantContext;
import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.model.TipoPrecio;
import com.tecnoa.pos.modules.inventario.service.InventarioService;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.modules.ventas.dto.DetalleVentaDTO;
import com.tecnoa.pos.modules.ventas.dto.VentaRequestDTO;
import com.tecnoa.pos.modules.ventas.dto.VentaResponseDTO;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.service.VentaService;
import com.tecnoa.pos.shared.exception.BusinessException;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Pruebas de integración para el flujo de ventas: registro con 1 y N productos,
 * con y sin descuento, y anulación con reversión de stock.
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
@DisplayName("VentaService - Pruebas de Integración")
class VentaIntegrationTest {

    private static final String TENANT = "farmacia_noa";

    @Autowired private VentaService ventaService;
    @Autowired private InventarioService inventarioService;
    @Autowired private DataSource dataSource;

    /** Mockeado para no depender de la tabla de parámetros en la BD de test. */
    @MockBean private ParametroService parametroService;

    // IDs únicos por clase de test
    private final UUID sucursalId     = UUID.randomUUID();
    private final UUID laboratorioId  = UUID.randomUUID();

    // Producto A (precio 25.50 por UNIDAD)
    private final UUID productoAId    = UUID.randomUUID();
    private final UUID loteAId        = UUID.randomUUID();
    private final UUID inventarioAId  = UUID.randomUUID();
    private final UUID precioAId      = UUID.randomUUID();

    // Producto B (precio 10.00 por UNIDAD)
    private final UUID productoBId    = UUID.randomUUID();
    private final UUID loteBId        = UUID.randomUUID();
    private final UUID inventarioBId  = UUID.randomUUID();
    private final UUID precioBId      = UUID.randomUUID();

    // Producto C (precio 5.75 por UNIDAD)
    private final UUID productoCId    = UUID.randomUUID();
    private final UUID loteCId        = UUID.randomUUID();
    private final UUID inventarioCId  = UUID.randomUUID();
    private final UUID precioCId      = UUID.randomUUID();

    // -----------------------------------------------------------------------
    // Setup / Teardown
    // -----------------------------------------------------------------------

    @BeforeAll
    void crearDatosDeTest() throws Exception {
        System.out.println("\n=== [SETUP] Creando datos de ventas para integración en " + TENANT + " ===");
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {

            // Sucursal
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO sucursales (id, nombre, es_matriz, activo) VALUES (?::uuid, ?, false, true)")) {
                ps.setString(1, sucursalId.toString());
                ps.setString(2, "Sucursal Ventas Test");
                ps.executeUpdate();
            }

            // Laboratorio
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO laboratorios (id, nombre, activo) VALUES (?::uuid, ?, true)")) {
                ps.setString(1, laboratorioId.toString());
                ps.setString(2, "Lab Ventas Test");
                ps.executeUpdate();
            }

            // Producto A
            insertarProducto(conn, productoAId, "Producto Ventas A", "VENTA-A-" + productoAId.toString().substring(0, 8));
            insertarLote(conn, loteAId, productoAId, laboratorioId, "LOTE-VA-001");
            insertarInventario(conn, inventarioAId, loteAId, sucursalId, 200);
            insertarPrecio(conn, precioAId, productoAId, "25.50");

            // Producto B
            insertarProducto(conn, productoBId, "Producto Ventas B", "VENTA-B-" + productoBId.toString().substring(0, 8));
            insertarLote(conn, loteBId, productoBId, laboratorioId, "LOTE-VB-001");
            insertarInventario(conn, inventarioBId, loteBId, sucursalId, 200);
            insertarPrecio(conn, precioBId, productoBId, "10.00");

            // Producto C
            insertarProducto(conn, productoCId, "Producto Ventas C", "VENTA-C-" + productoCId.toString().substring(0, 8));
            insertarLote(conn, loteCId, productoCId, laboratorioId, "LOTE-VC-001");
            insertarInventario(conn, inventarioCId, loteCId, sucursalId, 200);
            insertarPrecio(conn, precioCId, productoCId, "5.75");
        }
        TenantContext.clear();
        System.out.println("Datos de ventas creados. Productos A/B/C con stock 200 cada uno.");
    }

    @AfterAll
    void eliminarDatosDeTest() throws Exception {
        System.out.println("\n=== [TEARDOWN] Limpiando datos de ventas ===");
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {
            String inventarioIds = "'" + inventarioAId + "','" + inventarioBId + "','" + inventarioCId + "'";

            // Recolectar IDs de ventas vinculadas a nuestros inventarios (residuos de tests fallidos)
            List<String> ventaIds = new java.util.ArrayList<>();
            try (java.sql.ResultSet rs = conn.createStatement().executeQuery(
                    "SELECT DISTINCT venta_id::text FROM detalle_ventas " +
                    "WHERE inventario_id IN (" + inventarioIds + ")")) {
                while (rs.next()) ventaIds.add(rs.getString(1));
            }

            // Eliminar en orden correcto (FK → padre)
            conn.createStatement().executeUpdate(
                    "DELETE FROM movimientos_inventario WHERE inventario_id IN (" + inventarioIds + ")");
            conn.createStatement().executeUpdate(
                    "DELETE FROM detalle_ventas WHERE inventario_id IN (" + inventarioIds + ")");
            if (!ventaIds.isEmpty()) {
                conn.createStatement().executeUpdate(
                        "DELETE FROM ventas WHERE id::text IN ('" + String.join("','", ventaIds) + "')");
            }
            conn.createStatement().executeUpdate(
                    "DELETE FROM inventario WHERE id IN (" + inventarioIds + ")");
            conn.createStatement().executeUpdate(
                    "DELETE FROM producto_lotes WHERE id IN ('" +
                    loteAId + "','" + loteBId + "','" + loteCId + "')");
            conn.createStatement().executeUpdate(
                    "DELETE FROM producto_precios WHERE id IN ('" +
                    precioAId + "','" + precioBId + "','" + precioCId + "')");
            conn.createStatement().executeUpdate(
                    "DELETE FROM productos WHERE id IN ('" +
                    productoAId + "','" + productoBId + "','" + productoCId + "')");
            conn.createStatement().executeUpdate(
                    "DELETE FROM laboratorios WHERE id = '" + laboratorioId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM sucursales WHERE id = '" + sucursalId + "'");
        }
        TenantContext.clear();
        System.out.println("Datos de ventas eliminados.");
    }

    @BeforeEach
    void resetearStockYMocks() throws Exception {
        // Reinicia el stock de los 3 productos a 200
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {
            conn.createStatement().executeUpdate(
                    "UPDATE inventario SET stock_actual = 200 WHERE id IN ('" +
                    inventarioAId + "','" + inventarioBId + "','" + inventarioCId + "')");
        }
        // Configuración por defecto de mocks
        when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);
        when(parametroService.getValorAsDecimal("MAX_DESCUENTO_PORCENTAJE")).thenReturn(new BigDecimal("30"));
    }

    @AfterEach
    void limpiarVentasYTenant() throws Exception {
        // Limpia las ventas y movimientos generados por cada test.
        // Orden: (1) recolectar IDs de ventas afectadas, (2) borrar detalles y movimientos,
        //        (3) borrar las ventas por sus IDs (evita problemas de FK y NOT IN vacío).
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {
            String inventarioIds = "'" + inventarioAId + "','" + inventarioBId + "','" + inventarioCId + "'";

            // Paso 1: recolectar los IDs de las ventas vinculadas a nuestros inventarios
            List<String> ventaIds = new java.util.ArrayList<>();
            try (java.sql.ResultSet rs = conn.createStatement().executeQuery(
                    "SELECT DISTINCT venta_id::text FROM detalle_ventas " +
                    "WHERE inventario_id IN (" + inventarioIds + ")")) {
                while (rs.next()) ventaIds.add(rs.getString(1));
            }

            // Paso 2: borrar movimientos y detalles de nuestros inventarios
            conn.createStatement().executeUpdate(
                    "DELETE FROM movimientos_inventario WHERE inventario_id IN (" + inventarioIds + ")");
            conn.createStatement().executeUpdate(
                    "DELETE FROM detalle_ventas WHERE inventario_id IN (" + inventarioIds + ")");

            // Paso 3: borrar las ventas recolectadas (sus detalles ya fueron borrados)
            if (!ventaIds.isEmpty()) {
                conn.createStatement().executeUpdate(
                        "DELETE FROM ventas WHERE id::text IN ('" +
                        String.join("','", ventaIds) + "')");
            }
        }
        TenantContext.clear();
    }

    // -----------------------------------------------------------------------
    // Helpers SQL
    // -----------------------------------------------------------------------

    private void insertarProducto(Connection conn, UUID id, String nombre, String codigo) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO productos (id, nombre, codigo, requiere_receta, controlado, activo) " +
                "VALUES (?::uuid, ?, ?, false, false, true)")) {
            ps.setString(1, id.toString());
            ps.setString(2, nombre);
            ps.setString(3, codigo);
            ps.executeUpdate();
        }
    }

    private void insertarLote(Connection conn, UUID id, UUID productoId, UUID laboratorioId, String numeroLote) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO producto_lotes (id, producto_id, laboratorio_id, numero_lote, " +
                "fecha_vencimiento, cantidad_inicial, activo) " +
                "VALUES (?::uuid, ?::uuid, ?::uuid, ?, '2028-12-31', 200, true)")) {
            ps.setString(1, id.toString());
            ps.setString(2, productoId.toString());
            ps.setString(3, laboratorioId.toString());
            ps.setString(4, numeroLote);
            ps.executeUpdate();
        }
    }

    private void insertarInventario(Connection conn, UUID id, UUID loteId, UUID sucursalId, int stockInicial) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO inventario (id, lote_id, sucursal_id, stock_actual, stock_minimo) " +
                "VALUES (?::uuid, ?::uuid, ?::uuid, ?, 5)")) {
            ps.setString(1, id.toString());
            ps.setString(2, loteId.toString());
            ps.setString(3, sucursalId.toString());
            ps.setInt(4, stockInicial);
            ps.executeUpdate();
        }
    }

    private void insertarPrecio(Connection conn, UUID id, UUID productoId, String precio) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO producto_precios (id, producto_id, tipo_precio, precio, vigencia_desde, activo) " +
                "VALUES (?::uuid, ?::uuid, 'UNIDAD', ?, NOW() - INTERVAL '1 day', true)")) {
            ps.setString(1, id.toString());
            ps.setString(2, productoId.toString());
            ps.setBigDecimal(3, new BigDecimal(precio));
            ps.executeUpdate();
        }
    }

    private DetalleVentaDTO detalle(UUID inventarioId, int cantidad) {
        DetalleVentaDTO dto = new DetalleVentaDTO();
        dto.setInventarioId(inventarioId);
        dto.setCantidad(cantidad);
        dto.setTipoPrecio(TipoPrecio.UNIDAD);
        return dto;
    }

    private int getStockActual(UUID productoId) {
        List<InventarioResponseDTO> stocks = inventarioService.getStock(productoId, null, null);
        assertThat(stocks).as("Debe existir inventario para productoId=" + productoId).isNotEmpty();
        return stocks.get(0).getStockActual();
    }

    // -----------------------------------------------------------------------
    // Tests de venta simple (1 producto)
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("Venta de 1 producto sin descuento → total correcto y stock decrementado")
    void venta_unProductoSinDescuento_totalCorrectoYStockDecrementa() {
        // Precio: 25.50, Cantidad: 4 → Total esperado: 102.00
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(detalle(inventarioAId, 4)));

        VentaResponseDTO response = ventaService.registrarVenta(request);

        assertThat(response.getEstado()).isEqualTo(EstadoVenta.COMPLETADA);
        assertThat(response.getTotal()).isEqualByComparingTo("102.00");
        assertThat(response.getDescuento()).isEqualByComparingTo("0");
        assertThat(response.getDetalles()).hasSize(1);
        assertThat(response.getId()).isNotNull();

        // Stock A debe haber bajado: 200 - 4 = 196
        assertThat(getStockActual(productoAId)).isEqualTo(196);
    }

    @Test
    @DisplayName("Venta de 1 producto con descuento 10% → total = subtotal × 0.90")
    void venta_unProductoConDescuento10_totalCorrecto() {
        // Precio: 10.00, Cantidad: 5 → Subtotal: 50.00
        // Descuento 10% = 5.00 → Total esperado: 45.00
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(detalle(inventarioBId, 5)));
        request.setDescuento(new BigDecimal("10"));

        VentaResponseDTO response = ventaService.registrarVenta(request);

        assertThat(response.getTotal()).isEqualByComparingTo("45.00");
        assertThat(response.getDescuento()).isEqualByComparingTo("10");
        assertThat(getStockActual(productoBId)).isEqualTo(195); // 200 - 5
    }

    // -----------------------------------------------------------------------
    // Tests de venta con N productos
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("Venta de 3 productos sin descuento → total = suma de subtotales y stocks decrementados")
    void venta_tresProductosSinDescuento_totalYStocksCorrectos() {
        // A: 25.50 × 2 =  51.00
        // B: 10.00 × 3 =  30.00
        // C:  5.75 × 4 =  23.00
        // Total esperado: 104.00
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(
                detalle(inventarioAId, 2),
                detalle(inventarioBId, 3),
                detalle(inventarioCId, 4)
        ));

        VentaResponseDTO response = ventaService.registrarVenta(request);

        assertThat(response.getEstado()).isEqualTo(EstadoVenta.COMPLETADA);
        assertThat(response.getTotal()).isEqualByComparingTo("104.00");
        assertThat(response.getDetalles()).hasSize(3);

        // Verificar stock de cada producto
        assertThat(getStockActual(productoAId)).isEqualTo(198); // 200 - 2
        assertThat(getStockActual(productoBId)).isEqualTo(197); // 200 - 3
        assertThat(getStockActual(productoCId)).isEqualTo(196); // 200 - 4
    }

    @Test
    @DisplayName("Venta de 3 productos con descuento 20% → total = (suma subtotales) × 0.80")
    void venta_tresProductosConDescuento20_totalCorrecto() {
        // A: 25.50 × 10 = 255.00
        // B: 10.00 ×  5 =  50.00
        // C:  5.75 ×  8 =  46.00
        // Subtotal total: 351.00 → descuento 20% = 70.20 → Total esperado: 280.80
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(
                detalle(inventarioAId, 10),
                detalle(inventarioBId, 5),
                detalle(inventarioCId, 8)
        ));
        request.setDescuento(new BigDecimal("20"));

        VentaResponseDTO response = ventaService.registrarVenta(request);

        assertThat(response.getTotal()).isEqualByComparingTo("280.80");
        assertThat(response.getDescuento()).isEqualByComparingTo("20");

        assertThat(getStockActual(productoAId)).isEqualTo(190); // 200 - 10
        assertThat(getStockActual(productoBId)).isEqualTo(195); // 200 - 5
        assertThat(getStockActual(productoCId)).isEqualTo(192); // 200 - 8
    }

    @Test
    @DisplayName("Venta de N productos con descuento máximo permitido → no lanza excepción")
    void venta_conDescuentoMaximoPermitido_seRegistra() {
        when(parametroService.getValorAsDecimal("MAX_DESCUENTO_PORCENTAJE")).thenReturn(new BigDecimal("30"));

        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(
                detalle(inventarioAId, 1),
                detalle(inventarioBId, 1)
        ));
        request.setDescuento(new BigDecimal("30")); // exactamente el máximo

        assertThatCode(() -> ventaService.registrarVenta(request))
                .doesNotThrowAnyException();
    }

    @Test
    @DisplayName("Venta con descuento superior al máximo → lanza BusinessException")
    void venta_conDescuentoSuperiorAlMaximo_lanzaException() {
        when(parametroService.getValorAsDecimal("MAX_DESCUENTO_PORCENTAJE")).thenReturn(new BigDecimal("15"));

        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(detalle(inventarioAId, 1)));
        request.setDescuento(new BigDecimal("16")); // supera el máximo de 15

        assertThatThrownBy(() -> ventaService.registrarVenta(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("descuento");

        // Stock no debe haberse modificado
        assertThat(getStockActual(productoAId)).isEqualTo(200);
    }

    @Test
    @DisplayName("Venta con stock insuficiente → lanza BusinessException y no modifica stock")
    void venta_stockInsuficiente_lanzaExceptionYNoModificaStock() {
        when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(false);

        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(detalle(inventarioAId, 999))); // supera los 200 disponibles

        assertThatThrownBy(() -> ventaService.registrarVenta(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Stock insuficiente");

        assertThat(getStockActual(productoAId)).isEqualTo(200);
    }

    // -----------------------------------------------------------------------
    // Tests de anulación de venta
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("Anular venta de 1 producto → estado ANULADA y stock revertido")
    void anularVenta_unProducto_revierteStockYCambiaEstado() {
        // Paso 1: registrar la venta
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(detalle(inventarioAId, 10)));
        VentaResponseDTO venta = ventaService.registrarVenta(request);

        assertThat(getStockActual(productoAId)).isEqualTo(190); // 200 - 10

        // Paso 2: anular la venta
        VentaResponseDTO ventaAnulada = ventaService.anularVenta(venta.getId());

        assertThat(ventaAnulada.getEstado()).isEqualTo(EstadoVenta.ANULADA);
        assertThat(getStockActual(productoAId)).isEqualTo(200); // stock revertido
    }

    @Test
    @DisplayName("Anular venta de N productos → stock de todos los productos revertido")
    void anularVenta_tresProductos_revierteStockDeTodos() {
        // Paso 1: registrar venta con 3 productos
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(
                detalle(inventarioAId, 5),
                detalle(inventarioBId, 8),
                detalle(inventarioCId, 12)
        ));
        VentaResponseDTO venta = ventaService.registrarVenta(request);

        assertThat(getStockActual(productoAId)).isEqualTo(195);
        assertThat(getStockActual(productoBId)).isEqualTo(192);
        assertThat(getStockActual(productoCId)).isEqualTo(188);

        // Paso 2: anular la venta
        VentaResponseDTO ventaAnulada = ventaService.anularVenta(venta.getId());

        assertThat(ventaAnulada.getEstado()).isEqualTo(EstadoVenta.ANULADA);
        // Stock completamente revertido
        assertThat(getStockActual(productoAId)).isEqualTo(200);
        assertThat(getStockActual(productoBId)).isEqualTo(200);
        assertThat(getStockActual(productoCId)).isEqualTo(200);
    }

    @Test
    @DisplayName("Anular venta de N productos con descuento → estado ANULADA y stock revertido")
    void anularVenta_conDescuento_revierteStockIndependientementeDelDescuento() {
        // El descuento no afecta la cantidad de stock a revertir
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(
                detalle(inventarioAId, 3),
                detalle(inventarioBId, 7)
        ));
        request.setDescuento(new BigDecimal("15"));
        VentaResponseDTO venta = ventaService.registrarVenta(request);

        // Paso 2: anular
        VentaResponseDTO ventaAnulada = ventaService.anularVenta(venta.getId());

        assertThat(ventaAnulada.getEstado()).isEqualTo(EstadoVenta.ANULADA);
        assertThat(getStockActual(productoAId)).isEqualTo(200);
        assertThat(getStockActual(productoBId)).isEqualTo(200);
    }

    @Test
    @DisplayName("Anular venta ya anulada → lanza BusinessException")
    void anularVentaYaAnulada_lanzaException() {
        VentaRequestDTO request = new VentaRequestDTO();
        request.setDetalles(List.of(detalle(inventarioAId, 1)));
        VentaResponseDTO venta = ventaService.registrarVenta(request);

        // Primera anulación: exitosa
        ventaService.anularVenta(venta.getId());

        // Segunda anulación: debe fallar
        assertThatThrownBy(() -> ventaService.anularVenta(venta.getId()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya está anulada");
    }
}

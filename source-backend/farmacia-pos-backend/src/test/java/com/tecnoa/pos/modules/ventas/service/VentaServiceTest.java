package com.tecnoa.pos.modules.ventas.service;

import com.tecnoa.pos.modules.inventario.model.*;
import com.tecnoa.pos.modules.inventario.repository.InventarioRepository;
import com.tecnoa.pos.modules.inventario.repository.MovimientoRepository;
import com.tecnoa.pos.modules.inventario.repository.ProductoPrecioRepository;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.modules.ventas.dto.DetalleVentaDTO;
import com.tecnoa.pos.modules.ventas.dto.VentaRequestDTO;
import com.tecnoa.pos.modules.ventas.dto.VentaResponseDTO;
import com.tecnoa.pos.modules.ventas.model.DetalleVenta;
import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.model.Venta;
import com.tecnoa.pos.modules.ventas.repository.VentaRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Pruebas unitarias para {@link VentaService}.
 * Valida la lógica de negocio de ventas: cálculo de totales, aplicación de
 * descuentos, descuento de stock, registro de movimientos y anulación.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("VentaService - Pruebas Unitarias")
class VentaServiceTest {

    @Mock private VentaRepository ventaRepository;
    @Mock private InventarioRepository inventarioRepository;
    @Mock private MovimientoRepository movimientoRepository;
    @Mock private ProductoPrecioRepository precioRepository;
    @Mock private ParametroService parametroService;

    @InjectMocks
    private VentaService ventaService;

    // -----------------------------------------------------------------------
    // Helpers de construcción de objetos de prueba
    // -----------------------------------------------------------------------

    /**
     * Crea un Inventario con stock dado, con toda la cadena
     * ProductoLote → Producto y Sucursal necesaria para el servicio.
     */
    private Inventario buildInventario(int stock) {
        Producto producto = new Producto();
        producto.setId(UUID.randomUUID());
        producto.setNombre("Ibuprofeno 400mg");
        producto.setCodigo("IBU-400");

        ProductoLote lote = new ProductoLote();
        lote.setId(UUID.randomUUID());
        lote.setNumeroLote("LOTE-V-001");
        lote.setProducto(producto);

        Sucursal sucursal = new Sucursal();
        sucursal.setId(UUID.randomUUID());
        sucursal.setNombre("Sucursal Principal");

        return Inventario.builder()
                .id(UUID.randomUUID())
                .lote(lote)
                .sucursal(sucursal)
                .stockActual(stock)
                .stockMinimo(5)
                .build();
    }

    private ProductoPrecio buildPrecio(UUID productoId, BigDecimal precio) {
        return ProductoPrecio.builder()
                .id(UUID.randomUUID())
                .precio(precio)
                .tipoPrecio(TipoPrecio.UNIDAD)
                .vigenciaDesde(LocalDateTime.now().minusDays(1))
                .activo(true)
                .build();
    }

    private DetalleVentaDTO buildDetalle(UUID inventarioId, int cantidad) {
        DetalleVentaDTO dto = new DetalleVentaDTO();
        dto.setInventarioId(inventarioId);
        dto.setCantidad(cantidad);
        dto.setTipoPrecio(TipoPrecio.UNIDAD);
        return dto;
    }

    /** Configura los stubs de ParametroService con los valores dados. */
    private void stubParametros(boolean permitirSinStock, String maxDescuento) {
        when(parametroService.getValorAsBoolean("PERMITIR_VENTA_SIN_STOCK")).thenReturn(permitirSinStock);
        when(parametroService.getValorAsDecimal("MAX_DESCUENTO_PORCENTAJE")).thenReturn(new BigDecimal(maxDescuento));
    }

    /** Hace que ventaRepository.save() devuelva el mismo objeto recibido. */
    private void stubVentaSave() {
        when(ventaRepository.save(any(Venta.class))).thenAnswer(inv -> inv.getArgument(0));
    }

    // -----------------------------------------------------------------------
    // registrarVenta
    // -----------------------------------------------------------------------

    @Nested
    @DisplayName("registrarVenta - cálculo de totales")
    class RegistrarVentaTotales {

        @Test
        @DisplayName("1 producto sin descuento → total = precio × cantidad")
        void unProductoSinDescuento_totalCorrecto() {
            // Precio: 10.00, Cantidad: 3 → Total esperado: 30.00
            Inventario inv = buildInventario(100);
            UUID prodId = inv.getLote().getProducto().getId();

            stubParametros(false, "20");
            when(inventarioRepository.findById(inv.getId())).thenReturn(Optional.of(inv));
            when(precioRepository.findPrecioVigente(eq(prodId), eq(TipoPrecio.UNIDAD), any()))
                    .thenReturn(Optional.of(buildPrecio(prodId, new BigDecimal("10.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(inv.getId(), 3)));

            VentaResponseDTO response = ventaService.registrarVenta(request);

            assertThat(response.getTotal()).isEqualByComparingTo("30.00");
            assertThat(response.getDescuento()).isEqualByComparingTo("0");
            assertThat(response.getEstado()).isEqualTo(EstadoVenta.COMPLETADA);
            assertThat(response.getDetalles()).hasSize(1);
        }

        @Test
        @DisplayName("3 productos sin descuento → total = suma de subtotales individuales")
        void tresProductosSinDescuento_sumaCorrectamente() {
            // A: 10.00 × 2 = 20.00
            // B:  5.50 × 4 = 22.00
            // C: 15.00 × 1 = 15.00
            // Total esperado: 57.00
            Inventario invA = buildInventario(50);
            Inventario invB = buildInventario(50);
            Inventario invC = buildInventario(50);

            UUID prodA = invA.getLote().getProducto().getId();
            UUID prodB = invB.getLote().getProducto().getId();
            UUID prodC = invC.getLote().getProducto().getId();

            stubParametros(false, "30");
            when(inventarioRepository.findById(invA.getId())).thenReturn(Optional.of(invA));
            when(inventarioRepository.findById(invB.getId())).thenReturn(Optional.of(invB));
            when(inventarioRepository.findById(invC.getId())).thenReturn(Optional.of(invC));
            when(precioRepository.findPrecioVigente(eq(prodA), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodA, new BigDecimal("10.00"))));
            when(precioRepository.findPrecioVigente(eq(prodB), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodB, new BigDecimal("5.50"))));
            when(precioRepository.findPrecioVigente(eq(prodC), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodC, new BigDecimal("15.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(
                    buildDetalle(invA.getId(), 2),
                    buildDetalle(invB.getId(), 4),
                    buildDetalle(invC.getId(), 1)
            ));

            VentaResponseDTO response = ventaService.registrarVenta(request);

            assertThat(response.getTotal()).isEqualByComparingTo("57.00");
            assertThat(response.getDetalles()).hasSize(3);
        }

        @Test
        @DisplayName("1 producto con descuento 10% → total = subtotal × 0.90")
        void unProductoConDescuento10Porciento_aplicaDescuento() {
            // Precio: 50.00, Cantidad: 2 → Subtotal: 100.00
            // Descuento 10% → Total esperado: 90.00
            Inventario inv = buildInventario(100);
            UUID prodId = inv.getLote().getProducto().getId();

            stubParametros(false, "20");
            when(inventarioRepository.findById(inv.getId())).thenReturn(Optional.of(inv));
            when(precioRepository.findPrecioVigente(eq(prodId), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodId, new BigDecimal("50.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(inv.getId(), 2)));
            request.setDescuento(new BigDecimal("10"));

            VentaResponseDTO response = ventaService.registrarVenta(request);

            assertThat(response.getTotal()).isEqualByComparingTo("90.00");
            assertThat(response.getDescuento()).isEqualByComparingTo("10");
        }

        @Test
        @DisplayName("3 productos con descuento 15% → total = (suma subtotales) × 0.85")
        void tresProductosConDescuento15_calculaTotalCorrecto() {
            // A: 20.00 × 3 =  60.00
            // B:  8.00 × 5 =  40.00
            // C: 30.00 × 1 =  30.00
            // Subtotal total: 130.00 → descuento 15% = 19.50 → Total esperado: 110.50
            Inventario invA = buildInventario(100);
            Inventario invB = buildInventario(100);
            Inventario invC = buildInventario(100);

            UUID prodA = invA.getLote().getProducto().getId();
            UUID prodB = invB.getLote().getProducto().getId();
            UUID prodC = invC.getLote().getProducto().getId();

            stubParametros(false, "30");
            when(inventarioRepository.findById(invA.getId())).thenReturn(Optional.of(invA));
            when(inventarioRepository.findById(invB.getId())).thenReturn(Optional.of(invB));
            when(inventarioRepository.findById(invC.getId())).thenReturn(Optional.of(invC));
            when(precioRepository.findPrecioVigente(eq(prodA), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodA, new BigDecimal("20.00"))));
            when(precioRepository.findPrecioVigente(eq(prodB), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodB, new BigDecimal("8.00"))));
            when(precioRepository.findPrecioVigente(eq(prodC), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodC, new BigDecimal("30.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(
                    buildDetalle(invA.getId(), 3),
                    buildDetalle(invB.getId(), 5),
                    buildDetalle(invC.getId(), 1)
            ));
            request.setDescuento(new BigDecimal("15"));

            VentaResponseDTO response = ventaService.registrarVenta(request);

            assertThat(response.getTotal()).isEqualByComparingTo("110.50");
        }

        @Test
        @DisplayName("descuento = 0 → no aplica ningún descuento al total")
        void descuentoCero_noAplicaDescuento() {
            Inventario inv = buildInventario(100);
            UUID prodId = inv.getLote().getProducto().getId();

            stubParametros(false, "20");
            when(inventarioRepository.findById(inv.getId())).thenReturn(Optional.of(inv));
            when(precioRepository.findPrecioVigente(eq(prodId), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodId, new BigDecimal("100.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(inv.getId(), 1)));
            request.setDescuento(BigDecimal.ZERO);

            VentaResponseDTO response = ventaService.registrarVenta(request);

            assertThat(response.getTotal()).isEqualByComparingTo("100.00");
        }
    }

    @Nested
    @DisplayName("registrarVenta - validaciones de negocio")
    class RegistrarVentaValidaciones {

        @Test
        @DisplayName("descuento supera el máximo configurado → lanza BusinessException")
        void descuentoSuperaMaximo_lanzaBusinessException() {
            stubParametros(false, "20");

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(UUID.randomUUID(), 1)));
            request.setDescuento(new BigDecimal("25")); // > máximo 20

            assertThatThrownBy(() -> ventaService.registrarVenta(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("descuento")
                    .hasMessageContaining("20");
        }

        @Test
        @DisplayName("stock insuficiente y PERMITIR_VENTA_SIN_STOCK=false → lanza BusinessException")
        void stockInsuficiente_noPermitido_lanzaBusinessException() {
            Inventario inv = buildInventario(2);

            stubParametros(false, "20");
            when(inventarioRepository.findById(inv.getId())).thenReturn(Optional.of(inv));

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(inv.getId(), 5)));

            assertThatThrownBy(() -> ventaService.registrarVenta(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Stock insuficiente");
        }

        @Test
        @DisplayName("inventario no encontrado → lanza ResourceNotFoundException")
        void inventarioNoEncontrado_lanzaException() {
            UUID inventarioId = UUID.randomUUID();

            stubParametros(false, "20");
            when(inventarioRepository.findById(inventarioId)).thenReturn(Optional.empty());

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(inventarioId, 1)));

            assertThatThrownBy(() -> ventaService.registrarVenta(request))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Inventario");
        }

        @Test
        @DisplayName("sin precio vigente para el tipo de precio → lanza BusinessException")
        void sinPrecioVigente_lanzaBusinessException() {
            Inventario inv = buildInventario(50);
            UUID prodId = inv.getLote().getProducto().getId();

            stubParametros(false, "20");
            when(inventarioRepository.findById(inv.getId())).thenReturn(Optional.of(inv));
            when(precioRepository.findPrecioVigente(eq(prodId), any(), any()))
                    .thenReturn(Optional.empty());

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(inv.getId(), 1)));

            assertThatThrownBy(() -> ventaService.registrarVenta(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("precio vigente");
        }

        @Test
        @DisplayName("PERMITIR_VENTA_SIN_STOCK=true → permite vender con stock insuficiente")
        void stockInsuficiente_permitido_procesaVenta() {
            Inventario inv = buildInventario(2);
            UUID prodId = inv.getLote().getProducto().getId();

            stubParametros(true, "20");
            when(inventarioRepository.findById(inv.getId())).thenReturn(Optional.of(inv));
            when(precioRepository.findPrecioVigente(eq(prodId), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodId, new BigDecimal("10.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(buildDetalle(inv.getId(), 5)));

            VentaResponseDTO response = ventaService.registrarVenta(request);

            assertThat(response.getEstado()).isEqualTo(EstadoVenta.COMPLETADA);
            assertThat(inv.getStockActual()).isEqualTo(-3); // stock negativo permitido
        }
    }

    @Nested
    @DisplayName("registrarVenta - efectos sobre stock y movimientos")
    class RegistrarVentaEfectos {

        @Test
        @DisplayName("descuenta el stock de cada producto incluido en la venta")
        void descontaStockPorCadaDetalle() {
            Inventario invA = buildInventario(100);
            Inventario invB = buildInventario(80);

            UUID prodA = invA.getLote().getProducto().getId();
            UUID prodB = invB.getLote().getProducto().getId();

            stubParametros(false, "30");
            when(inventarioRepository.findById(invA.getId())).thenReturn(Optional.of(invA));
            when(inventarioRepository.findById(invB.getId())).thenReturn(Optional.of(invB));
            when(precioRepository.findPrecioVigente(eq(prodA), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodA, new BigDecimal("10.00"))));
            when(precioRepository.findPrecioVigente(eq(prodB), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodB, new BigDecimal("10.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(
                    buildDetalle(invA.getId(), 10),
                    buildDetalle(invB.getId(), 20)
            ));

            ventaService.registrarVenta(request);

            assertThat(invA.getStockActual()).isEqualTo(90);
            assertThat(invB.getStockActual()).isEqualTo(60);
        }

        @Test
        @DisplayName("registra exactamente 1 movimiento SALIDA por cada detalle de la venta")
        void registraUnMovimientoSalidaPorDetalle() {
            Inventario invA = buildInventario(50);
            Inventario invB = buildInventario(50);
            Inventario invC = buildInventario(50);

            UUID prodA = invA.getLote().getProducto().getId();
            UUID prodB = invB.getLote().getProducto().getId();
            UUID prodC = invC.getLote().getProducto().getId();

            stubParametros(false, "30");
            when(inventarioRepository.findById(invA.getId())).thenReturn(Optional.of(invA));
            when(inventarioRepository.findById(invB.getId())).thenReturn(Optional.of(invB));
            when(inventarioRepository.findById(invC.getId())).thenReturn(Optional.of(invC));
            when(precioRepository.findPrecioVigente(eq(prodA), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodA, new BigDecimal("5.00"))));
            when(precioRepository.findPrecioVigente(eq(prodB), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodB, new BigDecimal("5.00"))));
            when(precioRepository.findPrecioVigente(eq(prodC), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodC, new BigDecimal("5.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(
                    buildDetalle(invA.getId(), 5),
                    buildDetalle(invB.getId(), 8),
                    buildDetalle(invC.getId(), 3)
            ));

            ventaService.registrarVenta(request);

            // 3 detalles → exactamente 3 movimientos de tipo SALIDA
            verify(movimientoRepository, times(3))
                    .save(argThat(m -> m.getTipo() == TipoMovimiento.SALIDA));
        }

        @Test
        @DisplayName("venta con N productos y descuento → cada detalle tiene su subtotal sin descuento")
        void ventaNProductosConDescuento_subTotalesIndividualesSinDescuento() {
            // El descuento se aplica sobre el total, NO sobre cada subtotal individual
            // Precio A: 20.00 × 1 = 20.00, Precio B: 30.00 × 2 = 60.00 → Total: 80.00
            // Descuento 25% → 80 * 0.75 = 60.00
            Inventario invA = buildInventario(50);
            Inventario invB = buildInventario(50);

            UUID prodA = invA.getLote().getProducto().getId();
            UUID prodB = invB.getLote().getProducto().getId();

            stubParametros(false, "30");
            when(inventarioRepository.findById(invA.getId())).thenReturn(Optional.of(invA));
            when(inventarioRepository.findById(invB.getId())).thenReturn(Optional.of(invB));
            when(precioRepository.findPrecioVigente(eq(prodA), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodA, new BigDecimal("20.00"))));
            when(precioRepository.findPrecioVigente(eq(prodB), any(), any()))
                    .thenReturn(Optional.of(buildPrecio(prodB, new BigDecimal("30.00"))));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            stubVentaSave();

            VentaRequestDTO request = new VentaRequestDTO();
            request.setDetalles(List.of(
                    buildDetalle(invA.getId(), 1),
                    buildDetalle(invB.getId(), 2)
            ));
            request.setDescuento(new BigDecimal("25"));

            VentaResponseDTO response = ventaService.registrarVenta(request);

            assertThat(response.getTotal()).isEqualByComparingTo("60.00");
            // Subtotales individuales sin descuento
            assertThat(response.getDetalles().get(0).getSubtotal()).isEqualByComparingTo("20.00");
            assertThat(response.getDetalles().get(1).getSubtotal()).isEqualByComparingTo("60.00");
        }
    }

    // -----------------------------------------------------------------------
    // anularVenta
    // -----------------------------------------------------------------------

    @Nested
    @DisplayName("anularVenta")
    class AnularVenta {

        @Test
        @DisplayName("venta COMPLETADA → cambia a ANULADA y revierte el stock de cada detalle")
        void ventaCompletada_revierteStockYCambiaEstado() {
            Inventario inventario = buildInventario(20);

            DetalleVenta detalle = DetalleVenta.builder()
                    .id(UUID.randomUUID())
                    .inventarioId(inventario.getId())
                    .productoId(inventario.getLote().getProducto().getId())
                    .loteId(inventario.getLote().getId())
                    .cantidad(5)
                    .precioUnitario(new BigDecimal("10.00"))
                    .subtotal(new BigDecimal("50.00"))
                    .tipoPrecio(TipoPrecio.UNIDAD)
                    .build();

            Venta venta = Venta.builder()
                    .id(UUID.randomUUID())
                    .total(new BigDecimal("50.00"))
                    .descuento(BigDecimal.ZERO)
                    .estado(EstadoVenta.COMPLETADA)
                    .detalles(new ArrayList<>(List.of(detalle)))
                    .build();
            detalle.setVenta(venta);

            when(ventaRepository.findById(venta.getId())).thenReturn(Optional.of(venta));
            when(inventarioRepository.findById(inventario.getId())).thenReturn(Optional.of(inventario));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(ventaRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            VentaResponseDTO response = ventaService.anularVenta(venta.getId());

            assertThat(response.getEstado()).isEqualTo(EstadoVenta.ANULADA);
            assertThat(inventario.getStockActual()).isEqualTo(25); // 20 + 5 revertidos
        }

        @Test
        @DisplayName("anulación de venta multi-producto → revierte stock de todos los detalles")
        void ventaConMultiplesDetalles_revierteStockDeTodos() {
            Inventario invA = buildInventario(40);
            Inventario invB = buildInventario(15);
            Inventario invC = buildInventario(70);

            DetalleVenta detalleA = DetalleVenta.builder()
                    .id(UUID.randomUUID()).inventarioId(invA.getId())
                    .productoId(invA.getLote().getProducto().getId())
                    .loteId(invA.getLote().getId()).cantidad(10)
                    .precioUnitario(new BigDecimal("5.00")).subtotal(new BigDecimal("50.00"))
                    .tipoPrecio(TipoPrecio.UNIDAD).build();

            DetalleVenta detalleB = DetalleVenta.builder()
                    .id(UUID.randomUUID()).inventarioId(invB.getId())
                    .productoId(invB.getLote().getProducto().getId())
                    .loteId(invB.getLote().getId()).cantidad(3)
                    .precioUnitario(new BigDecimal("20.00")).subtotal(new BigDecimal("60.00"))
                    .tipoPrecio(TipoPrecio.UNIDAD).build();

            DetalleVenta detalleC = DetalleVenta.builder()
                    .id(UUID.randomUUID()).inventarioId(invC.getId())
                    .productoId(invC.getLote().getProducto().getId())
                    .loteId(invC.getLote().getId()).cantidad(25)
                    .precioUnitario(new BigDecimal("2.00")).subtotal(new BigDecimal("50.00"))
                    .tipoPrecio(TipoPrecio.UNIDAD).build();

            Venta venta = Venta.builder()
                    .id(UUID.randomUUID()).total(new BigDecimal("160.00")).descuento(BigDecimal.ZERO)
                    .estado(EstadoVenta.COMPLETADA)
                    .detalles(new ArrayList<>(List.of(detalleA, detalleB, detalleC)))
                    .build();

            when(ventaRepository.findById(venta.getId())).thenReturn(Optional.of(venta));
            when(inventarioRepository.findById(invA.getId())).thenReturn(Optional.of(invA));
            when(inventarioRepository.findById(invB.getId())).thenReturn(Optional.of(invB));
            when(inventarioRepository.findById(invC.getId())).thenReturn(Optional.of(invC));
            when(inventarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(movimientoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(ventaRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            ventaService.anularVenta(venta.getId());

            assertThat(invA.getStockActual()).isEqualTo(50);  // 40 + 10
            assertThat(invB.getStockActual()).isEqualTo(18);  // 15 +  3
            assertThat(invC.getStockActual()).isEqualTo(95);  // 70 + 25

            // Exactamente 3 movimientos de ENTRADA (uno por detalle revertido)
            verify(movimientoRepository, times(3))
                    .save(argThat(m -> m.getTipo() == TipoMovimiento.ENTRADA));
        }

        @Test
        @DisplayName("venta ya ANULADA → lanza BusinessException")
        void ventaYaAnulada_lanzaBusinessException() {
            Venta venta = Venta.builder()
                    .id(UUID.randomUUID())
                    .estado(EstadoVenta.ANULADA)
                    .detalles(new ArrayList<>())
                    .build();

            when(ventaRepository.findById(venta.getId())).thenReturn(Optional.of(venta));

            assertThatThrownBy(() -> ventaService.anularVenta(venta.getId()))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("ya está anulada");

            verify(inventarioRepository, never()).save(any());
        }

        @Test
        @DisplayName("venta inexistente → lanza ResourceNotFoundException")
        void ventaNoEncontrada_lanzaResourceNotFoundException() {
            UUID ventaId = UUID.randomUUID();
            when(ventaRepository.findById(ventaId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> ventaService.anularVenta(ventaId))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Venta");
        }
    }
}

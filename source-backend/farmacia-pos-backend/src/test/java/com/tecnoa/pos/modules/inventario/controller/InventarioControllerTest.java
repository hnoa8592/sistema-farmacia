package com.tecnoa.pos.modules.inventario.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.service.InventarioService;
import com.tecnoa.pos.shared.dto.ApiResponse;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityFilterAutoConfiguration;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Pruebas de capa web para {@link InventarioController}.
 * Se usa {@code @WebMvcTest} con seguridad deshabilitada para validar:
 * - Binding correcto de query params
 * - Delegación al servicio con los argumentos esperados
 * - Serialización de la respuesta
 */
@WebMvcTest(
    controllers = InventarioController.class,
    excludeAutoConfiguration = {
        SecurityAutoConfiguration.class,
        SecurityFilterAutoConfiguration.class
    }
)
@DisplayName("InventarioController – GET /inventario/stock")
class InventarioControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private InventarioService inventarioService;

    // ---------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------

    private InventarioResponseDTO buildDTO(String productoNombre, int stockActual) {
        return InventarioResponseDTO.builder()
                .id(UUID.randomUUID())
                .productoId(UUID.randomUUID())
                .productoNombre(productoNombre)
                .sucursalId(UUID.randomUUID())
                .sucursalNombre("Farmacia Central")
                .loteId(UUID.randomUUID())
                .numeroLote("LOT-001")
                .stockActual(stockActual)
                .stockMinimo(10)
                .bajoStock(stockActual <= 10)
                .precios(List.of())
                .build();
    }

    // ---------------------------------------------------------------
    // Tests de respuesta básica
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("Respuesta HTTP")
    class RespuestaHttp {

        @Test
        @DisplayName("GET /stock sin parámetros → 200 OK con lista vacía")
        void sinParametros_retorna200() throws Exception {
            when(inventarioService.getStock(null, null, null, null, null))
                    .thenReturn(List.of());

            mockMvc.perform(get("/inventario/stock"))
                    .andExpect(status().isOk())
                    .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                    .andExpect(jsonPath("$.data").isArray())
                    .andExpect(jsonPath("$.data").isEmpty());
        }

        @Test
        @DisplayName("GET /stock → retorna productos en data[]")
        void conResultados_retornaListaEnData() throws Exception {
            List<InventarioResponseDTO> lista = List.of(
                    buildDTO("Paracetamol 500mg", 50),
                    buildDTO("Ibuprofeno 400mg",  30));
            when(inventarioService.getStock(null, null, null, null, null))
                    .thenReturn(lista);

            mockMvc.perform(get("/inventario/stock"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.data").isArray())
                    .andExpect(jsonPath("$.data.length()").value(2))
                    .andExpect(jsonPath("$.data[0].productoNombre").value("Paracetamol 500mg"))
                    .andExpect(jsonPath("$.data[1].productoNombre").value("Ibuprofeno 400mg"));
        }

        @Test
        @DisplayName("Mensaje de respuesta es 'Stock obtenido'")
        void retornaMensajeStockObtenido() throws Exception {
            when(inventarioService.getStock(any(), any(), any(), any(), any()))
                    .thenReturn(List.of());

            mockMvc.perform(get("/inventario/stock"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.message").value("Stock obtenido"));
        }
    }

    // ---------------------------------------------------------------
    // Tests de binding de parámetros
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("Binding de query params")
    class BindingDeParams {

        @Test
        @DisplayName("?productoNombre=para → delega productoNombre al servicio")
        void conProductoNombre_delegaAlServicio() throws Exception {
            when(inventarioService.getStock(null, null, null, "para", null))
                    .thenReturn(List.of(buildDTO("Paracetamol 500mg", 50)));

            mockMvc.perform(get("/inventario/stock")
                            .param("productoNombre", "para"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.data[0].productoNombre").value("Paracetamol 500mg"));

            verify(inventarioService).getStock(null, null, null, "para", null);
        }

        @Test
        @DisplayName("?soloConStock=true → delega soloConStock=true al servicio")
        void conSoloConStock_delegaAlServicio() throws Exception {
            when(inventarioService.getStock(null, null, null, null, true))
                    .thenReturn(List.of());

            mockMvc.perform(get("/inventario/stock")
                            .param("soloConStock", "true"))
                    .andExpect(status().isOk());

            verify(inventarioService).getStock(null, null, null, null, true);
        }

        @Test
        @DisplayName("?productoNombre=amox&soloConStock=true → delega ambos (flujo POS)")
        void flujoPos_nombreYSoloConStock() throws Exception {
            when(inventarioService.getStock(null, null, null, "amox", true))
                    .thenReturn(List.of(buildDTO("Amoxicilina 500mg", 40)));

            mockMvc.perform(get("/inventario/stock")
                            .param("productoNombre", "amox")
                            .param("soloConStock",   "true"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.data.length()").value(1))
                    .andExpect(jsonPath("$.data[0].productoNombre").value("Amoxicilina 500mg"));

            verify(inventarioService).getStock(null, null, null, "amox", true);
        }

        @Test
        @DisplayName("?sucursalId=<uuid>&productoNombre=met → delega ambos")
        void conSucursalIdYNombre_delegaAmbos() throws Exception {
            UUID sucursalId = UUID.randomUUID();
            when(inventarioService.getStock(null, sucursalId, null, "met", true))
                    .thenReturn(List.of(buildDTO("Metformina 500mg", 30)));

            mockMvc.perform(get("/inventario/stock")
                            .param("sucursalId",     sucursalId.toString())
                            .param("productoNombre", "met")
                            .param("soloConStock",   "true"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.data[0].productoNombre").value("Metformina 500mg"));

            verify(inventarioService).getStock(null, sucursalId, null, "met", true);
        }

        @Test
        @DisplayName("?productoId=<uuid> → delega productoId correctamente")
        void conProductoId_delegaCorrectamente() throws Exception {
            UUID productoId = UUID.randomUUID();
            when(inventarioService.getStock(productoId, null, null, null, null))
                    .thenReturn(List.of());

            mockMvc.perform(get("/inventario/stock")
                            .param("productoId", productoId.toString()))
                    .andExpect(status().isOk());

            verify(inventarioService).getStock(productoId, null, null, null, null);
        }

        @Test
        @DisplayName("?loteId=<uuid> → delega loteId correctamente")
        void conLoteId_delegaCorrectamente() throws Exception {
            UUID loteId = UUID.randomUUID();
            when(inventarioService.getStock(null, null, loteId, null, null))
                    .thenReturn(List.of());

            mockMvc.perform(get("/inventario/stock")
                            .param("loteId", loteId.toString()))
                    .andExpect(status().isOk());

            verify(inventarioService).getStock(null, null, loteId, null, null);
        }
    }

    // ---------------------------------------------------------------
    // Tests de campos del DTO en la respuesta
    // ---------------------------------------------------------------

    @Nested
    @DisplayName("Campos del DTO en la respuesta JSON")
    class CamposDTO {

        @Test
        @DisplayName("La respuesta incluye stockActual, bajoStock y sucursalNombre")
        void dto_incluyeCamposClave() throws Exception {
            InventarioResponseDTO dto = buildDTO("Losartan 50mg", 5); // 5 <= 10 → bajoStock=true
            when(inventarioService.getStock(any(), any(), any(), any(), any()))
                    .thenReturn(List.of(dto));

            mockMvc.perform(get("/inventario/stock"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.data[0].productoNombre").value("Losartan 50mg"))
                    .andExpect(jsonPath("$.data[0].stockActual").value(5))
                    .andExpect(jsonPath("$.data[0].bajoStock").value(true))
                    .andExpect(jsonPath("$.data[0].sucursalNombre").value("Farmacia Central"))
                    .andExpect(jsonPath("$.data[0].numeroLote").value("LOT-001"))
                    .andExpect(jsonPath("$.data[0].precios").isArray());
        }
    }
}

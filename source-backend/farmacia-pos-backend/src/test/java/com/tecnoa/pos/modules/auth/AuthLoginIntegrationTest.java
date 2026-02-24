package com.tecnoa.pos.modules.auth;

import com.tecnoa.pos.config.TenantContext;
import com.tecnoa.pos.modules.auth.dto.LoginRequestDTO;
import com.tecnoa.pos.modules.auth.dto.LoginResponseDTO;
import com.tecnoa.pos.shared.exception.BusinessException;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Test de integración contra PostgreSQL real.
 * Requiere: base de datos farmacia_pos corriendo en localhost:5432
 * con el tenant farmacia_noa ya inicializado.
 *
 * Usa @TestInstance(PER_CLASS) para poder usar @BeforeAll/@AfterAll
 * con métodos de instancia (y así poder inyectar beans con @Autowired).
 */
@SpringBootTest
@ActiveProfiles("test")
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("AuthService - Login Integration")
class AuthLoginIntegrationTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private static final String TENANT       = "farmacia_noa";
    private static final String TEST_EMAIL   = "admin-test@farmacia-integration.com";
    private static final String TEST_PASS    = "admin123";

    /** ID del usuario de prueba creado en @BeforeAll, para limpiarlo en @AfterAll */
    private UUID testUserId;

    // -----------------------------------------------------------------------
    // Setup / Teardown
    // -----------------------------------------------------------------------

    @BeforeAll
    void setupTestUser() throws Exception {
        System.out.println("\n=== [SETUP] Creando usuario de prueba en " + TENANT + " ===");

        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {

            // Diagnóstico: qué usuarios existen actualmente
            System.out.println("Usuarios actuales en " + TENANT + ":");
            try (ResultSet rs = conn.createStatement().executeQuery(
                    "SELECT email, activo FROM usuarios LIMIT 10")) {
                int cnt = 0;
                while (rs.next()) {
                    System.out.printf("  - email=%-40s activo=%s%n",
                            rs.getString(1), rs.getBoolean(2));
                    cnt++;
                }
                if (cnt == 0) System.out.println("  (ninguno — tabla vacía)");
            }

            // Diagnóstico: qué perfiles existen
            System.out.println("Perfiles disponibles en " + TENANT + ":");
            try (ResultSet rs = conn.createStatement().executeQuery(
                    "SELECT nombre, descripcion FROM perfiles")) {
                int cnt = 0;
                while (rs.next()) {
                    System.out.printf("  - %-20s %s%n", rs.getString(1), rs.getString(2));
                    cnt++;
                }
                if (cnt == 0) System.out.println("  (ninguno — ¿faltó ejecutar 04-seed-perfiles.sql?)");
            }

            // Limpiar usuario de prueba si quedó de una ejecución anterior
            conn.createStatement().executeUpdate(
                    "DELETE FROM usuario_perfiles WHERE usuario_id IN " +
                    "(SELECT id FROM usuarios WHERE email = '" + TEST_EMAIL + "')");
            conn.createStatement().executeUpdate(
                    "DELETE FROM usuarios WHERE email = '" + TEST_EMAIL + "'");

            // Insertar usuario de prueba con password BCrypt
            String hash = passwordEncoder.encode(TEST_PASS);
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO usuarios (nombre, email, password, activo) " +
                    "VALUES (?, ?, ?, true) RETURNING id::text")) {
                ps.setString(1, "Test Admin Integration");
                ps.setString(2, TEST_EMAIL);
                ps.setString(3, hash);
                try (ResultSet rs = ps.executeQuery()) {
                    assertThat(rs.next())
                            .as("INSERT de usuario de prueba debe retornar id")
                            .isTrue();
                    testUserId = UUID.fromString(rs.getString(1));
                }
            }
            System.out.println("Usuario creado: " + TEST_EMAIL + " (id=" + testUserId + ")");

            // Asignar perfil ADMIN
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO usuario_perfiles (usuario_id, perfil_id) " +
                    "SELECT ?, id FROM perfiles WHERE nombre = 'ADMIN' LIMIT 1")) {
                ps.setObject(1, testUserId);
                int rows = ps.executeUpdate();
                System.out.println("Perfil ADMIN asignado: " + rows + " fila(s)");
                if (rows == 0) {
                    System.out.println("  ADVERTENCIA: no se asignó perfil ADMIN (¿no existe en " + TENANT + "?)");
                }
            }
        }
        TenantContext.clear();
    }

    @AfterAll
    void cleanupTestUser() throws Exception {
        if (testUserId == null) return;
        System.out.println("\n=== [TEARDOWN] Eliminando usuario de prueba ===");
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection()) {
            conn.createStatement().executeUpdate(
                    "DELETE FROM usuario_perfiles WHERE usuario_id = '" + testUserId + "'");
            conn.createStatement().executeUpdate(
                    "DELETE FROM usuarios WHERE id = '" + testUserId + "'");
        }
        TenantContext.clear();
        System.out.println("Usuario eliminado: " + TEST_EMAIL);
    }

    @AfterEach
    void clearTenant() {
        TenantContext.clear();
    }

    // -----------------------------------------------------------------------
    // Tests del DataSource wrapper
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("DataSource: sin tenant → search_path apunta a public")
    void dataSource_noTenant_searchPathIsPublic() throws Exception {
        TenantContext.clear();
        try (Connection conn = dataSource.getConnection();
             ResultSet rs = conn.createStatement().executeQuery("SHOW search_path")) {
            rs.next();
            String searchPath = rs.getString(1);
            System.out.println("search_path (sin tenant): " + searchPath);
            assertThat(searchPath).contains("public");
        }
    }

    @Test
    @DisplayName("DataSource: con tenant → search_path apunta al schema del tenant")
    void dataSource_withTenant_searchPathIsTenantSchema() throws Exception {
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection();
             ResultSet rs = conn.createStatement().executeQuery("SHOW search_path")) {
            rs.next();
            String searchPath = rs.getString(1);
            System.out.println("search_path (con tenant): " + searchPath);
            assertThat(searchPath).contains(TENANT);
        }
    }

    @Test
    @DisplayName("DataSource: schema del tenant existe y tiene tabla usuarios")
    void dataSource_tenantSchema_hasUsuariosTable() throws Exception {
        TenantContext.setTenant(TENANT);
        try (Connection conn = dataSource.getConnection();
             ResultSet rs = conn.createStatement().executeQuery(
                     "SELECT COUNT(*) FROM information_schema.tables " +
                     "WHERE table_schema = '" + TENANT + "' AND table_name = 'usuarios'")) {
            rs.next();
            long count = rs.getLong(1);
            System.out.println("Tabla usuarios en " + TENANT + " existe: " + (count > 0));
            assertThat(count).isGreaterThan(0);
        }
    }

    @Test
    @DisplayName("TenantContext: el valor seteado es visible en el mismo hilo inmediatamente")
    void tenantContext_setIsImmediatelyVisible() {
        assertThat(TenantContext.getTenant()).isNull();

        TenantContext.setTenant(TENANT);
        assertThat(TenantContext.getTenant()).isEqualTo(TENANT);

        TenantContext.clear();
        assertThat(TenantContext.getTenant()).isNull();
    }

    // -----------------------------------------------------------------------
    // Tests del flujo de login completo
    // -----------------------------------------------------------------------

    @Test
    @DisplayName("Login: credenciales válidas retornan token JWT")
    void login_validCredentials_returnsToken() {
        LoginRequestDTO request = new LoginRequestDTO();
        request.setEmail(TEST_EMAIL);
        request.setPassword(TEST_PASS);
        request.setTenantId(TENANT);

        LoginResponseDTO response = authService.login(request);

        System.out.println("Token obtenido: " + response.getToken().substring(0, 20) + "...");
        System.out.println("Email:    " + response.getEmail());
        System.out.println("TenantId: " + response.getTenantId());
        System.out.println("Recursos: " + response.getRecursos());

        assertThat(response.getToken()).isNotBlank();
        assertThat(response.getEmail()).isEqualTo(TEST_EMAIL);
        assertThat(response.getTenantId()).isEqualTo(TENANT);
        assertThat(response.getRecursos()).isNotNull();
    }

    @Test
    @DisplayName("Login: contraseña incorrecta lanza BusinessException")
    void login_wrongPassword_throwsException() {
        LoginRequestDTO request = new LoginRequestDTO();
        request.setEmail(TEST_EMAIL);
        request.setPassword("wrong-password");
        request.setTenantId(TENANT);

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Credenciales inválidas");
    }

    @Test
    @DisplayName("Login: tenant inexistente lanza BusinessException")
    void login_invalidTenant_throwsException() {
        LoginRequestDTO request = new LoginRequestDTO();
        request.setEmail(TEST_EMAIL);
        request.setPassword(TEST_PASS);
        request.setTenantId("tenant_que_no_existe_xzy");

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Tenant no encontrado");
    }

    @Test
    @DisplayName("Login: usuario inexistente en el tenant lanza BusinessException")
    void login_unknownUser_throwsException() {
        LoginRequestDTO request = new LoginRequestDTO();
        request.setEmail("noexiste@farmacia.com");
        request.setPassword(TEST_PASS);
        request.setTenantId(TENANT);

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Credenciales inválidas");
    }

    @Test
    @DisplayName("Login: tenant farmacia_noa existe en public.tenants")
    void login_tenantExistsInPublicTenants() throws Exception {
        TenantContext.clear(); // sin tenant → search_path = public
        try (Connection conn = dataSource.getConnection();
             ResultSet rs = conn.createStatement().executeQuery(
                     "SELECT schema_name, activo FROM public.tenants " +
                     "WHERE schema_name = '" + TENANT + "'")) {
            assertThat(rs.next())
                    .as("El tenant " + TENANT + " debe existir en public.tenants")
                    .isTrue();
            System.out.println("Tenant '" + rs.getString(1) +
                               "' activo=" + rs.getBoolean(2));
        }
    }
}

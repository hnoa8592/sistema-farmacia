package com.tecnoa.pos.modules.tenant;

import com.tecnoa.pos.config.TenantContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Inicializa el schema de un nuevo tenant.
 * Las migraciones estructurales (V1-V6) las gestiona Flyway a través de {@link TenantFlywayMigrator}.
 * Los scripts de carga de productos (08-14) se ejecutan manualmente al crear el tenant.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TenantInitializer {

    private final TenantFlywayMigrator tenantFlywayMigrator;
    private final JdbcTemplate jdbcTemplate;

    public void initializeTenantSchema(String schemaName) {
        log.info("Initializing schema for tenant: {}", schemaName);
        try {
            tenantFlywayMigrator.migrate(schemaName);
            loadProductScripts(schemaName);
            log.info("Schema initialized successfully for tenant: {}", schemaName);
        } catch (Exception e) {
            log.error("Failed to initialize schema for tenant: {}", schemaName, e);
            throw new RuntimeException("Failed to initialize tenant schema: " + schemaName, e);
        }
    }

    private void loadProductScripts(String schemaName) {
        String[] productScripts = {
            "db/08-seed-productos-csv-staging.sql",
            "db/09-seed-productos-csv-principios-activos.sql",
            "db/10-seed-productos-csv-productos.sql",
            "db/11-seed-productos-csv-producto-principios-activos.sql",
            "db/12-seed-productos-csv-precios.sql",
            "db/13-seed-productos-csv-lotes-inventario.sql",
            "db/14-validacion-productos-csv.sql"
        };
        TenantContext.setTenant(schemaName);
        try {
            for (String scriptFile : productScripts) {
                try {
                    ClassPathResource res = new ClassPathResource(scriptFile);
                    String sql = res.getContentAsString(StandardCharsets.UTF_8);
                    sql = sql.replace("{SCHEMA}", schemaName);
                    executeSqlScript(sql, schemaName);
                } catch (IOException e) {
                    log.warn("Product script not found, skipping: {}", scriptFile);
                }
            }
        } finally {
            TenantContext.clear();
        }
    }

    private void executeSqlScript(String script, String schemaName) {
        for (String stmt : parseSqlStatements(script)) {
            String trimmed = stmt.trim();
            if (!trimmed.isEmpty()) {
                try {
                    jdbcTemplate.execute(trimmed);
                } catch (Exception e) {
                    log.warn("Statement warning for tenant {}: {}", schemaName, e.getMessage());
                }
            }
        }
    }

    private List<String> parseSqlStatements(String script) {
        List<String> result = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inDollarBlock = false;

        for (String line : script.split("\n")) {
            String trimmedLine = line.trim();
            if (trimmedLine.startsWith("--")) continue;

            int count = 0;
            int pos = 0;
            while ((pos = line.indexOf("$$", pos)) >= 0) { count++; pos += 2; }
            if (count % 2 != 0) inDollarBlock = !inDollarBlock;

            current.append(line).append("\n");

            if (!inDollarBlock && trimmedLine.endsWith(";")) {
                String stmt = current.toString().trim();
                if (!stmt.isEmpty()) result.add(stmt);
                current = new StringBuilder();
            }
        }
        String remaining = current.toString().trim();
        if (!remaining.isEmpty()) result.add(remaining);
        return result;
    }
}

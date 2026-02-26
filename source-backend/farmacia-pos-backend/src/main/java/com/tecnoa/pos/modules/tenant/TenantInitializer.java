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

@Slf4j
@Service
@RequiredArgsConstructor
public class TenantInitializer {

    private final JdbcTemplate jdbcTemplate;

    public void initializeTenantSchema(String schemaName) {
        log.info("Initializing schema for tenant: {}", schemaName);
        try {
            String template = loadTemplate();
            String script = template.replace("{SCHEMA}", schemaName);
            executeSqlScript(script, schemaName);
            initializeDefaultData(schemaName);
            log.info("Schema initialized successfully for tenant: {}", schemaName);
        } catch (Exception e) {
            log.error("Failed to initialize schema for tenant: {}", schemaName, e);
            throw new RuntimeException("Failed to initialize tenant schema: " + schemaName, e);
        }
    }

    private String loadTemplate() throws IOException {
        ClassPathResource resource = new ClassPathResource("db/02-tenant-schema-template.sql");
        return resource.getContentAsString(StandardCharsets.UTF_8);
    }

    private void executeSqlScript(String script, String schemaName) {
        List<String> statements = parseSqlStatements(script);
        for (String stmt : statements) {
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

    /**
     * Parsea un script SQL en statements individuales, manejando:
     * - Líneas de comentario (--) que se omiten antes de acumular
     * - Bloques DO $$ ... $$; de PL/pgSQL que contienen ; internos
     */
    private List<String> parseSqlStatements(String script) {
        List<String> result = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inDollarBlock = false;

        for (String line : script.split("\n")) {
            String trimmedLine = line.trim();

            // Omitir líneas que son solo comentarios
            if (trimmedLine.startsWith("--")) {
                continue;
            }

            // Rastrear apertura/cierre de bloques $$ (dollar-quoting de PostgreSQL)
            int count = 0;
            int pos = 0;
            while ((pos = line.indexOf("$$", pos)) >= 0) {
                count++;
                pos += 2;
            }
            if (count % 2 != 0) {
                inDollarBlock = !inDollarBlock;
            }

            current.append(line).append("\n");

            // Fin de statement: ; al final de la línea y fuera de un bloque $$
            if (!inDollarBlock && trimmedLine.endsWith(";")) {
                String stmt = current.toString().trim();
                if (!stmt.isEmpty()) {
                    result.add(stmt);
                }
                current = new StringBuilder();
            }
        }

        // Capturar cualquier statement sin ; final
        String remaining = current.toString().trim();
        if (!remaining.isEmpty()) {
            result.add(remaining);
        }

        return result;
    }

    private void initializeDefaultData(String schemaName) {
        // El DataSource wrapper lee TenantContext en cada getConnection()
        // para aplicar SET search_path al schema correcto
        TenantContext.setTenant(schemaName);
        try {
            String[] seedFiles = {
                "db/03-seed-recursos.sql",
                "db/04-seed-perfiles.sql",
                "db/05-seed-parametros.sql",
                "db/06-seed-catalogos.sql",
                "db/08-seed-productos-liname.sql",
                "db/09-seed-productos-liname-part2.sql",
                "db/09-seed-productos-liname-part2b.sql",
                "db/09-seed-productos-liname-part2c.sql"
            };
            for (String seedFile : seedFiles) {
                try {
                    ClassPathResource res = new ClassPathResource(seedFile);
                    String sql = res.getContentAsString(StandardCharsets.UTF_8);
                    sql = sql.replace("{SCHEMA}", schemaName);
                    executeSqlScript(sql, schemaName);
                } catch (IOException e) {
                    log.warn("Seed file not found: {}", seedFile);
                }
            }
        } finally {
            TenantContext.clear();
        }
    }
}

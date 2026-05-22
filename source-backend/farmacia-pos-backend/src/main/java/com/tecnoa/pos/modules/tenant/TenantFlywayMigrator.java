package com.tecnoa.pos.modules.tenant;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.output.MigrateResult;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class TenantFlywayMigrator {

    private final DataSource dataSource;

    public void migrate(String schemaName) {
        log.info("Applying Flyway migrations for tenant: {}", schemaName);
        try {
            Flyway flyway = Flyway.configure()
                    .dataSource(dataSource)
                    .schemas(schemaName)
                    .createSchemas(true)
                    .locations("classpath:db/migration/tenant")
                    .placeholderPrefix("{")
                    .placeholderSuffix("}")
                    .placeholders(Map.of("SCHEMA", schemaName))
                    .table("flyway_schema_history")
                    .validateOnMigrate(true)
                    .outOfOrder(false)
                    .load();

            MigrateResult result = flyway.migrate();
            log.info("Flyway applied {}/{} migration(s) to tenant '{}' — success: {}",
                    result.migrationsExecuted, result.migrations.size(), schemaName, result.success);
        } catch (Exception e) {
            log.error("Flyway migration failed for tenant '{}': {}", schemaName, e.getMessage(), e);
            throw new RuntimeException("Flyway migration failed for tenant: " + schemaName, e);
        }
    }
}

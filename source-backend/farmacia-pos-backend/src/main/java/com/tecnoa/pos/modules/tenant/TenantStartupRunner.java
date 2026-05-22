package com.tecnoa.pos.modules.tenant;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class TenantStartupRunner implements ApplicationRunner {

    private final TenantRepository tenantRepository;
    private final TenantFlywayMigrator tenantFlywayMigrator;

    @Override
    public void run(ApplicationArguments args) {
        List<Tenant> tenants = tenantRepository.findAll();
        log.info("Running Flyway startup migrations for {} tenant(s)", tenants.size());
        for (Tenant tenant : tenants) {
            if (Boolean.TRUE.equals(tenant.getActivo())) {
                try {
                    tenantFlywayMigrator.migrate(tenant.getSchemaName());
                } catch (Exception e) {
                    log.error("Startup migration failed for tenant '{}', skipping: {}",
                            tenant.getSchemaName(), e.getMessage());
                }
            }
        }
        log.info("Startup tenant migrations complete");
    }
}

package com.tecnoa.pos.config;

import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DelegatingDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * En lugar de usar la API de multi-tenancy de Hibernate (que entra en conflicto
 * con LocalContainerEntityManagerFactoryBean), se intercepta cada getConnection()
 * del pool y se ejecuta SET search_path ANTES de que Hibernate haga cualquier
 * consulta. PostgreSQL resuelve los nombres de tabla sin schema usando ese path.
 */
@Slf4j
@Configuration
public class TenantDataSourceConfig {

    /**
     * Pool HikariCP base, toma sus propiedades de spring.datasource.*
     * y spring.datasource.hikari.*
     */
    @Bean(name = "baseDataSource")
    @ConfigurationProperties("spring.datasource.hikari")
    public HikariDataSource baseDataSource(DataSourceProperties properties) {
        return properties.initializeDataSourceBuilder()
                .type(HikariDataSource.class)
                .build();
    }

    /**
     * DataSource primario que envuelve el pool base.
     * En cada getConnection() aplica SET search_path según TenantContext.
     */
    @Bean
    @Primary
    public DataSource dataSource(@Qualifier("baseDataSource") HikariDataSource base) {
        return new DelegatingDataSource(base) {
            @Override
            public Connection getConnection() throws SQLException {
                return applySchema(super.getConnection());
            }

            @Override
            public Connection getConnection(String username, String password) throws SQLException {
                return applySchema(super.getConnection(username, password));
            }
        };
    }

    private Connection applySchema(Connection conn) throws SQLException {
        String tenant = TenantContext.getTenant();
        String schema = (tenant != null && !tenant.isBlank()) ? tenant : "public";
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("SET search_path TO " + schema + ", public");
        }
        log.info("search_path set to: {}", schema);
        return conn;
    }
}

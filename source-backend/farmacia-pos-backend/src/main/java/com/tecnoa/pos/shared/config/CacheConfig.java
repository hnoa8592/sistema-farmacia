package com.tecnoa.pos.shared.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.caffeine.CaffeineCache;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;
import java.util.List;

/**
 * Configuración de caché con Caffeine.
 * Cada caché tiene su propio TTL y tamaño máximo según la volatilidad del dato.
 *
 * TTL largo (24h)  → datos estáticos: catálogos, sucursales, perfiles, recursos
 * TTL medio (30min) → datos semi-dinámicos: precios vigentes
 */
@Configuration
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager manager = new SimpleCacheManager();
        manager.setCaches(List.of(
            // Datos de configuración — cambian solo por acción de admin
            buildCache("parametros",           200, Duration.ofHours(24)),

            // Catálogos — prácticamente estáticos en operación normal
            buildCache("sucursales",            50, Duration.ofHours(24)),
            buildCache("categorias",           150, Duration.ofHours(24)),
            buildCache("formas-farmaceuticas", 150, Duration.ofHours(24)),
            buildCache("vias-administracion",  150, Duration.ofHours(24)),

            // Seguridad — solo cambian con operaciones de admin
            buildCache("perfiles",              50, Duration.ofHours(24)),
            buildCache("recursos",             300, Duration.ofHours(24)),

            // Precios — pueden cambiar durante el día pero no en cada venta
            buildCache("precios-producto",    1000, Duration.ofMinutes(30)),
            buildCache("precios-vigentes",    2000, Duration.ofMinutes(30))
        ));
        return manager;
    }

    private CaffeineCache buildCache(String name, int maxSize, Duration ttl) {
        return new CaffeineCache(name,
            Caffeine.newBuilder()
                .maximumSize(maxSize)
                .expireAfterWrite(ttl)
                .recordStats()
                .build());
    }
}

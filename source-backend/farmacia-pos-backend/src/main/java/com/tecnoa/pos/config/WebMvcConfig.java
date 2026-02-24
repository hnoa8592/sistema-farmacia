package com.tecnoa.pos.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    private final TenantInterceptor tenantInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // context-path=/api ya es eliminado por el DispatcherServlet,
        // por lo que los patrones van sin el prefijo /api
        registry.addInterceptor(tenantInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/auth/**", "/admin/**",
                        "/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**",
                        "/actuator/**");
    }
}

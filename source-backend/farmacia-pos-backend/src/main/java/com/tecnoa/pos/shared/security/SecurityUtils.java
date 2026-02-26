package com.tecnoa.pos.shared.security;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.UUID;

@Component
@RequiredArgsConstructor
public class SecurityUtils {

    private final JwtService jwtService;

    /**
     * Extrae el UUID del usuario autenticado desde el token JWT almacenado
     * como atributo de la request por {@link JwtAuthFilter}.
     *
     * @return UUID del usuario o {@code null} si no se puede resolver.
     */
    public UUID getCurrentUserId() {
        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs == null) return null;
            String token = (String) attrs.getRequest().getAttribute("jwtToken");
            if (token == null || token.isBlank()) return null;
            String userId = jwtService.extractUserId(token);
            return userId != null ? UUID.fromString(userId) : null;
        } catch (Exception e) {
            return null;
        }
    }
}

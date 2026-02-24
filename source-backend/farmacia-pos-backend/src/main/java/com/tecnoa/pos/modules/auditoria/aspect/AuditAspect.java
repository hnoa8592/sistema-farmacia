package com.tecnoa.pos.modules.auditoria.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tecnoa.pos.config.TenantContext;
import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.auditoria.model.AuditLog;
import com.tecnoa.pos.modules.auditoria.service.AuditService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.UUID;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class AuditAspect {

    private final AuditService auditService;
    private final ObjectMapper objectMapper;

    @Around("@annotation(auditable)")
    public Object audit(ProceedingJoinPoint joinPoint, Auditable auditable) throws Throwable {
        String usuarioEmail = null;
        UUID usuarioId = null;
        String ipOrigen = null;

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            usuarioEmail = auth.getName();
        }

        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                Object ipAttr = attrs.getRequest().getAttribute("clientIp");
                if (ipAttr != null) ipOrigen = ipAttr.toString();
            }
        } catch (Exception e) {
            log.debug("Could not get request attributes: {}", e.getMessage());
        }

        // Capturar tenant ANTES del método.
        // Para endpoints con TenantInterceptor ya estará seteado.
        // Para /auth/login (excluido del interceptor), el método lo setea internamente.
        final String tenantAntes = TenantContext.getTenant();

        String valorAnterior = null;
        Object resultado = null;

        try {
            resultado = joinPoint.proceed();

            // Después del proceed el tenant puede haber sido seteado por el propio método
            // (p.ej. login() setea el tenant y NO lo limpia, dejándolo para este punto).
            String tenantEfectivo = (tenantAntes != null)
                    ? tenantAntes
                    : TenantContext.getTenant();

            String valorNuevo = serializeToJson(resultado);

            AuditLog auditLog = AuditLog.builder()
                    .usuarioEmail(usuarioEmail)
                    .accion(auditable.accion())
                    .modulo(auditable.modulo())
                    .entidad(auditable.entidad())
                    .descripcion(auditable.descripcion())
                    .valorAnterior(valorAnterior)
                    .valorNuevo(valorNuevo)
                    .ipOrigen(ipOrigen)
                    .exitoso(true)
                    .build();

            auditService.registrar(auditLog, tenantEfectivo);

            // Limpiar el tenant si el método lo seteó internamente
            // (para endpoints con interceptor, afterCompletion() también lo limpiará — sin problema)
            TenantContext.clear();
            return resultado;

        } catch (Throwable ex) {
            // Mismo patrón: usar el tenant que fue seteado (antes o dentro del método)
            String tenantEfectivo = (tenantAntes != null)
                    ? tenantAntes
                    : TenantContext.getTenant();

            AuditLog auditLog = AuditLog.builder()
                    .usuarioEmail(usuarioEmail)
                    .accion(auditable.accion())
                    .modulo(auditable.modulo())
                    .entidad(auditable.entidad())
                    .descripcion(auditable.descripcion() + " - ERROR: " + ex.getMessage())
                    .ipOrigen(ipOrigen)
                    .exitoso(false)
                    .build();

            auditService.registrar(auditLog, tenantEfectivo);
            TenantContext.clear();
            throw ex;
        }
    }

    private String serializeToJson(Object obj) {
        if (obj == null) return null;
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (Exception e) {
            log.debug("Could not serialize audit value: {}", e.getMessage());
            return obj.toString();
        }
    }
}

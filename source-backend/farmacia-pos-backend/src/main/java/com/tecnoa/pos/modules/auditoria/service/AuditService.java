package com.tecnoa.pos.modules.auditoria.service;

import com.tecnoa.pos.config.TenantContext;
import com.tecnoa.pos.modules.auditoria.model.AuditLog;
import com.tecnoa.pos.modules.auditoria.repository.AuditLogRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuditService {

    private final AuditLogRepository auditLogRepository;

    /**
     * Guarda el log de auditoría de forma asíncrona en el schema del tenant.
     *
     * IMPORTANTE: No lleva @Transactional propio porque la anotación @Transactional
     * abre la conexión a BD ANTES de ejecutar el cuerpo del método, lo que haría
     * que TenantContext.setTenant() llegara tarde (la conexión ya estaría con
     * search_path=public). Al no ser transaccional, auditLogRepository.save()
     * abre su propia transacción DESPUÉS de que se seteó el tenant en este hilo.
     */
    @Async
    public void registrar(AuditLog auditLog, String tenantId) {
        if (tenantId == null || tenantId.isBlank()) {
            log.debug("Audit log omitido: sin tenant (accion={})", auditLog.getAccion());
            return;
        }
        TenantContext.setTenant(tenantId);
        try {
            auditLogRepository.save(auditLog);
        } catch (Exception e) {
            log.error("Error al registrar auditoría (tenant={}): {}", tenantId, e.getMessage(), e);
        } finally {
            TenantContext.clear();
        }
    }
}

package com.tecnoa.pos.modules.auditoria.repository;

import com.tecnoa.pos.modules.auditoria.model.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, UUID> {

    @Query("SELECT a FROM AuditLog a WHERE " +
           "(:usuarioId IS NULL OR a.usuarioId = :usuarioId) AND " +
           "(:modulo IS NULL OR a.modulo = :modulo) AND " +
           "(:entidad IS NULL OR a.entidad = :entidad) AND " +
           "(:accion IS NULL OR a.accion = :accion) AND " +
           "(:desde IS NULL OR a.fecha >= :desde) AND " +
           "(:hasta IS NULL OR a.fecha <= :hasta)")
    Page<AuditLog> findByFiltros(
            @Param("usuarioId") UUID usuarioId,
            @Param("modulo") String modulo,
            @Param("entidad") String entidad,
            @Param("accion") String accion,
            @Param("desde") LocalDateTime desde,
            @Param("hasta") LocalDateTime hasta,
            Pageable pageable);

    List<AuditLog> findByEntidadAndEntidadIdOrderByFechaDesc(String entidad, String entidadId);

    Page<AuditLog> findByUsuarioIdOrderByFechaDesc(UUID usuarioId, Pageable pageable);

    @Query("SELECT a.modulo, a.accion, COUNT(a) FROM AuditLog a " +
           "WHERE (:desde IS NULL OR a.fecha >= :desde) AND (:hasta IS NULL OR a.fecha <= :hasta) " +
           "GROUP BY a.modulo, a.accion ORDER BY a.modulo, a.accion")
    List<Object[]> findResumenByFechas(
            @Param("desde") LocalDateTime desde,
            @Param("hasta") LocalDateTime hasta);
}

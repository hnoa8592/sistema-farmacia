package com.tecnoa.pos.modules.caja.repository;

import com.tecnoa.pos.modules.caja.model.Caja;
import com.tecnoa.pos.modules.caja.model.EstadoCaja;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CajaRepository extends JpaRepository<Caja, UUID> {

    Optional<Caja> findBySucursalIdAndEstado(UUID sucursalId, EstadoCaja estado);

    boolean existsBySucursalIdAndEstado(UUID sucursalId, EstadoCaja estado);

    @Query("""
            SELECT c FROM Caja c
            WHERE c.sucursalId = :sucursalId
              AND c.estado = 'CERRADA'
              AND (CAST(:desde AS timestamp) IS NULL OR c.fechaApertura >= CAST(:desde AS timestamp))
              AND (CAST(:hasta AS timestamp) IS NULL OR c.fechaApertura <= CAST(:hasta AS timestamp))
            ORDER BY c.fechaApertura DESC
            """)
    Page<Caja> findHistorial(@Param("sucursalId") UUID sucursalId,
                              @Param("desde") LocalDateTime desde,
                              @Param("hasta") LocalDateTime hasta,
                              Pageable pageable);
}

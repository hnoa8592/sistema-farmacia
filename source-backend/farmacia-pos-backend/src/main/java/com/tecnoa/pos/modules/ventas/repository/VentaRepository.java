package com.tecnoa.pos.modules.ventas.repository;

import com.tecnoa.pos.modules.ventas.model.EstadoVenta;
import com.tecnoa.pos.modules.ventas.model.Venta;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.UUID;

@Repository
public interface VentaRepository extends JpaRepository<Venta, UUID> {

    @Query("""
            SELECT v FROM Venta v
            WHERE (:usuarioId IS NULL OR v.usuarioId = :usuarioId)
              AND (:estado    IS NULL OR v.estado    = :estado)
              AND (CAST(:desde AS timestamp)     IS NULL OR v.fecha    >= CAST(:desde AS timestamp))
              AND (CAST(:hasta AS timestamp)     IS NULL OR v.fecha    <= CAST(:hasta AS timestamp))
            ORDER BY v.fecha DESC
            """)
    Page<Venta> buscarConFiltros(@Param("usuarioId") UUID usuarioId,
                                 @Param("estado")    EstadoVenta estado,
                                 @Param("desde")     LocalDateTime desde,
                                 @Param("hasta")     LocalDateTime hasta,
                                 Pageable pageable);

    Page<Venta> findByFechaBetween(LocalDateTime desde, LocalDateTime hasta, Pageable pageable);
}

package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.MovimientoInventario;
import com.tecnoa.pos.modules.inventario.model.TipoMovimiento;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.UUID;

@Repository
public interface MovimientoRepository extends JpaRepository<MovimientoInventario, UUID> {

    @Query("SELECT m FROM MovimientoInventario m WHERE " +
           "(:productoId IS NULL OR m.productoId = :productoId) AND " +
           "(:sucursalId IS NULL OR m.sucursalId = :sucursalId) AND " +
           "(:loteId IS NULL OR m.loteId = :loteId) AND " +
           "(:tipo IS NULL OR m.tipo = :tipo) AND " +
           "(:usuarioId IS NULL OR m.usuarioId = :usuarioId) AND " +
           "(CAST(:desde AS timestamp) IS NULL OR m.fecha >= CAST(:desde AS timestamp)) AND " +
           "(CAST(:hasta AS timestamp) IS NULL OR m.fecha <= CAST(:hasta AS timestamp))")
    Page<MovimientoInventario> buscar(
            @Param("productoId") UUID productoId,
            @Param("sucursalId") UUID sucursalId,
            @Param("loteId") UUID loteId,
            @Param("tipo") TipoMovimiento tipo,
            @Param("usuarioId") UUID usuarioId,
            @Param("desde") LocalDateTime desde,
            @Param("hasta") LocalDateTime hasta,
            Pageable pageable);
}

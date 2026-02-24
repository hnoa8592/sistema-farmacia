package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.ProductoPrecio;
import com.tecnoa.pos.modules.inventario.model.TipoPrecio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ProductoPrecioRepository extends JpaRepository<ProductoPrecio, UUID> {
    List<ProductoPrecio> findByProductoIdAndActivoTrue(UUID productoId);

    @Query("SELECT pp FROM ProductoPrecio pp WHERE pp.producto.id = :productoId AND " +
           "pp.tipoPrecio = :tipo AND pp.activo = true AND " +
           "pp.vigenciaDesde <= :ahora AND (pp.vigenciaHasta IS NULL OR pp.vigenciaHasta >= :ahora)")
    Optional<ProductoPrecio> findPrecioVigente(
            @Param("productoId") UUID productoId,
            @Param("tipo") TipoPrecio tipo,
            @Param("ahora") LocalDateTime ahora);

    @Query("SELECT pp FROM ProductoPrecio pp WHERE pp.producto.id = :productoId AND " +
           "pp.tipoPrecio = :tipo AND pp.activo = true AND pp.vigenciaHasta IS NULL")
    Optional<ProductoPrecio> findPrecioActual(
            @Param("productoId") UUID productoId,
            @Param("tipo") TipoPrecio tipo);
}

package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.ProductoLote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface ProductoLoteRepository extends JpaRepository<ProductoLote, UUID> {
    List<ProductoLote> findByProductoIdAndActivoTrue(UUID productoId);
    boolean existsByProductoIdAndNumeroLote(UUID productoId, String numeroLote);

    @Query("SELECT l FROM ProductoLote l WHERE l.producto.id = :productoId AND " +
           "l.fechaVencimiento <= :fecha AND l.activo = true")
    List<ProductoLote> findProximosVencer(
            @Param("productoId") UUID productoId,
            @Param("fecha") LocalDate fecha);

    @Query("SELECT l FROM ProductoLote l WHERE l.producto.id = :productoId AND " +
           "l.fechaVencimiento < CURRENT_DATE AND l.activo = true")
    List<ProductoLote> findVencidos(@Param("productoId") UUID productoId);
}

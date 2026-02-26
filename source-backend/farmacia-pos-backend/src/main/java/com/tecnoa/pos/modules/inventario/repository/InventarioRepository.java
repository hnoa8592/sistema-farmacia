package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.Inventario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface InventarioRepository extends JpaRepository<Inventario, UUID> {
    Optional<Inventario> findByLoteIdAndSucursalId(UUID loteId, UUID sucursalId);
    List<Inventario> findByLoteId(UUID loteId);
    List<Inventario> findBySucursalId(UUID sucursalId);

    @Query("SELECT i FROM Inventario i WHERE i.stockActual <= i.stockMinimo")
    List<Inventario> findBajoStock();

    @Query("SELECT i FROM Inventario i WHERE i.lote.producto.id = :productoId")
    List<Inventario> findByProductoId(@Param("productoId") UUID productoId);

    /**
     * Búsqueda flexible de stock combinando múltiples filtros opcionales.
     * Los parámetros nulos se ignoran en el filtrado.
     * productoNombre aplica una búsqueda parcial case-insensitive (LIKE).
     */
    @Query("""
            SELECT i FROM Inventario i
            JOIN i.lote l
            JOIN l.producto p
            JOIN i.sucursal s
            WHERE (:productoId IS NULL OR p.id = :productoId)
              AND (:sucursalId IS NULL OR s.id = :sucursalId)
              AND (:loteId IS NULL OR l.id = :loteId)
              AND (:productoNombre IS NULL
                   OR LOWER(p.nombre) LIKE LOWER(CONCAT('%',  CAST(:productoNombre AS string), '%')))
            ORDER BY p.nombre ASC
            """)
    List<Inventario> buscarStock(@Param("productoId")     UUID productoId,
                                 @Param("sucursalId")     UUID sucursalId,
                                 @Param("loteId")         UUID loteId,
                                 @Param("productoNombre") String productoNombre);
}

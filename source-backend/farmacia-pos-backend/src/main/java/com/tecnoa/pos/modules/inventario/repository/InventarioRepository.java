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
}

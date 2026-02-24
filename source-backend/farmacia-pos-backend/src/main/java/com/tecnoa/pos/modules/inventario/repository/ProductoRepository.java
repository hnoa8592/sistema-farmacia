package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.Producto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ProductoRepository extends JpaRepository<Producto, UUID> {
    Optional<Producto> findByCodigoAndActivoTrue(String codigo);
    boolean existsByCodigo(String codigo);
    boolean existsByCodigoAndIdNot(String codigo, UUID id);

    @Query("SELECT p FROM Producto p WHERE p.activo = true AND " +
           "(:nombre IS NULL OR LOWER(p.nombre) LIKE LOWER(CONCAT('%',:nombre,'%'))) AND " +
           "(:categoriaId IS NULL OR p.categoria.id = :categoriaId) AND " +
           "(:requiereReceta IS NULL OR p.requiereReceta = :requiereReceta)")
    Page<Producto> buscar(
            @Param("nombre") String nombre,
            @Param("categoriaId") UUID categoriaId,
            @Param("requiereReceta") Boolean requiereReceta,
            Pageable pageable);
}

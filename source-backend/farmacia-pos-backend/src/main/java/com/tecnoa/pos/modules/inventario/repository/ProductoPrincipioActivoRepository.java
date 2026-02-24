package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.ProductoPrincipioActivo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ProductoPrincipioActivoRepository extends JpaRepository<ProductoPrincipioActivo, UUID> {
    List<ProductoPrincipioActivo> findByProductoId(UUID productoId);
    Optional<ProductoPrincipioActivo> findByProductoIdAndPrincipioActivoId(UUID productoId, UUID principioActivoId);
    boolean existsByProductoIdAndPrincipioActivoId(UUID productoId, UUID principioActivoId);
}

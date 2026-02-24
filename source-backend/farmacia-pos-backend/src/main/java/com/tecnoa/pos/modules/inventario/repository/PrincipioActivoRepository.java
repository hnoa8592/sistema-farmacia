package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.PrincipioActivo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface PrincipioActivoRepository extends JpaRepository<PrincipioActivo, UUID> {
    Optional<PrincipioActivo> findByNombre(String nombre);
    boolean existsByNombre(String nombre);
    Page<PrincipioActivo> findByActivoTrueAndNombreContainingIgnoreCase(String nombre, Pageable pageable);
    Page<PrincipioActivo> findByActivoTrue(Pageable pageable);
}

package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.ViaAdministracion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ViaAdministracionRepository extends JpaRepository<ViaAdministracion, UUID> {
    Optional<ViaAdministracion> findByNombre(String nombre);
    boolean existsByNombre(String nombre);
}

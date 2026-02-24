package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.Sucursal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SucursalRepository extends JpaRepository<Sucursal, UUID> {
    List<Sucursal> findByActivoTrue();
    Optional<Sucursal> findByEsMatrizTrueAndActivoTrue();
}

package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.Laboratorio;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface LaboratorioRepository extends JpaRepository<Laboratorio, UUID> {
    Page<Laboratorio> findByActivoTrue(Pageable pageable);
    Page<Laboratorio> findByActivoTrueAndNombreContainingIgnoreCase(String nombre, Pageable pageable);
    boolean existsByNombreIgnoreCase(String nombre);
}

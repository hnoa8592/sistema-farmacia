package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.FormaFarmaceutica;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface FormaFarmaceuticaRepository extends JpaRepository<FormaFarmaceutica, UUID> {
    Optional<FormaFarmaceutica> findByNombre(String nombre);
    boolean existsByNombre(String nombre);
}

package com.tecnoa.pos.modules.inventario.repository;

import com.tecnoa.pos.modules.inventario.model.CategoriaTerapeutica;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface CategoriaTerapeuticaRepository extends JpaRepository<CategoriaTerapeutica, UUID> {
    Optional<CategoriaTerapeutica> findByNombre(String nombre);
    boolean existsByNombre(String nombre);
}

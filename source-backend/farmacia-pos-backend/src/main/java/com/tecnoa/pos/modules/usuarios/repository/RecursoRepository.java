package com.tecnoa.pos.modules.usuarios.repository;

import com.tecnoa.pos.modules.usuarios.model.Recurso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface RecursoRepository extends JpaRepository<Recurso, UUID> {
    Optional<Recurso> findByNombre(String nombre);
    List<Recurso> findByModulo(String modulo);
}

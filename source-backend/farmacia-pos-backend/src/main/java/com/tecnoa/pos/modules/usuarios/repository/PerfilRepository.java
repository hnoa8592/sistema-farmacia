package com.tecnoa.pos.modules.usuarios.repository;

import com.tecnoa.pos.modules.usuarios.model.Perfil;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface PerfilRepository extends JpaRepository<Perfil, UUID> {
    Optional<Perfil> findByNombre(String nombre);
    boolean existsByNombre(String nombre);
}

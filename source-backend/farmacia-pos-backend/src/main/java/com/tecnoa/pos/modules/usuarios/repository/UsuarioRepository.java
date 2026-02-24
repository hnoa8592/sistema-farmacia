package com.tecnoa.pos.modules.usuarios.repository;

import com.tecnoa.pos.modules.usuarios.model.Usuario;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, UUID> {

    @Query("SELECT u from Usuario u where u.email = :email and u.activo=true ")
    Optional<Usuario> findByEmailAndActivoTrue(String email);

    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);

    Page<Usuario> findByActivoTrue(Pageable pageable);
}

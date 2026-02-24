package com.tecnoa.pos.modules.parametros.repository;

import com.tecnoa.pos.modules.parametros.model.Parametro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ParametroRepository extends JpaRepository<Parametro, UUID> {
    Optional<Parametro> findByClaveAndActivoTrue(String clave);
    List<Parametro> findByModuloAndActivoTrue(String modulo);
    List<Parametro> findByActivoTrue();
}

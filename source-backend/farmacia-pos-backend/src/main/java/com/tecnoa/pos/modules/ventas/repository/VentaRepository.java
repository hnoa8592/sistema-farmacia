package com.tecnoa.pos.modules.ventas.repository;

import com.tecnoa.pos.modules.ventas.model.Venta;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.UUID;

@Repository
public interface VentaRepository extends JpaRepository<Venta, UUID> {
    Page<Venta> findByUsuarioId(UUID usuarioId, Pageable pageable);
    Page<Venta> findByFechaBetween(LocalDateTime desde, LocalDateTime hasta, Pageable pageable);
}

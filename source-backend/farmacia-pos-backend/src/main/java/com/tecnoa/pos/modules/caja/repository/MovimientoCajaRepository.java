package com.tecnoa.pos.modules.caja.repository;

import com.tecnoa.pos.modules.caja.model.MovimientoCaja;
import com.tecnoa.pos.modules.caja.model.TipoMovimientoCaja;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface MovimientoCajaRepository extends JpaRepository<MovimientoCaja, UUID> {

    List<MovimientoCaja> findByCajaIdAndTipo(UUID cajaId, TipoMovimientoCaja tipo);

    List<MovimientoCaja> findByCajaIdOrderByFechaAsc(UUID cajaId);
}

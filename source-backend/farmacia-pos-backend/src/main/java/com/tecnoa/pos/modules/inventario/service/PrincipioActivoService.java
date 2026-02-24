package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.inventario.dto.PrincipioActivoDTO;
import com.tecnoa.pos.modules.inventario.model.PrincipioActivo;
import com.tecnoa.pos.modules.inventario.repository.PrincipioActivoRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PrincipioActivoService {

    private final PrincipioActivoRepository repository;

    public Page<PrincipioActivoDTO> listar(String nombre, Pageable pageable) {
        Page<PrincipioActivo> page = (nombre != null && !nombre.isBlank())
                ? repository.findByActivoTrueAndNombreContainingIgnoreCase(nombre, pageable)
                : repository.findByActivoTrue(pageable);
        return page.map(this::toDTO);
    }

    @Transactional
    public PrincipioActivoDTO crear(PrincipioActivoDTO dto) {
        if (repository.existsByNombre(dto.getNombre()))
            throw new BusinessException("Ya existe un principio activo con nombre: " + dto.getNombre());
        return toDTO(repository.save(
                PrincipioActivo.builder().nombre(dto.getNombre())
                        .descripcion(dto.getDescripcion()).activo(true).build()));
    }

    @Transactional
    public PrincipioActivoDTO actualizar(UUID id, PrincipioActivoDTO dto) {
        PrincipioActivo pa = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("PrincipioActivo", id));
        pa.setNombre(dto.getNombre());
        pa.setDescripcion(dto.getDescripcion());
        return toDTO(repository.save(pa));
    }

    @Transactional
    public void eliminar(UUID id) {
        PrincipioActivo pa = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("PrincipioActivo", id));
        pa.setActivo(false);
        repository.save(pa);
    }

    private PrincipioActivoDTO toDTO(PrincipioActivo pa) {
        return PrincipioActivoDTO.builder()
                .id(pa.getId()).nombre(pa.getNombre())
                .descripcion(pa.getDescripcion()).activo(pa.getActivo()).build();
    }
}

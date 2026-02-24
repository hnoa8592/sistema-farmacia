package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.inventario.dto.LaboratorioDTO;
import com.tecnoa.pos.modules.inventario.model.Laboratorio;
import com.tecnoa.pos.modules.inventario.repository.LaboratorioRepository;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LaboratorioService {

    private final LaboratorioRepository repository;

    public Page<LaboratorioDTO> listar(String nombre, Pageable pageable) {
        Page<Laboratorio> page = (nombre != null && !nombre.isBlank())
                ? repository.findByActivoTrueAndNombreContainingIgnoreCase(nombre, pageable)
                : repository.findByActivoTrue(pageable);
        return page.map(this::toDTO);
    }

    @Transactional
    public LaboratorioDTO crear(LaboratorioDTO dto) {
        return toDTO(repository.save(Laboratorio.builder()
                .nombre(dto.getNombre()).pais(dto.getPais())
                .direccion(dto.getDireccion()).telefono(dto.getTelefono())
                .email(dto.getEmail()).activo(true).build()));
    }

    @Transactional
    public LaboratorioDTO actualizar(UUID id, LaboratorioDTO dto) {
        Laboratorio lab = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Laboratorio", id));
        lab.setNombre(dto.getNombre());
        lab.setPais(dto.getPais());
        lab.setDireccion(dto.getDireccion());
        lab.setTelefono(dto.getTelefono());
        lab.setEmail(dto.getEmail());
        return toDTO(repository.save(lab));
    }

    @Transactional
    public void eliminar(UUID id) {
        Laboratorio lab = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Laboratorio", id));
        lab.setActivo(false);
        repository.save(lab);
    }

    private LaboratorioDTO toDTO(Laboratorio l) {
        return LaboratorioDTO.builder()
                .id(l.getId()).nombre(l.getNombre()).pais(l.getPais())
                .direccion(l.getDireccion()).telefono(l.getTelefono())
                .email(l.getEmail()).activo(l.getActivo()).build();
    }
}

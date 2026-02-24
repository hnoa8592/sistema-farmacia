package com.tecnoa.pos.modules.usuarios.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.usuarios.dto.PerfilRequestDTO;
import com.tecnoa.pos.modules.usuarios.dto.PerfilResponseDTO;
import com.tecnoa.pos.modules.usuarios.model.Perfil;
import com.tecnoa.pos.modules.usuarios.model.Recurso;
import com.tecnoa.pos.modules.usuarios.repository.PerfilRepository;
import com.tecnoa.pos.modules.usuarios.repository.RecursoRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PerfilService {

    private final PerfilRepository perfilRepository;
    private final RecursoRepository recursoRepository;

    public List<PerfilResponseDTO> listar() {
        return perfilRepository.findAll().stream().map(this::toResponse).collect(Collectors.toList());
    }

    public List<PerfilResponseDTO.RecursoDTO> listarRecursos() {
        return recursoRepository.findAll().stream()
                .map(r -> PerfilResponseDTO.RecursoDTO.builder()
                        .id(r.getId()).nombre(r.getNombre()).modulo(r.getModulo()).build())
                .collect(Collectors.toList());
    }

    @Auditable(accion = "CREAR", modulo = "PERFILES", entidad = "Perfil", descripcion = "Creación de perfil")
    @Transactional
    public PerfilResponseDTO crear(PerfilRequestDTO dto) {
        if (perfilRepository.existsByNombre(dto.getNombre())) {
            throw new BusinessException("Ya existe un perfil con nombre: " + dto.getNombre());
        }

        Set<Recurso> recursos = new HashSet<>();
        if (dto.getRecursoIds() != null) {
            for (UUID rid : dto.getRecursoIds()) {
                recursos.add(recursoRepository.findById(rid)
                        .orElseThrow(() -> new ResourceNotFoundException("Recurso", rid)));
            }
        }

        Perfil perfil = Perfil.builder()
                .nombre(dto.getNombre())
                .descripcion(dto.getDescripcion())
                .recursos(recursos)
                .build();

        return toResponse(perfilRepository.save(perfil));
    }

    @Auditable(accion = "EDITAR", modulo = "PERFILES", entidad = "Perfil", descripcion = "Actualización de perfil")
    @Transactional
    public PerfilResponseDTO actualizar(UUID id, PerfilRequestDTO dto) {
        Perfil perfil = perfilRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Perfil", id));

        perfil.setNombre(dto.getNombre());
        perfil.setDescripcion(dto.getDescripcion());

        if (dto.getRecursoIds() != null) {
            Set<Recurso> recursos = new HashSet<>();
            for (UUID rid : dto.getRecursoIds()) {
                recursos.add(recursoRepository.findById(rid)
                        .orElseThrow(() -> new ResourceNotFoundException("Recurso", rid)));
            }
            perfil.setRecursos(recursos);
        }

        return toResponse(perfilRepository.save(perfil));
    }

    @Auditable(accion = "EDITAR", modulo = "PERFILES", entidad = "Perfil", descripcion = "Asignación de recursos")
    @Transactional
    public PerfilResponseDTO asignarRecursos(UUID id, List<UUID> recursoIds) {
        Perfil perfil = perfilRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Perfil", id));

        Set<Recurso> recursos = new HashSet<>();
        for (UUID rid : recursoIds) {
            recursos.add(recursoRepository.findById(rid)
                    .orElseThrow(() -> new ResourceNotFoundException("Recurso", rid)));
        }
        perfil.setRecursos(recursos);
        return toResponse(perfilRepository.save(perfil));
    }

    private PerfilResponseDTO toResponse(Perfil p) {
        return PerfilResponseDTO.builder()
                .id(p.getId())
                .nombre(p.getNombre())
                .descripcion(p.getDescripcion())
                .recursos(p.getRecursos().stream()
                        .map(r -> PerfilResponseDTO.RecursoDTO.builder()
                                .id(r.getId()).nombre(r.getNombre()).modulo(r.getModulo()).build())
                        .collect(Collectors.toList()))
                .build();
    }
}

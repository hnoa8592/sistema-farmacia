package com.tecnoa.pos.modules.usuarios.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.usuarios.dto.PerfilResponseDTO;
import com.tecnoa.pos.modules.usuarios.dto.UsuarioRequestDTO;
import com.tecnoa.pos.modules.usuarios.dto.UsuarioResponseDTO;
import com.tecnoa.pos.modules.usuarios.model.Perfil;
import com.tecnoa.pos.modules.usuarios.model.Usuario;
import com.tecnoa.pos.modules.usuarios.repository.PerfilRepository;
import com.tecnoa.pos.modules.usuarios.repository.UsuarioRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final PerfilRepository perfilRepository;
    private final PasswordEncoder passwordEncoder;

    public Page<UsuarioResponseDTO> listar(Pageable pageable) {
        return usuarioRepository.findByActivoTrue(pageable).map(this::toResponse);
    }

    @Auditable(accion = "CREAR", modulo = "USUARIOS", entidad = "Usuario", descripcion = "Creación de usuario")
    @Transactional
    public UsuarioResponseDTO crear(UsuarioRequestDTO dto) {
        if (usuarioRepository.existsByEmail(dto.getEmail())) {
            throw new BusinessException("Ya existe un usuario con email: " + dto.getEmail());
        }

        Set<Perfil> perfiles = new HashSet<>();
        if (dto.getPerfilIds() != null) {
            for (UUID pid : dto.getPerfilIds()) {
                perfiles.add(perfilRepository.findById(pid)
                        .orElseThrow(() -> new ResourceNotFoundException("Perfil", pid)));
            }
        }

        Usuario usuario = Usuario.builder()
                .nombre(dto.getNombre())
                .email(dto.getEmail())
                .password(passwordEncoder.encode(dto.getPassword()))
                .activo(true)
                .perfiles(perfiles)
                .build();

        return toResponse(usuarioRepository.save(usuario));
    }

    @Auditable(accion = "EDITAR", modulo = "USUARIOS", entidad = "Usuario", descripcion = "Actualización de usuario")
    @Transactional
    public UsuarioResponseDTO actualizar(UUID id, UsuarioRequestDTO dto) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario", id));

        if (!usuario.getEmail().equals(dto.getEmail()) && usuarioRepository.existsByEmail(dto.getEmail())) {
            throw new BusinessException("Ya existe un usuario con email: " + dto.getEmail());
        }

        usuario.setNombre(dto.getNombre());
        usuario.setEmail(dto.getEmail());
        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            usuario.setPassword(passwordEncoder.encode(dto.getPassword()));
        }

        if (dto.getPerfilIds() != null) {
            Set<Perfil> perfiles = new HashSet<>();
            for (UUID pid : dto.getPerfilIds()) {
                perfiles.add(perfilRepository.findById(pid)
                        .orElseThrow(() -> new ResourceNotFoundException("Perfil", pid)));
            }
            usuario.setPerfiles(perfiles);
        }

        return toResponse(usuarioRepository.save(usuario));
    }

    @Auditable(accion = "ELIMINAR", modulo = "USUARIOS", entidad = "Usuario", descripcion = "Eliminación de usuario")
    @Transactional
    public void eliminar(UUID id) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario", id));
        usuario.setActivo(false);
        usuarioRepository.save(usuario);
    }

    @Transactional
    public UsuarioResponseDTO asignarPerfiles(UUID id, List<UUID> perfilIds) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario", id));

        Set<Perfil> perfiles = new HashSet<>();
        for (UUID pid : perfilIds) {
            perfiles.add(perfilRepository.findById(pid)
                    .orElseThrow(() -> new ResourceNotFoundException("Perfil", pid)));
        }
        usuario.setPerfiles(perfiles);
        return toResponse(usuarioRepository.save(usuario));
    }

    private UsuarioResponseDTO toResponse(Usuario u) {
        List<PerfilResponseDTO> perfiles = u.getPerfiles().stream()
                .map(p -> PerfilResponseDTO.builder()
                        .id(p.getId())
                        .nombre(p.getNombre())
                        .descripcion(p.getDescripcion())
                        .recursos(p.getRecursos().stream()
                                .map(r -> PerfilResponseDTO.RecursoDTO.builder()
                                        .id(r.getId())
                                        .nombre(r.getNombre())
                                        .modulo(r.getModulo())
                                        .build())
                                .collect(Collectors.toList()))
                        .build())
                .collect(Collectors.toList());

        return UsuarioResponseDTO.builder()
                .id(u.getId())
                .nombre(u.getNombre())
                .email(u.getEmail())
                .activo(u.getActivo())
                .createdAt(u.getCreatedAt())
                .perfiles(perfiles)
                .build();
    }
}

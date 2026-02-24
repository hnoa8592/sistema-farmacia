package com.tecnoa.pos.shared.security;

import com.tecnoa.pos.config.TenantContext;
import com.tecnoa.pos.modules.usuarios.model.Usuario;
import com.tecnoa.pos.modules.usuarios.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UsuarioRepository usuarioRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        String tenant = TenantContext.getTenant();
        log.debug("Loading user {} for tenant {}", email, tenant);

        Usuario usuario = usuarioRepository.findByEmailAndActivoTrue(email)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + email));

        List<SimpleGrantedAuthority> authorities = usuario.getPerfiles().stream()
                .flatMap(p -> p.getRecursos().stream())
                .map(r -> new SimpleGrantedAuthority(r.getNombre()))
                .distinct()
                .collect(Collectors.toList());

        return new User(usuario.getEmail(), usuario.getPassword(), authorities);
    }
}

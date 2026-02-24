package com.tecnoa.pos.modules.auth;

import com.tecnoa.pos.config.TenantContext;
import com.tecnoa.pos.modules.auth.dto.LoginRequestDTO;
import com.tecnoa.pos.modules.auth.dto.LoginResponseDTO;
import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.tenant.TenantRepository;
import com.tecnoa.pos.modules.usuarios.model.Usuario;
import com.tecnoa.pos.modules.usuarios.repository.UsuarioRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.security.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final TenantRepository tenantRepository;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;

    @Auditable(accion = "LOGIN", modulo = "AUTH", entidad = "Usuario", descripcion = "Login de usuario")
    public LoginResponseDTO login(LoginRequestDTO request) {
        TenantContext.setTenant(request.getTenantId());
        tenantRepository.findBySchemaNameAndActivoTrue(request.getTenantId())
                .orElseThrow(() -> new BusinessException(
                        "Tenant no encontrado o inactivo: " + request.getTenantId()));


        // TenantContext is intentionally NOT cleared here.
        // The @AuditAspect reads the tenant after this method returns and
        // is responsible for cleanup via TenantContext.clear().
        // TenantInterceptor.afterCompletion() also clears it for HTTP requests.

        Usuario usuario = usuarioRepository.findByEmailAndActivoTrue(request.getEmail())
                .orElseThrow(() -> new BusinessException("Credenciales inválidas"));

        if (!passwordEncoder.matches(request.getPassword(), usuario.getPassword())) {
            throw new BusinessException("Credenciales inválidas");
        }

        List<String> recursos = usuario.getPerfiles().stream()
                .flatMap(p -> p.getRecursos().stream())
                .map(r -> r.getNombre())
                .distinct()
                .collect(Collectors.toList());

        String token = jwtService.generateToken(
                usuario.getId(), usuario.getEmail(), request.getTenantId(), recursos);

        return LoginResponseDTO.builder()
                .token(token)
                .userId(usuario.getId())
                .email(usuario.getEmail())
                .nombre(usuario.getNombre())
                .tenantId(request.getTenantId())
                .recursos(recursos)
                .build();
    }
}

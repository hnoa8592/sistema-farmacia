package com.tecnoa.pos.modules.tenant;

import com.tecnoa.pos.modules.tenant.dto.TenantRequestDTO;
import com.tecnoa.pos.modules.tenant.dto.TenantResponseDTO;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TenantService {

    private final TenantRepository tenantRepository;
    private final TenantInitializer tenantInitializer;

    @Transactional
    public TenantResponseDTO crear(TenantRequestDTO dto) {
        if (tenantRepository.existsBySchemaName(dto.getSchemaName())) {
            throw new BusinessException("Ya existe un tenant con schemaName: " + dto.getSchemaName());
        }
        Tenant tenant = Tenant.builder()
                .nombre(dto.getNombre())
                .schemaName(dto.getSchemaName())
                .activo(true)
                .build();
        tenant = tenantRepository.save(tenant);
        tenantInitializer.initializeTenantSchema(tenant.getSchemaName());
        return toResponse(tenant);
    }

    public List<TenantResponseDTO> listar() {
        return tenantRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public TenantResponseDTO actualizar(UUID id, TenantRequestDTO dto) {
        Tenant tenant = tenantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Tenant", id));
        tenant.setNombre(dto.getNombre());
        return toResponse(tenantRepository.save(tenant));
    }

    @Transactional
    public void desactivar(UUID id) {
        Tenant tenant = tenantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Tenant", id));
        tenant.setActivo(false);
        tenantRepository.save(tenant);
    }

    private TenantResponseDTO toResponse(Tenant t) {
        return TenantResponseDTO.builder()
                .id(t.getId())
                .nombre(t.getNombre())
                .schemaName(t.getSchemaName())
                .activo(t.getActivo())
                .createdAt(t.getCreatedAt())
                .build();
    }
}

package com.tecnoa.pos.modules.parametros.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.parametros.dto.ParametroResponseDTO;
import com.tecnoa.pos.modules.parametros.model.Parametro;
import com.tecnoa.pos.modules.parametros.repository.ParametroRepository;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ParametroService {

    private final ParametroRepository parametroRepository;

    @Cacheable(value = "parametros", key = "#clave")
    public String getValor(String clave) {
        return parametroRepository.findByClaveAndActivoTrue(clave)
                .orElseThrow(() -> new BusinessException("Parámetro no encontrado: " + clave))
                .getValor();
    }

    public Integer getValorAsInteger(String clave) {
        return Integer.parseInt(getValor(clave));
    }

    public BigDecimal getValorAsDecimal(String clave) {
        return new BigDecimal(getValor(clave));
    }

    public Boolean getValorAsBoolean(String clave) {
        return Boolean.parseBoolean(getValor(clave));
    }

    public List<ParametroResponseDTO> getByModulo(String modulo) {
        return parametroRepository.findByModuloAndActivoTrue(modulo)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    public List<ParametroResponseDTO> getAll() {
        return parametroRepository.findByActivoTrue()
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Auditable(accion = "EDITAR", modulo = "PARAMETROS", entidad = "Parametro",
               descripcion = "Actualización de parámetro")
    @Transactional
    @CacheEvict(value = "parametros", key = "#clave")
    public ParametroResponseDTO actualizar(String clave, String nuevoValor, String usuarioEmail) {
        Parametro parametro = parametroRepository.findByClaveAndActivoTrue(clave)
                .orElseThrow(() -> new ResourceNotFoundException("Parámetro", clave));

        if (!parametro.getEditable()) {
            throw new BusinessException("El parámetro '" + clave + "' no es editable");
        }

        parametro.setValor(nuevoValor);
        parametro.setUpdatedAt(LocalDateTime.now());
        parametro.setUpdatedBy(usuarioEmail);

        return toResponse(parametroRepository.save(parametro));
    }

    private ParametroResponseDTO toResponse(Parametro p) {
        return ParametroResponseDTO.builder()
                .id(p.getId())
                .clave(p.getClave())
                .valor(p.getValor())
                .descripcion(p.getDescripcion())
                .tipo(p.getTipo())
                .modulo(p.getModulo())
                .editable(p.getEditable())
                .activo(p.getActivo())
                .updatedAt(p.getUpdatedAt())
                .updatedBy(p.getUpdatedBy())
                .build();
    }
}

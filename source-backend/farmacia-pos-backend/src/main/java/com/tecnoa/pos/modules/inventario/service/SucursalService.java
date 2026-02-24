package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.inventario.dto.SucursalDTO;
import com.tecnoa.pos.modules.inventario.model.Sucursal;
import com.tecnoa.pos.modules.inventario.repository.InventarioRepository;
import com.tecnoa.pos.modules.inventario.repository.SucursalRepository;
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
public class SucursalService {

    private final SucursalRepository sucursalRepository;
    private final InventarioRepository inventarioRepository;

    public List<SucursalDTO> listar() {
        return sucursalRepository.findByActivoTrue().stream().map(this::toDTO).collect(Collectors.toList());
    }

    @Transactional
    public SucursalDTO crear(SucursalDTO dto) {
        return toDTO(sucursalRepository.save(Sucursal.builder()
                .nombre(dto.getNombre()).direccion(dto.getDireccion())
                .telefono(dto.getTelefono())
                .esMatriz(dto.getEsMatriz() != null ? dto.getEsMatriz() : false)
                .activo(true).build()));
    }

    @Transactional
    public SucursalDTO actualizar(UUID id, SucursalDTO dto) {
        Sucursal s = sucursalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sucursal", id));
        s.setNombre(dto.getNombre());
        s.setDireccion(dto.getDireccion());
        s.setTelefono(dto.getTelefono());
        return toDTO(sucursalRepository.save(s));
    }

    @Transactional
    public void eliminar(UUID id) {
        Sucursal s = sucursalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sucursal", id));
        boolean tieneStock = inventarioRepository.findBySucursalId(id)
                .stream().anyMatch(inv -> inv.getStockActual() > 0);
        if (tieneStock) {
            throw new BusinessException("No se puede desactivar la sucursal porque tiene inventario con stock activo");
        }
        s.setActivo(false);
        sucursalRepository.save(s);
    }

    private SucursalDTO toDTO(Sucursal s) {
        return SucursalDTO.builder()
                .id(s.getId()).nombre(s.getNombre()).direccion(s.getDireccion())
                .telefono(s.getTelefono()).esMatriz(s.getEsMatriz()).activo(s.getActivo()).build();
    }
}

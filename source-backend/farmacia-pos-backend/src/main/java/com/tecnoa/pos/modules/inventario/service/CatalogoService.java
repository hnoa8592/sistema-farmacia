package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.inventario.dto.CatalogoDTO;
import com.tecnoa.pos.modules.inventario.model.CategoriaTerapeutica;
import com.tecnoa.pos.modules.inventario.model.FormaFarmaceutica;
import com.tecnoa.pos.modules.inventario.model.ViaAdministracion;
import com.tecnoa.pos.modules.inventario.repository.*;
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
public class CatalogoService {

    private final CategoriaTerapeuticaRepository categoriaRepo;
    private final FormaFarmaceuticaRepository formaRepo;
    private final ViaAdministracionRepository viaRepo;
    private final ProductoRepository productoRepo;

    // -------- Categorías --------
    public List<CatalogoDTO> listarCategorias() {
        return categoriaRepo.findAll().stream().map(c ->
                CatalogoDTO.builder().id(c.getId()).nombre(c.getNombre())
                        .descripcion(c.getDescripcion()).activo(c.getActivo()).build()
        ).collect(Collectors.toList());
    }

    @Transactional
    public CatalogoDTO crearCategoria(CatalogoDTO dto) {
        if (categoriaRepo.existsByNombre(dto.getNombre()))
            throw new BusinessException("Ya existe una categoría con nombre: " + dto.getNombre());
        CategoriaTerapeutica c = categoriaRepo.save(
                CategoriaTerapeutica.builder().nombre(dto.getNombre())
                        .descripcion(dto.getDescripcion()).activo(true).build());
        return CatalogoDTO.builder().id(c.getId()).nombre(c.getNombre())
                .descripcion(c.getDescripcion()).activo(c.getActivo()).build();
    }

    @Transactional
    public CatalogoDTO actualizarCategoria(UUID id, CatalogoDTO dto) {
        CategoriaTerapeutica c = categoriaRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CategoriaTerapeutica", id));
        c.setNombre(dto.getNombre());
        c.setDescripcion(dto.getDescripcion());
        categoriaRepo.save(c);
        return CatalogoDTO.builder().id(c.getId()).nombre(c.getNombre())
                .descripcion(c.getDescripcion()).activo(c.getActivo()).build();
    }

    @Transactional
    public void eliminarCategoria(UUID id) {
        CategoriaTerapeutica c = categoriaRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CategoriaTerapeutica", id));
        c.setActivo(false);
        categoriaRepo.save(c);
    }

    // -------- Formas Farmacéuticas --------
    public List<CatalogoDTO> listarFormas() {
        return formaRepo.findAll().stream().map(f ->
                CatalogoDTO.builder().id(f.getId()).nombre(f.getNombre())
                        .descripcion(f.getDescripcion()).activo(f.getActivo()).build()
        ).collect(Collectors.toList());
    }

    @Transactional
    public CatalogoDTO crearForma(CatalogoDTO dto) {
        if (formaRepo.existsByNombre(dto.getNombre()))
            throw new BusinessException("Ya existe una forma farmacéutica con nombre: " + dto.getNombre());
        FormaFarmaceutica f = formaRepo.save(
                FormaFarmaceutica.builder().nombre(dto.getNombre())
                        .descripcion(dto.getDescripcion()).activo(true).build());
        return CatalogoDTO.builder().id(f.getId()).nombre(f.getNombre())
                .descripcion(f.getDescripcion()).activo(f.getActivo()).build();
    }

    @Transactional
    public CatalogoDTO actualizarForma(UUID id, CatalogoDTO dto) {
        FormaFarmaceutica f = formaRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FormaFarmaceutica", id));
        f.setNombre(dto.getNombre());
        f.setDescripcion(dto.getDescripcion());
        formaRepo.save(f);
        return CatalogoDTO.builder().id(f.getId()).nombre(f.getNombre())
                .descripcion(f.getDescripcion()).activo(f.getActivo()).build();
    }

    @Transactional
    public void eliminarForma(UUID id) {
        FormaFarmaceutica f = formaRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FormaFarmaceutica", id));
        f.setActivo(false);
        formaRepo.save(f);
    }

    // -------- Vías de Administración --------
    public List<CatalogoDTO> listarVias() {
        return viaRepo.findAll().stream().map(v ->
                CatalogoDTO.builder().id(v.getId()).nombre(v.getNombre())
                        .descripcion(v.getDescripcion()).activo(v.getActivo()).build()
        ).collect(Collectors.toList());
    }

    @Transactional
    public CatalogoDTO crearVia(CatalogoDTO dto) {
        if (viaRepo.existsByNombre(dto.getNombre()))
            throw new BusinessException("Ya existe una vía con nombre: " + dto.getNombre());
        ViaAdministracion v = viaRepo.save(
                ViaAdministracion.builder().nombre(dto.getNombre())
                        .descripcion(dto.getDescripcion()).activo(true).build());
        return CatalogoDTO.builder().id(v.getId()).nombre(v.getNombre())
                .descripcion(v.getDescripcion()).activo(v.getActivo()).build();
    }

    @Transactional
    public CatalogoDTO actualizarVia(UUID id, CatalogoDTO dto) {
        ViaAdministracion v = viaRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ViaAdministracion", id));
        v.setNombre(dto.getNombre());
        v.setDescripcion(dto.getDescripcion());
        viaRepo.save(v);
        return CatalogoDTO.builder().id(v.getId()).nombre(v.getNombre())
                .descripcion(v.getDescripcion()).activo(v.getActivo()).build();
    }

    @Transactional
    public void eliminarVia(UUID id) {
        ViaAdministracion v = viaRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ViaAdministracion", id));
        v.setActivo(false);
        viaRepo.save(v);
    }
}

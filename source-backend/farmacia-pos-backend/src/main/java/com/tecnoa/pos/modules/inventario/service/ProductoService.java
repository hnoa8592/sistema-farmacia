package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.inventario.dto.*;
import com.tecnoa.pos.modules.inventario.model.*;
import com.tecnoa.pos.modules.inventario.repository.*;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductoService {

    private final ProductoRepository productoRepository;
    private final CategoriaTerapeuticaRepository categoriaRepo;
    private final FormaFarmaceuticaRepository formaRepo;
    private final ViaAdministracionRepository viaRepo;
    private final PrincipioActivoRepository principioRepo;
    private final ProductoPrincipioActivoRepository ppActivoRepo;
    private final ParametroService parametroService;

    public Page<ProductoResponseDTO> listar(String nombre, UUID categoriaId,
                                             Boolean requiereReceta, Pageable pageable) {
        return productoRepository.buscar(nombre, categoriaId, requiereReceta, pageable)
                .map(this::toResponse);
    }

    @Auditable(accion = "CREAR", modulo = "INVENTARIO", entidad = "Producto",
               descripcion = "Creación de producto")
    @Transactional
    public ProductoResponseDTO crear(ProductoRequestDTO dto) {
        if (productoRepository.existsByCodigo(dto.getCodigo())) {
            throw new BusinessException("Ya existe un producto con código: " + dto.getCodigo());
        }

        Producto producto = buildProducto(dto, null);
        return toResponse(productoRepository.save(producto));
    }

    public ProductoResponseDTO obtener(UUID id) {
        return toResponse(productoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", id)));
    }

    @Auditable(accion = "EDITAR", modulo = "INVENTARIO", entidad = "Producto",
               descripcion = "Actualización de producto")
    @Transactional
    public ProductoResponseDTO actualizar(UUID id, ProductoRequestDTO dto) {
        Producto existing = productoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", id));
        if (!existing.getCodigo().equals(dto.getCodigo()) &&
            productoRepository.existsByCodigoAndIdNot(dto.getCodigo(), id)) {
            throw new BusinessException("Ya existe un producto con código: " + dto.getCodigo());
        }
        Producto producto = buildProducto(dto, existing);
        return toResponse(productoRepository.save(producto));
    }

    @Auditable(accion = "ELIMINAR", modulo = "INVENTARIO", entidad = "Producto",
               descripcion = "Eliminación de producto")
    @Transactional
    public void eliminar(UUID id) {
        Producto producto = productoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", id));
        boolean tieneStockActivo = producto.getLotes().stream()
                .flatMap(l -> l.getInventarios().stream())
                .anyMatch(i -> i.getStockActual() > 0);
        if (tieneStockActivo) {
            throw new BusinessException("No se puede eliminar el producto porque tiene lotes con stock activo");
        }
        producto.setActivo(false);
        productoRepository.save(producto);
    }

    @Transactional
    public ProductoPrincipioActivoDTO asociarPrincipioActivo(UUID productoId, ProductoPrincipioActivoDTO dto) {
        Producto producto = productoRepository.findById(productoId)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", productoId));
        if (ppActivoRepo.existsByProductoIdAndPrincipioActivoId(productoId, dto.getPrincipioActivoId())) {
            throw new BusinessException("El principio activo ya está asociado a este producto");
        }
        PrincipioActivo pa = principioRepo.findById(dto.getPrincipioActivoId())
                .orElseThrow(() -> new ResourceNotFoundException("PrincipioActivo", dto.getPrincipioActivoId()));
        ProductoPrincipioActivo ppa = ppActivoRepo.save(
                ProductoPrincipioActivo.builder()
                        .producto(producto).principioActivo(pa)
                        .concentracion(dto.getConcentracion()).build());
        return ProductoPrincipioActivoDTO.builder()
                .id(ppa.getId()).principioActivoId(pa.getId())
                .principioActivoNombre(pa.getNombre()).concentracion(ppa.getConcentracion()).build();
    }

    @Transactional
    public void desasociarPrincipioActivo(UUID productoId, UUID paId) {
        ProductoPrincipioActivo ppa = ppActivoRepo
                .findByProductoIdAndPrincipioActivoId(productoId, paId)
                .orElseThrow(() -> new BusinessException("Asociación no encontrada"));
        ppActivoRepo.delete(ppa);
    }

    private Producto buildProducto(ProductoRequestDTO dto, Producto existing) {
        CategoriaTerapeutica categoria = dto.getCategoriaId() != null
                ? categoriaRepo.findById(dto.getCategoriaId()).orElse(null) : null;
        FormaFarmaceutica forma = dto.getFormaFarmaceuticaId() != null
                ? formaRepo.findById(dto.getFormaFarmaceuticaId()).orElse(null) : null;
        ViaAdministracion via = dto.getViaAdministracionId() != null
                ? viaRepo.findById(dto.getViaAdministracionId()).orElse(null) : null;

        if (existing != null) {
            existing.setNombre(dto.getNombre());
            existing.setNombreComercial(dto.getNombreComercial());
            existing.setCodigo(dto.getCodigo());
            existing.setCodigoBarra(dto.getCodigoBarra());
            existing.setDescripcion(dto.getDescripcion());
            existing.setConcentracion(dto.getConcentracion());
            existing.setPresentacion(dto.getPresentacion());
            existing.setRequiereReceta(dto.getRequiereReceta() != null ? dto.getRequiereReceta() : false);
            existing.setControlado(dto.getControlado() != null ? dto.getControlado() : false);
            existing.setCategoria(categoria);
            existing.setFormaFarmaceutica(forma);
            existing.setViaAdministracion(via);
            return existing;
        }

        return Producto.builder()
                .nombre(dto.getNombre()).nombreComercial(dto.getNombreComercial())
                .codigo(dto.getCodigo()).codigoBarra(dto.getCodigoBarra())
                .descripcion(dto.getDescripcion()).concentracion(dto.getConcentracion())
                .presentacion(dto.getPresentacion())
                .requiereReceta(dto.getRequiereReceta() != null ? dto.getRequiereReceta() : false)
                .controlado(dto.getControlado() != null ? dto.getControlado() : false)
                .activo(true).categoria(categoria).formaFarmaceutica(forma).viaAdministracion(via)
                .build();
    }

    ProductoResponseDTO toResponse(Producto p) {
        CatalogoDTO cat = p.getCategoria() != null ?
                CatalogoDTO.builder().id(p.getCategoria().getId()).nombre(p.getCategoria().getNombre()).build() : null;
        CatalogoDTO forma = p.getFormaFarmaceutica() != null ?
                CatalogoDTO.builder().id(p.getFormaFarmaceutica().getId()).nombre(p.getFormaFarmaceutica().getNombre()).build() : null;
        CatalogoDTO via = p.getViaAdministracion() != null ?
                CatalogoDTO.builder().id(p.getViaAdministracion().getId()).nombre(p.getViaAdministracion().getNombre()).build() : null;

        List<ProductoPrincipioActivoDTO> pas = p.getPrincipiosActivos().stream()
                .map(ppa -> ProductoPrincipioActivoDTO.builder()
                        .id(ppa.getId())
                        .principioActivoId(ppa.getPrincipioActivo().getId())
                        .principioActivoNombre(ppa.getPrincipioActivo().getNombre())
                        .concentracion(ppa.getConcentracion()).build())
                .collect(Collectors.toList());

        List<ProductoPrecioDTO> precios = p.getPrecios().stream()
                .map(pp -> ProductoPrecioDTO.builder()
                        .id(pp.getId()).tipoPrecio(pp.getTipoPrecio()).precio(pp.getPrecio())
                        .precioCompra(pp.getPrecioCompra()).vigenciaDesde(pp.getVigenciaDesde())
                        .vigenciaHasta(pp.getVigenciaHasta()).activo(pp.getActivo()).build())
                .collect(Collectors.toList());

        return ProductoResponseDTO.builder()
                .id(p.getId()).nombre(p.getNombre()).nombreComercial(p.getNombreComercial())
                .codigo(p.getCodigo()).codigoBarra(p.getCodigoBarra())
                .descripcion(p.getDescripcion()).concentracion(p.getConcentracion())
                .presentacion(p.getPresentacion()).requiereReceta(p.getRequiereReceta())
                .controlado(p.getControlado()).activo(p.getActivo())
                .categoria(cat).formaFarmaceutica(forma).viaAdministracion(via)
                .principiosActivos(pas).precios(precios).build();
    }
}

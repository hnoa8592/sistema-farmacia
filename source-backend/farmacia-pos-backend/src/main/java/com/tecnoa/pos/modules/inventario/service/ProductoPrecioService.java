package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.inventario.dto.ProductoPrecioDTO;
import com.tecnoa.pos.modules.inventario.model.Producto;
import com.tecnoa.pos.modules.inventario.model.ProductoPrecio;
import com.tecnoa.pos.modules.inventario.repository.ProductoPrecioRepository;
import com.tecnoa.pos.modules.inventario.repository.ProductoRepository;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductoPrecioService {

    private final ProductoPrecioRepository precioRepository;
    private final ProductoRepository productoRepository;

    public List<ProductoPrecioDTO> listarPorProducto(UUID productoId) {
        return precioRepository.findByProductoIdAndActivoTrue(productoId)
                .stream().map(this::toDTO).collect(Collectors.toList());
    }

    @Auditable(accion = "CREAR", modulo = "INVENTARIO", entidad = "ProductoPrecio",
               descripcion = "Creación/actualización de precio de producto")
    @Transactional
    public ProductoPrecioDTO crear(UUID productoId, ProductoPrecioDTO dto) {
        Producto producto = productoRepository.findById(productoId)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", productoId));

        // Cerrar precio anterior del mismo tipo
        precioRepository.findPrecioActual(productoId, dto.getTipoPrecio()).ifPresent(prev -> {
            prev.setVigenciaHasta(dto.getVigenciaDesde() != null ? dto.getVigenciaDesde() : LocalDateTime.now());
            precioRepository.save(prev);
        });

        ProductoPrecio precio = ProductoPrecio.builder()
                .producto(producto).tipoPrecio(dto.getTipoPrecio())
                .precio(dto.getPrecio()).precioCompra(dto.getPrecioCompra())
                .vigenciaDesde(dto.getVigenciaDesde() != null ? dto.getVigenciaDesde() : LocalDateTime.now())
                .vigenciaHasta(dto.getVigenciaHasta()).activo(true).build();

        return toDTO(precioRepository.save(precio));
    }

    @Auditable(accion = "EDITAR", modulo = "INVENTARIO", entidad = "ProductoPrecio",
               descripcion = "Actualización de precio de producto")
    @Transactional
    public ProductoPrecioDTO actualizar(UUID id, ProductoPrecioDTO dto) {
        ProductoPrecio precio = precioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ProductoPrecio", id));
        precio.setPrecio(dto.getPrecio());
        precio.setPrecioCompra(dto.getPrecioCompra());
        precio.setVigenciaHasta(dto.getVigenciaHasta());
        return toDTO(precioRepository.save(precio));
    }

    @Transactional
    public void desactivar(UUID id) {
        ProductoPrecio precio = precioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ProductoPrecio", id));
        precio.setActivo(false);
        precioRepository.save(precio);
    }

    private ProductoPrecioDTO toDTO(ProductoPrecio p) {
        return ProductoPrecioDTO.builder()
                .id(p.getId()).tipoPrecio(p.getTipoPrecio()).precio(p.getPrecio())
                .precioCompra(p.getPrecioCompra()).vigenciaDesde(p.getVigenciaDesde())
                .vigenciaHasta(p.getVigenciaHasta()).activo(p.getActivo()).build();
    }
}

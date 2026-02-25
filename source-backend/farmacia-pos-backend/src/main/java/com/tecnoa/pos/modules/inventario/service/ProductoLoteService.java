package com.tecnoa.pos.modules.inventario.service;

import com.tecnoa.pos.modules.auditoria.annotation.Auditable;
import com.tecnoa.pos.modules.inventario.dto.InventarioResponseDTO;
import com.tecnoa.pos.modules.inventario.dto.ProductoLoteRequestDTO;
import com.tecnoa.pos.modules.inventario.dto.ProductoLoteResponseDTO;
import com.tecnoa.pos.modules.inventario.model.*;
import com.tecnoa.pos.modules.inventario.repository.*;
import com.tecnoa.pos.modules.parametros.service.ParametroService;
import com.tecnoa.pos.shared.exception.BusinessException;
import com.tecnoa.pos.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductoLoteService {

    private final ProductoLoteRepository loteRepository;
    private final ProductoRepository productoRepository;
    private final LaboratorioRepository laboratorioRepository;
    private final SucursalRepository sucursalRepository;
    private final InventarioRepository inventarioRepository;
    private final ParametroService parametroService;

    public List<ProductoLoteResponseDTO> listarPorProducto(UUID productoId) {
        return loteRepository.findByProductoIdAndActivoTrue(productoId)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    public List<ProductoLoteResponseDTO> listarProximosVencer(UUID productoId) {
        int dias = parametroService.getValorAsInteger("DIAS_ALERTA_VENCIMIENTO");
        LocalDate fechaLimite = LocalDate.now().plusDays(dias);
        return loteRepository.findProximosVencer(productoId, fechaLimite)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    public List<ProductoLoteResponseDTO> listarVencidos(UUID productoId) {
        return loteRepository.findVencidos(productoId)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Auditable(accion = "CREAR", modulo = "INVENTARIO", entidad = "ProductoLote",
               descripcion = "Registro de lote de producto")
    @Transactional
    public ProductoLoteResponseDTO crear(UUID productoId, ProductoLoteRequestDTO dto) {
        Producto producto = productoRepository.findById(productoId)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", productoId));
        if (loteRepository.existsByProductoIdAndNumeroLote(productoId, dto.getNumeroLote())) {
            throw new BusinessException("Ya existe un lote con número: " + dto.getNumeroLote() + " para este producto");
        }
        Laboratorio laboratorio = laboratorioRepository.findById(dto.getLaboratorioId())
                .orElseThrow(() -> new ResourceNotFoundException("Laboratorio", dto.getLaboratorioId()));

        ProductoLote lote = ProductoLote.builder()
                .producto(producto).laboratorio(laboratorio)
                .numeroLote(dto.getNumeroLote()).fechaFabricacion(dto.getFechaFabricacion())
                .fechaVencimiento(dto.getFechaVencimiento())
                .cantidadInicial(dto.getCantidadInicial()).activo(true).build();
        lote = loteRepository.save(lote);

        // Crear inventario inicial
        Sucursal sucursal = (dto.getSucursalId() != null)
                ? sucursalRepository.findById(dto.getSucursalId())
                        .orElseThrow(() -> new ResourceNotFoundException("Sucursal", dto.getSucursalId()))
                : sucursalRepository.findByEsMatrizTrueAndActivoTrue()
                        .orElseThrow(() -> new BusinessException("No hay sucursal matriz configurada"));

        int stockMinimo = parametroService.getValorAsInteger("STOCK_MINIMO_DEFAULT");
        inventarioRepository.save(Inventario.builder()
                .lote(lote).sucursal(sucursal)
                .stockActual(dto.getCantidadInicial()).stockMinimo(stockMinimo).build());

        return toResponse(lote);
    }

    @Auditable(accion = "EDITAR", modulo = "INVENTARIO", entidad = "ProductoLote",
               descripcion = "Actualización de lote de producto")
    @Transactional
    public ProductoLoteResponseDTO actualizar(UUID id, ProductoLoteRequestDTO dto) {
        ProductoLote lote = loteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ProductoLote", id));
        Laboratorio laboratorio = laboratorioRepository.findById(dto.getLaboratorioId())
                .orElseThrow(() -> new ResourceNotFoundException("Laboratorio", dto.getLaboratorioId()));
        lote.setLaboratorio(laboratorio);
        lote.setFechaFabricacion(dto.getFechaFabricacion());
        lote.setFechaVencimiento(dto.getFechaVencimiento());
        return toResponse(loteRepository.save(lote));
    }

    private ProductoLoteResponseDTO toResponse(ProductoLote l) {
        List<InventarioResponseDTO> inventarios = l.getInventarios().stream()
                .map(i -> InventarioResponseDTO.builder()
                        .id(i.getId()).loteId(l.getId()).numeroLote(l.getNumeroLote())
                        .sucursalId(i.getSucursal().getId()).sucursalNombre(i.getSucursal().getNombre())
                        .stockActual(i.getStockActual()).stockMinimo(i.getStockMinimo())
                        .ubicacion(i.getUbicacion())
                        .bajoStock(i.getStockActual() <= i.getStockMinimo()).build())
                .collect(Collectors.toList());

        return ProductoLoteResponseDTO.builder()
                .id(l.getId()).productoId(l.getProducto().getId())
                .productoNombre(l.getProducto().getNombre())
                .laboratorioId(l.getLaboratorio().getId())
                .laboratorioNombre(l.getLaboratorio().getNombre())
                .numeroLote(l.getNumeroLote()).fechaFabricacion(l.getFechaFabricacion())
                .fechaVencimiento(l.getFechaVencimiento())
                .cantidadInicial(l.getCantidadInicial()).activo(l.getActivo())
                .inventarios(inventarios).build();
    }
}

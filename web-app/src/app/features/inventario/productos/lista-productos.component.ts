import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ConfirmationService, MessageService } from 'primeng/api';
import { ProductoService } from '../services/producto.service';
import { CatalogoService } from '../../catalogos/services/catalogo.service';
import { ProductoResponse } from '../models/producto.model';
import { CatalogoDTO } from '../../catalogos/models/catalogo.model';

@Component({
  selector: 'app-lista-productos',
  templateUrl: './lista-productos.component.html',
  providers: [ConfirmationService, MessageService]
})
export class ListaProductosComponent implements OnInit {
  productos: ProductoResponse[] = [];
  totalRegistros = 0;
  cargando = true;
  mostrarFormulario = false;
  productoSeleccionado: ProductoResponse | null = null;

  categorias: CatalogoDTO[] = [];
  formas: CatalogoDTO[] = [];

  filtros = { nombre: '', categoriaId: '', formaId: '' };
  paginaActual = 0;
  filasPorPagina = 10;

  constructor(
    private productoService: ProductoService,
    private catalogoService: CatalogoService,
    private confirmationService: ConfirmationService,
    private messageService: MessageService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.cargarCatalogos();
    this.cargarProductos();
  }

  cargarCatalogos(): void {
    this.catalogoService.getCategorias().subscribe(c => this.categorias = c);
    this.catalogoService.getFormas().subscribe(f => this.formas = f);
  }

  cargarProductos(): void {
    this.cargando = true;
    this.productoService.getProductos(this.paginaActual, this.filasPorPagina, this.filtros).subscribe({
      next: p => {
        this.productos = p.content;
        this.totalRegistros = p.totalElements;
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });
  }

  onLazyLoad(event: any): void {
    this.paginaActual = event.first / event.rows;
    this.filasPorPagina = event.rows;
    this.cargarProductos();
  }

  verDetalle(producto: ProductoResponse): void {
    this.router.navigate(['/inventario/productos', producto.id]);
  }

  nuevoProducto(): void {
    this.productoSeleccionado = null;
    this.mostrarFormulario = true;
  }

  editarProducto(producto: ProductoResponse): void {
    this.productoSeleccionado = { ...producto };
    this.mostrarFormulario = true;
  }

  desactivarProducto(producto: ProductoResponse): void {
    this.confirmationService.confirm({
      message: `¿Desea desactivar el producto "${producto.nombre}"?`,
      header: 'Confirmar',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
        this.productoService.desactivarProducto(producto.id).subscribe({
          next: () => {
            this.messageService.add({ severity: 'success', summary: 'Producto desactivado', detail: 'El producto fue desactivado' });
            this.cargarProductos();
          },
          error: () => this.messageService.add({ severity: 'error', summary: 'Error', detail: 'No se pudo desactivar el producto' })
        });
      }
    });
  }

  onGuardado(): void {
    this.mostrarFormulario = false;
    this.cargarProductos();
  }

  aplicarFiltros(): void {
    this.paginaActual = 0;
    this.cargarProductos();
  }

  limpiarFiltros(): void {
    this.filtros = { nombre: '', categoriaId: '', formaId: '' };
    this.paginaActual = 0;
    this.cargarProductos();
  }
}

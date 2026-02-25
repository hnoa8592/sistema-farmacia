import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MessageService } from 'primeng/api';
import { ProductoService } from '../../services/producto.service';
import { ProductoLoteService } from '../../services/producto-lote.service';
import { ProductoPrecioService } from '../../services/producto-precio.service';
import { InventarioService } from '../../services/inventario.service';
import { ProductoResponse } from '../../models/producto.model';
import { ProductoLoteResponse } from '../../models/producto-lote.model';
import { ProductoPrecioDTO } from '../../models/producto-precio.model';
import { InventarioResponse } from '../../models/inventario.model';

@Component({
  selector: 'app-detalle-producto',
  templateUrl: './detalle-producto.component.html',
  providers: [MessageService]
})
export class DetalleProductoComponent implements OnInit {
  productoId!: string;
  producto: ProductoResponse | null = null;
  lotes: ProductoLoteResponse[] = [];
  precios: ProductoPrecioDTO[] = [];
  stock: InventarioResponse[] = [];
  cargando = true;

  mostrarFormLote = false;
  mostrarFormPrecio = false;
  precioSeleccionado: ProductoPrecioDTO | null = null;

  activeTabIndex = 0;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private productoService: ProductoService,
    private loteService: ProductoLoteService,
    private precioService: ProductoPrecioService,
    private inventarioService: InventarioService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.productoId = this.route.snapshot.paramMap.get('id')!;
    this.cargarProducto();
  }

  cargarProducto(): void {
    this.cargando = true;
    this.productoService.getProductoById(this.productoId).subscribe({
      next: p => {
        this.producto = p;
        this.precios = p.precios || [];
        this.cargando = false;
        this.cargarLotes();
        this.cargarStock();
      },
      error: () => { this.cargando = false; this.router.navigate(['/inventario/productos']); }
    });
  }

  cargarLotes(): void {
    this.loteService.getLotes(this.productoId).subscribe({ next: l => this.lotes = l, error: () => {} });
  }

  cargarStock(): void {
    this.inventarioService.getStock({ productoId: this.productoId }).subscribe({ next: s => this.stock = s, error: () => {} });
  }

  cargarPrecios(): void {
    this.precioService.getPrecios(this.productoId).subscribe({ next: p => this.precios = p, error: () => {} });
  }

  editarPrecio(precio: ProductoPrecioDTO): void {
    this.precioSeleccionado = { ...precio };
    this.mostrarFormPrecio = true;
  }

  onLoteGuardado(): void {
    this.mostrarFormLote = false;
    this.cargarLotes();
    this.cargarStock();
  }

  onPrecioGuardado(): void {
    this.mostrarFormPrecio = false;
    this.precioSeleccionado = null;
    this.cargarPrecios();
  }

  volver(): void {
    this.router.navigate(['/inventario/productos']);
  }

  isVencido(fecha: string): boolean {
    return new Date(fecha) < new Date();
  }

  isProximoVencer(fecha: string): boolean {
    const en30 = new Date();
    en30.setDate(en30.getDate() + 30);
    const f = new Date(fecha);
    return f <= en30 && f >= new Date();
  }
}

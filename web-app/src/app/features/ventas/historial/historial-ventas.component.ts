import { Component, OnInit } from '@angular/core';
import { ConfirmationService, MessageService } from 'primeng/api';
import { VentaService } from '../services/venta.service';
import { VentaResponse } from '../models/venta.model';
import { PageResponse } from 'src/app/shared/models/api-response.model';

@Component({
  selector: 'app-historial-ventas',
  templateUrl: './historial-ventas.component.html',
  providers: [ConfirmationService, MessageService]
})
export class HistorialVentasComponent implements OnInit {
  ventas: VentaResponse[] = [];
  totalRegistros = 0;
  cargando = true;
  ventaDetalle: VentaResponse | null = null;
  mostrarDetalle = false;

  private hoy(): Date { const d = new Date(); d.setHours(0, 0, 0, 0); return d; }
  filtros = { desde: this.hoy(), hasta: this.hoy(), estado: '' };
  estadoOpciones = [
    { label: 'Todos', value: '' },
    { label: 'Completada', value: 'COMPLETADA' },
    { label: 'Anulada', value: 'ANULADA' }
  ];

  constructor(
    private ventaService: VentaService,
    private confirmationService: ConfirmationService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.cargarVentas(0, 10);
  }

  cargarVentas(page: number, size: number): void {
    this.cargando = true;
    const filtros: any = {};
    if (this.filtros.desde) filtros.desde = this.filtros.desde.toISOString().split('T')[0];
    if (this.filtros.hasta) filtros.hasta = this.filtros.hasta.toISOString().split('T')[0];
    if (this.filtros.estado) filtros.estado = this.filtros.estado;

    this.ventaService.getVentas(page, size, filtros).subscribe({
      next: (p: PageResponse<VentaResponse>) => {
        this.ventas = p.content;
        this.totalRegistros = p.totalElements;
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });
  }

  onLazyLoad(event: any): void {
    this.cargarVentas(event.first / event.rows, event.rows);
  }

  verDetalle(venta: VentaResponse): void {
    this.ventaDetalle = venta;
    this.mostrarDetalle = true;
  }

  anularVenta(venta: VentaResponse): void {
    this.confirmationService.confirm({
      message: `¿Desea anular la venta del ${new Date(venta.fecha).toLocaleDateString()}?`,
      header: 'Confirmar Anulación',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Sí, anular',
      rejectLabel: 'Cancelar',
      accept: () => {
        this.ventaService.anularVenta(venta.id).subscribe({
          next: () => {
            this.messageService.add({ severity: 'success', summary: 'Venta anulada', detail: 'La venta fue anulada correctamente' });
            this.cargarVentas(0, 10);
          },
          error: () => this.messageService.add({ severity: 'error', summary: 'Error', detail: 'No se pudo anular la venta' })
        });
      }
    });
  }

  aplicarFiltros(): void { this.cargarVentas(0, 10); }
  limpiarFiltros(): void {
    this.filtros = { desde: this.hoy(), hasta: this.hoy(), estado: '' };
    this.cargarVentas(0, 10);
  }
}

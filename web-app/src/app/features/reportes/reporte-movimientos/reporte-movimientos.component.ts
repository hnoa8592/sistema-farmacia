import { Component, OnInit } from '@angular/core';
import { ReporteService } from '../services/reporte.service';

@Component({
  selector: 'app-reporte-movimientos',
  template: `
    <div class="surface-card shadow-2 border-round p-4">
      <div class="flex align-items-center justify-content-between mb-4">
        <h2 class="m-0 text-900 font-bold"><i class="pi pi-list mr-2 text-indigo-500"></i>Reporte de Movimientos</h2>
      </div>
      <div class="flex flex-wrap gap-3 mb-4 align-items-end">
        <div class="flex flex-column gap-1">
          <label class="text-sm font-medium text-600">Desde</label>
          <p-calendar [(ngModel)]="desde" dateFormat="dd/mm/yy" [showIcon]="true"></p-calendar>
        </div>
        <div class="flex flex-column gap-1">
          <label class="text-sm font-medium text-600">Hasta</label>
          <p-calendar [(ngModel)]="hasta" dateFormat="dd/mm/yy" [showIcon]="true"></p-calendar>
        </div>
        <p-button label="Generar" icon="pi pi-refresh" [loading]="cargando" (onClick)="cargar()"></p-button>
      </div>
      <p-table [value]="datos" [loading]="cargando" responsiveLayout="scroll" styleClass="p-datatable-sm">
        <ng-template pTemplate="header">
          <tr><th>Fecha</th><th>Producto</th><th>Sucursal</th><th>Tipo</th><th class="text-right">Cantidad</th></tr>
        </ng-template>
        <ng-template pTemplate="body" let-m>
          <tr>
            <td>{{ m.fecha | date:'dd/MM/yyyy HH:mm' }}</td>
            <td>{{ m.productoNombre }}</td>
            <td>{{ m.sucursalNombre }}</td>
            <td><p-tag [value]="m.tipo" [severity]="getTipoSeveridad(m.tipo)"></p-tag></td>
            <td class="text-right font-medium">{{ m.cantidad }}</td>
          </tr>
        </ng-template>
        <ng-template pTemplate="emptymessage">
          <tr><td colspan="5" class="text-center text-500 py-4">Sin movimientos en el período</td></tr>
        </ng-template>
      </p-table>
    </div>
  `
})
export class ReporteMovimientosComponent implements OnInit {
  desde: Date = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
  hasta: Date = new Date();
  datos: any[] = [];
  cargando = false;

  constructor(private reporteService: ReporteService) {}

  ngOnInit(): void { this.cargar(); }

  cargar(): void {
    this.cargando = true;
    const d = this.desde.toISOString().split('T')[0];
    const h = this.hasta.toISOString().split('T')[0];
    this.reporteService.getReporteMovimientos(d, h).subscribe({
      next: d => { this.datos = d; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  getTipoSeveridad(tipo: string): string {
    return { ENTRADA: 'success', SALIDA: 'danger', AJUSTE: 'warning', TRANSFERENCIA: 'info' }[tipo] || 'info';
  }
}

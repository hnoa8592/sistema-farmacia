import { Component, OnInit } from '@angular/core';
import { InventarioService } from '../services/inventario.service';
import { SucursalService } from '../../catalogos/services/sucursal.service';
import { InventarioResponse } from '../models/inventario.model';
import { Sucursal } from '../../catalogos/models/sucursal.model';

@Component({
  selector: 'app-stock-actual',
  template: `
    <div class="grid">
      <div class="col-12">
        <div class="surface-card shadow-2 border-round p-4">
          <h2 class="text-900 font-bold mt-0 mb-4">
            <i class="pi pi-database mr-2 text-indigo-500"></i>Stock Actual
          </h2>
          <div class="flex flex-wrap gap-3 mb-4 align-items-end">
            <div class="flex flex-column gap-1">
              <label class="text-sm font-medium text-600">Sucursal</label>
              <p-dropdown [options]="sucursales" [(ngModel)]="sucursalId" optionLabel="nombre" optionValue="id"
                placeholder="Todas" [showClear]="true" styleClass="w-12rem" (ngModelChange)="cargarStock()">
              </p-dropdown>
            </div>
            <div class="flex align-items-center gap-2">
              <p-inputSwitch [(ngModel)]="soloConStock" (ngModelChange)="cargarStock()"></p-inputSwitch>
              <label class="font-medium text-sm">Solo con stock</label>
            </div>
          </div>
          <p-table [value]="stock" [loading]="cargando" responsiveLayout="scroll" styleClass="p-datatable-sm">
            <ng-template pTemplate="header">
              <tr>
                <th>Producto</th>
                <th>Lote</th>
                <th>Sucursal</th>
                <th>Vencimiento</th>
                <th class="text-right">Stock Actual</th>
                <th class="text-right">Stock Mínimo</th>
                <th>Ubicación</th>
              </tr>
            </ng-template>
            <ng-template pTemplate="body" let-inv>
              <tr [class.bg-red-50]="inv.stockActual <= inv.stockMinimo"
                [class.bg-yellow-50]="isProximoVencer(inv.fechaVencimiento) && inv.stockActual > inv.stockMinimo">
                <td class="font-medium">{{ inv.productoNombre }}</td>
                <td><code class="text-sm">{{ inv.numeroLote }}</code></td>
                <td>{{ inv.sucursalNombre }}</td>
                <td>
                  {{ inv.fechaVencimiento | date:'dd/MM/yyyy' }}
                  <p-badge *ngIf="isProximoVencer(inv.fechaVencimiento)" value="!" severity="warning" class="ml-1"></p-badge>
                </td>
                <td class="text-right">
                  <span class="font-bold" [class.text-red-600]="inv.stockActual <= inv.stockMinimo">{{ inv.stockActual }}</span>
                </td>
                <td class="text-right text-500">{{ inv.stockMinimo }}</td>
                <td class="text-500">{{ inv.ubicacion || '—' }}</td>
              </tr>
            </ng-template>
            <ng-template pTemplate="emptymessage">
              <tr><td colspan="7" class="text-center text-500 py-5">No hay registros de stock</td></tr>
            </ng-template>
          </p-table>
        </div>
      </div>
    </div>
  `
})
export class StockActualComponent implements OnInit {
  stock: InventarioResponse[] = [];
  sucursales: Sucursal[] = [];
  sucursalId = '';
  soloConStock = true;
  cargando = true;

  constructor(private inventarioService: InventarioService, private sucursalService: SucursalService) {}

  ngOnInit(): void {
    this.sucursalService.getSucursales().subscribe(s => this.sucursales = s);
    this.cargarStock();
  }

  cargarStock(): void {
    this.cargando = true;
    const filtros: any = { soloConStock: this.soloConStock };
    if (this.sucursalId) filtros.sucursalId = this.sucursalId;
    this.inventarioService.getStock(filtros).subscribe({
      next: s => { this.stock = s; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  isProximoVencer(fecha: string): boolean {
    const en30 = new Date();
    en30.setDate(en30.getDate() + 30);
    return new Date(fecha) <= en30 && new Date(fecha) >= new Date();
  }
}

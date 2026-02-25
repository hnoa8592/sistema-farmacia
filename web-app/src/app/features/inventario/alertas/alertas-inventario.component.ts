import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ProductoService } from '../services/producto.service';
import { InventarioService } from '../services/inventario.service';
import { ProductoResponse } from '../models/producto.model';
import { InventarioResponse } from '../models/inventario.model';

@Component({
  selector: 'app-alertas-inventario',
  template: `
    <div class="grid">
      <div class="col-12">
        <div class="surface-card shadow-2 border-round p-4">
          <h2 class="text-900 font-bold mt-0 mb-4">
            <i class="pi pi-bell mr-2 text-orange-500"></i>Alertas de Inventario
          </h2>
          <p-tabView>
            <p-tabPanel>
              <ng-template pTemplate="header">
                <span>Bajo Stock</span>
                <p-badge [value]="bajoStock.length.toString()" severity="danger" class="ml-2"></p-badge>
              </ng-template>
              <p-table [value]="bajoStock" [loading]="cargando" responsiveLayout="scroll" styleClass="p-datatable-sm">
                <ng-template pTemplate="header">
                  <tr><th>Producto</th><th>Sucursal</th><th class="text-right">Stock</th><th class="text-right">Mínimo</th><th></th></tr>
                </ng-template>
                <ng-template pTemplate="body" let-inv>
                  <tr class="bg-red-50">
                    <td class="font-medium">{{ inv.productoNombre }}</td>
                    <td>{{ inv.sucursalNombre }}</td>
                    <td class="text-right text-red-600 font-bold">{{ inv.stockActual }}</td>
                    <td class="text-right text-500">{{ inv.stockMinimo }}</td>
                    <td>
                      <p-button icon="pi pi-eye" label="Ver" styleClass="p-button-text p-button-sm"
                        (onClick)="verProducto(inv.productoId)">
                      </p-button>
                    </td>
                  </tr>
                </ng-template>
                <ng-template pTemplate="emptymessage">
                  <tr><td colspan="5" class="text-center text-500 py-4">Sin alertas de bajo stock</td></tr>
                </ng-template>
              </p-table>
            </p-tabPanel>

            <p-tabPanel>
              <ng-template pTemplate="header">
                <span>Próximos a Vencer</span>
                <p-badge [value]="proximosVencer.length.toString()" severity="warning" class="ml-2"></p-badge>
              </ng-template>
              <p-table [value]="proximosVencer" [loading]="cargando" responsiveLayout="scroll" styleClass="p-datatable-sm">
                <ng-template pTemplate="header">
                  <tr><th>Producto</th><th>Lote</th><th>Vencimiento</th><th class="text-right">Stock</th><th></th></tr>
                </ng-template>
                <ng-template pTemplate="body" let-inv>
                  <tr class="bg-yellow-50">
                    <td class="font-medium">{{ inv.productoNombre }}</td>
                    <td><code>{{ inv.numeroLote }}</code></td>
                    <td>{{ inv.fechaVencimiento | date:'dd/MM/yyyy' }}</td>
                    <td class="text-right">{{ inv.stockActual }}</td>
                    <td>
                      <p-button icon="pi pi-eye" label="Ver" styleClass="p-button-text p-button-sm"
                        (onClick)="verProducto(inv.productoId)">
                      </p-button>
                    </td>
                  </tr>
                </ng-template>
                <ng-template pTemplate="emptymessage">
                  <tr><td colspan="5" class="text-center text-500 py-4">Sin lotes próximos a vencer</td></tr>
                </ng-template>
              </p-table>
            </p-tabPanel>

            <p-tabPanel>
              <ng-template pTemplate="header">
                <span>Sin Stock</span>
                <p-badge [value]="sinStock.length.toString()" severity="info" class="ml-2"></p-badge>
              </ng-template>
              <p-table [value]="sinStock" [loading]="cargando" responsiveLayout="scroll" styleClass="p-datatable-sm">
                <ng-template pTemplate="header">
                  <tr><th>Código</th><th>Producto</th><th>Categoría</th><th></th></tr>
                </ng-template>
                <ng-template pTemplate="body" let-prod>
                  <tr>
                    <td><code>{{ prod.codigo }}</code></td>
                    <td class="font-medium">{{ prod.nombre }}</td>
                    <td>{{ prod.categoriaNombre }}</td>
                    <td>
                      <p-button icon="pi pi-eye" label="Ver" styleClass="p-button-text p-button-sm"
                        (onClick)="verProducto(prod.id)">
                      </p-button>
                    </td>
                  </tr>
                </ng-template>
                <ng-template pTemplate="emptymessage">
                  <tr><td colspan="4" class="text-center text-500 py-4">Todos los productos tienen stock</td></tr>
                </ng-template>
              </p-table>
            </p-tabPanel>
          </p-tabView>
        </div>
      </div>
    </div>
  `
})
export class AlertasInventarioComponent implements OnInit {
  bajoStock: InventarioResponse[] = [];
  proximosVencer: InventarioResponse[] = [];
  sinStock: ProductoResponse[] = [];
  cargando = true;

  constructor(
    private productoService: ProductoService,
    private inventarioService: InventarioService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.inventarioService.getStock({ soloConStock: false }).subscribe({
      next: stock => {
        this.bajoStock = stock.filter(s => s.stockActual <= s.stockMinimo && s.stockActual > 0);
        const en30dias = new Date();
        en30dias.setDate(en30dias.getDate() + 30);
        this.proximosVencer = stock.filter(s => {
          const f = new Date(s.fechaVencimiento);
          return f <= en30dias && f >= new Date() && s.stockActual > 0;
        });
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });
    this.productoService.getProductosSinStock().subscribe({
      next: p => this.sinStock = p,
      error: () => {}
    });
  }

  verProducto(id: string): void {
    this.router.navigate(['/inventario/productos', id]);
  }
}

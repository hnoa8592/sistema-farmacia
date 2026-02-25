import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { InventarioRoutingModule } from './inventario-routing.module';
import { ListaProductosComponent } from './productos/lista-productos.component';
import { FormProductoComponent } from './productos/form-producto/form-producto.component';
import { DetalleProductoComponent } from './productos/detalle-producto/detalle-producto.component';
import { FormLoteComponent } from './lotes/form-lote.component';
import { FormPrecioComponent } from './precios/form-precio.component';
import { MovimientosComponent } from './movimientos/movimientos.component';
import { StockActualComponent } from './stock/stock-actual.component';
import { AlertasInventarioComponent } from './alertas/alertas-inventario.component';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { InputNumberModule } from 'primeng/inputnumber';
import { InputTextareaModule } from 'primeng/inputtextarea';
import { DropdownModule } from 'primeng/dropdown';
import { MultiSelectModule } from 'primeng/multiselect';
import { CalendarModule } from 'primeng/calendar';
import { DialogModule } from 'primeng/dialog';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { ToastModule } from 'primeng/toast';
import { TagModule } from 'primeng/tag';
import { BadgeModule } from 'primeng/badge';
import { CardModule } from 'primeng/card';
import { TabViewModule } from 'primeng/tabview';
import { ChipModule } from 'primeng/chip';
import { CheckboxModule } from 'primeng/checkbox';
import { ToggleButtonModule } from 'primeng/togglebutton';
import { InputSwitchModule } from 'primeng/inputswitch';
import { TooltipModule } from 'primeng/tooltip';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { SkeletonModule } from 'primeng/skeleton';
import { ConfirmationService, MessageService } from 'primeng/api';
import { SharedModule } from 'src/app/shared/shared.module';

@NgModule({
  declarations: [
    ListaProductosComponent,
    FormProductoComponent,
    DetalleProductoComponent,
    FormLoteComponent,
    FormPrecioComponent,
    MovimientosComponent,
    StockActualComponent,
    AlertasInventarioComponent
  ],
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule,
    InventarioRoutingModule,
    TableModule, ButtonModule, InputTextModule, InputNumberModule, InputTextareaModule,
    DropdownModule, MultiSelectModule, CalendarModule,
    DialogModule, ConfirmDialogModule, ToastModule,
    TagModule, BadgeModule, CardModule, TabViewModule,
    ChipModule, CheckboxModule, ToggleButtonModule, InputSwitchModule,
    TooltipModule, ProgressSpinnerModule, SkeletonModule,
    SharedModule
  ],
  providers: [ConfirmationService, MessageService]
})
export class InventarioModule {}

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ReportesRoutingModule } from './reportes-routing.module';
import { ReporteVentasComponent } from './reporte-ventas/reporte-ventas.component';
import { ReporteStockComponent } from './reporte-stock/reporte-stock.component';
import { ReporteMovimientosComponent } from './reporte-movimientos/reporte-movimientos.component';
import { CierreCajaComponent } from './cierre-caja/cierre-caja.component';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { CalendarModule } from 'primeng/calendar';
import { DropdownModule } from 'primeng/dropdown';
import { CardModule } from 'primeng/card';
import { ChartModule } from 'primeng/chart';
import { TagModule } from 'primeng/tag';
import { DialogModule } from 'primeng/dialog';
import { InputNumberModule } from 'primeng/inputnumber';
import { InputTextModule } from 'primeng/inputtext';
import { InputTextareaModule } from 'primeng/inputtextarea';
import { DividerModule } from 'primeng/divider';
import { ToastModule } from 'primeng/toast';
import { TooltipModule } from 'primeng/tooltip';
import { SharedModule } from 'src/app/shared/shared.module';

@NgModule({
  declarations: [ReporteVentasComponent, ReporteStockComponent, ReporteMovimientosComponent, CierreCajaComponent],
  imports: [
    CommonModule, FormsModule, ReportesRoutingModule,
    TableModule, ButtonModule, CalendarModule, DropdownModule,
    CardModule, ChartModule, TagModule, SharedModule,
    DialogModule, InputNumberModule, InputTextModule, InputTextareaModule,
    DividerModule, ToastModule, TooltipModule
  ]
})
export class ReportesModule {}

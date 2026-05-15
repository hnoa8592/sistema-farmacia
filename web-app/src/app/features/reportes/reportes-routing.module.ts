import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ReporteVentasComponent } from './reporte-ventas/reporte-ventas.component';
import { ReporteStockComponent } from './reporte-stock/reporte-stock.component';
import { ReporteMovimientosComponent } from './reporte-movimientos/reporte-movimientos.component';
import { CierreCajaComponent } from './cierre-caja/cierre-caja.component';

const routes: Routes = [
  { path: '', redirectTo: 'ventas', pathMatch: 'full' },
  { path: 'ventas', component: ReporteVentasComponent },
  { path: 'stock', component: ReporteStockComponent },
  { path: 'movimientos', component: ReporteMovimientosComponent },
  { path: 'cierre-caja', component: CierreCajaComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReportesRoutingModule {}

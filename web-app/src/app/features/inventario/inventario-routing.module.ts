import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListaProductosComponent } from './productos/lista-productos.component';
import { DetalleProductoComponent } from './productos/detalle-producto/detalle-producto.component';
import { MovimientosComponent } from './movimientos/movimientos.component';
import { StockActualComponent } from './stock/stock-actual.component';
import { AlertasInventarioComponent } from './alertas/alertas-inventario.component';

const routes: Routes = [
  { path: '', redirectTo: 'productos', pathMatch: 'full' },
  { path: 'productos', component: ListaProductosComponent },
  { path: 'productos/:id', component: DetalleProductoComponent },
  { path: 'movimientos', component: MovimientosComponent },
  { path: 'stock', component: StockActualComponent },
  { path: 'alertas', component: AlertasInventarioComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class InventarioRoutingModule {}

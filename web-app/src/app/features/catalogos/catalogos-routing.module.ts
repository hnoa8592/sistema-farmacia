import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CategoriasComponent } from './categorias/categorias.component';
import { FormasComponent } from './formas/formas.component';
import { ViasComponent } from './vias/vias.component';
import { PrincipiosActivosComponent } from './principios-activos/principios-activos.component';
import { LaboratoriosComponent } from './laboratorios/laboratorios.component';
import { SucursalesComponent } from './sucursales/sucursales.component';

const routes: Routes = [
  { path: '', redirectTo: 'categorias', pathMatch: 'full' },
  { path: 'categorias', component: CategoriasComponent },
  { path: 'formas', component: FormasComponent },
  { path: 'vias', component: ViasComponent },
  { path: 'principios-activos', component: PrincipiosActivosComponent },
  { path: 'laboratorios', component: LaboratoriosComponent },
  { path: 'sucursales', component: SucursalesComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CatalogosRoutingModule {}

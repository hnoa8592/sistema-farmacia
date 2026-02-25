import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListaParametrosComponent } from './lista-parametros.component';

const routes: Routes = [{ path: '', component: ListaParametrosComponent }];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ParametrosRoutingModule {}

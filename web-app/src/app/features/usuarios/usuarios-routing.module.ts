import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListaUsuariosComponent } from './gestion/lista-usuarios.component';
import { ListaPerfilesComponent } from './perfiles/lista-perfiles.component';

const routes: Routes = [
  { path: '', redirectTo: 'gestion', pathMatch: 'full' },
  { path: 'gestion', component: ListaUsuariosComponent },
  { path: 'perfiles', component: ListaPerfilesComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class UsuariosRoutingModule {}

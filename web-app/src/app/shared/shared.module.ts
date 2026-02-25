import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PermisoDirective } from './directives/permiso.directive';
import { EstadoVentaPipe } from './pipes/estado-venta.pipe';

@NgModule({
  declarations: [PermisoDirective, EstadoVentaPipe],
  imports: [CommonModule],
  exports: [PermisoDirective, EstadoVentaPipe]
})
export class SharedModule {}

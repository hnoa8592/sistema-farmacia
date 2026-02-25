import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CatalogosRoutingModule } from './catalogos-routing.module';
import { CategoriasComponent } from './categorias/categorias.component';
import { FormasComponent } from './formas/formas.component';
import { ViasComponent } from './vias/vias.component';
import { PrincipiosActivosComponent } from './principios-activos/principios-activos.component';
import { LaboratoriosComponent } from './laboratorios/laboratorios.component';
import { SucursalesComponent } from './sucursales/sucursales.component';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { InputTextareaModule } from 'primeng/inputtextarea';
import { DialogModule } from 'primeng/dialog';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { ToastModule } from 'primeng/toast';
import { TagModule } from 'primeng/tag';
import { BadgeModule } from 'primeng/badge';
import { CheckboxModule } from 'primeng/checkbox';
import { TooltipModule } from 'primeng/tooltip';
import { ConfirmationService, MessageService } from 'primeng/api';
import { SharedModule } from 'src/app/shared/shared.module';

@NgModule({
  declarations: [
    CategoriasComponent, FormasComponent, ViasComponent,
    PrincipiosActivosComponent, LaboratoriosComponent, SucursalesComponent
  ],
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule,
    CatalogosRoutingModule,
    TableModule, ButtonModule, InputTextModule, InputTextareaModule,
    DialogModule, ConfirmDialogModule, ToastModule,
    TagModule, BadgeModule, CheckboxModule, TooltipModule,
    SharedModule
  ],
  providers: [ConfirmationService, MessageService]
})
export class CatalogosModule {}

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuditoriaRoutingModule } from './auditoria-routing.module';
import { ListaAuditoriaComponent } from './lista-auditoria.component';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { CalendarModule } from 'primeng/calendar';
import { DropdownModule } from 'primeng/dropdown';
import { DialogModule } from 'primeng/dialog';
import { TagModule } from 'primeng/tag';
import { ScrollPanelModule } from 'primeng/scrollpanel';
import { SharedModule } from 'src/app/shared/shared.module';

@NgModule({
  declarations: [ListaAuditoriaComponent],
  imports: [
    CommonModule, FormsModule, AuditoriaRoutingModule,
    TableModule, ButtonModule, CalendarModule, DropdownModule,
    DialogModule, TagModule, ScrollPanelModule, SharedModule
  ]
})
export class AuditoriaModule {}

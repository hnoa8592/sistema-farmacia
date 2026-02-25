import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { VentasRoutingModule } from './ventas-routing.module';
import { PosComponent } from './pos/pos.component';
import { HistorialVentasComponent } from './historial/historial-ventas.component';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { InputNumberModule } from 'primeng/inputnumber';
import { DropdownModule } from 'primeng/dropdown';
import { CalendarModule } from 'primeng/calendar';
import { DialogModule } from 'primeng/dialog';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { ToastModule } from 'primeng/toast';
import { TagModule } from 'primeng/tag';
import { CardModule } from 'primeng/card';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { MessageModule } from 'primeng/message';
import { DividerModule } from 'primeng/divider';
import { TooltipModule } from 'primeng/tooltip';
import { BadgeModule } from 'primeng/badge';
import { SharedModule } from 'src/app/shared/shared.module';

@NgModule({
  declarations: [PosComponent, HistorialVentasComponent],
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule,
    VentasRoutingModule,
    TableModule, ButtonModule, InputTextModule, InputNumberModule,
    DropdownModule, CalendarModule, DialogModule, ConfirmDialogModule,
    ToastModule, TagModule, CardModule, AutoCompleteModule,
    MessageModule, DividerModule, TooltipModule, BadgeModule,
    SharedModule
  ]
})
export class VentasModule {}

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ParametrosRoutingModule } from './parametros-routing.module';
import { ListaParametrosComponent } from './lista-parametros.component';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { InputNumberModule } from 'primeng/inputnumber';
import { InputSwitchModule } from 'primeng/inputswitch';
import { TagModule } from 'primeng/tag';
import { TabViewModule } from 'primeng/tabview';
import { ToastModule } from 'primeng/toast';
import { InplaceModule } from 'primeng/inplace';
import { TooltipModule } from 'primeng/tooltip';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { MessageService } from 'primeng/api';
import { SharedModule } from 'src/app/shared/shared.module';

@NgModule({
  declarations: [ListaParametrosComponent],
  imports: [
    CommonModule, FormsModule, ParametrosRoutingModule,
    TableModule, ButtonModule, InputTextModule, InputNumberModule,
    InputSwitchModule, TagModule, TabViewModule, ToastModule,
    InplaceModule, TooltipModule, ProgressSpinnerModule, SharedModule
  ],
  providers: [MessageService]
})
export class ParametrosModule {}

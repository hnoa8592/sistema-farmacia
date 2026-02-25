import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { UsuariosRoutingModule } from './usuarios-routing.module';
import { ListaUsuariosComponent } from './gestion/lista-usuarios.component';
import { ListaPerfilesComponent } from './perfiles/lista-perfiles.component';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { InputTextareaModule } from 'primeng/inputtextarea';
import { DropdownModule } from 'primeng/dropdown';
import { MultiSelectModule } from 'primeng/multiselect';
import { DialogModule } from 'primeng/dialog';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { ToastModule } from 'primeng/toast';
import { TagModule } from 'primeng/tag';
import { ChipModule } from 'primeng/chip';
import { CheckboxModule } from 'primeng/checkbox';
import { InputSwitchModule } from 'primeng/inputswitch';
import { PasswordModule } from 'primeng/password';
import { TooltipModule } from 'primeng/tooltip';
import { CardModule } from 'primeng/card';
import { ConfirmationService, MessageService } from 'primeng/api';
import { SharedModule } from 'src/app/shared/shared.module';

@NgModule({
  declarations: [ListaUsuariosComponent, ListaPerfilesComponent],
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule,
    UsuariosRoutingModule,
    TableModule, ButtonModule, InputTextModule, InputTextareaModule,
    DropdownModule, MultiSelectModule, DialogModule, ConfirmDialogModule,
    ToastModule, TagModule, ChipModule, CheckboxModule, InputSwitchModule,
    PasswordModule, TooltipModule, CardModule, SharedModule
  ],
  providers: [ConfirmationService, MessageService]
})
export class UsuariosModule {}

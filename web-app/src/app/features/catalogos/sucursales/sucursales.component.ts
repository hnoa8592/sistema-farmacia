import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ConfirmationService, MessageService } from 'primeng/api';
import { SucursalService } from '../services/sucursal.service';
import { Sucursal } from '../models/sucursal.model';

@Component({
  selector: 'app-sucursales',
  templateUrl: './sucursales.component.html',
  providers: [ConfirmationService, MessageService]
})
export class SucursalesComponent implements OnInit {
  sucursales: Sucursal[] = [];
  cargando = true;
  mostrarFormulario = false;
  sucursalSeleccionada: Sucursal | null = null;
  form!: FormGroup;
  guardando = false;

  constructor(private service: SucursalService, private fb: FormBuilder,
    private confirmationService: ConfirmationService, private messageService: MessageService) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      nombre: ['', Validators.required],
      direccion: ['', Validators.required],
      telefono: [''],
      esMatriz: [false]
    });
    this.cargar();
  }

  cargar(): void {
    this.cargando = true;
    this.service.getSucursales().subscribe({ next: s => { this.sucursales = s; this.cargando = false; }, error: () => { this.cargando = false; } });
  }
  nuevo(): void { this.sucursalSeleccionada = null; this.form.reset({ esMatriz: false }); this.mostrarFormulario = true; }
  editar(s: Sucursal): void { this.sucursalSeleccionada = { ...s }; this.form.patchValue(s); this.mostrarFormulario = true; }
  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const op = this.sucursalSeleccionada ? this.service.editar(this.sucursalSeleccionada.id, this.form.value) : this.service.crear(this.form.value);
    op.subscribe({ next: () => { this.guardando = false; this.mostrarFormulario = false; this.cargar(); }, error: () => { this.guardando = false; } });
  }
  eliminar(s: Sucursal): void {
    this.confirmationService.confirm({ message: `¿Eliminar la sucursal "${s.nombre}"?`, accept: () => {
      this.service.eliminar(s.id).subscribe({ next: () => { this.messageService.add({ severity: 'success', summary: 'Eliminada' }); this.cargar(); } });
    }});
  }
}

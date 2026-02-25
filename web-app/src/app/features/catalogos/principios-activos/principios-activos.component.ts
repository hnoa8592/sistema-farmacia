import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ConfirmationService, MessageService } from 'primeng/api';
import { PrincipioActivoService } from '../services/principio-activo.service';
import { PrincipioActivo } from '../models/principio-activo.model';

@Component({
  selector: 'app-principios-activos',
  templateUrl: './principios-activos.component.html',
  providers: [ConfirmationService, MessageService]
})
export class PrincipiosActivosComponent implements OnInit {
  items: PrincipioActivo[] = [];
  cargando = true;
  mostrarFormulario = false;
  itemSeleccionado: PrincipioActivo | null = null;
  form!: FormGroup;
  guardando = false;

  constructor(private service: PrincipioActivoService, private fb: FormBuilder,
    private confirmationService: ConfirmationService, private messageService: MessageService) {}

  ngOnInit(): void {
    this.form = this.fb.group({ nombre: ['', Validators.required], descripcion: [''] });
    this.cargar();
  }

  cargar(): void {
    this.cargando = true;
    this.service.getAll().subscribe({ next: d => { this.items = d.content; this.cargando = false; }, error: () => { this.cargando = false; } });
  }
  nuevo(): void { this.itemSeleccionado = null; this.form.reset(); this.mostrarFormulario = true; }
  editar(item: PrincipioActivo): void { this.itemSeleccionado = { ...item }; this.form.patchValue(item); this.mostrarFormulario = true; }
  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const op = this.itemSeleccionado ? this.service.editar(this.itemSeleccionado.id, this.form.value) : this.service.crear(this.form.value);
    op.subscribe({ next: () => { this.guardando = false; this.mostrarFormulario = false; this.cargar(); }, error: () => { this.guardando = false; } });
  }
  eliminar(item: PrincipioActivo): void {
    this.confirmationService.confirm({ message: `¿Eliminar "${item.nombre}"?`, accept: () => {
      this.service.eliminar(item.id).subscribe({ next: () => { this.messageService.add({ severity: 'success', summary: 'Eliminado' }); this.cargar(); } });
    }});
  }
}

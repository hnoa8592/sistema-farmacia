import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ConfirmationService, MessageService } from 'primeng/api';
import { LaboratorioService } from '../services/laboratorio.service';
import { Laboratorio } from '../models/laboratorio.model';

@Component({
  selector: 'app-laboratorios',
  templateUrl: './laboratorios.component.html',
  providers: [ConfirmationService, MessageService]
})
export class LaboratoriosComponent implements OnInit {
  laboratorios: Laboratorio[] = [];
  totalRegistros = 0;
  cargando = true;
  mostrarFormulario = false;
  labSeleccionado: Laboratorio | null = null;
  form!: FormGroup;
  guardando = false;

  constructor(private service: LaboratorioService, private fb: FormBuilder,
    private confirmationService: ConfirmationService, private messageService: MessageService) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      nombre: ['', Validators.required],
      pais: [''],
      direccion: [''],
      telefono: [''],
      email: ['', Validators.email]
    });
    this.cargar();
  }

  cargar(page = 0, size = 20): void {
    this.cargando = true;
    this.service.getAll(undefined, undefined, page, size).subscribe({
      next: p => { this.laboratorios = p.content; this.totalRegistros = p.totalElements; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  onLazyLoad(event: any): void { this.cargar(event.first / event.rows, event.rows); }
  nuevo(): void { this.labSeleccionado = null; this.form.reset(); this.mostrarFormulario = true; }
  editar(lab: Laboratorio): void { this.labSeleccionado = { ...lab }; this.form.patchValue(lab); this.mostrarFormulario = true; }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const op = this.labSeleccionado
      ? this.service.editar(this.labSeleccionado.id, this.form.value)
      : this.service.crear(this.form.value);
    op.subscribe({ next: () => { this.guardando = false; this.mostrarFormulario = false; this.cargar(); }, error: () => { this.guardando = false; } });
  }

  eliminar(lab: Laboratorio): void {
    this.confirmationService.confirm({ message: `¿Eliminar laboratorio "${lab.nombre}"?`, accept: () => {
      this.service.eliminar(lab.id).subscribe({ next: () => { this.messageService.add({ severity: 'success', summary: 'Eliminado' }); this.cargar(); } });
    }});
  }
}

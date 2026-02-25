import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MessageService } from 'primeng/api';
import { PerfilService } from '../services/perfil.service';
import { PerfilResponse } from '../models/perfil.model';
import { RecursoResponse } from '../models/recurso.model';

@Component({
  selector: 'app-lista-perfiles',
  templateUrl: './lista-perfiles.component.html',
  providers: [MessageService]
})
export class ListaPerfilesComponent implements OnInit {
  perfiles: PerfilResponse[] = [];
  recursos: RecursoResponse[] = [];
  cargando = true;
  mostrarFormulario = false;
  perfilSeleccionado: PerfilResponse | null = null;
  form!: FormGroup;
  guardando = false;

  get modulosRecursos(): string[] {
    return [...new Set(this.recursos.map(r => r.modulo))];
  }

  getRecursosPorModulo(modulo: string): RecursoResponse[] {
    return this.recursos.filter(r => r.modulo === modulo);
  }

  constructor(private perfilService: PerfilService, private fb: FormBuilder, private messageService: MessageService) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      nombre: ['', Validators.required],
      descripcion: ['', Validators.required],
      recursosIds: [[]]
    });
    this.perfilService.getRecursos().subscribe(r => this.recursos = r);
    this.cargar();
  }

  cargar(): void {
    this.cargando = true;
    this.perfilService.getPerfiles().subscribe({
      next: p => { this.perfiles = p; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  nuevo(): void { this.perfilSeleccionado = null; this.form.reset({ recursosIds: [] }); this.mostrarFormulario = true; }

  editar(p: PerfilResponse): void {
    this.perfilSeleccionado = { ...p };
    this.form.patchValue({ nombre: p.nombre, descripcion: p.descripcion, recursosIds: p.recursos.map(r => r.id) });
    this.mostrarFormulario = true;
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const v = this.form.value;
    const op = this.perfilSeleccionado
      ? this.perfilService.editarPerfil(this.perfilSeleccionado.id, v)
      : this.perfilService.crearPerfil(v);
    op.subscribe({
      next: () => { this.guardando = false; this.mostrarFormulario = false; this.cargar(); },
      error: (e) => { this.guardando = false; this.messageService.add({ severity: 'error', summary: 'Error', detail: e?.error?.message || 'Error al guardar' }); }
    });
  }
}

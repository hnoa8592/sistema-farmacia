import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ConfirmationService, MessageService } from 'primeng/api';
import { finalize } from 'rxjs';
import { UsuarioService } from '../services/usuario.service';
import { PerfilService } from '../services/perfil.service';
import { UsuarioResponse } from '../models/usuario.model';
import { PerfilResponse } from '../models/perfil.model';

@Component({
  selector: 'app-lista-usuarios',
  templateUrl: './lista-usuarios.component.html',
  providers: [ConfirmationService, MessageService]
})
export class ListaUsuariosComponent implements OnInit {
  usuarios: UsuarioResponse[] = [];
  totalRegistros = 0;
  cargando = true;
  mostrarFormulario = false;
  usuarioSeleccionado: UsuarioResponse | null = null;
  perfiles: PerfilResponse[] = [];
  form!: FormGroup;
  guardando = false;

  constructor(
    private usuarioService: UsuarioService,
    private perfilService: PerfilService,
    private fb: FormBuilder,
    private confirmationService: ConfirmationService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      nombre: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      password: [''],
      activo: [true],
      perfilesIds: [[]]
    });
    this.perfilService.getPerfiles().subscribe(p => this.perfiles = this.perfilesUnicos(p));
    this.cargar(0, 10);
  }

  cargar(page: number, size: number): void {
    this.cargando = true;
    this.usuarioService.getUsuarios(page, size).subscribe({
      next: p => { this.usuarios = p.content; this.totalRegistros = p.totalElements; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  onLazyLoad(event: any): void { this.cargar(event.first / event.rows, event.rows); }

  nuevo(): void {
    this.usuarioSeleccionado = null;
    this.form.reset({ activo: true, perfilesIds: [] });
    this.form.get('password')!.setValidators([Validators.required, Validators.minLength(8)]);
    this.form.get('password')!.updateValueAndValidity();
    this.mostrarFormulario = true;
  }

  editar(u: UsuarioResponse): void {
    this.usuarioSeleccionado = { ...u };
    this.form.get('password')!.clearValidators();
    this.form.get('password')!.updateValueAndValidity();
    this.form.patchValue({
      nombre: u.nombre, email: u.email, activo: u.activo,
      perfilesIds: u.perfiles.map(p => p.id)
    });
    this.mostrarFormulario = true;
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const v = this.form.value;
    const req: any = { nombre: v.nombre, email: v.email, activo: v.activo, perfilIds: v.perfilesIds ?? [] };
    if (v.password) req.password = v.password;

    const op = this.usuarioSeleccionado
      ? this.usuarioService.editarUsuario(this.usuarioSeleccionado.id, req)
      : this.usuarioService.crearUsuario(req);

    op.pipe(finalize(() => this.guardando = false)).subscribe({
      next: () => {
        this.mostrarFormulario = false;
        this.cargar(0, 10);
      },
      error: (e) => { this.messageService.add({ severity: 'error', summary: 'Error', detail: e?.error?.message || 'Error al guardar' }); }
    });
  }

  private perfilesUnicos(perfiles: PerfilResponse[]): PerfilResponse[] {
    const porNombre = new Map<string, PerfilResponse>();
    perfiles.forEach(p => {
      if (!porNombre.has(p.nombre)) {
        porNombre.set(p.nombre, p);
      }
    });
    return Array.from(porNombre.values()).sort((a, b) => a.nombre.localeCompare(b.nombre));
  }

  desactivar(u: UsuarioResponse): void {
    this.confirmationService.confirm({
      message: `¿Desactivar el usuario "${u.nombre}"?`,
      accept: () => {
        this.usuarioService.desactivarUsuario(u.id).subscribe({
          next: () => { this.messageService.add({ severity: 'success', summary: 'Usuario desactivado' }); this.cargar(0, 10); }
        });
      }
    });
  }
}

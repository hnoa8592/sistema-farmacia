import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ConfirmationService, MessageService } from 'primeng/api';
import { CatalogoService } from '../services/catalogo.service';
import { CatalogoDTO } from '../models/catalogo.model';

@Component({
  selector: 'app-categorias',
  templateUrl: './categorias.component.html',
  providers: [ConfirmationService, MessageService]
})
export class CategoriasComponent implements OnInit {
  items: CatalogoDTO[] = [];
  cargando = true;
  mostrarFormulario = false;
  itemSeleccionado: CatalogoDTO | null = null;
  form!: FormGroup;
  guardando = false;

  constructor(
    private catalogoService: CatalogoService,
    private fb: FormBuilder,
    private confirmationService: ConfirmationService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      nombre: ['', Validators.required],
      descripcion: ['']
    });
    this.cargar();
  }

  cargar(): void {
    this.cargando = true;
    this.catalogoService.getCategorias().subscribe({
      next: d => { this.items = d; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  nuevo(): void { this.itemSeleccionado = null; this.form.reset(); this.mostrarFormulario = true; }

  editar(item: CatalogoDTO): void {
    this.itemSeleccionado = { ...item };
    this.form.patchValue(item);
    this.mostrarFormulario = true;
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const req = this.form.value;
    const op = this.itemSeleccionado
      ? this.catalogoService.editarCategoria(this.itemSeleccionado.id, req)
      : this.catalogoService.crearCategoria(req);
    op.subscribe({
      next: () => { this.guardando = false; this.mostrarFormulario = false; this.cargar(); },
      error: (e) => { this.guardando = false; this.messageService.add({ severity: 'error', summary: 'Error', detail: e?.error?.message || 'Error al guardar' }); }
    });
  }

  eliminar(item: CatalogoDTO): void {
    this.confirmationService.confirm({
      message: `¿Desea eliminar "${item.nombre}"?`,
      header: 'Confirmar',
      accept: () => {
        this.catalogoService.eliminarCategoria(item.id).subscribe({
          next: () => { this.messageService.add({ severity: 'success', summary: 'Eliminado' }); this.cargar(); },
          error: () => this.messageService.add({ severity: 'error', summary: 'Error', detail: 'No se pudo eliminar' })
        });
      }
    });
  }
}

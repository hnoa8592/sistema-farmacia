import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ConfirmationService, MessageService } from 'primeng/api';
import { CatalogoService } from '../services/catalogo.service';
import { CatalogoDTO } from '../models/catalogo.model';

@Component({
  selector: 'app-vias',
  templateUrl: './vias.component.html',
  providers: [ConfirmationService, MessageService]
})
export class ViasComponent implements OnInit {
  items: CatalogoDTO[] = [];
  cargando = true;
  mostrarFormulario = false;
  itemSeleccionado: CatalogoDTO | null = null;
  form!: FormGroup;
  guardando = false;

  constructor(private catalogoService: CatalogoService, private fb: FormBuilder,
    private confirmationService: ConfirmationService, private messageService: MessageService) {}

  ngOnInit(): void {
    this.form = this.fb.group({ nombre: ['', Validators.required], descripcion: [''] });
    this.cargar();
  }

  cargar(): void {
    this.cargando = true;
    this.catalogoService.getVias().subscribe({ next: d => { this.items = d; this.cargando = false; }, error: () => { this.cargando = false; } });
  }
  nuevo(): void { this.itemSeleccionado = null; this.form.reset(); this.mostrarFormulario = true; }
  editar(item: CatalogoDTO): void { this.itemSeleccionado = { ...item }; this.form.patchValue(item); this.mostrarFormulario = true; }
  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const op = this.itemSeleccionado ? this.catalogoService.editarVia(this.itemSeleccionado.id, this.form.value) : this.catalogoService.crearVia(this.form.value);
    op.subscribe({ next: () => { this.guardando = false; this.mostrarFormulario = false; this.cargar(); }, error: () => { this.guardando = false; } });
  }
  eliminar(item: CatalogoDTO): void {
    this.confirmationService.confirm({ message: `¿Eliminar "${item.nombre}"?`, accept: () => {
      this.catalogoService.eliminarVia(item.id).subscribe({ next: () => { this.messageService.add({ severity: 'success', summary: 'Eliminado' }); this.cargar(); }, error: () => {} });
    }});
  }
}

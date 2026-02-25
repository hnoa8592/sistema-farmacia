import { Component, EventEmitter, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MessageService } from 'primeng/api';
import { forkJoin } from 'rxjs';
import { ProductoService } from '../../services/producto.service';
import { CatalogoService } from '../../../catalogos/services/catalogo.service';
import { ProductoResponse } from '../../models/producto.model';
import { CatalogoDTO } from '../../../catalogos/models/catalogo.model';

@Component({
  selector: 'app-form-producto',
  templateUrl: './form-producto.component.html',
  providers: [MessageService]
})
export class FormProductoComponent implements OnInit, OnChanges {
  @Input() visible = false;
  @Input() producto: ProductoResponse | null = null;
  @Output() visibleChange = new EventEmitter<boolean>();
  @Output() guardado = new EventEmitter<void>();

  form!: FormGroup;
  categorias: CatalogoDTO[] = [];
  formas: CatalogoDTO[] = [];
  vias: CatalogoDTO[] = [];
  guardando = false;
  catalogosCargados = false;

  constructor(
    private fb: FormBuilder,
    private productoService: ProductoService,
    private catalogoService: CatalogoService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      nombre:              ['', Validators.required],
      nombreComercial:     [''],
      codigo:              ['', Validators.required],
      codigoBarra:         [''],
      descripcion:         [''],
      concentracion:       [''],
      presentacion:        [''],
      requiereReceta:      [false],
      controlado:          [false],
      categoriaId:         ['', Validators.required],
      formaFarmaceuticaId: ['', Validators.required],
      viaAdministracionId: ['', Validators.required]
    });

    this.cargarCatalogos();
  }

  ngOnChanges(changes: SimpleChanges): void {
    // React to producto input changes only when the form is ready
    if (changes['producto'] && this.form) {
      if (this.catalogosCargados) {
        this.patchFormConProducto();
      }
      // If catalogs not loaded yet, cargarCatalogos() will patch after loading
    }
  }

  cargarCatalogos(): void {
    forkJoin({
      categorias: this.catalogoService.getCategorias(),
      formas:     this.catalogoService.getFormas(),
      vias:       this.catalogoService.getVias()
    }).subscribe({
      next: ({ categorias, formas, vias }) => {
        this.categorias = categorias.filter(c => c.activo);
        this.formas     = formas.filter(f => f.activo);
        this.vias       = vias.filter(v => v.activo);
        this.catalogosCargados = true;
        // Patch now that catalogs are available
        this.patchFormConProducto();
      },
      error: () => {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'No se pudieron cargar los catálogos'
        });
      }
    });
  }

  /**
   * Patches the form with the current product's data.
   * Must be called AFTER catalogs are loaded so dropdown selections work correctly.
   */
  private patchFormConProducto(): void {
    if (!this.form) return;

    if (this.producto) {
      this.form.patchValue({
        nombre:              this.producto.nombre,
        nombreComercial:     this.producto.nombreComercial ?? '',
        codigo:              this.producto.codigo,
        codigoBarra:         this.producto.codigoBarra ?? '',
        descripcion:         this.producto.descripcion ?? '',
        concentracion:       this.producto.concentracion ?? '',
        presentacion:        this.producto.presentacion ?? '',
        requiereReceta:      this.producto.requiereReceta,
        controlado:          this.producto.controlado,
        categoriaId:         this.producto.categoria?.id ?? '',
        formaFarmaceuticaId: this.producto.formaFarmaceutica?.id ?? '',
        viaAdministracionId: this.producto.viaAdministracion?.id ?? ''
      });
    } else {
      this.form.reset({ requiereReceta: false, controlado: false });
    }
  }

  get titulo(): string {
    return this.producto ? 'Editar Producto' : 'Nuevo Producto';
  }

  guardar(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.guardando = true;
    const req = this.form.value;
    const op = this.producto
      ? this.productoService.editarProducto(this.producto.id, req)
      : this.productoService.crearProducto(req);

    op.subscribe({
      next: () => {
        this.guardando = false;
        this.messageService.add({
          severity: 'success',
          summary: this.producto ? 'Producto actualizado' : 'Producto creado',
          detail: `"${this.form.value.nombre}" guardado correctamente`,
          life: 3000
        });
        this.guardado.emit();
        this.cerrar();
      },
      error: (e) => {
        this.guardando = false;
        this.messageService.add({
          severity: 'error',
          summary: 'Error al guardar',
          detail: e?.error?.message || 'No se pudo guardar el producto'
        });
      }
    });
  }

  cerrar(): void {
    this.visible = false;
    this.visibleChange.emit(false);
    this.form.reset({ requiereReceta: false, controlado: false });
  }
}

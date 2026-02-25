import { Component, EventEmitter, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MessageService } from 'primeng/api';
import { ProductoPrecioService } from '../services/producto-precio.service';
import { ProductoPrecioDTO } from '../models/producto-precio.model';

@Component({
  selector: 'app-form-precio',
  template: `
    <p-dialog [header]="precio ? 'Editar Precio' : 'Nuevo Precio'" [(visible)]="visible"
      [modal]="true" [style]="{width:'420px'}" [draggable]="false" (onHide)="cerrar()">
      <form [formGroup]="form" class="p-fluid">
        <div class="field">
          <label class="font-medium">Tipo de Precio <span class="text-red-500">*</span></label>
          <p-dropdown [options]="tiposPrecio" formControlName="tipoPrecio"
            optionLabel="label" optionValue="value" placeholder="Seleccione"
            [class.ng-invalid]="form.get('tipoPrecio')?.invalid && form.get('tipoPrecio')?.touched">
          </p-dropdown>
        </div>
        <div class="field">
          <label class="font-medium">Precio de Venta <span class="text-red-500">*</span></label>
          <p-inputNumber formControlName="precio" mode="currency" currency="BOB" locale="es-BO"
            placeholder="0.00" [min]="0.01"
            [class.ng-invalid]="form.get('precio')?.invalid && form.get('precio')?.touched">
          </p-inputNumber>
        </div>
        <div class="field">
          <label class="font-medium">Precio de Compra</label>
          <p-inputNumber formControlName="precioCompra" mode="currency" currency="BOB" locale="es-BO"
            placeholder="0.00">
          </p-inputNumber>
        </div>
        <div class="field">
          <label class="font-medium">Vigencia Desde <span class="text-red-500">*</span></label>
          <p-calendar formControlName="vigenciaDesde" [showTime]="true" [showSeconds]="false"
            dateFormat="dd/mm/yy" hourFormat="24" [showIcon]="true"
            [class.ng-invalid]="form.get('vigenciaDesde')?.invalid && form.get('vigenciaDesde')?.touched">
          </p-calendar>
        </div>
      </form>
      <ng-template pTemplate="footer">
        <p-button label="Cancelar" icon="pi pi-times" styleClass="p-button-outlined" (onClick)="cerrar()"></p-button>
        <p-button label="Guardar" icon="pi pi-check" [loading]="guardando" (onClick)="guardar()"></p-button>
      </ng-template>
    </p-dialog>
    <p-toast></p-toast>
  `,
  providers: [MessageService]
})
export class FormPrecioComponent implements OnInit, OnChanges {
  @Input() visible = false;
  @Input() productoId!: string;
  @Input() precio: ProductoPrecioDTO | null = null;
  @Output() visibleChange = new EventEmitter<boolean>();
  @Output() guardado = new EventEmitter<void>();

  form!: FormGroup;
  guardando = false;

  tiposPrecio = [
    { label: 'Unidad', value: 'UNIDAD' },
    { label: 'Tira', value: 'TIRA' },
    { label: 'Caja', value: 'CAJA' },
    { label: 'Fracción', value: 'FRACCION' }
  ];

  constructor(
    private fb: FormBuilder,
    private precioService: ProductoPrecioService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      tipoPrecio: ['UNIDAD', Validators.required],
      precio: [null, [Validators.required, Validators.min(0.01)]],
      precioCompra: [null],
      vigenciaDesde: [new Date(), Validators.required]
    });
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['precio'] && this.form && this.precio) {
      this.form.patchValue({
        tipoPrecio: this.precio.tipoPrecio,
        precio: this.precio.precio,
        precioCompra: this.precio.precioCompra,
        vigenciaDesde: new Date(this.precio.vigenciaDesde)
      });
    } else if (changes['precio'] && this.form && !this.precio) {
      this.form.reset({ tipoPrecio: 'UNIDAD', vigenciaDesde: new Date() });
    }
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const v = this.form.value;
    const req = {
      tipoPrecio: v.tipoPrecio,
      precio: v.precio,
      precioCompra: v.precioCompra,
      vigenciaDesde: (v.vigenciaDesde as Date).toISOString()
    };
    const op = this.precio
      ? this.precioService.editarPrecio(this.productoId, this.precio.id, req)
      : this.precioService.crearPrecio(this.productoId, req);

    op.subscribe({
      next: () => { this.guardando = false; this.guardado.emit(); this.cerrar(); },
      error: (e) => { this.guardando = false; this.messageService.add({ severity: 'error', summary: 'Error', detail: e?.error?.message || 'No se pudo guardar el precio' }); }
    });
  }

  cerrar(): void {
    this.visible = false;
    this.visibleChange.emit(false);
    this.form.reset({ tipoPrecio: 'UNIDAD', vigenciaDesde: new Date() });
  }
}

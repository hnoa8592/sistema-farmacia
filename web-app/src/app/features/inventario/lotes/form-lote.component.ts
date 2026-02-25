import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MessageService } from 'primeng/api';
import { ProductoLoteService } from '../services/producto-lote.service';
import { LaboratorioService } from '../../catalogos/services/laboratorio.service';
import { SucursalService } from '../../catalogos/services/sucursal.service';
import { Laboratorio } from '../../catalogos/models/laboratorio.model';
import { Sucursal } from '../../catalogos/models/sucursal.model';

@Component({
  selector: 'app-form-lote',
  template: `
    <p-dialog header="Registrar Lote" [(visible)]="visible" [modal]="true"
      [style]="{width:'500px'}" [draggable]="false" (onHide)="cerrar()">
      <form [formGroup]="form" class="p-fluid">
        <div class="field">
          <label class="font-medium">Laboratorio <span class="text-red-500">*</span></label>
          <p-dropdown [options]="laboratorios" formControlName="laboratorioId"
            optionLabel="nombre" optionValue="id" placeholder="Seleccione laboratorio"
            [class.ng-invalid]="form.get('laboratorioId')?.invalid && form.get('laboratorioId')?.touched">
          </p-dropdown>
        </div>
        <div class="field">
          <label class="font-medium">Sucursal <span class="text-red-500">*</span></label>
          <p-dropdown [options]="sucursales" formControlName="sucursalId"
            optionLabel="nombre" optionValue="id" placeholder="Seleccione sucursal"
            [class.ng-invalid]="form.get('sucursalId')?.invalid && form.get('sucursalId')?.touched">
          </p-dropdown>
        </div>
        <div class="field">
          <label class="font-medium">N° de Lote <span class="text-red-500">*</span></label>
          <input type="text" pInputText formControlName="numeroLote" placeholder="Ej: LOT-2024-001"
            [class.ng-invalid]="form.get('numeroLote')?.invalid && form.get('numeroLote')?.touched" />
        </div>
        <div class="grid">
          <div class="col-6 field">
            <label class="font-medium">Fecha Fabricación</label>
            <p-calendar formControlName="fechaFabricacion" dateFormat="dd/mm/yy"
              placeholder="Opcional" [showIcon]="true" [maxDate]="hoy">
            </p-calendar>
          </div>
          <div class="col-6 field">
            <label class="font-medium">Fecha Vencimiento <span class="text-red-500">*</span></label>
            <p-calendar formControlName="fechaVencimiento" dateFormat="dd/mm/yy"
              placeholder="Requerido" [showIcon]="true" [minDate]="hoy"
              [class.ng-invalid]="form.get('fechaVencimiento')?.invalid && form.get('fechaVencimiento')?.touched">
            </p-calendar>
          </div>
        </div>
        <div class="field">
          <label class="font-medium">Cantidad Inicial <span class="text-red-500">*</span></label>
          <p-inputNumber formControlName="cantidadInicial" [min]="1" placeholder="Unidades"
            [class.ng-invalid]="form.get('cantidadInicial')?.invalid && form.get('cantidadInicial')?.touched">
          </p-inputNumber>
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
export class FormLoteComponent implements OnInit {
  @Input() visible = false;
  @Input() productoId!: string;
  @Output() visibleChange = new EventEmitter<boolean>();
  @Output() guardado = new EventEmitter<void>();

  form!: FormGroup;
  laboratorios: Laboratorio[] = [];
  sucursales: Sucursal[] = [];
  guardando = false;
  hoy = new Date();

  constructor(
    private fb: FormBuilder,
    private loteService: ProductoLoteService,
    private laboratorioService: LaboratorioService,
    private sucursalService: SucursalService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      laboratorioId: ['', Validators.required],
      sucursalId: ['', Validators.required],
      numeroLote: ['', Validators.required],
      fechaFabricacion: [null],
      fechaVencimiento: [null, Validators.required],
      cantidadInicial: [null, [Validators.required, Validators.min(1)]]
    });
    this.laboratorioService.getAll().subscribe(p => this.laboratorios = p.content.filter(l => l.activo));
    this.sucursalService.getSucursales().subscribe(s => this.sucursales = s.filter(x => x.activo));
  }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.guardando = true;
    const v = this.form.value;
    const req = {
      laboratorioId: v.laboratorioId,
      sucursalId: v.sucursalId,
      numeroLote: v.numeroLote,
      fechaFabricacion: v.fechaFabricacion ? (v.fechaFabricacion as Date).toISOString().split('T')[0] : null,
      fechaVencimiento: (v.fechaVencimiento as Date).toISOString().split('T')[0],
      cantidadInicial: v.cantidadInicial
    };
    this.loteService.crearLote(this.productoId, req).subscribe({
      next: () => { this.guardando = false; this.guardado.emit(); this.cerrar(); },
      error: (e) => { this.guardando = false; this.messageService.add({ severity: 'error', summary: 'Error', detail: e?.error?.message || 'No se pudo guardar el lote' }); }
    });
  }

  cerrar(): void {
    this.visible = false;
    this.visibleChange.emit(false);
    this.form.reset();
  }
}

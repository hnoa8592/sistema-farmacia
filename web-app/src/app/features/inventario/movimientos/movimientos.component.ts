import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MessageService } from 'primeng/api';
import { InventarioService } from '../services/inventario.service';
import { SucursalService } from '../../catalogos/services/sucursal.service';
import { MovimientoResponse, TipoMovimiento } from '../models/movimiento.model';
import { InventarioResponse } from '../models/inventario.model';
import { Sucursal } from '../../catalogos/models/sucursal.model';
import { PageResponse } from 'src/app/shared/models/api-response.model';

@Component({
  selector: 'app-movimientos',
  templateUrl: './movimientos.component.html',
  providers: [MessageService]
})
export class MovimientosComponent implements OnInit {
  movimientos: MovimientoResponse[] = [];
  totalRegistros = 0;
  cargando = true;
  sucursales: Sucursal[] = [];
  inventarios: InventarioResponse[] = [];

  private hoy(): Date { const d = new Date(); d.setHours(0, 0, 0, 0); return d; }
  filtros = { desde: this.hoy(), hasta: this.hoy(), tipo: '', sucursalId: '' };
  tiposMovimiento = [
    { label: 'Todos', value: '' },
    { label: 'Entrada', value: 'ENTRADA' },
    { label: 'Salida', value: 'SALIDA' },
    { label: 'Ajuste', value: 'AJUSTE' },
    { label: 'Transferencia', value: 'TRANSFERENCIA' }
  ];

  tipoDialogo: 'ENTRADA' | 'SALIDA' | 'AJUSTE' | null = null;
  mostrarDialogo = false;
  formMovimiento!: FormGroup;
  guardando = false;

  constructor(
    private inventarioService: InventarioService,
    private sucursalService: SucursalService,
    private fb: FormBuilder,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.cargarMovimientos(0, 10);
    this.sucursalService.getSucursales().subscribe(s => {
      this.sucursales = s.filter(x => x.activo);
    });
    this.inventarioService.getStock({ soloConStock: false }).subscribe(stock => {
      this.inventarios = stock;
    });
    this.formMovimiento = this.fb.group({
      inventarioId: ['', Validators.required],
      cantidad: [null, [Validators.required, Validators.min(1)]],
      observacion: ['']
    });
  }

  cargarMovimientos(page: number, size: number): void {
    this.cargando = true;
    const f: any = {};
    if (this.filtros.desde) f.desde = this.filtros.desde.toISOString().split('T')[0];
    if (this.filtros.hasta) f.hasta = this.filtros.hasta.toISOString().split('T')[0];
    if (this.filtros.tipo) f.tipo = this.filtros.tipo;
    if (this.filtros.sucursalId) f.sucursalId = this.filtros.sucursalId;

    this.inventarioService.getMovimientos(page, size, f).subscribe({
      next: (p: PageResponse<MovimientoResponse>) => {
        this.movimientos = p.content;
        this.totalRegistros = p.totalElements;
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });
  }

  onLazyLoad(event: any): void {
    this.cargarMovimientos(event.first / event.rows, event.rows);
  }

  abrirDialogo(tipo: 'ENTRADA' | 'SALIDA' | 'AJUSTE'): void {
    this.tipoDialogo = tipo;
    this.mostrarDialogo = true;
    this.formMovimiento.reset();
    if (tipo === 'AJUSTE') {
      this.formMovimiento.get('cantidad')!.setValidators([Validators.required, Validators.min(0)]);
      this.formMovimiento.get('cantidad')!.updateValueAndValidity();
    }
  }

  registrar(): void {
    if (this.formMovimiento.invalid) { this.formMovimiento.markAllAsTouched(); return; }
    this.guardando = true;
    const v = this.formMovimiento.value;
    let op;

    if (this.tipoDialogo === 'ENTRADA') {
      op = this.inventarioService.registrarEntrada({ inventarioId: v.inventarioId, cantidad: v.cantidad, observacion: v.observacion });
    } else if (this.tipoDialogo === 'SALIDA') {
      op = this.inventarioService.registrarSalida({ inventarioId: v.inventarioId, cantidad: v.cantidad, observacion: v.observacion });
    } else {
      op = this.inventarioService.registrarAjuste({ inventarioId: v.inventarioId, stockNuevo: v.cantidad, observacion: v.observacion });
    }

    op.subscribe({
      next: () => {
        this.guardando = false;
        this.mostrarDialogo = false;
        this.messageService.add({ severity: 'success', summary: 'Movimiento registrado', detail: 'El movimiento fue registrado exitosamente' });
        this.cargarMovimientos(0, 10);
      },
      error: (e) => {
        this.guardando = false;
        this.messageService.add({ severity: 'error', summary: 'Error', detail: e?.error?.message || 'No se pudo registrar el movimiento' });
      }
    });
  }

  getSeveridad(tipo: TipoMovimiento): string {
    const map: Record<string, string> = { ENTRADA: 'success', SALIDA: 'danger', AJUSTE: 'warning', TRANSFERENCIA: 'info' };
    return map[tipo] || 'info';
  }

  aplicarFiltros(): void { this.cargarMovimientos(0, 10); }
  limpiarFiltros(): void {
    this.filtros = { desde: this.hoy(), hasta: this.hoy(), tipo: '', sucursalId: '' };
    this.cargarMovimientos(0, 10);
  }
}

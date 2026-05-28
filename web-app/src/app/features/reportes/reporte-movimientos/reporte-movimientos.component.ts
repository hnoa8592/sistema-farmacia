import { Component, OnInit } from '@angular/core';
import { ReporteService } from '../services/reporte.service';
import { SucursalService } from '../../catalogos/services/sucursal.service';
import { Sucursal } from '../../catalogos/models/sucursal.model';

@Component({
  selector: 'app-reporte-movimientos',
  templateUrl: './reporte-movimientos.component.html'
})
export class ReporteMovimientosComponent implements OnInit {
  movimientos: any[] = [];
  totalRegistros = 0;
  cargando = false;
  exportando = false;
  sucursales: Sucursal[] = [];

  private hoy(): Date { const d = new Date(); d.setHours(0, 0, 0, 0); return d; }
  filtros = { desde: this.hoy(), hasta: this.hoy(), tipo: '', sucursalId: '' };

  tiposMovimiento = [
    { label: 'Todos', value: '' },
    { label: 'Entrada', value: 'ENTRADA' },
    { label: 'Salida', value: 'SALIDA' },
    { label: 'Ajuste', value: 'AJUSTE' },
    { label: 'Transferencia', value: 'TRANSFERENCIA' }
  ];

  private paginaActual = 0;
  private tamPagina = 10;

  constructor(
    private reporteService: ReporteService,
    private sucursalService: SucursalService
  ) {}

  ngOnInit(): void {
    this.sucursalService.getSucursales().subscribe(s => {
      this.sucursales = s.filter(x => x.activo);
    });
    this.cargar(0, 10);
  }

  cargar(page: number, size: number): void {
    this.cargando = true;
    this.paginaActual = page;
    this.tamPagina = size;
    const d = this.filtros.desde.toISOString().split('T')[0];
    const h = this.filtros.hasta.toISOString().split('T')[0];
    this.reporteService.getReporteMovimientos(
      d, h, this.filtros.tipo || undefined, this.filtros.sucursalId || undefined, page, size
    ).subscribe({
      next: p => {
        this.movimientos = p.content;
        this.totalRegistros = p.totalElements;
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });
  }

  onLazyLoad(event: any): void {
    this.cargar(event.first / event.rows, event.rows);
  }

  aplicarFiltros(): void { this.cargar(0, this.tamPagina); }

  limpiarFiltros(): void {
    this.filtros = { desde: this.hoy(), hasta: this.hoy(), tipo: '', sucursalId: '' };
    this.cargar(0, this.tamPagina);
  }

  getTipoSeveridad(tipo: string): string {
    return ({ ENTRADA: 'success', SALIDA: 'danger', AJUSTE: 'warning', TRANSFERENCIA: 'info' } as any)[tipo] || 'info';
  }

  exportarCSV(): void {
    if (this.exportando) return;
    this.exportando = true;

    const d = this.filtros.desde.toISOString().split('T')[0];
    const h = this.filtros.hasta.toISOString().split('T')[0];

    this.reporteService.exportarMovimientosCSV(
      d, h,
      this.filtros.tipo || undefined,
      this.filtros.sucursalId || undefined
    ).subscribe({
      next: blob => {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `movimientos_${d}_${h}.csv`;
        a.click();
        URL.revokeObjectURL(url);
        this.exportando = false;
      },
      error: () => { this.exportando = false; }
    });
  }
}

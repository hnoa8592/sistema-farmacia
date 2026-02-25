import { Component, OnInit } from '@angular/core';
import { AuditoriaService } from './services/auditoria.service';
import { AuditLogResponse, AuditFiltro, AccionAudit } from './models/audit-log.model';

@Component({
  selector: 'app-lista-auditoria',
  templateUrl: './lista-auditoria.component.html'
})
export class ListaAuditoriaComponent implements OnInit {
  logs: AuditLogResponse[] = [];
  totalRegistros = 0;
  cargando = true;
  logDetalle: AuditLogResponse | null = null;
  mostrarDetalle = false;

  filtros: AuditFiltro = { page: 0, size: 10 };
  desdeDate: Date | null = null;
  hastaDate: Date | null = null;

  modulosOpciones = [
    { label: 'Todos', value: '' },
    { label: 'VENTAS', value: 'VENTAS' },
    { label: 'INVENTARIO', value: 'INVENTARIO' },
    { label: 'CATALOGOS', value: 'CATALOGOS' },
    { label: 'USUARIOS', value: 'USUARIOS' },
    { label: 'SISTEMA', value: 'SISTEMA' }
  ];

  accionesOpciones = [
    { label: 'Todas', value: '' },
    { label: 'CREAR', value: 'CREAR' },
    { label: 'EDITAR', value: 'EDITAR' },
    { label: 'ELIMINAR', value: 'ELIMINAR' },
    { label: 'LOGIN', value: 'LOGIN' },
    { label: 'ANULAR', value: 'ANULAR' }
  ];

  constructor(private auditoriaService: AuditoriaService) {}

  ngOnInit(): void { this.cargar(0, 10); }

  cargar(page: number, size: number): void {
    this.cargando = true;
    const f: AuditFiltro = { ...this.filtros, page, size };
    if (this.desdeDate) f.desde = this.desdeDate.toISOString();
    if (this.hastaDate) f.hasta = this.hastaDate.toISOString();
    this.auditoriaService.getLogs(f).subscribe({
      next: p => { this.logs = p.content; this.totalRegistros = p.totalElements; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  onLazyLoad(event: any): void { this.cargar(event.first / event.rows, event.rows); }

  verDetalle(log: AuditLogResponse): void { this.logDetalle = log; this.mostrarDetalle = true; }

  formatJson(json: string | null): string {
    if (!json) return '—';
    try { return JSON.stringify(JSON.parse(json), null, 2); } catch { return json; }
  }

  getAccionSeveridad(accion: AccionAudit): string {
    const map: Record<string, string> = { CREAR: 'info', EDITAR: 'warning', ELIMINAR: 'danger', ANULAR: 'danger', LOGIN: 'success', LOGOUT: 'secondary', VER: 'secondary' };
    return map[accion] || 'info';
  }

  aplicarFiltros(): void { this.cargar(0, 10); }
  limpiarFiltros(): void { this.filtros = { page: 0, size: 10 }; this.desdeDate = null; this.hastaDate = null; this.cargar(0, 10); }
}

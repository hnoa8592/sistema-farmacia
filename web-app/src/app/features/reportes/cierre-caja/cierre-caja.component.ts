import {Component, OnInit} from '@angular/core';
import {MessageService} from 'primeng/api';
import {
    AperturaCajaRequest, CajaResponseDTO, CierreCajaRequest,
    MovimientoCajaRequest, ReporteCierreCajaDTO
} from './cierre-caja.model';
import {CajaService} from '../services/caja.service';
import {SucursalService} from '../../catalogos/services/sucursal.service';
import {Sucursal} from '../../catalogos/models/sucursal.model';

@Component({
    selector: 'app-cierre-caja',
    templateUrl: './cierre-caja.component.html',
    providers: [MessageService]
})
export class CierreCajaComponent implements OnInit {

    cargando = false;
    cajaActiva: CajaResponseDTO | null = null;
    reporte: ReporteCierreCajaDTO | null = null;

    // Sucursales
    sucursales: Sucursal[] = [];
    sucursalesOpciones: { label: string; value: string }[] = [];

    // Historial
    historial: CajaResponseDTO[] = [];
    totalHistorial = 0;
    pageSize = 10;
    desdeHistorial: Date = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
    hastaHistorial: Date = new Date();
    sucursalIdHistorial = '';

    // Diálogos
    mostrarApertura = false;
    mostrarCierre = false;
    mostrarRetiro = false;
    mostrarIngreso = false;
    mostrarReporte = false;

    // Forms
    sucursalIdInput = '';
    montoApertura: number | null = null;
    montoContado: number | null = null;
    observacionCierre = '';
    montoMovimiento: number | null = null;
    descripcionMovimiento = '';

    constructor(
        private cajaService: CajaService,
        private sucursalService: SucursalService,
        private messageService: MessageService
    ) {
    }

    ngOnInit(): void {
        this.sucursalService.getSucursales().subscribe(s => {
            this.sucursales = s.filter(x => x.activo);
            this.sucursalesOpciones = [
                {label: 'Todas las sucursales', value: ''},
                ...this.sucursales.map(x => ({label: x.nombre, value: x.id}))
            ];
        });
        this.cargarHistorial();
    }

    abrirDialogoApertura(): void {
        this.sucursalIdInput = '';
        this.montoApertura = null;
        this.mostrarApertura = true;
    }

    confirmarApertura(): void {
        if (!this.sucursalIdInput || this.montoApertura === null) return;
        const req: AperturaCajaRequest = {
            sucursalId: this.sucursalIdInput,
            montoApertura: this.montoApertura
        };
        this.cargando = true;
        this.cajaService.abrir(req).subscribe({
            next: caja => {
                this.cajaActiva = caja;
                this.mostrarApertura = false;
                this.cargando = false;
                this.messageService.add({
                    severity: 'success',
                    summary: 'Caja abierta',
                    detail: 'La caja fue abierta correctamente'
                });
            },
            error: e => {
                this.cargando = false;
                this.messageService.add({
                    severity: 'error',
                    summary: 'Error',
                    detail: e?.error?.message || 'No se pudo abrir la caja'
                });
            }
        });
    }

    abrirDialogoCierre(): void {
        this.montoContado = null;
        this.observacionCierre = '';
        this.mostrarCierre = true;
    }

    confirmarCierre(): void {
        if (!this.cajaActiva || this.montoContado === null) return;
        const req: CierreCajaRequest = {
            montoContado: this.montoContado,
            observacion: this.observacionCierre || undefined
        };
        this.cargando = true;
        this.cajaService.cerrar(this.cajaActiva.id, req).subscribe({
            next: reporte => {
                this.reporte = reporte;
                this.cajaActiva = null;
                this.mostrarCierre = false;
                this.mostrarReporte = true;
                this.cargando = false;
                this.cargarHistorial();
                this.messageService.add({
                    severity: 'success',
                    summary: 'Caja cerrada',
                    detail: 'El cierre fue registrado correctamente'
                });
            },
            error: e => {
                this.cargando = false;
                this.messageService.add({
                    severity: 'error',
                    summary: 'Error',
                    detail: e?.error?.message || 'No se pudo cerrar la caja'
                });
            }
        });
    }

    abrirDialogoRetiro(): void {
        this.montoMovimiento = null;
        this.descripcionMovimiento = '';
        this.mostrarRetiro = true;
    }

    cargarCajaAbierta(): void {
        this.cajaService.getActiva(this.sucursalIdInput).subscribe({
            next: caja => {
                this.cajaActiva = caja;
                this.mostrarApertura = false;
                this.cargando = false;
            },
            error: e => {
                this.cargando = false;
                this.messageService.add({
                    severity: 'error',
                    summary: 'Error',
                    detail: e?.error?.message || 'No se pudo cargar caja'
                });
            }
        });
    }

    confirmarRetiro(): void {
        if (!this.cajaActiva || !this.montoMovimiento || !this.descripcionMovimiento) return;
        const req: MovimientoCajaRequest = {monto: this.montoMovimiento, descripcion: this.descripcionMovimiento};
        this.cargando = true;
        this.cajaService.registrarRetiro(this.cajaActiva.id, req).subscribe({
            next: mov => {
                this.cajaActiva!.movimientos.push(mov);
                this.mostrarRetiro = false;
                this.cargando = false;
                this.messageService.add({
                    severity: 'success',
                    summary: 'Retiro registrado',
                    detail: `S/ ${mov.monto} retirado`
                });
            },
            error: e => {
                this.cargando = false;
                this.messageService.add({
                    severity: 'error',
                    summary: 'Error',
                    detail: e?.error?.message || 'No se pudo registrar el retiro'
                });
            }
        });
    }

    abrirDialogoIngreso(): void {
        this.montoMovimiento = null;
        this.descripcionMovimiento = '';
        this.mostrarIngreso = true;
    }

    confirmarIngreso(): void {
        if (!this.cajaActiva || !this.montoMovimiento || !this.descripcionMovimiento) return;
        const req: MovimientoCajaRequest = {monto: this.montoMovimiento, descripcion: this.descripcionMovimiento};
        this.cargando = true;
        this.cajaService.registrarIngreso(this.cajaActiva.id, req).subscribe({
            next: mov => {
                this.cajaActiva!.movimientos.push(mov);
                this.mostrarIngreso = false;
                this.cargando = false;
                this.messageService.add({
                    severity: 'success',
                    summary: 'Ingreso registrado',
                    detail: `S/ ${mov.monto} ingresado`
                });
            },
            error: e => {
                this.cargando = false;
                this.messageService.add({
                    severity: 'error',
                    summary: 'Error',
                    detail: e?.error?.message || 'No se pudo registrar el ingreso'
                });
            }
        });
    }

    verReporteCierre(caja: CajaResponseDTO): void {
        this.cajaService.getReporte(caja.id).subscribe({
            next: r => {
                this.reporte = r;
                this.mostrarReporte = true;
            },
            error: () => this.messageService.add({
                severity: 'error',
                summary: 'Error',
                detail: 'No se pudo cargar el reporte'
            })
        });
    }

    cargarHistorial(): void {
        if (!this.desdeHistorial || !this.hastaHistorial) return;
        const desde = this.desdeHistorial.toISOString().split('T')[0];
        const hasta = this.hastaHistorial.toISOString().split('T')[0];
        this.cajaService.getHistorial(desde, hasta, this.sucursalIdHistorial || undefined).subscribe({
            next: p => {
                this.historial = p.content;
                this.totalHistorial = p.totalElements;
            }
        });
    }

    getSeveridadDiferencia(estado: string | null): string {
        if (estado === 'CUADRADO') return 'success';
        if (estado === 'SOBRANTE') return 'info';
        if (estado === 'FALTANTE') return 'danger';
        return 'secondary';
    }

    getMovimientosRetiro(): any[] {
        return this.cajaActiva?.movimientos.filter(m => m.tipo === 'RETIRO') ?? [];
    }

    getMovimientosIngreso(): any[] {
        return this.cajaActiva?.movimientos.filter(m => m.tipo === 'INGRESO_MANUAL') ?? [];
    }

    totalRetiros(): number {
        return this.getMovimientosRetiro().reduce((a, m) => a + m.monto, 0);
    }

    totalIngresos(): number {
        return this.getMovimientosIngreso().reduce((a, m) => a + m.monto, 0);
    }
}

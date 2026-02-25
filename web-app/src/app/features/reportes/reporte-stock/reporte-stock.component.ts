import { Component, OnInit } from '@angular/core';
import { ReporteService } from '../services/reporte.service';
import { SucursalService } from '../../catalogos/services/sucursal.service';
import { Sucursal } from '../../catalogos/models/sucursal.model';

@Component({
  selector: 'app-reporte-stock',
  templateUrl: './reporte-stock.component.html'
})
export class ReporteStockComponent implements OnInit {
  datos: any[] = [];
  sucursales: Sucursal[] = [];
  sucursalId = '';
  cargando = true;

  get totalValor(): number {
    return this.datos.reduce((acc, d) => acc + (d.valorTotal || 0), 0);
  }

  constructor(private reporteService: ReporteService, private sucursalService: SucursalService) {}

  ngOnInit(): void {
    this.sucursalService.getSucursales().subscribe(s => this.sucursales = s);
    this.cargar();
  }

  cargar(): void {
    this.cargando = true;
    this.reporteService.getReporteStock().subscribe({
      next: d => {
        this.datos = Array.isArray(d) ? d : (d?.items || []);
        if (this.sucursalId) this.datos = this.datos.filter((x: any) => x.sucursalId === this.sucursalId);
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });
  }
}

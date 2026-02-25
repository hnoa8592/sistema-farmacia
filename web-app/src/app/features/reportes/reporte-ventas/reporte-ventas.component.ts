import { Component, OnInit } from '@angular/core';
import { ReporteService } from '../services/reporte.service';

@Component({
  selector: 'app-reporte-ventas',
  templateUrl: './reporte-ventas.component.html'
})
export class ReporteVentasComponent implements OnInit {
  desde: Date = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
  hasta: Date = new Date();
  datos: any = null;
  cargando = false;
  graficaData: any = {};
  graficaOpciones: any = {};
  ventasPorDia: any[] = [];

  constructor(private reporteService: ReporteService) {}

  ngOnInit(): void {
    this.configurarGrafica();
    this.cargar();
  }

  configurarGrafica(): void {
    this.graficaOpciones = {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: { x: { grid: { display: false } }, y: { beginAtZero: true } }
    };
  }

  cargar(): void {
    this.cargando = true;
    const d = this.desde.toISOString().split('T')[0];
    const h = this.hasta.toISOString().split('T')[0];
    this.reporteService.getReporteVentas(d, h).subscribe({
      next: data => {
        this.datos = data;
        this.ventasPorDia = data?.ventasPorDia || [];
        this.graficaData = {
          labels: this.ventasPorDia.map((v: any) => v.fecha?.split('T')[0] || v.fecha),
          datasets: [{
            label: 'Ventas (S/)',
            data: this.ventasPorDia.map((v: any) => v.totalVendido),
            backgroundColor: 'rgba(99,102,241,0.6)',
            borderColor: '#6366f1',
            borderWidth: 1
          }]
        };
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });
  }

  exportarCSV(): void {
    if (!this.ventasPorDia.length) return;
    const headers = ['Fecha', 'N° Ventas', 'Total Vendido'];
    const rows = this.ventasPorDia.map((v: any) => [v.fecha, v.cantidadVentas, v.totalVendido]);
    const csv = [headers, ...rows].map(r => r.join(',')).join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url; a.download = 'reporte-ventas.csv'; a.click();
    URL.revokeObjectURL(url);
  }
}

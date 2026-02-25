import { Component, OnInit } from '@angular/core';
import { ReporteService } from '../reportes/services/reporte.service';
import { InventarioService } from '../inventario/services/inventario.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html'
})
export class DashboardComponent implements OnInit {
  today = new Date();
  totalVentasHoy = 0;
  productosBajoStock = 0;
  lotesPorVencer = 0;
  cantidadVentasHoy = 0;
  graficaVentas: any = {};
  graficaOpciones: any = {};
  ultimasVentas: any[] = [];
  cargando = true;

  constructor(
    private reporteService: ReporteService,
    private inventarioService: InventarioService
  ) {}

  ngOnInit(): void {
    this.configurarGrafica();
    this.cargarDatos();
  }

  cargarDatos(): void {
    const hoy = new Date();
    const hasta = this.toDateStr(hoy);
    const desde7 = new Date(hoy);
    desde7.setDate(desde7.getDate() - 6);
    const desde = this.toDateStr(desde7);
    const todayStr = hasta;

    // Reporte de ventas: rango de 7 dias para KPIs + grafica + ultimas ventas
    this.reporteService.getReporteVentas(desde, hasta).subscribe({
      next: (data: any) => {
        // KPIs: tomar el dia de hoy dentro de ventasPorDia
        const hoyData = (data?.ventasPorDia || [])
          .find((v: any) => v.fecha === todayStr);
        this.totalVentasHoy   = hoyData?.totalVendido   || 0;
        this.cantidadVentasHoy = hoyData?.cantidadVentas || 0;

        // Ultimas ventas (5 mas recientes del periodo)
        this.ultimasVentas = data?.ultimasVentas || [];

        // Grafica: un punto por dia en el rango
        const dias: any[] = data?.ventasPorDia || [];
        if (dias.length) {
          this.graficaVentas = {
            ...this.graficaVentas,
            labels: dias.map((v: any) =>
              new Date(v.fecha + 'T12:00:00').toLocaleDateString('es', { weekday: 'short', day: 'numeric' })
            ),
            datasets: [{
              ...this.graficaVentas.datasets[0],
              data: dias.map((v: any) => Number(v.totalVendido) || 0)
            }]
          };
        }
        this.cargando = false;
      },
      error: () => { this.cargando = false; }
    });

    // Alertas de inventario (bajo stock y proximos a vencer)
    this.inventarioService.getStock({ soloConStock: false }).subscribe({
      next: (stock: any[]) => {
        this.productosBajoStock = stock.filter(s => s.stockActual <= s.stockMinimo).length;
        const en30dias = new Date(hoy);
        en30dias.setDate(en30dias.getDate() + 30);
        this.lotesPorVencer = stock.filter(s => {
          if (!s.fechaVencimiento) return false;
          const venc = new Date(s.fechaVencimiento + 'T12:00:00');
          return venc >= hoy && venc <= en30dias;
        }).length;
      },
      error: () => {}
    });
  }

  configurarGrafica(): void {
    const labels = Array.from({ length: 7 }, (_, i) => {
      const d = new Date();
      d.setDate(d.getDate() - (6 - i));
      return d.toLocaleDateString('es', { weekday: 'short', day: 'numeric' });
    });

    this.graficaVentas = {
      labels,
      datasets: [{
        label: 'Ventas (Bs.)',
        data: new Array(7).fill(0),
        fill: true,
        borderColor: '#6366f1',
        backgroundColor: 'rgba(99,102,241,0.1)',
        tension: 0.4,
        pointBackgroundColor: '#6366f1'
      }]
    };

    this.graficaOpciones = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: (ctx: any) => `Bs. ${Number(ctx.raw).toFixed(2)}`
          }
        }
      },
      scales: {
        x: { grid: { display: false } },
        y: {
          beginAtZero: true,
          grid: { color: 'rgba(0,0,0,0.05)' },
          ticks: {
            callback: (value: any) => `Bs. ${Number(value).toFixed(0)}`
          }
        }
      }
    };
  }

  private toDateStr(date: Date): string {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
  }
}

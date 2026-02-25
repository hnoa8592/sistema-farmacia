export interface ReporteVentasResponse {
  totalVendido: number;
  cantidadVentas: number;
  promedioPorVenta: number;
  productoMasVendido: string;
  ventas: any[];
  ventasPorDia: VentaDiaDTO[];
}

export interface VentaDiaDTO {
  fecha: string;
  cantidadVentas: number;
  totalVendido: number;
}

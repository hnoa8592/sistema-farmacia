export interface ReporteStockItem {
  productoId: string;
  productoNombre: string;
  codigo: string;
  lote: string;
  sucursalNombre: string;
  stockActual: number;
  stockMinimo: number;
  precioUnidad: number;
  valorTotal: number;
  alertaBajoStock: boolean;
  alertaVencimiento: boolean;
}

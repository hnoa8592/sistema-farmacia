import { ProductoPrecioDTO } from './producto-precio.model';

export interface InventarioResponse {
  id: string;
  loteId: string;
  sucursalId: string;
  sucursalNombre: string;
  productoId: string;
  productoNombre: string;
  numeroLote: string;
  fechaVencimiento: string;
  stockActual: number;
  stockMinimo: number;
  ubicacion: string | null;
  precios?: ProductoPrecioDTO[];
}

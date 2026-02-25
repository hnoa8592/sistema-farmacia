import {ProductoPrecioDTO, TipoPrecio} from '../../inventario/models/producto-precio.model';

export interface VentaRequest {
  detalles: DetalleVentaRequest[];
  descuento: number;
}

export interface DetalleVentaRequest {
  inventarioId: string;
  loteId: string;
  productoId: string;
  tipoPrecio: TipoPrecio;
  cantidad: number;
  precioUnitario: number;
}

export interface VentaResponse {
  id: string;
  fecha: string;
  total: number;
  descuento: number;
  usuarioId: string;
  estado: 'COMPLETADA' | 'ANULADA';
  detalles: DetalleVentaResponse[];
}

export interface DetalleVentaResponse {
  id: string;
  productoId: string;
  productoNombre: string;
  loteId: string;
  numeroLote: string;
  tipoPrecio: TipoPrecio;
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
}

export interface ItemCarrito {
  inventarioId: string;
  loteId: string;
  productoId: string;
  productoNombre: string;
  numeroLote: string;
  fechaVencimiento: string;
  sucursalId: string;
  tipoPrecio: TipoPrecio;
  cantidad: number;
  precioUnitario: number;
  stockDisponible: number;
  subtotal: number;
  precios?: ProductoPrecioDTO[];
}

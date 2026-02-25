export type TipoPrecio = 'UNIDAD' | 'TIRA' | 'CAJA' | 'FRACCION';

export interface ProductoPrecioDTO {
  id: string;
  productoId: string;
  tipoPrecio: TipoPrecio;
  precio: number;
  precioCompra: number | null;
  vigenciaDesde: string;
  vigenciaHasta: string | null;
  activo: boolean;
}

export interface ProductoPrecioRequest {
  tipoPrecio: TipoPrecio;
  precio: number;
  precioCompra: number | null;
  vigenciaDesde: string;
}

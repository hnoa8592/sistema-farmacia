export type TipoMovimiento = 'ENTRADA' | 'SALIDA' | 'AJUSTE' | 'TRANSFERENCIA';

export interface MovimientoRequest {
  inventarioId: string;
  cantidad: number;
  observacion: string | null;
}

export interface AjusteRequest {
  inventarioId: string;
  stockNuevo: number;
  observacion: string | null;
}

export interface MovimientoResponse {
  id: string;
  inventarioId: string;
  loteId: string;
  productoId: string;
  productoNombre: string;
  sucursalId: string;
  sucursalNombre: string;
  tipo: TipoMovimiento;
  cantidad: number;
  stockAnterior: number;
  stockResultante: number;
  fecha: string;
  usuarioId: string;
  observacion: string | null;
}

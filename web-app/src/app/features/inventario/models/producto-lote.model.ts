export interface ProductoLoteRequest {
  laboratorioId: string;
  numeroLote: string;
  fechaFabricacion: string | null;
  fechaVencimiento: string;
  cantidadInicial: number;
  sucursalId: string;
}

export interface ProductoLoteResponse {
  id: string;
  productoId: string;
  laboratorioId: string;
  laboratorioNombre: string;
  numeroLote: string;
  fechaFabricacion: string | null;
  fechaVencimiento: string;
  cantidadInicial: number;
  activo: boolean;
}

export interface MovimientoCajaDTO {
  id: string;
  tipo: 'RETIRO' | 'INGRESO_MANUAL';
  monto: number;
  descripcion: string;
  fecha: string;
  usuarioId: string;
}

export interface VentaCajeroDTO {
  usuarioId: string;
  nombreUsuario: string;
  cantidadVentas: number;
  totalVentas: number;
}

export interface CajaResponseDTO {
  id: string;
  sucursalId: string;
  usuarioId: string;
  nombreUsuario: string;
  fechaApertura: string;
  montoApertura: number;
  fechaCierre: string | null;
  montoContado: number | null;
  efectivoEsperado: number | null;
  diferencia: number | null;
  observacion: string | null;
  estado: 'ABIERTA' | 'CERRADA';
  movimientos: MovimientoCajaDTO[];
}

export interface ReporteCierreCajaDTO {
  cajaId: string;
  sucursalId: string;
  nombreCajero: string;
  fechaApertura: string;
  fechaCierre: string | null;
  montoApertura: number;
  totalVentas: number;
  cantidadVentas: number;
  ventasPorCajero: VentaCajeroDTO[];
  totalRetiros: number;
  retiros: MovimientoCajaDTO[];
  totalIngresosManuales: number;
  ingresosManuales: MovimientoCajaDTO[];
  efectivoEsperado: number;
  montoContado: number | null;
  diferencia: number | null;
  estadoDiferencia: 'CUADRADO' | 'SOBRANTE' | 'FALTANTE' | null;
  observacion: string | null;
  estadoCaja: 'ABIERTA' | 'CERRADA';
}

export interface AperturaCajaRequest {
  sucursalId: string;
  montoApertura: number;
}

export interface CierreCajaRequest {
  montoContado: number;
  observacion?: string;
}

export interface MovimientoCajaRequest {
  monto: number;
  descripcion: string;
}

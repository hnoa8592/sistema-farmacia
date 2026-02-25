export type TipoParametro = 'STRING' | 'INTEGER' | 'DECIMAL' | 'BOOLEAN';

export interface ParametroResponse {
  id: string;
  clave: string;
  valor: string;
  descripcion: string;
  tipo: TipoParametro;
  modulo: string;
  editable: boolean;
  activo: boolean;
  updatedAt: string;
  updatedBy: string;
}

export interface ParametroRequest {
  valor: string;
}

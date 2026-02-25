export interface Sucursal {
  id: string;
  nombre: string;
  direccion: string;
  telefono: string | null;
  esMatriz: boolean;
  activo: boolean;
}

export interface SucursalRequest {
  nombre: string;
  direccion: string;
  telefono: string | null;
  esMatriz: boolean;
}

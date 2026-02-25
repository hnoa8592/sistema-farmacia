export interface Laboratorio {
  id: string;
  nombre: string;
  pais: string | null;
  direccion: string | null;
  telefono: string | null;
  email: string | null;
  activo: boolean;
}

export interface LaboratorioRequest {
  nombre: string;
  pais: string | null;
  direccion: string | null;
  telefono: string | null;
  email: string | null;
}

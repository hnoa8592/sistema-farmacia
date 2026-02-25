export interface CatalogoDTO {
  id: string;
  nombre: string;
  descripcion: string | null;
  activo: boolean;
}

export interface CatalogoRequest {
  nombre: string;
  descripcion: string | null;
}

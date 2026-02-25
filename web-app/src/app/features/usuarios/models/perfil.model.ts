import { RecursoResponse } from './recurso.model';

export interface PerfilRequest {
  nombre: string;
  descripcion: string;
  recursosIds: string[];
}

export interface PerfilResponse {
  id: string;
  nombre: string;
  descripcion: string;
  recursos: RecursoResponse[];
}

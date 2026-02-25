import { PerfilResponse } from './perfil.model';

export interface UsuarioRequest {
  nombre: string;
  email: string;
  password: string;
  activo: boolean;
}

export interface UsuarioResponse {
  id: string;
  nombre: string;
  email: string;
  activo: boolean;
  createdAt: string;
  perfiles: PerfilResponse[];
}

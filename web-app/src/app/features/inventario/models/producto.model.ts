import { CatalogoDTO } from '../../catalogos/models/catalogo.model';
import { ProductoPrecioDTO } from './producto-precio.model';

export interface ProductoPrincipioActivoDTO {
  id: string;
  principioActivoId: string;
  principioActivoNombre: string;
  concentracion: string | null;
}

export interface ProductoRequest {
  nombre: string;
  nombreComercial: string | null;
  codigo: string;
  codigoBarra: string | null;
  descripcion: string | null;
  concentracion: string | null;
  presentacion: string | null;
  requiereReceta: boolean;
  controlado: boolean;
  categoriaId: string;
  formaFarmaceuticaId: string;
  viaAdministracionId: string;
}

export interface ProductoResponse {
  id: string;
  nombre: string;
  nombreComercial: string | null;
  codigo: string;
  codigoBarra: string | null;
  descripcion: string | null;
  concentracion: string | null;
  presentacion: string | null;
  requiereReceta: boolean;
  controlado: boolean;
  activo: boolean;
  categoria: CatalogoDTO | null;
  formaFarmaceutica: CatalogoDTO | null;
  viaAdministracion: CatalogoDTO | null;
  principiosActivos: ProductoPrincipioActivoDTO[];
  precios: ProductoPrecioDTO[];
}

import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse, PageResponse } from 'src/app/shared/models/api-response.model';
import { ProductoRequest, ProductoResponse, ProductoPrincipioActivoDTO } from '../models/producto.model';

@Injectable({ providedIn: 'root' })
export class ProductoService {
  private readonly url = `${environment.apiUrl}/productos`;

  constructor(private http: HttpClient) {}

  getProductos(page: number, size: number, filtros: any = {}): Observable<PageResponse<ProductoResponse>> {
    let params = new HttpParams().set('page', page).set('size', size);
    if (filtros.nombre) params = params.set('nombre', filtros.nombre);
    if (filtros.codigo) params = params.set('codigo', filtros.codigo);
    if (filtros.categoriaId) params = params.set('categoriaId', filtros.categoriaId);
    if (filtros.formaId) params = params.set('formaId', filtros.formaId);
    if (filtros.requiereReceta !== undefined) params = params.set('requiereReceta', String(filtros.requiereReceta));
    if (filtros.controlado !== undefined) params = params.set('controlado', String(filtros.controlado));
    return this.http.get<ApiResponse<PageResponse<ProductoResponse>>>(this.url, { params }).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  getProductoById(id: string): Observable<ProductoResponse> {
    return this.http.get<ApiResponse<ProductoResponse>>(`${this.url}/${id}`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  buscarProductos(search: string): Observable<ProductoResponse[]> {
    return this.http.get<ApiResponse<PageResponse<ProductoResponse>>>(`${this.url}?nombre=${search}&size=20`).pipe(
      map(r => r.data.content),
      catchError(e => throwError(() => e))
    );
  }

  crearProducto(request: ProductoRequest): Observable<ProductoResponse> {
    return this.http.post<ApiResponse<ProductoResponse>>(this.url, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  editarProducto(id: string, request: ProductoRequest): Observable<ProductoResponse> {
    return this.http.put<ApiResponse<ProductoResponse>>(`${this.url}/${id}`, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  desactivarProducto(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/${id}`).pipe(
      map(() => undefined),
      catchError(e => throwError(() => e))
    );
  }

  getProductosBajoStock(): Observable<ProductoResponse[]> {
    return this.http.get<ApiResponse<ProductoResponse[]>>(`${this.url}/bajo-stock`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  getProductosProximosVencer(): Observable<ProductoResponse[]> {
    return this.http.get<ApiResponse<ProductoResponse[]>>(`${this.url}/proximos-vencer`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  getProductosSinStock(): Observable<ProductoResponse[]> {
    return this.http.get<ApiResponse<ProductoResponse[]>>(`${this.url}/sin-stock`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  getPrincipiosActivos(productoId: string): Observable<ProductoPrincipioActivoDTO[]> {
    return this.http.get<ApiResponse<ProductoPrincipioActivoDTO[]>>(`${this.url}/${productoId}/principios-activos`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  asociarPrincipioActivo(productoId: string, paId: string, concentracion: string | null): Observable<void> {
    return this.http.post<ApiResponse<void>>(`${this.url}/${productoId}/principios-activos`, { principioActivoId: paId, concentracion }).pipe(
      map(() => undefined),
      catchError(e => throwError(() => e))
    );
  }

  desasociarPrincipioActivo(productoId: string, paId: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/${productoId}/principios-activos/${paId}`).pipe(
      map(() => undefined),
      catchError(e => throwError(() => e))
    );
  }
}

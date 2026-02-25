import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { ProductoPrecioDTO, ProductoPrecioRequest } from '../models/producto-precio.model';

@Injectable({ providedIn: 'root' })
export class ProductoPrecioService {
  private readonly url = `${environment.apiUrl}/productos`;

  constructor(private http: HttpClient) {}

  getPrecios(productoId: string): Observable<ProductoPrecioDTO[]> {
    return this.http.get<ApiResponse<ProductoPrecioDTO[]>>(`${this.url}/${productoId}/precios`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  crearPrecio(productoId: string, request: ProductoPrecioRequest): Observable<ProductoPrecioDTO> {
    return this.http.post<ApiResponse<ProductoPrecioDTO>>(`${this.url}/${productoId}/precios`, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  editarPrecio(productoId: string, precioId: string, request: ProductoPrecioRequest): Observable<ProductoPrecioDTO> {
    return this.http.put<ApiResponse<ProductoPrecioDTO>>(`${this.url}/${productoId}/precios/${precioId}`, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  desactivarPrecio(productoId: string, precioId: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/${productoId}/precios/${precioId}`).pipe(
      map(() => undefined),
      catchError(e => throwError(() => e))
    );
  }
}

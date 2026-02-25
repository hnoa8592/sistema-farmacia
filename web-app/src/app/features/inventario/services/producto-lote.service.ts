import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { ProductoLoteRequest, ProductoLoteResponse } from '../models/producto-lote.model';

@Injectable({ providedIn: 'root' })
export class ProductoLoteService {
  private readonly url = `${environment.apiUrl}/productos`;

  constructor(private http: HttpClient) {}

  getLotes(productoId: string): Observable<ProductoLoteResponse[]> {
    return this.http.get<ApiResponse<ProductoLoteResponse[]>>(`${this.url}/${productoId}/lotes`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  crearLote(productoId: string, request: ProductoLoteRequest): Observable<ProductoLoteResponse> {
    return this.http.post<ApiResponse<ProductoLoteResponse>>(`${this.url}/${productoId}/lotes`, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  getLotesProximosVencer(productoId: string): Observable<ProductoLoteResponse[]> {
    return this.http.get<ApiResponse<ProductoLoteResponse[]>>(`${this.url}/${productoId}/lotes/proximos-vencer`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  getLotesVencidos(productoId: string): Observable<ProductoLoteResponse[]> {
    return this.http.get<ApiResponse<ProductoLoteResponse[]>>(`${this.url}/${productoId}/lotes/vencidos`).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }
}

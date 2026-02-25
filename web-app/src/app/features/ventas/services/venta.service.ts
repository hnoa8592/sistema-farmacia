import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse, PageResponse } from 'src/app/shared/models/api-response.model';
import { VentaRequest, VentaResponse } from '../models/venta.model';

@Injectable({ providedIn: 'root' })
export class VentaService {
  private readonly url = `${environment.apiUrl}/ventas`;

  constructor(private http: HttpClient) {}

  getVentas(page: number, size: number, filtros: any = {}): Observable<PageResponse<VentaResponse>> {
    let params = new HttpParams().set('page', page).set('size', size);
    if (filtros.desde) params = params.set('desde', filtros.desde);
    if (filtros.hasta) params = params.set('hasta', filtros.hasta);
    if (filtros.estado) params = params.set('estado', filtros.estado);
    if (filtros.usuarioId) params = params.set('usuarioId', filtros.usuarioId);
    return this.http.get<ApiResponse<PageResponse<VentaResponse>>>(this.url, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getVentaById(id: string): Observable<VentaResponse> {
    return this.http.get<ApiResponse<VentaResponse>>(`${this.url}/${id}`).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  crearVenta(request: VentaRequest): Observable<VentaResponse> {
    return this.http.post<ApiResponse<VentaResponse>>(this.url, request).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  anularVenta(id: string): Observable<void> {
    return this.http.put<ApiResponse<void>>(`${this.url}/${id}/anular`, {}).pipe(
      map(() => undefined), catchError(e => throwError(() => e))
    );
  }
}

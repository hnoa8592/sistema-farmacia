import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse, PageResponse } from 'src/app/shared/models/api-response.model';
import { InventarioResponse } from '../models/inventario.model';
import { MovimientoRequest, AjusteRequest, MovimientoResponse } from '../models/movimiento.model';

@Injectable({ providedIn: 'root' })
export class InventarioService {
  private readonly url = `${environment.apiUrl}/inventario`;

  constructor(private http: HttpClient) {}

  getStock(filtros: any = {}): Observable<InventarioResponse[]> {
    let params = new HttpParams();
    if (filtros.productoId) params = params.set('productoId', filtros.productoId);
    if (filtros.sucursalId) params = params.set('sucursalId', filtros.sucursalId);
    if (filtros.loteId) params = params.set('loteId', filtros.loteId);
    if (filtros.productoNombre) params = params.set('productoNombre', filtros.productoNombre);
    if (filtros.soloConStock !== undefined) params = params.set('soloConStock', String(filtros.soloConStock));
    return this.http.get<ApiResponse<InventarioResponse[]>>(`${this.url}/stock`, { params }).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  getMovimientos(page: number, size: number, filtros: any = {}): Observable<PageResponse<MovimientoResponse>> {
    let params = new HttpParams().set('page', page).set('size', size);
    if (filtros.productoId) params = params.set('productoId', filtros.productoId);
    if (filtros.sucursalId) params = params.set('sucursalId', filtros.sucursalId);
    if (filtros.tipo) params = params.set('tipo', filtros.tipo);
    if (filtros.desde) params = params.set('desde', filtros.desde);
    if (filtros.hasta) params = params.set('hasta', filtros.hasta);
    return this.http.get<ApiResponse<PageResponse<MovimientoResponse>>>(`${this.url}/movimientos`, { params }).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  registrarEntrada(request: MovimientoRequest): Observable<MovimientoResponse> {
    return this.http.post<ApiResponse<MovimientoResponse>>(`${this.url}/entrada`, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  registrarSalida(request: MovimientoRequest): Observable<MovimientoResponse> {
    return this.http.post<ApiResponse<MovimientoResponse>>(`${this.url}/salida`, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }

  registrarAjuste(request: AjusteRequest): Observable<MovimientoResponse> {
    return this.http.post<ApiResponse<MovimientoResponse>>(`${this.url}/ajuste`, request).pipe(
      map(r => r.data),
      catchError(e => throwError(() => e))
    );
  }
}

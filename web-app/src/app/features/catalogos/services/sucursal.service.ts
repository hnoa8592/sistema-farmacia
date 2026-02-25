import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { Sucursal, SucursalRequest } from '../models/sucursal.model';
import { InventarioResponse } from '../../inventario/models/inventario.model';

@Injectable({ providedIn: 'root' })
export class SucursalService {
  private readonly url = `${environment.apiUrl}/sucursales`;

  constructor(private http: HttpClient) {}

  getSucursales(): Observable<Sucursal[]> {
    return this.http.get<ApiResponse<Sucursal[]>>(this.url).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  crear(req: SucursalRequest): Observable<Sucursal> {
    return this.http.post<ApiResponse<Sucursal>>(this.url, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  editar(id: string, req: SucursalRequest): Observable<Sucursal> {
    return this.http.put<ApiResponse<Sucursal>>(`${this.url}/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  eliminar(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/${id}`).pipe(map(() => undefined), catchError(e => throwError(() => e)));
  }

  getInventario(id: string): Observable<InventarioResponse[]> {
    return this.http.get<ApiResponse<InventarioResponse[]>>(`${this.url}/${id}/inventario`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
}

import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse, PageResponse } from 'src/app/shared/models/api-response.model';
import { AuditLogResponse, AuditFiltro } from '../models/audit-log.model';

@Injectable({ providedIn: 'root' })
export class AuditoriaService {
  private readonly url = `${environment.apiUrl}/auditoria`;

  constructor(private http: HttpClient) {}

  getLogs(filtros: AuditFiltro): Observable<PageResponse<AuditLogResponse>> {
    let params = new HttpParams();
    if (filtros.usuarioId) params = params.set('usuarioId', filtros.usuarioId);
    if (filtros.modulo) params = params.set('modulo', filtros.modulo);
    if (filtros.entidad) params = params.set('entidad', filtros.entidad);
    if (filtros.accion) params = params.set('accion', filtros.accion);
    if (filtros.desde) params = params.set('desde', filtros.desde);
    if (filtros.hasta) params = params.set('hasta', filtros.hasta);
    if (filtros.page !== undefined) params = params.set('page', filtros.page);
    if (filtros.size !== undefined) params = params.set('size', filtros.size);
    return this.http.get<ApiResponse<PageResponse<AuditLogResponse>>>(this.url, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getLogById(id: string): Observable<AuditLogResponse> {
    return this.http.get<ApiResponse<AuditLogResponse>>(`${this.url}/${id}`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  getHistorialEntidad(entidad: string, entidadId: string): Observable<AuditLogResponse[]> {
    return this.http.get<ApiResponse<AuditLogResponse[]>>(`${this.url}/entidad/${entidad}/${entidadId}`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  getActividadUsuario(usuarioId: string): Observable<AuditLogResponse[]> {
    return this.http.get<ApiResponse<AuditLogResponse[]>>(`${this.url}/usuario/${usuarioId}`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  getResumen(desde: string, hasta: string): Observable<any> {
    const params = new HttpParams().set('desde', desde).set('hasta', hasta);
    return this.http.get<ApiResponse<any>>(`${this.url}/resumen`, { params }).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
}

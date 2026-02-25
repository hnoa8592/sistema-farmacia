import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse, PageResponse } from 'src/app/shared/models/api-response.model';
import { PrincipioActivo } from '../models/principio-activo.model';

@Injectable({ providedIn: 'root' })
export class PrincipioActivoService {
  private readonly url = `${environment.apiUrl}/principios-activos`;

  constructor(private http: HttpClient) {}

  getAll(nombre?: string, page = 0, size = 100): Observable<PageResponse<PrincipioActivo>> {
    let params = new HttpParams().set('page', page).set('size', size);
    if (nombre) params = params.set('nombre', nombre);
    return this.http.get<ApiResponse<PageResponse<PrincipioActivo>>>(this.url, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  crear(req: { nombre: string; descripcion: string | null }): Observable<PrincipioActivo> {
    return this.http.post<ApiResponse<PrincipioActivo>>(this.url, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  editar(id: string, req: { nombre: string; descripcion: string | null }): Observable<PrincipioActivo> {
    return this.http.put<ApiResponse<PrincipioActivo>>(`${this.url}/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  eliminar(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/${id}`).pipe(map(() => undefined), catchError(e => throwError(() => e)));
  }
}

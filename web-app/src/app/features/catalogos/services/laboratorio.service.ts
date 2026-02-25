import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse, PageResponse } from 'src/app/shared/models/api-response.model';
import { Laboratorio, LaboratorioRequest } from '../models/laboratorio.model';

@Injectable({ providedIn: 'root' })
export class LaboratorioService {
  private readonly url = `${environment.apiUrl}/laboratorios`;

  constructor(private http: HttpClient) {}

  getAll(nombre?: string, pais?: string, page = 0, size = 20): Observable<PageResponse<Laboratorio>> {
    let params = new HttpParams().set('page', page).set('size', size);
    if (nombre) params = params.set('nombre', nombre);
    if (pais) params = params.set('pais', pais);
    return this.http.get<ApiResponse<PageResponse<Laboratorio>>>(this.url, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  crear(req: LaboratorioRequest): Observable<Laboratorio> {
    return this.http.post<ApiResponse<Laboratorio>>(this.url, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  editar(id: string, req: LaboratorioRequest): Observable<Laboratorio> {
    return this.http.put<ApiResponse<Laboratorio>>(`${this.url}/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  eliminar(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/${id}`).pipe(map(() => undefined), catchError(e => throwError(() => e)));
  }
}

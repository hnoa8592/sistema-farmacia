import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { PerfilRequest, PerfilResponse } from '../models/perfil.model';
import { RecursoResponse } from '../models/recurso.model';

@Injectable({ providedIn: 'root' })
export class PerfilService {
  private readonly url = `${environment.apiUrl}/perfiles`;

  constructor(private http: HttpClient) {}

  getPerfiles(): Observable<PerfilResponse[]> {
    return this.http.get<ApiResponse<PerfilResponse[]>>(this.url).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  crearPerfil(req: PerfilRequest): Observable<PerfilResponse> {
    return this.http.post<ApiResponse<PerfilResponse>>(this.url, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  editarPerfil(id: string, req: PerfilRequest): Observable<PerfilResponse> {
    return this.http.put<ApiResponse<PerfilResponse>>(`${this.url}/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  asignarRecursos(perfilId: string, recursosIds: string[]): Observable<void> {
    return this.http.post<ApiResponse<void>>(`${this.url}/${perfilId}/recursos`, { recursosIds }).pipe(
      map(() => undefined), catchError(e => throwError(() => e))
    );
  }

  getRecursos(): Observable<RecursoResponse[]> {
    return this.http.get<ApiResponse<RecursoResponse[]>>(`${this.url}/recursos`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
}

import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse, PageResponse } from 'src/app/shared/models/api-response.model';
import { UsuarioRequest, UsuarioResponse } from '../models/usuario.model';

@Injectable({ providedIn: 'root' })
export class UsuarioService {
  private readonly url = `${environment.apiUrl}/usuarios`;

  constructor(private http: HttpClient) {}

  getUsuarios(page = 0, size = 10): Observable<PageResponse<UsuarioResponse>> {
    const params = new HttpParams().set('page', page).set('size', size);
    return this.http.get<ApiResponse<PageResponse<UsuarioResponse>>>(this.url, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  crearUsuario(req: UsuarioRequest): Observable<UsuarioResponse> {
    return this.http.post<ApiResponse<UsuarioResponse>>(this.url, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  editarUsuario(id: string, req: Partial<UsuarioRequest>): Observable<UsuarioResponse> {
    return this.http.put<ApiResponse<UsuarioResponse>>(`${this.url}/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  desactivarUsuario(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/${id}`).pipe(map(() => undefined), catchError(e => throwError(() => e)));
  }

  asignarPerfiles(usuarioId: string, perfilesIds: string[]): Observable<void> {
    return this.http.post<ApiResponse<void>>(`${this.url}/${usuarioId}/perfiles`, { perfilesIds }).pipe(
      map(() => undefined), catchError(e => throwError(() => e))
    );
  }
}

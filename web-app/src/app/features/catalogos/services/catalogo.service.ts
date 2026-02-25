import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { CatalogoDTO, CatalogoRequest } from '../models/catalogo.model';

@Injectable({ providedIn: 'root' })
export class CatalogoService {
  private readonly url = `${environment.apiUrl}/catalogos`;

  constructor(private http: HttpClient) {}

  getCategorias(): Observable<CatalogoDTO[]> {
    return this.http.get<ApiResponse<CatalogoDTO[]>>(`${this.url}/categorias`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  crearCategoria(req: CatalogoRequest): Observable<CatalogoDTO> {
    return this.http.post<ApiResponse<CatalogoDTO>>(`${this.url}/categorias`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  editarCategoria(id: string, req: CatalogoRequest): Observable<CatalogoDTO> {
    return this.http.put<ApiResponse<CatalogoDTO>>(`${this.url}/categorias/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  eliminarCategoria(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/categorias/${id}`).pipe(map(() => undefined), catchError(e => throwError(() => e)));
  }

  getFormas(): Observable<CatalogoDTO[]> {
    return this.http.get<ApiResponse<CatalogoDTO[]>>(`${this.url}/formas-farmaceuticas`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  crearForma(req: CatalogoRequest): Observable<CatalogoDTO> {
    return this.http.post<ApiResponse<CatalogoDTO>>(`${this.url}/formas-farmaceuticas`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  editarForma(id: string, req: CatalogoRequest): Observable<CatalogoDTO> {
    return this.http.put<ApiResponse<CatalogoDTO>>(`${this.url}/formas-farmaceuticas/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  eliminarForma(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/formas-farmaceuticas/${id}`).pipe(map(() => undefined), catchError(e => throwError(() => e)));
  }

  getVias(): Observable<CatalogoDTO[]> {
    return this.http.get<ApiResponse<CatalogoDTO[]>>(`${this.url}/vias-administracion`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  crearVia(req: CatalogoRequest): Observable<CatalogoDTO> {
    return this.http.post<ApiResponse<CatalogoDTO>>(`${this.url}/vias-administracion`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  editarVia(id: string, req: CatalogoRequest): Observable<CatalogoDTO> {
    return this.http.put<ApiResponse<CatalogoDTO>>(`${this.url}/vias-administracion/${id}`, req).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
  eliminarVia(id: string): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.url}/vias-administracion/${id}`).pipe(map(() => undefined), catchError(e => throwError(() => e)));
  }
}

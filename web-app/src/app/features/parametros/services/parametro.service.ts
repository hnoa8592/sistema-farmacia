import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { ParametroResponse, ParametroRequest } from '../models/parametro.model';

@Injectable({ providedIn: 'root' })
export class ParametroService {
  private readonly url = `${environment.apiUrl}/parametros`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<ParametroResponse[]> {
    return this.http.get<ApiResponse<ParametroResponse[]>>(this.url).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  getByModulo(modulo: string): Observable<ParametroResponse[]> {
    return this.http.get<ApiResponse<ParametroResponse[]>>(`${this.url}/modulo/${modulo}`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  getByClave(clave: string): Observable<ParametroResponse> {
    return this.http.get<ApiResponse<ParametroResponse>>(`${this.url}/${clave}`).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }

  actualizar(clave: string, request: ParametroRequest): Observable<ParametroResponse> {
    return this.http.put<ApiResponse<ParametroResponse>>(`${this.url}/${clave}`, request).pipe(map(r => r.data), catchError(e => throwError(() => e)));
  }
}

import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';

@Injectable({ providedIn: 'root' })
export class ReporteService {
  private readonly url = `${environment.apiUrl}/reportes`;

  constructor(private http: HttpClient) {}

  getReporteVentas(desde: string, hasta: string, usuarioId?: string, laboratorio?: string): Observable<any> {
    let params = new HttpParams().set('desde', desde).set('hasta', hasta);
    if (usuarioId) params = params.set('usuarioId', usuarioId);
    if (laboratorio) params = params.set('laboratorio', laboratorio);
    return this.http.get<ApiResponse<any>>(`${this.url}/ventas`, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getProductosMasVendidos(desde: string, hasta: string): Observable<any[]> {
    let params = new HttpParams().set('desde', desde).set('hasta', hasta);
    return this.http.get<ApiResponse<any[]>>(`${this.url}/productos-vendidos`, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getReporteStock(): Observable<any> {
    return this.http.get<ApiResponse<any>>(`${this.url}/stock`).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getReporteMovimientos(desde: string, hasta: string): Observable<any[]> {
    let params = new HttpParams().set('desde', desde).set('hasta', hasta);
    return this.http.get<ApiResponse<any[]>>(`${this.url}/movimientos`, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }
}

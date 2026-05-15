import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import {
  AperturaCajaRequest, CajaResponseDTO, CierreCajaRequest,
  MovimientoCajaDTO, MovimientoCajaRequest, ReporteCierreCajaDTO
} from '../cierre-caja/cierre-caja.model';

@Injectable({ providedIn: 'root' })
export class CajaService {
  private readonly url = `${environment.apiUrl}/caja`;

  constructor(private http: HttpClient) {}

  abrir(request: AperturaCajaRequest): Observable<CajaResponseDTO> {
    return this.http.post<ApiResponse<CajaResponseDTO>>(`${this.url}/abrir`, request).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  cerrar(cajaId: string, request: CierreCajaRequest): Observable<ReporteCierreCajaDTO> {
    return this.http.post<ApiResponse<ReporteCierreCajaDTO>>(`${this.url}/${cajaId}/cerrar`, request).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  registrarRetiro(cajaId: string, request: MovimientoCajaRequest): Observable<MovimientoCajaDTO> {
    return this.http.post<ApiResponse<MovimientoCajaDTO>>(`${this.url}/${cajaId}/retiro`, request).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  registrarIngreso(cajaId: string, request: MovimientoCajaRequest): Observable<MovimientoCajaDTO> {
    return this.http.post<ApiResponse<MovimientoCajaDTO>>(`${this.url}/${cajaId}/ingreso`, request).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getActiva(sucursalId: string): Observable<CajaResponseDTO | null> {
    const params = new HttpParams().set('sucursalId', sucursalId);
    return this.http.get<ApiResponse<CajaResponseDTO>>(`${this.url}/activa`, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getReporte(cajaId: string): Observable<ReporteCierreCajaDTO> {
    return this.http.get<ApiResponse<ReporteCierreCajaDTO>>(`${this.url}/${cajaId}/reporte`).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }

  getHistorial(desde: string, hasta: string, sucursalId?: string, page = 0, size = 10): Observable<any> {
    let params = new HttpParams().set('desde', desde).set('hasta', hasta)
      .set('page', page).set('size', size);
    if (sucursalId) params = params.set('sucursalId', sucursalId);
    return this.http.get<ApiResponse<any>>(`${this.url}/historial`, { params }).pipe(
      map(r => r.data), catchError(e => throwError(() => e))
    );
  }
}

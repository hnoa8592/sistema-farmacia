import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, map, tap, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { LoginRequest, LoginResponse, JwtPayload } from './models/auth.model';
import { ApiResponse } from 'src/app/shared/models/api-response.model';
import { PermissionService } from '../services/permission.service';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly apiUrl = environment.apiUrl;
  private readonly tenantId = environment.tenantId;

  constructor(
    private http: HttpClient,
    private router: Router,
    private permissionService: PermissionService
  ) {}

  login(request: LoginRequest): Observable<LoginResponse> {
    request.tenantId = this.tenantId;
    return this.http.post<ApiResponse<LoginResponse>>(`${this.apiUrl}/auth/login`, request).pipe(
      map(r => r.data),
      tap(data => {
        localStorage.setItem('token', data.token);
        localStorage.setItem('email', data.email);
        localStorage.setItem('nombre', data.nombre);
        const payload = this.decodeJwt(data.token);
        if (payload) {
          localStorage.setItem('tenantId', payload.tenantId);
          localStorage.setItem('userId', payload.userId);
        }
        const recursos = data.recursos || (payload?.recursos ?? []);
        localStorage.setItem('recursos', JSON.stringify(recursos));
        this.permissionService.setRecursos(recursos);
      }),
      catchError(e => throwError(() => e))
    );
  }

  logout(): void {
    localStorage.clear();
    this.permissionService.setRecursos([]);
    this.router.navigate(['/login']);
  }

  getToken(): string | null {
    return localStorage.getItem('token');
  }

  getTenantId(): string {
    return localStorage.getItem('tenantId') || '';
  }

  getRecursos(): string[] {
    const stored = localStorage.getItem('recursos');
    return stored ? JSON.parse(stored) : [];
  }

  getNombre(): string {
    return localStorage.getItem('nombre') || '';
  }

  getEmail(): string {
    return localStorage.getItem('email') || '';
  }

  isLoggedIn(): boolean {
    const token = this.getToken();
    if (!token) return false;
    const payload = this.decodeJwt(token);
    if (!payload) return false;
    return payload.exp * 1000 > Date.now();
  }

  private decodeJwt(token: string): JwtPayload | null {
    try {
      const base64 = token.split('.')[1];
      const decoded = atob(base64.replace(/-/g, '+').replace(/_/g, '/'));
      return JSON.parse(decoded) as JwtPayload;
    } catch {
      return null;
    }
  }
}

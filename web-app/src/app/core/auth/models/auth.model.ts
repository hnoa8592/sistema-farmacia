export interface LoginRequest {
  email: string;
  password: string;
  tenantId: string;
}

export interface LoginResponse {
  token: string;
  email: string;
  nombre: string;
  recursos: string[];
}

export interface JwtPayload {
  sub: string;
  tenantId: string;
  userId: string;
  recursos: string[];
  exp: number;
}

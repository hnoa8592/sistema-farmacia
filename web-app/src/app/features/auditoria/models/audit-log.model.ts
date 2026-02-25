export type AccionAudit = 'CREAR' | 'EDITAR' | 'ELIMINAR' | 'VER' | 'LOGIN' | 'LOGOUT' | 'ANULAR';

export interface AuditLogResponse {
  id: string;
  usuarioId: string;
  usuarioEmail: string;
  accion: AccionAudit;
  modulo: string;
  entidad: string;
  entidadId: string | null;
  valorAnterior: string | null;
  valorNuevo: string | null;
  descripcion: string;
  ipOrigen: string | null;
  userAgent: string | null;
  fecha: string;
  exitoso: boolean;
}

export interface AuditFiltro {
  usuarioId?: string;
  modulo?: string;
  entidad?: string;
  accion?: AccionAudit;
  desde?: string;
  hasta?: string;
  page?: number;
  size?: number;
}

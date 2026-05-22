SET search_path TO {SCHEMA}, public;

INSERT INTO recursos (nombre, modulo) VALUES
-- Ventas
('ventas:ver',       'VENTAS'),
('ventas:crear',     'VENTAS'),
('ventas:anular',    'VENTAS'),
('ventas:descuento', 'VENTAS'),
-- Inventario
('inventario:ver',         'INVENTARIO'),
('inventario:crear',       'INVENTARIO'),
('inventario:editar',      'INVENTARIO'),
('inventario:movimientos', 'INVENTARIO'),
('inventario:lotes',       'INVENTARIO'),
('inventario:precios',     'INVENTARIO'),
('inventario:ajuste',      'INVENTARIO'),
-- Laboratorios
('laboratorios:ver',    'LABORATORIOS'),
('laboratorios:editar', 'LABORATORIOS'),
-- Sucursales
('sucursales:ver',    'SUCURSALES'),
('sucursales:editar', 'SUCURSALES'),
-- Catálogos
('catalogos:ver',    'CATALOGOS'),
('catalogos:editar', 'CATALOGOS'),
-- Principios activos
('principios-activos:ver',    'PRINCIPIOS_ACTIVOS'),
('principios-activos:editar', 'PRINCIPIOS_ACTIVOS'),
-- Reportes
('reportes:ventas',       'REPORTES'),
('reportes:inventario',   'REPORTES'),
('reportes:stock',        'REPORTES'),
('reportes:movimientos',  'REPORTES'),
('reportes:cierre-caja',  'REPORTES'),
-- Usuarios
('usuarios:ver',    'USUARIOS'),
('usuarios:crear',  'USUARIOS'),
('usuarios:editar', 'USUARIOS'),
-- Perfiles
('perfiles:ver',    'PERFILES'),
('perfiles:crear',  'PERFILES'),
('perfiles:editar', 'PERFILES'),
-- Auditoría
('auditoria:ver', 'AUDITORIA'),
-- Parámetros
('parametros:ver',    'PARAMETROS'),
('parametros:editar', 'PARAMETROS'),
-- Caja
('caja:abrir',       'CAJA'),
('caja:cerrar',      'CAJA'),
('caja:ver',         'CAJA'),
('caja:movimientos', 'CAJA')
ON CONFLICT (nombre) DO NOTHING;

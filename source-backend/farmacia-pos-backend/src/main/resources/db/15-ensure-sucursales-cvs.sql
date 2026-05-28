-- ============================================================
-- 15-ensure-sucursales-cvs.sql
-- Asegura las sucursales requeridas por los seeds existentes.
-- Tenant: farmacia_bri
--
-- No modifica usuarios, permisos ni otros modulos.
-- No borra datos existentes.
-- Ejecutar con cliente/archivo en UTF-8.
-- ============================================================

SET client_encoding TO 'UTF8';
SET search_path TO {SCHEMA}, public;

BEGIN;

-- Los scripts de datos existentes solo declaran esta sucursal.
-- Si ya existe, queda activa y marcada como matriz.
UPDATE sucursales
SET activo = true,
    es_matriz = true,
    direccion = COALESCE(direccion, 'Generada para seed LINAME CSV'),
    telefono = telefono
WHERE nombre = 'Sucursal Matriz';

INSERT INTO sucursales (nombre, direccion, telefono, es_matriz, activo)
SELECT 'Sucursal Matriz', 'Generada para seed LINAME CSV', NULL, true, true
WHERE NOT EXISTS (
    SELECT 1
    FROM sucursales
    WHERE nombre = 'Sucursal Matriz'
);

COMMIT;

-- Validacion: el POS consume /api/sucursales, que lista activo = true.
SELECT id, nombre, direccion, telefono, es_matriz, activo
FROM sucursales
WHERE activo = true
ORDER BY es_matriz DESC, nombre;

SET search_path TO public;

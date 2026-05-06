-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando {SCHEMA} por el tenant correspondiente.
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

INSERT INTO laboratorios (nombre, pais, activo)
SELECT 'LINAME 2026-2027', 'Bolivia', true
WHERE NOT EXISTS (
    SELECT 1
    FROM laboratorios
    WHERE nombre = 'LINAME 2026-2027'
);

INSERT INTO sucursales (nombre, direccion, telefono, es_matriz, activo)
SELECT 'Sucursal Matriz', 'Generada para seed LINAME CSV cuando no existen sucursales activas', NULL, true, true
WHERE NOT EXISTS (SELECT 1 FROM sucursales WHERE activo = true);

INSERT INTO producto_lotes (producto_id, laboratorio_id, numero_lote, fecha_vencimiento, cantidad_inicial, activo)
SELECT p.id, l.id, 'LOT-' || p.codigo, DATE '2027-12-31', 100, true
FROM seed_productos_csv_staging s
JOIN productos p ON p.codigo = s.codigo
JOIN laboratorios l ON l.nombre = 'LINAME 2026-2027'
WHERE s.es_valido = true
ON CONFLICT (producto_id, numero_lote) DO UPDATE
SET laboratorio_id = EXCLUDED.laboratorio_id,
    fecha_vencimiento = EXCLUDED.fecha_vencimiento,
    cantidad_inicial = EXCLUDED.cantidad_inicial,
    activo = true;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo, ubicacion)
SELECT pl.id, s.id,
       CASE WHEN s.es_matriz THEN 80 ELSE 20 END,
       CASE WHEN s.es_matriz THEN 10 ELSE 5 END,
       'Seed LINAME CSV'
FROM seed_productos_csv_staging src
JOIN productos p ON p.codigo = src.codigo
JOIN producto_lotes pl ON pl.producto_id = p.id AND pl.numero_lote = 'LOT-' || p.codigo
JOIN sucursales s ON s.activo = true
WHERE src.es_valido = true
ON CONFLICT (lote_id, sucursal_id) DO UPDATE
SET stock_actual = EXCLUDED.stock_actual,
    stock_minimo = EXCLUDED.stock_minimo,
    ubicacion = EXCLUDED.ubicacion;

COMMIT;

SET search_path TO public;

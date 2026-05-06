-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando {SCHEMA} por el tenant correspondiente.
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde, activo)
SELECT p.id, 'UNIDAD', ROUND(s.precio_referencial, 2), NULL, TIMESTAMP '2026-04-06 00:00:00', true
FROM seed_productos_csv_staging s
JOIN productos p ON p.codigo = s.codigo
WHERE s.es_valido = true
  AND NOT EXISTS (
      SELECT 1
      FROM producto_precios pp
      WHERE pp.producto_id = p.id
        AND pp.tipo_precio = 'UNIDAD'
        AND pp.vigencia_desde = TIMESTAMP '2026-04-06 00:00:00'
  );

COMMIT;

SET search_path TO public;
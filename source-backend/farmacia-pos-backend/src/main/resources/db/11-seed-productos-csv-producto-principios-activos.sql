-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando {SCHEMA} por el tenant correspondiente.
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT DISTINCT p.id, pa.id, LEFT(s.concentracion, 100)
FROM seed_productos_csv_staging s
JOIN productos p ON p.codigo = s.codigo
CROSS JOIN LATERAL regexp_split_to_table(s.medicamento, '[[:space:]]*\+[[:space:]]*') AS pa_raw(nombre)
JOIN principios_activos pa ON pa.nombre = LEFT(TRIM(pa_raw.nombre), 200)
WHERE s.es_valido = true
  AND NULLIF(TRIM(pa_raw.nombre), '') IS NOT NULL
ON CONFLICT (producto_id, principio_activo_id) DO UPDATE
SET concentracion = EXCLUDED.concentracion;

COMMIT;

SET search_path TO public;

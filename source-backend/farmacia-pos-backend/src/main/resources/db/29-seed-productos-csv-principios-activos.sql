-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando {SCHEMA} por el tenant correspondiente.
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

INSERT INTO principios_activos (nombre, descripcion, activo)
SELECT DISTINCT
       LEFT(TRIM(pa.nombre), 200) AS nombre,
       'Importado desde LINAME 2026-2027 CSV' AS descripcion,
       true AS activo
FROM seed_productos_csv_staging s
CROSS JOIN LATERAL regexp_split_to_table(s.medicamento, '[[:space:]]*\+[[:space:]]*') AS pa(nombre)
WHERE s.es_valido = true
  AND NULLIF(TRIM(pa.nombre), '') IS NOT NULL
ON CONFLICT (nombre) DO UPDATE
SET activo = true;

COMMIT;

SET search_path TO public;

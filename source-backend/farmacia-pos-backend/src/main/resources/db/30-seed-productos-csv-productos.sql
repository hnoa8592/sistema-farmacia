-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando {SCHEMA} por el tenant correspondiente.
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

WITH categorias(nombre, descripcion) AS (
    VALUES
        ('Antiácidos y Gastroprotectores', 'Equivalencia ATQ A: tracto alimentario y metabolismo'),
        ('Anticoagulantes y Antitrombóticos', 'Equivalencia ATQ B: sangre y órganos hematopoyéticos'),
        ('Cardiovascular', 'Equivalencia ATQ C: sistema cardiovascular'),
        ('Dermatológicos', 'Equivalencia ATQ D: medicamentos dermatológicos'),
        ('Salud Reproductiva', 'Equivalencia ATQ G: sistema genitourinario y hormonas sexuales'),
        ('Hormonas y Corticoides', 'Equivalencia ATQ H: preparados hormonales sistémicos'),
        ('Antibióticos', 'Equivalencia ATQ J: antiinfecciosos de uso sistémico'),
        ('Oncológicos', 'Equivalencia ATQ L: antineoplásicos e inmunomoduladores'),
        ('Sistema Musculoesquelético', 'Equivalencia ATQ M: sistema musculoesquelético'),
        ('Psicotrópicos y Antidepresivos', 'Equivalencia ATQ N: sistema nervioso'),
        ('Antiparasitarios', 'Equivalencia ATQ P: antiparasitarios'),
        ('Broncodilatadores y Antiasmáticos', 'Equivalencia ATQ R: sistema respiratorio'),
        ('Oftalmológicos', 'Equivalencia ATQ S: órganos de los sentidos'),
        ('Sueros y Electrolitos', 'Equivalencia ATQ V: varios')
)
INSERT INTO categorias_terapeuticas (nombre, descripcion, activo)
SELECT nombre, descripcion, true FROM categorias
ON CONFLICT (nombre) DO UPDATE
SET descripcion = EXCLUDED.descripcion,
    activo = true;

WITH formas AS (
    SELECT DISTINCT
           CASE
               WHEN lower(forma_farmaceutica) IN ('comprimido', 'comprimidos') THEN 'Tableta'
               WHEN lower(forma_farmaceutica) IN ('capsula', 'cápsula') THEN 'Cápsula'
               WHEN lower(forma_farmaceutica) LIKE 'suspensión%' THEN 'Suspensión'
               WHEN lower(forma_farmaceutica) LIKE 'solución oral%' THEN 'Solución oral'
               WHEN lower(forma_farmaceutica) LIKE 'crema%' THEN 'Crema'
               WHEN lower(forma_farmaceutica) LIKE 'pomada%' THEN 'Pomada'
               WHEN lower(forma_farmaceutica) LIKE 'jarabe%' THEN 'Jarabe'
               WHEN lower(forma_farmaceutica) LIKE 'gel%' THEN 'Gel'
               WHEN lower(forma_farmaceutica) LIKE 'colirio%' THEN 'Colirio'
               ELSE LEFT(forma_farmaceutica, 200)
           END AS nombre
    FROM seed_productos_csv_staging
    WHERE es_valido = true
)
INSERT INTO formas_farmaceuticas (nombre, descripcion, activo)
SELECT nombre, 'Forma farmacéutica importada/equivalente desde LINAME 2026-2027 CSV', true
FROM formas
WHERE NULLIF(nombre, '') IS NOT NULL
ON CONFLICT (nombre) DO UPDATE
SET activo = true;

WITH vias(nombre, descripcion) AS (
    VALUES ('Parenteral', 'Administración inyectable cuando el CSV no diferencia IV, IM o SC')
)
INSERT INTO vias_administracion (nombre, descripcion, activo)
SELECT nombre, descripcion, true FROM vias
ON CONFLICT (nombre) DO UPDATE
SET descripcion = EXCLUDED.descripcion,
    activo = true;

WITH vias_csv AS (
    SELECT DISTINCT
           CASE
               WHEN lower(forma_farmaceutica) LIKE '%oftálm%' OR lower(forma_farmaceutica) LIKE '%oftalm%' OR lower(forma_farmaceutica) LIKE '%colirio%' THEN 'Oftálmica'
               WHEN lower(forma_farmaceutica) LIKE '%ótica%' OR lower(forma_farmaceutica) LIKE '%otica%' THEN 'Ótica'
               WHEN lower(forma_farmaceutica) LIKE '%vaginal%' OR lower(forma_farmaceutica) LIKE '%óvulo%' OR lower(forma_farmaceutica) LIKE '%ovulo%' THEN 'Vaginal'
               WHEN lower(forma_farmaceutica) LIKE '%rectal%' OR lower(forma_farmaceutica) LIKE '%supositorio%' THEN 'Rectal'
               WHEN lower(forma_farmaceutica) LIKE '%nasal%' THEN 'Nasal'
               WHEN lower(forma_farmaceutica) LIKE '%inhal%' OR lower(forma_farmaceutica) LIKE '%nebul%' THEN 'Inhalatoria'
               WHEN lower(forma_farmaceutica) LIKE '%intraven%' THEN 'Intravenosa'
               WHEN lower(forma_farmaceutica) LIKE '%intramus%' THEN 'Intramuscular'
               WHEN lower(forma_farmaceutica) LIKE '%subcut%' THEN 'Subcutánea'
               WHEN lower(forma_farmaceutica) LIKE '%inyect%' THEN 'Parenteral'
               WHEN lower(forma_farmaceutica) LIKE '%dérmic%' OR lower(forma_farmaceutica) LIKE '%dermic%' OR lower(forma_farmaceutica) LIKE '%tópic%' OR lower(forma_farmaceutica) LIKE '%topic%' OR lower(forma_farmaceutica) LIKE '%crema%' OR lower(forma_farmaceutica) LIKE '%pomada%' OR lower(forma_farmaceutica) LIKE '%gel%' THEN 'Tópica'
               ELSE 'Oral'
           END AS nombre
    FROM seed_productos_csv_staging
    WHERE es_valido = true
)
INSERT INTO vias_administracion (nombre, descripcion, activo)
SELECT nombre, 'Vía de administración inferida desde la forma farmacéutica LINAME 2026-2027 CSV', true
FROM vias_csv
ON CONFLICT (nombre) DO UPDATE
SET activo = true;

WITH source AS (
    SELECT DISTINCT ON (codigo)
           codigo, medicamento, forma_farmaceutica, concentracion, clasificacion_atq,
           uso_restringido, aclaracion_particularidades,
           CASE grupo_atq
               WHEN 'A' THEN 'Antiácidos y Gastroprotectores'
               WHEN 'B' THEN 'Anticoagulantes y Antitrombóticos'
               WHEN 'C' THEN 'Cardiovascular'
               WHEN 'D' THEN 'Dermatológicos'
               WHEN 'G' THEN 'Salud Reproductiva'
               WHEN 'H' THEN 'Hormonas y Corticoides'
               WHEN 'J' THEN 'Antibióticos'
               WHEN 'L' THEN 'Oncológicos'
               WHEN 'M' THEN 'Sistema Musculoesquelético'
               WHEN 'N' THEN 'Psicotrópicos y Antidepresivos'
               WHEN 'P' THEN 'Antiparasitarios'
               WHEN 'R' THEN 'Broncodilatadores y Antiasmáticos'
               WHEN 'S' THEN 'Oftalmológicos'
               WHEN 'V' THEN 'Sueros y Electrolitos'
               ELSE 'Vitaminas y Suplementos'
           END AS categoria_nombre,
           CASE
               WHEN lower(forma_farmaceutica) IN ('comprimido', 'comprimidos') THEN 'Tableta'
               WHEN lower(forma_farmaceutica) IN ('capsula', 'cápsula') THEN 'Cápsula'
               WHEN lower(forma_farmaceutica) LIKE 'suspensión%' THEN 'Suspensión'
               WHEN lower(forma_farmaceutica) LIKE 'solución oral%' THEN 'Solución oral'
               WHEN lower(forma_farmaceutica) LIKE 'crema%' THEN 'Crema'
               WHEN lower(forma_farmaceutica) LIKE 'pomada%' THEN 'Pomada'
               WHEN lower(forma_farmaceutica) LIKE 'jarabe%' THEN 'Jarabe'
               WHEN lower(forma_farmaceutica) LIKE 'gel%' THEN 'Gel'
               WHEN lower(forma_farmaceutica) LIKE 'colirio%' THEN 'Colirio'
               ELSE LEFT(forma_farmaceutica, 200)
           END AS forma_nombre,
           CASE
               WHEN lower(forma_farmaceutica) LIKE '%oftálm%' OR lower(forma_farmaceutica) LIKE '%oftalm%' OR lower(forma_farmaceutica) LIKE '%colirio%' THEN 'Oftálmica'
               WHEN lower(forma_farmaceutica) LIKE '%ótica%' OR lower(forma_farmaceutica) LIKE '%otica%' THEN 'Ótica'
               WHEN lower(forma_farmaceutica) LIKE '%vaginal%' OR lower(forma_farmaceutica) LIKE '%óvulo%' OR lower(forma_farmaceutica) LIKE '%ovulo%' THEN 'Vaginal'
               WHEN lower(forma_farmaceutica) LIKE '%rectal%' OR lower(forma_farmaceutica) LIKE '%supositorio%' THEN 'Rectal'
               WHEN lower(forma_farmaceutica) LIKE '%nasal%' THEN 'Nasal'
               WHEN lower(forma_farmaceutica) LIKE '%inhal%' OR lower(forma_farmaceutica) LIKE '%nebul%' THEN 'Inhalatoria'
               WHEN lower(forma_farmaceutica) LIKE '%intraven%' THEN 'Intravenosa'
               WHEN lower(forma_farmaceutica) LIKE '%intramus%' THEN 'Intramuscular'
               WHEN lower(forma_farmaceutica) LIKE '%subcut%' THEN 'Subcutánea'
               WHEN lower(forma_farmaceutica) LIKE '%inyect%' THEN 'Parenteral'
               WHEN lower(forma_farmaceutica) LIKE '%dérmic%' OR lower(forma_farmaceutica) LIKE '%dermic%' OR lower(forma_farmaceutica) LIKE '%tópic%' OR lower(forma_farmaceutica) LIKE '%topic%' OR lower(forma_farmaceutica) LIKE '%crema%' OR lower(forma_farmaceutica) LIKE '%pomada%' OR lower(forma_farmaceutica) LIKE '%gel%' THEN 'Tópica'
               ELSE 'Oral'
           END AS via_nombre
    FROM seed_productos_csv_staging
    WHERE es_valido = true
    ORDER BY codigo, fila_excel
)
INSERT INTO productos (nombre, codigo, descripcion, concentracion, presentacion, requiere_receta, controlado, activo, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT LEFT(s.medicamento, 300), s.codigo,
       LEFT(CONCAT('LINAME 2026-2027. ATQ: ', COALESCE(NULLIF(s.clasificacion_atq, ''), 'N/D'), '. Forma CSV: ', s.forma_farmaceutica), 1000),
       LEFT(s.concentracion, 100), NULLIF(LEFT(s.aclaracion_particularidades, 200), ''),
       (upper(COALESCE(s.uso_restringido, '')) = 'R'), false, true,
       c.id, f.id, v.id
FROM source s
LEFT JOIN categorias_terapeuticas c ON c.nombre = s.categoria_nombre
LEFT JOIN formas_farmaceuticas f ON f.nombre = s.forma_nombre
LEFT JOIN vias_administracion v ON v.nombre = s.via_nombre
ON CONFLICT (codigo) DO UPDATE
SET nombre = EXCLUDED.nombre,
    descripcion = EXCLUDED.descripcion,
    concentracion = EXCLUDED.concentracion,
    presentacion = EXCLUDED.presentacion,
    requiere_receta = EXCLUDED.requiere_receta,
    controlado = EXCLUDED.controlado,
    activo = true,
    categoria_id = EXCLUDED.categoria_id,
    forma_farmaceutica_id = EXCLUDED.forma_farmaceutica_id,
    via_administracion_id = EXCLUDED.via_administracion_id;

COMMIT;

SET search_path TO public;
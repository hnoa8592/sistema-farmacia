-- ============================================================
-- 16-fix-precios-productos-cvs.sql
-- Tenant: farmacia_bri
-- Codificacion: UTF-8
--
-- Objetivo:
--   - Dejar precios activos, vigentes y positivos para UNIDAD, TIRA,
--     CAJA y FRACCION en todos los productos activos.
--   - Corregir precios nulos, cero o negativos en producto_precios.
--   - Cerrar duplicados vigentes por producto/tipo sin eliminar datos.
--   - No modificar inventario, ventas, usuarios ni catalogos.
--
-- Regla de derivacion:
--   - UNIDAD y FRACCION toman el precio unitario vigente del producto.
--   - CAJA usa un precio CAJA vigente si ya existe; si falta, deriva
--     unidad * cantidad detectada en presentacion ("Caja x N"). Si no
--     hay cantidad, usa el precio unitario.
--   - TIRA se calcula como unidad * 10 en formas solidas fraccionables
--     cuando hay caja de 10 o mas unidades. En otros casos usa unidad.
--
-- El script es idempotente: se puede ejecutar varias veces sin crear
-- nuevos duplicados ni cambiar otros modulos.
-- ============================================================

SET client_encoding TO 'UTF8';
SET search_path TO farmacia_bri, public;

BEGIN;

-- ------------------------------------------------------------
-- 1) Diagnostico previo
-- ------------------------------------------------------------
WITH tipos(tipo_precio) AS (
    VALUES ('UNIDAD'), ('TIRA'), ('CAJA'), ('FRACCION')
),
faltantes AS (
    SELECT t.tipo_precio, COUNT(*) AS productos_sin_precio_vigente
    FROM productos p
    CROSS JOIN tipos t
    WHERE p.activo = true
      AND NOT EXISTS (
          SELECT 1
          FROM producto_precios pp
          WHERE pp.producto_id = p.id
            AND pp.tipo_precio = t.tipo_precio
            AND pp.activo = true
            AND pp.precio IS NOT NULL
            AND pp.precio > 0
            AND pp.vigencia_desde <= now()
            AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
      )
    GROUP BY t.tipo_precio
),
duplicados AS (
    SELECT COUNT(*) AS grupos_duplicados_vigentes
    FROM (
        SELECT pp.producto_id, pp.tipo_precio
        FROM producto_precios pp
        WHERE pp.activo = true
          AND pp.vigencia_desde <= now()
          AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
        GROUP BY pp.producto_id, pp.tipo_precio
        HAVING COUNT(*) > 1
    ) d
),
invalidos AS (
    SELECT COUNT(*) AS precios_nulos_cero_o_negativos
    FROM producto_precios pp
    WHERE pp.precio IS NULL OR pp.precio <= 0
)
SELECT
    'ANTES' AS etapa,
    (SELECT jsonb_object_agg(tipo_precio, productos_sin_precio_vigente) FROM faltantes) AS faltantes_por_tipo,
    (SELECT grupos_duplicados_vigentes FROM duplicados) AS grupos_duplicados_vigentes,
    (SELECT precios_nulos_cero_o_negativos FROM invalidos) AS precios_nulos_cero_o_negativos;

-- ------------------------------------------------------------
-- 2) Corregir precios vacios, nulos, cero o negativos.
--    Usa el mejor precio positivo del mismo producto; si no existe,
--    deja 0.01 para cumplir la restriccion operativa del POS.
-- ------------------------------------------------------------
WITH precio_base AS (
    SELECT
        p.id AS producto_id,
        COALESCE(
            MAX(pp.precio) FILTER (
                WHERE pp.tipo_precio = 'UNIDAD'
                  AND pp.precio IS NOT NULL
                  AND pp.precio > 0
            ),
            MAX(pp.precio) FILTER (
                WHERE pp.precio IS NOT NULL
                  AND pp.precio > 0
            ),
            0.01
        ) AS precio_referencia
    FROM productos p
    LEFT JOIN producto_precios pp ON pp.producto_id = p.id
    GROUP BY p.id
)
UPDATE producto_precios pp
SET precio = ROUND(pb.precio_referencia, 2)
FROM precio_base pb
WHERE pb.producto_id = pp.producto_id
  AND (pp.precio IS NULL OR pp.precio <= 0);

-- ------------------------------------------------------------
-- 3) Cerrar duplicados activos y vigentes por producto/tipo.
--    Se conserva una fila: la vigente mas reciente, con mayor precio.
--    Las demas quedan historicas: activo=false y vigencia_hasta pasada.
-- ------------------------------------------------------------
WITH ranked AS (
    SELECT
        pp.id,
        ROW_NUMBER() OVER (
            PARTITION BY pp.producto_id, pp.tipo_precio
            ORDER BY pp.vigencia_desde DESC, pp.precio DESC, pp.id
        ) AS rn
    FROM producto_precios pp
    WHERE pp.activo = true
      AND pp.vigencia_desde <= now()
      AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
)
UPDATE producto_precios pp
SET activo = false,
    vigencia_hasta = LEAST(COALESCE(pp.vigencia_hasta, now() - interval '1 second'), now() - interval '1 second')
FROM ranked r
WHERE r.id = pp.id
  AND r.rn > 1;

-- ------------------------------------------------------------
-- 4) Insertar precios faltantes para todos los productos activos.
--    No inserta si ya existe un precio activo, vigente y positivo.
-- ------------------------------------------------------------
WITH tipos(tipo_precio) AS (
    VALUES ('UNIDAD'), ('TIRA'), ('CAJA'), ('FRACCION')
),
base AS (
    SELECT
        p.id AS producto_id,
        p.presentacion,
        COALESCE(ff.nombre, '') AS forma,
        COALESCE(
            MAX(pp.precio) FILTER (
                WHERE pp.tipo_precio = 'UNIDAD'
                  AND pp.activo = true
                  AND pp.precio IS NOT NULL
                  AND pp.precio > 0
                  AND pp.vigencia_desde <= now()
                  AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
            ),
            MAX(pp.precio) FILTER (
                WHERE pp.activo = true
                  AND pp.precio IS NOT NULL
                  AND pp.precio > 0
                  AND pp.vigencia_desde <= now()
                  AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
            ),
            0.01
        ) AS precio_unidad,
        MAX(pp.precio) FILTER (
            WHERE pp.tipo_precio = 'CAJA'
              AND pp.activo = true
              AND pp.precio IS NOT NULL
              AND pp.precio > 0
              AND pp.vigencia_desde <= now()
              AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
        ) AS precio_caja_existente,
        COALESCE(
            NULLIF(substring(lower(COALESCE(p.presentacion, '')) FROM 'x[[:space:]]*([0-9]+)'), '')::numeric,
            1
        ) AS unidades_por_caja
    FROM productos p
    LEFT JOIN formas_farmaceuticas ff ON ff.id = p.forma_farmaceutica_id
    LEFT JOIN producto_precios pp ON pp.producto_id = p.id
    WHERE p.activo = true
    GROUP BY p.id, p.presentacion, ff.nombre
),
precios_calculados AS (
    SELECT
        b.producto_id,
        t.tipo_precio,
        CASE t.tipo_precio
            WHEN 'UNIDAD' THEN b.precio_unidad
            WHEN 'FRACCION' THEN b.precio_unidad
            WHEN 'CAJA' THEN COALESCE(b.precio_caja_existente, b.precio_unidad * GREATEST(b.unidades_por_caja, 1))
            WHEN 'TIRA' THEN
                CASE
                    WHEN lower(b.forma) ~ '(tableta|comprimido|capsula|cápsula|perla)'
                         AND b.unidades_por_caja >= 10
                        THEN b.precio_unidad * 10
                    ELSE b.precio_unidad
                END
        END AS precio
    FROM base b
    CROSS JOIN tipos t
)
INSERT INTO producto_precios (
    producto_id,
    tipo_precio,
    precio,
    precio_compra,
    vigencia_desde,
    vigencia_hasta,
    activo
)
SELECT
    pc.producto_id,
    pc.tipo_precio,
    ROUND(GREATEST(pc.precio, 0.01), 2),
    NULL,
    now(),
    NULL,
    true
FROM precios_calculados pc
WHERE NOT EXISTS (
    SELECT 1
    FROM producto_precios pp
    WHERE pp.producto_id = pc.producto_id
      AND pp.tipo_precio = pc.tipo_precio
      AND pp.activo = true
      AND pp.precio IS NOT NULL
      AND pp.precio > 0
      AND pp.vigencia_desde <= now()
      AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
);

-- ------------------------------------------------------------
-- 5) Evitar nuevos duplicados abiertos hacia adelante.
--    Permite historicos cerrados, pero impide dos precios actuales
--    activos con vigencia_hasta NULL para el mismo producto/tipo.
-- ------------------------------------------------------------
CREATE UNIQUE INDEX IF NOT EXISTS uq_producto_precios_actual_abierto
ON producto_precios (producto_id, tipo_precio)
WHERE activo = true AND vigencia_hasta IS NULL;

-- ------------------------------------------------------------
-- 6) Validacion posterior.
--    Debe devolver faltantes=0, duplicados=0 e invalidos=0.
-- ------------------------------------------------------------
WITH tipos(tipo_precio) AS (
    VALUES ('UNIDAD'), ('TIRA'), ('CAJA'), ('FRACCION')
),
faltantes AS (
    SELECT t.tipo_precio, COUNT(*) AS productos_sin_precio_vigente
    FROM productos p
    CROSS JOIN tipos t
    WHERE p.activo = true
      AND NOT EXISTS (
          SELECT 1
          FROM producto_precios pp
          WHERE pp.producto_id = p.id
            AND pp.tipo_precio = t.tipo_precio
            AND pp.activo = true
            AND pp.precio IS NOT NULL
            AND pp.precio > 0
            AND pp.vigencia_desde <= now()
            AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
      )
    GROUP BY t.tipo_precio
),
duplicados AS (
    SELECT COUNT(*) AS grupos_duplicados_vigentes
    FROM (
        SELECT pp.producto_id, pp.tipo_precio
        FROM producto_precios pp
        WHERE pp.activo = true
          AND pp.vigencia_desde <= now()
          AND (pp.vigencia_hasta IS NULL OR pp.vigencia_hasta >= now())
        GROUP BY pp.producto_id, pp.tipo_precio
        HAVING COUNT(*) > 1
    ) d
),
invalidos AS (
    SELECT COUNT(*) AS precios_nulos_cero_o_negativos
    FROM producto_precios pp
    WHERE pp.precio IS NULL OR pp.precio <= 0
)
SELECT
    'DESPUES' AS etapa,
    COALESCE((SELECT jsonb_object_agg(tipo_precio, productos_sin_precio_vigente) FROM faltantes), '{}'::jsonb) AS faltantes_por_tipo,
    (SELECT grupos_duplicados_vigentes FROM duplicados) AS grupos_duplicados_vigentes,
    (SELECT precios_nulos_cero_o_negativos FROM invalidos) AS precios_nulos_cero_o_negativos;

COMMIT;

SET search_path TO public;

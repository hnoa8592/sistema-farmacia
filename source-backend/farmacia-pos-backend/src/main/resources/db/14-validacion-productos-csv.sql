-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando {SCHEMA} por el tenant correspondiente.
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

SELECT COUNT(*) AS total_filas_staging,
       COUNT(*) FILTER (WHERE es_valido) AS filas_validas,
       COUNT(*) FILTER (WHERE NOT es_valido) AS filas_invalidas
FROM seed_productos_csv_staging;

SELECT fila_excel, codigo, medicamento, forma_farmaceutica, concentracion, precio_referencial, motivo_invalidacion
FROM seed_productos_csv_staging
WHERE es_valido = false
ORDER BY fila_excel;

SELECT COUNT(*) AS total_productos_cargados_desde_csv
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo
WHERE s.es_valido = true;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_precios pp WHERE pp.producto_id = p.id AND pp.activo = true)
ORDER BY p.codigo;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_lotes pl WHERE pl.producto_id = p.id AND pl.activo = true)
ORDER BY p.codigo;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_lotes pl JOIN inventario i ON i.lote_id = pl.id WHERE pl.producto_id = p.id)
ORDER BY p.codigo;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_principios_activos ppa WHERE ppa.producto_id = p.id)
ORDER BY p.codigo;

SELECT codigo, COUNT(*) AS cantidad
FROM productos
GROUP BY codigo
HAVING COUNT(*) > 1
ORDER BY cantidad DESC, codigo;

SELECT p.nombre, p.concentracion, p.presentacion,
       COALESCE(f.nombre, 'SIN_FORMA') AS forma_farmaceutica,
       COALESCE(v.nombre, 'SIN_VIA') AS via_administracion,
       COUNT(*) AS cantidad
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN formas_farmaceuticas f ON f.id = p.forma_farmaceutica_id
LEFT JOIN vias_administracion v ON v.id = p.via_administracion_id
GROUP BY p.nombre, p.concentracion, p.presentacion, f.nombre, v.nombre
HAVING COUNT(*) > 1
ORDER BY cantidad DESC, p.nombre;

SELECT COALESCE(c.nombre, 'SIN_CATEGORIA') AS categoria, COUNT(*) AS total
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN categorias_terapeuticas c ON c.id = p.categoria_id
GROUP BY c.nombre
ORDER BY total DESC, categoria;

SELECT COALESCE(f.nombre, 'SIN_FORMA') AS forma_farmaceutica, COUNT(*) AS total
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN formas_farmaceuticas f ON f.id = p.forma_farmaceutica_id
GROUP BY f.nombre
ORDER BY total DESC, forma_farmaceutica;

SELECT COALESCE(v.nombre, 'SIN_VIA') AS via_administracion, COUNT(*) AS total
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN vias_administracion v ON v.id = p.via_administracion_id
GROUP BY v.nombre
ORDER BY total DESC, via_administracion;

COMMIT;

SET search_path TO public;
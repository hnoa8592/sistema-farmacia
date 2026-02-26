-- ============================================================
-- 09-seed-productos-liname-part2b.sql
-- Lista Nacional de Medicamentos Esenciales - Bolivia 2022-2024
-- GRUPOS 9 al 15 (continuación de part2.sql)
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

-- ============================================================
-- GRUPO 9: BRONCODILATADORES Y ANTIASMÁTICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Salbutamol Inhalador', 'LINAME-0500', '100 mcg/dosis', 'Inhalador x 200 dosis', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Inhalador de Dosis Medida' AND v.nombre='Inhalatoria'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mcg/dosis' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0500' AND pa.nombre='Salbutamol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 110.00, 68.00, NOW() FROM productos WHERE codigo='LINAME-0500';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Salbutamol Nebulización', 'LINAME-0501', '1 mg/mL', 'Frasco x 20 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Solución para Nebulización' AND v.nombre='Inhalatoria'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0501' AND pa.nombre='Salbutamol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0501';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Salbutamol Jarabe', 'LINAME-0502', '2 mg/5 mL', 'Frasco x 100 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Jarabe' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '2 mg/5 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0502' AND pa.nombre='Salbutamol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 17.00, 10.50, NOW() FROM productos WHERE codigo='LINAME-0502';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Budesonida Inhalador', 'LINAME-0503', '200 mcg/dosis', 'Inhalador x 200 dosis', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Inhalador de Dosis Medida' AND v.nombre='Inhalatoria'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mcg/dosis' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0503' AND pa.nombre='Budesonida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 155.00, 96.00, NOW() FROM productos WHERE codigo='LINAME-0503';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Budesonida Nebulización', 'LINAME-0504', '0.5 mg/2 mL', 'Caja x 20 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Solución para Nebulización' AND v.nombre='Inhalatoria'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.5 mg/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0504' AND pa.nombre='Budesonida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 13.50, NOW() FROM productos WHERE codigo='LINAME-0504';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 400.00, 248.00, NOW() FROM productos WHERE codigo='LINAME-0504';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ipratropio Inhalador', 'LINAME-0505', '20 mcg/dosis', 'Inhalador x 200 dosis', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Inhalador de Dosis Medida' AND v.nombre='Inhalatoria'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mcg/dosis' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0505' AND pa.nombre='Ipratropio' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 140.00, 87.00, NOW() FROM productos WHERE codigo='LINAME-0505';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Montelukast', 'LINAME-0506', '10 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0506' AND pa.nombre='Montelukast' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0506';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 280.00, 174.00, NOW() FROM productos WHERE codigo='LINAME-0506';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Montelukast Masticable', 'LINAME-0507', '5 mg', 'Caja x 30 tabletas masticables', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Broncodilatadores y Antiasmáticos' AND f.nombre='Tableta Masticable' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0507' AND pa.nombre='Montelukast' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0507';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 275.00, 170.00, NOW() FROM productos WHERE codigo='LINAME-0507';

-- ============================================================
-- GRUPO 10: DIGESTIVO
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Omeprazol', 'LINAME-0550', '20 mg', 'Caja x 14 cápsulas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiácidos y Gastroprotectores' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0550' AND pa.nombre='Omeprazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0550';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0550';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Omeprazol IV', 'LINAME-0551', '40 mg', 'Vial polvo para inyección', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiácidos y Gastroprotectores' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '40 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0551' AND pa.nombre='Omeprazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0551';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Pantoprazol', 'LINAME-0552', '40 mg', 'Caja x 14 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiácidos y Gastroprotectores' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '40 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0552' AND pa.nombre='Pantoprazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.10, NOW() FROM productos WHERE codigo='LINAME-0552';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  64.00, 40.00, NOW() FROM productos WHERE codigo='LINAME-0552';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ranitidina', 'LINAME-0553', '150 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiácidos y Gastroprotectores' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '150 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0553' AND pa.nombre='Ranitidina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0553';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  36.00, 22.00, NOW() FROM productos WHERE codigo='LINAME-0553';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metoclopramida', 'LINAME-0554', '10 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiemético y Procinético' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0554' AND pa.nombre='Metoclopramida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.50, 0.90, NOW() FROM productos WHERE codigo='LINAME-0554';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  27.00, 17.00, NOW() FROM productos WHERE codigo='LINAME-0554';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metoclopramida Inyectable', 'LINAME-0555', '10 mg/2 mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiemético y Procinético' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0555' AND pa.nombre='Metoclopramida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.00, 3.75, NOW() FROM productos WHERE codigo='LINAME-0555';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  27.00, 17.00, NOW() FROM productos WHERE codigo='LINAME-0555';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ondansetrón', 'LINAME-0556', '8 mg', 'Caja x 10 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiemético y Procinético' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '8 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0556' AND pa.nombre='Ondansetrón' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0556';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  90.00, 56.00, NOW() FROM productos WHERE codigo='LINAME-0556';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ondansetrón Inyectable', 'LINAME-0557', '4 mg/2 mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiemético y Procinético' AND f.nombre='Ampolla' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '4 mg/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0557' AND pa.nombre='Ondansetrón' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 15.00, 9.30, NOW() FROM productos WHERE codigo='LINAME-0557';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  68.00, 42.00, NOW() FROM productos WHERE codigo='LINAME-0557';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Domperidona', 'LINAME-0558', '10 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiemético y Procinético' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0558' AND pa.nombre='Domperidona' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0558';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  45.00, 28.00, NOW() FROM productos WHERE codigo='LINAME-0558';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Loperamida', 'LINAME-0559', '2 mg', 'Caja x 12 cápsulas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiarreicos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '2 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0559' AND pa.nombre='Loperamida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0559';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  27.00, 17.00, NOW() FROM productos WHERE codigo='LINAME-0559';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Bromuro de Hioscina', 'LINAME-0560', '10 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Relajantes Musculares' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0560' AND pa.nombre='Bromuro de Hioscina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0560';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  45.00, 28.00, NOW() FROM productos WHERE codigo='LINAME-0560';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Bromuro de Hioscina Inyectable', 'LINAME-0561', '20 mg/mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Relajantes Musculares' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0561' AND pa.nombre='Bromuro de Hioscina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0561';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  45.00, 28.00, NOW() FROM productos WHERE codigo='LINAME-0561';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Sales de Rehidratación Oral', 'LINAME-0562', 'Glucosa 13.5 g + NaCl 2.6 g + KCl 1.5 g', 'Sobre para 1 L', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiarreicos' AND f.nombre='Polvo para Suspensión' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '13.5 g + 2.6 g + 1.5 g' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0562' AND pa.nombre='Sales de Rehidratación Oral' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0562';

-- ============================================================
-- GRUPO 11: ANTIDIABÉTICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metformina 500 mg', 'LINAME-0600', '500 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0600' AND pa.nombre='Metformina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0600';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  55.00, 34.00, NOW() FROM productos WHERE codigo='LINAME-0600';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metformina 850 mg', 'LINAME-0601', '850 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '850 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0601' AND pa.nombre='Metformina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0601';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  68.00, 42.00, NOW() FROM productos WHERE codigo='LINAME-0601';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Glibenclamida', 'LINAME-0602', '5 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0602' AND pa.nombre='Glibenclamida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.20, 0.75, NOW() FROM productos WHERE codigo='LINAME-0602';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0602';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Glimepirida', 'LINAME-0603', '4 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '4 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0603' AND pa.nombre='Glimepirida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.10, NOW() FROM productos WHERE codigo='LINAME-0603';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 135.00, 84.00, NOW() FROM productos WHERE codigo='LINAME-0603';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Sitagliptina', 'LINAME-0604', '100 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0604' AND pa.nombre='Sitagliptina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 20.00, 12.50, NOW() FROM productos WHERE codigo='LINAME-0604';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 560.00, 348.00, NOW() FROM productos WHERE codigo='LINAME-0604';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Insulina NPH', 'LINAME-0605', '100 UI/mL', 'Frasco vial x 10 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Ampolla' AND v.nombre='Subcutánea'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 UI/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0605' AND pa.nombre='Insulina NPH' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 175.00, 108.00, NOW() FROM productos WHERE codigo='LINAME-0605';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Insulina Regular', 'LINAME-0606', '100 UI/mL', 'Frasco vial x 10 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Ampolla' AND v.nombre='Subcutánea'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 UI/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0606' AND pa.nombre='Insulina Regular' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 170.00, 105.00, NOW() FROM productos WHERE codigo='LINAME-0606';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Insulina Glargina', 'LINAME-0607', '100 UI/mL', 'Frasco vial x 10 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antidiabéticos' AND f.nombre='Ampolla' AND v.nombre='Subcutánea'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 UI/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0607' AND pa.nombre='Insulina Glargina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 245.00, 152.00, NOW() FROM productos WHERE codigo='LINAME-0607';

-- ============================================================
-- GRUPO 12: HORMONAS Y CORTICOIDES
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Dexametasona Inyectable', 'LINAME-0650', '4 mg/mL', 'Caja x 6 ampollas 2 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Hormonas y Corticoides' AND f.nombre='Ampolla' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '4 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0650' AND pa.nombre='Dexametasona' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0650';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  55.00, 34.00, NOW() FROM productos WHERE codigo='LINAME-0650';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Prednisona', 'LINAME-0651', '5 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Hormonas y Corticoides' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0651' AND pa.nombre='Prednisona' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.80, 1.10, NOW() FROM productos WHERE codigo='LINAME-0651';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0651';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Hidrocortisona Inyectable', 'LINAME-0652', '100 mg', 'Vial polvo para inyección', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Hormonas y Corticoides' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0652' AND pa.nombre='Hidrocortisona' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 25.00, 15.50, NOW() FROM productos WHERE codigo='LINAME-0652';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metilprednisolona Inyectable', 'LINAME-0653', '500 mg', 'Vial polvo para inyección', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Hormonas y Corticoides' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0653' AND pa.nombre='Metilprednisolona' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 95.00, 59.00, NOW() FROM productos WHERE codigo='LINAME-0653';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Levotiroxina 50 mcg', 'LINAME-0654', '50 mcg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Tiroides' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mcg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0654' AND pa.nombre='Levotiroxina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 3.00, 1.85, NOW() FROM productos WHERE codigo='LINAME-0654';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  82.00, 51.00, NOW() FROM productos WHERE codigo='LINAME-0654';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Levotiroxina 100 mcg', 'LINAME-0655', '100 mcg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Tiroides' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mcg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0655' AND pa.nombre='Levotiroxina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 3.80, 2.35, NOW() FROM productos WHERE codigo='LINAME-0655';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 105.00, 65.00, NOW() FROM productos WHERE codigo='LINAME-0655';

-- ============================================================
-- GRUPO 13: VITAMINAS Y MINERALES
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ácido Fólico', 'LINAME-0700', '5 mg', 'Caja x 30 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Vitaminas y Suplementos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0700' AND pa.nombre='Ácido Fólico' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.00, 0.60, NOW() FROM productos WHERE codigo='LINAME-0700';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  27.00, 17.00, NOW() FROM productos WHERE codigo='LINAME-0700';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Vitamina C', 'LINAME-0701', '500 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Vitaminas y Suplementos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0701' AND pa.nombre='Vitamina C' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.20, 0.75, NOW() FROM productos WHERE codigo='LINAME-0701';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  22.00, 13.00, NOW() FROM productos WHERE codigo='LINAME-0701';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Calcio + Vitamina D3', 'LINAME-0702', '500 mg/400 UI', 'Caja x 30 tabletas masticables', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Vitaminas y Suplementos' AND f.nombre='Tableta Masticable' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg/400 UI' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0702' AND pa.nombre='Calcio + Vitamina D3' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0702';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 110.00, 68.00, NOW() FROM productos WHERE codigo='LINAME-0702';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Sulfato Ferroso', 'LINAME-0703', '300 mg', 'Caja x 30 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antianémicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '300 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0703' AND pa.nombre='Sulfato Ferroso' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.20, 0.75, NOW() FROM productos WHERE codigo='LINAME-0703';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0703';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Cianocobalamina', 'LINAME-0704', '1.000 mcg/mL', 'Caja x 5 ampollas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antianémicos' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1.000 mcg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0704' AND pa.nombre='Cianocobalamina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0704';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  45.00, 28.00, NOW() FROM productos WHERE codigo='LINAME-0704';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Zinc Sulfato', 'LINAME-0705', '20 mg', 'Caja x 30 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Vitaminas y Suplementos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0705' AND pa.nombre='Zinc Sulfato' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0705';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  55.00, 34.00, NOW() FROM productos WHERE codigo='LINAME-0705';

-- ============================================================
-- GRUPO 14: DERMATOLÓGICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Betametasona Crema', 'LINAME-0750', '0.05%', 'Tubo x 30 g', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Dermatológicos' AND f.nombre='Crema' AND v.nombre='Tópica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.05%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0750' AND pa.nombre='Betametasona' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 25.00, 15.50, NOW() FROM productos WHERE codigo='LINAME-0750';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Clobetasol Crema', 'LINAME-0751', '0.05%', 'Tubo x 30 g', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Dermatológicos' AND f.nombre='Crema' AND v.nombre='Tópica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.05%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0751' AND pa.nombre='Clobetasol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 28.00, 17.50, NOW() FROM productos WHERE codigo='LINAME-0751';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Permetrina Crema', 'LINAME-0752', '5%', 'Tubo x 60 g', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Dermatológicos' AND f.nombre='Crema' AND v.nombre='Tópica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0752' AND pa.nombre='Permetrina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0752';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ketoconazol Champú', 'LINAME-0753', '2%', 'Frasco x 120 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Dermatológicos' AND f.nombre='Champú' AND v.nombre='Tópica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '2%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0753' AND pa.nombre='Ketoconazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 38.00, 24.00, NOW() FROM productos WHERE codigo='LINAME-0753';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Tretinoína Crema', 'LINAME-0754', '0.025%', 'Tubo x 40 g', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Dermatológicos' AND f.nombre='Crema' AND v.nombre='Tópica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.025%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0754' AND pa.nombre='Tretinoína' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 42.00, 26.00, NOW() FROM productos WHERE codigo='LINAME-0754';

-- ============================================================
-- GRUPO 15: OFTALMOLÓGICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ciprofloxacino Colirio', 'LINAME-0800', '3 mg/mL', 'Frasco x 5 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Oftalmológicos' AND f.nombre='Colirio' AND v.nombre='Oftálmica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '3 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0800' AND pa.nombre='Ciprofloxacino' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 25.00, 15.50, NOW() FROM productos WHERE codigo='LINAME-0800';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Gentamicina Colirio', 'LINAME-0801', '3 mg/mL', 'Frasco x 5 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Oftalmológicos' AND f.nombre='Colirio' AND v.nombre='Oftálmica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '3 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0801' AND pa.nombre='Gentamicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 13.50, NOW() FROM productos WHERE codigo='LINAME-0801';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Timolol Colirio', 'LINAME-0802', '0.5%', 'Frasco x 5 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Oftalmológicos' AND f.nombre='Colirio' AND v.nombre='Oftálmica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.5%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0802' AND pa.nombre='Timolol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 30.00, 18.50, NOW() FROM productos WHERE codigo='LINAME-0802';

COMMIT;

-- ==============================================================
-- CONTINÚA EN: 09-seed-productos-liname-part2c.sql
-- (grupos 16 al 22: salud reproductiva, antihistamínicos,
--  anticonvulsivos, musculoesquelético, sueros, anestésicos, oncológicos)
-- ==============================================================

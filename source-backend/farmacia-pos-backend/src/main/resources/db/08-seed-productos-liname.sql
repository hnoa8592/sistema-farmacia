-- ============================================================
-- 08-seed-productos-liname.sql
-- Lista Nacional de Medicamentos Esenciales - Bolivia 2022-2024
-- LINAME - Ministerio de Salud del Estado Plurinacional de Bolivia
-- ============================================================
-- NOTA: Ejecutar DENTRO del schema del tenant correspondiente.
-- Ejemplo: SET search_path TO farmacia_demo, public;
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

-- ============================================================
-- PASO 2: PRODUCTOS DEL LINAME
-- ============================================================


-- ============================================================
-- GRUPO 1: ANALGÉSICOS, ANTIPIRÉTICOS Y AINEs
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Paracetamol', 'LINAME-0001', '500 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0001' AND pa.nombre='Paracetamol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.50, 0.25, NOW() FROM productos WHERE codigo='LINAME-0001';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',   8.50, 4.50, NOW() FROM productos WHERE codigo='LINAME-0001';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Paracetamol Jarabe', 'LINAME-0002', '120 mg/5 mL', 'Frasco x 120 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Jarabe' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '120 mg/5 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0002' AND pa.nombre='Paracetamol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0002';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ibuprofeno', 'LINAME-0003', '400 mg', 'Caja x 10 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiinflamatorios' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '400 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0003' AND pa.nombre='Ibuprofeno' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.80, 0.45, NOW() FROM productos WHERE codigo='LINAME-0003';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',   7.00, 4.00, NOW() FROM productos WHERE codigo='LINAME-0003';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ibuprofeno Suspensión', 'LINAME-0004', '200 mg/5 mL', 'Frasco x 100 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiinflamatorios' AND f.nombre='Suspensión' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg/5 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0004' AND pa.nombre='Ibuprofeno' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 14.00, NOW() FROM productos WHERE codigo='LINAME-0004';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metamizol', 'LINAME-0005', '500 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0005' AND pa.nombre='Metamizol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.60, 0.30, NOW() FROM productos WHERE codigo='LINAME-0005';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  10.00, 5.50, NOW() FROM productos WHERE codigo='LINAME-0005';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metamizol Inyectable', 'LINAME-0006', '1 g/2 mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1 g/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0006' AND pa.nombre='Metamizol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.50, 2.50, NOW() FROM productos WHERE codigo='LINAME-0006';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  20.00,11.00, NOW() FROM productos WHERE codigo='LINAME-0006';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Diclofenaco', 'LINAME-0007', '50 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiinflamatorios' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0007' AND pa.nombre='Diclofenaco' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.70, 0.35, NOW() FROM productos WHERE codigo='LINAME-0007';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  12.00, 6.00, NOW() FROM productos WHERE codigo='LINAME-0007';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Diclofenaco Inyectable', 'LINAME-0008', '75 mg/3 mL', 'Caja x 3 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiinflamatorios' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '75 mg/3 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0008' AND pa.nombre='Diclofenaco' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 2.80, NOW() FROM productos WHERE codigo='LINAME-0008';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  14.00, 7.50, NOW() FROM productos WHERE codigo='LINAME-0008';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Naproxeno', 'LINAME-0009', '500 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiinflamatorios' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0009' AND pa.nombre='Naproxeno' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.90, 0.50, NOW() FROM productos WHERE codigo='LINAME-0009';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  16.00, 8.50, NOW() FROM productos WHERE codigo='LINAME-0009';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ketorolaco Inyectable', 'LINAME-0010', '30 mg/mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '30 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0010' AND pa.nombre='Ketorolaco' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 7.00, 4.00, NOW() FROM productos WHERE codigo='LINAME-0010';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  32.00,18.00, NOW() FROM productos WHERE codigo='LINAME-0010';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Meloxicam', 'LINAME-0011', '15 mg', 'Caja x 10 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiinflamatorios' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '15 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0011' AND pa.nombre='Meloxicam' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.20, 0.70, NOW() FROM productos WHERE codigo='LINAME-0011';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  11.00, 6.00, NOW() FROM productos WHERE codigo='LINAME-0011';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Celecoxib', 'LINAME-0012', '200 mg', 'Caja x 10 cápsulas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiinflamatorios' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0012' AND pa.nombre='Celecoxib' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 3.00, 1.80, NOW() FROM productos WHERE codigo='LINAME-0012';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  28.00,16.00, NOW() FROM productos WHERE codigo='LINAME-0012';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Tramadol', 'LINAME-0013', '50 mg', 'Caja x 10 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0013' AND pa.nombre='Tramadol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.50, NOW() FROM productos WHERE codigo='LINAME-0013';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  22.00,13.00, NOW() FROM productos WHERE codigo='LINAME-0013';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Tramadol Inyectable', 'LINAME-0014', '100 mg/2 mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0014' AND pa.nombre='Tramadol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 12.00, 7.00, NOW() FROM productos WHERE codigo='LINAME-0014';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',   55.00,32.00, NOW() FROM productos WHERE codigo='LINAME-0014';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Morfina', 'LINAME-0015', '10 mg', 'Caja x 10 tabletas', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0015' AND pa.nombre='Morfina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.00, NOW() FROM productos WHERE codigo='LINAME-0015';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ácido Acetilsalicílico 100 mg', 'LINAME-0016', '100 mg', 'Caja x 30 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticoagulantes y Antitrombóticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0016' AND pa.nombre='Ácido Acetilsalicílico' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.40, 0.20, NOW() FROM productos WHERE codigo='LINAME-0016';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  10.00, 5.00, NOW() FROM productos WHERE codigo='LINAME-0016';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ácido Acetilsalicílico 500 mg', 'LINAME-0017', '500 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Analgésicos y Antipiréticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0017' AND pa.nombre='Ácido Acetilsalicílico' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.50, 0.25, NOW() FROM productos WHERE codigo='LINAME-0017';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',   9.00, 4.50, NOW() FROM productos WHERE codigo='LINAME-0017';


-- ============================================================
-- GRUPO 2: ANTIBIÓTICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Amoxicilina', 'LINAME-0100', '500 mg', 'Caja x 12 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0100' AND pa.nombre='Amoxicilina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.20, 0.70, NOW() FROM productos WHERE codigo='LINAME-0100';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  13.00, 8.00, NOW() FROM productos WHERE codigo='LINAME-0100';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Amoxicilina Suspensión', 'LINAME-0101', '250 mg/5 mL', 'Frasco x 60 mL (polvo)', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Polvo para Suspensión' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '250 mg/5 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0101' AND pa.nombre='Amoxicilina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 25.00, 15.00, NOW() FROM productos WHERE codigo='LINAME-0101';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Amoxicilina + Ácido Clavulánico', 'LINAME-0102', '875 mg/125 mg', 'Caja x 14 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '875 mg/125 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0102' AND pa.nombre='Amoxicilina + Ácido Clavulánico' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.50, 2.80, NOW() FROM productos WHERE codigo='LINAME-0102';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  58.00,36.00, NOW() FROM productos WHERE codigo='LINAME-0102';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Azitromicina', 'LINAME-0103', '500 mg', 'Caja x 3 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0103' AND pa.nombre='Azitromicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 7.00, 4.00, NOW() FROM productos WHERE codigo='LINAME-0103';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  20.00,11.00, NOW() FROM productos WHERE codigo='LINAME-0103';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Azitromicina Suspensión', 'LINAME-0104', '200 mg/5 mL', 'Frasco x 30 mL (polvo)', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Polvo para Suspensión' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg/5 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0104' AND pa.nombre='Azitromicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 35.00, 22.00, NOW() FROM productos WHERE codigo='LINAME-0104';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ciprofloxacino', 'LINAME-0105', '500 mg', 'Caja x 10 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0105' AND pa.nombre='Ciprofloxacino' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.80, 1.60, NOW() FROM productos WHERE codigo='LINAME-0105';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  26.00,14.00, NOW() FROM productos WHERE codigo='LINAME-0105';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ciprofloxacino Infusión IV', 'LINAME-0106', '200 mg/100 mL', 'Bolsa x 100 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Solución para Infusión IV' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg/100 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0106' AND pa.nombre='Ciprofloxacino' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0106';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ceftriaxona Inyectable', 'LINAME-0107', '1 g', 'Frasco ampolla (polvo)', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1 g' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0107' AND pa.nombre='Ceftriaxona' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 14.00, 8.00, NOW() FROM productos WHERE codigo='LINAME-0107';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Cefazolina Inyectable', 'LINAME-0108', '1 g', 'Frasco ampolla (polvo)', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1 g' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0108' AND pa.nombre='Cefazolina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.00, NOW() FROM productos WHERE codigo='LINAME-0108';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Cefalexina', 'LINAME-0109', '500 mg', 'Caja x 16 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0109' AND pa.nombre='Cefalexina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.40, NOW() FROM productos WHERE codigo='LINAME-0109';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  36.00,20.00, NOW() FROM productos WHERE codigo='LINAME-0109';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Claritromicina', 'LINAME-0110', '500 mg', 'Caja x 14 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0110' AND pa.nombre='Claritromicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 9.00, 5.50, NOW() FROM productos WHERE codigo='LINAME-0110';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 115.00,72.00, NOW() FROM productos WHERE codigo='LINAME-0110';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Clindamicina', 'LINAME-0111', '300 mg', 'Caja x 16 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '300 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0111' AND pa.nombre='Clindamicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.30, NOW() FROM productos WHERE codigo='LINAME-0111';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  58.00,34.00, NOW() FROM productos WHERE codigo='LINAME-0111';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Doxiciclina', 'LINAME-0112', '100 mg', 'Caja x 10 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0112' AND pa.nombre='Doxiciclina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.10, NOW() FROM productos WHERE codigo='LINAME-0112';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  18.00,10.00, NOW() FROM productos WHERE codigo='LINAME-0112';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Gentamicina Inyectable', 'LINAME-0113', '80 mg/2 mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '80 mg/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0113' AND pa.nombre='Gentamicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.50, 3.00, NOW() FROM productos WHERE codigo='LINAME-0113';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  25.00,13.00, NOW() FROM productos WHERE codigo='LINAME-0113';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Levofloxacino', 'LINAME-0114', '500 mg', 'Caja x 7 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0114' AND pa.nombre='Levofloxacino' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 8.00, 4.80, NOW() FROM productos WHERE codigo='LINAME-0114';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  52.00,31.00, NOW() FROM productos WHERE codigo='LINAME-0114';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metronidazol', 'LINAME-0115', '500 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0115' AND pa.nombre='Metronidazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.60, 0.30, NOW() FROM productos WHERE codigo='LINAME-0115';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  11.00, 5.50, NOW() FROM productos WHERE codigo='LINAME-0115';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metronidazol Infusión IV', 'LINAME-0116', '500 mg/100 mL', 'Bolsa x 100 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Solución para Infusión IV' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg/100 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0116' AND pa.nombre='Metronidazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 9.00, 5.00, NOW() FROM productos WHERE codigo='LINAME-0116';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Nitrofurantoína', 'LINAME-0117', '100 mg', 'Caja x 20 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0117' AND pa.nombre='Nitrofurantoína' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.80, 1.00, NOW() FROM productos WHERE codigo='LINAME-0117';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  34.00,19.00, NOW() FROM productos WHERE codigo='LINAME-0117';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Trimetoprim + Sulfametoxazol', 'LINAME-0118', '80 mg/400 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '80 mg/400 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0118' AND pa.nombre='Trimetoprim + Sulfametoxazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.50, 0.25, NOW() FROM productos WHERE codigo='LINAME-0118';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',   9.00, 4.50, NOW() FROM productos WHERE codigo='LINAME-0118';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Vancomicina Inyectable', 'LINAME-0119', '500 mg', 'Frasco ampolla (polvo)', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0119' AND pa.nombre='Vancomicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 45.00, 30.00, NOW() FROM productos WHERE codigo='LINAME-0119';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Amikacina Inyectable', 'LINAME-0120', '500 mg/2 mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0120' AND pa.nombre='Amikacina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0120';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  85.00, 52.00, NOW() FROM productos WHERE codigo='LINAME-0120';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Imipenem + Cilastatina Inyectable', 'LINAME-0121', '500 mg', 'Frasco ampolla (polvo)', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0121' AND pa.nombre='Imipenem + Cilastatina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 85.00, 55.00, NOW() FROM productos WHERE codigo='LINAME-0121';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Penicilina V', 'LINAME-0122', '500 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0122' AND pa.nombre='Penicilina V Potásica' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 0.80, 0.40, NOW() FROM productos WHERE codigo='LINAME-0122';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  14.00, 7.00, NOW() FROM productos WHERE codigo='LINAME-0122';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Bencilpenicilina Benzatínica Inyectable', 'LINAME-0123', '1.200.000 UI', 'Frasco ampolla (polvo)', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Polvo para Inyección' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1.200.000 UI' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0123' AND pa.nombre='Bencilpenicilina Benzatínica' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 12.00, 7.00, NOW() FROM productos WHERE codigo='LINAME-0123';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Linezolid', 'LINAME-0124', '600 mg', 'Caja x 10 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antibióticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '600 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0124' AND pa.nombre='Linezolid' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 65.00, 42.00, NOW() FROM productos WHERE codigo='LINAME-0124';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  600.00,390.00, NOW() FROM productos WHERE codigo='LINAME-0124';

COMMIT;

-- ==============================================================
-- CONTINÚA EN: 09-seed-productos-liname-part2.sql
-- (grupos 3 al 22: antifúngicos, cardiovascular, digestivo, etc.)
-- ==============================================================

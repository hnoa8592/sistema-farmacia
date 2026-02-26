-- ============================================================
-- 09-seed-productos-liname-part2c.sql
-- Lista Nacional de Medicamentos Esenciales - Bolivia 2022-2024
-- GRUPOS 16 al 22 (continuación final de part2b.sql)
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

-- ============================================================
-- GRUPO 16: SALUD REPRODUCTIVA
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Misoprostol', 'LINAME-0850', '200 mcg', 'Caja x 4 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Salud Reproductiva' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mcg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0850' AND pa.nombre='Misoprostol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 20.00, 12.50, NOW() FROM productos WHERE codigo='LINAME-0850';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  72.00, 45.00, NOW() FROM productos WHERE codigo='LINAME-0850';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Oxitocina', 'LINAME-0851', '10 UI/mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Salud Reproductiva' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 UI/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0851' AND pa.nombre='Oxitocina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 15.00, 9.30, NOW() FROM productos WHERE codigo='LINAME-0851';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  68.00, 42.00, NOW() FROM productos WHERE codigo='LINAME-0851';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Sulfato de Magnesio', 'LINAME-0852', '500 mg/mL', 'Ampolla x 10 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Salud Reproductiva' AND f.nombre='Ampolla' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0852' AND pa.nombre='Sulfato de Magnesio' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0852';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Levonorgestrel', 'LINAME-0853', '1.5 mg', 'Caja x 1 tableta', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Salud Reproductiva' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1.5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0853' AND pa.nombre='Levonorgestrel' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 38.00, 24.00, NOW() FROM productos WHERE codigo='LINAME-0853';

-- ============================================================
-- GRUPO 17: ANTIHISTAMÍNICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Loratadina', 'LINAME-0900', '10 mg', 'Caja x 10 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antihistamínicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0900' AND pa.nombre='Loratadina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0900';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  22.00, 13.50, NOW() FROM productos WHERE codigo='LINAME-0900';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Loratadina Jarabe', 'LINAME-0901', '5 mg/5 mL', 'Frasco x 100 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antihistamínicos' AND f.nombre='Jarabe' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg/5 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0901' AND pa.nombre='Loratadina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 13.50, NOW() FROM productos WHERE codigo='LINAME-0901';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Cetirizina', 'LINAME-0902', '10 mg', 'Caja x 10 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antihistamínicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0902' AND pa.nombre='Cetirizina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0902';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  36.00, 22.00, NOW() FROM productos WHERE codigo='LINAME-0902';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Clorfenamina', 'LINAME-0903', '4 mg', 'Caja x 20 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antihistamínicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '4 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0903' AND pa.nombre='Clorfenamina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.00, 0.60, NOW() FROM productos WHERE codigo='LINAME-0903';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0903';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Fexofenadina', 'LINAME-0904', '120 mg', 'Caja x 10 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antihistamínicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '120 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0904' AND pa.nombre='Fexofenadina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 7.50, 4.65, NOW() FROM productos WHERE codigo='LINAME-0904';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  68.00, 42.00, NOW() FROM productos WHERE codigo='LINAME-0904';

-- ============================================================
-- GRUPO 18: ANTICONVULSIVOS Y PSICOTRÓPICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Carbamazepina', 'LINAME-0950', '200 mg', 'Caja x 20 tabletas', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticonvulsivos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0950' AND pa.nombre='Carbamazepina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0950';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  72.00, 45.00, NOW() FROM productos WHERE codigo='LINAME-0950';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ácido Valproico LP', 'LINAME-0951', '500 mg', 'Caja x 30 tabletas liberación prolongada', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticonvulsivos' AND f.nombre='Tableta de Liberación Prolongada' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0951' AND pa.nombre='Ácido Valproico' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 7.50, 4.65, NOW() FROM productos WHERE codigo='LINAME-0951';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 205.00, 127.00, NOW() FROM productos WHERE codigo='LINAME-0951';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Levetiracetam', 'LINAME-0952', '500 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticonvulsivos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0952' AND pa.nombre='Levetiracetam' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 15.00, 9.30, NOW() FROM productos WHERE codigo='LINAME-0952';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 420.00, 260.00, NOW() FROM productos WHERE codigo='LINAME-0952';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Diazepam', 'LINAME-0953', '5 mg', 'Caja x 20 tabletas', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Psicotrópicos y Antidepresivos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0953' AND pa.nombre='Diazepam' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0953';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  36.00, 22.00, NOW() FROM productos WHERE codigo='LINAME-0953';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Clonazepam', 'LINAME-0954', '0.5 mg', 'Caja x 30 tabletas', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticonvulsivos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0954' AND pa.nombre='Clonazepam' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0954';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  68.00, 42.00, NOW() FROM productos WHERE codigo='LINAME-0954';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Fluoxetina', 'LINAME-0955', '20 mg', 'Caja x 14 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Psicotrópicos y Antidepresivos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0955' AND pa.nombre='Fluoxetina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.10, NOW() FROM productos WHERE codigo='LINAME-0955';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  64.00, 40.00, NOW() FROM productos WHERE codigo='LINAME-0955';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Sertralina', 'LINAME-0956', '50 mg', 'Caja x 14 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Psicotrópicos y Antidepresivos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0956' AND pa.nombre='Sertralina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 7.50, 4.65, NOW() FROM productos WHERE codigo='LINAME-0956';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  95.00, 59.00, NOW() FROM productos WHERE codigo='LINAME-0956';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Haloperidol', 'LINAME-0957', '5 mg', 'Caja x 20 tabletas', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antipsicóticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0957' AND pa.nombre='Haloperidol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0957';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  72.00, 45.00, NOW() FROM productos WHERE codigo='LINAME-0957';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Olanzapina', 'LINAME-0958', '5 mg', 'Caja x 14 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antipsicóticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0958' AND pa.nombre='Olanzapina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-0958';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 128.00, 79.00, NOW() FROM productos WHERE codigo='LINAME-0958';

-- ============================================================
-- GRUPO 19: MUSCULOESQUELÉTICO / ANTIGOTOSOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Alopurinol', 'LINAME-1000', '300 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antigotosos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '300 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1000' AND pa.nombre='Alopurinol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-1000';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  45.00, 28.00, NOW() FROM productos WHERE codigo='LINAME-1000';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Colchicina', 'LINAME-1001', '0.5 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antigotosos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1001' AND pa.nombre='Colchicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.50, 3.40, NOW() FROM productos WHERE codigo='LINAME-1001';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 100.00, 62.00, NOW() FROM productos WHERE codigo='LINAME-1001';

-- ============================================================
-- GRUPO 20: SUEROS Y ELECTROLITOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Solución Glucosada 5%', 'LINAME-1050', '5%', 'Bolsa x 1.000 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Sueros y Electrolitos' AND f.nombre='Solución para Infusión IV' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 g/L' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1050' AND pa.nombre='Glucosa' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 13.50, NOW() FROM productos WHERE codigo='LINAME-1050';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Solución Salina 0.9%', 'LINAME-1051', '0.9% NaCl', 'Bolsa x 1.000 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Sueros y Electrolitos' AND f.nombre='Solución para Infusión IV' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '9 g/L' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1051' AND pa.nombre='Cloruro de Sodio' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-1051';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ringer Lactato', 'LINAME-1052', 'NaCl 6 g + KCl 0.4 g + CaCl2 0.27 g + Lactato 3.1 g/L', 'Bolsa x 1.000 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Sueros y Electrolitos' AND f.nombre='Solución para Infusión IV' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, 'solución polielectrolítica' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1052' AND pa.nombre='Ringer Lactato' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 13.50, NOW() FROM productos WHERE codigo='LINAME-1052';

-- ============================================================
-- GRUPO 21: ANESTÉSICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Lidocaína Inyectable', 'LINAME-1100', '2%', 'Ampolla x 20 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anestésicos' AND f.nombre='Ampolla' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '2%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1100' AND pa.nombre='Lidocaína' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-1100';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Bupivacaína Inyectable', 'LINAME-1101', '0.5%', 'Ampolla x 20 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anestésicos' AND f.nombre='Ampolla' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.5%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1101' AND pa.nombre='Bupivacaína' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 15.00, 9.30, NOW() FROM productos WHERE codigo='LINAME-1101';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Midazolam Inyectable', 'LINAME-1102', '5 mg/mL', 'Ampolla x 3 mL', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anestésicos' AND f.nombre='Ampolla' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1102' AND pa.nombre='Midazolam' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 38.00, 24.00, NOW() FROM productos WHERE codigo='LINAME-1102';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Cetamina Inyectable', 'LINAME-1103', '500 mg/10 mL', 'Vial x 10 mL', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anestésicos' AND f.nombre='Ampolla' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1103' AND pa.nombre='Cetamina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 95.00, 59.00, NOW() FROM productos WHERE codigo='LINAME-1103';

-- ============================================================
-- GRUPO 22: ONCOLÓGICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Tamoxifeno', 'LINAME-1150', '20 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Oncológicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1150' AND pa.nombre='Tamoxifeno' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.50, 4.00, NOW() FROM productos WHERE codigo='LINAME-1150';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 178.00, 110.00, NOW() FROM productos WHERE codigo='LINAME-1150';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metotrexato', 'LINAME-1151', '2.5 mg', 'Caja x 20 tabletas', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Oncológicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '2.5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1151' AND pa.nombre='Metotrexato' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.50, 3.40, NOW() FROM productos WHERE codigo='LINAME-1151';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 100.00, 62.00, NOW() FROM productos WHERE codigo='LINAME-1151';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ciclofosfamida', 'LINAME-1152', '50 mg', 'Caja x 20 tabletas', true, true,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Oncológicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-1152' AND pa.nombre='Ciclofosfamida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.20, NOW() FROM productos WHERE codigo='LINAME-1152';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 180.00, 112.00, NOW() FROM productos WHERE codigo='LINAME-1152';

COMMIT;

-- ==============================================================
-- FIN DEL SEED LINAME Bolivia 2022-2024
-- Resumen total de archivos:
--   08-seed-productos-liname.sql        → Catálogos + Grupos 1-2  (42 productos)
--   09-seed-productos-liname-part2.sql  → Grupos 3-8              (36 productos)
--   09-seed-productos-liname-part2b.sql → Grupos 9-15             (40 productos)
--   09-seed-productos-liname-part2c.sql → Grupos 16-22            (23 productos)
--   TOTAL: ~141 productos del LINAME Bolivia 2022-2024
-- ==============================================================

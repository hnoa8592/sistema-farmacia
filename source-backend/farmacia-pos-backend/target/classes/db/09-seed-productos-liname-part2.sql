-- ============================================================
-- 09-seed-productos-liname-part2.sql
-- Lista Nacional de Medicamentos Esenciales - Bolivia 2022-2024
-- GRUPOS 3 al 22 (continuación de 08-seed-productos-liname.sql)
-- ============================================================
-- NOTA: Ejecutar DENTRO del schema del tenant correspondiente.
-- Ejemplo: SET search_path TO farmacia_demo, public;
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

-- ============================================================
-- GRUPO 3: ANTIFÚNGICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Fluconazol', 'LINAME-0200', '150 mg', 'Caja x 1 cápsula', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '150 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0200' AND pa.nombre='Fluconazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 13.00, 8.00, NOW() FROM productos WHERE codigo='LINAME-0200';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  13.00, 8.00, NOW() FROM productos WHERE codigo='LINAME-0200';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Fluconazol IV', 'LINAME-0201', '200 mg/100 mL', 'Frasco x 100 mL', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Solución para Infusión IV' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg/100 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0201' AND pa.nombre='Fluconazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 52.00, 33.00, NOW() FROM productos WHERE codigo='LINAME-0201';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Clotrimazol Crema', 'LINAME-0202', '1%', 'Tubo x 20 g', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Crema' AND v.nombre='Tópica'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1%' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0202' AND pa.nombre='Clotrimazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 13.00, NOW() FROM productos WHERE codigo='LINAME-0202';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Clotrimazol Óvulo Vaginal', 'LINAME-0203', '100 mg', 'Caja x 6 óvulos', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Óvulo Vaginal' AND v.nombre='Vaginal'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0203' AND pa.nombre='Clotrimazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.00, NOW() FROM productos WHERE codigo='LINAME-0203';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  55.00, 34.00, NOW() FROM productos WHERE codigo='LINAME-0203';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Itraconazol', 'LINAME-0204', '100 mg', 'Caja x 15 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0204' AND pa.nombre='Itraconazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0204';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 250.00,155.00, NOW() FROM productos WHERE codigo='LINAME-0204';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ketoconazol', 'LINAME-0205', '200 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0205' AND pa.nombre='Ketoconazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.00, NOW() FROM productos WHERE codigo='LINAME-0205';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  90.00, 55.00, NOW() FROM productos WHERE codigo='LINAME-0205';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Nistatina Suspensión', 'LINAME-0206', '100.000 UI/mL', 'Frasco x 60 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Suspensión' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100.000 UI/mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0206' AND pa.nombre='Nistatina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 22.00, 14.00, NOW() FROM productos WHERE codigo='LINAME-0206';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Anfotericina B', 'LINAME-0207', '50 mg', 'Vial polvo liofilizado', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antifúngicos' AND f.nombre='Polvo para Inyección' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0207' AND pa.nombre='Anfotericina B' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 215.00, 138.00, NOW() FROM productos WHERE codigo='LINAME-0207';

-- ============================================================
-- GRUPO 4: ANTIVIRALES
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Aciclovir', 'LINAME-0250', '200 mg', 'Caja x 25 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antivirales' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '200 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0250' AND pa.nombre='Aciclovir' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0250';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  90.00, 56.00, NOW() FROM productos WHERE codigo='LINAME-0250';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Oseltamivir', 'LINAME-0251', '75 mg', 'Caja x 10 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antivirales' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '75 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0251' AND pa.nombre='Oseltamivir' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 42.00, 27.00, NOW() FROM productos WHERE codigo='LINAME-0251';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 400.00, 250.00, NOW() FROM productos WHERE codigo='LINAME-0251';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Lamivudina', 'LINAME-0252', '150 mg', 'Caja x 60 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antivirales' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '150 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0252' AND pa.nombre='Lamivudina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.50, NOW() FROM productos WHERE codigo='LINAME-0252';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 550.00, 350.00, NOW() FROM productos WHERE codigo='LINAME-0252';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Tenofovir + Emtricitabina', 'LINAME-0253', '300 mg/200 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antivirales' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '300 mg/200 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0253' AND pa.nombre='Tenofovir + Emtricitabina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0253';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 900.00, 570.00, NOW() FROM productos WHERE codigo='LINAME-0253';

-- ============================================================
-- GRUPO 5: ANTIPARASITARIOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Albendazol', 'LINAME-0300', '400 mg', 'Caja x 1 tableta masticable', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiparasitarios' AND f.nombre='Tableta Masticable' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '400 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0300' AND pa.nombre='Albendazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.50, 2.80, NOW() FROM productos WHERE codigo='LINAME-0300';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Albendazol Suspensión', 'LINAME-0301', '400 mg/10 mL', 'Frasco x 20 mL', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiparasitarios' AND f.nombre='Suspensión' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '400 mg/10 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0301' AND pa.nombre='Albendazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 17.00, 10.00, NOW() FROM productos WHERE codigo='LINAME-0301';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ivermectina', 'LINAME-0302', '6 mg', 'Caja x 2 tabletas', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiparasitarios' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '6 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0302' AND pa.nombre='Ivermectina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 10.00, 6.00, NOW() FROM productos WHERE codigo='LINAME-0302';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  20.00, 12.00, NOW() FROM productos WHERE codigo='LINAME-0302';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Mebendazol', 'LINAME-0303', '100 mg', 'Caja x 6 tabletas masticables', false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiparasitarios' AND f.nombre='Tableta Masticable' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0303' AND pa.nombre='Mebendazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0303';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  11.00, 6.50, NOW() FROM productos WHERE codigo='LINAME-0303';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Praziquantel', 'LINAME-0304', '600 mg', 'Caja x 6 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiparasitarios' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '600 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0304' AND pa.nombre='Praziquantel' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 15.00, 9.50, NOW() FROM productos WHERE codigo='LINAME-0304';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  80.00, 50.00, NOW() FROM productos WHERE codigo='LINAME-0304';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Tinidazol', 'LINAME-0305', '500 mg', 'Caja x 4 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antiparasitarios' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0305' AND pa.nombre='Tinidazol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.00, NOW() FROM productos WHERE codigo='LINAME-0305';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0305';

-- ============================================================
-- GRUPO 6: ANTITUBERCULOSOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Isoniazida', 'LINAME-0350', '100 mg', 'Caja x 100 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antituberculosos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0350' AND pa.nombre='Isoniazida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0350';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 180.00, 110.00, NOW() FROM productos WHERE codigo='LINAME-0350';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Rifampicina', 'LINAME-0351', '300 mg', 'Caja x 100 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antituberculosos' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '300 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0351' AND pa.nombre='Rifampicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.50, 4.00, NOW() FROM productos WHERE codigo='LINAME-0351';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 600.00, 375.00, NOW() FROM productos WHERE codigo='LINAME-0351';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Pirazinamida', 'LINAME-0352', '500 mg', 'Caja x 100 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antituberculosos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0352' AND pa.nombre='Pirazinamida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0352';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 380.00, 235.00, NOW() FROM productos WHERE codigo='LINAME-0352';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Etambutol', 'LINAME-0353', '400 mg', 'Caja x 100 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antituberculosos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '400 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0353' AND pa.nombre='Etambutol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.20, NOW() FROM productos WHERE codigo='LINAME-0353';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 460.00, 285.00, NOW() FROM productos WHERE codigo='LINAME-0353';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Estreptomicina', 'LINAME-0354', '1 g', 'Vial polvo para inyección', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antituberculosos' AND f.nombre='Polvo para Inyección' AND v.nombre='Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '1 g' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0354' AND pa.nombre='Estreptomicina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0354';

-- ============================================================
-- GRUPO 7: CARDIOVASCULAR
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Enalapril', 'LINAME-0400', '10 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0400' AND pa.nombre='Enalapril' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0400';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  36.00, 22.00, NOW() FROM productos WHERE codigo='LINAME-0400';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Amlodipino 5 mg', 'LINAME-0401', '5 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0401' AND pa.nombre='Amlodipino' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.00, 1.20, NOW() FROM productos WHERE codigo='LINAME-0401';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  55.00, 34.00, NOW() FROM productos WHERE codigo='LINAME-0401';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Amlodipino 10 mg', 'LINAME-0402', '10 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0402' AND pa.nombre='Amlodipino' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 3.00, 1.80, NOW() FROM productos WHERE codigo='LINAME-0402';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  82.00, 51.00, NOW() FROM productos WHERE codigo='LINAME-0402';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Losartan', 'LINAME-0403', '50 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0403' AND pa.nombre='Losartan' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0403';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  68.00, 42.00, NOW() FROM productos WHERE codigo='LINAME-0403';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Atenolol', 'LINAME-0404', '50 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0404' AND pa.nombre='Atenolol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.50, 0.90, NOW() FROM productos WHERE codigo='LINAME-0404';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  40.00, 24.00, NOW() FROM productos WHERE codigo='LINAME-0404';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Captopril', 'LINAME-0405', '25 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '25 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0405' AND pa.nombre='Captopril' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.50, 0.90, NOW() FROM productos WHERE codigo='LINAME-0405';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  28.00, 17.00, NOW() FROM productos WHERE codigo='LINAME-0405';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Carvedilol', 'LINAME-0406', '6.25 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '6.25 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0406' AND pa.nombre='Carvedilol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0406';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  72.00, 45.00, NOW() FROM productos WHERE codigo='LINAME-0406';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Metoprolol', 'LINAME-0407', '100 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0407' AND pa.nombre='Metoprolol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0407';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  46.00, 28.00, NOW() FROM productos WHERE codigo='LINAME-0407';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Furosemida', 'LINAME-0408', '40 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '40 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0408' AND pa.nombre='Furosemida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.20, 0.75, NOW() FROM productos WHERE codigo='LINAME-0408';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  22.00, 13.00, NOW() FROM productos WHERE codigo='LINAME-0408';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Furosemida Inyectable', 'LINAME-0409', '20 mg/2 mL', 'Caja x 5 ampollas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Ampolla' AND v.nombre='Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg/2 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0409' AND pa.nombre='Furosemida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.50, 4.00, NOW() FROM productos WHERE codigo='LINAME-0409';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  30.00, 18.00, NOW() FROM productos WHERE codigo='LINAME-0409';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Hidroclorotiazida', 'LINAME-0410', '25 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '25 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0410' AND pa.nombre='Hidroclorotiazida' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.00, 0.60, NOW() FROM productos WHERE codigo='LINAME-0410';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  18.00, 11.00, NOW() FROM productos WHERE codigo='LINAME-0410';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Propranolol', 'LINAME-0411', '40 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '40 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0411' AND pa.nombre='Propranolol' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 1.20, 0.75, NOW() FROM productos WHERE codigo='LINAME-0411';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  32.00, 20.00, NOW() FROM productos WHERE codigo='LINAME-0411';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Nifedipino LP', 'LINAME-0412', '30 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta de Liberación Prolongada' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '30 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0412' AND pa.nombre='Nifedipino' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.50, 4.00, NOW() FROM productos WHERE codigo='LINAME-0412';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 180.00, 112.00, NOW() FROM productos WHERE codigo='LINAME-0412';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Digoxina', 'LINAME-0413', '0.25 mg', 'Caja x 20 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.25 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0413' AND pa.nombre='Digoxina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0413';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  45.00, 28.00, NOW() FROM productos WHERE codigo='LINAME-0413';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Nitroglicerina Sublingual', 'LINAME-0414', '0.5 mg', 'Frasco x 25 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Tableta Sublingual' AND v.nombre='Sublingual'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '0.5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0414' AND pa.nombre='Nitroglicerina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 2.50, 1.55, NOW() FROM productos WHERE codigo='LINAME-0414';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'FRASCO', 58.00, 36.00, NOW() FROM productos WHERE codigo='LINAME-0414';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Ramipril', 'LINAME-0415', '5 mg', 'Caja x 28 cápsulas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Cardiovascular' AND f.nombre='Cápsula' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0415' AND pa.nombre='Ramipril' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 5.00, 3.10, NOW() FROM productos WHERE codigo='LINAME-0415';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 130.00, 81.00, NOW() FROM productos WHERE codigo='LINAME-0415';

-- ============================================================
-- GRUPO 8: ANTICOAGULANTES Y ANTILIPÍDICOS
-- ============================================================

INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Warfarina', 'LINAME-0450', '5 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticoagulantes y Antitrombóticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0450' AND pa.nombre='Warfarina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0450';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 110.00, 68.00, NOW() FROM productos WHERE codigo='LINAME-0450';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Clopidogrel', 'LINAME-0451', '75 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticoagulantes y Antitrombóticos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '75 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0451' AND pa.nombre='Clopidogrel' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.50, 4.00, NOW() FROM productos WHERE codigo='LINAME-0451';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 180.00, 112.00, NOW() FROM productos WHERE codigo='LINAME-0451';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Enoxaparina', 'LINAME-0452', '40 mg/0.4 mL', 'Caja x 2 jeringas prellenadas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Anticoagulantes y Antitrombóticos' AND f.nombre='Ampolla' AND v.nombre='Subcutánea'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '40 mg/0.4 mL' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0452' AND pa.nombre='Enoxaparina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 95.00, 60.00, NOW() FROM productos WHERE codigo='LINAME-0452';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 180.00, 112.00, NOW() FROM productos WHERE codigo='LINAME-0452';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Atorvastatina 20 mg', 'LINAME-0453', '20 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antilipídicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0453' AND pa.nombre='Atorvastatina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 4.00, 2.50, NOW() FROM productos WHERE codigo='LINAME-0453';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 110.00, 68.00, NOW() FROM productos WHERE codigo='LINAME-0453';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Atorvastatina 40 mg', 'LINAME-0454', '40 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antilipídicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '40 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0454' AND pa.nombre='Atorvastatina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.50, 4.00, NOW() FROM productos WHERE codigo='LINAME-0454';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 175.00, 108.00, NOW() FROM productos WHERE codigo='LINAME-0454';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Simvastatina', 'LINAME-0455', '20 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antilipídicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0455' AND pa.nombre='Simvastatina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 3.00, 1.85, NOW() FROM productos WHERE codigo='LINAME-0455';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA',  82.00, 51.00, NOW() FROM productos WHERE codigo='LINAME-0455';

-- ------------------------------------------------------------
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, controlado, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT 'Rosuvastatina', 'LINAME-0456', '10 mg', 'Caja x 30 tabletas', true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre='Antilipídicos' AND f.nombre='Tableta' AND v.nombre='Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg' FROM productos p, principios_activos pa
WHERE p.codigo='LINAME-0456' AND pa.nombre='Rosuvastatina' ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'UNIDAD', 6.50, 4.00, NOW() FROM productos WHERE codigo='LINAME-0456';
INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT id, 'CAJA', 178.00, 110.00, NOW() FROM productos WHERE codigo='LINAME-0456';

COMMIT;

-- ==============================================================
-- CONTINÚA EN: 09-seed-productos-liname-part2b.sql
-- (grupos 9 al 22: broncodilatadores, digestivo, antidiabéticos, etc.)
-- ==============================================================

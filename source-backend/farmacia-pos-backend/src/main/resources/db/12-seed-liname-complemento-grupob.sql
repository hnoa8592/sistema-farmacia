-- ============================================================
-- 12-seed-liname-complemento-grupo-b.sql
-- Complemento LINAME - Grupo B: Sangre y órganos formadores de sangre
-- Reemplazar {SCHEMA} con el schemaName del tenant
-- ============================================================

SET search_path TO {SCHEMA}, public;

BEGIN;

-- ============================================================
-- B01 - Anticoagulantes y Antitrombóticos
-- ============================================================

INSERT INTO principios_activos (nombre) VALUES
('Ácido Tranexámico'),
('Fitomenadiona'),
('Dabigatrán'),
('Rivaroxabán'),
('Apixabán')
ON CONFLICT (nombre) DO NOTHING;

-- Ácido Tranexámico
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Ácido Tranexámico',
       'LINAME-1160',
       '500 mg',
       'Caja x 20 tabletas',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Anticoagulantes y Antitrombóticos'
  AND f.nombre = 'Tableta'
  AND v.nombre = 'Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1160'
  AND pa.nombre = 'Ácido Tranexámico'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 4.50, 2.80, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1160'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 82.00, 50.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1160'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'CAJA'
  );

-- Ácido Tranexámico Inyectable
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Ácido Tranexámico Inyectable',
       'LINAME-1161',
       '500 mg/5 mL',
       'Caja x 5 ampollas',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Anticoagulantes y Antitrombóticos'
  AND f.nombre = 'Ampolla'
  AND v.nombre = 'Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500 mg/5 mL'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1161'
  AND pa.nombre = 'Ácido Tranexámico'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 15.00, 9.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1161'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

-- Fitomenadiona
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Fitomenadiona Inyectable',
       'LINAME-1162',
       '10 mg/mL',
       'Caja x 5 ampollas',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Anticoagulantes y Antitrombóticos'
  AND f.nombre = 'Ampolla'
  AND v.nombre = 'Intramuscular'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '10 mg/mL'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1162'
  AND pa.nombre = 'Fitomenadiona'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 12.00, 7.20, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1162'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

-- Dabigatrán
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Dabigatrán',
       'LINAME-1163',
       '110 mg',
       'Caja x 30 cápsulas',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Anticoagulantes y Antitrombóticos'
  AND f.nombre = 'Cápsula'
  AND v.nombre = 'Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '110 mg'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1163'
  AND pa.nombre = 'Dabigatrán'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 12.00, 7.50, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1163'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 330.00, 205.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1163'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'CAJA'
  );

-- Rivaroxabán
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Rivaroxabán',
       'LINAME-1164',
       '20 mg',
       'Caja x 30 tabletas',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Anticoagulantes y Antitrombóticos'
  AND f.nombre = 'Tableta'
  AND v.nombre = 'Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '20 mg'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1164'
  AND pa.nombre = 'Rivaroxabán'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 15.00, 9.50, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1164'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 420.00, 265.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1164'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'CAJA'
  );

-- Apixabán
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Apixabán',
       'LINAME-1165',
       '5 mg',
       'Caja x 30 tabletas',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Anticoagulantes y Antitrombóticos'
  AND f.nombre = 'Tableta'
  AND v.nombre = 'Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '5 mg'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1165'
  AND pa.nombre = 'Apixabán'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 16.00, 10.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1165'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 450.00, 280.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1165'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'CAJA'
  );

-- ============================================================
-- B03 - Antianémicos
-- ============================================================

INSERT INTO principios_activos (nombre) VALUES
('Hierro Sacarato'),
('Eritropoyetina'),
('Ácido Fólico + Hierro')
ON CONFLICT (nombre) DO NOTHING;

-- Hierro Polimaltosado Gotas
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Hierro Polimaltosado Gotas',
       'LINAME-1166',
       '50 mg/mL',
       'Frasco x 30 mL',
       false, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Antianémicos'
  AND f.nombre = 'Gotas'
  AND v.nombre = 'Oral'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '50 mg/mL'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1166'
  AND pa.nombre = 'Hierro Polimaltosado'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 24.00, 15.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1166'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

-- Hierro Sacarato Inyectable
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Hierro Sacarato Inyectable',
       'LINAME-1167',
       '100 mg/5 mL',
       'Caja x 5 ampollas',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Antianémicos'
  AND f.nombre = 'Ampolla'
  AND v.nombre = 'Intravenosa'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '100 mg/5 mL'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1167'
  AND pa.nombre = 'Hierro Sacarato'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 35.00, 22.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1167'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

-- Eritropoyetina
INSERT INTO productos (
    nombre, codigo, concentracion, presentacion,
    requiere_receta, controlado,
    categoria_id, forma_farmaceutica_id, via_administracion_id
)
SELECT 'Eritropoyetina',
       'LINAME-1168',
       '4000 UI/mL',
       'Jeringa prellenada',
       true, false,
       c.id, f.id, v.id
FROM categorias_terapeuticas c, formas_farmaceuticas f, vias_administracion v
WHERE c.nombre = 'Antianémicos'
  AND f.nombre = 'Ampolla'
  AND v.nombre = 'Subcutánea'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '4000 UI/mL'
FROM productos p, principios_activos pa
WHERE p.codigo = 'LINAME-1168'
  AND pa.nombre = 'Eritropoyetina'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 180.00, 115.00, NOW()
FROM productos p
WHERE p.codigo = 'LINAME-1168'
  AND NOT EXISTS (
      SELECT 1 FROM producto_precios pp
      WHERE pp.producto_id = p.id AND pp.tipo_precio = 'UNIDAD'
  );

COMMIT;

SET search_path TO public;
-- 07-seed-data-demo.sql — Datos de prueba para farmacia_demo
-- Ejecutar después de inicializar el schema farmacia_demo

SET search_path TO farmacia_demo, public;

-- ============================================================
-- Sucursales
-- ============================================================
INSERT INTO sucursales (nombre, direccion, telefono, es_matriz) VALUES
('Farmacia Central', 'Av. Principal 123, Lima', '01-234-5678', true),
('Sucursal Norte',   'Av. Norte 456, Lima',     '01-987-6543', false)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Laboratorios
-- ============================================================
INSERT INTO laboratorios (nombre, pais) VALUES
('BAYER', 'Alemania'),
('PFIZER', 'Estados Unidos'),
('GENFAR', 'Colombia')
ON CONFLICT DO NOTHING;

-- ============================================================
-- Usuarios (passwords: BCrypt de Admin1234, Super1234, Cajero1234)
-- ============================================================
INSERT INTO usuarios (nombre, email, password) VALUES
('Administrador Demo', 'admin@demo.com',
 '$2a$10$g42ZeZ7XP2z7IaGY6qUdYO81xPkOCqle8l1EqYL.4RlVKkqcfJhuu'),
('Supervisor Demo', 'supervisor@demo.com',
 '$2a$10$g42ZeZ7XP2z7IaGY6qUdYO81xPkOCqle8l1EqYL.4RlVKkqcfJhuu'),
('Cajero Demo', 'cajero@demo.com',
 '$2a$10$g42ZeZ7XP2z7IaGY6qUdYO81xPkOCqle8l1EqYL.4RlVKkqcfJhuu')
ON CONFLICT (email) DO NOTHING;

-- Asignar perfiles
INSERT INTO usuario_perfiles (usuario_id, perfil_id)
SELECT u.id, p.id FROM usuarios u, perfiles p
WHERE u.email = 'admin@demo.com' AND p.nombre = 'ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO usuario_perfiles (usuario_id, perfil_id)
SELECT u.id, p.id FROM usuarios u, perfiles p
WHERE u.email = 'supervisor@demo.com' AND p.nombre = 'SUPERVISOR'
ON CONFLICT DO NOTHING;

INSERT INTO usuario_perfiles (usuario_id, perfil_id)
SELECT u.id, p.id FROM usuarios u, perfiles p
WHERE u.email = 'cajero@demo.com' AND p.nombre = 'CAJERO'
ON CONFLICT DO NOTHING;

-- ============================================================
-- Productos con lotes, precios e inventario
-- ============================================================

-- 1. Paracetamol 500mg
INSERT INTO productos (nombre, codigo, concentracion, presentacion, categoria_id, forma_farmaceutica_id)
SELECT 'Paracetamol 500mg', 'PARA-500', '500mg', 'Caja x 20 tabletas',
       c.id, f.id
FROM categorias_terapeuticas c, formas_farmaceuticas f
WHERE c.nombre = 'Analgésicos y Antipiréticos' AND f.nombre = 'Tableta'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT p.id, pa.id, '500mg'
FROM productos p, principios_activos pa
WHERE p.codigo = 'PARA-500' AND pa.nombre = 'Paracetamol'
ON CONFLICT DO NOTHING;

INSERT INTO producto_lotes (producto_id, laboratorio_id, numero_lote, fecha_vencimiento, cantidad_inicial)
SELECT p.id, l.id, 'LOT-PARA-001', '2026-12-31', 200
FROM productos p, laboratorios l
WHERE p.codigo = 'PARA-500' AND l.nombre = 'BAYER'
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 150, 20
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-PARA-001' AND s.es_matriz = true
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 50, 10
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-PARA-001' AND s.es_matriz = false
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 0.50, 0.30, NOW()
FROM productos p WHERE p.codigo = 'PARA-500'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 8.50, 5.00, NOW()
FROM productos p WHERE p.codigo = 'PARA-500'
ON CONFLICT DO NOTHING;

-- 2. Ibuprofeno 400mg
INSERT INTO productos (nombre, codigo, concentracion, presentacion, categoria_id, forma_farmaceutica_id)
SELECT 'Ibuprofeno 400mg', 'IBU-400', '400mg', 'Caja x 10 tabletas',
       c.id, f.id
FROM categorias_terapeuticas c, formas_farmaceuticas f
WHERE c.nombre = 'Antiinflamatorios' AND f.nombre = 'Tableta'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_lotes (producto_id, laboratorio_id, numero_lote, fecha_vencimiento, cantidad_inicial)
SELECT p.id, l.id, 'LOT-IBU-001', '2026-08-31', 100
FROM productos p, laboratorios l
WHERE p.codigo = 'IBU-400' AND l.nombre = 'PFIZER'
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 80, 10
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-IBU-001' AND s.es_matriz = true
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 20, 5
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-IBU-001' AND s.es_matriz = false
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 0.80, 0.50, NOW()
FROM productos p WHERE p.codigo = 'IBU-400'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 7.00, 4.50, NOW()
FROM productos p WHERE p.codigo = 'IBU-400'
ON CONFLICT DO NOTHING;

-- 3. Amoxicilina 500mg
INSERT INTO productos (nombre, codigo, concentracion, presentacion, requiere_receta, categoria_id, forma_farmaceutica_id)
SELECT 'Amoxicilina 500mg', 'AMOX-500', '500mg', 'Caja x 12 cápsulas', true,
       c.id, f.id
FROM categorias_terapeuticas c, formas_farmaceuticas f
WHERE c.nombre = 'Antibióticos' AND f.nombre = 'Cápsula'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_lotes (producto_id, laboratorio_id, numero_lote, fecha_vencimiento, cantidad_inicial)
SELECT p.id, l.id, 'LOT-AMOX-001', '2025-11-30', 60
FROM productos p, laboratorios l
WHERE p.codigo = 'AMOX-500' AND l.nombre = 'GENFAR'
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 48, 10
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-AMOX-001' AND s.es_matriz = true
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 12, 5
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-AMOX-001' AND s.es_matriz = false
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 1.20, 0.80, NOW()
FROM productos p WHERE p.codigo = 'AMOX-500'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 12.00, 8.50, NOW()
FROM productos p WHERE p.codigo = 'AMOX-500'
ON CONFLICT DO NOTHING;

-- 4. Loratadina 10mg
INSERT INTO productos (nombre, codigo, concentracion, presentacion, categoria_id, forma_farmaceutica_id)
SELECT 'Loratadina 10mg', 'LORA-10', '10mg', 'Caja x 10 tabletas',
       c.id, f.id
FROM categorias_terapeuticas c, formas_farmaceuticas f
WHERE c.nombre = 'Antihistamínicos' AND f.nombre = 'Tableta'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_lotes (producto_id, laboratorio_id, numero_lote, fecha_vencimiento, cantidad_inicial)
SELECT p.id, l.id, 'LOT-LORA-001', '2027-03-31', 120
FROM productos p, laboratorios l
WHERE p.codigo = 'LORA-10' AND l.nombre = 'BAYER'
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 90, 15
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-LORA-001' AND s.es_matriz = true
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 30, 5
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-LORA-001' AND s.es_matriz = false
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 0.90, 0.55, NOW()
FROM productos p WHERE p.codigo = 'LORA-10'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 8.00, 5.00, NOW()
FROM productos p WHERE p.codigo = 'LORA-10'
ON CONFLICT DO NOTHING;

-- 5. Omeprazol 20mg
INSERT INTO productos (nombre, codigo, concentracion, presentacion, categoria_id, forma_farmaceutica_id)
SELECT 'Omeprazol 20mg', 'OMEP-20', '20mg', 'Caja x 14 cápsulas',
       c.id, f.id
FROM categorias_terapeuticas c, formas_farmaceuticas f
WHERE c.nombre = 'Antiácidos y Gastroprotectores' AND f.nombre = 'Cápsula'
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO producto_lotes (producto_id, laboratorio_id, numero_lote, fecha_vencimiento, cantidad_inicial)
SELECT p.id, l.id, 'LOT-OMEP-001', '2026-06-30', 84
FROM productos p, laboratorios l
WHERE p.codigo = 'OMEP-20' AND l.nombre = 'PFIZER'
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 70, 14
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-OMEP-001' AND s.es_matriz = true
ON CONFLICT DO NOTHING;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo)
SELECT pl.id, s.id, 14, 7
FROM producto_lotes pl, sucursales s
WHERE pl.numero_lote = 'LOT-OMEP-001' AND s.es_matriz = false
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'UNIDAD', 0.70, 0.45, NOW()
FROM productos p WHERE p.codigo = 'OMEP-20'
ON CONFLICT DO NOTHING;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde)
SELECT p.id, 'CAJA', 9.00, 5.80, NOW()
FROM productos p WHERE p.codigo = 'OMEP-20'
ON CONFLICT DO NOTHING;

SET search_path TO public;

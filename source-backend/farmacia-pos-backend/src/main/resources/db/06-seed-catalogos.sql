-- 06-seed-catalogos.sql — Catálogos farmacéuticos iniciales
INSERT INTO categorias_terapeuticas (nombre) VALUES
('Analgésicos y Antipiréticos'),
('Antibióticos'),
('Antiinflamatorios'),
('Antihistamínicos'),
('Antihipertensivos'),
('Antidiabéticos'),
('Vitaminas y Suplementos'),
('Antiácidos y Gastroprotectores'),
('Antiparasitarios'),
('Dermatológicos')
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO formas_farmaceuticas (nombre) VALUES
('Tableta'),
('Cápsula'),
('Jarabe'),
('Suspensión'),
('Crema'),
('Pomada'),
('Ampolla'),
('Solución oral'),
('Parche transdérmico'),
('Supositorio')
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO vias_administracion (nombre) VALUES
('Oral'),
('Tópica'),
('Intravenosa'),
('Intramuscular'),
('Subcutánea'),
('Oftálmica'),
('Ótica'),
('Rectal')
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO principios_activos (nombre) VALUES
('Paracetamol'),
('Ibuprofeno'),
('Amoxicilina'),
('Azitromicina'),
('Diclofenaco'),
('Loratadina'),
('Enalapril'),
('Metformina'),
('Omeprazol'),
('Ranitidina'),
('Vitamina C'),
('Calcio + Vitamina D'),
('Albendazol'),
('Clotrimazol'),
('Dexametasona')
ON CONFLICT (nombre) DO NOTHING;

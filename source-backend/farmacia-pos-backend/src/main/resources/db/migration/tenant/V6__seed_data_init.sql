SET search_path TO {SCHEMA}, public;

INSERT INTO usuarios (nombre, email, password) VALUES
('Administrador Demo', 'admin@demo.com',
 '$2a$10$g42ZeZ7XP2z7IaGY6qUdYO81xPkOCqle8l1EqYL.4RlVKkqcfJhuu')
ON CONFLICT (email) DO NOTHING;

INSERT INTO usuario_perfiles (usuario_id, perfil_id)
SELECT u.id, p.id FROM usuarios u, perfiles p
WHERE u.email = 'admin@demo.com' AND p.nombre = 'ADMIN'
ON CONFLICT DO NOTHING;

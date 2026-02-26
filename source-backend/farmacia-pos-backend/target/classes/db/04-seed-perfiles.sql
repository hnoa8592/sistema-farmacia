SET search_path TO {SCHEMA}, public;
-- 04-seed-perfiles.sql — Perfiles del sistema
DO $$
DECLARE
    v_admin_id    UUID;
    v_super_id    UUID;
    v_cajero_id   UUID;
BEGIN
    -- ADMIN
    INSERT INTO perfiles (nombre, descripcion)
    VALUES ('ADMIN', 'Administrador con acceso completo')
    ON CONFLICT DO NOTHING;
    SELECT id INTO v_admin_id FROM perfiles WHERE nombre = 'ADMIN';

    INSERT INTO perfil_recursos (perfil_id, recurso_id)
    SELECT v_admin_id, id FROM recursos
    ON CONFLICT DO NOTHING;

    -- SUPERVISOR
    INSERT INTO perfiles (nombre, descripcion)
    VALUES ('SUPERVISOR', 'Supervisor con acceso a ventas, inventario y reportes')
    ON CONFLICT DO NOTHING;
    SELECT id INTO v_super_id FROM perfiles WHERE nombre = 'SUPERVISOR';

    INSERT INTO perfil_recursos (perfil_id, recurso_id)
    SELECT v_super_id, id FROM recursos WHERE nombre IN (
        'ventas:ver','ventas:crear','ventas:anular','ventas:descuento',
        'inventario:ver','inventario:crear','inventario:editar',
        'inventario:movimientos','inventario:lotes','inventario:precios',
        'reportes:ventas','reportes:inventario','reportes:stock',
        'laboratorios:ver','sucursales:ver','catalogos:ver',
        'principios-activos:ver','usuarios:ver','auditoria:ver','parametros:ver'
    ) ON CONFLICT DO NOTHING;

    -- CAJERO
    INSERT INTO perfiles (nombre, descripcion)
    VALUES ('CAJERO', 'Cajero con acceso básico de ventas')
    ON CONFLICT DO NOTHING;
    SELECT id INTO v_cajero_id FROM perfiles WHERE nombre = 'CAJERO';

    INSERT INTO perfil_recursos (perfil_id, recurso_id)
    SELECT v_cajero_id, id FROM recursos WHERE nombre IN (
        'ventas:ver','ventas:crear',
        'inventario:ver','catalogos:ver','sucursales:ver'
    ) ON CONFLICT DO NOTHING;
END $$;

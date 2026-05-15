-- ============================================================
-- 01-init-public.sql — Inicialización del schema public
-- ============================================================

CREATE SCHEMA IF NOT EXISTS public;

CREATE TABLE IF NOT EXISTS public.tenants (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(200) NOT NULL,
    schema_name VARCHAR(100) UNIQUE NOT NULL,
    activo      BOOLEAN NOT NULL DEFAULT true,
    created_at  TIMESTAMP DEFAULT NOW()
);

-- Tenant demo inicial
INSERT INTO public.tenants (nombre, schema_name, activo)
VALUES ('Farmacia Demo', 'farmacia_demo', true)
ON CONFLICT (schema_name) DO NOTHING;

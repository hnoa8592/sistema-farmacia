-- ============================================================
-- 02-tenant-schema-template.sql
-- Reemplazar {SCHEMA} con el schemaName del tenant
-- ============================================================

CREATE SCHEMA IF NOT EXISTS {SCHEMA};

SET search_path TO {SCHEMA}, public;

-- 1. Categorías terapéuticas
CREATE TABLE IF NOT EXISTS categorias_terapeuticas (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(200) UNIQUE NOT NULL,
    descripcion VARCHAR(500),
    activo      BOOLEAN NOT NULL DEFAULT true
);

-- 2. Formas farmacéuticas
CREATE TABLE IF NOT EXISTS formas_farmaceuticas (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(200) UNIQUE NOT NULL,
    descripcion VARCHAR(500),
    activo      BOOLEAN NOT NULL DEFAULT true
);

-- 3. Vías de administración
CREATE TABLE IF NOT EXISTS vias_administracion (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(200) UNIQUE NOT NULL,
    descripcion VARCHAR(500),
    activo      BOOLEAN NOT NULL DEFAULT true
);

-- 4. Principios activos
CREATE TABLE IF NOT EXISTS principios_activos (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(200) UNIQUE NOT NULL,
    descripcion VARCHAR(500),
    activo      BOOLEAN NOT NULL DEFAULT true
);
CREATE INDEX IF NOT EXISTS idx_principios_nombre ON principios_activos(nombre);

-- 5. Laboratorios
CREATE TABLE IF NOT EXISTS laboratorios (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(200) NOT NULL,
    pais        VARCHAR(100),
    direccion   VARCHAR(500),
    telefono    VARCHAR(50),
    email       VARCHAR(200),
    activo      BOOLEAN NOT NULL DEFAULT true
);
CREATE INDEX IF NOT EXISTS idx_laboratorios_nombre ON laboratorios(nombre);

-- 6. Sucursales
CREATE TABLE IF NOT EXISTS sucursales (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(200) NOT NULL,
    direccion   VARCHAR(500),
    telefono    VARCHAR(50),
    es_matriz   BOOLEAN NOT NULL DEFAULT false,
    activo      BOOLEAN NOT NULL DEFAULT true
);

-- 7. Productos
CREATE TABLE IF NOT EXISTS productos (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre                VARCHAR(300) NOT NULL,
    nombre_comercial      VARCHAR(300),
    codigo                VARCHAR(100) UNIQUE NOT NULL,
    codigo_barra          VARCHAR(100),
    descripcion           TEXT,
    concentracion         VARCHAR(100),
    presentacion          VARCHAR(200),
    requiere_receta       BOOLEAN NOT NULL DEFAULT false,
    controlado            BOOLEAN NOT NULL DEFAULT false,
    activo                BOOLEAN NOT NULL DEFAULT true,
    categoria_id          UUID REFERENCES categorias_terapeuticas(id),
    forma_farmaceutica_id UUID REFERENCES formas_farmaceuticas(id),
    via_administracion_id UUID REFERENCES vias_administracion(id)
);
CREATE INDEX IF NOT EXISTS idx_productos_codigo ON productos(codigo);
CREATE INDEX IF NOT EXISTS idx_productos_codigo_barra ON productos(codigo_barra);
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);
CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_productos_forma ON productos(forma_farmaceutica_id);

-- 8. Producto principios activos
CREATE TABLE IF NOT EXISTS producto_principios_activos (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producto_id        UUID NOT NULL REFERENCES productos(id),
    principio_activo_id UUID NOT NULL REFERENCES principios_activos(id),
    concentracion      VARCHAR(100),
    UNIQUE(producto_id, principio_activo_id)
);

-- 9. Producto lotes
CREATE TABLE IF NOT EXISTS producto_lotes (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producto_id       UUID NOT NULL REFERENCES productos(id),
    laboratorio_id    UUID NOT NULL REFERENCES laboratorios(id),
    numero_lote       VARCHAR(100) NOT NULL,
    fecha_fabricacion DATE,
    fecha_vencimiento DATE NOT NULL,
    cantidad_inicial  INTEGER NOT NULL,
    activo            BOOLEAN NOT NULL DEFAULT true,
    UNIQUE(producto_id, numero_lote)
);
CREATE INDEX IF NOT EXISTS idx_lotes_producto ON producto_lotes(producto_id);
CREATE INDEX IF NOT EXISTS idx_lotes_laboratorio ON producto_lotes(laboratorio_id);
CREATE INDEX IF NOT EXISTS idx_lotes_vencimiento ON producto_lotes(fecha_vencimiento);
CREATE INDEX IF NOT EXISTS idx_lotes_numero ON producto_lotes(numero_lote);

-- 10. Producto precios
CREATE TABLE IF NOT EXISTS producto_precios (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producto_id     UUID NOT NULL REFERENCES productos(id),
    tipo_precio     VARCHAR(20) NOT NULL CHECK (tipo_precio IN ('UNIDAD','TIRA','CAJA','FRACCION')),
    precio          NUMERIC(10,2) NOT NULL,
    precio_compra   NUMERIC(10,2),
    vigencia_desde  TIMESTAMP NOT NULL DEFAULT NOW(),
    vigencia_hasta  TIMESTAMP,
    activo          BOOLEAN NOT NULL DEFAULT true
);
CREATE INDEX IF NOT EXISTS idx_precios_producto_tipo ON producto_precios(producto_id, tipo_precio) WHERE activo = true;

-- 11. Inventario
CREATE TABLE IF NOT EXISTS inventario (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lote_id      UUID NOT NULL REFERENCES producto_lotes(id),
    sucursal_id  UUID NOT NULL REFERENCES sucursales(id),
    stock_actual INTEGER NOT NULL DEFAULT 0,
    stock_minimo INTEGER NOT NULL DEFAULT 5,
    ubicacion    VARCHAR(200),
    UNIQUE(lote_id, sucursal_id)
);
CREATE INDEX IF NOT EXISTS idx_inventario_lote ON inventario(lote_id);
CREATE INDEX IF NOT EXISTS idx_inventario_sucursal ON inventario(sucursal_id);

-- 12. Movimientos inventario
CREATE TABLE IF NOT EXISTS movimientos_inventario (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    inventario_id    UUID NOT NULL REFERENCES inventario(id),
    lote_id          UUID NOT NULL,
    producto_id      UUID NOT NULL,
    sucursal_id      UUID NOT NULL,
    tipo             VARCHAR(20) NOT NULL CHECK (tipo IN ('ENTRADA','SALIDA','AJUSTE','TRANSFERENCIA')),
    cantidad         INTEGER NOT NULL,
    stock_anterior   INTEGER NOT NULL,
    stock_resultante INTEGER NOT NULL,
    fecha            TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_id       UUID,
    observacion      VARCHAR(500)
);
CREATE INDEX IF NOT EXISTS idx_movimientos_inventario ON movimientos_inventario(inventario_id);
CREATE INDEX IF NOT EXISTS idx_movimientos_producto ON movimientos_inventario(producto_id);
CREATE INDEX IF NOT EXISTS idx_movimientos_sucursal ON movimientos_inventario(sucursal_id);
CREATE INDEX IF NOT EXISTS idx_movimientos_fecha ON movimientos_inventario(fecha);
CREATE INDEX IF NOT EXISTS idx_movimientos_tipo ON movimientos_inventario(tipo);

-- 13. Seguridad
CREATE TABLE IF NOT EXISTS recursos (
    id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre  VARCHAR(100) UNIQUE NOT NULL,
    modulo  VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS perfiles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre      VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS perfil_recursos (
    perfil_id   UUID NOT NULL REFERENCES perfiles(id),
    recurso_id  UUID NOT NULL REFERENCES recursos(id),
    PRIMARY KEY (perfil_id, recurso_id)
);

CREATE TABLE IF NOT EXISTS usuarios (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre     VARCHAR(200) NOT NULL,
    email      VARCHAR(200) UNIQUE NOT NULL,
    password   VARCHAR(255) NOT NULL,
    activo     BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS usuario_perfiles (
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    perfil_id  UUID NOT NULL REFERENCES perfiles(id),
    PRIMARY KEY (usuario_id, perfil_id)
);

-- 14. Ventas
CREATE TABLE IF NOT EXISTS ventas (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fecha      TIMESTAMP NOT NULL DEFAULT NOW(),
    total      NUMERIC(10,2) NOT NULL,
    descuento  NUMERIC(5,2) DEFAULT 0,
    usuario_id UUID,
    estado     VARCHAR(20) NOT NULL CHECK (estado IN ('COMPLETADA','ANULADA'))
);

CREATE TABLE IF NOT EXISTS detalle_ventas (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venta_id        UUID NOT NULL REFERENCES ventas(id),
    producto_id     UUID NOT NULL,
    lote_id         UUID NOT NULL,
    inventario_id   UUID NOT NULL,
    tipo_precio     VARCHAR(20) NOT NULL,
    cantidad        INTEGER NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL,
    subtotal        NUMERIC(10,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_detalle_venta ON detalle_ventas(venta_id);
CREATE INDEX IF NOT EXISTS idx_detalle_producto ON detalle_ventas(producto_id);
CREATE INDEX IF NOT EXISTS idx_detalle_lote ON detalle_ventas(lote_id);

-- 15. Auditoría
CREATE TABLE IF NOT EXISTS audit_logs (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id     UUID,
    usuario_email  VARCHAR(200),
    accion         VARCHAR(50) NOT NULL,
    modulo         VARCHAR(100) NOT NULL,
    entidad        VARCHAR(100) NOT NULL,
    entidad_id     VARCHAR(100),
    valor_anterior TEXT,
    valor_nuevo    TEXT,
    descripcion    VARCHAR(500) NOT NULL,
    ip_origen      VARCHAR(100),
    user_agent     VARCHAR(500),
    fecha          TIMESTAMP NOT NULL DEFAULT NOW(),
    exitoso        BOOLEAN NOT NULL DEFAULT true
);
CREATE INDEX IF NOT EXISTS idx_audit_usuario ON audit_logs(usuario_id);
CREATE INDEX IF NOT EXISTS idx_audit_modulo ON audit_logs(modulo);
CREATE INDEX IF NOT EXISTS idx_audit_entidad ON audit_logs(entidad);
CREATE INDEX IF NOT EXISTS idx_audit_fecha ON audit_logs(fecha);
CREATE INDEX IF NOT EXISTS idx_audit_entidad_id ON audit_logs(entidad, entidad_id);

-- 16. Parámetros
CREATE TABLE IF NOT EXISTS parametros (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clave       VARCHAR(100) UNIQUE NOT NULL,
    valor       VARCHAR(500) NOT NULL,
    descripcion VARCHAR(500),
    tipo        VARCHAR(20) NOT NULL CHECK (tipo IN ('STRING','INTEGER','DECIMAL','BOOLEAN')),
    modulo      VARCHAR(50) NOT NULL,
    editable    BOOLEAN NOT NULL DEFAULT true,
    activo      BOOLEAN NOT NULL DEFAULT true,
    updated_at  TIMESTAMP,
    updated_by  VARCHAR(200)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_parametros_clave ON parametros(clave);
CREATE INDEX IF NOT EXISTS idx_parametros_modulo ON parametros(modulo);

SET search_path TO public;

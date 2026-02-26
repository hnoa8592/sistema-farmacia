SET search_path TO {SCHEMA}, public;
-- 05-seed-parametros.sql — Parámetros iniciales del sistema
INSERT INTO parametros (clave, valor, descripcion, tipo, modulo, editable) VALUES
-- GENERAL
('MONEDA',         'BOB',        'Moneda del sistema',                         'STRING',  'GENERAL',    false),
('NOMBRE_FARMACIA','Mi Farmacia','Nombre de la farmacia',                       'STRING',  'GENERAL',    true),
('RUC',            '',           'RUC de la empresa',                           'STRING',  'GENERAL',    true),
('DIRECCION',      '',           'Dirección de la farmacia',                    'STRING',  'GENERAL',    true),
('TELEFONO',       '',           'Teléfono de la farmacia',                     'STRING',  'GENERAL',    true),
('LOGO_URL',       '',           'URL del logo para comprobantes',              'STRING',  'GENERAL',    true),
-- VENTAS
('IVA_PORCENTAJE',           '13',     'Porcentaje de IVA aplicado',                      'INTEGER', 'VENTAS',     false),
('MAX_DESCUENTO_PORCENTAJE', '20',     'Descuento máximo permitido por venta (%)',         'INTEGER', 'VENTAS',     true),
('PERMITIR_VENTA_SIN_STOCK', 'false',  'Permite vender productos sin stock',              'BOOLEAN', 'VENTAS',     true),
('IMPRIMIR_TICKET_AUTO',     'true',   'Imprime ticket automáticamente',                   'BOOLEAN', 'VENTAS',     true),
('FORMATO_COMPROBANTE',      'TICKET', 'Formato por defecto del comprobante',             'STRING',  'VENTAS',     true),
-- INVENTARIO
('STOCK_MINIMO_DEFAULT',    '5',    'Stock mínimo por defecto al crear producto',         'INTEGER', 'INVENTARIO', true),
('DIAS_ALERTA_VENCIMIENTO', '30',   'Días de anticipación para alertar vencimiento',      'INTEGER', 'INVENTARIO', true),
('ALERTAR_STOCK_BAJO',      'true', 'Activar alertas de stock bajo',                     'BOOLEAN', 'INVENTARIO', true),
-- SISTEMA
('ZONA_HORARIA',         'America/La_Paz', 'Zona horaria del sistema',                    'STRING',  'SISTEMA',    false),
('INTENTOS_LOGIN_MAX',   '5',           'Intentos máximos de login antes de bloquear',   'INTEGER', 'SISTEMA',    false),
('SESION_DURACION_HORAS','8',           'Duración máxima de sesión en horas',             'INTEGER', 'SISTEMA',    false),
('REGISTROS_POR_PAGINA', '20',          'Número de registros por página por defecto',     'INTEGER', 'SISTEMA',    true)
ON CONFLICT (clave) DO NOTHING;

SET search_path TO farmancia_noa;


CREATE TABLE IF NOT EXISTS seed_productos_csv_staging (
                                                          fila_excel INTEGER PRIMARY KEY,
                                                          codigo TEXT,
                                                          grupo_atq TEXT,
                                                          subgrupo_atq TEXT,
                                                          correlativo TEXT,
                                                          medicamento TEXT,
                                                          forma_farmaceutica TEXT,
                                                          concentracion TEXT,
                                                          clasificacion_atq TEXT,
                                                          uso_restringido TEXT,
                                                          precio_referencial NUMERIC(10,2),
    aclaracion_particularidades TEXT,
    descripcion TEXT,
    es_valido BOOLEAN NOT NULL DEFAULT false,
    motivo_invalidacion TEXT,
    loaded_at TIMESTAMP NOT NULL DEFAULT NOW()
    );

TRUNCATE TABLE seed_productos_csv_staging;

INSERT INTO seed_productos_csv_staging (
    fila_excel, codigo, grupo_atq, subgrupo_atq, correlativo, medicamento,
    forma_farmaceutica, concentracion, clasificacion_atq, uso_restringido,
    precio_referencial, aclaracion_particularidades, descripcion, es_valido, motivo_invalidacion
) VALUES
    (4, 'J0501', 'J', '5', '1', 'Abacavir', 'Comprimido', '300 mg', 'J05AF06', NULL, 2.890000, NULL, 'Abacavir Comprimido 300 mg', true, NULL);

SET search_path TO farmancia_noa;
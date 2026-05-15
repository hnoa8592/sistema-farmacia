-- ============================================================
-- run-seed-productos-csv.sql
-- Script maestro autocontenido para DBeaver.
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================


-- ============================================================
-- INICIO 28-seed-productos-csv-staging.sql
-- ============================================================

-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================
SET search_path TO {SCHEMA}, public;

BEGIN;

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
    precio_referencial NUMERIC(14,6),
    aclaracion_particularidades TEXT,
    es_valido BOOLEAN NOT NULL DEFAULT false,
    motivo_invalidacion TEXT,
    loaded_at TIMESTAMP NOT NULL DEFAULT NOW()
);

TRUNCATE TABLE seed_productos_csv_staging;

INSERT INTO seed_productos_csv_staging (
    fila_excel, codigo, grupo_atq, subgrupo_atq, correlativo, medicamento,
    forma_farmaceutica, concentracion, clasificacion_atq, uso_restringido,
    precio_referencial, aclaracion_particularidades, es_valido, motivo_invalidacion
) VALUES
(4, 'J0501', 'J', '5', '1', 'Abacavir', 'Comprimido', '300 mg', 'J05AF06', NULL, 2.890000, NULL, true, NULL),
(5, 'J0550', 'J', '5', '50', 'Abacavir sulfato + Lamivudina', 'Comprimido dispersable', '120 mg + 60 mg', 'J05AR02', 'R', 0.630000, NULL, true, NULL),
(6, 'L0209', 'L', '2', '9', 'Abiraterona Acetato', 'Comprimido', '250 mg', 'L02BX03', 'R', 83.620000, NULL, true, NULL),
(7, 'A0601', 'A', '6', '1', 'Aceite mineral', 'EmulsiÃ³n oral', '0.4', 'A06AG06', NULL, 38.644190, '100 ml', true, NULL),
(8, 'A1101', 'A', '11', '1', 'Aceite vitaminado (alimento)', 'EmulsiÃ³n oral', 'SegÃºn disponibilidad', 'A11CB**', NULL, 10.453636, '1 L', true, NULL),
(9, 'C0301', 'C', '3', '1', 'Acetazolamida', 'Comprimido', '250 mg', 'C03**', NULL, 1.894593, NULL, true, NULL),
(10, 'V0301', 'V', '3', '1', 'Acetil Cisteina', 'Inyectable', '0.1', 'V03AB23', NULL, 13.390000, '3 ml', true, NULL),
(11, 'D0603', 'D', '6', '3', 'Aciclovir', 'Crema dÃ©rmica', '0.05', 'D06BB03', NULL, 20.800000, '5 g', true, NULL),
(12, 'J0504', 'J', '5', '4', 'Aciclovir', 'Comprimido', '400 mg', 'J05AB01', NULL, 2.611272, NULL, true, NULL),
(13, 'J0530', 'J', '5', '30', 'Aciclovir', 'SuspensiÃ³n', '200 mg/5 ml', 'J05AB01', NULL, 79.479009, '100 ml', true, NULL),
(14, 'J0542', 'J', '5', '42', 'Aciclovir', 'Comprimido', '200 mg', 'J05AB01', NULL, 2.510000, NULL, true, NULL),
(15, 'J0543', 'J', '5', '43', 'Aciclovir', 'Comprimido', '800 mg', 'J05AB01', NULL, 8.213333, NULL, true, NULL),
(16, 'J0544', 'J', '5', '44', 'Aciclovir', 'Inyectable', '250 mg', 'J05AB01', NULL, 47.500000, NULL, true, NULL),
(17, 'J0545', 'J', '5', '45', 'Aciclovir', 'Inyectable', '500 mg', 'J05AB01', NULL, 74.380000, NULL, true, NULL),
(18, 'S0101', 'S', '1', '1', 'Aciclovir', 'Crema o Pomada oftÃ¡lmica', '0.03', 'S01AD03', NULL, 31.783056, '5 g', true, NULL),
(19, 'G0101', 'G', '1', '1', 'Ãcido acÃ©tico (Ãcido tricloroacÃ©tico)', 'SoluciÃ³n tÃ³pica', '0.5', 'G01AD02', NULL, 74.060000, '5 ml', true, NULL),
(20, 'B0101', 'B', '1', '1', 'Ãcido acetil salicÃ­lico', 'Comprimido', '100 mg', 'B01AC06', NULL, 0.396184, NULL, true, NULL),
(21, 'N0201', 'N', '2', '1', 'Ãcido acetil salicÃ­lico', 'Comprimido', '500 mg', 'N02BA01', NULL, 0.320000, NULL, true, NULL),
(22, 'M0503', 'M', '5', '3', 'Ãcido AlendrÃ³nico (Alendronato)', 'Comprimido', '70 mg', 'M05BA04', NULL, 6.650000, NULL, true, NULL),
(23, 'B0201', 'B', '2', '1', 'Ãcido aminocaprÃ³ico', 'Inyectable', '2g /10 ml', 'B02AA01', NULL, 60.320000, '10 ml', true, NULL),
(24, 'A1102', 'A', '11', '2', 'Ãcido Ascorbico (Vitamina C)', 'Inyectable', '500 mg/ml (2 ml)', 'A11GA01', NULL, 3.060000, '1 ml', true, NULL),
(25, 'A1103', 'A', '11', '3', 'Ãcido AscÃ³rbico (Vitamina C)', 'SoluciÃ³n oral gotas', 'SegÃºn disponibilidad', 'A11GA01', NULL, 16.115000, '30 ml', true, NULL),
(26, 'V0317', 'V', '3', '17', 'Ãcido dimercaptosuccinico', 'Capsula', '100 mg', 'V03AX', 'R', 84.450000, NULL, true, NULL),
(27, 'V0318', 'V', '3', '18', 'Ãcido dimercaptosuccinico', 'Capsula', '200 mg', 'V03AX', 'R', 168.900000, NULL, true, NULL),
(28, 'B0301', 'B', '3', '1', 'Ãcido fÃ³lico', 'Comprimido', '5 mg', 'B03BB01', NULL, 0.500000, NULL, true, NULL),
(29, 'B0310', 'B', '3', '10', 'Ãcido FÃ³lico', 'Comprimido', '800 mcg', 'B03BB01', NULL, 0.640000, NULL, true, NULL),
(30, 'V0812', 'V', '8', '12', 'Ãcido GadotÃ©rico', 'Inyectable', '0.5 mmol/ml', 'V08CA02', NULL, 557.350000, '15 ml', true, NULL),
(31, 'J0101', 'J', '1', '1', 'Ãcido nalidÃ­xico', 'Comprimido', '500 mg', 'J01MB02', NULL, 2.310000, NULL, true, NULL),
(32, 'J0102', 'J', '1', '2', 'Ãcido nalidÃ­xico', 'SuspensiÃ³n', '250 mg/5 ml', 'J01MB02', NULL, 41.845000, '120 ml', true, NULL),
(33, 'J0103', 'J', '1', '3', 'Ãcido nalidÃ­xico', 'SuspensiÃ³n', '125 mg/5 ml', 'J01MB02', NULL, 20.000000, '120 ml', true, NULL),
(34, 'J0411', 'J', '4', '11', 'Acido p-aminosalicilico', 'Polvo para soluciÃ³n oral', '4 g', 'J04AA01', NULL, 14.330000, NULL, true, NULL),
(35, 'D0101', 'D', '1', '1', 'Ãcido salicÃ­lico', 'SoluciÃ³n tÃ³pica', '0.05', 'D01AE12', NULL, 27.100000, NULL, true, NULL),
(36, 'B0206', 'B', '2', '6', 'Ãcido TranexÃ¡mico', 'Inyectable', '500 mg', 'B02AA02', 'R', 26.574286, NULL, true, NULL),
(37, 'B0207', 'B', '2', '7', 'Ãcido TranexÃ¡mico', 'Comprimido', '500 mg', 'B02AA02', NULL, 10.000000, NULL, true, NULL),
(38, 'A0501', 'A', '5', '1', 'Ãcido UrsodeoxicÃ³lico', 'CÃ¡psula', '250 mg', 'A05AA02', NULL, 9.270000, NULL, true, NULL),
(39, 'N0301', 'N', '3', '1', 'Ãcido ValprÃ³ico Ã³ Valproato sÃ³dico', 'Jarabe o SoluciÃ³n oral', '200 mg/5 ml', 'N03AG01', NULL, 103.428008, '40 ml', true, NULL),
(40, 'N0302', 'N', '3', '2', 'Ãcido ValprÃ³ico Ã³ Valproato sÃ³dico', 'Jarabe o SoluciÃ³n oral', '250 mg/5 ml', 'N03AG01', NULL, 164.250000, '100 ml', true, NULL),
(41, 'N0303', 'N', '3', '3', 'Ãcido ValprÃ³ico Ã³ Valproato sÃ³dico', 'CÃ¡psula o Comprimido', '500 mg', 'N03AG01', NULL, 10.160000, NULL, true, NULL),
(42, 'N0322', 'N', '3', '22', 'Ãcido ValprÃ³ico Ã³ Valproato sÃ³dico', 'Jarabe o SoluciÃ³n Oral', '200 mg/ml', 'N03AG01', NULL, 148.940000, '40 ml', true, NULL),
(43, 'M0504', 'M', '5', '4', 'Ãcido ZoledrÃ³nico', 'Inyectable', '4 mg', 'M05BA08', 'R', 555.938476, NULL, true, NULL),
(44, 'C0101', 'C', '1', '1', 'Adenosina', 'Inyectable', '6 mg/2 ml', 'C01EB10', NULL, 85.390000, NULL, true, NULL),
(45, 'B0512', 'B', '5', '12', 'Agentes con gelatina', 'SoluciÃ³n parenteral de gran volÃºmen', 'SegÃºn disponibilidad', 'B05AA06', NULL, 294.485000, '500 ml', true, NULL),
(46, 'B0501', 'B', '5', '1', 'Agua para inyecciÃ³n', 'Inyectable', '5 ml', 'B05X**', NULL, 1.000000, NULL, true, NULL),
(47, 'P0201', 'P', '2', '1', 'Albendazol', 'Comprimido', '200 mg', 'P02CA03', NULL, 1.210000, NULL, true, NULL),
(48, 'P0202', 'P', '2', '2', 'Albendazol', 'SuspensiÃ³n', '200 mg/5 ml', 'P02CA03', NULL, 11.250000, '10 ml', true, NULL),
(49, 'B0502', 'B', '5', '2', 'AlbÃºmina humana', 'Inyectable', '0.2', 'B05AA01', NULL, 756.000000, NULL, true, NULL),
(50, 'D0801', 'D', '8', '1', 'Alcohol etÃ­lico (Etanol)', 'SoluciÃ³n 1 l', '70% a 95%', 'D08AX08', NULL, 41.205000, '1 L', true, NULL),
(51, 'V0602', 'V', '6', '2', 'Alimentos TerapÃ©utico Listo para Uso (ATLU)', 'Polvo, pasta o Granulado segÃºn disponibilidad', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DB**', NULL, 9.720000, NULL, true, NULL),
(52, 'M0401', 'M', '4', '1', 'Alopurinol', 'Comprimido', '300 mg', 'M04AA01', NULL, 0.745000, NULL, true, NULL),
(53, 'N0501', 'N', '5', '1', 'Alprazolam', 'Comprimido ranurado', '0,5 mg', 'N05BA12', NULL, 0.940000, NULL, true, NULL),
(54, 'J0201', 'J', '2', '1', 'Amfotericina B', 'Inyectable', '50 mg', 'J02AA01', NULL, 201.160000, NULL, true, NULL),
(55, 'J0104', 'J', '1', '4', 'Amikacina', 'Inyectable', '500mg /2 ml', 'J01GB06', NULL, 8.595311, '2 ml', true, NULL),
(56, 'B0503', 'B', '5', '3', 'AminoÃ¡cidos', 'SoluciÃ³n parenteral de gran volumen', '0.1', 'B05BA01', NULL, 176.696991, '500ml', true, NULL),
(57, 'R0301', 'R', '3', '1', 'Aminofilina', 'Inyectable', '250 mg / 10 ml', 'R03DA05', NULL, 8.120000, NULL, true, NULL),
(58, 'R0302', 'R', '3', '2', 'Aminofilina', 'Comprimido', '200 mg', 'R03DA05', NULL, 1.000000, NULL, true, NULL),
(59, 'C0102', 'C', '1', '2', 'Amiodarona (clorhidrato)', 'Comprimido', '200 mg', 'C01BD01', NULL, 3.664931, NULL, true, NULL),
(60, 'C0103', 'C', '1', '3', 'Amiodarona (clorhidrato)', 'Inyectable', '50 mg/ml', 'C01BD01', NULL, 10.940000, NULL, true, NULL),
(61, 'N0601', 'N', '6', '1', 'Amitriptilina', 'Comprimido ranurado', '25 mg', 'N06AA09', NULL, 0.645000, NULL, true, NULL),
(62, 'C0807', 'C', '8', '7', 'Amlodipina', 'Comprimido', '10 mg', 'C08CA01', NULL, 1.335133, NULL, true, NULL),
(63, 'J0105', 'J', '1', '5', 'Amoxicilina', 'Comprimido', '1 g', 'J01CA04', NULL, 1.705000, '1 g', true, NULL),
(64, 'J0106', 'J', '1', '6', 'Amoxicilina', 'Comprimido', '500 mg', 'J01CA05', NULL, 0.780000, NULL, true, NULL),
(65, 'J0108', 'J', '1', '8', 'Amoxicilina', 'Inyectable', '1 g', 'J01CA06', NULL, 8.256162, NULL, true, NULL),
(66, 'J0157', 'J', '1', '57', 'Amoxicilina', 'SuspensiÃ³n', '500 mg/5 ml', 'J01CA07', NULL, 17.910000, '60 ml', true, NULL),
(67, 'J0109', 'J', '1', '9', 'Amoxicilina + inhibidor betalactamasa', 'Comprimido', '500 mg + SegÃºn disponibilidad', 'J01CR02', NULL, 6.360000, '500 Mg/125 Mg', true, NULL),
(68, 'J0110', 'J', '1', '10', 'Amoxicilina + inhibidor betalactamasa', 'SuspensiÃ³n', '250 mg + SegÃºn disponibilidad', 'J01CR02', NULL, 75.335000, '100 ml', true, NULL),
(69, 'J0111', 'J', '1', '11', 'Amoxicilina + inhibidor betalactamasa', 'Inyectable', '1 g + SegÃºn disponibilidad', 'J01CR02', NULL, 48.000000, '1 g + 500 Mg', true, NULL),
(70, 'J0171', 'J', '1', '71', 'Amoxicilina + inhibidor betalactamasa', 'Comprimido', '875 mg + SegÃºn disponibilidad', 'J01CR03', NULL, 9.585000, NULL, true, NULL),
(71, 'J0112', 'J', '1', '12', 'Ampicilina', 'Inyectable', '1 g', 'J01CA01', NULL, 7.871098, NULL, true, NULL),
(72, 'L0201', 'L', '2', '1', 'Anastrozol', 'Comprimido', '1 mg', 'L02BG03', NULL, 10.448810, NULL, true, NULL),
(73, 'R0501', 'R', '5', '1', 'Antigripal (Paracetamol + AntihistamÃ­nico + Vasoconstrictor con o sin CafeÃ­na)', 'Comprimido', 'SegÃºn disponibilidad', 'R05X**', NULL, 0.720000, NULL, true, NULL),
(74, 'J0601', 'J', '6', '1', 'AntitÃ³xina tetÃ¡nica', 'Inyectable', 'Norma PAI segÃºn disponibilidad', 'J06AA02', NULL, 50.240000, NULL, true, NULL),
(75, 'N0515', 'N', '5', '15', 'Aripiprazol', 'Comprimido', '10 mg', 'N05AX12', 'R', 10.302500, NULL, true, NULL),
(76, 'N0516', 'N', '5', '16', 'Aripiprazol', 'Comprimido', '15 mg', 'N05AX12', 'R', 11.342500, NULL, true, NULL),
(77, 'P0123', 'P', '1', '23', 'Artemeter + Lumefantrina', 'Comprimido', '20 mg + 120 mg', 'P01BF01', NULL, 0.300000, NULL, true, NULL),
(78, 'P0101', 'P', '1', '1', 'Artesunato', 'Comprimido', '50 mg', 'P01BE03', NULL, 3.670000, NULL, true, NULL),
(79, 'P0124', 'P', '1', '24', 'Artesunato', 'Inyectable', '60 mg', 'P01BE03', NULL, 3.310000, NULL, true, NULL),
(80, 'P0121', 'P', '1', '21', 'Artesunato + Mefloquina', 'Comprimido', '25 mg + 55 mg', 'P01BE03', NULL, 1.150000, NULL, true, NULL),
(81, 'P0122', 'P', '1', '22', 'Artesunato + Mefloquina', 'Comprimido', '100 mg + 220 mg', 'P01BE03', NULL, 2.330000, NULL, true, NULL),
(82, 'L0121', 'L', '1', '21', 'Asparaginasa', 'Inyectable', '10.000 UI', 'L01XX02', NULL, 1626.250000, NULL, true, NULL),
(83, 'J0531', 'J', '5', '31', 'Atazanavir (sulfato)', 'CÃ¡psula o Comprimido', '300 mg', 'J05AE08', 'R', 7.470000, NULL, true, NULL),
(84, 'J0539', 'J', '5', '39', 'Atazanavir + Ritonavir', 'CÃ¡psula o Comprimido', '300 mg + 100 mg', 'J05AR**', NULL, 6.070000, NULL, true, NULL),
(85, 'C0701', 'C', '7', '1', 'Atenolol', 'Comprimido ranurado', '100 mg', 'C07AB03', NULL, 0.625000, NULL, true, NULL),
(86, 'C1001', 'C', '10', '1', 'Atorvastatina', 'Comprimido', '10 mg', 'C10AA05', NULL, 1.421736, NULL, true, NULL),
(87, 'C1005', 'C', '10', '5', 'Atorvastatina', 'Comprimido', '20 mg', 'C10AA05', NULL, 1.170000, NULL, true, NULL),
(88, 'M0301', 'M', '3', '1', 'Atracurio besilato', 'Inyectable', '10 mg/ml', 'M03AC04', NULL, 27.000000, NULL, true, NULL),
(89, 'A0301', 'A', '3', '1', 'Atropina sulfato', 'Inyectable', '1 mg/ml', 'A03BA01', NULL, 3.630000, NULL, true, NULL),
(90, 'S0102', 'S', '1', '2', 'Atropina sulfato', 'SoluciÃ³n oftÃ¡lmica', '0.01', 'S01FA01', NULL, 29.600000, NULL, true, NULL),
(91, 'L0401', 'L', '4', '1', 'Azatioprina', 'Comprimido', '50 mg', 'L04AX01', NULL, 2.850000, NULL, true, NULL),
(92, 'L0402', 'L', '4', '2', 'Azatioprina', 'Inyectable', '20 mg/ml', 'L04AX01', NULL, 214.770000, NULL, true, NULL),
(93, 'J0113', 'J', '1', '13', 'Azitromicina', 'Comprimido', '500 mg', 'J01FA10', NULL, 7.827382, NULL, true, NULL),
(94, 'J0162', 'J', '1', '62', 'Azitromicina', 'SuspensiÃ³n', '200 mg/5 ml', 'J01FA10', NULL, 32.110000, '30 ml', true, NULL),
(95, 'D0102', 'D', '1', '2', 'Bacitracina + Neomicina sulfato', 'Crema o Pomada', '500 UI + 5 mg/g', 'D01AA20', NULL, 10.603500, '10 g', true, NULL),
(96, 'L0409', 'L', '4', '9', 'Basiliximab', 'Polvo para inyectable', '20 mg', 'L04AA09', 'R', 16013.620000, NULL, true, NULL),
(97, 'R0303', 'R', '3', '3', 'Beclometasona dipropionato', 'Aerosol', '50 mcg/inhalaciÃ³n', 'R03BA01', NULL, 88.652283, '200 dÃ³sis', true, NULL),
(98, 'J0418', 'J', '4', '18', 'Bedaquilina', 'Comprimido', '100 mg', 'J04AK05', NULL, 53.050000, NULL, true, NULL),
(99, 'J0114', 'J', '1', '14', 'Bencilpenicilina benzatÃ­nica', 'Inyectable', '600.000 UI', 'J01CE08', NULL, 5.090000, NULL, true, NULL),
(100, 'J0115', 'J', '1', '15', 'Bencilpenicilina benzatÃ­nica', 'Inyectable', '1.200.000 UI', 'J01CE09', NULL, 6.000000, NULL, true, NULL),
(101, 'J0116', 'J', '1', '16', 'Bencilpenicilina benzatÃ­nica', 'Inyectable', '2.400.000 UI', 'J01CE10', NULL, 13.243018, NULL, true, NULL),
(102, 'J0117', 'J', '1', '17', 'Bencilpenicilina procaÃ­nica', 'Inyectable', '400.000 UI', 'J01CE09', NULL, 5.830000, NULL, true, NULL),
(103, 'J0118', 'J', '1', '18', 'Bencilpenicilina procaÃ­nica', 'Inyectable', '800.000 UI', 'J01CE10', NULL, 6.840000, NULL, true, NULL),
(104, 'J0119', 'J', '1', '19', 'Bencilpenicilina sÃ³dica', 'Inyectable', '1.000.000 UI', 'J01CE01', NULL, 5.400000, NULL, true, NULL),
(105, 'J0120', 'J', '1', '20', 'Bencilpenicilina sÃ³dica', 'Inyectable', '30.000.000 UI', 'J01CE01', NULL, 35.600000, NULL, true, NULL),
(106, 'P0102', 'P', '1', '2', 'Benznidazol', 'Comprimido', '100 mg', 'P01CA02', NULL, 8.535000, NULL, true, NULL),
(107, 'P0125', 'P', '1', '25', 'Benznidazol', 'Comprimido', '12,5 mg', 'P01CA02', NULL, 1.070000, NULL, true, NULL),
(108, 'P0128', 'P', '1', '28', 'Benznidazol', 'Comprimido', '50 mg', 'P01CA02', NULL, 4.150000, NULL, true, NULL),
(109, 'P0301', 'P', '3', '1', 'Benzoato de bencilo', 'SoluciÃ³n o LociÃ³n', '20% o 25%', 'P03AX01', NULL, 10.250000, '100 ml', true, NULL),
(110, 'H0201', 'H', '2', '1', 'Betametasona (fosfato)', 'Inyectable', '4 mg', 'H02AB01', NULL, 11.836875, NULL, true, NULL),
(111, 'D0701', 'D', '7', '1', 'Betametasona (valerato)', 'Crema o Pomada', '0,1%', 'D07AC01', NULL, 9.480000, '15 g', true, NULL),
(112, 'L0136', 'L', '1', '36', 'Bevacizumab', 'Inyectable', '25 mg/ml', 'L01XC07', NULL, 4517.988563, NULL, true, NULL),
(113, 'L0212', 'L', '2', '12', 'Bicalutamida', 'Comprimido', '50 mg', 'L02BB03', 'R', 8.750000, NULL, true, NULL),
(114, 'A0101', 'A', '1', '1', 'Bicarbonato de sodio', 'Polvo', '20 g', 'A01AB11', NULL, 2.105000, NULL, true, NULL),
(115, 'B0504', 'B', '5', '4', 'Bicarbonato de sodio', 'Inyectable', '0.08', 'B05XA02', NULL, 9.493718, NULL, true, NULL),
(116, 'B0505', 'B', '5', '5', 'Bicarbonato de sodio p/hemodiÃ¡lisis', 'Polvo', 'Frasco por 720 g', 'B05CB04', NULL, 189.420000, NULL, true, NULL),
(117, 'N0401', 'N', '4', '1', 'Biperideno clorhidrato', 'Comprimido', '4 mg', 'N04AA02', NULL, 5.985000, NULL, true, NULL),
(118, 'A0602', 'A', '6', '2', 'Bisacodilo', 'Comprimido', '5 mg', 'A06AB02', NULL, 0.970000, NULL, true, NULL),
(119, 'C0706', 'C', '7', '6', 'Bisoprolol', 'Comprimido', '5 mg', 'C07AB07', NULL, 2.960000, NULL, true, NULL),
(120, 'L0101', 'L', '1', '1', 'Bleomicina', 'Inyectable', '15 UI', 'L01DC01', NULL, 412.240000, NULL, true, NULL),
(121, 'L0155', 'L', '1', '55', 'Bortezomib', 'Polvo para inyectable', '3,5 mg', 'L01XX32', 'R', 5000.000000, NULL, true, NULL),
(122, 'G0201', 'G', '2', '1', 'Bromocriptina', 'Comprimido', '2,5 mg', 'G02CB01', NULL, 4.470000, NULL, true, NULL),
(123, 'R0312', 'R', '3', '12', 'Budesonida', 'Aerosol', '100 mcg', 'R03BA02', NULL, 129.655000, '20 ml', true, NULL),
(124, 'N0101', 'N', '1', '1', 'Bupivacaina clorhidrato', 'Inyectable', '0,5%', 'N01BB01', NULL, 18.000000, NULL, true, NULL),
(125, 'N0102', 'N', '1', '2', 'Bupivacaina clorhidrato (pesada)', 'Inyectable', '0,5%', 'N01BB01', NULL, 13.589186, NULL, true, NULL),
(126, 'N0103', 'N', '1', '3', 'Bupivacaina clorhidrato con Epinefrina sin conservante', 'Inyectable', '0,5% 1:200.000', 'N01BB51', NULL, 41.365000, '20 ml', true, NULL),
(127, 'L0102', 'L', '1', '2', 'Busulfano', 'Comprimido', '2 mg', 'L01AB01', NULL, 9.390000, NULL, true, NULL),
(128, 'A0302', 'A', '3', '2', 'Butilbromuro de Hioscina (Butilescopolamina)', 'Comprimido', '10 mg', 'A03BB01', NULL, 2.100000, NULL, true, NULL),
(129, 'A0303', 'A', '3', '3', 'Butilbromuro de Hioscina (Butilescopolamina)', 'SoluciÃ³n oral gotas', '0,1%', 'A03BB01', NULL, 25.400000, NULL, true, NULL),
(130, 'A0304', 'A', '3', '4', 'Butilbromuro de Hioscina (Butilescopolamina)', 'Inyectable', '20 mg/ml', 'A03BB01', NULL, 4.956009, NULL, true, NULL),
(131, 'G0211', 'G', '2', '11', 'Cabergolina', 'Comprimido', '0,5 mg', 'G02CB03', NULL, 53.794668, NULL, true, NULL),
(132, 'N0609', 'N', '6', '9', 'CafeÃ­na Citrato', 'Inyectable', '20 mg/ml', 'N06BC01', NULL, 120.000000, '3 ml', true, NULL),
(133, 'A1201', 'A', '12', '1', 'Calcio (carbonato o citrato)', 'Comprimido', '500 mg (iÃ³n calcio)', 'A12AA04', NULL, 1.390000, NULL, true, NULL),
(134, 'A1202', 'A', '12', '2', 'Calcio + Vitamina D', 'Comprimido o CÃ¡psula', '500 mg (iÃ³n calcio); SegÃºn disponibilidad', 'A12AX**', NULL, 1.660000, NULL, true, NULL),
(135, 'L0103', 'L', '1', '3', 'Capecitabine', 'Comprimido', '500 mg', 'L01BC06', NULL, 15.124509, NULL, true, NULL),
(136, 'J0412', 'J', '4', '12', 'Capreomicina', 'Inyectable', '1 g', 'J04AB30', NULL, 41.480000, NULL, true, NULL),
(137, 'N0304', 'N', '3', '4', 'Carbamazepina', 'Comprimido', '200 mg', 'N03AF01', NULL, 0.977632, NULL, true, NULL),
(138, 'H0105', 'H', '1', '5', 'Carbetocina', 'Inyectable', '100 mcg/ml', 'H01BB03', 'R', 408.410000, NULL, true, NULL),
(139, 'A0701', 'A', '7', '1', 'CarbÃ³n medicinal activado', 'Polvo', 'SegÃºn disponibilidad', 'A07BA01', NULL, 2.770000, NULL, true, NULL),
(140, 'L0104', 'L', '1', '4', 'Carboplatino', 'Inyectable', '450 mg', 'L01XA02', NULL, 734.712206, NULL, true, NULL),
(141, 'L0132', 'L', '1', '32', 'Carboplatino', 'Inyectable', '150 mg', 'L01XA02', NULL, 391.635000, NULL, true, NULL),
(142, 'C0704', 'C', '7', '4', 'Carvedilol', 'Comprimido', '6,25 mg', 'C07AG02', NULL, 1.931463, NULL, true, NULL),
(143, 'C0705', 'C', '7', '5', 'Carvedilol', 'Comprimido', '12,5 mg', 'C07AG02', NULL, 2.202024, NULL, true, NULL),
(144, 'J0121', 'J', '1', '21', 'Cefazolina', 'Inyectable', '1 g', 'J01DB04', NULL, 18.000000, NULL, true, NULL),
(145, 'J0174', 'J', '1', '74', 'Cefepima', 'Inyectable', '1g', 'J01DE01', NULL, 120.000000, '15 ml', true, NULL),
(146, 'J0158', 'J', '1', '58', 'Cefixima', 'Comprimido o CÃ¡psula', '400 mg', 'J01DD08', 'R', 7.380000, NULL, true, NULL),
(147, 'J0163', 'J', '1', '63', 'Cefixima', 'SuspensiÃ³n', '100 mg/5 ml', 'J01DD08', NULL, 38.580000, '50 ml', true, NULL),
(148, 'J0122', 'J', '1', '22', 'Cefotaxima', 'Inyectable', '1 g', 'J01DD01', NULL, 8.440000, NULL, true, NULL),
(149, 'J0123', 'J', '1', '23', 'Cefradina', 'CÃ¡psula o Comprimido', '500 mg', 'J01DB09', NULL, 2.225000, NULL, true, NULL),
(150, 'J0124', 'J', '1', '24', 'Cefradina', 'SuspensiÃ³n', '250 mg/5 ml', 'J01DB09', NULL, 21.000000, '60 ml', true, NULL),
(151, 'J0125', 'J', '1', '25', 'Ceftazidima', 'Inyectable', '1 g', 'J01DD02', NULL, 13.000000, NULL, true, NULL),
(152, 'J0126', 'J', '1', '26', 'Ceftriaxona', 'Inyectable', '1 g', 'J01DD04', NULL, 11.985000, NULL, true, NULL),
(153, 'R0607', 'R', '6', '7', 'Cetirizina', 'CÃ¡psula o Comprimido', '10 mg', 'R06AE07', NULL, 1.110000, NULL, true, NULL),
(154, 'R0608', 'R', '6', '8', 'Cetirizina', 'Jarabe', '5 mg/5 ml', 'R06AE07', NULL, 24.300000, '100 ml', true, NULL),
(155, 'A1104', 'A', '11', '4', 'Cianocobalamina (Vitamina B12)', 'Inyectable', '1 mg/ml', 'A11EA**', NULL, 4.890000, '1ml', true, NULL),
(156, 'L0105', 'L', '1', '5', 'Ciclofosfamida', 'Inyectable', '500 mg', 'L01AA01', NULL, 164.590000, NULL, true, NULL),
(157, 'L0106', 'L', '1', '6', 'Ciclofosfamida', 'Inyectable', '1 g', 'L01AA01', NULL, 398.740000, '50 ml', true, NULL),
(158, 'L0107', 'L', '1', '7', 'Ciclofosfamida', 'Comprimido', '50 mg', 'L01AA01', NULL, 5.590000, NULL, true, NULL),
(159, 'J0401', 'J', '4', '1', 'Cicloserina', 'CÃ¡psula', '250 mg', 'J04AB01', NULL, 2.990000, NULL, true, NULL),
(160, 'L0403', 'L', '4', '3', 'Ciclosporina', 'SoluciÃ³n oral', '100 mg/ml', 'L04AA01', NULL, 1597.725000, NULL, true, NULL),
(161, 'L0404', 'L', '4', '4', 'Ciclosporina', 'CÃ¡psula blanda', '100 mg', 'L04AA01', NULL, 25.215000, NULL, true, NULL),
(162, 'L0405', 'L', '4', '5', 'Ciclosporina', 'CÃ¡psula blanda', '25 mg', 'L04AA01', NULL, 11.760000, NULL, true, NULL),
(163, 'L0406', 'L', '4', '6', 'Ciclosporina', 'CÃ¡psula blanda', '50 mg', 'L04AA01', NULL, 13.200000, NULL, true, NULL),
(164, 'S0103', 'S', '1', '3', 'Ciclosporina', 'SoluciÃ³n oftÃ¡lmica', '1E-3', 'S01XA18', NULL, 285.000000, NULL, true, NULL),
(165, 'J0127', 'J', '1', '27', 'Ciprofloxacina', 'Comprimido', '500 mg', 'J01MA02', NULL, 1.170000, NULL, true, NULL),
(166, 'J0128', 'J', '1', '28', 'Ciprofloxacina', 'Inyectable', '200 mg', 'J01MA02', NULL, 11.640000, NULL, true, NULL),
(167, 'J0161', 'J', '1', '61', 'Ciprofloxacina', 'Comprimido', '250 mg', 'J01MA02', NULL, 1.110000, NULL, true, NULL),
(168, 'S0104', 'S', '1', '4', 'Ciprofloxacina', 'SoluciÃ³n oftÃ¡lmica', '0,3%', 'S01AX13', NULL, 40.529188, NULL, true, NULL),
(169, 'L0202', 'L', '2', '2', 'Ciproterona (acetato)', 'Comprimido', '50 mg', 'L02AX**', NULL, 7.000000, NULL, true, NULL),
(170, 'G0301', 'G', '3', '1', 'Ciproterona acetato + Estradiol valerato', 'Comprimido', '2 mg + 1 mg', 'G03HA01', NULL, 126.000000, 'Por ciclo', true, NULL),
(171, 'G0302', 'G', '3', '2', 'Ciproterona acetato + Estradiol valerato', 'Comprimido', '2 mg + 0,035 mg', 'G03HA01', NULL, 6.428333, 'Por ciclo', true, NULL),
(172, 'L0108', 'L', '1', '8', 'Cisplatino', 'Inyectable', '10 mg', 'L01XA01', NULL, 75.600000, NULL, true, NULL),
(173, 'L0109', 'L', '1', '9', 'Cisplatino', 'Inyectable', '50 mg', 'L01XA01', NULL, 148.096701, NULL, true, NULL),
(174, 'L0110', 'L', '1', '10', 'Citarabina', 'Inyectable', '100 mg', 'L01BC01', NULL, 102.095000, NULL, true, NULL),
(175, 'L0111', 'L', '1', '11', 'Citarabina', 'Inyectable', '500 mg', 'L01BC01', NULL, 281.350000, NULL, true, NULL),
(176, 'J0129', 'J', '1', '29', 'Claritromicina', 'Comprimido', '500 mg', 'J01FA09', 'R', 5.920000, NULL, true, NULL),
(177, 'J0130', 'J', '1', '30', 'Claritromicina', 'SuspensiÃ³n', '250 mg/5 ml', 'J01FA09', 'R', 138.380000, '80 ml', true, NULL),
(178, 'J0131', 'J', '1', '31', 'Clindamicina', 'SuspensiÃ³n o Jarabe', '75 mg/5 ml', 'J01FF01', 'R', 145.250000, NULL, true, NULL),
(179, 'J0156', 'J', '1', '56', 'Clindamicina', 'CÃ¡psula o comprimido', '300 mg', 'J01FF01', 'R', 13.065002, NULL, true, NULL),
(180, 'J0164', 'J', '1', '64', 'Clindamicina', 'Inyectable', '600 mg', 'J01FF01', NULL, 17.200000, NULL, true, NULL),
(181, 'D0702', 'D', '7', '2', 'Clobetasol', 'Crema o Pomada', '0,05%', 'D07AD01', NULL, 18.025827, '25 g', true, NULL),
(182, 'D0703', 'D', '7', '3', 'Clobetasol', 'SoluciÃ³n', '0,05%', 'D07AD01', NULL, 56.900000, NULL, true, NULL),
(183, 'J0415', 'J', '4', '15', 'Clofazimina', 'CÃ¡psula', '100 mg', 'J04BA01', 'R', 10.940000, NULL, true, NULL),
(184, 'J0402', 'J', '4', '2', 'Clofazimina', 'CÃ¡psula', '50 mg', 'J04BA01', NULL, 5.690000, NULL, true, NULL),
(185, 'G0303', 'G', '3', '3', 'Clomifeno citrato', 'Comprimido', '50 mg', 'G03GB02', NULL, 3.770000, NULL, true, NULL),
(186, 'N0602', 'N', '6', '2', 'Clomipramina', 'Comprimido', '75 mg', 'N06AA04', NULL, 5.000000, NULL, true, NULL),
(187, 'N0603', 'N', '6', '3', 'Clomipramina (clorhidrato)', 'Inyectable', '25 mg/2 ml', 'N06AA04', NULL, 15.210000, NULL, true, NULL),
(188, 'N0306', 'N', '3', '6', 'Clonazepam', 'Comprimido ranurado', '2 mg', 'N03AE01', NULL, 4.236201, NULL, true, NULL),
(189, 'N0312', 'N', '3', '12', 'Clonazepam', 'SoluciÃ³n oral', '2,5 mg/ml', 'N03AE01', NULL, 108.590766, '30 ml', true, NULL),
(190, 'B0106', 'B', '1', '6', 'Clopidogrel', 'Comprimido', '75 mg', 'B01AC04', 'R', 5.090000, NULL, true, NULL),
(191, 'J0132', 'J', '1', '32', 'Cloranfenicol', 'CÃ¡psula', '500 mg', 'J01BA01', NULL, 2.370000, NULL, true, NULL),
(192, 'S0105', 'S', '1', '5', 'Cloranfenicol', 'SoluciÃ³n oftÃ¡lmica', '0,5%', 'S01AA01', NULL, 11.460000, NULL, true, NULL),
(193, 'S0106', 'S', '1', '6', 'Cloranfenicol', 'UngÃ¼ento oftÃ¡lmico', '0.01', 'S01AA01', NULL, 24.425443, '5 g', true, NULL),
(194, 'J0133', 'J', '1', '33', 'Cloranfenicol succinato sÃ³dico', 'Inyectable', '1 g', 'J01BA01', NULL, 4.490000, NULL, true, NULL),
(195, 'R0601', 'R', '6', '1', 'Clorfenamina (Clorfeniramina)', 'Comprimido', '4 mg', 'R06AB04', NULL, 0.340640, NULL, true, NULL),
(196, 'R0602', 'R', '6', '2', 'Clorfenamina (Clorfeniramina)', 'Jarabe', '2 mg/5 ml', 'R06AB04', NULL, 10.203503, NULL, true, NULL),
(197, 'R0603', 'R', '6', '3', 'Clorfenamina (Clorfeniramina)', 'Inyectable', '10 mg/ml', 'R06AB04', NULL, 2.050000, NULL, true, NULL),
(198, 'D0802', 'D', '8', '2', 'Clorhexidina gluconato', 'SoluciÃ³n', 'SegÃºn disponibilidad', 'D08AC02', NULL, 146.530000, '1 L', true, NULL),
(199, 'P0103', 'P', '1', '3', 'Cloroquina fosfato', 'Comprimido', '250 mg (150 mg base)', 'P01BA01', NULL, 0.370000, NULL, true, NULL),
(200, 'N0502', 'N', '5', '2', 'Clorpromazina', 'Comprimido', '100 mg', 'N05AA01', NULL, 2.950000, NULL, true, NULL),
(201, 'N0503', 'N', '5', '3', 'Clorpromazina', 'Inyectable', '12,5 mg/ml', 'N05AA01', NULL, 3.811895, '2 ml', true, NULL),
(202, 'A1203', 'A', '12', '3', 'Cloruro de potasio', 'SoluciÃ³n oral', '1,3 mEq/ml', 'A12BA01', NULL, 29.670000, NULL, true, NULL),
(203, 'B0506', 'B', '5', '6', 'Cloruro de potasio', 'Inyectable', '0.2', 'B05XA01', NULL, 3.550000, NULL, true, NULL),
(204, 'B0507', 'B', '5', '7', 'Cloruro de sodio', 'Inyectable', '0.2', 'B05CB01', NULL, 3.530000, NULL, true, NULL),
(205, 'D0103', 'D', '1', '3', 'Clotrimazol', 'Crema o Pomada', '0.01', 'D01AC01', NULL, 9.926521, '20 g', true, NULL),
(206, 'G0102', 'G', '1', '2', 'Clotrimazol', 'Ã“vulo', '100 mg', 'G01AF02', NULL, 1.907073, NULL, true, NULL),
(207, 'G0103', 'G', '1', '3', 'Clotrimazol', 'Crema vaginal', '0.01', 'G01AF02', NULL, 13.420716, '30 g', true, NULL),
(208, 'J0134', 'J', '1', '34', 'Cloxacilina', 'Inyectable', '500 mg', 'J01CF02', NULL, 7.320000, NULL, true, NULL),
(209, 'J0136', 'J', '1', '36', 'Cloxacilina', 'Inyectable', '1 g', 'J01CF02', NULL, 9.450000, NULL, true, NULL),
(210, 'N0202', 'N', '2', '2', 'CodeÃ­na', 'Comprimido', '30 mg', 'N02AA07', NULL, 3.790000, NULL, true, NULL),
(211, 'R0502', 'R', '5', '2', 'CodeÃ­na', 'Jarabe', '10 mg/5 ml', 'R05DA04', NULL, 37.395217, NULL, true, NULL),
(212, 'M0402', 'M', '4', '2', 'Colchicina', 'Comprimido', '0,5 mg', 'M04AC01', NULL, 1.200000, NULL, true, NULL),
(213, 'A1105', 'A', '11', '5', 'Colecalciferol (Vitamina D3)', 'Comprimido o CÃ¡psula blanda', '0,25 mcg', 'A11CC05', NULL, 3.950000, NULL, true, NULL),
(214, 'J0167', 'J', '1', '67', 'Colistina', 'Inyectable', '100 mg', 'J01XB01', 'R', 116.976190, NULL, true, NULL),
(215, 'A1106', 'A', '11', '6', 'Complejo B (B1 + B6 + B12)', 'Comprimido', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'A11DB**', NULL, 0.314820, NULL, true, NULL),
(216, 'A1107', 'A', '11', '7', 'Complejo B (B1 + B6 + B12)', 'Inyectable', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'A11DB**', NULL, 3.100000, NULL, true, NULL),
(217, 'A1108', 'A', '11', '8', 'Complejo de vitaminas y minerales (Uso pediatrÃ­a) CMV', 'Polvo para soluciÃ³n oral', 'SegÃºn disponibilidad', 'A11JC**', NULL, 395.000000, NULL, true, NULL),
(218, 'V0605', 'V', '6', '5', 'Complemento nutricional', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DB**', NULL, 275.500000, '1000 g', true, NULL),
(219, 'V0604', 'V', '6', '4', 'Complemento nutricional (Carmelo)', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DB**', NULL, 77.680000, NULL, true, NULL),
(220, 'V0606', 'V', '6', '6', 'Complemento nutricional (DiabÃ©tico)', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DB**', NULL, 159.249685, NULL, true, NULL),
(221, 'V0607', 'V', '6', '7', 'Complemento nutricional (Nutri Mama con CaÃ±ahua, probiÃ³tico y Omega-3)', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DB**', NULL, 86.760000, '800 g', true, NULL),
(222, 'V0603', 'V', '6', '3', 'Complemento nutricional (NutribebÃ©)', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DA', NULL, 36.500000, '750 g', true, NULL),
(223, 'V0801', 'V', '8', '1', 'Contraste iodado', 'Inyectable', 'SegÃºn disponibilidad (10 ml)', 'V08AB**', NULL, 352.000000, NULL, true, NULL),
(224, 'V0802', 'V', '8', '2', 'Contraste iodado', 'Inyectable', 'SegÃºn disponibilidad (50 ml)', 'V08AB**', NULL, 352.000000, NULL, true, NULL),
(225, 'V0803', 'V', '8', '3', 'Contraste iodado', 'Inyectable', 'SegÃºn disponibilidad (100 ml o 200 ml)', 'V08AB**', NULL, 432.675783, '100 ml', true, NULL),
(226, 'C0501', 'C', '5', '1', 'Corticoide + anestÃ©sico', 'Supositorio', 'SegÃºn disponibilidad', 'C05AX03', NULL, 3.205000, NULL, true, NULL),
(227, 'C0502', 'C', '5', '2', 'Corticoide + anestÃ©sico', 'Crema o Pomada', 'SegÃºn disponibilidad', 'C05AX03', NULL, 71.625000, '30 g', true, NULL),
(228, 'S0124', 'S', '1', '24', 'Corticoide + antiinfeccioso de accion tÃ³pica', 'SoluciÃ³n oftÃ¡lmica', 'SegÃºn disponibilidad', 'S01CA01', NULL, 28.160848, NULL, true, NULL),
(229, 'S0125', 'S', '1', '25', 'Corticoide + antiinfeccioso de accion tÃ³pica', 'UngÃ¼ento oftÃ¡lmico', 'SegÃºn disponibilidad', 'S01CA01', NULL, 48.690000, NULL, true, NULL),
(230, 'H0101', 'H', '1', '1', 'Corticotrofina (ACTH)', 'Inyectable', '25 UI o 40 UI', 'H01AA01', NULL, 109.470000, NULL, true, NULL),
(231, 'J0137', 'J', '1', '37', 'Cotrimoxazol (Sulfametoxazol + Trimetoprima)', 'Comprimido', '800 mg + 160 mg', 'J01EE01', NULL, 1.370000, NULL, true, NULL),
(232, 'J0138', 'J', '1', '38', 'Cotrimoxazol (Sulfametoxazol + Trimetoprima)', 'SuspensiÃ³n', '200 mg + 40 mg/5 ml', 'J01EE01', NULL, 13.710476, '100 ml', true, NULL),
(233, 'J0139', 'J', '1', '39', 'Cotrimoxazol (Sulfametoxazol + Trimetoprima)', 'Comprimido', '100 mg + 20 mg', 'J01EE01', NULL, 0.450000, NULL, true, NULL),
(234, 'J0140', 'J', '1', '40', 'Cotrimoxazol (Sulfametoxazol + Trimetoprima)', 'Comprimido', '400 mg + 80 mg', 'J01EE01', NULL, 0.726077, NULL, true, NULL),
(235, 'J0160', 'J', '1', '60', 'Cotrimoxazol (Sulfametoxazol + Trimetoprima)', 'Inyectable', '400 mg + 80 mg/5 ml', 'J01EE01', NULL, 39.940000, NULL, true, NULL),
(236, 'J0165', 'J', '1', '65', 'Cotrimoxazol (Sulfametoxazol + Trimetoprima)', 'SuspensiÃ³n', '400 mg + 80 mg/5 ml', 'J01EE01', NULL, 34.040000, '100 ml', true, NULL),
(237, 'L0112', 'L', '1', '12', 'Dacarbazina', 'Inyectable', '200 mg', 'L01AX04', NULL, 416.535000, NULL, true, NULL),
(238, 'J0540', 'J', '5', '40', 'Daclatasvir', 'CÃ¡psula o Comprimido', '60 mg', 'J05AX14', NULL, 471.510000, NULL, true, NULL),
(239, 'L0113', 'L', '1', '13', 'Dactinomicina', 'Inyectable', '0,5 mg/ml', 'L01DA01', NULL, 437.410000, NULL, true, NULL),
(240, 'J0416', 'J', '4', '16', 'Dapsona', 'Comprimido', '50 mg', 'J04BA02', 'R', 2.550000, NULL, true, NULL),
(241, 'J0403', 'J', '4', '3', 'Dapsona', 'Comprimido', '100 mg', 'J04BA02', NULL, 6.780000, NULL, true, NULL),
(242, 'J0532', 'J', '5', '32', 'Darunavir', 'Comprimido', '600 mg', 'J05AE10', 'R', 61.467000, NULL, true, NULL),
(243, 'L0144', 'L', '1', '44', 'Dasatinib', 'Comprimido', '20 mg', 'L01XE06', 'R', 41.670000, NULL, true, NULL),
(244, 'L0145', 'L', '1', '45', 'Dasatinib', 'Comprimido', '50 mg', 'L01XE06', 'R', 196.630000, NULL, true, NULL),
(245, 'L0146', 'L', '1', '46', 'Dasatinib', 'Comprimido', '70 mg', 'L01XE06', 'R', 209.730000, NULL, true, NULL),
(246, 'L0147', 'L', '1', '47', 'Dasatinib', 'Comprimido', '100 mg', 'L01XE06', 'R', 286.500000, NULL, true, NULL),
(247, 'L0137', 'L', '1', '37', 'Daunorrubicina', 'Inyectable', '20 mg', 'L01DB02', NULL, 553.970000, NULL, true, NULL),
(248, 'V0302', 'V', '3', '2', 'Deferoxamina mesilato', 'Inyectable', '500 mg', 'V03AC01', NULL, 111.550000, NULL, true, NULL),
(249, 'J0419', 'J', '4', '19', 'Delamanid', 'Comprimido', '100 mg', 'J04AK06', NULL, 106.000000, NULL, true, NULL),
(250, 'H0102', 'H', '1', '2', 'Desmopresina acetato', 'SoluciÃ³n nasal', '0,1 mg/ml', 'H01BA02', NULL, 560.192246, '5 ml', true, NULL),
(251, 'H0202', 'H', '2', '2', 'Dexametasona', 'Comprimido', '4 mg', 'H02AB02', NULL, 0.820000, NULL, true, NULL),
(252, 'H0203', 'H', '2', '3', 'Dexametasona', 'Comprimido', '0,5 mg', 'H02AB02', NULL, 0.580000, NULL, true, NULL),
(253, 'H0204', 'H', '2', '4', 'Dexametasona', 'Inyectable', '4 mg/ml', 'H02AB02', NULL, 4.030000, '1 ml', true, NULL),
(254, 'S0109', 'S', '1', '9', 'Dexametasona', 'SoluciÃ³n oftÃ¡lmica', '0,1%', 'S01BA01', NULL, 17.590000, '10 ml', true, NULL),
(255, 'S0110', 'S', '1', '10', 'Dexametasona', 'UngÃ¼ento o Pomada oftÃ¡lmica', '0,1%', 'S01BA01', NULL, 35.070000, NULL, true, NULL),
(256, 'N0519', 'N', '5', '19', 'Dexmedetomidina', 'Inyectable', '100 mcg/ml', 'N05CM18', NULL, 150.000000, NULL, true, NULL),
(257, 'B0508', 'B', '5', '8', 'DextrÃ¡n 70', 'SoluciÃ³n parenteral de gran volÃºmen', '0.06', 'B05AA05', NULL, 67.200000, NULL, true, NULL),
(258, 'R0503', 'R', '5', '3', 'Dextrometorfano bromhidrato', 'Jarabe', '10 mg/5 ml', 'R05DA09', NULL, 11.195000, NULL, true, NULL),
(259, 'N0504', 'N', '5', '4', 'Diazepam', 'Comprimido ranurado', '10 mg', 'N05BA01', NULL, 1.870489, NULL, true, NULL),
(260, 'N0505', 'N', '5', '5', 'Diazepam', 'Inyectable', '10 mg', 'N05BA01', NULL, 12.750000, NULL, true, NULL),
(261, 'N0506', 'N', '5', '6', 'Diazepam', 'Comprimido ranurado', '5 mg', 'N05BA01', NULL, 0.600000, NULL, true, NULL),
(262, 'M0101', 'M', '1', '1', 'Diclofenaco SÃ³dico', 'Pomada o Gel', '0.01', 'M01AB05', NULL, 18.179433, '30g', true, NULL),
(263, 'M0102', 'M', '1', '2', 'Diclofenaco SÃ³dico', 'Comprimido', '50 mg', 'M01AB05', NULL, 0.200967, NULL, true, NULL),
(264, 'M0103', 'M', '1', '3', 'Diclofenaco SÃ³dico', 'Inyectable', '75 mg', 'M01AB05', NULL, 2.617563, '3 ml', true, NULL),
(265, 'S0111', 'S', '1', '11', 'Diclofenaco SÃ³dico', 'SoluciÃ³n oftÃ¡lmica', '0,1%', 'S01BC03', NULL, 29.960000, NULL, true, NULL),
(266, 'J0141', 'J', '1', '41', 'Dicloxacilina sÃ³dica', 'CÃ¡psula', '500 mg', 'J01CF01', NULL, 1.764190, NULL, true, NULL),
(267, 'J0142', 'J', '1', '42', 'Dicloxacilina sÃ³dica', 'SuspensiÃ³n', '250 mg/5 ml', 'J01CF01', NULL, 15.860000, '100 ml', true, NULL),
(268, 'C0105', 'C', '1', '5', 'Digoxina', 'Inyectable', '0,25 mg/ml', 'C01AA05', NULL, 7.700000, '2ml', true, NULL),
(269, 'C0106', 'C', '1', '6', 'Digoxina', 'Comprimido ranurado', '0,25 mg', 'C01AA05', NULL, 0.785667, NULL, true, NULL),
(270, 'N0701', 'N', '7', '1', 'Dimenhidrinato', 'Comprimido', '50 mg', 'N07X**', NULL, 0.900000, NULL, true, NULL),
(271, 'N0702', 'N', '7', '2', 'Dimenhidrinato', 'Supositorio', '50 mg', 'N07X**', NULL, 4.120000, NULL, true, NULL),
(272, 'N0703', 'N', '7', '3', 'Dimenhidrinato', 'Inyectable', '50 mg/ml', 'N07X**', NULL, 14.910000, NULL, true, NULL),
(273, 'V0303', 'V', '3', '3', 'Dimercaprol (B.A.L.)', 'Inyectable', '100 mg/ml', 'V03AB09', NULL, 758.010000, NULL, true, NULL),
(274, 'C0107', 'C', '1', '7', 'Dinitrato de isosorbida (Isosorbide dinitrato)', 'Comprimido sublingual', '5 mg', 'C01DA08', NULL, 1.350000, NULL, true, NULL),
(275, 'C0108', 'C', '1', '8', 'Dobutamina clorhidrato', 'Inyectable', '250 mg', 'C01CA07', NULL, 41.300000, NULL, true, NULL),
(276, 'L0138', 'L', '1', '38', 'Docetaxel', 'Inyectable', '40 mg/ml (2ml)', 'L01CD02', NULL, 794.000000, NULL, true, NULL),
(277, 'J0551', 'J', '5', '51', 'Dolutegravir', 'Comprimido dispersable', '10 mg', 'J05AJ03', 'R', 0.330000, NULL, true, NULL),
(278, 'J0552', 'J', '5', '52', 'Dolutegravir', 'Comprimido dispersable', '50 mg', 'J05AJ03', 'R', 0.320000, NULL, true, NULL),
(279, 'J0553', 'J', '5', '53', 'Dolutegravir + Lamivudine + Tenofovir', 'Comprimido', '50 mg + 300 mg + 300 mg', 'J05AR27', 'R', 0.720000, NULL, true, NULL),
(280, 'A0306', 'A', '3', '6', 'Domperidona', 'Comprimido', '10 mg', 'A03FA03', NULL, 0.620000, NULL, true, NULL),
(281, 'C0109', 'C', '1', '9', 'Dopamina clorhidrato', 'Inyectable', '200 mg', 'C01CA04', NULL, 12.641667, NULL, true, NULL),
(282, 'S0112', 'S', '1', '12', 'Dorzolamida', 'SoluciÃ³n oftÃ¡lmica', '0.02', 'S01EC03', NULL, 134.310523, NULL, true, NULL),
(283, 'J0144', 'J', '1', '44', 'Doxiciclina', 'CÃ¡psula o Comprimido', '100 mg', 'J01AA02', NULL, 1.059531, NULL, true, NULL),
(284, 'L0148', 'L', '1', '48', 'Doxorrubicina liposomal pegilada', 'Inyectable', '20 mg/ 10 ml', 'L01DB01', 'R', 718.130000, '10 ml', true, NULL),
(285, 'L0114', 'L', '1', '14', 'Doxorubicina clorhidrato (Adriamicina clorh.)', 'Inyectable', '10 mg', 'L01DB01', NULL, 120.000000, NULL, true, NULL),
(286, 'L0115', 'L', '1', '15', 'Doxorubicina clorhidrato (Adriamicina clorh.)', 'Inyectable', '50 mg', 'L01DB01', NULL, 226.675000, NULL, true, NULL),
(287, 'N0608', 'N', '6', '8', 'Duloxetina', 'CÃ¡psula', '30 mg', 'N06AX21', 'R', 8.222000, NULL, true, NULL),
(288, 'V0304', 'V', '3', '4', 'Edetato sÃ³dico de calcio (EDTA)', 'Inyectable', '0.2', 'V03AB03', NULL, 122.630000, NULL, true, NULL),
(289, 'B0509', 'B', '5', '9', 'EmulsiÃ³n de lÃ­pidos', 'EmulsiÃ³n inyectable', 'SegÃºn disponibilidad', 'B05BA02', NULL, 169.560000, NULL, true, NULL),
(290, 'C0901', 'C', '9', '1', 'Enalapril maleato', 'Comprimido ranurado', '10 mg', 'C09AA02', NULL, 0.381555, NULL, true, NULL),
(291, 'L0211', 'L', '2', '11', 'Enzalutamida', 'CÃ¡psula', '40 mg', 'L02BB04', 'R', 139.993333, NULL, true, NULL),
(292, 'A0901', 'A', '9', '1', 'Enzimas pancreÃ¡ticas (Lipasa, Proteasa y Amilasa en combinaciÃ³n)', 'Comprimido', 'SegÃºn disponibilidad', 'A09AA02', NULL, 2.180000, '150 Mg', true, NULL),
(293, 'C0110', 'C', '1', '10', 'Epinefrina (Adrenalina)', 'Inyectable', '1 mg/ml', 'C01CA24', NULL, 6.890000, NULL, true, NULL),
(294, 'G0203', 'G', '2', '3', 'Ergometrina maleato', 'Comprimido', '0,2 mg', 'G02AB03', NULL, 3.123701, NULL, true, NULL),
(295, 'G0204', 'G', '2', '4', 'Ergometrina maleato', 'Inyectable', '0,2 mg/ml', 'G02AB03', NULL, 11.400018, '1 ml', true, NULL),
(296, 'N0203', 'N', '2', '3', 'Ergotamina tartrato + CafeÃ­na', 'Comprimido', '1 mg + 100 mg', 'N02CA72', NULL, 3.328775, NULL, true, NULL),
(297, 'D1001', 'D', '10', '1', 'Eritromicina', 'LociÃ³n', '2% a 4%', 'D10AF02', NULL, 56.630000, '3 ml', true, NULL),
(298, 'J0145', 'J', '1', '45', 'Eritromicina (estearato)', 'CÃ¡psula o Comprimido', '500 mg', 'J01FA01', NULL, 1.494967, NULL, true, NULL),
(299, 'J0146', 'J', '1', '46', 'Eritromicina (etilsuccinato)', 'SuspensiÃ³n', '250 mg/5 ml', 'J01FA01', NULL, 25.758471, '100 ml', true, NULL),
(300, 'B0302', 'B', '3', '2', 'Eritropoyetina', 'Inyectable', '10.000 UI', 'B03XA01', NULL, 95.375000, NULL, true, NULL),
(301, 'B0303', 'B', '3', '3', 'Eritropoyetina', 'Inyectable', '2.000 UI', 'B03XA01', NULL, 32.990000, NULL, true, NULL),
(302, 'B0311', 'B', '3', '11', 'Eritropoyetina', 'Inyectable', '4000 UI', 'B03XA01', NULL, 94.330000, NULL, true, NULL),
(303, 'L0159', 'L', '1', '59', 'Erlotinib', 'Comprimido', '150 mg', 'L01XE03', 'R', 207.130000, NULL, true, NULL),
(304, 'J0147', 'J', '1', '47', 'Espiramicina', 'Comprimido', '500 mg', 'J01FA02', NULL, 7.580000, NULL, true, NULL),
(305, 'C0302', 'C', '3', '2', 'Espironolactona', 'Comprimido', '100 mg', 'C03DA01', NULL, 2.105262, NULL, true, NULL),
(306, 'C0303', 'C', '3', '3', 'Espironolactona', 'Comprimido', '25 mg', 'C03DA01', NULL, 0.964511, NULL, true, NULL),
(307, 'G0304', 'G', '3', '4', 'Estradiol + Noretisterona acetato', 'Comprimido', '2mg + 1mg', 'G03FB05', NULL, 146.495700, 'Por ciclo', true, NULL),
(308, 'G0305', 'G', '3', '5', 'Estradiol valerianato + Norgestrel', 'Comprimido', '2 mg + 0,5 mg', 'G03FA10', NULL, 95.090000, 'por ciclo', true, NULL),
(309, 'G0306', 'G', '3', '6', 'Estradiol valerianato + Prasterona enantato', 'Inyectable', '4 mg + 200 mg/ml', 'G03EA03', NULL, 113.355000, NULL, true, NULL),
(310, 'J0404', 'J', '4', '4', 'Estreptomicina sulfato', 'Inyectable', '1 g', 'J04AM**', NULL, 5.126851, NULL, true, NULL),
(311, 'B0102', 'B', '1', '2', 'Estreptoquinasa', 'Inyectable', '1.500.000 UI', 'B01AD01', NULL, 1074.350000, NULL, true, NULL),
(312, 'G0307', 'G', '3', '7', 'EstrÃ³genos conjugados', 'Comprimido', '0,625 mg', 'G03CA57', NULL, 7.560000, NULL, true, NULL),
(313, 'G0308', 'G', '3', '8', 'EstrÃ³genos conjugados', 'Comprimido', '1,25 mg', 'G03CA57', NULL, 5.050000, NULL, true, NULL),
(314, 'G0309', 'G', '3', '9', 'EstrÃ³genos conjugados', 'Crema vaginal', '0,625 mg', 'G03CA57', NULL, 181.300000, '43 g', true, NULL),
(315, 'J0405', 'J', '4', '5', 'Etambutol', 'Comprimido', '400 mg', 'J04AK02', 'R', 0.290000, NULL, true, NULL),
(316, 'J0424', 'J', '4', '24', 'Etambutol', 'Comprimido dispersable', '100 mg', 'J04AK02', 'R', 1.360000, NULL, true, NULL),
(317, 'J0425', 'J', '4', '25', 'Etambutol + Isoniazida + Pirazinamida + Rifampicina', 'Comprimido', '275 mg + 75 mg + 400 mg +150 mg', 'J04AM06', 'R', 1.130000, NULL, true, NULL),
(318, 'B0203', 'B', '2', '3', 'Etamsilato', 'Inyectable', '250 mg/2 ml', 'B02BX01', 'R', 37.943630, NULL, true, NULL),
(319, 'D0803', 'D', '8', '3', 'Eter alifÃ¡tico dietilamino etanol', 'SoluciÃ³n 1 l', 'SegÃºn disponibilidad', 'D08AC**', NULL, 614.919167, NULL, true, NULL),
(320, 'C0113', 'C', '1', '13', 'Etilefrina', 'Inyectable', '10 mg/ml', 'C01CA01', NULL, 20.560000, '1 ml', true, NULL),
(321, 'J0406', 'J', '4', '6', 'Etionamida', 'Comprimido', '250 mg', 'J04AD03', NULL, 0.730000, NULL, true, NULL),
(322, 'L0116', 'L', '1', '16', 'EtopÃ³sido', 'Inyectable', '100 mg/5 ml', 'L01CB01', NULL, 109.720000, NULL, true, NULL),
(323, 'B0205', 'B', '2', '5', 'Factor IX de la coagulaciÃ³n', 'Inyectable', '500 UI', 'B02BD04', 'R', 3190.405000, NULL, true, NULL),
(324, 'B0204', 'B', '2', '4', 'Factor VIII de la coagulaciÃ³n', 'Inyectable', '500 UI', 'B02BD02', 'R', 2628.905000, NULL, true, NULL),
(325, 'J0549', 'J', '5', '49', 'Favipiravir', 'Comprimido recubierto', '200 mg', 'J05AX27', 'R', 42.920000, NULL, true, NULL),
(326, 'N0307', 'N', '3', '7', 'FenitoÃ­na', 'Inyectable', '50 mg/ml', 'N03AB02', NULL, 12.990000, NULL, true, NULL),
(327, 'N0308', 'N', '3', '8', 'FenitoÃ­na', 'CÃ¡psula o Comprimido', '100 mg', 'N03AB02', NULL, 0.880000, NULL, true, NULL),
(328, 'N0309', 'N', '3', '9', 'Fenobarbital', 'Comprimido', '100 mg', 'N03AA02', NULL, 2.620000, NULL, true, NULL),
(329, 'N0310', 'N', '3', '10', 'Fenobarbital', 'Gotas', '20 mg/ml', 'N03AA02', NULL, 56.240000, '15 ml', true, NULL),
(330, 'N0311', 'N', '3', '11', 'Fenobarbital', 'Inyectable', '100 mg/ml', 'N03AA02', NULL, 37.800000, NULL, true, NULL),
(331, 'C1004', 'C', '10', '4', 'Fenofibrato', 'CÃ¡psula o Comprimido', '200 mg', 'C10AB05', NULL, 6.156534, NULL, true, NULL),
(332, 'N0105', 'N', '1', '5', 'Fentanilo con conservante', 'Inyectable', '0,05 mg/ml', 'N01AH01', NULL, 37.120000, NULL, true, NULL),
(333, 'N0106', 'N', '1', '6', 'Fentanilo sin conservante', 'Inyectable', '0,05 mg/ml', 'N01AH01', NULL, 16.574879, NULL, true, NULL),
(334, 'A0604', 'A', '6', '4', 'Fibra natural', 'Polvo o granulado', 'SegÃºn disponibilidad', 'A06AC07', NULL, 3.818944, NULL, true, NULL),
(335, 'B0208', 'B', '2', '8', 'FibrinÃ³geno humano', 'Inyectable', '1g', 'B02BB01', 'R', 8426.855000, NULL, true, NULL),
(336, 'L0301', 'L', '3', '1', 'Filgrastrim', 'Inyectable', '300 mcg/ml', 'L03AA02', NULL, 195.780000, NULL, true, NULL),
(337, 'G0401', 'G', '4', '1', 'Finasterida', 'Comprimido', '5 mg', 'G04CB01', NULL, 2.916488, NULL, true, NULL),
(338, 'L0418', 'L', '4', '18', 'Fingolimod', 'CÃ¡psula', '0,5 mg', 'L04AA27', 'R', 148.500000, NULL, true, NULL),
(339, 'B0202', 'B', '2', '2', 'Fitomenadiona (Vitamina K1)', 'Inyectable', '10 mg/ml', 'B02BA01', NULL, 3.225479, NULL, true, NULL),
(340, 'J0202', 'J', '2', '2', 'Fluconazol', 'Inyectable', '200 mg', 'J02AC01', NULL, 28.560000, NULL, true, NULL),
(341, 'J0208', 'J', '2', '8', 'Fluconazol', 'Comprimido o CÃ¡psula', '150 mg', 'J02AC01', NULL, 4.900000, NULL, true, NULL),
(342, 'L0162', 'L', '1', '62', 'Fludarabina', 'Inyectable', '50 mg', 'L01BB05', 'R', 1965.600000, NULL, true, NULL),
(343, 'V0305', 'V', '3', '5', 'Flumazenil', 'Inyectable', '0,5 mg/5 ml', 'V03AB25', NULL, 190.000000, NULL, true, NULL),
(344, 'N0708', 'N', '7', '8', 'Flunarizina', 'Comprimido', '10 mg', 'N07CA03', NULL, 3.313333, NULL, true, NULL),
(345, 'S0113', 'S', '1', '13', 'Fluoresceina', 'Inyectable', '0.1', 'S01JA01', NULL, 82.590000, NULL, true, NULL),
(346, 'S0114', 'S', '1', '14', 'Fluoresceina (sal sÃ³dica)', 'SoluciÃ³n oftÃ¡lmica', '0,25%', 'S01JA01', NULL, 46.320000, NULL, true, NULL),
(347, 'L0117', 'L', '1', '17', 'Fluorouracilo', 'Inyectable', '500 mg/10 ml', 'L01BC02', NULL, 59.000000, NULL, true, NULL),
(348, 'A0102', 'A', '1', '2', 'Fluoruro de sodio', 'Gel o Pasta', 'SegÃºn Programa', 'A01AA01', NULL, 25.000000, NULL, true, NULL),
(349, 'A1204', 'A', '12', '4', 'Fluoruro de sodio', 'SoluciÃ³n oral gotas', '0,2%', 'A12CD01', NULL, 19.220000, NULL, true, NULL),
(350, 'N0604', 'N', '6', '4', 'Fluoxetina', 'CÃ¡psula o Comprimido', '20 mg', 'N06AB03', NULL, 2.310000, NULL, true, NULL),
(351, 'L0203', 'L', '2', '3', 'Flutamida', 'Comprimido', '250 mg', 'L02BB01', NULL, 8.745000, NULL, true, NULL),
(352, 'D0804', 'D', '8', '4', 'Formaldehido', 'SoluciÃ³n', '40% p/v', 'D08AC**', NULL, 27.500000, '1 L', true, NULL),
(353, 'V0608', 'V', '6', '8', 'Formula Infantil', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DF', 'R', 236.000000, NULL, true, NULL),
(354, 'C0304', 'C', '3', '4', 'Furosemida', 'Comprimido ranurado', '40 mg', 'C03CA01', NULL, 0.478641, NULL, true, NULL),
(355, 'C0305', 'C', '3', '5', 'Furosemida', 'Inyectable', '10 mg/ml', 'C03CA01', NULL, 1.800000, '2 ml', true, NULL),
(356, 'V0811', 'V', '8', '11', 'Gadobutrol', 'Inyectable', '604,72mg/ml', 'V08CA09', NULL, 479.890000, '7.5 ml', true, NULL),
(357, 'V0804', 'V', '8', '4', 'Gadodiamida', 'Inyectable', '287 mg/ml', 'V08CA03', NULL, 473.670000, NULL, true, NULL),
(358, 'V0805', 'V', '8', '5', 'Gadopentato de dimeglumina', 'Inyectable', '469 mg/ml', 'V08CA01', NULL, 450.000000, '15 ml', true, NULL),
(359, 'V0810', 'V', '8', '10', 'Gadoversetamida', 'Inyectable', '0.5mmol / ml', 'V08CA06', 'R', 450.000000, NULL, true, NULL),
(360, 'L0118', 'L', '1', '18', 'Gemcitabina', 'Inyectable', '1 g', 'L01BC05', NULL, 600.000000, NULL, true, NULL),
(361, 'L0133', 'L', '1', '33', 'Gemcitabina', 'Inyectable', '200 mg', 'L01BC05', NULL, 271.630000, NULL, true, NULL),
(362, 'C1002', 'C', '10', '2', 'Gemfibrozilo', 'Comprimido', '600 mg', 'C10AB04', NULL, 2.330000, NULL, true, NULL),
(363, 'S0115', 'S', '1', '15', 'Gentamicina', 'UngÃ¼ento oftÃ¡lmico', '0,3%', 'S01AA11', NULL, 37.530000, '5 g', true, NULL),
(364, 'S0116', 'S', '1', '16', 'Gentamicina', 'SoluciÃ³n oftÃ¡lmica', '0,3%', 'S01AA11', NULL, 11.590000, '5 ml', true, NULL),
(365, 'J0148', 'J', '1', '48', 'Gentamicina sulfato', 'Inyectable', '20 mg', 'J01GB03', NULL, 2.600000, NULL, true, NULL),
(366, 'J0149', 'J', '1', '49', 'Gentamicina sulfato', 'Inyectable', '80 mg', 'J01GB03', NULL, 2.150000, NULL, true, NULL),
(367, 'A1001', 'A', '10', '1', 'Glibenclamida', 'Comprimido', '5 mg', 'A10BB01', NULL, 0.305800, NULL, true, NULL),
(368, 'S0201', 'S', '2', '1', 'Glicerina + carbonato de sodio', 'Gotas Ã³ticas', 'SegÃºn disponibilidad', 'S02DA30', NULL, 25.330000, '3g/100ml', true, NULL),
(369, 'D0201', 'D', '2', '1', 'Glicerol (Glicerina bidestilada)', 'SoluciÃ³n 1 l', 'SegÃºn disponibilidad', 'D02AX**', NULL, 106.830000, NULL, true, NULL),
(370, 'A0605', 'A', '6', '5', 'Glicerol (Glicerina)', 'Supositorio', '2 g a 4 g (adulto)', 'A06AX01', NULL, 2.646779, NULL, true, NULL),
(371, 'A0606', 'A', '6', '6', 'Glicerol (Glicerina)', 'Supositorio', '1 g a 1,80 g (infantil)', 'A06AX01', NULL, 2.464394, NULL, true, NULL),
(372, 'L0411', 'L', '4', '11', 'Globulina Anti-timocito', 'Inyectable', '250 mg/5ml', 'L04AA04', 'R', 2813.460000, NULL, true, NULL),
(373, 'L0419', 'L', '4', '19', 'Globulina Anti-timocito (conejo)', 'Inyectable', '25 mg', 'L04AA04', 'R', NULL, NULL, false, 'precio no numerico o ausente'),
(374, 'B0510', 'B', '5', '10', 'Gluconato CÃ¡lcico (Calcio Gluconato)', 'Inyectable', '0.1', 'B05XA07', NULL, 4.349916, NULL, true, NULL),
(375, 'G0310', 'G', '3', '10', 'Gonadotrofina coriÃ³nica', 'Inyectable', '5.000 UI/ml', 'G03GA01', NULL, 241.810000, '1 ml', true, NULL),
(376, 'J0204', 'J', '2', '4', 'Griseofulvina', 'Comprimido', '500 mg', 'J02AX**', NULL, 2.941485, NULL, true, NULL),
(377, 'J0205', 'J', '2', '5', 'Griseofulvina', 'SuspensiÃ³n', '125 mg/5 ml', 'J02AX**', NULL, 23.120000, NULL, true, NULL),
(378, 'N0507', 'N', '5', '7', 'Haloperidol', 'SoluciÃ³n oral', '2 mg/ml', 'N05AD01', NULL, 74.281600, NULL, true, NULL),
(379, 'N0508', 'N', '5', '8', 'Haloperidol', 'Comprimido', '5 mg', 'N05AD01', NULL, 2.109111, NULL, true, NULL),
(380, 'N0517', 'N', '5', '17', 'Haloperidol', 'Inyectable', '5 mg/ml', 'N05AD01', NULL, 42.510000, '1 ml', true, NULL),
(381, 'N0509', 'N', '5', '9', 'Haloperidol decanoato', 'Inyectable', '50 mg/ml', 'N05AD01', NULL, 79.499000, '1 ml', true, NULL),
(382, 'N0107', 'N', '1', '7', 'Halotano', 'SoluciÃ³n', '0,01% de timol', 'N01AB01', NULL, 450.000000, '250 ml', true, NULL),
(383, 'B0103', 'B', '1', '3', 'Heparina de bajo peso molecular', 'Inyectable', 'SegÃºn disponibilidad', 'B01AB**', NULL, 76.141565, NULL, true, NULL),
(384, 'B0104', 'B', '1', '4', 'Heparina sÃ³dica', 'Inyectable', '5.000 UI/ml', 'B01AB01', NULL, 55.631351, NULL, true, NULL),
(385, 'C0203', 'C', '2', '3', 'Hidralazina clorhidrato', 'Inyectable', '20 mg/ml', 'C02DB02', NULL, 79.000000, NULL, true, NULL),
(386, 'C0207', 'C', '2', '7', 'Hidralazina clorhidrato', 'Comprimido', '25 mg', 'C02DB02', NULL, 0.790000, NULL, true, NULL),
(387, 'C0306', 'C', '3', '6', 'Hidroclorotiazida', 'Comprimido ranurado', '50 mg', 'C03AA03', NULL, 0.570000, NULL, true, NULL),
(388, 'C0307', 'C', '3', '7', 'Hidroclorotiazida + Amilorida', 'Comprimido', '50 mg + 5 mg', 'C03AX01', NULL, 1.230000, NULL, true, NULL),
(389, 'D0704', 'D', '7', '4', 'Hidrocortisona acetato', 'Crema o Pomada', '0.01', 'D07AA02', NULL, 14.441814, '10 g', true, NULL),
(390, 'H0205', 'H', '2', '5', 'Hidrocortisona succinato sÃ³dico', 'Inyectable', '100 mg', 'H02AB09', NULL, 13.310277, NULL, true, NULL),
(391, 'H0206', 'H', '2', '6', 'Hidrocortisona succinato sÃ³dico', 'Inyectable', '250 mg', 'H02AB09', NULL, 45.870000, NULL, true, NULL),
(392, 'D1101', 'D', '11', '1', 'Hidroquinona', 'LociÃ³n', '4% o 5%', 'D11AX11', NULL, 51.670996, '30 ml', true, NULL),
(393, 'D1102', 'D', '11', '2', 'Hidroquinona', 'Crema a Pomada', '4% o 5 %', 'D11AX11', NULL, 37.060000, '30 g', true, NULL),
(394, 'P0127', 'P', '1', '27', 'Hidroxicloroquina sulfato', 'Comprimido', '200 mg', 'P01BA02', NULL, 7.088931, NULL, true, NULL),
(395, 'A0201', 'A', '2', '1', 'HidrÃ³xido de aluminio y magnesio', 'SuspensiÃ³n', '1:1', 'A02AD01', NULL, 16.180000, '120 ml', true, NULL),
(396, 'L0119', 'L', '1', '19', 'Hidroxiurea', 'CÃ¡psula', '500 mg', 'L01XX05', NULL, 5.425000, NULL, true, NULL),
(397, 'B0304', 'B', '3', '4', 'Hierro', 'Inyectable', '100 mg - IM o IV', 'B03AC02', NULL, 46.994445, NULL, true, NULL),
(398, 'B0312', 'B', '3', '12', 'Hierro (como bisglicina quelato)', 'SuspensiÃ³n', '30 mg/5 mL', 'B03AA01', NULL, 115.120000, '120 ml', true, NULL),
(399, 'D0805', 'D', '8', '5', 'Hipoclorito de sodio', 'SoluciÃ³n', '0.08', 'D08AX07', NULL, 14.710000, NULL, true, NULL),
(400, 'C0114', 'C', '1', '14', 'Ibuprofeno', 'Inyectable', '5 mg/ml', 'C01EB16', NULL, 34.650000, NULL, true, NULL),
(401, 'M0104', 'M', '1', '4', 'Ibuprofeno', 'SuspensiÃ³n', '100 mg/5 ml', 'M01AE01', NULL, 14.580000, '100ml', true, NULL),
(402, 'M0105', 'M', '1', '5', 'Ibuprofeno', 'Comprimido', '400 mg', 'M01AE01', NULL, 0.492014, NULL, true, NULL),
(403, 'L0120', 'L', '1', '20', 'Ifosfamida', 'Inyectable', '1 g', 'L01AA06', NULL, 131.330000, NULL, true, NULL),
(404, 'L0149', 'L', '1', '49', 'Imatinib', 'Comprimido', '100 mg', 'L01XE01', 'R', 26.250000, NULL, true, NULL),
(405, 'L0150', 'L', '1', '50', 'Imatinib', 'Comprimido', '400 mg', 'L01XE01', 'R', 238.000000, NULL, true, NULL),
(406, 'J0150', 'J', '1', '50', 'Imipenem + Cilastatina', 'Inyectable', '500 mg + 500 mg', 'J01DH51', 'R', 74.450000, NULL, true, NULL),
(407, 'N0605', 'N', '6', '5', 'Imipramina clorhidrato', 'Comprimido', '25 mg', 'N06AA02', NULL, 0.620000, NULL, true, NULL),
(408, 'M0106', 'M', '1', '6', 'Indometacina', 'CÃ¡psula o Comprimido', '25 mg', 'M01AB01', NULL, 0.465600, NULL, true, NULL),
(409, 'M0107', 'M', '1', '7', 'Indometacina', 'Supositorio', '100 mg', 'M01AB01', NULL, 2.201279, NULL, true, NULL),
(410, 'J0602', 'J', '6', '2', 'Inmunoglobulina anti D (RH +)', 'Inyectable', '0,1 mg/ml a 0,2 mg/ml', 'J06BB01', NULL, 1886.605000, NULL, true, NULL),
(411, 'J0603', 'J', '6', '3', 'Inmunoglobulina humana normal', 'Inyectable', '5 g IV', 'J06BA02', NULL, 4507.000000, NULL, true, NULL),
(412, 'A1005', 'A', '10', '5', 'Insulina Glargina', 'Inyectable', '100 U.I/ml', 'A10AE04', NULL, 411.016500, '10 ml', true, NULL),
(413, 'A1006', 'A', '10', '6', 'Insulina Glulisina', 'Inyectable', '100 U.I/ml', 'A10AB06', NULL, 370.210000, '10 ml', true, NULL),
(414, 'A1002', 'A', '10', '2', 'Insulina recombinante humana NPH', 'Inyectable', '100 UI/ml', 'A10AC01', NULL, 130.000000, NULL, true, NULL),
(415, 'A1003', 'A', '10', '3', 'Insulina zinc cristalina recombinante humana', 'Inyectable', '100 UI/ml', 'A10AB01', NULL, 107.226667, '10 ml', true, NULL),
(416, 'L0302', 'L', '3', '2', 'Interferon alfa 2 b recombinante', 'Inyectable', '10.000.000 UI con diluyente (1 ml)', 'L03AB05', NULL, 195.310000, NULL, true, NULL),
(417, 'L0303', 'L', '3', '3', 'Interferon alfa 2 b recombinante', 'Inyectable', '3.000.000 UI con diluyente (1 ml)', 'L03AB05', NULL, 90.000000, NULL, true, NULL),
(418, 'L0304', 'L', '3', '4', 'Interferon beta', 'Inyectable', '0,3 mg', 'L03AB07', NULL, 558.335000, '1 l', true, NULL),
(419, 'D0806', 'D', '8', '6', 'Iodo (Yodo)', 'SoluciÃ³n hidroalcohÃ³lica', '0.02', 'D08AG03', NULL, 125.000000, '1 L', true, NULL),
(420, 'D0807', 'D', '8', '7', 'Iodo povidona (Yodopovidona)', 'Crema o Pomada', '10% ( 500 g )', 'D08AG02', NULL, 186.150000, NULL, true, NULL),
(421, 'D0808', 'D', '8', '8', 'Iodo povidona (Yodopovidona)', 'SoluciÃ³n', '0.1', 'D08AG02', NULL, 96.000000, '1 L', true, NULL),
(422, 'R0309', 'R', '3', '9', 'Ipratropio bromuro', 'Aerosol', '20 mcg/dosis', 'R03BB01', NULL, 153.710000, '200 dosis', true, NULL),
(423, 'L0140', 'L', '1', '40', 'Irinotecan', 'Inyectable', '100 mg /5 ml', 'L01XX19', 'R', 667.476842, NULL, true, NULL),
(424, 'J0426', 'J', '4', '26', 'Isoniazida', 'Comprimido dispersable', '100 mg', 'J04AC01', 'R', 0.670000, NULL, true, NULL),
(425, 'J0407', 'J', '4', '7', 'Isoniazida (INH)', 'Comprimido', '100 mg', 'J04AC01', 'R', 0.130000, NULL, true, NULL),
(426, 'C0111', 'C', '1', '11', 'Isosorbida Mononitrato', 'Comprimido', '20 mg', 'C01DA14', NULL, 2.150000, NULL, true, NULL),
(427, 'P0213', 'P', '2', '13', 'Ivermectina', 'Comprimido', '3 mg', 'P02CF01', NULL, 8.450000, NULL, true, NULL),
(428, 'P0214', 'P', '2', '14', 'Ivermectina', 'Comprimido', '6 mg', 'P02CF01', NULL, 7.500000, NULL, true, NULL),
(429, 'J0413', 'J', '4', '13', 'Kanamicina', 'Inyectable', '1 g', 'J01GB04', NULL, 16.792524, NULL, true, NULL),
(430, 'N0108', 'N', '1', '8', 'Ketamina (Cetamina)', 'Inyectable', '50 mg/ml', 'N01AX03', NULL, 69.000000, '5 ml', true, NULL),
(431, 'M0110', 'M', '1', '10', 'Ketoprofeno', 'Inyectable', '100 mg', 'M01AE03', NULL, 20.824136, NULL, true, NULL),
(432, 'M0109', 'M', '1', '9', 'Ketorolaco', 'Inyectable', '30 mg/ml', 'M01AB15', NULL, 8.395965, '1 ml', true, NULL),
(433, 'R0604', 'R', '6', '4', 'Ketotifeno', 'Comprimido', '1 mg', 'R06AX17', NULL, 5.160000, NULL, true, NULL),
(434, 'S0117', 'S', '1', '17', 'Ketotifeno', 'SoluciÃ³n oftÃ¡lmica', '0,25 mg/ml', 'S01GX08', NULL, 189.000000, NULL, true, NULL),
(435, 'C0707', 'C', '7', '7', 'Labetalol', 'Inyectable', '20 mg', 'C07AG01', 'R', 67.660213, NULL, true, NULL),
(436, 'A0607', 'A', '6', '7', 'Lactulosa', 'SoluciÃ³n oral', '65% a 67%', 'A06AD11', NULL, 58.280000, '0.65', true, NULL),
(437, 'S0118', 'S', '1', '18', 'LÃ¡grimas artificiales', 'SoluciÃ³n oftÃ¡lmica', '0,3% o 1%', 'S01XA20', NULL, 34.965000, NULL, true, NULL),
(438, 'S0126', 'S', '1', '26', 'LÃ¡grimas artificiales', 'Gel', '0,3% o 1%', 'S01XA20', NULL, 105.505000, NULL, true, NULL),
(439, 'J0515', 'J', '5', '15', 'Lamivudina', 'Comprimido', '150 mg', 'J05AF05', NULL, 0.390000, NULL, true, NULL),
(440, 'J0516', 'J', '5', '16', 'Lamivudina', 'Jarabe o SoluciÃ³n oral', '10 mg/ml', 'J05AF05', NULL, 19.410000, NULL, true, NULL),
(441, 'N0315', 'N', '3', '15', 'Lamotrigina', 'Comprimido', '25 mg', 'N03AX09', 'R', 9.866667, NULL, true, NULL),
(442, 'N0316', 'N', '3', '16', 'Lamotrigina', 'Comprimido', '50 mg', 'N03AX09', 'R', 12.570000, NULL, true, NULL),
(443, 'N0317', 'N', '3', '17', 'Lamotrigina', 'Comprimido', '100 mg', 'N03AX09', 'R', 13.268750, NULL, true, NULL),
(444, 'N0318', 'N', '3', '18', 'Lamotrigina', 'Comprimido', '200 mg', 'N03AX09', 'R', 17.760000, NULL, true, NULL),
(445, 'S0127', 'S', '1', '27', 'Latanoprost', 'SoluciÃ³n oftÃ¡lmica', '50 mcg/ml', 'S01EE01', NULL, 129.930000, NULL, true, NULL),
(446, 'J0546', 'J', '5', '46', 'Ledipasvir + Sofosbuvir', 'Comprimido', '90 mg + 400 mg', 'J05AX65.', 'R', 966.650000, NULL, true, NULL),
(447, 'L0412', 'L', '4', '12', 'Leflunomida', 'Comprimido', '20 mg', 'L04AA13', 'R', 11.357716, NULL, true, NULL),
(448, 'L0413', 'L', '4', '13', 'Leflunomida', 'Comprimido', '100 mg', 'L04AA13', 'R', 50.000000, NULL, true, NULL),
(449, 'L0414', 'L', '4', '14', 'Lenalidomida', 'CÃ¡psula', '5 mg', 'L04AX04', 'R', 297.000000, NULL, true, NULL),
(450, 'L0415', 'L', '4', '15', 'Lenalidomida', 'CÃ¡psula', '10 mg', 'L04AX04', 'R', 357.520000, NULL, true, NULL),
(451, 'L0416', 'L', '4', '16', 'Lenalidomida', 'CÃ¡psula', '15 mg', 'L04AX04', 'R', 494.000000, NULL, true, NULL),
(452, 'L0417', 'L', '4', '17', 'Lenalidomida', 'CÃ¡psula', '25 mg', 'L04AX04', 'R', 500.000000, NULL, true, NULL),
(453, 'L0204', 'L', '2', '4', 'Letrozol', 'Comprimido', '2,5 mg', 'L02BG04', NULL, 7.020000, NULL, true, NULL),
(454, 'V0307', 'V', '3', '7', 'Leucovorina', 'Inyectable', '50 mg', 'V03AF03', NULL, 102.471105, NULL, true, NULL),
(455, 'V0314', 'V', '3', '14', 'Leucovorina (Folinato de calcio)', 'Comprimido', '15 mg', 'V03AF03', NULL, 36.330000, NULL, true, NULL),
(456, 'L0210', 'L', '2', '10', 'Leuprolide', 'Inyectable', '7,5 mg', 'L02AE02', 'R', 2768.220000, NULL, true, NULL),
(457, 'N0402', 'N', '4', '2', 'Levodopa + Carbidopa', 'Comprimido', '250 mg + 25 mg', 'N04BA02', NULL, 3.965388, NULL, true, NULL),
(458, 'J0166', 'J', '1', '66', 'Levofloxacina', 'Comprimido', '500 mg', 'J01MA12', 'R', 4.639266, NULL, true, NULL),
(459, 'J0168', 'J', '1', '68', 'Levofloxacina', 'Inyectable', '500 mg', 'J01MA12', 'R', 46.000000, '100 ml', true, NULL),
(460, 'G0311', 'G', '3', '11', 'Levonorgestrel', 'Comprimido', '0,75 mg', 'G03AD01', NULL, 13.863333, NULL, true, NULL),
(461, 'G0319', 'G', '3', '19', 'Levonorgestrel', 'Implante subdÃ©rmico', '150 mg', 'G03AC03', NULL, 260.000000, NULL, true, NULL),
(462, 'G0320', 'G', '3', '20', 'Levonorgestrel', 'Comprimido', '1,5 mg', 'G03AD01', NULL, 15.276111, NULL, true, NULL),
(463, 'G0312', 'G', '3', '12', 'Levonorgestrel + Etinilestradiol', 'Comprimido', '0,150 mg + 0,03 mg', 'G03FB09', NULL, 1.480000, 'Por ciclo', true, NULL),
(464, 'H0303', 'H', '3', '3', 'Levotiroxina sÃ²dica', 'Comprimido', '0,05 mg', 'H03AA01', NULL, 0.420000, '50 MCg', true, NULL),
(465, 'H0301', 'H', '3', '1', 'Levotiroxina sÃ³dica', 'Comprimido ranurado', '0,1 mg', 'H03AA01', NULL, 0.728000, NULL, true, NULL),
(466, 'D0401', 'D', '4', '1', 'LidocaÃ­na', 'Gel o Jalea', '0.02', 'D04AB01', NULL, 42.673796, NULL, true, NULL),
(467, 'N0109', 'N', '1', '9', 'LidocaÃ­na', 'Cartucho dental', '0.02', 'N01BB52', NULL, 5.150000, NULL, true, NULL),
(468, 'D0402', 'D', '4', '2', 'LidocaÃ­na clorhidrato', 'SoluciÃ³n para atomizaciÃ³n', '0.1', 'D04AB01', NULL, 135.820000, NULL, true, NULL),
(469, 'N0110', 'N', '1', '10', 'LidocaÃ­na clorhidrato + Epinefrina', 'Inyectable', '2% 1:200.000', 'N01BB52', NULL, 34.475000, NULL, true, NULL),
(470, 'N0111', 'N', '1', '11', 'LidocaÃ­na clorhidrato + Epinefrina', 'Cartucho dental', '2% 1:200.000', 'N01BB52', NULL, 5.925000, NULL, true, NULL),
(471, 'N0112', 'N', '1', '12', 'LidocaÃ­na clorhidrato sin conservante', 'Inyectable', '0.02', 'N01BB02', NULL, 12.210815, NULL, true, NULL),
(472, 'J0170', 'J', '1', '70', 'Linezolid', 'Comprimido', '600 mg', 'J01XX08', 'R', 15.290000, NULL, true, NULL),
(473, 'N0510', 'N', '5', '10', 'Litio carbonato', 'Comprimido', '300 mg', 'N05AN01', NULL, 2.440000, NULL, true, NULL),
(474, 'A0702', 'A', '7', '2', 'Loperamida', 'CÃ¡psula o Comprimido', '2 mg', 'A07DA03', NULL, 0.330000, NULL, true, NULL),
(475, 'C0902', 'C', '9', '2', 'LosartÃ¡n', 'Comprimido', '50 mg', 'C09CA01', NULL, 1.270000, '50 Mg', true, NULL),
(476, 'C0903', 'C', '9', '3', 'LosartÃ¡n + hidroclorotiazida', 'Comprimido', '50 mg + 12.5 mg', 'C09DA01', NULL, 1.260000, NULL, true, NULL),
(477, 'C0904', 'C', '9', '4', 'LosartÃ¡n + hidroclorotiazida', 'Comprimido', '100 mg + 25 mg', 'C9DA01', NULL, 15.200000, NULL, true, NULL),
(478, 'P0203', 'P', '2', '3', 'Mebendazol', 'Comprimido', '100 mg', 'P02CA01', NULL, 0.340000, NULL, true, NULL),
(479, 'P0204', 'P', '2', '4', 'Mebendazol', 'SuspensiÃ³n', '100 mg/5 ml', 'P02CA01', NULL, 8.270000, NULL, true, NULL),
(480, 'P0205', 'P', '2', '5', 'Mebendazol', 'Comprimido', '500 mg', 'P02CA01', NULL, 2.890000, NULL, true, NULL),
(481, 'G0313', 'G', '3', '13', 'Medroxiprogesterona acetato', 'Inyectable', '150 mg/ml', 'G03AC06', NULL, 18.081533, '1 ml', true, NULL),
(482, 'G0314', 'G', '3', '14', 'Medroxiprogesterona acetato', 'Comprimido', '10 mg', 'G03DA02', NULL, 2.320000, NULL, true, NULL),
(483, 'G0321', 'G', '3', '21', 'Medroxiprogesterona acetato', 'Inyectable', '104mg/0,65 ml', 'G03AC06', NULL, 9.490000, NULL, true, NULL),
(484, 'P0104', 'P', '1', '4', 'Mefloquina (clorhidrato)', 'Comprimido', '250 mg', 'P01BC02', NULL, 5.990000, NULL, true, NULL),
(485, 'P0105', 'P', '1', '5', 'Meglumina antimoniato', 'Inyectable', '1,5 g/5 ml', 'P01CB01', NULL, 67.580000, NULL, true, NULL),
(486, 'V0806', 'V', '8', '6', 'Meglumina diatrizoato', 'Inyectable', '70% o 76% (20 ml)', 'V08AA01', NULL, 133.845000, NULL, true, NULL),
(487, 'V0807', 'V', '8', '7', 'Meglumina diatrizoato', 'Inyectable', '70% o 76% (50 ml)', 'V08AA01', NULL, 183.280000, NULL, true, NULL),
(488, 'L0122', 'L', '1', '22', 'MelfalÃ¡n', 'Comprimido', '2 mg', 'L01AA03', NULL, 23.000000, NULL, true, NULL),
(489, 'L0163', 'L', '1', '63', 'MelfalÃ¡n', 'Inyectable', '50 mg', 'L01AA03', 'R', NULL, NULL, false, 'precio no numerico o ausente'),
(490, 'M0111', 'M', '1', '11', 'Meloxicam', 'Comprimido', '15 mg', 'M01AC06', NULL, 3.030000, NULL, true, NULL),
(491, 'L0123', 'L', '1', '23', 'Mercaptopurina', 'Comprimido ranurado', '50 mg', 'L01BB02', NULL, 9.880000, NULL, true, NULL),
(492, 'J0169', 'J', '1', '69', 'Meropenem', 'Inyectable', '500 mg', 'J01DH02', 'R', 90.586799, NULL, true, NULL),
(493, 'A0707', 'A', '7', '7', 'Mesalazina', 'Comprimido', '500 mg', 'A07S02', NULL, 18.565000, NULL, true, NULL),
(494, 'A0708', 'A', '7', '8', 'Mesalazina', 'Supositorio', '1g', 'A07S02', NULL, 57.392400, NULL, true, NULL),
(495, 'V0308', 'V', '3', '8', 'Mesna (Mercapto etilsulfonato sÃ³dico)', 'Inyectable', '400 mg', 'V03AF01', NULL, 99.850000, NULL, true, NULL),
(496, 'N0204', 'N', '2', '4', 'Metadona', 'Comprimido', '5 mg', 'N02AC**', NULL, 7.760000, NULL, true, NULL),
(497, 'N0205', 'N', '2', '5', 'Metamizol (Dipirona)', 'Inyectable', '1 g', 'N02BB02', NULL, 3.555000, NULL, true, NULL),
(498, 'A1004', 'A', '10', '4', 'Metformina', 'Comprimido', '850 mg', 'A10BA02', NULL, 1.690000, NULL, true, NULL),
(499, 'A1007', 'A', '10', '7', 'Metformina', 'Comprimido', '500 mg', 'A10BA02', NULL, 1.280000, NULL, true, NULL),
(500, 'C0204', 'C', '2', '4', 'Metildopa (Alfametildopa)', 'Comprimido', '500 mg', 'C02AB02', NULL, 3.300000, NULL, true, NULL),
(501, 'N0606', 'N', '6', '6', 'Metilfenidato', 'Comprimido', '10 mg', 'N06BA04', NULL, 16.450000, NULL, true, NULL),
(502, 'H0207', 'H', '2', '7', 'Metilprednisolona succinato sÃ³dico', 'Inyectable', '500 mg', 'H02AB04', NULL, 186.797217, NULL, true, NULL),
(503, 'A0307', 'A', '3', '7', 'Metoclopramida', 'Comprimido', '10 mg', 'A03FA01', NULL, 0.383970, NULL, true, NULL),
(504, 'A0308', 'A', '3', '8', 'Metoclopramida', 'Inyectable', '10mg / 2ml', 'A03FA01', NULL, 2.860000, '2 ml', true, NULL),
(505, 'A0309', 'A', '3', '9', 'Metoclopramida', 'SoluciÃ³n oral gotas', '0,35% o 0,5%', 'A03FA01', NULL, 18.061176, NULL, true, NULL),
(506, 'L0124', 'L', '1', '24', 'Metotrexato', 'Inyectable', '50 mg', 'L01BA01', NULL, 128.875000, NULL, true, NULL),
(507, 'L0125', 'L', '1', '25', 'Metotrexato', 'Inyectable', '500 mg', 'L01BA01', NULL, 244.860000, NULL, true, NULL),
(508, 'L0126', 'L', '1', '26', 'Metotrexato', 'Comprimido', '2,5 mg', 'L01BA01', NULL, 3.520000, NULL, true, NULL),
(509, 'G0104', 'G', '1', '4', 'Metronidazol', 'Ã“vulo', '500 mg', 'G01AF01', NULL, 3.280000, NULL, true, NULL),
(510, 'P0106', 'P', '1', '6', 'Metronidazol', 'SuspensiÃ³n', '250 mg/5 ml', 'P01AB01', NULL, 27.000000, '100 ml', true, NULL),
(511, 'P0107', 'P', '1', '7', 'Metronidazol', 'Inyectable', '500 mg', 'P01AB01', NULL, 12.680000, NULL, true, NULL),
(512, 'P0108', 'P', '1', '8', 'Metronidazol', 'SuspensiÃ³n', '125 mg/5 ml', 'P01AB01', NULL, 14.200000, NULL, true, NULL),
(513, 'P0109', 'P', '1', '9', 'Metronidazol', 'Comprimido', '500 mg', 'P01AB01', NULL, 0.624244, NULL, true, NULL),
(514, 'L0407', 'L', '4', '7', 'Micofenolato de mofetilo', 'Comprimido', '500 mg', 'L04AA06', 'R', 5.470000, NULL, true, NULL),
(515, 'B0305', 'B', '3', '5', 'Micronutrientes (Vit. C + Vit A + Fe + Zn + Ac. FÃ³lico) (Chispitas nutricionales)', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'B03AE10', NULL, 0.460000, NULL, true, NULL),
(516, 'N0511', 'N', '5', '11', 'Midazolam', 'Inyectable', '15 mg/3 ml', 'N05CD08', NULL, 20.500000, NULL, true, NULL),
(517, 'G0210', 'G', '2', '10', 'Mifepristona', 'Comprimido', '200 mg', 'G03XB01', NULL, 172.650000, NULL, true, NULL),
(518, 'C0116', 'C', '1', '16', 'Milrinona', 'Inyectable', '1 mg/ml', 'C01CE02', 'R', 219.176153, '12 ml', true, NULL),
(519, 'J0173', 'J', '1', '73', 'Minociclina', 'Comprimido', '100 mg', 'J01AA08', 'R', 11.034996, NULL, true, NULL),
(520, 'A0206', 'A', '2', '6', 'Misoprostol', 'Comprimido', '200 mcg', 'A02BB01', 'R', 9.112500, NULL, true, NULL),
(521, 'G0208', 'G', '2', '8', 'Misoprostol', 'Comprimido vaginal', '25 mcg', 'G02AD06', 'R', 5.900000, NULL, true, NULL),
(522, 'L0127', 'L', '1', '27', 'Mitomicina', 'Inyectable', '20 mg', 'L01DC03', NULL, 717.655065, NULL, true, NULL),
(523, 'M0302', 'M', '3', '2', 'Mivacuronio', 'Inyectable', '2 mg/ml', 'M03AC10', NULL, 118.830000, NULL, true, NULL),
(524, 'R0313', 'R', '3', '13', 'Montelukast', 'Comprimido o CÃ¡psula', '10 mg', 'R03DC03', NULL, 5.840000, NULL, true, NULL),
(525, 'R0314', 'R', '3', '14', 'Montelukast', 'Comprimido', '5 mg', 'R03DC03', NULL, 4.700000, NULL, true, NULL),
(526, 'N0206', 'N', '2', '6', 'Morfina', 'CÃ¡psula o Comprimido', '10 mg', 'N02AA01', NULL, 4.138893, NULL, true, NULL),
(527, 'N0207', 'N', '2', '7', 'Morfina (con y sin conservante)', 'Inyectable', '10 mg/ml', 'N02AA01', NULL, 18.232623, '1 ml', true, NULL),
(528, 'J0172', 'J', '1', '72', 'Moxifloxacina', 'Comprimido', '400 mg', 'J01MA14', 'R', 3.450000, NULL, true, NULL),
(529, 'A1109', 'A', '11', '9', 'Multivitaminas', 'Comprimido', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'A11AA03', NULL, 0.630310, NULL, true, NULL),
(530, 'A1110', 'A', '11', '10', 'Multivitaminas', 'Jarabe', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'A11AA03', NULL, 23.020000, '100 ml', true, NULL),
(531, 'A1120', 'A', '11', '20', 'Multivitaminas', 'Polvo liofilizado', 'SegÃºn disponibilidad', 'A11AA03', NULL, 50.000000, NULL, true, NULL),
(532, 'V0316', 'V', '3', '16', 'N-acetilcisteina', 'Polvo vÃ­a oral', '600 mg', 'V03AB23', 'R', 11.100000, NULL, true, NULL),
(533, 'V0315', 'V', '3', '15', 'N-acetilcisteina', 'Polvo vÃ­a oral', '200 mg', 'V03AB23', 'R', 8.500000, NULL, true, NULL),
(534, 'S0119', 'S', '1', '19', 'Nafazolina clorhidrato', 'SoluciÃ³n oftÃ¡lmica', '0,1%', 'S01GA01', NULL, 20.727727, '15 ml', true, NULL),
(535, 'V0309', 'V', '3', '9', 'Naloxona', 'Inyectable', '0,4 mg/ml', 'V03AB15', NULL, 63.000000, NULL, true, NULL),
(536, 'N0216', 'N', '2', '16', 'Naratriptan', 'Comprimido', '2,5 mg', 'N02CC02', NULL, 12.500000, NULL, true, NULL),
(537, 'N0705', 'N', '7', '5', 'Neostigmina', 'Inyectable', '0,5 mg/ml', 'N07AA01', NULL, 8.325000, NULL, true, NULL),
(538, 'J0521', 'J', '5', '21', 'Nevirapina', 'SuspensiÃ³n', '10 mg/ml', 'J05AG01', NULL, 20.750000, NULL, true, NULL),
(539, 'P0206', 'P', '2', '6', 'Niclosamida', 'Comprimido', '500 mg', 'P02DA01', NULL, 7.580000, NULL, true, NULL),
(540, 'C0808', 'C', '8', '8', 'Nifedipino', 'Comprimido o CÃ¡psula', '10 mg', 'C08CA05', NULL, 0.510000, NULL, true, NULL),
(541, 'P0110', 'P', '1', '10', 'Nifurtimox', 'Comprimido', '120 mg', 'P01CC01', NULL, 17.050000, NULL, true, NULL),
(542, 'P0129', 'P', '1', '29', 'Nifurtimox', 'Comprimido', '30 mg', 'P01CC01', NULL, 0.600000, NULL, true, NULL),
(543, 'P0130', 'P', '1', '30', 'Nifurtimox', 'Comprimido', '250 mg', 'P01CC01', NULL, 2.020000, NULL, true, NULL),
(544, 'C0802', 'C', '8', '2', 'Nimodipina', 'Comprimido', '30 mg', 'C08CA06', NULL, 0.930000, NULL, true, NULL),
(545, 'C0803', 'C', '8', '3', 'Nimodipina', 'Inyectable', '0,2 mg/ml', 'C08CA06', NULL, 172.534450, '50 ml', true, NULL),
(546, 'L0154', 'L', '1', '54', 'Nimotuzumab', 'Inyectable', '50 mg', 'L01XC99', 'R', 68.970000, NULL, true, NULL),
(547, 'A0703', 'A', '7', '3', 'Nistatina', 'Comprimido', '500.000 UI', 'A07AA02', NULL, 0.970000, NULL, true, NULL),
(548, 'A0704', 'A', '7', '4', 'Nistatina', 'SuspensiÃ³n', '500.000 UI/5 ml', 'A07AA02', NULL, 31.893000, NULL, true, NULL),
(549, 'D0104', 'D', '1', '4', 'Nistatina', 'Crema o Pomada', '100.000 UI/g', 'D01AA01', NULL, 13.351185, '10 g', true, NULL),
(550, 'G0105', 'G', '1', '5', 'Nistatina', 'Ã“vulo', '100.000 UI', 'G01AA01', NULL, 1.150000, NULL, true, NULL),
(551, 'P0111', 'P', '1', '11', 'Nitazoxanida', 'Comprimido', '500 mg', 'P01AX11', NULL, 6.100000, NULL, true, NULL),
(552, 'P0126', 'P', '1', '26', 'Nitazoxanida', 'Jarabe', '100 mg / 5 ml', 'P01AX11', NULL, 27.915000, NULL, true, NULL),
(553, 'D0809', 'D', '8', '9', 'Nitrofural (Nitrofurazona)', 'Crema o Pomada', '0,2% (450 g)', 'D08AF01', NULL, 179.028625, NULL, true, NULL),
(554, 'J0151', 'J', '1', '51', 'NitrofurantoÃ­na', 'Comprimido', '100 mg', 'J01XE01', NULL, 1.500000, NULL, true, NULL),
(555, 'J0152', 'J', '1', '52', 'NitrofurantoÃ­na', 'SuspensiÃ³n', '25 mg/5 ml', 'J01XE01', NULL, 24.225000, NULL, true, NULL),
(556, 'C0112', 'C', '1', '12', 'Nitroglicerina (Trinitrato de glicerol)', 'Inyectable', '5 mg/ml', 'C01DA02', NULL, 61.720000, '10 ml', true, NULL),
(557, 'C0205', 'C', '2', '5', 'Nitroprusiato de sodio', 'Inyectable', '25 mg/ml', 'C02DD01', NULL, 200.000000, '2 ml', true, NULL),
(558, 'C0115', 'C', '1', '15', 'Noradrenalina', 'Inyectable', '1 mg/ml', 'C01CA03', NULL, 28.800000, NULL, true, NULL),
(559, 'G0315', 'G', '3', '15', 'Noretisterona', 'Comprimido', '5 mg', 'G03DC02', NULL, 1.060000, NULL, true, NULL),
(560, 'G0316', 'G', '3', '16', 'Norgestrel + Etinilestradiol', 'Comprimido', '0,3 mg + 0,03 mg Ã³ 0,5 mg + 0,05 mg', 'G03FB01', NULL, 6.320000, NULL, true, NULL),
(561, 'J0153', 'J', '1', '53', 'Ofloxacina', 'Comprimido', '400 mg', 'J01MA01', 'R', 0.820000, NULL, true, NULL),
(562, 'J0159', 'J', '1', '59', 'Ofloxacina', 'Comprimido', '200 mg', 'J01MA01', 'R', 0.710000, NULL, true, NULL),
(563, 'B0511', 'B', '5', '11', 'Oligoelementos para nutricion parenteral', 'SoluciÃ³n parenteral de gran volÃºmen', 'SegÃºn disponibilidad', 'B05BA10', NULL, 45.830000, NULL, true, NULL),
(564, 'A0202', 'A', '2', '2', 'Omeprazol', 'CÃ¡psula', '20 mg', 'A02BC01', NULL, 0.657300, NULL, true, NULL),
(565, 'A0205', 'A', '2', '5', 'Omeprazol', 'Inyectable', '40 mg/ml', 'A02BC01', NULL, 19.470000, '10 ml', true, NULL),
(566, 'A0401', 'A', '4', '1', 'OndansetrÃ³n', 'Inyectable', '8 mg', 'A04AA01', NULL, 15.610000, NULL, true, NULL),
(567, 'A0402', 'A', '4', '2', 'OndansetrÃ³n', 'Comprimido', '8 mg', 'A04AA01', NULL, 9.740000, NULL, true, NULL),
(568, 'J0536', 'J', '5', '36', 'Oseltamivir', 'CÃ¡psula', '75 mg', 'J05AH02', 'R', 23.750000, NULL, true, NULL),
(569, 'J0547', 'J', '5', '47', 'Oseltamivir', 'SuspensiÃ³n', '30 mg/5 ml', 'J05AH02', 'R', 158.095000, NULL, true, NULL),
(570, 'J0548', 'J', '5', '48', 'Oseltamivir', 'SuspensiÃ³n', '12 mg/ml', 'J05AH02', 'R', 13.530000, NULL, true, NULL),
(571, 'L0134', 'L', '1', '34', 'Oxaliplatino', 'Inyectable', '50 mg', 'L01XA03', NULL, 226.880000, NULL, true, NULL),
(572, 'L0135', 'L', '1', '35', 'Oxaliplatino', 'Inyectable', '100 mg', 'L01XA03', NULL, 342.660000, NULL, true, NULL),
(573, 'D0202', 'D', '2', '2', 'Oxido de Zinc con o sin aceite', 'Pasta o Pomada', 'SegÃºn disponibilidad', 'D02AB**', NULL, 16.250000, '30 g', true, NULL),
(574, 'V0310', 'V', '3', '10', 'OxÃ­geno', 'Gas', '93% - 99%', 'V03AN01', NULL, 15.000000, 'm3', true, NULL),
(575, 'G0209', 'G', '2', '9', 'Oxitocina', 'Inyectable', '5 UI/ml o 10 UI/ml', 'G02AX**', NULL, 2.670000, '10 UI/ml', true, NULL),
(576, 'L0128', 'L', '1', '28', 'Paclitaxel', 'Inyectable', '30 mg/5 ml', 'L01CD01', NULL, 194.940258, NULL, true, NULL),
(577, 'L0160', 'L', '1', '60', 'Paclitaxel', 'Inyectable', '300 mg/50 ml', 'L01CD01', 'R', 1034.000000, NULL, true, NULL),
(578, 'N0208', 'N', '2', '8', 'Paracetamol (Acetaminofeno)', 'Comprimido', '500 mg', 'N02BE01', NULL, 0.214052, NULL, true, NULL),
(579, 'N0209', 'N', '2', '9', 'Paracetamol (Acetaminofeno)', 'Jarabe', '120 mg/5 ml o 125 mg/5 ml', 'N02BE01', NULL, 10.735377, NULL, true, NULL),
(580, 'N0210', 'N', '2', '10', 'Paracetamol (Acetaminofeno)', 'Gotas', '100 mg/ml', 'N02BE01', NULL, 6.951715, '15 ml', true, NULL),
(581, 'N0211', 'N', '2', '11', 'Paracetamol (Acetaminofeno)', 'Supositorio', '100 mg', 'N02BE01', NULL, 1.760000, NULL, true, NULL),
(582, 'N0212', 'N', '2', '12', 'Paracetamol (Acetaminofeno)', 'Comprimido', '100 mg', 'N02BE01', NULL, 0.300000, NULL, true, NULL),
(583, 'N0218', 'N', '2', '18', 'Paracetamol (Acetaminofeno)', 'Inyectable', '1 gr', 'N02BE01', NULL, 74.455000, '1000Mg/100ml', true, NULL),
(584, 'L0157', 'L', '1', '57', 'Pazopanib', 'Comprimido', '200 mg', 'L01XE11', 'R', 278.830000, NULL, true, NULL),
(585, 'L0161', 'L', '1', '61', 'Pegaspargasa', 'Plegable Frasco Vial', '750 mg/ml', 'L01XX24', 'R', 8765.310000, NULL, true, NULL),
(586, 'M0108', 'M', '1', '8', 'Penicilamina', 'Comprimido', '250 mg', 'M01CC01', NULL, 13.040000, NULL, true, NULL),
(587, 'P0112', 'P', '1', '12', 'Pentamidina', 'Inyectable', '200 mg', 'P01CX01', NULL, 503.590000, NULL, true, NULL),
(588, 'P0113', 'P', '1', '13', 'Pentamidina', 'Inyectable', '300 mg', 'P01CX01', NULL, 816.690000, NULL, true, NULL),
(589, 'P0302', 'P', '3', '2', 'Permetrina', 'LociÃ³n', '0.01', 'P03AC04', NULL, 28.430000, NULL, true, NULL),
(590, 'P0303', 'P', '3', '3', 'Permetrina', 'Crema o Pomada', '0.05', 'P03AC04', NULL, 61.230000, NULL, true, NULL),
(591, 'D1002', 'D', '10', '2', 'PerÃ³xido de BenzoÃ­lo', 'LociÃ³n', '0.05', 'D10AE01', NULL, 85.110000, NULL, true, NULL),
(592, 'D1003', 'D', '10', '3', 'PerÃ³xido de BenzoÃ­lo', 'Crema, Pomada o Gel', '0.05', 'D10AE01', NULL, 64.800000, '90 g', true, NULL),
(593, 'D0810', 'D', '8', '10', 'PerÃ³xido de hidrÃ³geno (Agua oxigenada)', 'SoluciÃ³n', '2% o 3%', 'D08AX01', NULL, 16.390000, '1 L', true, NULL),
(594, 'L0158', 'L', '1', '58', 'Pertuzumab', 'Inyectable', '420 mg/14 ml', 'L01XC13', 'R', 28476.100000, NULL, true, NULL),
(595, 'N0213', 'N', '2', '13', 'Petidina (Meperidina)', 'Inyectable', '100 mg', 'N02AB02', NULL, 50.310000, '2 ml', true, NULL),
(596, 'J0175', 'J', '1', '75', 'Piperacilina + Tazobactam', 'Inyectable', '4 g/500 mg', 'J01CR05', 'R', 108.000000, NULL, true, NULL),
(597, 'P0207', 'P', '2', '7', 'Pirantel pamoato', 'Comprimido', '250 mg', 'P02CC01', NULL, 2.160000, NULL, true, NULL),
(598, 'P0208', 'P', '2', '8', 'Pirantel pamoato', 'SuspensiÃ³n', '250 mg/5 ml', 'P02CC01', NULL, 15.090000, '15 ml', true, NULL),
(599, 'J0408', 'J', '4', '8', 'Pirazinamida', 'Comprimido', '500 mg', 'J04AK01', 'R', 0.292381, NULL, true, NULL),
(600, 'J0427', 'J', '4', '27', 'Pirazinamida', 'Comprimido dispersable', '150 mg', 'J04AK01', 'R', 0.630000, NULL, true, NULL),
(601, 'N0706', 'N', '7', '6', 'Piridostigmina', 'Comprimido', '60 mg', 'N07AA02', NULL, 5.500000, NULL, true, NULL),
(602, 'A1111', 'A', '11', '11', 'Piridoxina clorhidrato (Vitamina B6)', 'Comprimido', '300 mg', 'A11HA02', NULL, 3.065000, NULL, true, NULL),
(603, 'A1112', 'A', '11', '12', 'Piridoxina clorhidrato (Vitamina B6)', 'Inyectable', '300 mg', 'A11HA02', NULL, 5.100000, NULL, true, NULL),
(604, 'P0114', 'P', '1', '14', 'Pirimetamina', 'Comprimido', '25 mg', 'P01BD01', NULL, 0.210000, NULL, true, NULL),
(605, 'P0209', 'P', '2', '9', 'Prazicuantel', 'Comprimido', '600 mg', 'P02BA01', NULL, 3.600000, NULL, true, NULL),
(606, 'H0208', 'H', '2', '8', 'Prednisona', 'Comprimido', '5 mg', 'H02AB07', NULL, 0.608092, NULL, true, NULL),
(607, 'H0209', 'H', '2', '9', 'Prednisona', 'Comprimido ranurado', '20 mg', 'H02AB07', NULL, 1.136603, NULL, true, NULL),
(608, 'H0210', 'H', '2', '10', 'Prednisona', 'SuspensiÃ³n', '1 mg/ml', 'H02AB07', NULL, 53.710000, '100 ml', true, NULL),
(609, 'N0319', 'N', '3', '19', 'Pregabalina', 'Comprimido o CÃ¡psula', '50 mg', 'N03AX16', 'R', 6.540000, NULL, true, NULL),
(610, 'N0320', 'N', '3', '20', 'Pregabalina', 'Comprimido o CÃ¡psula', '75 mg', 'N03AX16', 'R', 9.489848, NULL, true, NULL),
(611, 'N0321', 'N', '3', '21', 'Pregabalina', 'Comprimido o CÃ¡psula', '150 mg', 'N03AX16', 'R', 19.570000, NULL, true, NULL),
(612, 'P0115', 'P', '1', '15', 'Primaquina (base)', 'Comprimido', '15 mg', 'P01BA03', NULL, 0.164026, NULL, true, NULL),
(613, 'P0116', 'P', '1', '16', 'Primaquina (base)', 'SuspensiÃ³n', '15 mg/5 ml', 'P01BA03', NULL, 31.590000, NULL, true, NULL),
(614, 'P0120', 'P', '1', '20', 'Primaquina (base)', 'Comprimido', '5 mg', 'P01BA03', NULL, 0.120000, NULL, true, NULL),
(615, 'G0322', 'G', '3', '22', 'Progesterona', 'CÃ¡psula', '200 mg', 'G03DA04', NULL, 7.770000, NULL, true, NULL),
(616, 'H0302', 'H', '3', '2', 'Propiltiouracilo', 'Comprimido', '50 mg', 'H03BA02', NULL, 1.960000, NULL, true, NULL),
(617, 'A0310', 'A', '3', '10', 'Propinoxato', 'Comprimido', '10 mg', 'A03AC**', NULL, 2.555000, NULL, true, NULL),
(618, 'A0311', 'A', '3', '11', 'Propinoxato', 'Inyectable', '5 mg/ml', 'A03AC**', NULL, 8.590000, '2 ml', true, NULL),
(619, 'N0113', 'N', '1', '13', 'Propofol', 'Inyectable', '10 mg/ml', 'N01AX10', NULL, 73.939617, '20 ml', true, NULL),
(620, 'C0702', 'C', '7', '2', 'Propranolol', 'Comprimido', '40 mg', 'C07AA05', NULL, 0.330000, NULL, true, NULL),
(621, 'C0703', 'C', '7', '3', 'Propranolol', 'Inyectable', '1 mg/ml', 'C07AA05', NULL, 37.660000, NULL, true, NULL),
(622, 'V0313', 'V', '3', '13', 'Protamina Sulfato', 'Inyectable', '10 mg/ml', 'V03AB14', NULL, 157.500000, NULL, true, NULL),
(623, 'V0601', 'V', '6', '1', 'Proteinas para alimentaciÃ³n enteral (alimento)', 'Polvo', 'SegÃºn disponibilidad', 'V06DB**', NULL, 126.751108, NULL, true, NULL),
(624, 'S0120', 'S', '1', '20', 'Proximetacaina (Proparacaina)', 'SoluciÃ³n oftÃ¡lmica', '0,5%', 'S01HA04', NULL, 125.938000, NULL, true, NULL),
(625, 'N0518', 'N', '5', '18', 'Quetiapina', 'Comprimido', '100 mg', 'N05AH04', 'R', 10.420000, NULL, true, NULL),
(626, 'P0117', 'P', '1', '17', 'Quinina (bisulfato o sulfato)', 'Comprimido', '300 mg', 'P01BC01', NULL, 0.830000, NULL, true, NULL),
(627, 'P0118', 'P', '1', '18', 'Quinina (diclorhidrato)', 'Inyectable', '600 mg', 'P01BC01', NULL, 27.510000, NULL, true, NULL),
(628, 'N0116', 'N', '1', '16', 'Remifentanilo', 'Inyectable', '5 mg', 'N01AH06', NULL, 147.287385, NULL, true, NULL),
(629, 'D0601', 'D', '6', '1', 'Resina de Podofilo (Podofilina)', 'SoluciÃ³n tÃ³pica', '10% o 25%', 'D06BB04', NULL, 35.000000, '25% 15ml', true, NULL),
(630, 'D1004', 'D', '10', '4', 'Resorcinol', 'Crema o Pomada', '0.1', 'D10AX02', NULL, 22.670000, '10 g', true, NULL),
(631, 'A1113', 'A', '11', '13', 'Retinol (Vitamina A)', 'CÃ¡psula o Perla', '10.000 UI', 'A11CA01', NULL, 0.800000, NULL, true, NULL),
(632, 'A1114', 'A', '11', '14', 'Retinol (Vitamina A)', 'CÃ¡psula o Perla', '25.000 UI', 'A11CA01', NULL, 0.890000, NULL, true, NULL),
(633, 'A1115', 'A', '11', '15', 'Retinol (Vitamina A)', 'CÃ¡psula o Perla', '100.000 UI', 'A11CA01', NULL, 1.460000, NULL, true, NULL),
(634, 'A1116', 'A', '11', '16', 'Retinol (Vitamina A)', 'CÃ¡psula o Perla', '200.000 UI', 'A11CA01', NULL, 1.175894, NULL, true, NULL),
(635, 'J0409', 'J', '4', '9', 'Rifampicina', 'SuspensiÃ³n', '100 mg/5 ml', 'J04AB02', NULL, 28.600000, NULL, true, NULL),
(636, 'J0410', 'J', '4', '10', 'Rifampicina', 'CÃ¡psula o Comprimido', '300 mg', 'J04AB02', NULL, 1.730000, NULL, true, NULL),
(637, 'J0417', 'J', '4', '17', 'Rifampicina', 'CÃ¡psula o Comprimido', '150 mg', 'J04AB02', 'R', 1.250000, NULL, true, NULL),
(638, 'J0428', 'J', '4', '28', 'Rifampicina', 'SoluciÃ³n oral', '20 mg/ml', 'J04AB02', 'R', 48.300000, NULL, true, NULL),
(639, 'J0429', 'J', '4', '29', 'Rifampicina + Isoniazida', 'Comprimido dispersable', '75 mg + 50 mg', 'J04AM02', 'R', 0.360000, NULL, true, NULL),
(640, 'J0414', 'J', '4', '14', 'Rifampicina + Isoniazida (INH)', 'Comprimido', '300 mg + 150 mg', 'J04AM02', 'R', 0.244026, NULL, true, NULL),
(641, 'J0422', 'J', '4', '22', 'Rifampicina, Clofazimina, Dapsona', 'Comprimido', '300 mg + 50 mg + 50 mg', '104BA', 'R', 13.400000, NULL, true, NULL),
(642, 'J0423', 'J', '4', '23', 'Rifampicina, Clofazimina, Dapsona', 'Comprimido', '300 mg + 100 mg + 100 mg', 'J04BA', 'R', 22.220000, NULL, true, NULL),
(643, 'J0420', 'J', '4', '20', 'Rifampicina, Dapsona', 'Comprimido', '300 mg + 50 mg', 'J04BA', 'R', 2.000000, NULL, true, NULL),
(644, 'J0421', 'J', '4', '21', 'Rifampicina, Dapsona', 'Comprimido', '300 mg + 100 mg', 'J04BA', 'R', 1.990000, NULL, true, NULL),
(645, 'N0512', 'N', '5', '12', 'Risperidona', 'Comprimido', '3 mg', 'N05AX08', NULL, 4.980000, NULL, true, NULL),
(646, 'J0522', 'J', '5', '22', 'Ritonavir', 'CÃ¡psula blanda', '100 mg', 'J05AE03', NULL, 17.860000, NULL, true, NULL),
(647, 'L0141', 'L', '1', '41', 'Rituximab', 'Inyectable', '500 mg/50 ml', 'L01XC02', 'R', 9393.850000, NULL, true, NULL),
(648, 'L0156', 'L', '1', '56', 'Rituximab', 'Inyectable', '100 mg/10ml', 'L01XC02', 'R', 4500.000000, NULL, true, NULL),
(649, 'B0107', 'B', '1', '7', 'RivaroxabÃ¡n', 'Comprimido', '10 mg', 'B01AX06', 'R', 20.670000, NULL, true, NULL),
(650, 'M0303', 'M', '3', '3', 'Rocuronio bromuro', 'Inyectable', '10 mg/ml', 'M03AC09', NULL, 79.702500, NULL, true, NULL),
(651, 'C1003', 'C', '10', '3', 'Rosuvastatina', 'Comprimido', '20 mg', 'C10AA07', NULL, 12.020000, NULL, true, NULL),
(652, 'R0304', 'R', '3', '4', 'Salbutamol', 'SoluciÃ³n para nebulizaciÃ³n', '5 mg/ml', 'R03AC02', NULL, 54.128827, NULL, true, NULL),
(653, 'R0305', 'R', '3', '5', 'Salbutamol', 'Comprimido', '4 mg', 'R03CC02', NULL, 0.710000, NULL, true, NULL),
(654, 'R0306', 'R', '3', '6', 'Salbutamol', 'Aerosol', '0,1 mg/inhalaciÃ³n', 'R03AC02', NULL, 21.030967, '200 dÃ³sis', true, NULL),
(655, 'A0706', 'A', '7', '6', 'Sales de rehidrataciÃ³n oral (SRO) baja osmolaridad', 'Sobres', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'A07CA**', NULL, 2.482455, NULL, true, NULL),
(656, 'R0311', 'R', '3', '11', 'Salmeterol + Fluticasona', 'Aerosol', '25 mcg + 125 mcg', 'R03AK06', NULL, 161.342165, '120 dÃ³sis', true, NULL),
(657, 'N0114', 'N', '1', '14', 'Sevoflurano (Trifluorometil etil)', 'SoluciÃ³n', '250 ml', 'N01AB08', NULL, 1930.000000, NULL, true, NULL),
(658, 'C0208', 'C', '2', '8', 'Sildenafilo', 'Comprimido', '50 mg', 'C02KX', NULL, 4.720000, NULL, true, NULL),
(659, 'A0312', 'A', '3', '12', 'Simeticona', 'SuspensiÃ³n', '3% o 4%', 'A03AX13', NULL, 22.350000, '30ml', true, NULL),
(660, 'A0313', 'A', '3', '13', 'Simeticona', 'Comprimido', '100 mg', 'A03AX13', NULL, 1.970000, NULL, true, NULL),
(661, 'J0541', 'J', '5', '41', 'Sofosbuvir', 'Comprimido', '400 mg', 'J05AX15', NULL, 380.510000, NULL, true, NULL),
(662, 'B0513', 'B', '5', '13', 'Solucion Acida', 'SoluciÃ³n', 'SegÃºn disponibilidad', 'B05Z**', NULL, 120.890000, '10 L', true, NULL),
(663, 'B0514', 'B', '5', '14', 'SoluciÃ³n BÃ¡sica', 'SoluciÃ³n', 'SegÃºn disponibilidad', 'B05Z**', NULL, 120.970000, '10 L', true, NULL),
(664, 'B0515', 'B', '5', '15', 'SoluciÃ³n de glucosa', 'SoluciÃ³n parenteral de gran volumen', '5% (500 ml)', 'B05CX01', NULL, 11.777005, NULL, true, NULL),
(665, 'B0516', 'B', '5', '16', 'SoluciÃ³n de glucosa', 'SoluciÃ³n parenteral de gran volumen', '5% (1.000 ml)', 'B05CX01', NULL, 13.440000, NULL, true, NULL),
(666, 'B0517', 'B', '5', '17', 'SoluciÃ³n de glucosa', 'SoluciÃ³n parenteral de gran volumen', '10% (500 ml)', 'B05CX01', NULL, 9.744752, NULL, true, NULL),
(667, 'B0518', 'B', '5', '18', 'SoluciÃ³n de glucosa', 'SoluciÃ³n parenteral de gran volumen', '10% (1.000 ml)', 'B05CX01', NULL, 10.694317, NULL, true, NULL),
(668, 'B0519', 'B', '5', '19', 'SoluciÃ³n de glucosa', 'SoluciÃ³n parenteral de gran volumen', '50% (500 ml)', 'B05CX01', NULL, 22.140563, NULL, true, NULL),
(669, 'B0520', 'B', '5', '20', 'SoluciÃ³n de glucosa', 'Inyectable', '50% (20 ml)', 'B05CX01', NULL, 6.760000, NULL, true, NULL),
(670, 'B0536', 'B', '5', '36', 'SoluciÃ³n de glucosa', 'SoluciÃ³n parenteral', '10% (250 ml)', 'B05CX01', NULL, 16.700000, NULL, true, NULL),
(671, 'B0521', 'B', '5', '21', 'SoluciÃ³n de Manitol', 'SoluciÃ³n parenteral de gran volumen', '20% (500 ml)', 'B05CX04', NULL, 23.900000, NULL, true, NULL),
(672, 'V0701', 'V', '7', '1', 'SoluciÃ³n de preservaciÃ³n de Ã³rganos sÃ²lidos HTK', 'SoluciÃ²n', 'SegÃºn disponibilidad', 'V07AB', 'R', 3904.000000, NULL, true, NULL),
(673, 'B0522', 'B', '5', '22', 'SoluciÃ³n FisiolÃ³gica', 'SoluciÃ³n parenteral de gran volumen', '0,9% (500 ml)', 'B05CB01', NULL, 10.407478, NULL, true, NULL),
(674, 'B0523', 'B', '5', '23', 'SoluciÃ³n FisiolÃ³gica', 'SoluciÃ³n parenteral de gran volumen', '0,9% (1.000 ml)', 'B05CB01', NULL, 10.710000, NULL, true, NULL),
(675, 'B0534', 'B', '5', '34', 'SoluciÃ³n FisiolÃ³gica', 'SoluciÃ³n parenteral', '0,9% (150 ml)', 'B05CB01', NULL, 10.610000, NULL, true, NULL),
(676, 'B0537', 'B', '5', '37', 'SoluciÃ³n FisiolÃ³gica', 'SoluciÃ³n parenteral', '0,9% (100 ml)', 'B05CB01', NULL, 7.050000, NULL, true, NULL),
(677, 'S0121', 'S', '1', '21', 'SoluciÃ³n FisiolÃ³gica', 'SoluciÃ³n Nasal', '0,9% (15 a 30 ml)', 'S01X**', NULL, 30.470000, '15 ml', true, NULL),
(678, 'B0524', 'B', '5', '24', 'SoluciÃ³n glucosada clorurada', 'SoluciÃ³n parenteral de gran volumen', '500 ml', 'B05CB10', NULL, 13.165000, NULL, true, NULL),
(679, 'B0525', 'B', '5', '25', 'SoluciÃ³n glucosada clorurada', 'SoluciÃ³n parenteral de gran volumen', '1.000 ml', 'B05CB10', NULL, 10.540000, '1.000 ml', true, NULL),
(680, 'B0535', 'B', '5', '35', 'SoluciÃ³n para diÃ¡lisis intraperitoneal (de acuerdo a composiciÃ³n apropiada)', 'SoluciÃ³n parenteral', 'SegÃºn disponibilidad', 'B05D**', 'R', 155.680000, '123.24Bs (2000 ml) 155,68Bs (6000 ml)', true, NULL),
(681, 'B0526', 'B', '5', '26', 'SoluciÃ³n para dialisis peritoneal I', 'SoluciÃ³n parenteral de gran volumen', '1.000 ml', 'B05DB**', NULL, 14.735000, NULL, true, NULL),
(682, 'B0527', 'B', '5', '27', 'SoluciÃ³n para dialisis peritoneal II', 'SoluciÃ³n parenteral de gran volumen', '1.000 ml', 'B05DB**', NULL, 18.430000, NULL, true, NULL),
(683, 'B0529', 'B', '5', '29', 'SoluciÃ³n ringer lactato', 'SoluciÃ³n parenteral de gran volumen', '500 ml', 'B05XA30', NULL, 10.046115, NULL, true, NULL),
(684, 'B0530', 'B', '5', '30', 'SoluciÃ³n ringer lactato', 'SoluciÃ³n parenteral de gran volumen', '1.000 ml', 'B05XA30', NULL, 13.520000, NULL, true, NULL),
(685, 'B0531', 'B', '5', '31', 'SoluciÃ³n ringer normal', 'SoluciÃ³n parenteral de gran volumen', '500 ml', 'B05XA30', NULL, 10.395000, NULL, true, NULL),
(686, 'B0532', 'B', '5', '32', 'SoluciÃ³n ringer normal', 'SoluciÃ³n parenteral de gran volumen', '1.000 ml', 'B05XA30', NULL, 13.896620, NULL, true, NULL),
(687, 'H0104', 'H', '1', '4', 'Somatropina', 'Inyectable', '4UI (1,33 mg)', 'H01AC01', 'R', NULL, NULL, false, 'precio no numerico o ausente'),
(688, 'A0207', 'A', '2', '7', 'Sucralfato', 'SuspensiÃ³n', '1g/5 ml', 'A02BX02', NULL, 105.055000, '200 ml', true, NULL),
(689, 'J0610', 'J', '6', '10', 'Suero Antiescorpionico', 'Inyectable', 'SegÃºn disponibilidad', 'J06B**', NULL, 224.000000, NULL, true, NULL),
(690, 'J0606', 'J', '6', '6', 'Suero Antilatrodectus', 'Inyectable', 'SegÃºn disponibilidad', 'J06****', NULL, 160.000000, NULL, true, NULL),
(691, 'J0607', 'J', '6', '7', 'Suero AntiofÃ­dico BotrÃ³pico CrotÃ lico', 'Inyectable', 'SegÃºn disponibilidad', 'J06AA03', NULL, 211.000000, NULL, true, NULL),
(692, 'J0608', 'J', '6', '8', 'Suero AntiofÃ­dico BotrÃ³pico LaquÃ©sico', 'Inyectable', 'SegÃºn disponibilidad', 'J06AA03', NULL, 211.000000, NULL, true, NULL),
(693, 'J0609', 'J', '6', '9', 'Suero AntirrÃ bico (heterÃ³logo)', 'Inyectable', 'SegÃºn disponibilidad', 'J06AA06', NULL, 138.000000, NULL, true, NULL),
(694, 'D0602', 'D', '6', '2', 'Sulfadiazina de plata', 'Crema o Pomada', '0.01', 'D06BA01', NULL, 48.100000, '60 g Bs 48.10. 500 g Bs 202', true, NULL),
(695, 'P0119', 'P', '1', '19', 'Sulfadoxina + Pirimetamina', 'Comprimido', '500 mg + 25 mg', 'P01BD51', NULL, 0.320000, NULL, true, NULL),
(696, 'V0808', 'V', '8', '8', 'Sulfato de Bario', 'SuspensiÃ³n', 'SegÃºn disponibilidad', 'V08BA02', NULL, 235.000000, NULL, true, NULL),
(697, 'V0809', 'V', '8', '9', 'Sulfato de Bario', 'Polvo para enema', 'SegÃºn disponibilidad', 'V08BA02', NULL, 280.750000, NULL, true, NULL),
(698, 'A0608', 'A', '6', '8', 'Sulfato de Magnesio', 'Granulado', '20 g a 30 g', 'A06AD04', NULL, 2.080000, '30 g', true, NULL),
(699, 'B0533', 'B', '5', '33', 'Sulfato de Magnesio', 'Inyectable', '0.1', 'B05XA05', NULL, 5.200000, '10 ml', true, NULL),
(700, 'B0306', 'B', '3', '6', 'Sulfato ferroso', 'Comprimido', '200 mg', 'B03AA07', NULL, 0.370000, NULL, true, NULL),
(701, 'B0307', 'B', '3', '7', 'Sulfato ferroso', 'SoluciÃ³n oral', '125 mg/ml', 'B03AA07', NULL, 12.860000, NULL, true, NULL),
(702, 'B0308', 'B', '3', '8', 'Sulfato ferroso + Ac. FÃ³lico + Vitamina C', 'Comprimido', '200 mg + 0,5 mg + 150 mg', 'B03AE10', NULL, 0.450000, NULL, true, NULL),
(703, 'B0309', 'B', '3', '9', 'Sulfato ferroso + Ac. FÃ³lico + Vitamina C', 'SoluciÃ³n oral', '125 mg + 0,25 mg + 30 mg', 'B03AE10', NULL, 7.470000, '30 ml', true, NULL),
(704, 'R0701', 'R', '7', '1', 'Surfactante pulmonar', 'Inyectable', '25 a 35 mg/ml', 'R07AA02', NULL, 2886.015000, NULL, true, NULL),
(705, 'M0304', 'M', '3', '4', 'Suxametonio (Succinil colina)', 'Inyectable', '500 mg', 'M03AB01', NULL, 82.880000, NULL, true, NULL),
(706, 'L0410', 'L', '4', '10', 'Tacrolimus', 'CÃ¡psula', '1 mg', 'L04AA05', 'R', 10.091444, NULL, true, NULL),
(707, 'L0408', 'L', '4', '8', 'Talidomida', 'Comprimido', '100 mg', 'L04AX02', 'R', 16.133333, NULL, true, NULL),
(708, 'L0205', 'L', '2', '5', 'Tamoxifeno', 'Comprimido', '20 mg', 'L02BA01', NULL, 4.320000, NULL, true, NULL),
(709, 'C0905', 'C', '9', '5', 'TelmisartÃ¡n', 'Comprimido', '40 mg', 'C09CA07', NULL, 6.180000, NULL, true, NULL),
(710, 'C0906', 'C', '9', '6', 'TelmisartÃ¡n', 'comprimido', '80 mg', 'C09CA07', NULL, 6.910000, NULL, true, NULL),
(711, 'C0907', 'C', '9', '7', 'Telmisartan + hidroclorotiazida', 'Comprimido', '40 mg + 12.5 mg', 'C09DA07', NULL, 7.850000, NULL, true, NULL),
(712, 'C0908', 'C', '9', '8', 'Telmisartan + hidroclorotiazida', 'Comprimido', '80 mg + 12.5 mg', 'C09DA07', NULL, 9.200000, NULL, true, NULL),
(713, 'C0909', 'C', '9', '9', 'Telmisartan + hidroclorotiazida', 'Comprimido', '80 mg + 25 mg', 'C09DA07', NULL, 11.140000, NULL, true, NULL),
(714, 'L0151', 'L', '1', '51', 'Temozolomida', 'CÃ¡psula', '20 mg', 'L01AX03', 'R', 105.730000, NULL, true, NULL),
(715, 'L0152', 'L', '1', '52', 'Temozolomida', 'CÃ¡psula', '100 mg', 'L01AX04', 'R', 286.745977, NULL, true, NULL),
(716, 'L0153', 'L', '1', '53', 'Temozolomida', 'CÃ¡psula', '250 mg', 'L01AX05', 'R', 858.000000, NULL, true, NULL),
(717, 'B0108', 'B', '1', '8', 'Tenecteplasa', 'Polvo para Inyectable', '50 mg', 'B01AD11', 'R', 6626.770000, NULL, true, NULL),
(718, 'J0554', 'J', '5', '54', 'Tenofovir disoproxil fumarate + Lamivudine', 'Comprimido recubierto', '300 mg + 300 mg', 'J05AR12', NULL, 0.660000, NULL, true, NULL),
(719, 'J0528', 'J', '5', '28', 'Tenofovir disoproxilo', 'Comprimido', '245 mg (Equiv. a 300 mg como fumarato)', 'J05AF07', NULL, 2.360000, NULL, true, NULL),
(720, 'R0308', 'R', '3', '8', 'Teofilina', 'Comprimido', '300 mg', 'R03DA04', NULL, 4.313333, NULL, true, NULL),
(721, 'D0108', 'D', '1', '8', 'Terbinafina', 'Comprimido', '250 mg', 'D01AE15', NULL, 19.750000, NULL, true, NULL),
(722, 'H0103', 'H', '1', '3', 'Terlipresina', 'Inyectable', '1 mg', 'H01BA04', 'R', 875.160000, NULL, true, NULL),
(723, 'G0318', 'G', '3', '18', 'Testosterona undecanoato', 'Inyectable', '1.000 mg', 'G03BA03', NULL, 1520.650000, NULL, true, NULL),
(724, 'J0154', 'J', '1', '54', 'Tetraciclina', 'CÃ¡psula o Comprimido', '500 mg', 'J01AA07', NULL, 1.300000, NULL, true, NULL),
(725, 'D0105', 'D', '1', '5', 'Tiabendazol', 'Crema o Pomada', '0.05', 'D01AC06', NULL, 15.370000, '20 g', true, NULL),
(726, 'P0210', 'P', '2', '10', 'Tiabendazol', 'Comprimido', '500 mg', 'P02CA02', NULL, 2.100000, NULL, true, NULL),
(727, 'P0211', 'P', '2', '11', 'Tiabendazol', 'SuspensiÃ³n', '500 mg/5 ml', 'P02CA02', NULL, 24.000000, '30 ml', true, NULL),
(728, 'H0304', 'H', '3', '4', 'Tiamazol (Metimazol)', 'Comprimido', '20 mg', 'H03BB02', NULL, 2.619250, NULL, true, NULL),
(729, 'A1117', 'A', '11', '17', 'Tiamina (Vitamina B 1)', 'Comprimido', '300 mg', 'A11DA01', NULL, 1.585937, NULL, true, NULL),
(730, 'A1118', 'A', '11', '18', 'Tiamina (Vitamina B 1)', 'Inyectable', '100 mg/ml', 'A11DA01', NULL, 3.040000, NULL, true, NULL),
(731, 'S0122', 'S', '1', '22', 'Timolol maleato', 'SoluciÃ³n oftÃ¡lmica', '0,5%', 'S01ED01', NULL, 41.821781, NULL, true, NULL),
(732, 'N0115', 'N', '1', '15', 'Tiopental sÃ³dico', 'Inyectable', '1 g', 'N01AF03', NULL, 36.848222, NULL, true, NULL),
(733, 'N0513', 'N', '5', '13', 'Tioridazina', 'SuspensiÃ³n', '100 mg/5 ml', 'N05AC02', NULL, 33.710000, NULL, true, NULL),
(734, 'N0514', 'N', '5', '14', 'Tioridazina', 'Comprimido', '100 mg', 'N05AC02', NULL, 4.200000, NULL, true, NULL),
(735, 'A1119', 'A', '11', '19', 'Tocoferol (Vitamina E)', 'CÃ¡psula blanda', '1.000 UI', 'A11HA03', NULL, 2.577188, NULL, true, NULL),
(736, 'J0701', 'J', '7', '1', 'Toxoide tetÃ¡nico adsorbido', 'Inyectable', '120 UI/ml', 'J07AM01', NULL, 42.000000, NULL, true, NULL),
(737, 'N0215', 'N', '2', '15', 'Tramadol', 'Comprimido', '50 mg', 'N02AX02', NULL, 3.740000, NULL, true, NULL),
(738, 'N0214', 'N', '2', '14', 'Tramadol', 'Inyectable', '100 mg/2 ml', 'N02AX02', NULL, 9.455000, NULL, true, NULL),
(739, 'N0217', 'N', '2', '17', 'Tramadol', 'SoluciÃ³n para gotas orales', '100 mg/ml', 'N02AX02', NULL, 96.662374, NULL, true, NULL),
(740, 'L0142', 'L', '1', '42', 'Trastuzumab', 'Inyectable', '440 mg', 'L01XC03', 'R', 9000.000000, '20 ml', true, NULL),
(741, 'L0143', 'L', '1', '43', 'Trastuzumab', 'Inyectable', '600 mg', 'L01XC03', 'R', 19539.700000, '5 ml', true, NULL),
(742, 'P0212', 'P', '2', '12', 'Triclabendazol', 'Comprimido', '250 mg', 'P02BX04', NULL, 343.150000, NULL, true, NULL),
(743, 'L0207', 'L', '2', '7', 'Triptorelina', 'Inyectable', '11,25 mg', 'L02AE04', NULL, 4759.180000, NULL, true, NULL),
(744, 'L0208', 'L', '2', '8', 'Triptorelina', 'Inyectable', '22,5 mg', 'L02AE04', 'R', 8720.844500, NULL, true, NULL),
(745, 'D0301', 'D', '3', '1', 'Trolamina', 'EmulsiÃ³n dermica', '0,67%', 'D03AX12', 'R', 183.000000, NULL, true, NULL),
(746, 'S0123', 'S', '1', '23', 'Tropicamida', 'SoluciÃ³n oftÃ¡lmica', '0.01', 'S01FA06', NULL, 86.330000, NULL, true, NULL),
(747, 'D0203', 'D', '2', '3', 'UngÃ¼ento dÃ©rmico eucalipto mentol', 'UngÃ¼ento o crema', 'SegÃºn disponibilidad', 'D02AX**', NULL, 7.990000, NULL, true, NULL),
(748, 'J0702', 'J', '7', '2', 'Vacuna antiamarÃ­lica', 'Inyectable', 'Norma PAI (20 dosis)', 'J07BL01', NULL, 10.140000, NULL, true, NULL),
(749, 'J0703', 'J', '7', '3', 'Vacuna antiamarÃ­lica', 'Inyectable', 'Norma PAI (10 dosis)', 'J07BL01', NULL, 9.890000, NULL, true, NULL),
(750, 'J0704', 'J', '7', '4', 'Vacuna antiamarÃ­lica', 'Inyectable', 'Norma PAI (5 dosis)', 'J07BL01', NULL, 8.750000, NULL, true, NULL),
(751, 'J0705', 'J', '7', '5', 'Vacuna antihepatitis B', 'Inyectable', 'Norma PAI', 'J07BC01', NULL, 2.960000, NULL, true, NULL),
(752, 'J0722', 'J', '7', '22', 'Vacuna antineumococo (13 valente)', 'Inyectable', 'Norma PAI (Unidosis)', 'J07AL02', NULL, 98.997600, NULL, true, NULL),
(753, 'J0723', 'J', '7', '23', 'Vacuna antipoliomielÃ­tica bivalente', 'SoluciÃ³n oral', 'Norma PAI', 'J07BF04', NULL, 1.130000, NULL, true, NULL),
(754, 'J0724', 'J', '7', '24', 'Vacuna antipoliomielÃ­tica inactivada', 'Inyectable', 'Norma PAI', 'J07BF03', NULL, 17.220000, NULL, true, NULL),
(755, 'J0718', 'J', '7', '18', 'Vacuna AntirotavÃ­rica', 'SoluciÃ³n oral', 'Norma PAI Multidosis', 'J07BH01', NULL, 66.530000, NULL, true, NULL),
(756, 'J0719', 'J', '7', '19', 'Vacuna AntirotavÃ­rica', 'SoluciÃ³n oral', 'Norma PAI (Unidosis)', 'J07BH01', NULL, 58.930000, NULL, true, NULL),
(757, 'J0708', 'J', '7', '8', 'Vacuna AntirrÃ¡bica', 'Inyectable', '1 UI/ml', 'J07BG01', NULL, 54.250000, '10 dÃ³sis', true, NULL),
(758, 'J0725', 'J', '7', '25', 'Vacuna AntirrÃ¡bica de uso Humano (Cultivo Celular)', 'Inyectable', '2,5 U.I./0,5 ml', 'J07BG01', NULL, 382.500000, NULL, true, NULL),
(759, 'J0711', 'J', '7', '11', 'Vacuna BCG', 'Inyectable', 'Norma PAI', 'J07AN01', NULL, 1.310000, NULL, true, NULL),
(760, 'J0727', 'J', '7', '27', 'Vacuna contra COVID-19', 'Inyectable', 'Norma PAI', 'J07BX03', NULL, NULL, NULL, false, 'precio no numerico o ausente'),
(761, 'J0721', 'J', '7', '21', 'Vacuna contra Influenza (Adulto)', 'Inyectable', 'Norma PAI (10 dosis)', 'J07BB', NULL, 25.380000, NULL, true, NULL),
(762, 'J0720', 'J', '7', '20', 'Vacuna contra Influenza (PediÃ¡trica)', 'Inyectable', 'Norma PAI (10 dosis)', 'J07BB', NULL, 19.796400, NULL, true, NULL),
(763, 'J0726', 'J', '7', '26', 'Vacuna cuadrivalente recombinante contra el Virus del Papiloma Humano', 'Inyectable', 'Norma PAI', 'J07BM01', NULL, 40.790000, NULL, true, NULL),
(764, 'J0712', 'J', '7', '12', 'Vacuna doble dT (difteria, TÃ©tanos)', 'Inyectable', 'Norma PAI', 'J07AM51', NULL, 1.000000, NULL, true, NULL),
(765, 'J0713', 'J', '7', '13', 'Vacuna pentavalente (DPT + Hep. B + H. Influenzae B)', 'Inyectable', 'Norma PAI', 'J07X**', NULL, 19.040000, NULL, true, NULL),
(766, 'J0714', 'J', '7', '14', 'Vacuna SR (SarampiÃ³n, Rubeola)', 'Inyectable', 'Norma PAI', 'J07BD53', NULL, 20.400000, NULL, true, NULL),
(767, 'J0715', 'J', '7', '15', 'Vacuna SRP (SarampiÃ³n, Rubeola; Paperas)', 'Inyectable', 'Norma PAI Multidosis', 'J07BD01', NULL, 11.660000, NULL, true, NULL),
(768, 'J0716', 'J', '7', '16', 'Vacuna SRP (SarampiÃ³n, Rubeola; Paperas)', 'Inyectable', 'Norma PAI (Unidosis)', 'J07BD01', NULL, 21.480000, NULL, true, NULL),
(769, 'J0717', 'J', '7', '17', 'Vacuna Triple DPT (Difteria, Pertusis, Tetanos)', 'Inyectable', 'Norma PAI', 'J07X**', NULL, 2.030000, NULL, true, NULL),
(770, 'J0529', 'J', '5', '29', 'Valganciclovir', 'Comprimido', '450 mg', 'J05AB14', 'R', 248.745000, NULL, true, NULL),
(771, 'J0155', 'J', '1', '55', 'Vancomicina', 'Inyectable', '500 mg', 'J01XA01', 'R', 26.589444, NULL, true, NULL),
(772, 'D0204', 'D', '2', '4', 'Vaselina liquida', 'SoluciÃ³n 1 l', 'SegÃºn disponibilidad', 'D02AC**', NULL, 68.470000, '1 L', true, NULL),
(773, 'D0205', 'D', '2', '5', 'Vaselina sÃ³lida', 'Pasta 1 kg', 'SegÃºn disponibilidad', 'D02AC**', NULL, 60.000000, NULL, true, NULL),
(774, 'C0804', 'C', '8', '4', 'Verapamilo', 'Comprimido', '80 mg', 'C08DA01', NULL, 0.600000, NULL, true, NULL),
(775, 'L0139', 'L', '1', '39', 'Vinblastina', 'Inyectable', '10 mg', 'L01CA01', NULL, 382.098521, NULL, true, NULL),
(776, 'L0130', 'L', '1', '30', 'Vincristina', 'Inyectable', '1 mg/ml', 'L01CA02', NULL, 115.960000, '1 ml', true, NULL),
(777, 'L0131', 'L', '1', '31', 'Vinorelbina', 'Inyectable', '50 mg', 'L01CA04', NULL, 1245.605000, NULL, true, NULL),
(778, 'D0107', 'D', '1', '7', 'Violeta de genciana (Cloruro de metilrosanilina)', 'SoluciÃ³n', '0.01', 'D01AE02', NULL, 4.655000, '30 ml', true, NULL),
(779, 'J0209', 'J', '2', '9', 'Voriconazol', 'Polvo para inyectable', '200 mg', 'J02AC03', 'R', 651.571077, NULL, true, NULL),
(780, 'B0105', 'B', '1', '5', 'Warfarina', 'Comprimido ranurado', '5 mg', 'B01AA03', NULL, 0.950000, NULL, true, NULL),
(781, 'J0524', 'J', '5', '24', 'Zidovudina', 'Inyectable', '10 mg/ml', 'J05AF01', NULL, 88.330000, NULL, true, NULL),
(782, 'J0525', 'J', '5', '25', 'Zidovudina', 'SuspensiÃ³n oral', '10 mg/ml', 'J05AF01', NULL, 42.065000, NULL, true, NULL),
(783, 'J0527', 'J', '5', '27', 'Zidovudina + Lamivudina', 'Comprimido', '300 mg + 150 mg', 'J05AF30', NULL, 1.480000, NULL, true, NULL),
(784, 'A1205', 'A', '12', '5', 'Zinc (como sulfato)', 'Jarabe', '20 mg/5 ml', 'A12CB01', NULL, 18.865716, NULL, true, NULL),
(785, 'A1206', 'A', '12', '6', 'Zinc (como sulfato)', 'Comprimido', '20 mg', 'A12CB01', NULL, 0.650000, NULL, true, NULL),
(787, '*FE DE ERRATAS : en el presente documento se ha identificado que no se especifico el uso restringuido en los siguientes medicamentos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 'codigo invalido o ausente; medicamento ausente; forma ausente; concentracion ausente; precio no numerico o ausente'),
(788, NULL, 'Co', 'di', 'go', 'Medicamento', 'Forma FarmacÃ©utica', 'ConcentraciÃ³n', 'Clasific. A.T.Q.', 'Uso Restrin- gido', NULL, 'AclaraciÃ³n de Particularidades', false, 'codigo invalido o ausente; precio no numerico o ausente'),
(789, NULL, 'J', '5', '50', 'Abacavir sulfato + Lamivudina', 'Comprimido dispersable', '120 mg + 60 mg', 'J05AR02', 'R', 0.630000, NULL, false, 'codigo invalido o ausente'),
(790, NULL, 'L', '2', '9', 'Abiraterona Acetato', 'Comprimido', '250 mg', 'L02BX03', 'R', 83.620000, NULL, false, 'codigo invalido o ausente'),
(791, NULL, 'V', '3', '17', 'Ãcido dimercaptosuccinico', 'Capsula', '100 mg', 'V03AX', 'R', 84.450000, NULL, false, 'codigo invalido o ausente'),
(792, NULL, 'J', '5', '51', 'Dolutegravir', 'Comprimido dispersable', '10 mg', 'J05AJ03', 'R', 0.330000, NULL, false, 'codigo invalido o ausente'),
(793, NULL, 'J', '5', '52', 'Dolutegravir', 'Comprimido dispersable', '50 mg', 'J05AJ03', 'R', 0.320000, NULL, false, 'codigo invalido o ausente'),
(794, NULL, 'J', '5', '53', 'Dolutegravir + Lamivudine + Tenofovir', 'Comprimido', '50 mg + 300 mg + 300 mg', 'J05AR27', 'R', 0.720000, NULL, false, 'codigo invalido o ausente'),
(795, NULL, 'J', '4', '24', 'Etambutol', 'Comprimido dispersable', '100 mg', 'J04AK02', 'R', 1.360000, NULL, false, 'codigo invalido o ausente'),
(796, NULL, 'J', '4', '25', 'Etambutol + Isoniazida + Pirazinamida + Rifampicina', 'Comprimido', '275 mg + 75 mg + 400 mg +150 mg', 'J04AM06', 'R', 1.130000, NULL, false, 'codigo invalido o ausente'),
(797, NULL, 'V', '6', '8', 'Formula Infantil', 'Polvo', 'SegÃºn concentraciÃ³n estÃ¡ndar', 'V06DF', 'R', 236.000000, NULL, false, 'codigo invalido o ausente'),
(798, NULL, 'J', '4', '26', 'Isoniazida', 'Comprimido dispersable', '100 mg', 'J04AC01', 'R', 0.670000, NULL, false, 'codigo invalido o ausente'),
(799, NULL, 'V', '3', '16', 'N-acetilcisteina', 'Polvo vÃ­a oral', '600 mg', 'V03AB23', 'R', 11.100000, NULL, false, 'codigo invalido o ausente'),
(800, NULL, 'V', '3', '15', 'N-acetilcisteina', 'Polvo vÃ­a oral', '200 mg', 'V03AB23', 'R', 8.500000, NULL, false, 'codigo invalido o ausente'),
(801, NULL, 'J', '4', '27', 'Pirazinamida', 'Comprimido dispersable', '150 mg', 'J04AK01', 'R', 0.630000, NULL, false, 'codigo invalido o ausente'),
(802, NULL, 'J', '4', '28', 'Rifampicina', 'SoluciÃ³n oral', '20 mg/ml', 'J04AB02', 'R', 48.300000, NULL, false, 'codigo invalido o ausente'),
(803, NULL, 'J', '4', '29', 'Rifampicina + Isoniazida', 'Comprimido dispersable', '75 mg + 50 mg', 'J04AM02', 'R', 0.360000, NULL, false, 'codigo invalido o ausente');

CREATE INDEX IF NOT EXISTS idx_seed_productos_csv_codigo ON seed_productos_csv_staging(codigo);
CREATE INDEX IF NOT EXISTS idx_seed_productos_csv_valido ON seed_productos_csv_staging(es_valido);

COMMIT;

SET search_path TO public;

-- ============================================================
-- FIN 28-seed-productos-csv-staging.sql
-- ============================================================


-- ============================================================
-- INICIO 29-seed-productos-csv-principios-activos.sql
-- ============================================================

-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================
SET search_path TO farmacia_bri, public;

BEGIN;

INSERT INTO principios_activos (nombre, descripcion, activo)
SELECT DISTINCT
       LEFT(TRIM(pa.nombre), 200) AS nombre,
       'Importado desde LINAME 2026-2027 CSV' AS descripcion,
       true AS activo
FROM seed_productos_csv_staging s
CROSS JOIN LATERAL regexp_split_to_table(s.medicamento, '[[:space:]]*\+[[:space:]]*') AS pa(nombre)
WHERE s.es_valido = true
  AND NULLIF(TRIM(pa.nombre), '') IS NOT NULL
ON CONFLICT (nombre) DO UPDATE
SET activo = true;

COMMIT;

SET search_path TO public;

-- ============================================================
-- FIN 29-seed-productos-csv-principios-activos.sql
-- ============================================================


-- ============================================================
-- INICIO 30-seed-productos-csv-productos.sql
-- ============================================================

-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================
SET search_path TO farmacia_bri, public;

BEGIN;

WITH categorias(nombre, descripcion) AS (
    VALUES
        ('AntiÃ¡cidos y Gastroprotectores', 'Equivalencia ATQ A: tracto alimentario y metabolismo'),
        ('Anticoagulantes y AntitrombÃ³ticos', 'Equivalencia ATQ B: sangre y Ã³rganos hematopoyÃ©ticos'),
        ('Cardiovascular', 'Equivalencia ATQ C: sistema cardiovascular'),
        ('DermatolÃ³gicos', 'Equivalencia ATQ D: medicamentos dermatolÃ³gicos'),
        ('Salud Reproductiva', 'Equivalencia ATQ G: sistema genitourinario y hormonas sexuales'),
        ('Hormonas y Corticoides', 'Equivalencia ATQ H: preparados hormonales sistÃ©micos'),
        ('AntibiÃ³ticos', 'Equivalencia ATQ J: antiinfecciosos de uso sistÃ©mico'),
        ('OncolÃ³gicos', 'Equivalencia ATQ L: antineoplÃ¡sicos e inmunomoduladores'),
        ('Sistema MusculoesquelÃ©tico', 'Equivalencia ATQ M: sistema musculoesquelÃ©tico'),
        ('PsicotrÃ³picos y Antidepresivos', 'Equivalencia ATQ N: sistema nervioso'),
        ('Antiparasitarios', 'Equivalencia ATQ P: antiparasitarios'),
        ('Broncodilatadores y AntiasmÃ¡ticos', 'Equivalencia ATQ R: sistema respiratorio'),
        ('OftalmolÃ³gicos', 'Equivalencia ATQ S: Ã³rganos de los sentidos'),
        ('Sueros y Electrolitos', 'Equivalencia ATQ V: varios')
)
INSERT INTO categorias_terapeuticas (nombre, descripcion, activo)
SELECT nombre, descripcion, true FROM categorias
ON CONFLICT (nombre) DO UPDATE
SET descripcion = EXCLUDED.descripcion,
    activo = true;

WITH formas AS (
    SELECT DISTINCT
           CASE
               WHEN lower(forma_farmaceutica) IN ('comprimido', 'comprimidos') THEN 'Tableta'
               WHEN lower(forma_farmaceutica) IN ('capsula', 'cÃ¡psula') THEN 'CÃ¡psula'
               WHEN lower(forma_farmaceutica) LIKE 'suspensiÃ³n%' THEN 'SuspensiÃ³n'
               WHEN lower(forma_farmaceutica) LIKE 'soluciÃ³n oral%' THEN 'SoluciÃ³n oral'
               WHEN lower(forma_farmaceutica) LIKE 'crema%' THEN 'Crema'
               WHEN lower(forma_farmaceutica) LIKE 'pomada%' THEN 'Pomada'
               WHEN lower(forma_farmaceutica) LIKE 'jarabe%' THEN 'Jarabe'
               WHEN lower(forma_farmaceutica) LIKE 'gel%' THEN 'Gel'
               WHEN lower(forma_farmaceutica) LIKE 'colirio%' THEN 'Colirio'
               ELSE LEFT(forma_farmaceutica, 200)
           END AS nombre
    FROM seed_productos_csv_staging
    WHERE es_valido = true
)
INSERT INTO formas_farmaceuticas (nombre, descripcion, activo)
SELECT nombre, 'Forma farmacÃ©utica importada/equivalente desde LINAME 2026-2027 CSV', true
FROM formas
WHERE NULLIF(nombre, '') IS NOT NULL
ON CONFLICT (nombre) DO UPDATE
SET activo = true;

WITH vias(nombre, descripcion) AS (
    VALUES ('Parenteral', 'AdministraciÃ³n inyectable cuando el CSV no diferencia IV, IM o SC')
)
INSERT INTO vias_administracion (nombre, descripcion, activo)
SELECT nombre, descripcion, true FROM vias
ON CONFLICT (nombre) DO UPDATE
SET descripcion = EXCLUDED.descripcion,
    activo = true;

WITH vias_csv AS (
    SELECT DISTINCT
           CASE
               WHEN lower(forma_farmaceutica) LIKE '%oftÃ¡lm%' OR lower(forma_farmaceutica) LIKE '%oftalm%' OR lower(forma_farmaceutica) LIKE '%colirio%' THEN 'OftÃ¡lmica'
               WHEN lower(forma_farmaceutica) LIKE '%Ã³tica%' OR lower(forma_farmaceutica) LIKE '%otica%' THEN 'Ã“tica'
               WHEN lower(forma_farmaceutica) LIKE '%vaginal%' OR lower(forma_farmaceutica) LIKE '%Ã³vulo%' OR lower(forma_farmaceutica) LIKE '%ovulo%' THEN 'Vaginal'
               WHEN lower(forma_farmaceutica) LIKE '%rectal%' OR lower(forma_farmaceutica) LIKE '%supositorio%' THEN 'Rectal'
               WHEN lower(forma_farmaceutica) LIKE '%nasal%' THEN 'Nasal'
               WHEN lower(forma_farmaceutica) LIKE '%inhal%' OR lower(forma_farmaceutica) LIKE '%nebul%' THEN 'Inhalatoria'
               WHEN lower(forma_farmaceutica) LIKE '%intraven%' THEN 'Intravenosa'
               WHEN lower(forma_farmaceutica) LIKE '%intramus%' THEN 'Intramuscular'
               WHEN lower(forma_farmaceutica) LIKE '%subcut%' THEN 'SubcutÃ¡nea'
               WHEN lower(forma_farmaceutica) LIKE '%inyect%' THEN 'Parenteral'
               WHEN lower(forma_farmaceutica) LIKE '%dÃ©rmic%' OR lower(forma_farmaceutica) LIKE '%dermic%' OR lower(forma_farmaceutica) LIKE '%tÃ³pic%' OR lower(forma_farmaceutica) LIKE '%topic%' OR lower(forma_farmaceutica) LIKE '%crema%' OR lower(forma_farmaceutica) LIKE '%pomada%' OR lower(forma_farmaceutica) LIKE '%gel%' THEN 'TÃ³pica'
               ELSE 'Oral'
           END AS nombre
    FROM seed_productos_csv_staging
    WHERE es_valido = true
)
INSERT INTO vias_administracion (nombre, descripcion, activo)
SELECT nombre, 'VÃ­a de administraciÃ³n inferida desde la forma farmacÃ©utica LINAME 2026-2027 CSV', true
FROM vias_csv
ON CONFLICT (nombre) DO UPDATE
SET activo = true;

WITH source AS (
    SELECT DISTINCT ON (codigo)
           codigo, medicamento, forma_farmaceutica, concentracion, clasificacion_atq,
           uso_restringido, aclaracion_particularidades,
           CASE grupo_atq
               WHEN 'A' THEN 'AntiÃ¡cidos y Gastroprotectores'
               WHEN 'B' THEN 'Anticoagulantes y AntitrombÃ³ticos'
               WHEN 'C' THEN 'Cardiovascular'
               WHEN 'D' THEN 'DermatolÃ³gicos'
               WHEN 'G' THEN 'Salud Reproductiva'
               WHEN 'H' THEN 'Hormonas y Corticoides'
               WHEN 'J' THEN 'AntibiÃ³ticos'
               WHEN 'L' THEN 'OncolÃ³gicos'
               WHEN 'M' THEN 'Sistema MusculoesquelÃ©tico'
               WHEN 'N' THEN 'PsicotrÃ³picos y Antidepresivos'
               WHEN 'P' THEN 'Antiparasitarios'
               WHEN 'R' THEN 'Broncodilatadores y AntiasmÃ¡ticos'
               WHEN 'S' THEN 'OftalmolÃ³gicos'
               WHEN 'V' THEN 'Sueros y Electrolitos'
               ELSE 'Vitaminas y Suplementos'
           END AS categoria_nombre,
           CASE
               WHEN lower(forma_farmaceutica) IN ('comprimido', 'comprimidos') THEN 'Tableta'
               WHEN lower(forma_farmaceutica) IN ('capsula', 'cÃ¡psula') THEN 'CÃ¡psula'
               WHEN lower(forma_farmaceutica) LIKE 'suspensiÃ³n%' THEN 'SuspensiÃ³n'
               WHEN lower(forma_farmaceutica) LIKE 'soluciÃ³n oral%' THEN 'SoluciÃ³n oral'
               WHEN lower(forma_farmaceutica) LIKE 'crema%' THEN 'Crema'
               WHEN lower(forma_farmaceutica) LIKE 'pomada%' THEN 'Pomada'
               WHEN lower(forma_farmaceutica) LIKE 'jarabe%' THEN 'Jarabe'
               WHEN lower(forma_farmaceutica) LIKE 'gel%' THEN 'Gel'
               WHEN lower(forma_farmaceutica) LIKE 'colirio%' THEN 'Colirio'
               ELSE LEFT(forma_farmaceutica, 200)
           END AS forma_nombre,
           CASE
               WHEN lower(forma_farmaceutica) LIKE '%oftÃ¡lm%' OR lower(forma_farmaceutica) LIKE '%oftalm%' OR lower(forma_farmaceutica) LIKE '%colirio%' THEN 'OftÃ¡lmica'
               WHEN lower(forma_farmaceutica) LIKE '%Ã³tica%' OR lower(forma_farmaceutica) LIKE '%otica%' THEN 'Ã“tica'
               WHEN lower(forma_farmaceutica) LIKE '%vaginal%' OR lower(forma_farmaceutica) LIKE '%Ã³vulo%' OR lower(forma_farmaceutica) LIKE '%ovulo%' THEN 'Vaginal'
               WHEN lower(forma_farmaceutica) LIKE '%rectal%' OR lower(forma_farmaceutica) LIKE '%supositorio%' THEN 'Rectal'
               WHEN lower(forma_farmaceutica) LIKE '%nasal%' THEN 'Nasal'
               WHEN lower(forma_farmaceutica) LIKE '%inhal%' OR lower(forma_farmaceutica) LIKE '%nebul%' THEN 'Inhalatoria'
               WHEN lower(forma_farmaceutica) LIKE '%intraven%' THEN 'Intravenosa'
               WHEN lower(forma_farmaceutica) LIKE '%intramus%' THEN 'Intramuscular'
               WHEN lower(forma_farmaceutica) LIKE '%subcut%' THEN 'SubcutÃ¡nea'
               WHEN lower(forma_farmaceutica) LIKE '%inyect%' THEN 'Parenteral'
               WHEN lower(forma_farmaceutica) LIKE '%dÃ©rmic%' OR lower(forma_farmaceutica) LIKE '%dermic%' OR lower(forma_farmaceutica) LIKE '%tÃ³pic%' OR lower(forma_farmaceutica) LIKE '%topic%' OR lower(forma_farmaceutica) LIKE '%crema%' OR lower(forma_farmaceutica) LIKE '%pomada%' OR lower(forma_farmaceutica) LIKE '%gel%' THEN 'TÃ³pica'
               ELSE 'Oral'
           END AS via_nombre
    FROM seed_productos_csv_staging
    WHERE es_valido = true
    ORDER BY codigo, fila_excel
)
INSERT INTO productos (nombre, codigo, descripcion, concentracion, presentacion, requiere_receta, controlado, activo, categoria_id, forma_farmaceutica_id, via_administracion_id)
SELECT LEFT(s.medicamento, 300), s.codigo,
       LEFT(CONCAT('LINAME 2026-2027. ATQ: ', COALESCE(NULLIF(s.clasificacion_atq, ''), 'N/D'), '. Forma CSV: ', s.forma_farmaceutica), 1000),
       LEFT(s.concentracion, 100), NULLIF(LEFT(s.aclaracion_particularidades, 200), ''),
       (upper(COALESCE(s.uso_restringido, '')) = 'R'), false, true,
       c.id, f.id, v.id
FROM source s
LEFT JOIN categorias_terapeuticas c ON c.nombre = s.categoria_nombre
LEFT JOIN formas_farmaceuticas f ON f.nombre = s.forma_nombre
LEFT JOIN vias_administracion v ON v.nombre = s.via_nombre
ON CONFLICT (codigo) DO UPDATE
SET nombre = EXCLUDED.nombre,
    descripcion = EXCLUDED.descripcion,
    concentracion = EXCLUDED.concentracion,
    presentacion = EXCLUDED.presentacion,
    requiere_receta = EXCLUDED.requiere_receta,
    controlado = EXCLUDED.controlado,
    activo = true,
    categoria_id = EXCLUDED.categoria_id,
    forma_farmaceutica_id = EXCLUDED.forma_farmaceutica_id,
    via_administracion_id = EXCLUDED.via_administracion_id;

COMMIT;

SET search_path TO public;

-- ============================================================
-- FIN 30-seed-productos-csv-productos.sql
-- ============================================================


-- ============================================================
-- INICIO 31-seed-productos-csv-producto-principios-activos.sql
-- ============================================================

-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================
SET search_path TO farmacia_bri, public;

BEGIN;

INSERT INTO producto_principios_activos (producto_id, principio_activo_id, concentracion)
SELECT DISTINCT p.id, pa.id, LEFT(s.concentracion, 100)
FROM seed_productos_csv_staging s
JOIN productos p ON p.codigo = s.codigo
CROSS JOIN LATERAL regexp_split_to_table(s.medicamento, '[[:space:]]*\+[[:space:]]*') AS pa_raw(nombre)
JOIN principios_activos pa ON pa.nombre = LEFT(TRIM(pa_raw.nombre), 200)
WHERE s.es_valido = true
  AND NULLIF(TRIM(pa_raw.nombre), '') IS NOT NULL
ON CONFLICT (producto_id, principio_activo_id) DO UPDATE
SET concentracion = EXCLUDED.concentracion;

COMMIT;

SET search_path TO public;

-- ============================================================
-- FIN 31-seed-productos-csv-producto-principios-activos.sql
-- ============================================================


-- ============================================================
-- INICIO 32-seed-productos-csv-precios.sql
-- ============================================================

-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================
SET search_path TO farmacia_bri, public;

BEGIN;

INSERT INTO producto_precios (producto_id, tipo_precio, precio, precio_compra, vigencia_desde, activo)
SELECT p.id, 'UNIDAD', ROUND(s.precio_referencial, 2), NULL, TIMESTAMP '2026-04-06 00:00:00', true
FROM seed_productos_csv_staging s
JOIN productos p ON p.codigo = s.codigo
WHERE s.es_valido = true
  AND NOT EXISTS (
      SELECT 1
      FROM producto_precios pp
      WHERE pp.producto_id = p.id
        AND pp.tipo_precio = 'UNIDAD'
        AND pp.vigencia_desde = TIMESTAMP '2026-04-06 00:00:00'
  );

COMMIT;

SET search_path TO public;

-- ============================================================
-- FIN 32-seed-productos-csv-precios.sql
-- ============================================================


-- ============================================================
-- INICIO 33-seed-productos-csv-lotes-inventario.sql
-- ============================================================

-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================
SET search_path TO farmacia_bri, public;

BEGIN;

INSERT INTO laboratorios (nombre, pais, activo)
SELECT 'LINAME 2026-2027', 'Bolivia', true
WHERE NOT EXISTS (
    SELECT 1
    FROM laboratorios
    WHERE nombre = 'LINAME 2026-2027'
);

INSERT INTO sucursales (nombre, direccion, telefono, es_matriz, activo)
SELECT 'Sucursal Matriz', 'Generada para seed LINAME CSV cuando no existen sucursales activas', NULL, true, true
WHERE NOT EXISTS (SELECT 1 FROM sucursales WHERE activo = true);

INSERT INTO producto_lotes (producto_id, laboratorio_id, numero_lote, fecha_vencimiento, cantidad_inicial, activo)
SELECT p.id, l.id, 'LOT-' || p.codigo, DATE '2027-12-31', 100, true
FROM seed_productos_csv_staging s
JOIN productos p ON p.codigo = s.codigo
JOIN laboratorios l ON l.nombre = 'LINAME 2026-2027'
WHERE s.es_valido = true
ON CONFLICT (producto_id, numero_lote) DO UPDATE
SET laboratorio_id = EXCLUDED.laboratorio_id,
    fecha_vencimiento = EXCLUDED.fecha_vencimiento,
    cantidad_inicial = EXCLUDED.cantidad_inicial,
    activo = true;

INSERT INTO inventario (lote_id, sucursal_id, stock_actual, stock_minimo, ubicacion)
SELECT pl.id, s.id,
       CASE WHEN s.es_matriz THEN 80 ELSE 20 END,
       CASE WHEN s.es_matriz THEN 10 ELSE 5 END,
       'Seed LINAME CSV'
FROM seed_productos_csv_staging src
JOIN productos p ON p.codigo = src.codigo
JOIN producto_lotes pl ON pl.producto_id = p.id AND pl.numero_lote = 'LOT-' || p.codigo
JOIN sucursales s ON s.activo = true
WHERE src.es_valido = true
ON CONFLICT (lote_id, sucursal_id) DO UPDATE
SET stock_actual = EXCLUDED.stock_actual,
    stock_minimo = EXCLUDED.stock_minimo,
    ubicacion = EXCLUDED.ubicacion;

COMMIT;

SET search_path TO public;

-- ============================================================
-- FIN 33-seed-productos-csv-lotes-inventario.sql
-- ============================================================


-- ============================================================
-- INICIO 34-validacion-productos-csv.sql
-- ============================================================

-- ============================================================
-- Generado desde documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.xlsx
-- Fuente convertida: documentation/Lista_Nacional_de_Medicamentos_Esenciales_LINAME_2026_2027_abril.csv
-- Ejecutar reemplazando farmacia_bri por el tenant correspondiente.
-- ============================================================
SET search_path TO farmacia_bri, public;

BEGIN;

SELECT COUNT(*) AS total_filas_staging,
       COUNT(*) FILTER (WHERE es_valido) AS filas_validas,
       COUNT(*) FILTER (WHERE NOT es_valido) AS filas_invalidas
FROM seed_productos_csv_staging;

SELECT fila_excel, codigo, medicamento, forma_farmaceutica, concentracion, precio_referencial, motivo_invalidacion
FROM seed_productos_csv_staging
WHERE es_valido = false
ORDER BY fila_excel;

SELECT COUNT(*) AS total_productos_cargados_desde_csv
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo
WHERE s.es_valido = true;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_precios pp WHERE pp.producto_id = p.id AND pp.activo = true)
ORDER BY p.codigo;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_lotes pl WHERE pl.producto_id = p.id AND pl.activo = true)
ORDER BY p.codigo;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_lotes pl JOIN inventario i ON i.lote_id = pl.id WHERE pl.producto_id = p.id)
ORDER BY p.codigo;

SELECT p.codigo, p.nombre
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
WHERE NOT EXISTS (SELECT 1 FROM producto_principios_activos ppa WHERE ppa.producto_id = p.id)
ORDER BY p.codigo;

SELECT codigo, COUNT(*) AS cantidad
FROM productos
GROUP BY codigo
HAVING COUNT(*) > 1
ORDER BY cantidad DESC, codigo;

SELECT p.nombre, p.concentracion, p.presentacion,
       COALESCE(f.nombre, 'SIN_FORMA') AS forma_farmaceutica,
       COALESCE(v.nombre, 'SIN_VIA') AS via_administracion,
       COUNT(*) AS cantidad
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN formas_farmaceuticas f ON f.id = p.forma_farmaceutica_id
LEFT JOIN vias_administracion v ON v.id = p.via_administracion_id
GROUP BY p.nombre, p.concentracion, p.presentacion, f.nombre, v.nombre
HAVING COUNT(*) > 1
ORDER BY cantidad DESC, p.nombre;

SELECT COALESCE(c.nombre, 'SIN_CATEGORIA') AS categoria, COUNT(*) AS total
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN categorias_terapeuticas c ON c.id = p.categoria_id
GROUP BY c.nombre
ORDER BY total DESC, categoria;

SELECT COALESCE(f.nombre, 'SIN_FORMA') AS forma_farmaceutica, COUNT(*) AS total
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN formas_farmaceuticas f ON f.id = p.forma_farmaceutica_id
GROUP BY f.nombre
ORDER BY total DESC, forma_farmaceutica;

SELECT COALESCE(v.nombre, 'SIN_VIA') AS via_administracion, COUNT(*) AS total
FROM productos p
JOIN seed_productos_csv_staging s ON s.codigo = p.codigo AND s.es_valido = true
LEFT JOIN vias_administracion v ON v.id = p.via_administracion_id
GROUP BY v.nombre
ORDER BY total DESC, via_administracion;

COMMIT;

SET search_path TO public;

-- ============================================================
-- FIN 34-validacion-productos-csv.sql
-- ============================================================


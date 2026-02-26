-- ============================================================
-- PASO 1: CATÁLOGOS AMPLIADOS
-- Complementa 06-seed-catalogos.sql
-- ============================================================
SET search_path TO {SCHEMA}, public;

INSERT INTO categorias_terapeuticas (nombre, descripcion) VALUES
                                                              ('Analgésicos y Antipiréticos',       'Medicamentos para el dolor y la fiebre'),
                                                              ('Antibióticos',                       'Antibacterianos de uso sistémico'),
                                                              ('Antiinflamatorios',                  'Antiinflamatorios no esteroideos (AINEs)'),
                                                              ('Antihistamínicos',                   'Medicamentos antialérgicos y antihistamínicos'),
                                                              ('Antihipertensivos',                  'Medicamentos para la hipertensión arterial'),
                                                              ('Antidiabéticos',                     'Medicamentos para la diabetes mellitus'),
                                                              ('Vitaminas y Suplementos',            'Vitaminas, minerales y suplementos nutricionales'),
                                                              ('Antiácidos y Gastroprotectores',     'Medicamentos para el sistema digestivo superior'),
                                                              ('Antiparasitarios',                   'Medicamentos contra parásitos intestinales y sistémicos'),
                                                              ('Dermatológicos',                     'Medicamentos de uso tópico cutáneo'),
                                                              ('Anestésicos',                        'Anestésicos generales, locales y adyuvantes'),
                                                              ('Anticonvulsivos',                    'Medicamentos antiepilépticos y anticonvulsivos'),
                                                              ('Antifúngicos',                       'Medicamentos antimicóticos sistémicos y tópicos'),
                                                              ('Antivirales',                        'Medicamentos antivirales'),
                                                              ('Antituberculosos',                   'Medicamentos para el tratamiento de la tuberculosis'),
                                                              ('Cardiovascular',                     'Medicamentos para el sistema cardiovascular'),
                                                              ('Anticoagulantes y Antitrombóticos',  'Anticoagulantes, antiagregantes plaquetarios'),
                                                              ('Antilipídicos',                      'Medicamentos hipolipemiantes'),
                                                              ('Broncodilatadores y Antiasmáticos',  'Medicamentos para el sistema respiratorio'),
                                                              ('Antiemético y Procinético',          'Medicamentos contra náuseas y para la motilidad gástrica'),
                                                              ('Hormonas y Corticoides',             'Hormonas, corticosteroides sistémicos y análogos'),
                                                              ('Tiroides',                           'Medicamentos para patologías de la glándula tiroides'),
                                                              ('Oftalmológicos',                     'Medicamentos de uso ocular (colirios, pomadas)'),
                                                              ('Salud Reproductiva',                 'Medicamentos para salud materna e infantil'),
                                                              ('Sistema Musculoesquelético',         'Medicamentos para músculos, huesos y articulaciones'),
                                                              ('Psicotrópicos y Antidepresivos',     'Medicamentos para trastornos depresivos y ansiedad'),
                                                              ('Antipsicóticos',                     'Medicamentos antipsicóticos y estabilizadores del ánimo'),
                                                              ('Oncológicos',                        'Medicamentos antineoplásicos'),
                                                              ('Sueros y Electrolitos',              'Soluciones parenterales y electrolitos'),
                                                              ('Antidiarreicos',                     'Medicamentos contra la diarrea y rehidratación'),
                                                              ('Antiulcerosos',                      'Medicamentos para úlceras gástricas y duodenales'),
                                                              ('Relajantes Musculares',              'Relajantes musculares y antiespasmódicos'),
                                                              ('Antigotosos',                        'Medicamentos para el tratamiento de la gota'),
                                                              ('Antianémicos',                       'Medicamentos para el tratamiento de la anemia')
    ON CONFLICT (nombre) DO NOTHING;

-- ------------------------------------------------------------
INSERT INTO formas_farmaceuticas (nombre, descripcion) VALUES
                                                           ('Tableta',                        'Comprimido sólido de administración oral'),
                                                           ('Cápsula',                        'Cápsula de gelatina dura o blanda'),
                                                           ('Jarabe',                         'Solución oral azucarada'),
                                                           ('Suspensión',                     'Dispersión de sólidos en líquido para uso oral'),
                                                           ('Crema',                          'Emulsión semisólida de uso tópico'),
                                                           ('Pomada',                         'Preparación semisólida lipofílica de uso tópico'),
                                                           ('Ampolla',                        'Solución inyectable en ampolla de vidrio sellada'),
                                                           ('Solución oral',                  'Solución líquida de administración oral'),
                                                           ('Parche transdérmico',            'Sistema de liberación transdérmica'),
                                                           ('Supositorio',                    'Forma farmacéutica sólida de uso rectal'),
                                                           ('Tableta Masticable',             'Tableta formulada para masticar antes de tragar'),
                                                           ('Tableta Sublingual',             'Tableta de disolución debajo de la lengua'),
                                                           ('Tableta de Liberación Prolongada','Tableta con liberación controlada del principio activo'),
                                                           ('Polvo para Suspensión',          'Polvo para reconstituir en suspensión oral'),
                                                           ('Colirio',                        'Gotas oftálmicas estériles'),
                                                           ('Óvulo Vaginal',                  'Forma farmacéutica sólida de uso vaginal'),
                                                           ('Gel',                            'Preparación semisólida hidrofílica de uso tópico'),
                                                           ('Champú',                         'Solución dermatológica para uso capilar'),
                                                           ('Inhalador de Dosis Medida',      'Dispositivo de inhalación presurizado (MDI)'),
                                                           ('Solución para Nebulización',     'Solución para uso con nebulizador'),
                                                           ('Solución para Infusión IV',      'Bolsa/frasco para infusión intravenosa'),
                                                           ('Polvo para Inyección',           'Polvo liofilizado para reconstituir e inyectar'),
                                                           ('Gragea',                         'Comprimido recubierto con cubierta azucarada'),
                                                           ('Gotas',                          'Solución de administración en gotas orales u óticas')
    ON CONFLICT (nombre) DO NOTHING;

-- ------------------------------------------------------------
INSERT INTO vias_administracion (nombre, descripcion) VALUES
                                                          ('Oral',          'Administración por vía oral (deglución)'),
                                                          ('Tópica',        'Aplicación directa sobre la piel o mucosas'),
                                                          ('Intravenosa',   'Inyección directa en vena (IV)'),
                                                          ('Intramuscular', 'Inyección en tejido muscular (IM)'),
                                                          ('Subcutánea',    'Inyección debajo de la piel (SC)'),
                                                          ('Oftálmica',     'Aplicación en el ojo'),
                                                          ('Ótica',         'Aplicación en el conducto auditivo'),
                                                          ('Rectal',        'Administración por vía rectal'),
                                                          ('Sublingual',    'Disolución debajo de la lengua'),
                                                          ('Inhalatoria',   'Administración por inhalación pulmonar'),
                                                          ('Vaginal',       'Administración por vía vaginal'),
                                                          ('Nasal',         'Aplicación en la cavidad nasal'),
                                                          ('Transdérmica',  'Absorción controlada a través de la piel')
    ON CONFLICT (nombre) DO NOTHING;

-- ------------------------------------------------------------
INSERT INTO principios_activos (nombre) VALUES
-- Analgésicos / Antipiréticos / AINEs
('Paracetamol'),('Ácido Acetilsalicílico'),('Ibuprofeno'),('Metamizol'),
('Tramadol'),('Codeína'),('Morfina'),('Naproxeno'),('Ketorolaco'),
('Diclofenaco'),('Celecoxib'),('Meloxicam'),('Fentanilo'),
-- Antibióticos
('Amoxicilina'),('Ampicilina'),('Azitromicina'),('Amikacina'),
('Bencilpenicilina'),('Bencilpenicilina Benzatínica'),
('Ceftriaxona'),('Cefazolina'),('Cefalexina'),('Cefuroxima'),
('Ciprofloxacino'),('Claritromicina'),('Clindamicina'),('Doxiciclina'),
('Eritromicina'),('Gentamicina'),('Imipenem + Cilastatina'),
('Levofloxacino'),('Linezolid'),('Metronidazol'),('Nitrofurantoína'),
('Norfloxacino'),('Penicilina V Potásica'),('Rifampicina'),
('Tetraciclina'),('Trimetoprim + Sulfametoxazol'),('Vancomicina'),
('Amoxicilina + Ácido Clavulánico'),
-- Antifúngicos
('Anfotericina B'),('Clotrimazol'),('Fluconazol'),('Griseofulvina'),
('Itraconazol'),('Ketoconazol'),('Miconazol'),('Nistatina'),
-- Antivirales
('Aciclovir'),('Lamivudina'),('Lamivudina + Zidovudina'),
('Oseltamivir'),('Ritonavir'),('Tenofovir + Emtricitabina'),
('Valaciclovir'),('Zidovudina'),
-- Antiparasitarios
('Albendazol'),('Cloroquina'),('Ivermectina'),('Mebendazol'),
('Praziquantel'),('Primaquina'),('Tinidazol'),
-- Antituberculosos
('Etambutol'),('Isoniazida'),('Pirazinamida'),('Estreptomicina'),
('Isoniazida + Rifampicina + Pirazinamida'),('Rifampicina + Isoniazida'),
-- Cardiovascular
('Amlodipino'),('Atenolol'),('Captopril'),('Carvedilol'),
('Digoxina'),('Diltiazem'),('Enalapril'),('Furosemida'),
('Hidralazina'),('Hidroclorotiazida'),('Irbesartan'),('Losartan'),
('Metoprolol'),('Nifedipino'),('Nitroglicerina'),
('Propranolol'),('Ramipril'),('Verapamilo'),
-- Anticoagulantes
('Enoxaparina'),('Heparina'),('Warfarina'),('Clopidogrel'),
-- Antilipídicos
('Atorvastatina'),('Gemfibrozilo'),('Rosuvastatina'),('Simvastatina'),
-- Broncodilatadores
('Beclometasona'),('Budesonida'),('Ipratropio'),
('Montelukast'),('Salbutamol'),('Teofilina'),
-- Digestivo
('Bromuro de Hioscina'),('Dimenhidrinato'),('Domperidona'),
('Esomeprazol'),('Loperamida'),('Metoclopramida'),
('Omeprazol'),('Ondansetrón'),('Pantoprazol'),('Ranitidina'),
('Hidróxido de Aluminio + Hidróxido de Magnesio'),
('Sales de Rehidratación Oral'),
-- Antidiabéticos
('Glibenclamida'),('Glimepirida'),('Insulina NPH'),
('Insulina Regular'),('Insulina Glargina'),('Metformina'),('Sitagliptina'),
-- Hormonas / Corticoides
('Dexametasona'),('Hidrocortisona'),('Levotiroxina'),
('Metilprednisolona'),('Prednisolona'),('Prednisona'),
-- Vitaminas y Minerales
('Ácido Fólico'),('Calcio'),('Calcio + Vitamina D3'),
('Cianocobalamina'),('Hierro Polimaltosado'),('Retinol'),
('Vitamina C'),('Zinc Sulfato'),('Complejo B'),('Sulfato Ferroso'),
-- Dermatológicos
('Betametasona'),('Clobetasol'),('Permetrina'),
('Tretinoína'),('Óxido de Zinc'),
-- Oftalmológicos
('Acetazolamida'),('Atropina'),('Cloranfenicol'),
('Timolol'),('Tropicamida'),
-- Salud Reproductiva
('Levonorgestrel'),('Medroxiprogesterona'),
('Misoprostol'),('Oxitocina'),('Sulfato de Magnesio'),
-- Musculoesquelético / Antigotosos
('Alopurinol'),('Colchicina'),('Metotrexato'),
-- Antihistamínicos
('Cetirizina'),('Clorfenamina'),('Difenhidramina'),
('Fexofenadina'),('Loratadina'),
-- Psiquiatría / Neurología
('Amitriptilina'),('Clonazepam'),('Diazepam'),('Escitalopram'),
('Fluoxetina'),('Haloperidol'),('Litio'),('Olanzapina'),
('Quetiapina'),('Risperidona'),('Sertralina'),('Venlafaxina'),('Clozapina'),
-- Anticonvulsivos
('Ácido Valproico'),('Carbamazepina'),('Fenitoína'),
('Fenobarbital'),('Gabapentina'),('Levetiracetam'),('Lamotrigina'),
-- Anestésicos
('Bupivacaína'),('Cetamina'),('Lidocaína'),('Midazolam'),
('Neostigmina'),('Propofol'),('Succinilcolina'),('Vecuronio'),
-- Oncológicos
('Ciclofosfamida'),('Cisplatino'),('Doxorrubicina'),
('Tamoxifeno'),('Vincristina'),
-- Sueros
('Glucosa'),('Cloruro de Sodio'),('Ringer Lactato')
    ON CONFLICT (nombre) DO NOTHING;

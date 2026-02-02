-- 1. Crear la tabla
CREATE TABLE planes_estudio_uandina (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    facultad            VARCHAR(150) NOT NULL,
    escuela_profesional VARCHAR(100) NOT NULL,
    anio_plan           VARCHAR(20) NOT NULL,          -- ej: '2016', '2020', '2025'
    url_pdf             VARCHAR(255) DEFAULT NULL,     -- NULL si no hay PDF para ese año
    color_icono         VARCHAR(20) DEFAULT NULL,      -- ej: '#00417b', '#00cdff', '#ed2a6e' (opcional, por si quieres usarlo después)
    ultima_actualizacion DATE DEFAULT (CURRENT_DATE),
    INDEX idx_facultad (facultad),
    INDEX idx_escuela (escuela_profesional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2. Insertar todos los datos (valores completos con URLs absolutas)
INSERT INTO planes_estudio_uandina 
    (facultad, escuela_profesional, anio_plan, url_pdf, color_icono) 
VALUES
-- FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ADMINISTRACIÓN',                        '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-administracion.pdf',     '#00417b'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ADMINISTRACIÓN',                        '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-administracion.pdf',     '#00cdff'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ADMINISTRACIÓN',                        '2025', NULL,                                                                                      NULL),

('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'CONTABILIDAD',                         '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-contabilidad.pdf',       '#00417b'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'CONTABILIDAD',                         '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-contabilidad.pdf',       '#00cdff'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'CONTABILIDAD',                         '2025', NULL,                                                                                      NULL),

('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ECONOMÍA',                             '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-economia.pdf',           '#00417b'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ECONOMÍA',                             '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-economia.pdf',           '#00cdff'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ECONOMÍA',                             '2025', NULL,                                                                                      NULL),

('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'FINANZAS',                             '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-finanzas.pdf',           '#00417b'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'FINANZAS',                             '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-finanzas.pdf',           '#00cdff'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'FINANZAS',                             '2025', NULL,                                                                                      NULL),

('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'MARKETING',                            '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-marketing.pdf',          '#00417b'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'MARKETING',                            '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-marketing.pdf',          '#00cdff'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'MARKETING',                            '2025', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/res-marketing-plan-estudios-2025.pdf', '#ed2a6e'),

('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ADMINISTRACIÓN DE NEGOCIOS INTERNACIONALES', '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-adm-negocios-internacionales.pdf', '#00417b'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ADMINISTRACIÓN DE NEGOCIOS INTERNACIONALES', '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-adm-negocios-internacionales.pdf', '#00cdff'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'ADMINISTRACIÓN DE NEGOCIOS INTERNACIONALES', '2025', NULL,                                                                                      NULL),

-- FACULTAD DE CIENCIAS Y HUMANIDADES
('FACULTAD DE CIENCIAS Y HUMANIDADES', 'EDUCACIÓN',  '2016 ó 2017', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2017v-pe-educacion.pdf',   '#00417b'),
('FACULTAD DE CIENCIAS Y HUMANIDADES', 'EDUCACIÓN',  '2020',        'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-educacion.pdf',   '#00cdff'),

('FACULTAD DE CIENCIAS Y HUMANIDADES', 'TURISMO',    '2016',        'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-turismo.pdf',     '#00417b'),
('FACULTAD DE CIENCIAS Y HUMANIDADES', 'TURISMO',    '2020',        'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-turismo.pdf',     '#00cdff'),

-- FACULTAD DE DERECHO Y CIENCIA POLÍTICA
('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', 'DERECHO', '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-derecho.pdf', '#00417b'),
('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', 'DERECHO', '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-derecho.pdf', '#00cdff'),

-- FACULTAD DE INGENIERÍA Y ARQUITECTURA
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'ARQUITECTURA',        '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-arquitectura.pdf',     '#00417b'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'ARQUITECTURA',        '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-arquitectura.pdf',     '#00cdff'),

('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA AMBIENTAL', '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-ing-ambiental.pdf',    '#00417b'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA AMBIENTAL', '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-ing-ambiental.pdf',    '#00cdff'),

('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA INDUSTRIAL','2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-ing-industrial.pdf',  '#00417b'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA INDUSTRIAL','2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-ing-industrial.pdf',  '#00cdff'),

('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA CIVIL',     '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-ing-civil.pdf',       '#00417b'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA CIVIL',     '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-ing-civil.pdf',       '#00cdff'),

('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA DE SISTEMAS','2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-ing-sistemas.pdf',    '#00417b'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'INGENIERÍA DE SISTEMAS','2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-ing-sistemas.pdf',    '#00cdff'),

-- FACULTAD DE CIENCIAS DE LA SALUD
('FACULTAD DE CIENCIAS DE LA SALUD', 'ENFERMERÍA',        '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-enfermeria.pdf',     '#00417b'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'ENFERMERÍA',        '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-enfermeria.pdf',     '#00cdff'),

('FACULTAD DE CIENCIAS DE LA SALUD', 'OBSTETRICIA',       '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-obstetricia.pdf',    '#00417b'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'OBSTETRICIA',       '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-obstetricia.pdf',    '#00cdff'),

('FACULTAD DE CIENCIAS DE LA SALUD', 'ESTOMATOLOGÍA',     '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-estomatologia.pdf',  '#00417b'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'ESTOMATOLOGÍA',     '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-estomatologia.pdf',  '#00cdff'),

('FACULTAD DE CIENCIAS DE LA SALUD', 'PSICOLOGÍA',        '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-psicologia.pdf',     '#00417b'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'PSICOLOGÍA',        '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-psicologia.pdf',     '#00cdff'),

('FACULTAD DE CIENCIAS DE LA SALUD', 'MEDICINA HUMANA',   '2016', NULL,                                                                                   NULL),
('FACULTAD DE CIENCIAS DE LA SALUD', 'MEDICINA HUMANA',   '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-medicina-humana.pdf','#00cdff'),

('FACULTAD DE CIENCIAS DE LA SALUD', 'TECNOLOGÍA MÉDICA', '2016', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2016v-pe-tecnologia-medica.pdf', '#00417b'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'TECNOLOGÍA MÉDICA', '2020', 'https://www.uandina.edu.pe/descargas/transparencia/planes-estudio/2020v-pe-tecnologia-medica.pdf', '#00cdff');
-- ============================================================================
-- BASE DE DATOS: PROYECTO GENERAL DE DESARROLLO POR FACULTAD
-- Solo tabla de facultades (sin documentos normativos)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS portal_transparencia 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE portal_transparencia;

-- ============================================================================
-- TABLA: doc_normativos_facultades
-- ============================================================================

CREATE TABLE IF NOT EXISTS doc_normativos_facultades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    facultad VARCHAR(200) NOT NULL,              -- Nombre de la facultad
    nivel VARCHAR(50) NOT NULL,                  -- 'Facultad' o 'Escuela Profesional'
    escuela VARCHAR(200) DEFAULT NULL,           -- Nombre de la escuela (NULL para facultad)
    pei_enlace TEXT DEFAULT NULL,                -- Enlace al PEI
    pgd_enlace TEXT DEFAULT NULL,                -- Enlace al PGD
    copea_enlace TEXT DEFAULT NULL,              -- Enlace al COPEA
    INDEX idx_facultad (facultad),
    INDEX idx_nivel (nivel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- DATOS: Facultades y Escuelas Profesionales
-- ============================================================================

-- Facultad de Ciencias Económicas, Administrativas y Contables
INSERT INTO doc_normativos_facultades (facultad, nivel, escuela, pei_enlace, pgd_enlace, copea_enlace) VALUES
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'Facultad', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-f-ceac.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-f-ceac.pdf', NULL),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'Escuela Profesional', 'ADMINISTRACIÓN', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-administracion.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-administracion.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-administracion.pdf'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'Escuela Profesional', 'CONTABILIDAD', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-contabilidad.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd1-contabilidad.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-CO.pdf'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'Escuela Profesional', 'ECONOMÍA', 'https://www.uandina.edu.pe/descargas/transparencia/pei/pei-economia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-economia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-economia.pdf'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'Escuela Profesional', 'FINANZAS', NULL, NULL, 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-finanzas.pdf'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'Escuela Profesional', 'MARKETING', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-marketing.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-marketing.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-marketing.pdf'),
('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', 'Escuela Profesional', 'ADMINISTRACIÓN DE NEGOCIOS INTERNACIONALES', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-adm-negocios-internacionales.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-adm-negocios-internacionales.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-negocios-internacionales.pdf');

-- Facultad de Ciencias y Humanidades
INSERT INTO doc_normativos_facultades (facultad, nivel, escuela, pei_enlace, pgd_enlace, copea_enlace) VALUES
('FACULTAD DE CIENCIAS Y HUMANIDADES', 'Facultad', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-f-ciencias-humanidades.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-f-ciencias-humanidades.pdf', NULL),
('FACULTAD DE CIENCIAS Y HUMANIDADES', 'Escuela Profesional', 'EDUCACIÓN', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-educacion.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-educacion.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-educacion.pdf'),
('FACULTAD DE CIENCIAS Y HUMANIDADES', 'Escuela Profesional', 'TURISMO', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-turismo.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-turismo.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-turismo.pdf');

-- Facultad de Derecho y Ciencia Política
INSERT INTO doc_normativos_facultades (facultad, nivel, escuela, pei_enlace, pgd_enlace, copea_enlace) VALUES
('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', 'Facultad', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-f-derecho-ciencia-politica.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-f-derecho-ciencia-politica.pdf', NULL),
('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', 'Escuela Profesional', 'DERECHO', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-derecho.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-derecho.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-derecho.pdf');

-- Facultad de Ingeniería y Arquitectura
INSERT INTO doc_normativos_facultades (facultad, nivel, escuela, pei_enlace, pgd_enlace, copea_enlace) VALUES
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Facultad', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-f-ingenieria-arquitectura.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-f-ingenieria-arquitectura.pdf', NULL),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Escuela Profesional', 'ARQUITECTURA', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-arquitectura.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-arquitectura.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-arquitectura.pdf'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Escuela Profesional', 'INGENIERÍA AMBIENTAL', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei1-ing-ambiental.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd1-ing-ambiental.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-ing-ambiental.pdf'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Escuela Profesional', 'INGENIERÍA INDUSTRIAL', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-ing-industrial.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-ing-industrial.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2018/copea-ing-industrial.pdf'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Escuela Profesional', 'INGENIERÍA CIVIL', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-ing-civil.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-ing-civil.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-ing-civil.pdf'),
('FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Escuela Profesional', 'INGENIERÍA DE SISTEMAS', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-ing-sistemas.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-ing-sistemas.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-ing-sistemas.pdf');

-- Facultad de Ciencias de la Salud
INSERT INTO doc_normativos_facultades (facultad, nivel, escuela, pei_enlace, pgd_enlace, copea_enlace) VALUES
('FACULTAD DE CIENCIAS DE LA SALUD', 'Facultad', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/pei-2024/pei-facsa.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-facsa.pdf', NULL),
('FACULTAD DE CIENCIAS DE LA SALUD', 'Escuela Profesional', 'ENFERMERÍA', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-enfermeria.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-enfermeria.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-enfermeria.pdf'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'Escuela Profesional', 'OBSTETRICIA', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-obstetricia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-obstetricia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-obstetricia.pdf'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'Escuela Profesional', 'ESTOMATOLOGÍA', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-estomatologia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-estomatologia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-estomatologia.pdf'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'Escuela Profesional', 'PSICOLOGÍA', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-psicologia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-psicologia.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-psicologia.pdf'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'Escuela Profesional', 'MEDICINA HUMANA', 'https://www.uandina.edu.pe/descargas/transparencia/pei-2016/pei-medicina-humana.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/pgd-2016/pgd-medicina-humana.pdf', 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-medicina-humana.pdf'),
('FACULTAD DE CIENCIAS DE LA SALUD', 'Escuela Profesional', 'TECNOLOGÍA MÉDICA', NULL, NULL, 'https://www.uandina.edu.pe/descargas/transparencia/copea-2016/copea-tecnologia-medica.pdf');

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
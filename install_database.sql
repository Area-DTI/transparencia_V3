/* =========================================================
   BASE DE DATOS
   Portal de Transparencia - Universidad Andina del Cusco
   Motor: MySQL / MariaDB
   ========================================================= */

DROP DATABASE IF EXISTS portal_transparencia;

CREATE DATABASE portal_transparencia
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE portal_transparencia;



-- ------------------------------------------------------------------------
-- ------------------------------------------------------------------------
-- Tabla: admin_users (Usuarios administradores)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    google_id VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    picture VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_google_id (google_id),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Tabla: portal_cards (Tarjetas del portal principal)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS portal_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    icon VARCHAR(50) NOT NULL COMMENT 'Emoji o código del icono',
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    link_url VARCHAR(500) NOT NULL,
    link_text VARCHAR(100) DEFAULT 'Ver Documentos',
    display_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    INDEX idx_display_order (display_order),
    INDEX idx_active (is_active),
    FOREIGN KEY (created_by) REFERENCES admin_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Tabla: activity_logs (Registro de actividades)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(50) NOT NULL,
    table_name VARCHAR(50),
    record_id INT,
    old_values TEXT,
    new_values TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES admin_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Insertar tarjetas iniciales del portal
-- ----------------------------------------------------------------------------
INSERT INTO portal_cards (icon, title, description, link_url, link_text, display_order, is_active) VALUES
('📘', 'Doc. Normativos', 'Consulta normas y documentos oficiales institucionales', '1_doc_normativos/index.html', 'Ver Documentos', 1, TRUE),
('📋', 'Actas', 'Consulta las actas de sesiones y reuniones institucionales', '2_actas_php/index.html', 'Ver Actas', 2, TRUE),
('💰', 'Estados Financieros', 'Información financiera y estados contables', '3_contabilidad_php/index.html', 'Ver Estados Financieros', 3, TRUE),
('🎓', 'Becas', 'Programas de becas y beneficios estudiantiles', '4_becas_php/index.html', 'Ver Becas', 4, TRUE),
('📊', 'Inversiones Reinversiones', 'Proyectos de inversión y ejecución presupuestal', '5_inversiones/index.html', 'Ver Inversiones Reinversiones', 5, TRUE),
('🔬', 'Investigación', 'Proyectos y publicaciones de investigación', '6_investigacion/index.html', 'Ver Investigación', 6, TRUE),
('👨🏼‍🎓', 'Alumnos', 'Información sobre estudiantes y matrícula', '7_alumnos/index.html', 'Ver Alumnos', 7, TRUE),
('👨🏼‍🏫', 'Docentes', 'Información del personal docente', '8_docentes/index.html', 'Ver Docentes', 8, TRUE),
('💵', 'Remuneraciones', 'Planilla de pagos y remuneraciones', '9_remuneraciones/index.html', 'Ver Remuneraciones', 9, TRUE),
('💳', 'Pagos', 'Información sobre pagos, tasas y conceptos administrativos', '9_pagos/index.html', 'Ver Pagos', 10, TRUE),
('📜', 'Reglamentos', 'Reglamentos y normativas institucionales', '10_reglamentos/index.html', 'Ver Reglamentos', 11, TRUE),
('📂', 'Otros Documentos', 'Documentos institucionales de interés y archivos complementarios', '11_otros_documentos/index.html', 'Ver Documentos', 12, TRUE),
('📊', 'Proyecto General de Desarrollo', 'Lineamientos, objetivos y estrategias del desarrollo institucional', '14_proyecto_general_desarrollo/index.html', 'Ver Proyecto', 13, TRUE),
('🎓', 'Plan de Estudios', 'Estructura académica, mallas curriculares y planes de estudio', '15_plan_estudio/index.html', 'Ver Planes de Estudio', 14, TRUE);

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================



/* =========================================================
   Portal de Transparencia - Universidad Andina del Cusco
   SCRIPT FINAL ULTRA COMPATIBLE
   SOLO TABLAS - SIN DATOS
   ========================================================= */

-- =========================================================
-- 1. DOCUMENTOS NORMATIVOS
-- =========================================================
CREATE TABLE IF NOT EXISTS doc_normativos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion VARCHAR(50) NOT NULL,
    titulo TEXT NOT NULL,
    resolucion VARCHAR(255) DEFAULT NULL,
    es_subitem TINYINT(1) DEFAULT 0,
    enlace TEXT NOT NULL,
    parent_id INT DEFAULT NULL,
    INDEX idx_seccion (seccion),
    INDEX idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


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


-- =========================================================
-- 2. ACTAS
-- =========================================================
CREATE TABLE actas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion VARCHAR(255),
    categoria VARCHAR(50),
    subcategoria VARCHAR(255),
    dia VARCHAR(2),
    mes VARCHAR(2),
    anio VARCHAR(4),
    fecha DATE,
    enlace VARCHAR(500),
    created_at DATETIME NULL
);

-- =========================================================
-- 3. CONTABILIDAD
-- =========================================================
CREATE TABLE contabilidad (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nombre VARCHAR(100) NOT NULL,
    anio YEAR NOT NULL,

    tipo_estado_financiero VARCHAR(150) NOT NULL,

    dia VARCHAR(2) NULL,
    mes VARCHAR(2) NULL,
    anio_detalle YEAR NOT NULL,

    nombre_original VARCHAR(200) NOT NULL,

    enlace VARCHAR(500) NOT NULL,

    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- 4. BECAS
-- =========================================================
CREATE TABLE IF NOT EXISTS becas (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del registro',
    
    -- Información de clasificación
    seccion VARCHAR(255) NOT NULL COMMENT 'Sección del documento (BECAS OFRECIDAS, RESUMEN, etc.)',
    categoria VARCHAR(10) NOT NULL DEFAULT '' COMMENT 'Categoría (año de referencia)',
    subcategoria VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'Subcategoría del documento',
    
    -- Información de periodo
    semestre VARCHAR(10) NOT NULL DEFAULT '' COMMENT 'Semestre (I, II, III)',
    tipo_periodo VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'Tipo de periodo (Semestre, Ciclo)',
    anio VARCHAR(10) NOT NULL DEFAULT '' COMMENT 'Año del documento',
    
    -- Información del documento
    nombre_original VARCHAR(500) NOT NULL DEFAULT '' COMMENT 'Nombre original completo del documento',
    enlace TEXT NOT NULL DEFAULT '' COMMENT 'URL del documento PDF',
    
    -- Control
    estado ENUM('activo', 'inactivo') DEFAULT 'activo' COMMENT 'Estado del documento',
    
    -- Timestamps
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de última actualización',
    
    -- Índices para mejorar rendimiento
    INDEX idx_seccion (seccion),
    INDEX idx_categoria (categoria),
    INDEX idx_anio (anio),
    INDEX idx_estado (estado),
    INDEX idx_seccion_anio (seccion, anio)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Becas y beneficios del portal de transparencia';


-- =========================================================
-- 5. INVERSIONES
-- =========================================================
CREATE TABLE inversiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion VARCHAR(255) NOT NULL,
    subseccion ENUM('Sí', 'No') DEFAULT 'No',
    tipo VARCHAR(255) NOT NULL,
    anio VARCHAR(20) NOT NULL,
    nombre_original VARCHAR(500) NOT NULL,
    enlace TEXT NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================================
-- 6. INVESTIGACIÓN
-- =========================================================
CREATE TABLE IF NOT EXISTS proyectos_investigacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_proyecto VARCHAR(50) NOT NULL, -- 'DGI', 'INSTITUTO_CIENTIFICO', 'TESIS'
    facultad VARCHAR(150) DEFAULT NULL,
    escuela_profesional VARCHAR(200) DEFAULT NULL,
    anio VARCHAR(20) NOT NULL,
    nombre_documento VARCHAR(300) NOT NULL,
    enlace_pdf VARCHAR(600) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    INDEX idx_tipo (tipo_proyecto),
    INDEX idx_facultad (facultad),
    INDEX idx_escuela (escuela_profesional),
    INDEX idx_anio (anio),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- 7. ALUMNOS
-- =========================================================
CREATE TABLE alumnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion VARCHAR(50) NOT NULL,                -- 'Pregrado', 'Posgrado', 'Segundas Especialidades'
    categoria VARCHAR(100) NOT NULL,             -- Ej: 'ALUMNOS MATRICULADOS POR SEMESTRE...'
    anio VARCHAR(100) NOT NULL,                  -- Puede ser un rango como '2017, 2018, ...' o un año solo
    enlace_pdf TEXT NOT NULL                     -- Enlace completo al PDF
);

-- =========================================================
-- 8. DOCENTES
-- =========================================================
CREATE TABLE docentes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion VARCHAR(50) NOT NULL,                -- 'Pregrado', 'Posgrado', 'Segundas Especialidades'
    categoria VARCHAR(100) NOT NULL,             -- Siempre 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN'
    semestre VARCHAR(20) NOT NULL,               -- Ej: '2025-II'
    mes VARCHAR(20) DEFAULT NULL,                -- NULL para Pregrado, o el mes específico
    programa VARCHAR(50) DEFAULT NULL,           -- 'PREGRADO', 'MAESTRÍA', 'DOCTORADO', 'ESTOMATOLOGÍA', 'OBSTETRICIA', 'ENFERMERÍA'
    enlace_pdf TEXT NOT NULL                     -- Enlace completo al PDF
);

-- =========================================================
-- 9. REMUNERACIONES
-- =========================================================
CREATE TABLE remuneraciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo TEXT NOT NULL,                        -- Título del documento
    enlace_pdf TEXT NOT NULL                     -- Enlace completo al PDF
);

-- =========================================================
-- 10. REGLAMENTOS
-- =========================================================
CREATE TABLE reglamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion VARCHAR(100) NOT NULL,               -- 'REGLAMENTOS', 'EJERCICIO PRE PROFESIONAL', 'INTERNADO', 'GRADOS Y TÍTULOS', 'POSGRADO', 'SEGUNDAS ESPECIALIDADES', 'DEFENSORIA UNIVERSITARIA'
    titulo TEXT NOT NULL,                        -- Título completo del reglamento
    resolucion VARCHAR(255) DEFAULT NULL,        -- Texto de resolución (puede ser NULL)
    es_subitem TINYINT(1) DEFAULT 0,             -- 1 si es modificación/subitem, 0 si principal
    enlace TEXT NOT NULL                         -- Enlace completo al PDF
);

-- =========================================================
-- 11. RESOLUCIONES
-- =========================================================
CREATE TABLE IF NOT EXISTS uac_resoluciones (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    grupo               VARCHAR(255) NOT NULL,
    subgrupo            VARCHAR(255) DEFAULT NULL,
    descripcion         TEXT NOT NULL,
    enlace_pdf          VARCHAR(255) NOT NULL,
    numero_resolucion   VARCHAR(100) NOT NULL,
    es_subresolucion    BOOLEAN DEFAULT FALSE
);

-- =========================================================
-- 12. DIRECTIVAS
-- =========================================================
CREATE TABLE directivas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion VARCHAR(50) NOT NULL,                -- 'Directivas' o 'Investigación'
    titulo TEXT NOT NULL,                        -- Título completo de la directiva
    resolucion VARCHAR(255) DEFAULT NULL,        -- Texto de la resolución (ej: 'Res. N° 276-2025/CU-UAC – Directiva N° 13-2025/VRAC-UAC')
    es_subdirectiva TINYINT(1) DEFAULT 0,        -- 1 si es una rectificación/modificación (subitem), 0 si es principal
    enlace_pdf TEXT NOT NULL                     -- Enlace completo al PDF
);

-- =========================================================
-- 13. DECÁLOGOS
-- =========================================================
CREATE TABLE decalogos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo TEXT NOT NULL,                        -- Título completo del decálogo
    enlace_pdf TEXT NOT NULL                     -- Enlace completo al PDF
);

-- =========================================================
-- 14 plan de studio
-- =========================================================

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

-- =========================================================
-- FIN DEL SCRIPT
-- =========================================================


-- =========================================================
-- insertar datos
-- =========================================================

INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'ESTATUTO UAC', 'Res. N°009-2014/AU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-009-2014-UAC-estatuto-260422.pdf', NULL);

SET @estatuto_id = LAST_INSERT_ID();

-- Modificaciones al Estatuto UAC (desde https://www.uandina.edu.pe/modificaciones-doc-normativos/)
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'Reforman en parte el Estatuto de la Universidad Andina del Cusco; por consiguiente, modifican el artículo 112 del diseño curricular del título VI del citado cuerpo normativo', 'Res. N° 015-2025/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_AU-015-2025-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman en parte el Estatuto de la Universidad Andina del Cusco; por consiguiente, modifican el literal LL) de la sexta disposición complementaria del título XIV debiendo reemplazar el término "LICENCIADO EN OBSTETRICIA" por el de "OBSTETRA"', 'Res. N° 014-2025/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_AU-014-2025-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman en parte el Estatuto de la Universidad Andina del Cusco; por consiguiente, modifican los artículos 17, 21 y 36 del citado estatuto', 'Res. N° 008-2025/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_AU-008-2025-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el estatuto de la Universidad Andina del Cusco, incorporando un segundo párrafo al artículo 57° del estatuto universitario vigente', 'Res. N° 009-2025/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_AU-009-2025-UAC-modifican-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman en parte el Estatuto de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, por consiguiente, modifican el artículo 14 del citado estatuto', 'Res. N° 005-2024/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_AU-005-2024-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, en lo que corresponde al 4.1 del sub numeral 4, del numeral 3. Vicerrectorado Administrativo del artículo 9 y numeral 1, del artículo 180, por cambio de nombre de la "Unidad de Servicios de Atención Integral a la Persona" a "Unidad de Salud"', 'Res. N° 014-2023/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_AU-014-2023-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014 y sus modificatorias, por consiguiente incluir en el Artículo 137° del Estatuto Universitario un literal D.; asimismo, modificar el literal B) del artículo N° 156 del Estatuto Universitario', 'Res. N° 010-2023/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-010-2023-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Rectifican de oficio el error material de la Resolución emitida por la Asamblea Universitaria con la que se reforma el Estatuto de la Universidad Andina del Cusco, en el sentido de cambiar la forma de elección de autoridades Rector, Vicerrectores y Decanos, mediante voto universal', 'Res. N° 009-2023/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/R_AU-009-2023-UAC-rectificacion-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto de la Universidad Andina del Cusco, aprobado por Resolución N° 09-AU-2014-UAC de fecha 7 de octubre de 2014, en el sentido de cambiar la forma de elección de autoridades Rector, Vicerrectores y Decanos, mediante voto universal, debiéndose por tanto, suprimir el literal F) del artículo 18°, modificar artículo 34, suprimir el literal P) del artículo 38° y modificar el artículo 42° del citado estatuto', 'Res. N° 008-2023/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/R_AU-008-2023-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, aprobar la modificación del subnumeral 6. del numeral 1 Vicerrectorado Académico del artículo 9° así como los artículos 194° y 195° del Estatuto Universitario', 'Res. N° 007-2023/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-007-2023-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, aprobar la modificación del artículo 141° del Estatuto Universitario', 'Res. N° 006-2023/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-006-2023-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, aprobar las modificaciones del artículo 10° del Estatuto Universitario', 'Res. N° 007-2022/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-007-2022-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014', 'Res. N° 002-2022/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-002-2022-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014 y. por consiguiente modifican el literal c) órganos de apoyo del art. 9°, capítulo I, de la estructura general, del título II, estructura orgánica de la Universidad y artículos 173 y 174 capítulo I de la Dirección de Planificación y Desarrollo Universitario del título XI de las Direcciones Universitarias.', 'Res. N° 017-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-017-2021-UAC-reforman-estatuto.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, y por consiguiente, adecuan y modifican la estructura y funcionamiento del Vicerrectorado de Investigación.', 'Res. N° 016-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-016-2021-UAC-modifican-estructura-funcionamiento-vrin.pdf', @estatuto_id),
('Documentos normativos', 'Reforman el Estatuto Universitario aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014 y, por consiguiente modifican el literal b) órganos de apoyo del art.9° capítulo I, de la estructura general, del título II estructura orgánica de la Universidad.', 'Res. N° 015-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-015-2021-UAC-modifican-literal-b.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, por consiguiente, crean la Unidad de Becas y Crédito Interinstitucional, como órgano de línea de la Dirección de Cooperación Nacional e Internacional de la UAC.', 'Res. N° 014-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-014-2021-UAC-modifican-unidad-becas-credito.pdf', @estatuto_id),
('Documentos normativos', 'Rectifican de oficio el error material contenido en la Resolución N° 001-AU-2021-UAC de fecha 03 de enero de 202, debe decir "Cusco, 03 de enero de 2021"', 'Res. N° 004-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-004-2021-UAC-rectifican-error-material.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el inciso 6.4 del numeral 6. del literal d) órganos de línea del Vicerrectorado Académico del numeral 1. Vicerrectorado Académico del art. 9° y el art. 200° del Estatuto Universitario y en consecuencia e todos los documentos normativos de la UAC que correspondan, debiendo consignar la denominación "Coordinación del Sistema de Seguimiento al Egresado y Graduado de la Universidad Andina del Cusco"', 'Res. N° 003-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-003-2021-UAC-modifican-inciso.pdf', @estatuto_id),
('Documentos normativos', 'Suprimen el texto de la segunda disposición complementaria del título XIV del estatuto universitario vigente de la Universidad Andina del Cusco', 'Res. N° 002-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-002-2021-UAC-suprimen-texto-segunda-disposicion.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el Estatuto Universitario de la Universidad Andina del Cusco en lo que corresponde al literal h) de la séptima disposición complementaria del Estatuto Universitario "H) Licenciado en educación (con mención en la especialidad correspondiente), asimismo, incluir en la citada disposición complementaria del Estatuto Universitario en el literal que corresponda "Licenciado en Servicio Social"', 'Res. N° 001-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-001-2021-UAC-modifican-literal-h.pdf', @estatuto_id),
('Documentos normativos', 'Modifican artículos 3, 11, 20, 22, 26, 27 y 29 del Reglamento de la Asamblea Universitaria de la Universidad Andina del Cusco aprobada mediante Resolución N° 010-AU-2014-UAC de fecha 30 de diciembre de 2014.', 'Res. N° 007-2020/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-007-2020-UAC-modifican-articulos.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el artículo 226° del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 003-2020/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-003-2020-UAC-modifican-articulo-226.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el artículo 9, del punto 2. Vicerrectorado de Investigación, en el inciso e. órganos de linea.', 'Res. N° 002-2020/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-002-2020-UAC-modifican-articulo-9.pdf', @estatuto_id),
('Documentos normativos', 'Modifican la quinta disposición transitoria del título XV del Estatuto Universitario, disposición modificada por Resolución N° 439-CU-2018-UAC del 03 de setiembre 2018.', 'Res. N° 012-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-012-2019-UAC-modifican-quinta-disposicion.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el literal m) del artículo 206° del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 011-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-011-2019-UAC-modifican-literal-m.pdf', @estatuto_id),
('Documentos normativos', 'Crean la Coordinación de Gestión con la Superintendencia Nacional de Educación Superior Universitaria (SUNEDU) de la Universidad Andina del Cusco.', 'Res. N° 010-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-010-2019-UAC-crean-coordinacion-gestion-sunedu.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el literal "A" del artículo 140° del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 006-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-006-2019-UAC-modifican-literal-a.pdf', @estatuto_id),
('Documentos normativos', 'Incluyen artículo respecto a programas de formación continua en Estatuto de la Universidad Andina del Cusco aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 005-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-005-2019-UAC-incluyen-articulo.pdf', @estatuto_id),
('Documentos normativos', 'Modifican artículo N° 157° del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 004-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-004-2019-UAC-modifican-articulo.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el numeral 5 de la tercera disposición complementaria del Estatuto Universitario aprobado por resolución N° 09-AU-2014-UAC.', 'Res. N° 003-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-003-2019-UAC-modifican-numeral-5.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el literal a. del artículo N° 102° del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 002-2019/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-002-2019-UAC-modifican-literal-a.pdf', @estatuto_id),
('Documentos normativos', 'Modifican algunos artículos del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 006-2018/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-006-2018-UAC-modifican-algunos-articulos.pdf', @estatuto_id),
('Documentos normativos', 'Rectifican de oficio error material de la Resolución N° 002-AU-2018-UAC de fecha 21 de febrero de 2018.', 'Res. N° 003-2018/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-003-2018-UAC-rectifican-error-material.pdf', @estatuto_id),
('Documentos normativos', 'Incluyen artículos y modifican algunos artículos así como la octava y novena disposición transitoria del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 002-2018/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-002-2018-UAC-incluyen-articulos-modifican.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el inciso d. del literal b del artículo 10°, así como el artículo 132° y primer párrafo del artículo 133° del Estatuto Universitario, aprobado mediante Resolución N° 009-AU-2014-UAC.', 'Res. N° 001-2018/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-001-2018-UAC-modifican-inciso-d.pdf', @estatuto_id),
('Documentos normativos', 'Modifican artículos así como la quinta disposición complementaria del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 004-2017/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-004-2017-UAC-modifican-articulos.pdf', @estatuto_id),
('Documentos normativos', 'Modifican artículo 199° así como el literal d) de la quinta disposición complementaria del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 003-2017/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-003-2017-UAC-modifican-articulo-199.pdf', @estatuto_id),
('Documentos normativos', 'Modifican artículos pertinentes donde se menciona sede o sedes en el Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 020-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-020-2016-UAC-modifica-articulos-pertinentes.pdf', @estatuto_id),
('Documentos normativos', 'Modifican algunos artículos así como la sexta y séptima disposición complementaria, quinta disposición transitoria y suprimen artículos del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 019-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-019-2016-UAC-modifican-articulos.pdf', @estatuto_id),
('Documentos normativos', 'Modifican el artículo 97°, el segundo párrafo del art. 108°, el art. 115° los artículos pertinentes del Estatuto Universitario donde diga cilo académico o ciclos académicos del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 013-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-013-2016-UAC-modifican-articulos-pertinentes.pdf', @estatuto_id),
('Documentos normativos', 'Dejan sin efecto la novena disposición complementaria del Estatuto Universitario aprobado por Resolución N° 09-AU-2014-UAC.', 'Res. N° 012-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-012-2016-UAC-dejan-sin-efecto-novena-disposicion.pdf', @estatuto_id),
('Documentos normativos', 'Aprueban ejecución presupuestal 2015 de la Universidad Andina del Cusco.', 'Res. N° 009-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-009-2016-UAC-aprueban-ejecucion-presupuestal.pdf', @estatuto_id),
('Documentos normativos', 'Modifican la sexta disposición transitoria del Estatuto Universitario.', 'Res. N° 007-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-007-2016-UAC-modifican-sexta-disposicion.pdf', @estatuto_id),
('Documentos normativos', 'Modifican denominación de la Escuela Profesional de Ingeniería de Sistemas de Información por la de Escuela Profesional de Ingeniería de Sistemas.', 'Res. N° 005-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-005-2016-UAC-modifican-denominacion-ep-sistemas.pdf', @estatuto_id),
('Documentos normativos', 'Modifican denominación de la Escuela Profesional de Marketing de Negocios por la de Escuela Profesional de Marketing.', 'Res. N° 004-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-004-2016-UAC-modifican-denominacion-ep-marketing.pdf', @estatuto_id),
('Documentos normativos', 'Modifican denominación de la Escuela Profesional de Finanzas Internacionales por la de Escuela Profesional de Finanzas.', 'Res. N° 003-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-003-2016-UAC-modifican-denominacion-ep-finanzas.pdf', @estatuto_id),
('Documentos normativos', 'Crean en la Escuela de Posgrado de la Universidad Andina del Cusco nuevos programas de maestría y doctorado.', 'Res. N° 002-2016/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-002-2016-UAC-crean-escuela-posgrado.pdf', @estatuto_id),
('Documentos normativos', 'Modifican denominación de la Facultad de Ingeniería por el de Ingeniería y Arquitectura.', 'Res. N° 009-2015/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-009-2015-UAC-modifican-denominacion-fia.pdf', @estatuto_id),
('Documentos normativos', 'Reorganizan la Facultad de Ciencias Sociales y Educación y por consiguiente cambian su denominación a Facultad de Ciencias y Humanidades.', 'Res. N° 008-2015/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-008-2015-UAC-reorganizan-fch.pdf', @estatuto_id);

-- TUPA Y TARIFARIO 2026
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'TEXTO ÚNICO DE PROCEDIMIENTOS ADMINISTRATIVOS – TUPA UAC 2026', 'Res. N° 710-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/tupa-uac.pdf', NULL),
('Documentos normativos', 'TARIFARIO UAC 2026', 'Res. N° 710-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/tarifario-uac.pdf', NULL);

-- OTROS DOCUMENTOS NORMATIVOS
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'PROYECTO GENERAL DE DESARROLLO 2015 – 2025', 'Res. N°295-2015/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/planificacion/PGD-2015-2025-UAC-280416.pdf', NULL),
('Documentos normativos', 'PLAN OPERATIVO INSTITUCIONAL 2025', 'Res. N°696-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-696-2024-UAC-poi-2025.pdf', NULL),
('Documentos normativos', 'PLAN ESTRATÉGICO INSTITUCIONAL 2023-2026', 'Res. N°507-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-507-2022-UAC-pei-2023-2026.pdf', NULL);

-- REGLAMENTO ORGANIZACIONAL DE FUNCIONES (ROF)
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'REGLAMENTO ORGANIZACIONAL DE FUNCIONES – ROF', 'Res. N°477-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/rof-uac.pdf', NULL);

SET @rof_id = LAST_INSERT_ID();

-- Modificaciones al ROF (desde https://www.uandina.edu.pe/modificaciones-doc-normativos/)
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'Modifican el Reglamento de Organización y Funciones (ROF) de la Universidad Andina del Cusco, aprobado mediante Resolución N° 477-2017-CU-UAC de fecha 22 de diciembre de 2017, incluyendo dentro del artículo 97° del citado reglamento, un numeral 97.8 referente a la Unidad de Asesoría Legal en Propiedad Intelectual', 'Res. N° 010-2024/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-010-2024-UAC-modifican-rof.pdf', @rof_id),
('Documentos normativos', 'Modificar el Reglamento de Organización y Funciones – ROF de la Universidad Andina del Cusco, aprobado mediante Resolución de Consejo Universitario N° 477-2017-CU-UAC de fecha 22 de diciembre de 2017, en lo que respecta al artículo 109° referente a la Dirección de Gestión de Calidad', 'Res. N° 514-2023/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-514-2023-UAC-modifican-rof.pdf', @rof_id),
('Documentos normativos', 'Aprueban la modificación y adecuación del Reglamento de Organización y Funciones (ROF) de la Oficina de Marketing, Promoción e Imagen Institucional de la Universidad Andina del Cusco.', 'Res. N° 253-2022/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU- 253-2022-UAC-aprueban-rof-marketing.pdf', @rof_id),
('Documentos normativos', 'Aprueban la modificación y adecuación del Reglamento de Organización y Funciones (ROF) de la Dirección de Planificación y Desarrollo Universitario de la Universidad Andina del Cusco.', 'Res. N° 252-2022/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU- 252-2022-UAC-aprueban-rof-dipla.pdf', @rof_id),
('Documentos normativos', 'Aprueban la modificación y adecuación del Reglamento de Organización y Funciones (ROF) del Vicerrectorado de Investigación de la Universidad Andina del Cusco.', 'Res. N° 251-2022/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU- 251-2022-UAC-aprueban-rof-vrin.pdf', @rof_id),
('Documentos normativos', 'Aprueban el Organigrama Estructural de la Facultad de Ciencias de la Salud y por consiguiente modifican el Reglamento de Organización y Funciones – ROF de la Universidad Andina del Cusco, aprobado con Resolución N° 477-CU-2017-UAC.', 'Res. N° 215-2022/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU- 215-2022-UAC-aprueban-organigrama-fcsa.pdf', @rof_id),
('Documentos normativos', 'Aprueban la modificación de la Estructura Orgánica de Facultades, y de la Facultad de Ciencias de la Salud de la Universidad Andina del Cusco, en el Reglamento de Organización y Funciones (ROF)', 'Res. N° 213-2022/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU- 213-2022-UAC-moficican-estructura-facultades.pdf', @rof_id),
('Documentos normativos', 'Reforman el Estatuto Universitario aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014 y, por consiguiente, retiran el numeral 4. Departamento Académico de Ciencias Biomédicas del literal e) en la Facultad de Ciencias de la Salud de la cuarta disposición complementaria.', 'Res. N° 008-2022/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU- 008-2022-UAC-reforman-estatuto-dptos-fcsa.pdf', @rof_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre de 2014, aprobar las modificaciones del artículo 10° del Estatuto Universitario.', 'Res. N° 007-2022/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU- 007-2022-UAC-reforman-estatuto-estructura-facultades.pdf', @rof_id),
('Documentos normativos', 'Rectifican el error material contenido en la Resolución N° 002-AU-2022-UAC de fecha 03 de enero de 2022.', 'Res. N° 003-2022/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU- 003-2022-UAC-rectifican-resolucion.pdf', @rof_id),
('Documentos normativos', 'Reforman el Estatuto Universitario aprobado por resolución N° 009-AU-2014-UAC de fecha 07 e octubre del 2014 y. por consiguiente modifican el literal c) órganos de apoyo del art. 9° capítulo I, de la estructura general, del título II. estructura orgánica de la Universidad y artículos 173 y 174 capítulo I. de la Dirección de Planificación y Desarrollo Universitario del Título XI. de las Direcciones Universitarias.', 'Res. N° 017-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU- 017-2021-UAC-estructura-organiza-dipla.pdf', @rof_id),
('Documentos normativos', 'Reforman el Estatuto Universitario de la Universidad Andina del Cusco, aprobando por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014, por consiguiente, adecuan y modifican la estructura y funcionamiento del Vicerrectorado de Investigación.', 'Res. N° 016-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU- 016-2021-UAC-estructura-vrin.pdf', @rof_id),
('Documentos normativos', 'Reforman el Estatuto Universitario aprobado por Resolución N° 009-AU-2014-UAC de fecha 07 de octubre del 2014 y, por consiguiente modifican el literal b) órganos de apoyo del art. 9° capítulo I. de la estructura general, del título II. estructura orgánica de la Universidad.', 'Res. N° 015-2021/AU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU- 015-2021-UAC-reforman-estatuto-estructura-general.pdf', @rof_id);

-- REGLAMENTO GENERAL
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'REGLAMENTO GENERAL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°293-2015/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2015/R_CU-293-2015-UAC-reglamento-general-uac.pdf', NULL);

SET @reglamento_general_id = LAST_INSERT_ID();

INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'Modifican artículo 57° del Reglamento General de la Universidad Andina del Cusco', 'Res. N° 464-2017/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-464-2017-UAC-modificacion-reglamento-general-uac.pdf', @reglamento_general_id);

-- OTROS DOCUMENTOS
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'TEMARIO DE ADMISIÓN', NULL, 0, 'https://www.uandina.edu.pe/descargas/transparencia/temario-admision.pdf', NULL),
('Documentos normativos', 'MODELO EDUCATIVO UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°284-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/modelo-educativo/', NULL);

-- ============================================================================
-- POLÍTICAS
-- ============================================================================

INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Políticas', 'POLÍTICAS DE DESARROLLO UNIVERSITARIO', 'Res. N°008-2016/AU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-008-2016-UAC-politicas-desarrollo-uac.pdf', NULL),
('Políticas', 'POLÍTICA Y OBJETIVOS DE SEGURIDAD DE LA INFORMACIÓN DEL SISTEMA DE GESTIÓN DE SEGURIDAD DE LA INFORMACIÓN – SGSI (Ver 2.0)', 'Res. N°350-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-350-2023-UAC-politicas-sgsi-uac-v2.pdf', NULL),
('Políticas', 'POLÍTICA AMBIENTAL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°294-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-294-2021-UAC-politica-ambiental.pdf', NULL),
('Políticas', 'POLÍTICA DE PROTECCIÓN DE DATOS PERSONALES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°491-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-491-2018-UAC-politica-proteccion-datos-personales.pdf', NULL);

-- ============================================================================
-- PLANES
-- ============================================================================

INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Planes', 'PLAN DE ECOEFICIENCIA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°374-2020/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2020/R_CU-374-2020-UAC-plan-ecoeficiencia-uac.pdf', NULL);

INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Decálogos', 'DECÁLOGO DEL ESTUDIANTE UNIVERSITARIO PERUANO', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-estudiante-universitario.pdf', NULL),
('Decálogos', 'DECÁLOGO DEL DOCENTE UNIVERSITARIO PERUANO', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-docente-universitario.pdf', NULL),
('Decálogos', 'DECÁLOGO DEL ADMINISTRATIVO UNIVERSITARIO PERUANO', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-administrativo-universitario.pdf', NULL);

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================




-- 2. Inserción de datos generales (manteniendo exactamente el orden de la imagen)

-- === Documentos normativos ===
-- === Documentos normativos ===
-- ESTATUTO UAC y sus modificaciones

-- ============================================================================
-- TABLAS DE FACULTADES (Sin cambios)
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

-- Sentencias INSERT para la tabla actas
-- Generado: 2026-01-07 16:03:55
-- Total de registros: 798

SET NAMES utf8mb4;
SET time_zone = '+00:00';

INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '19', '11', '2025', '2025-11-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-191125.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '8', '9', '2025', '2025-09-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-080925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '19', '8', '2025', '2025-08-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-190825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '25', '6', '2025', '2025-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-250625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '5', '6', '2025', '2025-06-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFe-050625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '26', '5', '2025', '2025-05-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-260525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '8', '4', '2025', '2025-04-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFe-080425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '31', '3', '2025', '2025-03-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-310325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '30', '3', '2025', '2025-03-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-300325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '20', '2', '2025', '2025-02-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCEAC-acta-CFo-200225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '27', '12', '2024', '2024-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-271224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '19', '12', '2024', '2024-12-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFe-191224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '27', '11', '2024', '2024-11-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-271124.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '28', '10', '2024', '2024-10-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-281024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '26', '9', '2024', '2024-09-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-260924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '28', '8', '2024', '2024-08-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-280824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '25', '6', '2024', '2024-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-250624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '13', '6', '2024', '2024-06-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFe-130624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '28', '5', '2024', '2024-05-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-280524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '30', '4', '2024', '2024-04-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-300424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '25', '3', '2024', '2024-03-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-250324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '29', '2', '2024', '2024-02-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFo-290224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '27', '12', '2023', '2023-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFe-271223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '27', '12', '2023', '2023-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-271223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '5', '12', '2023', '2023-12-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFe-051223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '28', '11', '2023', '2023-11-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-281123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '26', '10', '2023', '2023-10-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-261023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '29', '9', '2023', '2023-09-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFe-290923.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '7', '9', '2023', '2023-09-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-070923.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '29', '8', '2023', '2023-08-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-290823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '7', '8', '2023', '2023-08-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFe-070823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '26', '6', '2023', '2023-06-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-260623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '7', '6', '2023', '2023-06-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFe-070623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '30', '5', '2023', '2023-05-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-300523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '25', '4', '2023', '2023-04-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-250423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '29', '3', '2023', '2023-03-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-290323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '16', '2', '2023', '2023-02-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFo-160223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', '26', '2', '2020', '2020-02-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-260220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '18', '12', '2019', '2019-12-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFe-181219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Ordinaria - Consejo de Facultad', '9', '12', '2019', '2019-12-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-091219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Ordinaria - Consejo de Facultad', '14', '11', '2019', '2019-11-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-141119.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '30', '9', '2019', '2019-09-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFe-300919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Ordinaria - Consejo de Facultad', '20', '9', '2019', '2019-09-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-200919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Ordinaria - Consejo de Facultad', '26', '8', '2019', '2019-08-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-260819.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Ordinaria - Consejo de Facultad', '12', '6', '2019', '2019-06-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-120619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2019', 'Sesión Ordinaria - Consejo de Facultad', '29', '5', '2019', '2019-05-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-290519.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '20', '12', '2018', '2018-12-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFe-201218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '10', '12', '2018', '2018-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-101218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '28', '11', '2018', '2018-11-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-281118.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '26', '10', '2018', '2018-10-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-261018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '28', '9', '2018', '2018-09-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-280918.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '29', '8', '2018', '2018-08-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-290818.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '13', '6', '2018', '2018-06-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-130618.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '9', '5', '2018', '2018-05-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFe-090518.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '4', '5', '2018', '2018-05-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-040518.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '16', '4', '2018', '2018-04-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-160418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '14', '3', '2018', '2018-03-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-140318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2018', 'Sesión Ordinaria - Consejo de Facultad', '26', '2', '2018', '2018-02-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-260218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '11', '12', '2017', '2017-12-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-111217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '30', '11', '2017', '2017-11-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-301117.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '31', '10', '2017', '2017-10-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-311017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '21', '9', '2017', '2017-09-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-210917.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '21', '8', '2017', '2017-08-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-210817.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '23', '6', '2017', '2017-06-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-230617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Extraordinaria - Consejo de Facultad', '9', '6', '2017', '2017-06-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFe-090617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '21', '4', '2017', '2017-04-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-210417.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '9', '3', '2017', '2017-03-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-090317.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2017', 'Sesión Ordinaria - Consejo de Facultad', '10', '2', '2017', '2017-02-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFo-100217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-170420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-290420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-060520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-110520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-150520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-010620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-220620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-260620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-090720.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-150720.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-240920.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-291020.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-261120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-141220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-301220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-250321.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-060521.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-110621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-050721.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-260821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-300921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-291021.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-111121a.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-111121b.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFr-191121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CF-191121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-261121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-021221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-031221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFov-071221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-071221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-201221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-221221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCEAC-acta-CFev-271221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FCEAC-acta-CFov-301122.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FCEAC-acta-CFov-281222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFev-240223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCEAC-acta-CFev-160523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES', '2024', 'Consejo de Facultad', NULL, NULL, '2024', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCEAC-acta-CFr-021224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '5', '12', '2025', '2025-12-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-051225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '3', '10', '2025', '2025-10-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-031025.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '18', '9', '2025', '2025-09-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-180925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '16', '9', '2025', '2025-09-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-160925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '2', '9', '2025', '2025-09-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-020925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '14', '8', '2025', '2025-08-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-140825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '31', '7', '2025', '2025-07-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-310725.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '30', '6', '2025', '2025-06-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-300625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '27', '6', '2025', '2025-06-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-270625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '18', '6', '2025', '2025-06-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-180625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '29', '5', '2025', '2025-05-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-290525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '15', '5', '2025', '2025-05-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-150525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '24', '4', '2025', '2025-04-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-240425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '17', '3', '2025', '2025-03-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-170325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '13', '3', '2025', '2025-03-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-130325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '11', '2', '2025', '2025-02-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFo-110225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '5', '2', '2025', '2025-02-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FDER-acta-CFe-050225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '17', '12', '2024', '2024-12-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-171224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '6', '12', '2024', '2024-12-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-061224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '5', '12', '2024', '2024-12-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-051224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '22', '11', '2024', '2024-11-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-221124.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '24', '10', '2024', '2024-10-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-241024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '3', '10', '2024', '2024-10-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-031024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '24', '9', '2024', '2024-09-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-240924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '27', '8', '2024', '2024-08-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-270824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '9', '8', '2024', '2024-08-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-090824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '21', '6', '2024', '2024-06-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-210624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '20', '6', '2024', '2024-06-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-200624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '29', '5', '2024', '2024-05-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-290524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '30', '4', '2024', '2024-04-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-300424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '4', '4', '2024', '2024-04-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-040424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '12', '3', '2024', '2024-03-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-120324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '7', '3', '2024', '2024-03-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-070324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '20', '2', '2024', '2024-02-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFo-200224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '9', '2', '2024', '2024-02-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FDER-acta-CFe-090224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '21', '12', '2023', '2023-12-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFe-211223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '7', '12', '2023', '2023-12-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFo-071223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '6', '12', '2023', '2023-12-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-061223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '20', '11', '2023', '2023-11-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-201123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '26', '10', '2023', '2023-10-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-261023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '6', '10', '2023', '2023-10-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFe-061023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '18', '9', '2023', '2023-09-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-180923.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '22', '8', '2023', '2023-08-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFe-220823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '8', '8', '2023', '2023-08-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-080823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '20', '6', '2023', '2023-06-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFo-200623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '29', '5', '2023', '2023-05-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFe-290523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '9', '5', '2023', '2023-05-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFe-090523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '4', '5', '2023', '2023-05-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFo-040523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '13', '4', '2023', '2023-04-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFo-130423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '4', '4', '2023', '2023-04-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFo-040423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '30', '3', '2023', '2023-03-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFo-300323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '14', '3', '2023', '2023-03-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFe-140323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '28', '2', '2023', '2023-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-280223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '28', '2', '2023', '2023-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FDER-acta-CFe-280223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '17', '3', '2021', '2021-03-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-170321.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', '28', '12', '2020', '2020-12-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-281220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', '13', '3', '2020', '2020-03-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-130320.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '27', '12', '2019', '2019-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-271219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '22', '11', '2019', '2019-11-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-221119.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '25', '9', '2019', '2019-09-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-250919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '16', '9', '2019', '2019-09-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-160919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '28', '6', '2019', '2019-06-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-280619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '13', '6', '2019', '2019-06-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-130619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '28', '2', '2019', '2019-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-280219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '10', '12', '2018', '2018-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-101218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '11', '10', '2018', '2018-10-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-111018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '4', '9', '2018', '2018-09-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-040918.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '30', '4', '2018', '2018-04-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-300418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '17', '4', '2018', '2018-04-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFe-170418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '6', '4', '2018', '2018-04-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-060418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '6', '3', '2018', '2018-03-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-060318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '9', '2', '2018', '2018-02-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-090218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '21', '12', '2017', '2017-12-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-211217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '7', '12', '2017', '2017-12-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-071217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '14', '11', '2017', '2017-11-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-141117.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '12', '10', '2017', '2017-10-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-121017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '12', '9', '2017', '2017-09-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-120917.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '16', '8', '2017', '2017-08-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-160817.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '5', '6', '2017', '2017-06-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-050617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '4', '5', '2017', '2017-05-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-040517.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '3', '4', '2017', '2017-04-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-030417.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2017', 'Sesión Ordinaria - Consejo de Facultad', '27', '2', '2017', '2017-02-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFo-270217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2015', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-actas-cf-ordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2014', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2014', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-actas-cf-ordinarias-2014.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2016', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-actas-cf-ordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2014', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2014', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-actas-cf-extraordinarias-2014.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2015', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-actas-cf-extraordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2016', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-actas-cf-extraordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-080420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-050520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-190620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-150720.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-290920.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-061020.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2020', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-261120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-090421.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-130521.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-110621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-070721.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-070921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-280921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-251021.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-221121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-031221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-271221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-271221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-040322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-290322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-030522.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-230622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-310822.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-260922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-251022.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-101122.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFov-071222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-191222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-271222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE DERECHO Y CIENCIA POLÍTICA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FDER-acta-CFev-140223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '20', '11', '2025', '2025-11-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFe-201125.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '9', '10', '2025', '2025-10-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFo-091025.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '26', '9', '2025', '2025-09-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFo-260925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '22', '8', '2025', '2025-08-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFo-220825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '18', '6', '2025', '2025-06-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFo-180625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '29', '5', '2025', '2025-05-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFo-290525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '29', '5', '2025', '2025-05-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFe-290525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '24', '4', '2025', '2025-04-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFe-240425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '26', '3', '2025', '2025-03-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFo-260325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Ordinaria - Consejo de Facultad', '24', '2', '2025', '2025-02-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFo-240225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '6', '2', '2025', '2025-02-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FIA-acta-CFe-060225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '6', '12', '2024', '2024-12-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FIA-acta-CFe-061224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '2', '12', '2024', '2024-12-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FIA-acta-CFe-021224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '4', '11', '2024', '2024-11-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FIA-acta-CFo-041124.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '25', '9', '2024', '2024-09-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FIA-acta-CFo-250924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '29', '8', '2024', '2024-08-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FIA-acta-CFo-290824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2024', 'Sesión Ordinaria - Consejo de Facultad', '28', '6', '2024', '2024-06-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FIA-acta-CFo-280624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '22', '5', '2024', '2024-05-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FIA-acta-CFe-220524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '29', '12', '2023', '2023-12-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-291223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '22', '12', '2023', '2023-12-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFe-221223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '5', '12', '2023', '2023-12-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFe-051223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '30', '11', '2023', '2023-11-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-301123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '30', '11', '2023', '2023-11-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFe-301123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '28', '11', '2023', '2023-11-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFe-281123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '30', '10', '2023', '2023-10-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-301023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '29', '9', '2023', '2023-09-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-290923.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '31', '8', '2023', '2023-08-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-310823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '23', '6', '2023', '2023-06-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFe-230623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '23', '6', '2023', '2023-06-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-230623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '26', '4', '2023', '2023-04-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-260423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '11', '4', '2023', '2023-04-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFe-110423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '31', '3', '2023', '2023-03-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-310323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '22', '3', '2023', '2023-03-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFe-220323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2023', 'Sesión Ordinaria - Consejo de Facultad', '28', '2', '2023', '2023-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FIA-acta-CFo-280223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', '19', '10', '2022', '2022-10-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFe-191022.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Ordinaria - Consejo de Facultad', '15', '9', '2020', '2020-09-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-150920.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Ordinaria - Consejo de Facultad', '25', '6', '2020', '2020-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-250620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', '25', '6', '2020', '2020-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-250620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Ordinaria - Consejo de Facultad', '12', '6', '2020', '2020-06-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-120620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Ordinaria - Consejo de Facultad', '21', '5', '2020', '2020-05-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-210520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', '8', '5', '2020', '2020-05-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-080520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Extraordinaria - Consejo de Facultad', '6', '5', '2020', '2020-05-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-060520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Ordinaria - Consejo de Facultad', '21', '4', '2020', '2020-04-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-210420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2020', 'Sesión Ordinaria - Consejo de Facultad', '17', '2', '2020', '2020-02-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-170220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '10', '12', '2019', '2019-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-101219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '14', '11', '2019', '2019-11-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-141119.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '14', '10', '2019', '2019-10-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-141019.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '17', '9', '2019', '2019-09-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-170919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '17', '9', '2019', '2019-09-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-170919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '6', '9', '2019', '2019-09-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-060919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '20', '8', '2019', '2019-08-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-200819.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '13', '6', '2019', '2019-06-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-130619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Extraordinaria - Consejo de Facultad', '17', '5', '2019', '2019-05-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-170519.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2019', 'Sesión Ordinaria - Consejo de Facultad', '14', '5', '2019', '2019-05-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-140519.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '12', '12', '2018', '2018-12-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-121218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '10', '12', '2018', '2018-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-101218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '10', '12', '2018', '2018-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-101218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '28', '11', '2018', '2018-11-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-281118.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '29', '10', '2018', '2018-10-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-291018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '9', '10', '2018', '2018-10-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-091018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '26', '9', '2018', '2018-09-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-260918.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '24', '8', '2018', '2018-08-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-240818.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '13', '6', '2018', '2018-06-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-130618.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '1', '6', '2018', '2018-06-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-010618.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '1', '6', '2018', '2018-06-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-010618.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '8', '5', '2018', '2018-05-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-080518.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '2', '5', '2018', '2018-05-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-020518.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '6', '4', '2018', '2018-04-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-060418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '13', '3', '2018', '2018-03-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-130318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '2', '3', '2018', '2018-03-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFe-020318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Ordinaria - Consejo de Facultad', '13', '2', '2018', '2018-02-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFo-130218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2016', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-actas-cf-ordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2015', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-actas-cf-ordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2017', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2017', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-actas-cf-ordinarias-2017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2015', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-actas-cf-extraordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2016', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-actas-cf-extraordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2017', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2017', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-actas-cf-extraordinarias-2017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2018', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2018', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-actas-cf-extraordinarias-2018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-180321.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-270421.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-270421.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-310521.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-250621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-090721.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-180821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-010921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-300921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-291021.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-041121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-251121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-251121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-031221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFev-271221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FIA-acta-CFov-291221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-280222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFev-210322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-310322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-290422.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFev-240522.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-310522.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-300622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-020922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-300922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-281022.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFov-101122.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE INGENIERÍA Y ARQUITECTURA', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FIA-acta-CFev-231222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '25', '9', '2025', '2025-09-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCSH-acta-CFo-250925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '17', '6', '2025', '2025-06-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCSH-acta-CFe-170625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '16', '6', '2025', '2025-06-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCSH-acta-CFe-160625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '11', '4', '2025', '2025-04-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCSH-acta-CFe-110425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2025', 'Sesión Ordinaria - Consejo de Facultad', '14', '3', '2025', '2025-03-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCSH-acta-CFo-140325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '7', '2', '2025', '2025-02-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FCSH-acta-CFe-070225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '30', '12', '2024', '2024-12-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-301224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '18', '12', '2024', '2024-12-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-181224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '5', '12', '2024', '2024-12-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-051224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '22', '11', '2024', '2024-11-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFo-221124.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '29', '10', '2024', '2024-10-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-291024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '23', '10', '2024', '2024-10-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-231024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '18', '9', '2024', '2024-09-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFo-180924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '28', '8', '2024', '2024-08-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-280824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '16', '8', '2024', '2024-08-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFo-160824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '25', '6', '2024', '2024-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-250624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '14', '6', '2024', '2024-06-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFo-140624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '6', '5', '2024', '2024-05-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-060524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '12', '4', '2024', '2024-04-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFo-120424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '15', '3', '2024', '2024-03-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFo-150324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '6', '3', '2024', '2024-03-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFe-060324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2024', 'Sesión Ordinaria - Consejo de Facultad', '16', '2', '2024', '2024-02-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/FCSH-acta-CFo-160224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '15', '12', '2023', '2023-12-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFo-151223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '1', '12', '2023', '2023-12-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFo-011223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '13', '11', '2023', '2023-11-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFo-131123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '30', '10', '2023', '2023-10-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-301023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '26', '10', '2023', '2023-10-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-261023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '11', '10', '2023', '2023-10-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-111023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '4', '10', '2023', '2023-10-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFo-041023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '6', '9', '2023', '2023-09-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-060923.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '31', '8', '2023', '2023-08-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-310823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Ordinaria - Consejo de Facultad', '3', '7', '2023', '2023-07-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFo-030723.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '13', '6', '2023', '2023-06-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-130623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '29', '3', '2023', '2023-03-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-290323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '28', '2', '2023', '2023-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-280223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Ordinaria - Consejo de Facultad', '28', '12', '2022', '2022-12-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2022/FCSH-acta-CFo-281222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '3', '5', '2022', '2022-05-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FCSH-acta-CFe-0305223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '23', '12', '2021', '2021-12-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-231221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '7', '12', '2021', '2021-12-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-071221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '3', '12', '2021', '2021-12-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-031221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '25', '11', '2021', '2021-11-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-251121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Ordinaria - Consejo de Facultad', '12', '11', '2021', '2021-11-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFo-121121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Ordinaria - Consejo de Facultad', '18', '10', '2021', '2021-10-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFo-181021.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Ordinaria - Consejo de Facultad', '3', '9', '2021', '2021-09-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFo-030921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Ordinaria - Consejo de Facultad', '20', '8', '2021', '2021-08-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFo-200821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '19', '8', '2021', '2021-08-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-190821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '1', '7', '2021', '2021-07-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-010721.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '25', '6', '2021', '2021-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-250621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2020', 'Sesión Extraordinaria - Consejo de Facultad', '3', '1', '2020', '2020-01-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFe-030120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2015', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-ordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2014', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2014', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-ordinarias-2014.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2016', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-ordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2017', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2017', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-ordinarias-2017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2014', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2014', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-extraordinarias-2014.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2015', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-extraordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2016', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-extraordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2017', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2017', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-actas-cf-extraordinarias-2017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFov-301121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFev-271221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFov-030622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFev-200622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFov-300622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFev-220822.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFov-061022.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFev-120922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFov-271022.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS Y HUMANIDADES', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FCSH-acta-CFov-051222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '14', '10', '2025', '2025-10-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFe-141025.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Ordinaria - Consejo de Facultad', '28', '8', '2025', '2025-08-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFo-280825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '14', '8', '2025', '2025-08-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFe-140825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '5', '8', '2025', '2025-08-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFe-050825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '31', '7', '2025', '2025-07-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFe-310725.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Ordinaria - Consejo de Facultad', '23', '6', '2025', '2025-06-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFo-230625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '13', '6', '2025', '2025-06-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFe-130625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '4', '6', '2025', '2025-06-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFe-040625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Extraordinaria - Consejo de Facultad', '6', '5', '2025', '2025-05-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFe-060525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Ordinaria - Consejo de Facultad', '25', '4', '2025', '2025-04-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFo-250425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Ordinaria - Consejo de Facultad', '2', '4', '2025', '2025-04-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFo-020425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Ordinaria - Consejo de Facultad', '11', '3', '2025', '2025-03-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFo-110325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Ordinaria - Consejo de Facultad', '28', '2', '2025', '2025-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFo-280225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2025', 'Sesión Ordinaria - Consejo de Facultad', '6', '2', '2025', '2025-02-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/FACSA-acta-CFo-060225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Ordinaria - Consejo de Facultad', '20', '8', '2024', '2024-08-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-200824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '25', '6', '2024', '2024-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-250624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Ordinaria - Consejo de Facultad', '5', '6', '2024', '2024-06-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-050624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '16', '5', '2024', '2024-05-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-160524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '29', '4', '2024', '2024-04-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-290424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '15', '4', '2024', '2024-04-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-150424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Ordinaria - Consejo de Facultad', '4', '4', '2024', '2024-04-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-040424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Extraordinaria - Consejo de Facultad', '22', '3', '2024', '2024-03-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-220324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Ordinaria - Consejo de Facultad', '5', '3', '2024', '2024-03-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-050324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2024', 'Sesión Ordinaria - Consejo de Facultad', '15', '2', '2024', '2024-02-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-150224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '27', '12', '2023', '2023-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FACSA-acta-CFe-271223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '21', '12', '2023', '2023-12-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FACSA-acta-CFe-211223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '7', '12', '2023', '2023-12-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FACSA-acta-CFe-071223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Extraordinaria - Consejo de Facultad', '28', '11', '2023', '2023-11-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FACSA-acta-CFe-281123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Ordinaria - Consejo de Facultad', '17', '11', '2023', '2023-11-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/FACSA-acta-CFo-171123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Ordinaria - Consejo de Facultad', '5', '10', '2023', '2023-10-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-051023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Ordinaria - Consejo de Facultad', '23', '8', '2023', '2023-08-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-230823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Ordinaria - Consejo de Facultad', '5', '5', '2023', '2023-05-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-050523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Extraordinaria - Consejo de Facultad', '25', '6', '2021', '2021-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-250621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', '9', '6', '2021', '2021-06-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-090621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', '28', '5', '2021', '2021-05-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-280521.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', '30', '4', '2021', '2021-04-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-300421.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', '30', '3', '2021', '2021-03-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-300321.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', '25', '2', '2021', '2021-02-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-250221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '10', '12', '2020', '2020-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-101220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '13', '11', '2020', '2020-11-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-131120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '1', '10', '2020', '2020-10-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-011020.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '24', '8', '2020', '2020-08-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-240820.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '25', '6', '2020', '2020-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-250620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '15', '6', '2020', '2020-06-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-150620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '28', '5', '2020', '2020-05-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-280520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '17', '4', '2020', '2020-04-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-170420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2020', 'Sesión Ordinaria - Consejo de Facultad', '25', '2', '2020', '2020-02-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-250220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2019', 'Sesión Ordinaria - Consejo de Facultad', '6', '12', '2019', '2019-12-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-061219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2019', 'Sesión Ordinaria - Consejo de Facultad', '26', '11', '2019', '2019-11-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-261119.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2019', 'Sesión Ordinaria - Consejo de Facultad', '16', '10', '2019', '2019-10-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-161019.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2019', 'Sesión Ordinaria - Consejo de Facultad', '12', '9', '2019', '2019-09-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-120919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2019', 'Sesión Ordinaria - Consejo de Facultad', '13', '8', '2019', '2019-08-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-130819.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2019', 'Sesión Ordinaria - Consejo de Facultad', '15', '6', '2019', '2019-06-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-150619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2019', 'Sesión Ordinaria - Consejo de Facultad', '28', '5', '2019', '2019-05-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-280519.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '10', '12', '2018', '2018-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-101218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '30', '11', '2018', '2018-11-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-301118.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '28', '11', '2018', '2018-11-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-281118.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '18', '10', '2018', '2018-10-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-181018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '6', '9', '2018', '2018-09-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-060918.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '18', '6', '2018', '2018-06-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-180618.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '29', '5', '2018', '2018-05-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-290518.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '20', '4', '2018', '2018-04-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-200418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '26', '3', '2018', '2018-03-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-260318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Extraordinaria - Consejo de Facultad', '28', '2', '2018', '2018-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-280218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2018', 'Sesión Ordinaria - Consejo de Facultad', '13', '2', '2018', '2018-02-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-130218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '26', '12', '2017', '2017-12-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-261217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '30', '11', '2017', '2017-11-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-301117.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Extraordinaria - Consejo de Facultad', '12', '11', '2017', '2017-11-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-121117.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '31', '10', '2017', '2017-10-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-311017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '4', '10', '2017', '2017-10-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-041017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '4', '9', '2017', '2017-09-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-040917.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '16', '8', '2017', '2017-08-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-160817.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '25', '6', '2017', '2017-06-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-250617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '7', '6', '2017', '2017-06-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-070617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Extraordinaria - Consejo de Facultad', '11', '5', '2017', '2017-05-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-110517.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '27', '4', '2017', '2017-04-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-270417.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Extraordinaria - Consejo de Facultad', '27', '3', '2017', '2017-03-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-270317.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Extraordinaria - Consejo de Facultad', '24', '3', '2017', '2017-03-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFe-240317.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '10', '3', '2017', '2017-03-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-100317.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', '14', '2', '2017', '2017-02-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFo-140217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2015', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-ordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2014', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2014', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-ordinarias-2014.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2016', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-ordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2017', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-ordinarias-2017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2014', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2014', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-extraordinarias-2014.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2015', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2015', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-extraordinarias-2015.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2016', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2016', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-extraordinarias-2016.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2017', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2017', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-actas-cf-extraordinarias-2017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-180821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-220921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-280921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-051121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-111121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-031221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2021', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-271221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-070322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-150322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-230322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-110522.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-160822.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-080922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-071022.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-111122.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2022', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-201222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-070323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-230323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Ordinaria - Consejo de Facultad', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFov-310323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('FACULTAD DE CIENCIAS DE LA SALUD', '2023', 'Sesión Extraordinaria - Consejo de Facultad', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/FACSA-acta-CFev-270623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ESCUELA DE POSGRADO', '2025', 'Escuela de Posgrado', NULL, NULL, '2025', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/EPG-acta-Ci-040925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ESCUELA DE POSGRADO', '2025', 'Escuela de Posgrado', NULL, NULL, '2025', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/EPG-acta-Ce-080925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ESCUELA DE POSGRADO', '2025', 'Escuela de Posgrado', NULL, NULL, '2025', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/EPG-acta-Ci-291025.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ESCUELA DE POSGRADO', '2025', 'Escuela de Posgrado', NULL, NULL, '2025', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/EPG-acta-Ce-281125.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '18', '11', '2025', '2025-11-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-181125.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '7', '11', '2025', '2025-11-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-071125.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '28', '10', '2025', '2025-10-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-281025.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '13', '10', '2025', '2025-10-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-131025.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '6', '10', '2025', '2025-10-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-061025.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '30', '9', '2025', '2025-09-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-300925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '25', '9', '2025', '2025-09-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-250925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '16', '9', '2025', '2025-09-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-160925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '10', '9', '2025', '2025-09-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-100925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '20', '8', '2025', '2025-08-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-200825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '5', '8', '2025', '2025-08-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-050825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '1', '8', '2025', '2025-08-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-010825.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '30', '6', '2025', '2025-06-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-300625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '27', '6', '2025', '2025-06-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-270625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '18', '6', '2025', '2025-06-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-180625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '12', '6', '2025', '2025-06-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-120625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '4', '6', '2025', '2025-06-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-040625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '28', '5', '2025', '2025-05-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-280525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '19', '5', '2025', '2025-05-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-190525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '6', '5', '2025', '2025-05-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-060525.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '29', '4', '2025', '2025-04-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-290425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '22', '4', '2025', '2025-04-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-220425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '15', '4', '2025', '2025-04-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-150425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '14', '4', '2025', '2025-04-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-140425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '7', '4', '2025', '2025-04-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-070425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '1', '4', '2025', '2025-04-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-010425.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '28', '3', '2025', '2025-03-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-280325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '20', '3', '2025', '2025-03-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-200325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '19', '3', '2025', '2025-03-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-190325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '11', '3', '2025', '2025-03-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-110325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '25', '2', '2025', '2025-02-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUe-250225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2025', 'Sesión', '12', '2', '2025', '2025-02-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-CUo-120225.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '31', '12', '2024', '2024-12-31', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-311224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '27', '12', '2024', '2024-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-271224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '19', '12', '2024', '2024-12-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-191224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '5', '12', '2024', '2024-12-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-051224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '4', '12', '2024', '2024-12-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-041224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '29', '11', '2024', '2024-11-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-291124.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '21', '11', '2024', '2024-11-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-211124.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '12', '11', '2024', '2024-11-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-121124.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '30', '10', '2024', '2024-10-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-301024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '16', '10', '2024', '2024-10-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-161024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '14', '10', '2024', '2024-10-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-141024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '30', '9', '2024', '2024-09-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-300924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '19', '9', '2024', '2024-09-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-190924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '5', '9', '2024', '2024-09-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-050924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '21', '8', '2024', '2024-08-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-210824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '7', '8', '2024', '2024-08-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-070824.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '2', '7', '2024', '2024-07-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-020724.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '26', '6', '2024', '2024-06-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-260624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '12', '6', '2024', '2024-06-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-120624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '3', '6', '2024', '2024-06-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-030624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '20', '5', '2024', '2024-05-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-200524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '8', '5', '2024', '2024-05-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-080524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '3', '5', '2024', '2024-05-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-030524.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '22', '4', '2024', '2024-04-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-220424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '16', '4', '2024', '2024-04-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-160424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '28', '12', '2023', '2023-12-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-281223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '20', '12', '2023', '2023-12-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-201223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '13', '12', '2023', '2023-12-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-131223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '27', '11', '2023', '2023-11-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-271123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '27', '10', '2023', '2023-10-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-271023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '10', '10', '2023', '2023-10-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-101023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '21', '9', '2023', '2023-09-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-210923.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '7', '9', '2023', '2023-09-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-070923.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '25', '8', '2023', '2023-08-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-250823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '9', '8', '2023', '2023-08-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-090823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '30', '6', '2023', '2023-06-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-300623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '26', '6', '2023', '2023-06-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-260623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '14', '6', '2023', '2023-06-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-140623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '30', '5', '2023', '2023-05-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-300523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '25', '5', '2023', '2023-05-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-250523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '12', '5', '2023', '2023-05-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-120523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '28', '4', '2023', '2023-04-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-280423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '20', '4', '2023', '2023-04-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUe-200423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', '28', '3', '2023', '2023-03-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUo-280323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', '19', '8', '2022', '2022-08-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-190822.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', '9', '8', '2022', '2022-08-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-090822.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', '28', '6', '2022', '2022-06-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-280622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', '22', '6', '2022', '2022-06-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-220622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', '10', '6', '2022', '2022-06-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-100622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', '20', '5', '2022', '2022-05-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-200522.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', '9', '5', '2022', '2022-05-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-090522.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '2', '3', '2021', '2021-03-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-0203217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '30', '12', '2020', '2020-12-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-301220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '12', '4', '2020', '2020-04-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-12042024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '3', '4', '2020', '2020-04-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-03042024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '27', '3', '2020', '2020-03-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-27032024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '18', '3', '2020', '2020-03-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-18032024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '7', '3', '2020', '2020-03-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-07032024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', '3', '3', '2020', '2020-03-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-030320.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', '28', '2', '2020', '2020-02-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-280220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', '21', '2', '2020', '2020-02-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-210220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', '20', '2', '2020', '2020-02-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-200220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '19', '2', '2020', '2020-02-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUe-19022024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2024', 'Sesión', '14', '2', '2020', '2020-02-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-CUo-14022024.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', '5', '2', '2020', '2020-02-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-050220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '27', '12', '2019', '2019-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-271219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '19', '12', '2019', '2019-12-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-191219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '10', '12', '2019', '2019-12-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-101219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '25', '11', '2019', '2019-11-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-251119.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '14', '11', '2019', '2019-11-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-141119.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '5', '11', '2019', '2019-11-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-051119.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '17', '10', '2019', '2019-10-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-171019.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '9', '10', '2019', '2019-10-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-091019.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '30', '9', '2019', '2019-09-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-300919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '26', '9', '2019', '2019-09-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-260919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '18', '9', '2019', '2019-09-18', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-180919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '11', '9', '2019', '2019-09-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-110919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '9', '9', '2019', '2019-09-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-090919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '2', '9', '2019', '2019-09-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-020919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '21', '8', '2019', '2019-08-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-210819.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '8', '8', '2019', '2019-08-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-080819.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '27', '6', '2019', '2019-06-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-270619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '9', '5', '2019', '2019-05-09', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-090519.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '30', '4', '2019', '2019-04-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-300419.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '26', '4', '2019', '2019-04-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-260419.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '16', '4', '2019', '2019-04-16', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-160419.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '12', '4', '2019', '2019-04-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-120419.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '5', '4', '2019', '2019-04-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-050419.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '1', '4', '2019', '2019-04-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-010419.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '27', '3', '2019', '2019-03-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-270319.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '21', '3', '2019', '2019-03-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-210319.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '13', '3', '2019', '2019-03-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-130319.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '5', '3', '2019', '2019-03-05', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-050319.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '26', '2', '2019', '2019-02-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-260219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2019', 'Sesión', '14', '2', '2019', '2019-02-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-140219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '8', '11', '2018', '2018-11-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-081118.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '24', '10', '2018', '2018-10-24', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-241018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '23', '10', '2018', '2018-10-23', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-231018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '15', '10', '2018', '2018-10-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-151018.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '19', '9', '2018', '2018-09-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-190918.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '28', '8', '2018', '2018-08-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-280818.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '13', '8', '2018', '2018-08-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-130818.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '27', '6', '2018', '2018-06-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-270618.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '7', '6', '2018', '2018-06-07', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-070618.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '10', '5', '2018', '2018-05-10', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-100518.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '3', '4', '2018', '2018-04-03', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-030418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '28', '3', '2018', '2018-03-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-280318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '26', '3', '2018', '2018-03-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-260318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '19', '3', '2018', '2018-03-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-190318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '12', '3', '2018', '2018-03-12', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-120318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '2', '3', '2018', '2018-03-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-020318.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '20', '2', '2018', '2018-02-20', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-200218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2018', 'Sesión', '15', '2', '2018', '2018-02-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-150218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '29', '12', '2017', '2017-12-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-291217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '27', '12', '2017', '2017-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-271217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '22', '11', '2017', '2017-11-22', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-221117.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '30', '10', '2017', '2017-10-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-301017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '19', '10', '2017', '2017-10-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-191017.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '6', '9', '2017', '2017-09-06', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-060917.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '29', '8', '2017', '2017-08-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-290817.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '8', '8', '2017', '2017-08-08', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-080817.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '27', '6', '2017', '2017-06-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-270617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '21', '6', '2017', '2017-06-21', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-210617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '14', '6', '2017', '2017-06-14', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-140617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '1', '6', '2017', '2017-06-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-010617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '19', '5', '2017', '2017-05-19', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-190517.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '4', '5', '2017', '2017-05-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-040517.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '11', '4', '2017', '2017-04-11', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-110417.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '27', '3', '2017', '2017-03-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUe-270317.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '13', '3', '2017', '2017-03-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-130317.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2017', 'Sesión', '15', '2', '2017', '2017-02-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUo-150217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUet-270619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUot-080819.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUot-270819.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-310320.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-030420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-140420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-230420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-300420.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-080520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-120520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-150520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-220520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-290520.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-030620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-120620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-190620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-100720.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-140720.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-060820.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-310820.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-070920.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-160920.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-021020.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-041120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-091120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-131120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-231120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-301120.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-221220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-291220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-070121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-160221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-240221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-160321.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-240321.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-310321.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-200421.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-300421.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-110521.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-020621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-110621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-210621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-020721.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-090721.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-130821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-260821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-310821.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-060921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-280921.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-061021.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-271021.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-291021.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-051121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-111121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-231121.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-021221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-071221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-161221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-231221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-291221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-301221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-080222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-250222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-150322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-250322.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-070422.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-210422.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-250822.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-310822.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-140922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-160922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-300922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-201022.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-031122.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-151122.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-301122.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-151222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-291222.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-030223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUov-080223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-210223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-070323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-CUev-160323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUev-250423.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUev-080523.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUev-160823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUev-161023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('CONSEJO UNIVERSITARIO', '2023', 'Sesión', NULL, NULL, '2023', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-CUev-081123.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2025', 'Sesión', '17', '9', '2025', '2025-09-17', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-AUe-170925.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2025', 'Sesión', '30', '6', '2025', '2025-06-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-AUo-300625.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2025', 'Sesión', '4', '3', '2025', '2025-03-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2025/acta-AUe-040325.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2024', 'Sesión', '30', '12', '2024', '2024-12-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-AUo-301224.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2024', 'Sesión', '27', '9', '2024', '2024-09-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-AUe-270924.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2024', 'Sesión', '1', '7', '2024', '2024-07-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-AUo-010724.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2024', 'Sesión', '4', '6', '2024', '2024-06-04', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-AUe-040624.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2024', 'Sesión', '26', '4', '2024', '2024-04-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-AUe-260424.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2024', 'Sesión', '1', '3', '2024', '2024-03-01', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2024/acta-AUe-010324.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2023', 'Sesión', '29', '12', '2023', '2023-12-29', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-AUo-291223.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2023', 'Sesión', '2', '10', '2023', '2023-10-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-AUe-021023.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2023', 'Sesión', '28', '8', '2023', '2023-08-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-AUe-280823.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2023', 'Sesión', '27', '6', '2023', '2023-06-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-AUo-270623.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2023', 'Sesión', '2', '3', '2023', '2023-03-02', 'https://www.uandina.edu.pe/descargas/transparencia/actas/2023/acta-AUe-020323.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2019', 'Sesión', '30', '12', '2020', '2020-12-30', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUo-301220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2019', 'Sesión', '25', '9', '2019', '2019-09-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUe-250919.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2019', 'Sesión', '26', '6', '2019', '2019-06-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUo-260619.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2019', 'Sesión', '13', '2', '2019', '2019-02-13', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUe-130219.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2018', 'Sesión', '28', '12', '2018', '2018-12-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUo-281218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2018', 'Sesión', '27', '12', '2018', '2018-12-27', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUo-271218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2018', 'Sesión', '25', '4', '2018', '2018-04-25', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUe-250418.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2018', 'Sesión', '15', '2', '2018', '2018-02-15', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUo-150218.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2017', 'Sesión', '28', '12', '2017', '2017-12-28', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUo-281217.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2017', 'Sesión', '26', '6', '2017', '2017-06-26', 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUo-260617.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUov-300620.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUev-300920.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2020', 'Sesión', NULL, NULL, '2020', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUov-301220.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUev-180621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUov-230621.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUov-221221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2021', 'Sesión', NULL, NULL, '2021', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUev-301221.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUev-120422.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUev-310522.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUov-300622.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUev-220922.pdf', NOW());
INSERT INTO actas (seccion, categoria, subcategoria, dia, mes, anio, fecha, enlace, created_at) VALUES ('ASAMBLEA UNIVERSITARIA', '2022', 'Sesión', NULL, NULL, '2022', NULL, 'https://www.uandina.edu.pe/descargas/transparencia/actas/acta-AUev-021222.pdf', NOW());

-- Resumen:
-- Registros insertados: 797
-- Registros omitidos: 1


-- =========================================================
-- INSERTAR DATOS DE CONTABILIDAD (Estados Financieros)
-- Datos extraídos del JSON
-- Total: 28 registros
-- =========================================================

-- Limpiar datos existentes (OPCIONAL - Descomenta si quieres eliminar datos previos)
-- TRUNCATE TABLE contabilidad;

-- =========================================================
-- ESTADOS FINANCIEROS 2024 (4 registros)
-- =========================================================

INSERT INTO contabilidad (nombre, anio, tipo_estado_financiero, dia, mes, anio_detalle, nombre_original, enlace, estado) VALUES
('Situación Financiera', '2024', 'Estado de Situación Financiera', '', '', '2024', 'ESTADO DE SITUACIÓN FINANCIERA', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2024-situacion-financiera.pdf', 'activo'),
('Resultado Integral', '2024', 'Estado del Resultado Integral del Periodo', '', '', '2024', 'ESTADO DEL RESULTADO INTEGRAL DEL PERIODO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2024-resultado-integral.pdf', 'activo'),
('Cambios en el Patrimonio', '2024', 'Estado de Cambios en el Patrimonio', '', '', '2024', 'ESTADO DE CAMBIOS EN EL PATRIMONIO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2024-cambios-patrimonio.pdf', 'activo'),
('Flujo de Efectivo', '2024', 'Estado de Flujo de Efectivo', '', '', '2024', 'ESTADO DE FLUJO DE EFECTIVO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2024-flujo-efectivo.pdf', 'activo');

-- =========================================================
-- ESTADOS FINANCIEROS 2023 (4 registros)
-- =========================================================

INSERT INTO contabilidad (nombre, anio, tipo_estado_financiero, dia, mes, anio_detalle, nombre_original, enlace, estado) VALUES
('Situación Financiera', '2023', 'Estado de Situación Financiera', '', '', '2023', 'ESTADO DE SITUACIÓN FINANCIERA', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2023-situacion-financiera.pdf', 'activo'),
('Resultado Integral', '2023', 'Estado del Resultado Integral del Periodo', '', '', '2023', 'ESTADO DEL RESULTADO INTEGRAL DEL PERIODO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2023-resultado-integral.pdf', 'activo'),
('Cambios en el Patrimonio', '2023', 'Estado de Cambios en el Patrimonio', '', '', '2023', 'ESTADO DE CAMBIOS EN EL PATRIMONIO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2023-cambios-patrimonio.pdf', 'activo'),
('Flujo de Efectivo', '2023', 'Estado de Flujo de Efectivo', '', '', '2023', 'ESTADO DE FLUJO DE EFECTIVO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2023-flujo-efectivo.pdf', 'activo');

-- =========================================================
-- ESTADOS FINANCIEROS 2022 (4 registros)
-- =========================================================

INSERT INTO contabilidad (nombre, anio, tipo_estado_financiero, dia, mes, anio_detalle, nombre_original, enlace, estado) VALUES
('Situación Financiera', '2022', 'Estado de Situación Financiera', '', '', '2022', 'ESTADO DE SITUACIÓN FINANCIERA', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2022-situacion-financiera.pdf', 'activo'),
('Resultado Integral', '2022', 'Estado del Resultado Integral del Periodo', '', '', '2022', 'ESTADO DEL RESULTADO INTEGRAL DEL PERIODO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2022-resultado-integral.pdf', 'activo'),
('Cambios en el Patrimonio', '2022', 'Estado de Cambios en el Patrimonio', '', '', '2022', 'ESTADO DE CAMBIOS EN EL PATRIMONIO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2022-cambios-patrimonio.pdf', 'activo'),
('Flujo de Efectivo', '2022', 'Estado de Flujo de Efectivo', '', '', '2022', 'ESTADO DE FLUJO DE EFECTIVO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2022-flujo-efectivo.pdf', 'activo');

-- =========================================================
-- ESTADOS FINANCIEROS 2021 (4 registros)
-- =========================================================

INSERT INTO contabilidad (nombre, anio, tipo_estado_financiero, dia, mes, anio_detalle, nombre_original, enlace, estado) VALUES
('Situación Financiera', '2021', 'Estado de Situación Financiera', '', '', '2021', 'ESTADO DE SITUACIÓN FINANCIERA', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2021-situacion-financiera.pdf', 'activo'),
('Resultado Integral', '2021', 'Estado del Resultado Integral del Periodo', '', '', '2021', 'ESTADO DEL RESULTADO INTEGRAL DEL PERIODO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2021-resultado-integral.pdf', 'activo'),
('Cambios en el Patrimonio', '2021', 'Estado de Cambios en el Patrimonio', '', '', '2021', 'ESTADO DE CAMBIOS EN EL PATRIMONIO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2021-cambios-patrimonio.pdf', 'activo'),
('Flujo de Efectivo', '2021', 'Estado de Flujo de Efectivo', '', '', '2021', 'ESTADO DE FLUJO DE EFECTIVO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2021-flujo-efectivo.pdf', 'activo');

-- =========================================================
-- ESTADOS FINANCIEROS 2020 (4 registros)
-- =========================================================

INSERT INTO contabilidad (nombre, anio, tipo_estado_financiero, dia, mes, anio_detalle, nombre_original, enlace, estado) VALUES
('Situación Financiera', '2020', 'Estado de Situación Financiera', '', '', '2020', 'ESTADO DE SITUACIÓN FINANCIERA', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2020-situacion-financiera.pdf', 'activo'),
('Resultado Integral', '2020', 'Estado del Resultado Integral del Periodo', '', '', '2020', 'ESTADO DEL RESULTADO INTEGRAL DEL PERIODO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2020-resultado-integral.pdf', 'activo'),
('Cambios en el Patrimonio', '2020', 'Estado de Cambios en el Patrimonio', '', '', '2020', 'ESTADO DE CAMBIOS EN EL PATRIMONIO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2020-cambios-patrimonio.pdf', 'activo'),
('Flujo de Efectivo', '2020', 'Estado de Flujo de Efectivo', '', '', '2020', 'ESTADO DE FLUJO DE EFECTIVO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2020-flujo-efectivo.pdf', 'activo');

-- =========================================================
-- ESTADOS FINANCIEROS 2019 (4 registros)
-- =========================================================

INSERT INTO contabilidad (nombre, anio, tipo_estado_financiero, dia, mes, anio_detalle, nombre_original, enlace, estado) VALUES
('Situación Financiera', '2019', 'Estado de Situación Financiera', '', '', '2019', 'ESTADO DE SITUACIÓN FINANCIERA', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2019-situacion-financiera.pdf', 'activo'),
('Resultado Integral', '2019', 'Estado del Resultado Integral del Periodo', '', '', '2019', 'ESTADO DEL RESULTADO INTEGRAL DEL PERIODO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2019-resultado-integral.pdf', 'activo'),
('Cambios en el Patrimonio', '2019', 'Estado de Cambios en el Patrimonio', '', '', '2019', 'ESTADO DE CAMBIOS EN EL PATRIMONIO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2019-cambios-patrimonio.pdf', 'activo'),
('Flujo de Efectivo', '2019', 'Estado de Flujo de Efectivo', '', '', '2019', 'ESTADO DE FLUJO DE EFECTIVO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2019-flujo-efectivo.pdf', 'activo');

-- =========================================================
-- ESTADOS FINANCIEROS 2018 (4 registros)
-- =========================================================

INSERT INTO contabilidad (nombre, anio, tipo_estado_financiero, dia, mes, anio_detalle, nombre_original, enlace, estado) VALUES
('Situación Financiera', '2018', 'Estado de Situación Financiera', '', '', '2018', 'ESTADO DE SITUACIÓN FINANCIERA', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2018-situacion-financiera.pdf', 'activo'),
('Resultado Integral', '2018', 'Estado del Resultado Integral del Periodo', '', '', '2018', 'ESTADO DEL RESULTADO INTEGRAL DEL PERIODO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2018-resultado-integral.pdf', 'activo'),
('Cambios en el Patrimonio', '2018', 'Estado de Cambios en el Patrimonio', '', '', '2018', 'ESTADO DE CAMBIOS EN EL PATRIMONIO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2018-cambios-patrimonio.pdf', 'activo'),
('Flujo de Efectivo', '2018', 'Estado de Flujo de Efectivo', '', '', '2018', 'ESTADO DE FLUJO DE EFECTIVO', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/2018-flujo-efectivo.pdf', 'activo');


-- =========================================================
-- CONSULTAS ÚTILES
-- =========================================================

-- Ver estados financieros de un año específico
-- SELECT * FROM contabilidad WHERE anio = '2024';

-- Ver un tipo específico de estado financiero
-- SELECT * FROM contabilidad WHERE tipo_estado_financiero LIKE '%Situación Financiera%';

-- Ver estados financieros ordenados por año descendente
-- SELECT * FROM contabilidad ORDER BY anio DESC, nombre;



INSERT INTO becas (seccion, categoria, subcategoria, semestre, tipo_periodo, anio, nombre_original, enlace, estado) VALUES
('BECAS OFRECIDAS', '2022', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2022', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2022-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2022i-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2021', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2021', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2021-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2021i-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2021', 'Número de Becas Ofrecidas', 'II', 'Semestre', '2021', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2021-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2021ii-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2020', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2020', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2020-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2020i-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2020', 'Número de Becas Ofrecidas', 'II', 'Semestre', '2020', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2020-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2020ii-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2019', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2019', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2019-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2019i-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2019', 'Número de Becas Ofrecidas', 'II', 'Semestre', '2019', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2019-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2019ii-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2018', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2018', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2018-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2018i-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2018', 'Número de Becas Ofrecidas', 'II', 'Semestre', '2018', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2018-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2018ii-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2017', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2017', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2017I-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2017', 'Número de Becas Ofrecidas', 'II', 'Semestre', '2017', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2017II-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2016', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2016', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2016-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2016I-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2016', 'Número de Becas Ofrecidas', 'I', 'Semestre', '2016', 'NÚMERO DE BECAS OFRECIDAS – SEMESTRE ACADÉMICO 2016-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2016II-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2015', 'Número de Becas Ofrecidas', 'I', 'Ciclo', '2015', 'NÚMERO DE BECAS OFRECIDAS – CICLO ACADÉMICO 2015-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2015I-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2015', 'Número de Becas Ofrecidas', 'II', 'Ciclo', '2015', 'NÚMERO DE BECAS OFRECIDAS – CICLO ACADÉMICO 2015-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2015II-uac.pdf', 'activo'),
('BECAS OFRECIDAS', '2015', 'Número de Becas Ofrecidas', 'III', 'Ciclo', '2015', 'NÚMERO DE BECAS OFRECIDAS – CICLO ACADÉMICO 2015-III', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-disponibles-2015III-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2022', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'I', 'Semestre', '2022', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2022-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2022i-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2021', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'I', 'Semestre', '2021', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2021-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2021i-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2021', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'II', 'Semestre', '2021', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2021-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2021ii-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2020', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'I', 'Semestre', '2020', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2020-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2020i-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2020', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'II', 'Semestre', '2020', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2020-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2020ii-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2019', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'I', 'Semestre', '2019', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2019-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2019i-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2019', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'II', 'Semestre', '2019', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2019-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2019ii-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2018', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'I', 'Semestre', '2018', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2018-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2018i-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2018', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'II', 'Semestre', '2018', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2018-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2018ii-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2017', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'I', 'Semestre', '2017', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2017I-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2017', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'II', 'Semestre', '2017', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2017II-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2016', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'I', 'Semestre', '2016', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2016-I', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2016I-uac.pdf', 'activo'),
('RESUMEN DE BECAS OFRECIDAS Y OTORGADAS', '2016', 'Cuadro Resumen de Becas Ofrecidas/Otorgadas', 'II', 'Semestre', '2016', 'CUADRO RESUMEN DE BECAS OFRECIDAS/OTORGADAS – SEMESTRE ACADÉMICO 2016-II', 'https://www.uandina.edu.pe/descargas/transparencia/becas/cuadro-resumen-becas-2016II-uac.pdf', 'activo'),
('NÚMERO DE BECAS OFERTADAS Y NÚMERO DE BENEFICIARIOS', '2025', 'Becas Ofertadas y Número de Beneficiarios', 'II', 'Semestre', '2025', 'CUADRO BECAS OFERTADAS/BENEFICIARIOS – AÑO 2025', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-ofertadas-numero-beneficiarios-2025.pdf', 'activo'),
('NÚMERO DE BECAS OFERTADAS Y NÚMERO DE BENEFICIARIOS', '2024', 'Becas Ofertadas y Número de Beneficiarios', 'II', 'Semestre', '2024', 'CUADRO BECAS OFERTADAS/BENEFICIARIOS – AÑO 2024', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-ofertadas-numero-beneficiarios-2024.pdf', 'activo'),
('NÚMERO DE BECAS OFERTADAS Y NÚMERO DE BENEFICIARIOS', '2023', 'Becas Ofertadas y Número de Beneficiarios', 'II', 'Semestre', '2023', 'CUADRO BECAS OFERTADAS/BENEFICIARIOS – AÑO 2023', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-ofertadas-numero-beneficiarios-2023.pdf', 'activo'),
('NÚMERO DE BECAS OFERTADAS Y NÚMERO DE BENEFICIARIOS', '2022', 'Becas Ofertadas y Número de Beneficiarios', 'II', 'Semestre', '2022', 'CUADRO BECAS OFERTADAS/BENEFICIARIOS – AÑO 2022', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-ofertadas-numero-beneficiarios-2022.pdf', 'activo'),
('NÚMERO DE BECAS OFERTADAS Y NÚMERO DE BENEFICIARIOS', '2021', 'Becas Ofertadas y Número de Beneficiarios', 'II', 'Semestre', '2021', 'CUADRO BECAS OFERTADAS/BENEFICIARIOS – AÑO 2021', 'https://www.uandina.edu.pe/descargas/transparencia/becas/becas-ofertadas-numero-beneficiarios-2021.pdf', 'activo'),
('CRÉDITOS EDUCATIVOS', '', '', '', '', '', '', '', 'activo'),
('BECAS: NIVEL POSGRADO Y SEGUNDAS ESPECIALIDADES', '', '', '', '', '', '', '', 'activo');



INSERT INTO inversiones (seccion, subseccion, tipo, anio, nombre_original, enlace, estado) VALUES
('INVERSIONES Y REINVERSIONES', 'No', 'Donaciones (Informativo)', '', 'DONACIONES: La Universidad Andina del Cusco no ha recepcionado donaciones.', '', 'activo'),
('INVERSIONES Y REINVERSIONES', 'No', 'Inversiones y Reinversiones', '2021', 'INVERSIONES Y REINVERSIONES: AÑO 2021', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/re-inversiones-2021.pdf', 'activo'),
('INVERSIONES Y REINVERSIONES', 'No', 'Inversiones y Reinversiones', '2019-2020', 'INVERSIONES Y REINVERSIONES 2019-2020', 'https://www.uandina.edu.pe/descargas/transparencia/reinversiones-2019-2020-uac.pdf', 'activo'),
('INVERSIONES Y REINVERSIONES', 'Sí', 'Certificación de Reinversiones', '2019-2020', 'CERTIFICACIÓN DE REINVERSIONES 2019-2020 (POR SOCIEDAD AUDITORA)', 'https://www.uandina.edu.pe/descargas/transparencia/certificacion-reinversiones-2019-2020-uac.pdf', 'activo'),
('INVERSIONES Y REINVERSIONES', 'No', 'Inversiones y Reinversiones', '2018', 'INVERSIONES Y REINVERSIONES: AÑO 2018', 'https://www.uandina.edu.pe/descargas/transparencia/contabilidad/re-inversiones-2018.pdf', 'activo'),
('INVERSIONES Y REINVERSIONES', 'No', 'Inversiones y Reinversiones', '2014-2015', 'INVERSIONES Y REINVERSIONES: AÑOS 2014 – 2015', 'https://www.uandina.edu.pe/descargas/transparencia/re-inversiones-2014-2015.pdf', 'activo');

-- =========================================================
-- SECCIÓN 2: OBRAS DE INFRAESTRUCTURA
-- Total: 4 registro(s)
-- =========================================================

INSERT INTO inversiones (seccion, subseccion, tipo, anio, nombre_original, enlace, estado) VALUES
('OBRAS DE INFRAESTRUCTURA', 'No', 'Aulas Generales, Laboratorios y Otros', '', 'AULAS GENERALES, LABORATORIOS Y OTROS', 'https://www.uandina.edu.pe/descargas/transparencia/infraestuctura-aulas-generales.pdf', 'activo'),
('OBRAS DE INFRAESTRUCTURA', 'No', 'Facultad de Ciencias de la Salud', '', 'FACULTAD DE CIENCIAS DE LA SALUD, QOLLANA', 'https://www.uandina.edu.pe/descargas/transparencia/infraestuctura-facsa-qollana.pdf', 'activo'),
('OBRAS DE INFRAESTRUCTURA', 'No', 'Edificio de Aulas y Auditorio - Sede Sicuani', '', 'EDIFICIO DE AULAS Y AUDITORIO – SEDE SICUANI', 'https://www.uandina.edu.pe/descargas/transparencia/infraestuctura-sede-sicuani.pdf', 'activo'),
('OBRAS DE INFRAESTRUCTURA', 'No', 'Plano Perimétrico', '', 'PLANO PERIMÉTRICO EN HUASAO', 'https://www.uandina.edu.pe/descargas/transparencia/plano-perimetrico-huasao.pdf', 'activo');

-- =========================================================
-- SECCIÓN 3: RECURSOS DE DIVERSA FUENTE
-- Total: 1 registro(s)
-- =========================================================

INSERT INTO inversiones (seccion, subseccion, tipo, anio, nombre_original, enlace, estado) VALUES
('RECURSOS DE DIVERSA FUENTE', 'No', 'Fuentes de Financiamiento', '2016', 'FUENTES DE FINANCIAMIENTO – 2016', 'https://www.uandina.edu.pe/descargas/transparencia/fuentes-financiamiento-2016.pdf', 'activo');





-- 2. Inserción de datos (manteniendo orden y grupos exactos del HTML original)

-- === ALUMNOS DE PREGRADO ===
INSERT INTO alumnos (seccion, categoria, anio, enlace_pdf) VALUES
('Pregrado', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2017, 2018, 2019, 2020, 2021, 2022, 2023', 'https://www.uandina.edu.pe/descargas/transparencia/matriculados-programas-estudio.pdf'),
('Pregrado', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/alumnos-matriculados-por-semestre.-2024pdf'),
('Pregrado', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/alumnos-matriculados-por-semestre-2025.pdf'),

('Pregrado', 'POSTULANTES POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2017, 2018, 2019, 2020, 2021, 2022, 2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/postulantes-por-semestre-2017-2023.pdf'),
('Pregrado', 'POSTULANTES POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/postulantes-por-semestre-2024.pdf'),
('Pregrado', 'POSTULANTES POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/postulantes-por-semestre-2025.pdf'),

('Pregrado', 'INGRESANTES POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2017, 2018, 2019, 2020, 2021, 2022, 2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/ingresantes-por-semestre-2017-2023.pdf'),
('Pregrado', 'INGRESANTES POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/ingresantes-por-semestre-2024.pdf'),
('Pregrado', 'INGRESANTES POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/ingresantes-por-semestre-2025.pdf'),

('Pregrado', 'EGRESADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2017, 2018, 2019, 2020, 2021, 2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/egresados-por-semestre-2017-2022.pdf'),
('Pregrado', 'EGRESADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/egresados-por-semestre-2023.pdf'),
('Pregrado', 'EGRESADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/egresados-por-semestre-2024.pdf'),
('Pregrado', 'EGRESADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/egresados-por-semestre-2025.pdf'),

('Pregrado', 'GRADUADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2017, 2018, 2019, 2020, 2021, 2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/egresados-por-semestre-2017-2022.pdf'),
('Pregrado', 'GRADUADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/graduados-por-semestre-2023.pdf'),
('Pregrado', 'GRADUADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/graduados-por-semestre-2024.pdf'),
('Pregrado', 'GRADUADOS POR SEMESTRE SEGÚN ESCUELAS PROFESIONALES', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/graduados-por-semestre-2025.pdf');

-- === ALUMNOS DE POSGRADO ===
INSERT INTO alumnos (seccion, categoria, anio, enlace_pdf) VALUES
('Posgrado', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-alumnos-matriculados-por-semestre-2022.pdf'),
('Posgrado', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-alumnos-matriculados-por-semestre-2023.pdf'),
('Posgrado', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-alumnos-matriculados-por-semestre-2024.pdf'),
('Posgrado', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-alumnos-matriculados-por-semestre-2025.pdf'),

('Posgrado', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-postulantes-por-semestre-2022.pdf'),
('Posgrado', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-postulantes-por-semestre-2023.pdf'),
('Posgrado', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-postulantes-por-semestre-2024.pdf'),
('Posgrado', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-postulantes-por-semestre-2025.pdf'),

('Posgrado', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-ingresantes-por-semestre-2022.pdf'),
('Posgrado', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-ingresantes-por-semestre-2023.pdf'),
('Posgrado', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-ingresantes-por-semestre-2024.pdf'),
('Posgrado', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-ingresantes-por-semestre-2025.pdf'),

('Posgrado', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-egresados-por-semestre-2022.pdf'),
('Posgrado', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-egresados-por-semestre-2023.pdf'),
('Posgrado', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-egresados-por-semestre-2024.pdf'),
('Posgrado', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-egresados-por-semestre-2025.pdf'),

('Posgrado', 'GRADUADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-graduados-por-semestre-2022.pdf'),
('Posgrado', 'GRADUADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-graduados-por-semestre-2023.pdf'),
('Posgrado', 'GRADUADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-graduados-por-semestre-2024.pdf'),
('Posgrado', 'GRADUADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/epg-graduados-por-semestre-2025.pdf');

-- === ALUMNOS DE SEGUNDAS ESPECIALIDADES ===
INSERT INTO alumnos (seccion, categoria, anio, enlace_pdf) VALUES
('Segundas Especialidades', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-alumnos-matriculados-por-semestre-2022.pdf'),
('Segundas Especialidades', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-alumnos-matriculados-por-semestre-2023.pdf'),
('Segundas Especialidades', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-alumnos-matriculados-por-semestre-2024.pdf'),
('Segundas Especialidades', 'ALUMNOS MATRICULADOS POR SEMESTRE SEGÚN PROGRAMAS ACADÉMICOS', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-alumnos-matriculados-por-semestre-2025.pdf'),

('Segundas Especialidades', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-postulantes-por-semestre-2022.pdf'),
('Segundas Especialidades', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-postulantes-por-semestre-2023.pdf'),
('Segundas Especialidades', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-postulantes-por-semestre-2024.pdf'),
('Segundas Especialidades', 'POSTULANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-postulantes-por-semestre-2025.pdf'),

('Segundas Especialidades', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-ingresantes-por-semestre-2022.pdf'),
('Segundas Especialidades', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-ingresantes-por-semestre-2023.pdf'),
('Segundas Especialidades', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-ingresantes-por-semestre-2024.pdf'),
('Segundas Especialidades', 'INGRESANTES POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-ingresantes-por-semestre-2025.pdf'),

('Segundas Especialidades', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2022', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-egresados-por-semestre-2022.pdf'),
('Segundas Especialidades', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2023', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-egresados-por-semestre-2023.pdf'),
('Segundas Especialidades', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2024', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-egresados-por-semestre-2024.pdf'),
('Segundas Especialidades', 'EGRESADOS POR SEMESTRE SEGÚN PROGRAMA ACADÉMICO', '2025', 'https://www.uandina.edu.pe/descargas/transparencia/alumnos/se-egresados-por-semestre-2025.pdf');

-- 2. Inserción de datos (manteniendo el orden y agrupación exacta de la imagen y el HTML)

-- === DOCENTES PREGRADO ===
INSERT INTO docentes (seccion, categoria, semestre, mes, programa, enlace_pdf) VALUES
('Pregrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', NULL, 'PREGRADO', 'https://www.uandina.edu.pe/descargas/transparencia/plana-docente-uac.pdf');

-- === DOCENTES POSGRADO ===
INSERT INTO docentes (seccion, categoria, semestre, mes, programa, enlace_pdf) VALUES
('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Mayo', 'MAESTRÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-maestria-plana-docente-mayo.pdf'),
('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Mayo', 'DOCTORADO', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-doctorado-plana-docente-mayo.pdf'),

('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Junio', 'MAESTRÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-maestria-plana-docente-junio.pdf'),
('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Junio', 'DOCTORADO', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-doctorado-plana-docente-junio.pdf'),

('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Julio', 'MAESTRÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-maestria-plana-docente-julio.pdf'),
('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Julio', 'DOCTORADO', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-doctorado-plana-docente-julio.pdf'),

('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Agosto', 'MAESTRÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-maestria-plana-docente-agosto.pdf'),
('Posgrado', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Agosto', 'DOCTORADO', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/epg-doctorado-plana-docente-agosto.pdf');

-- === DOCENTES SEGUNDAS ESPECIALIDADES ===
INSERT INTO docentes (seccion, categoria, semestre, mes, programa, enlace_pdf) VALUES
('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Agosto', 'ESTOMATOLOGÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-estomatologia-plana-docente-agosto.pdf'),
('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Agosto', 'OBSTETRICIA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-obstetricia-plana-docente-agosto.pdf'),
('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Agosto', 'ENFERMERÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-enfermeria-plana-docente-agosto.pdf'),

('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Setiembre', 'ESTOMATOLOGÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-estomatologia-plana-docente-setiembre.pdf'),
('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Setiembre', 'OBSTETRICIA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-obstetricia-plana-docente-setiembre.pdf'),
('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Setiembre', 'ENFERMERÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-enfermeria-plana-docente-setiembre.pdf'),

('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Octubre', 'ESTOMATOLOGÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-estomatologia-plana-docente-octubre.pdf'),
('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Octubre', 'OBSTETRICIA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-obstetricia-plana-docente-octubre.pdf'),
-- Para Octubre Enfermería: celda vacía en la imagen → no insertamos fila

('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Noviembre', 'ESTOMATOLOGÍA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-estomatologia-plana-docente-noviembre.pdf'),
('Segundas Especialidades', 'RELACIÓN DE DOCENTES POR CLASE, CATEGORÍA Y RÉGIMEN', '2025-II', 'Noviembre', 'OBSTETRICIA', 'https://www.uandina.edu.pe/descargas/transparencia/docentes/2025/se-obstetricia-plana-docente-noviembre.pdf');
-- Para Noviembre Enfermería: celda vacía en la imagen → no insertamos fila



INSERT INTO remuneraciones (titulo, enlace_pdf) VALUES
(
  'REMUNERACIONES DEL PERSONAL DOCENTE DE LA UNIVERSIDAD ANDINA DEL CUSCO',
  'https://www.uandina.edu.pe/descargas/transparencia/remuneraciones-docentes-uac.pdf'
);


-- Inserción de datos manteniendo exactamente el orden y estructura de la página/imagen

-- === REGLAMENTOS ===
INSERT INTO reglamentos (seccion, titulo, resolucion, es_subitem, enlace) VALUES
('REGLAMENTOS', 'REGLAMENTO INTERNO DE SEGURIDAD Y SALUD EN EL TRABAJO 2026-2028 DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°573-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/reglamentos/2025/R_CU-573-2025-UAC-seguridad-salud-trabajo.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE LA BIBLIOTECA UNIVERSITARIA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°457-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-457-2025-UAC-reglamento-biblioteca-universitaria.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE MATRÍCULA ANTICIPADA PARA INGRESANTES ADMITIDOSPARA TODAS LAS MODALIDADES DE PREGRADO, (EXCEPTO LA MODALIDAD ORDINARIA) DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°379-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-379-2025-UAC-reglamento-matricula-anticipada.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE CERTIFICACIÓN INTERMEDIA DE LA ESCUELA PROFESIONAL DE INGENIERÍA CIVIL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°297-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-297-2025-UAC-reglamento-certificacion-intermedia-civil.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE CERTIFICACIÓN INTERMEDIA DE LA ESCUELA PROFESIONAL DE INGENIERÍA INDUSTRIAL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°296-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-296-2025-UAC-reglamento-certificacion-intermedia-industrial.pdf'),
('REGLAMENTOS', 'REGLAMENTO ESPECÍFICO DE CERTIFICACIÓN INTERMEDIA DE LA ESCUELA PROFESIONAL DE ARQUITECTURA LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°295-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-295-2025-UAC-reglamento-certificacion-intermedia-arquitectura.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE MOVILIDAD DOCENTE DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°225-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-225-2025-UAC-reglamento-movilidad-docente.pdf'),
('REGLAMENTOS', 'REGLAMENTO ESPECÍFICO DE ELECCIONES UNIVERSALES PARA RECTOR, VICERRECTORES Y DECANOS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°173-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-173-2025-UAC-reglamento-especifico-rector-vicerrectores-decanos.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE ELECCIONES UNIVERSITARIAS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°172-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-172-2025-UAC-reglamento-general-elecciones.pdf'),
('REGLAMENTOS', 'REGLAMENTO INTERNO DEL TRABAJO DEL PERSONAL ADMINISTRATIVO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 001-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-001-2025-UAC-reglamento-interno-personal-administrativo.pdf'),
('REGLAMENTOS', 'REGLAMENTO INTERNO DEL CENTRO DE IDIOMAS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 662-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-662-2024-UAC-reglamento-centro-idiomas.pdf'),
('REGLAMENTOS', 'Modifican Parcialmente la resolución N° 662-CU-2024-UAC, que aprueba el reglamento interno del Centro de Idiomas de la Universidad Andina del Cusco', 'Res. N° 184-2025/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R-CU-184-2025-UAC-modificacion-Res662CU2024.pdf'),
('REGLAMENTOS', 'Modifican en parte la resolución N° 662 en el extremo que corresponde al artículo 38', 'Res. N° 068-2025/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R-CU-068-2025-UAC-modificacion-Res662CU2024.pdf'),
('REGLAMENTOS', 'APRUEBAN EL REGLAMENTO DE CERTIFICACIÓN INTERMEDIA DE LA ESCUELA PROFESIONAL DE INGENIERÍA AMBIENTAL DE LA FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Res. N°586-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-586-2024-UAC-reglamento-certificacion-intermedia-ambiental.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE PAGO POR SERVICIOS EDUCATIVOS PARA ESTUDIANTES CON TARIFA A PARTIR DEL AÑO 2025', 'Res. N°583-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-583-2024-UAC-reglamento-pago-servicios-educativos-2025.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL CENTRO PRE UNIVERSITARIO DE CONSOLIDACIÓN DEL PERFIL DEL INGRESANTE (CPCPI) DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°522-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-522-2024-UAC-aprueban-reglamento-cpcpi.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE ADMISIÓN DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°521-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-521-2024-UAC-reglamento-general-admision-uac.pdf'),
('REGLAMENTOS', 'Modifican parcialmente la resolución N° 521-CU-2024-UAC, de fecha 15 de octubre de 2024', 'Res. N° 591-2025/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/reglamentos/2025/R-CU-591-2025-UAC-modificacion-Res521CU2024.pdf'),
('REGLAMENTOS', 'Modifican parcialmente la resolución N° 521-CU-2024-UAC, de fecha 15 de octubre de 2024', 'Res. N° 271-2025/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R-CU-271-2025-UAC-modificacion-Res521CU2024.pdf'),
('REGLAMENTOS', 'Modifican parcialmente la resolución N° 521 en lo que respecta a la modalidad de ingreso para los exonerados', 'Res. N° 565-2024/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R-CU-565-2024-UAC-modificacion-Res521CU2024.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL DEPORTE GENERAL, DE ALTA COMPETENCIA Y HABILIDADES ESPECIALES DE LA DIRECCIÓN DE PROMOCIÓN DEL DEPORTE DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 022-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-022-2024-UAC-deporte-general-dipd.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL COMITÉ INSTITUCIONAL DE ÉTICA EN INVESTIGACIÓN DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 474-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-474-2023-UAC-comite-etica-investigacion.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE MÉRITOS ACADÉMICOS DE ESTUDIANTES Y EGRESADOS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°451-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-451-2023-UAC-reglamento-meritos-academicos.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE PUBLICACIONES DE LA UNIVERSIDAD ANDINA DEL CUSCO Y ANEXO.', 'Res. N°448-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-448-2023-UAC-reglamento-publicaciones-uac.pdf'),
('REGLAMENTOS', 'REGLAMENTO PARA CONVOCATORIA, EVALUACIÓN, CONTRATO Y ESCALA REMUNERATIVA DE DOCENTES INVESTIGADORES RENACYT DEL INSTITUTO CIENTÍFICO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°728-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-728-2022-UAC-reglamento-docentes-renacyt.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE HOMOLOGACIONES Y CONVALIDACIONES DE PREGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°470-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-470-2022-UAC-homologacion-convalidacion-pregrado.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DEL SISTEMA DE BECAS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°044-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-044-2022-UAC-reglamento-becas.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE MATRÍCULAS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 588-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-588-2021-UAC-reglamento-matriculas.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE PAGO POR SERVICIOS EDUCATIVOS PARA ESTUDIANTES DE PREGRADO, SEGUNDAS ESPECIALIDADES Y POSGRADO Y SUS ANEXOS', 'Res. N°552-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-552-2021-UAC-reglamento-pago-servicios-educativos.pdf'),
('REGLAMENTOS', 'Modifican los artículos 36 y 7 del reglamento de pago por servicios educativos', 'Res. N° 401-2022/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-401-2022-UAC-modificacion-pago-servicios-120822.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE ASCENSOS DEL PERSONAL DOCENTE DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 515-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-515-2021-UAC-reglamento-ascenso-docente.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE CAMBIO DE RÉGIMEN DEL PERSONAL DOCENTE DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 516-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-516-2021-UAC-reglamento-regimen-docente.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE MOVILIDAD ESTUDIANTIL VIRTUAL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°141-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-141-2021-UAC-movilidad-estudiantil-virtual.pdf'),
('REGLAMENTOS', 'Deja en suspenso la aplicación de la resolución N° 141-CU-2021-UAC mediante la cual se aprueba el reglamento de movilidad estudiantil virtual de la Universidad Andina del Cusco', 'Res. N° 331-2021/R-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_R-331-2021-UAC-suspenden-aplicacion-cu141-2021.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL TRIBUNAL DE HONOR DE LA UNIVERSIDAD ANDINA DEL CUSCO VIRTUALIZADO', 'Res. N°339-2020/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2020/R_CU-339-2020-UAC-reglamento-tribunal-honor.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE INGRESO, ESTUDIOS Y GRADOS ACADÉMICOS DE LA ESCUELA DE POSGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°415-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-415-2022-UAC-reglamento-epg.pdf'),
('REGLAMENTOS', 'Modificar en parte la resolución N°415-CU-2022-UAC de fecha 15 de agosto de 2022, por consiguiente, aprobar la modificación del Reglamento de ingreso, estudios y grados académicos de la EPG', 'Res. N° 441-2023/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-441-2023-UAC-modifican-Res4152022.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE EVALUACIÓN DE LOS ESTUDIANTES DE PREGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°261-2019/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-261-2019-UAC-evaluacion-pregrado.pdf'),
('REGLAMENTOS', 'Modifican artículo 27° del reglamento 261-2019/CU-UAC', 'Res. N° 643-2021/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-643-2021-UAC-modificacion-261-2019.pdf'),
('REGLAMENTOS', 'Modifican artículo 21° del reglamento 261-2019/CU-UAC', 'Res. N° 388-2020/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2020/R_CU-388-2020-UAC-modificacion-261-2019.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE RATIFICACIÓN DE LOS DOCENTES DE LA UNIVERSIDAD ANDINA DEL CUSCO.', 'Res. N°095-2019/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-095-2019-UAC-reglamento-ratificacion-docentes.pdf'),
('REGLAMENTOS', 'Modifican artículo 16° del Reglamento de Ratificación de los Docentes', 'Res. N° 172-2019/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-172-2019-UAC-modificacion-reglamento-0952019.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE FORMACIÓN DEL COMITÉ DE DEFENSA CIVIL Y BRIGADAS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°574-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-574-2018-UAC-comite-defensa-civil.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE INGRESO COMO DOCENTE ORDINARIO A LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 458-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-458-2018-UAC-reglamento-docente-ordinario.pdf'),
('REGLAMENTOS', 'Rectifican por error material el numeral 2 del artículo 15° del Reglamento 458-2018-CU-UAC.', 'Res. N°513-2018/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-513-2018-UAC-rectificacion-458CU2018.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL CENTRO DE FORMACIÓN EN TECNOLOGÍAS DE INFORMACIÓN (CENFOTI) DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 230-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-230-2018-UAC-reglamento-cenfoti.pdf'),
('REGLAMENTOS', 'Suprimen los numerales 3 y 4 del artículo 19 de la resolución N° 230-CU-2018-UAC', 'Res. N°245-2019/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-245-2019-UAC-suprimen-art-230CU2018.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE CREACIÓN Y FUNCIONAMIENTO DE LA INCUBADORA DE EMPRESAS DE LA UNIVERSIDAD ANDINA DEL CUSCO, INCUBA ANDINA LAB', 'Res. N° 159-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-159-2018-UAC-reglamento-incuba-andinalab.pdf'),
('REGLAMENTOS', 'Rectifican los artículos 8, 10, 13, 19, 24, 33, 35, 51 y 56 del Reglamento 159-2018-CU-UAC.', 'Res. N°428-2018/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-428-2018-UAC-rectificacion-art-159CU2018.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL REGISTRO DE TRABAJOS DE INVESTIGACIÓN, REPOSITORIO DIGITAL INSTITUCIONALY PLAGIO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 114-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-114-2018-UAC-reglamento-trabajos-investigacion-repositorio-plagio.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE PROPIEDAD INTELECTUAL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 113-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-113-2018-UAC-reglamento-propiedad-intelectual.pdf'),
('REGLAMENTOS', 'REGLAMENTO MARCO PARA OTORGAR CERTIFICACIÓN DE FORMACIÓN INTERMEDIA EN LAS ESCUELAS PROFESIONALES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°485-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-485-2017-UAC-reglamento-certificacion-intermedia.pdf'),
('REGLAMENTOS', 'Suprimen el artículo 10 del reglamento marco para otorgar certificación de formación intermedia en las escuelas profesionales de la Universidad Andina del Cusco', 'Res. N°572-2024/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-572-2024-UAC-modificacion-reglamento-485CU2017.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE CERTIFICACIÓN DE FORMACIÓN INTERMEDIA CON MENCIÓN EN ASISTENTE EN FINANZAS CORPORATIVAS DE LA ESCUELA PROFESIONAL DE FINANZAS DE LA UAC', 'Res. N°635-2019/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-635-2019-UAC-certificacion-intermedia-finanzas.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE FINANCIAMIENTO O COFINANCIAMIENTO DE PROYECTOS DE INVESTIGACIÓN DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°463-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-463-2017-UAC-reglamento-financiamiento-investigacion.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE LA CLÍNICA ESTOMATOLÓGICA “LUIS VALLEJOS SANTONI”', 'Res. N°449-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-449-2017-UAC-reglamento-clies-lvs.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE DOCENTES Y JEFES DE PRÁCTICA', 'Res. N°289-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-289-2017-UAC-reglamento-docentes-jefes-practica.pdf'),
('REGLAMENTOS', 'Modifican el articulo 61° del Reglamento General de Docentes y Jefes de Práctica de la Universidad Andina del Cusco.', 'Res. N°284-2019/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-284-2019-UAC-modificacion-reglamento-289CU2017.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE VOLUNTARIADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°242-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-242-2017-UAC-reglamento-voluntariado-uac.pdf'),
('REGLAMENTOS', 'Modifican el literal c) del articulo 1° y literal d) del articulo 29° del Reglamento de Voluntariado de la Universidad Andina del Cusco.', 'Res. N°414-2017/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-414-2017-UAC-modificacion-reglamento-voluntariado.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE CERTIFICACIÓN INTERMEDIA DE LA ESCUELA PROFESIONAL DE INGENIERÍA DE SISTEMAS DE LA FACULTAD DE INGENIERÍA Y ARQUITECTURA', 'Res. N°658-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-658-2021-UAC-reglamento-certificacion-intermedia-is.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL TRIBUNAL DE HONOR DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°072-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-072-2017-UAC-reglamento-tribunal-honor.pdf'),
('REGLAMENTOS', 'REGLAMENTO ESPECÍFICO DEL PROGRAMA DE SEGUNDA ESPECIALIDAD DE INTERVENCIÓN EN CASOS DE VIOLENCIA FAMILIAR', 'Res. N°067-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-067-2017-UAC-reglamento-SE-intervencion-violencia-familiar.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE LOS DOCENTES EXTRAORDINARIOS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°050-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-050-2017-UAC-reglamento-docentes-extraordinarios.pdf'),
('REGLAMENTOS', 'Modificar parcialmente la resolución N° 050-CU-2017', 'Res. N° 277-2025/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-277-2025-UAC-modifican-Res050cu2017.pdf'),
('REGLAMENTOS', 'REGLAMENTO ESPECÍFICO DEL PROGRAMA DE SEGUNDA ESPECIALIDAD DE LA ESCUELA PROFESIONAL DE ESTOMATOLOGÍA', 'Res. N°448-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-448-2017-UAC-reglamento-SE-estomatologia.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE OTORGAMIENTO DE AUSPICIO INSTITUCIONAL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°489-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-489-2016-UAC-reglamento-otorgar-auspicio.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE LA ESCUELA DE POSGRADO', 'Res. N°665-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-665-2016-UAC-reglamento-general-epg.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE LAS DISCIPLINAS DEPORTIVAS DE LA UNIVERSIDAD ANDINA DEL CUSCO Y FILIALES', 'Res. N°664-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-664-2016-UAC-reglamento-disciplinas-deportivas.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE LABORATORIOS DE INGENIERÍA CIVIL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°384-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-384-2016-UAC-reglamento-laboratorios-ic.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE ESTUDIANTES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°291-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-291-2017-UAC-reglamento-general-estudiantes.pdf'),
('REGLAMENTOS', 'Modifican artículo 30° y 31° del Reglamento General de Estudiantes de la Universidad Andina del Cusco.', 'Res. N°260-2018/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-260-2018-UAC-modifican-articulo.pdf'),
('REGLAMENTOS', 'Modifican literal h) del artículo 46° del Reglamento General de Estudiantes de la Universidad Andina del Cusco.', 'Res. N°620-2018/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-620-2018-UAC-modifican-literal.pdf'),
('REGLAMENTOS', 'Rectifican el error material contenido en la Resolución N° 620-CU-2018-UAC', 'Res. N°641-2018/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-641-2018-UAC-rectifican-620CU2018.pdf'),
('REGLAMENTOS', 'Modifican el artículo 43° del Reglamento General de Estudiantes de la Universidad Andina del Cusco.', 'Res. N°398-2020/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2020/R_CU-398-2020-UAC-modifican-art43-291CU2017.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE MÉRITOS ACADÉMICOS DE LOS ESTUDIANTES Y EGRESADOS DE LA UNIVERSIDAD ANDINA DEL CUSCO.', 'Res. N°190-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-190-2023-UAC-meritos-academicos.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE EDITORIAL UNIVERSITARIA.', 'Res. N°602-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-602-2016-UAC-editorial-universitaria.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL SISTEMA INSTITUCIONAL DE TUTORÍA Y ATENCIÓN PSICOPEDAGÓGICA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°500-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-500-2016-UAC-sistema-tutoria-psicopedagogica.pdf'),
('REGLAMENTOS', 'REGLAMENTO INTERNO DEL CONSEJO DE FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°507-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-507-2016-UAC-consejo-facultad-ceac.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL USO DE EQUIPOS DE COMPUTO, PROYECTORES INTERACTIVOS Y LABORATORIOS DE LA FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°508-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-508-2016-UAC-uso-equipos-computo-ceac.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE LA ESCUELA DE ESTUDIOS DE FORMACIÓN GENERAL DE LA FACULTAD DE CIENCIAS Y HUMANIDADES', 'Res. N°581-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-581-2016-UAC-estudios-formacion-general.pdf'),
('REGLAMENTOS', 'Modifican artículo 15° del Reglamento de la Escuela de Estudios de Formación General de la Facultad de Ciencias y Humanidades de la Universidad Andina del Cusco.', 'Res. N°428-2017/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-428-2017-UAC-modificar-reglamento-estudios-formacion-general.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE ATENCIÓN A POSTULANTES Y ESTUDIANTES UNIVERSITARIOS CON DISCAPACIDAD DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°504-2014/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-504-2014-UAC-reglamento-estudiantes-discapacidad.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE PROGRAMA DE PRODUCTIVIDAD, ESTÍMULOS E INCENTIVOS PARA EL PERSONAL ADMINISTRATIVO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°510-2014/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-510-2014-UAC-reglamento-incentivos-administrativos.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE PROGRAMA DE ESTÍMULOS E INCENTIVOS PARA ESTUDIANTES UNIVERSITARIOS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°240-2014/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-240-2014-UAC-reglamento-incentivos-estudiantes.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE PROCEDIMIENTOS PARA INVESTIGACIÓN', 'Res. N°135-2015/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-135-2015-UAC-procedimientos-investigacion.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE USO DE LOCALES E INSTALACIONES DE LA UNIVERSIDAD ANDINA DEL CUSCO.', 'Res. N°205-2012/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-205-2012-UAC.pdf'),
('REGLAMENTOS', 'REGLAMENTO GENERAL DE ELECCIONES UNIVERSITARIAS DE LA UNIVERSIDAD ANDINA DEL CUSCO, PARA ELEGIR A LOS DELEGADOS REPRESENTANTES DE LOS PROFESORES, ESTUDIANTES Y GRADUADOS ANTE LOS ÓRGANOS DE GOBIERNO.', 'Res. N°051-2013/SG-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-051-2013-SG-UAC.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE GESTIÓN Y SUSCRIPCIÓN DE CONVENIOS INTERINSTITUCIONALES PARA LA UAC.', 'Res. N°041-2014/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-041-2014-UAC-reglamento-para-convenios.pdf'),
('REGLAMENTOS', 'REGLAMENTO MARCO DE CENTROS DE PRODUCCIÓN Y PRESTACIÓN DE SERVICIOS DE LA UAC.', 'Res. N°042-2014/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-042-2014-UAC-reglamento-centros-produccion-servicios.pdf'),
('REGLAMENTOS', 'REGLAMENTO DEL PROGRAMA DE PROFESIONALIZACIÓN ACADÉMICA EN TURISMO.', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-063-2014-UAC-reglamento-programa-profesionalizacion-turismo.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE TITULACIÓN BAJO LA MODALIDAD DE TALLERES DE TESIS (PRO TESIS) DE LA CARRERA PROFESIONAL DE EDUCACIÓN.', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-036-2014-UAC-reglamento-titulacion-protesis-educacion.pdf'),
('REGLAMENTOS', 'REGLAMENTO DE LA ASAMBLEA UNIVERSITARIA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°010-2014/AU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-010-2014-UAC-reglamento-asamble-universitaria.pdf'),
('REGLAMENTOS', 'REGLAMENTO INTERNO DEL CONSEJO UNIVERSITARIO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°478-2014/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-478-2014-UAC-reglamento-consejo-universitario.pdf');

-- === EJERCICIO PRE PROFESIONAL ===
INSERT INTO reglamentos (seccion, titulo, resolucion, es_subitem, enlace) VALUES
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO MARCO DE EJERCICIO PRE PROFESIONAL Y PRÁCTICAS PROFESIONALES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°653-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-653-2024-UAC-ejercicio-pre-profesional.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO ESPECÍFICO DEL EJERCICIO PRE PROFESIONAL DE LA ESCUELA PROFESIONAL DE DERECHO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°506-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-506-2023-UAC-reglamento-pre-profesional-derecho.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DEL EJERCICIO PRE PROFESIONAL DE LA FACULTAD DE INGENIERÍA Y ARQUITECTURA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°469-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-469-2022-UAC-ejercicio-preprofesional-fia.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DEL EJERCICIO PRE PROFESIONAL DE LA ESCUELA PROFESIONAL DE TURISMO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°034-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-034-2022-UAC-reglamento-pre-profesional-turismo.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DEL EJERCICIO PRE PROFESIONAL DE LA ESCUELA PROFESIONAL DE OBSTETRICIA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°058-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-058-2023-UAC-ejercicio-pre-profesional-obstericia.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DEL EJERCICIO PRE PROFESIONAL – INTERNADO DE LA ESCUELA PROFESIONAL DE PSICOLOGÍA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°057-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-057-2023-UAC-ejercicio-pre-profesional-psicologia.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DEL EJERCICIO PRE PROFESIONAL DE LA ESCUELA PROFESIONAL DE EDUCACIÓN DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°035-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-035-2022-UAC-reglamento-pre-profesional-educacion.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DE PRÁCTICAS PRE PROFESIONALES DE LA ESCUELA PROFESIONAL DE OBSTETRICIA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°244-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-244-reglamento-ppp-obstetricia.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DE PRÁCTICAS PRE PROFESIONALES DEL INTERNADO DE LA ESCUELA PROFESIONAL DE PSICOLOGÍA', 'Res. N°112-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-112-2017-UAC-reglamento-ppp-internado-psi.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO DE PRÁCTICAS PRE PROFESIONALES Y PROFESIONALES DE LAS ESCUELAS PROFESIONALES DE ECONOMÍA, ADMINISTRACIÓN Y CONTABILIDAD DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°676-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-676-reglamento-ppp-ceac.pdf'),
('EJERCICIO PRE PROFESIONAL', 'REGLAMENTO ESPECÍFICO DE PRÁCTICAS PRE-PROFESIONALES Y PROFESIONALES DE LA ESCUELA PROFESIONAL DE DERECHO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°530-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-530-2016-UAC-practicas-der.pdf');

-- === INTERNADO ===
INSERT INTO reglamentos (seccion, titulo, resolucion, es_subitem, enlace) VALUES
('INTERNADO', 'REGLAMENTO de INTERNADO DE LA ESCUELA PROFESIONAL DE ESTOMATOLOGÍA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°060-2023/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-060-2023-UAC-internado-estomatologia.pdf'),
('INTERNADO', 'REGLAMENTO DE INTERNADO CLÍNICO ESCUELA PROFESIONAL DE TECNOLOGÍA MÉDICA TERAPIA FÍSICA Y REHABILITACIÓN DE LA FACULTAD DE CIENCIAS DE LA SALUD DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°330-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-330-2022-UAC-reglamento-internado-clinico-tecnologia-medica.pdf');

-- === GRADOS Y TÍTULOS ===
INSERT INTO reglamentos (seccion, titulo, resolucion, es_subitem, enlace) VALUES
('GRADOS Y TÍTULOS', 'REGLAMENTO ESPECÍFICO PARA OBTENER EL GRADO ACADÉMICO DE BACHILLER Y EL TÍTULO PROFESIONAL EN LA FACULTAD DE INGENIERÍA Y ARQUITECTURA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°529-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/reglamentos/2025/R_CU-529-2025-UAC-grado-titulo-fia.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO ESPECÍFICO PARA LA OBTENCIÓN DEL GRADO ACADÉMICO DE BACHILLER Y EL TÍTULO PROFESIONAL DE ABOGADO A NOMBRE DE LA NACIÓN, EN LA FACULTAD DE DERECHO Y CIENCIA POLÍTICA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°508-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/reglamentos/2025/R_CU-508-2025-UAC-reglamento-especifico-grados-titulos-derecho.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO ESPECÍFICO DE GRADOS Y TÍTULOS PARA OBTENER EL GRADO ACADÉMICO DE BACHILLER Y EL TÍTULO PROFESIONAL DE LICENCIADO EN TURISMO/EDUCACIÓN LA FACULTAD DE CIENCIAS Y HUMANIDADES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°312-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_312-2025-CU-UAC-reglamento-especifico-turismo-educacion.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO ESPECÍFICO PARA OBTENER EL GRADO ACADÉMICO DE BACHILLER Y EL TÍTULO PROFESIONAL DE LA FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°289-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_289-2025-CU-UAC-reglamento-especifico-ceac.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO ESPECÍFICO PARA OBTENER EL GRADO ACADÉMICO DE BACHILLER Y EL TÍTULO PROFESIONAL EN LA FACULTAD DE CIENCIAS DE LA SALUD DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°513-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_513-2024-CU-UAC-reglamento-especifico-facsa.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO MARCO PARA OBTENER EL GRADO ACADÉMICO DE BACHILLER Y EL TÍTULO PROFESIONAL EN LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°256-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-256-2024-UAC-reglamento-marco-grados-titulos.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO ESPECÍFICO DE GRADOS Y TÍTULOS DE LA FACULTAD DE CIENCIAS Y HUMANIDADES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°374-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-374-2021-UAC-grados-titulos-fcsh.pdf'),
('GRADOS Y TÍTULOS', 'Modifican artículos 33° y 58° del Reglamento Específico de grados y títulos de la Facultad de Ciencias y Humanidades en mérito al Oficio N°0831-2022/INDECOPI-SRB', 'Res. N° 411-2022/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-411-2022-UAC-modificacion-reglamento-fch-150822.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO ESPECÍFICO DE GRADOS Y TÍTULOS DE LA FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°414-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-414-2022-UAC-grados-titulos-fceac.pdf'),
('GRADOS Y TÍTULOS', 'REGLAMENTO ACTUALIZADO PARA EL OTORGAMIENTO DE DUPLICADOS DE DIPLOMAS DE GRADOS Y TÍTULOS EMITIDOS POR LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°116-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-116-2023-UAC-duplicados-diplomas-gyt.pdf');

-- === POSGRADO ===
INSERT INTO reglamentos (seccion, titulo, resolucion, es_subitem, enlace) VALUES
('POSGRADO', 'REGLAMENTO DE HOMOLOGACIONES Y CONVALIDACIONES DE LA ESCUELA DE POSGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 484-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-484-2022-UAC-reglamento-homologaciones-convalidaciones.pdf'),
('POSGRADO', 'Modifican los artículos 26 y 29 del reglamento de homologaciones y convalidaciones de la Escuela de Posgrado de la Universidad Andina del Cusco', 'Res. N° 603-2024/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-603-2024-UAC-modificacion-reglamento-484CU22.pdf');

-- === SEGUNDAS ESPECIALIDADES ===
INSERT INTO reglamentos (seccion, titulo, resolucion, es_subitem, enlace) VALUES
('SEGUNDAS ESPECIALIDADES', 'REGLAMENTO ESPECÍFICO DE LOS PROGRAMAS DE LA SEGUNDA ESPECIALIDAD DE LA ESCUELA PROFESIONAL DE ESTOMATOLOGÍA DE LA UNIVERSIDAD ANDINA DEL CUSCO Y ANEXOS', 'Res. N° 587-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-587-2024-UAC-reglamento-especifico-se-estomatologia.pdf'),
('SEGUNDAS ESPECIALIDADES', 'REGLAMENTO ESPECÍFICO DE LOS PROGRAMAS DE LA SEGUNDA ESPECIALIDAD DE LA ESCUELA PROFESIONAL DE OBSTETRICIA DE LA UNIVERSIDAD ANDINA DEL CUSCO Y ANEXOS', 'Res. N° 588-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-588-2024-UAC-reglamento-especifico-se-obstetricia.pdf'),
('SEGUNDAS ESPECIALIDADES', 'REGLAMENTO ESPECÍFICO DE LOS PROGRAMAS DE LA SEGUNDA ESPECIALIDAD DE LA ESCUELA PROFESIONAL DE ENFERMERÍA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 589-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-589-2024-UAC-reglamento-especifico-se-enfemeria.pdf'),
('SEGUNDAS ESPECIALIDADES', 'REGLAMENTO MARCO DE SEGUNDA ESPECIALIDAD DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°310-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-310-2022-UAC-reglamento-segunda-especialidad.pdf'),
('SEGUNDAS ESPECIALIDADES', 'Incorporan artículo en el capítulo V: de la matrícula y modifican correlación de artículos en el citado reglamento', 'Res. N° 213-2023/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-213-2023-UAC-modificacion-reglamento-310CU22.pdf');

-- === DEFENSORIA UNIVERSITARIA ===
INSERT INTO reglamentos (seccion, titulo, resolucion, es_subitem, enlace) VALUES
('DEFENSORIA UNIVERSITARIA', 'REGLAMENTO DE LA DEFENSORIA UNIVERSITARIA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 152-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2016/R_CU-152-2016-UAC-reglamento-defensoria-universitaria.pdf'),
('DEFENSORIA UNIVERSITARIA', 'Modifican los artículos 17 y 21 del Reglamento de la Defensoría Universitaria de la Universidad Andina del Cusco', 'Res. N° 167-2024/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-167-2024-UAC-modificacion-reglamento-152CU16.pdf'),
('DEFENSORIA UNIVERSITARIA', 'REGLAMENTO SOBRE HOSTIGAMIENTO SEXUAL PARA ESTUDIANTES Y DOCENTES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 690-2021/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2021/R_CU-690-2021-UAC-reglamento-hostigamiento.pdf'),
('DEFENSORIA UNIVERSITARIA', 'REGLAMENTO SOBRE HOSTIGAMIENTO SEXUAL PARA EL PERSONAL ADMINISTRATIVO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 014-2020/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2020/R_CU-014-2020-UAC-reglamento-hostigamiento-adm.pdf');


-- 2. Inserción de datos (manteniendo el orden exacto y agrupación de la imagen: primero todas las Directivas principales y sub, luego la sección Investigación)

-- === DIRECTIVAS ===
INSERT INTO directivas (seccion, titulo, resolucion, es_subdirectiva, enlace_pdf) VALUES
('Directivas', 'DIRECTIVA N° 13-2025-VRAC-UAC, DE MATRÍCULA DE PREGRADO DEL SEMESTRE ACADÉMICO 2026-I DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 276-2025/CU-UAC – Directiva N° 13-2025/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/directivas/2025/R_R-276-2025-UAC-matriculas-2026-1.pdf'),

('Directivas', 'DIRECTIVA N° 009-2024-VRAC-UAC DE TESIS MULTIDISCIPLINARIAS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°470-2024/CU-UAC – Directiva N° 009-2024/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-470-2024-UAC-tesis-multidisciplinarias.pdf'),

('Directivas', 'DIRECTIVA PARA EL DESCARTE DE MATERIAL BIBLIOHEMEROGRÁFICO Y/O AUDIOVISUAL DE LAS BIBLIOTECAS DE PREGRADO Y POSGRADO, DE LA UNIVERSIDAD ANDINA DEL CUSCO Y ANEXOS', 'Res. N° 353-2024/CU-UAC – Directiva', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-353-2024-UAC-descarte-material-bibliohemerografico-audiovisual.pdf'),

('Directivas', 'DIRECTIVA N° 001-2023/VRAC-UAC SOBRE MATERIAL DE USO EN SESIONES DE CLASE PARA LAS ASIGNATURAS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 010-2023/CU-UAC – Directiva N° 001-2023/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-010-2023-UAC-material-sesiones.pdf'),

('Directivas', 'DIRECTIVA N° 008-2022/VRAC(COVID-19)-UAC DE PROCEDIMIENTO DE IMPLEMENTACIÓN, FUNCIONAMIENTO Y EVALUACIÓN DEL PROGRAMA DE NIVELACIÓN PARA INGRESANTES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 223-2022/R-UAC – Directiva N° 008-2022/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2022/R_R-223-2022-UAC-procedimiento-nivelacion-estudiantes.pdf'),

('Directivas', 'DIRECTIVA N° 002-2020/VRAC-UAC(COVID-19) DE PROCEDIMIENTOS PARA LA IMPLEMENTACION DE EDUCACIÓN VIRTUAL EN LAS MODALIDADES PRESENCIAL, SEMIPRESENCIAL Y A DISTANCIA EN LA PLATAFORMA MOODLE DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 096-2020/VRAC-UAC – Directiva N° 002-2020/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2020/R_VRAC-096-2020-UAC-procedimientos-implementacion-educacion-virtual.pdf'),

('Directivas', 'DIRECTIVA N° 007-2019/VRAC-UAC DE PROCEDIMIENTOS PARA LA ELABORACIÓN, IMPLEMENTACIÓN Y EVALUACIÓN DEL SÍLABO Y GUÍA DE PRÁCTICAS', 'Res. N° 543-2019/CU-UAC – Directiva N° 007-2019/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-543-2019-UAC-procedimiento-silabo.pdf'),
('Directivas', 'Rectifican el error material contenido, Directiva N°007-2019-VRAC-UAC', 'Res. N°598-2019/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/2019/R_CU-598-2019-UAC-rectificar.pdf'),

('Directivas', 'DIRECTIVA QUE REGULA LA AFILIACIÓN INSTITUCIONAL Y DE AUTORES EN LAS PUBLICACIONES CIENTÍFICAS DEL PERSONAL VINCULADO A LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°167-2018/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-167-2018-UAC-afiliacion-publicacion-cientifica.pdf'),

('Directivas', 'DIRECTIVA N° 009-2017/VRAC-UAC DE PERMANENCIA, CONTROL DE ASISTENCIA Y NORMAS INTERNAS DE TRABAJO DEL PERSONAL DOCENTE NOMBRADO Y CONTRATADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°617-2017/CU-UAC – Directiva N° 009-2017/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-617-2017-UAC-asistencia-normas-docentes.pdf'),
('Directivas', 'Modifican literal b) del numeral VII de la carga lectiva y no lectiva de la Directiva N°009-2017-VRAC-UAC', 'Res. N°256-2016/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-256-2018-UAC-modificacion-literal.pdf'),

('Directivas', 'DIRECTIVA N° 001-2017/EPG-UAC DE EVALUACIÓN PARA EL INGRESO A LA DOCENCIA EN LA ESCUELA DE POSGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°372-2017/R-UAC – Directiva N° 001-2017/EPG-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_R-372-2017-UAC-evaluacion-ingreso-docencia-epg.pdf'),

('Directivas', 'DIRECTIVA PARA LA PRESENTACIÓN, EVALUACIÓN, DESARROLLO Y FINANCIAMIENTO DE PROYECTOS DE INVESTIGACIÓN Y ANEXOS', 'Res. N°368-2017/R-UAC – Directiva', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_R-368-2017-UAC-presentacion-proyectos-investigacion.pdf'),

('Directivas', 'DIRECTIVA N° 007-2017/VRAC-UAC DEL PROCESO DE ADMISIÓN EXTRAORDINARIA A LA ESCUELA DE POSGRADO', 'Res. N°356-2017/R-UAC – Directiva N° 007-2017/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_R-356-2017-UAC-admision-extraordinaria-epg.pdf'),

('Directivas', 'DIRECTIVA N° 05-2017/VRAC-UAC SOBRE PROCEDIMIENTO PARA CONTRATAR DOCENTES Y JEFES DE PRÁCTICA MEDIANTE LA MODALIDAD DE INVITACIÓN', 'Res. N°209-2017/R-UAC – Directiva N° 05-2017/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_R-209-2017-UAC-contratar-docentes-invitacion.pdf'),

('Directivas', 'DIRECTIVA N° 04-2017/VRAC-UAC DE PROCEDIMIENTOS PARA LA PLANIFICACIÓN, EJECUCIÓN Y EVALUACIÓN DEL PLAN INTEGRAL DE CAPACITACIÓN INSTITUCIONAL Y ESPECIALIZADA DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°148-2017/CU-UAC – Directiva N° 04-2017/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-148-2017-UAC-directiva004-vrac-capacitacion-institucional.pdf'),

('Directivas', 'DIRECTIVA N° 001-2017-VRIN-UAC PARA LA PRESENTACIÓN DE ARTÍCULOS EN LAS REVISTAS DE LA UAC PARA LOS AUTORES/AS', 'Res. N°117-2017/CU-UAC – Directiva N° 001-2017/VRIN-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-117-2017-UAC-directiva001-vrin-presentacion-articulos.pdf'),

('Directivas', 'DIRECTIVA N° 014-2016/VRAC-UAC DE IMPLEMENTACIÓN DEL SISTEMA INSTITUCIONAL DE TUTORÍA Y ATENCIÓN PSICOPEDAGÓGICA (SITAP) EN LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°752-2016/CU-UAC – Directiva N° 014-2016/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-752-2016-UAC-implementacion-sitap.pdf'),

('Directivas', 'DIRECTIVA DEL PROCEDIMIENTO PARA EL FUNCIONAMIENTO DE LOS TALLERES DE TESIS (PRO-TESIS)', 'Res. N°704-2016/CU-UAC – Directiva N° 12-2016/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-704-2016-UAC-procedimiento-talleres-pro-tesis.pdf'),

('Directivas', 'DIRECTIVA DEL PROCEDIMIENTO DE DISPENSA ACADÉMICA PARA EL PRE-GRADO', 'Res. N°561-2018/CU-UAC – Directiva N° 05-2018/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-561-2018-UAC-directiva-dispensa-academica-pregrado.pdf'),
('Directivas', 'Modifican nomenclatura de la dispensa académica y al literal a) del numeral V. Generalidades de la Resolución 561-CU-2018-UAC', 'Res. N°591-2018/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-591-2018-UAC-modificacion-561CU2018.pdf'),

('Directivas', 'DIRECTIVA DE PRÁCTICAS PRE PROFESIONALES DEL PLAN DE ESTUDIOS 2013 DE LA ESCUELA PROFESIONAL DE DERECHO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°682-2016/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-682-2016-UAC-directiva-ppp-derecho-PE2013.pdf'),

('Directivas', 'DIRECTIVA N° 10-2016/VRAC-UAC DE LAS ACTIVIDADES EXTRACURRICULARES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°306-2016/R-UAC – Directiva N° 10-2016/VRAC-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_R-306-2016-UAC-actividades-extracurriculares.pdf'),

('Directivas', 'DIRECTIVA PROCESO DE EVALUACIÓN CURRICULAR 2005 Y 2013 Y ADECUACIÓN CURRICULAR 2014 DE LAS CARRERAS PROFESIONALES DE LA UAC.', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_099-2014-UAC-directiva-evaluacion-curricular-2005-2013-adecuacion-2014.pdf'),

('Directivas', 'DIRECTIVA PROCESO DE ACREDITACIÓN INSTITUCIONAL Y ACREDITACIÓN DE LAS CARRERAS PROFESIONALES DE LA UAC.', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_100-2014-UAC-directiva-acreditacion-institucional-carreras-profesionales.pdf'),

('Directivas', 'LINEAMIENTOS POLÍTICOS DE LA GESTIÓN ACADÉMICA UNIVERSITARIA', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/R_CU-228-2014-UAC-aprobar-lineamientos-politicos-gestion-academica-universitaria.pdf');

-- === INVESTIGACIÓN ===
INSERT INTO directivas (seccion, titulo, resolucion, es_subdirectiva, enlace_pdf) VALUES
('Investigación', 'DIRECTIVA PARA LA IMPLEMENTACIÓN Y EJECUCIÓN DEL CURSO DE TRABAJO DE INVESTIGACIÓN PARA LOS ESTUDIANTES DEL ÚLTIMO CICLO ACADÉMICO O ESTUDIANTES EGRESADOS QUE NO LES CORRESPONDE POR LEY EL BACHILLERATO AUTOMÁTICO DE PREGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 093-2025/CU-UAC – Directiva N° 1-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-093-2025-UAC-implementacion-ejecucion-trabajo-investigacion.pdf'),

('Investigación', 'DIRECTIVA DE PROCEDIMIENTO DE EVALUACIÓN DE PROYECTOS DE INVESTIGACIÓN Y DESIGNACIÓN DE PARES EVALUADORES EN EL INSTITUTO CIENTÍFICO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N° 409-2023/CU-UAC – Directiva', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-409-2023-UAC-procedimiento-evaluacion-proyectos-investigacion.pdf');


-- Inserción de datos (manteniendo el orden exacto de la sección DECÁLOGOS UNIVERSITARIOS)
INSERT INTO decalogos (titulo, enlace_pdf) VALUES
('DECÁLOGO DEL ESTUDIANTE UNIVERSITARIO PERUANO', 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-estudiante-universitario.pdf'),
('DECÁLOGO DEL DOCENTE UNIVERSITARIO PERUANO', 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-docente-universitario.pdf'),
('DECÁLOGO DEL ADMINISTRATIVO UNIVERSITARIO PERUANO', 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-administrativo-universitario.pdf');







CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(100) NOT NULL COMMENT 'Categoría del documento (ej: Documentos normativos, Tasas, etc.)',
    titulo VARCHAR(255) NOT NULL COMMENT 'Título del documento',
    resolucion VARCHAR(100) DEFAULT NULL COMMENT 'Número de resolución que lo aprueba',
    vigente TINYINT(1) DEFAULT 1 COMMENT '1 = Vigente, 0 = No vigente',
    enlace_pdf TEXT NOT NULL COMMENT 'URL del archivo PDF',
    fecha_publicacion DATE DEFAULT NULL COMMENT 'Fecha de publicación',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro en el sistema',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
    INDEX idx_categoria (categoria),
    INDEX idx_vigente (vigente),
    INDEX idx_fecha_publicacion (fecha_publicacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Documentos relacionados con pagos, TUPA y tarifarios de UAC';

-- ============================================================================
-- INSERCIÓN DE DATOS
-- ============================================================================
INSERT INTO pagos (categoria, titulo, resolucion, vigente, enlace_pdf, fecha_publicacion) VALUES
('Documentos Normativos', 'TEXTO ÚNICO DE PROCEDIMIENTOS ADMINISTRATIVOS – TUPA UAC 2026', 'Res. N° 710-2025/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/tupa-uac.pdf', '2026-01-01'),
('Documentos Normativos', 'TARIFARIO UAC 2026', 'Res. N° 710-2025/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/tarifario-uac.pdf', '2026-01-01');




-- =========================================================
-- SISTEMA COMPLETO DE PROYECTOS DE INVESTIGACIÓN
-- Universidad Andina del Cusco
-- Incluye: DGI, Instituto Científico y TODOS los Proyectos de Tesis
-- =========================================================

-- Tabla principal


-- =========================================================
-- DIRECCIÓN DE GESTIÓN DE LA INVESTIGACIÓN (DGI)
-- =========================================================
INSERT INTO proyectos_investigacion (tipo_proyecto, anio, nombre_documento, enlace_pdf) VALUES
('DGI', 'General', 'PROYECTOS DE INVESTIGACIÓN Y LOS GASTOS QUE GENERE', 'https://www.uandina.edu.pe/descargas/transparencia/proyectos-investigacion.pdf'),
('DGI', '2017-2018', 'PROYECTOS DE INVESTIGACIÓN A FINANCIAR 2017-2018', 'https://www.uandina.edu.pe/descargas/transparencia/financiamiento-proyectos-inv.pdf'),
('DGI', '2020', 'PROYECTOS DE INVESTIGACIÓN A FINANCIAR 2020', 'https://www.uandina.edu.pe/descargas/transparencia/financiamiento-proyectos-investigacion-2020.pdf'),
('DGI', '2021', 'PROYECTOS DE INVESTIGACIÓN A FINANCIAR 2021', 'https://www.uandina.edu.pe/descargas/transparencia/financiamiento-proyectos-investigacion-2021.pdf'),
('DGI', '2022', 'PROYECTOS DE INVESTIGACIÓN A FINANCIAR 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigaciones-financiadas-2022.pdf'),
('DGI', '2023-I', 'PROYECTOS DE INVESTIGACIÓN A FINANCIAR 2023-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigaciones-financiadas-2023i.pdf'),
('DGI', '2023-II', 'PROYECTOS DE INVESTIGACIÓN A FINANCIAR 2023-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigaciones-financiadas-2023ii.pdf'),
('DGI', '2024', 'PROYECTOS DE INVESTIGACIÓN CON FINANCIAMIENTO 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigaciones-financiadas-2024.pdf'),
('DGI', '2025', 'PROYECTOS DE INVESTIGACIÓN CON FINANCIAMIENTO 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/2025/proyectos-investigacion-con-financiamiento-2025.pdf');

-- =========================================================
-- INSTITUTO CIENTÍFICO
-- =========================================================
INSERT INTO proyectos_investigacion (tipo_proyecto, anio, nombre_documento, enlace_pdf) VALUES
('INSTITUTO_CIENTIFICO', '2022', 'PROYECTOS INSTITUTO CIENTÍFICO 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/2022/proyectos-instituto-cientifico-2022.pdf'),
('INSTITUTO_CIENTIFICO', '2023', 'PROYECTOS INSTITUTO CIENTÍFICO 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/2023/proyectos-instituto-cientifico-2023.pdf'),
('INSTITUTO_CIENTIFICO', '2024', 'PROYECTOS INSTITUTO CIENTÍFICO 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/2024/proyectos-instituto-cientifico-2024.pdf'),
('INSTITUTO_CIENTIFICO', '2025', 'PROYECTOS INSTITUTO CIENTÍFICO 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/2025/proyectos-instituto-cientifico-2025.pdf');

-- =========================================================
-- FACULTAD DE DERECHO Y CIENCIA POLÍTICA
-- =========================================================
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/derecho-proyecto-tesis-2016-1.pdf'),
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2017', 'Proyectos de Tesis 2017', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/derecho-proyecto-tesis-2017.pdf'),
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/derecho-proyecto-tesis-2018.pdf'),
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/derecho-proyecto-tesis-2019.pdf'),
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/derecho-proyecto-tesis-2020.pdf'),
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/derecho-proyecto-tesis-2021.pdf'),
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/derecho-proyecto-tesis-2022.pdf'),
('TESIS', 'Derecho y Ciencia Política', 'Derecho', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/2023/derecho-proyecto-tesis-2023.pdf');

-- =========================================================
-- FACULTAD DE INGENIERÍA Y ARQUITECTURA
-- =========================================================

-- ARQUITECTURA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ingeniería y Arquitectura', 'Arquitectura', '2019-2020', 'Proyectos de Tesis 2019-2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ARQ-proy-tesis-fia-2019-2020.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Arquitectura', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ARQ-proy-tesis-fia-2021.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Arquitectura', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ARQ-proy-tesis-fia-2022.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Arquitectura', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ARQ-proy-tesis-fia-2023.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Arquitectura', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ARQ-proy-tesis-fia-2024.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Arquitectura', '2025', 'Proyectos de Tesis 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ARQ-proy-tesis-fia-2025.pdf');

-- INGENIERÍA AMBIENTAL
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Ambiental', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AMB-proy-tesis-fia-2021.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Ambiental', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AMB-proy-tesis-fia-2022.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Ambiental', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AMB-proy-tesis-fia-2023.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Ambiental', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AMB-proy-tesis-fia-2024.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Ambiental', '2025', 'Proyectos de Tesis 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AMB-proy-tesis-fia-2025.pdf');

-- INGENIERÍA CIVIL
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proyectos-tesis-fia-2016-1.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2017-I', 'Proyectos de Tesis 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2017-1.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2017-II', 'Proyectos de Tesis 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2017-2.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2018.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2019.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2020.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2021.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2022.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2023.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2024.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Civil', '2025', 'Proyectos de Tesis 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IC-proy-tesis-fia-2025.pdf');

-- INGENIERÍA INDUSTRIAL
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2016-I', 'Proyectos de Tesis 2016-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/II-proyectos-tesis-fia-2016-1.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2016-II', 'Proyectos de Tesis 2016-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/II-proy-tesis-fia-2016-2.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2017-I', 'Proyectos de Tesis 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/II-proy-tesis-fia-2017-1.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2017-II', 'Proyectos de Tesis 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/II-proy-tesis-fia-2017-2.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2018.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2019.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2020.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2021.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2022.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2023.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2024.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería Industrial', '2025', 'Proyectos de Tesis 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IIND-proy-tesis-fia-2025.pdf');

-- INGENIERÍA DE SISTEMAS
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proyectos-tesis-fia-2016-1.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2017-I', 'Proyectos de Tesis 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2017-1.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2017-II', 'Proyectos de Tesis 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2017-2.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2018.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2019.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2020.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2021.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2022.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2023.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2024.pdf'),
('TESIS', 'Ingeniería y Arquitectura', 'Ingeniería de Sistemas', '2025', 'Proyectos de Tesis 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/IS-proy-tesis-fia-2025.pdf');

-- =========================================================
-- FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES
-- =========================================================

-- ADMINISTRACIÓN
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2016-I / 2016-II', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2016.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2017-I', 'Proyectos de Tesis 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2017I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2017-II', 'Proyectos de Tesis 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2017II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2018-I', 'Proyectos de Tesis 2018-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2018I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2018-II', 'Proyectos de Tesis 2018-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2018II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2019-I', 'Proyectos de Tesis 2019-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2019I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2019-II', 'Proyectos de Tesis 2019-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2019II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2020-I', 'Proyectos de Tesis 2020-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2020I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2020-II', 'Proyectos de Tesis 2020-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2020II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2021-I', 'Proyectos de Tesis 2021-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2021I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2021-II', 'Proyectos de Tesis 2021-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2021II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2022-I', 'Proyectos de Tesis 2022-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2022i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2022-II', 'Proyectos de Tesis 2022-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2022ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2023-I', 'Proyectos de Tesis 2023-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2023i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2023-II', 'Proyectos de Tesis 2023-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2023ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2024-I', 'Proyectos de Tesis 2024-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2024i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración', '2024-II', 'Proyectos de Tesis 2024-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AD-proyectos-tesis-fceac-2024ii.pdf');

-- CONTABILIDAD
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2016-I / 2016-II', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2016.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2017-I', 'Proyectos de Tesis 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2017I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2017-II', 'Proyectos de Tesis 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2017II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2018-I', 'Proyectos de Tesis 2018-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2018I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2018-II', 'Proyectos de Tesis 2018-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2018II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2019-I', 'Proyectos de Tesis 2019-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2019I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2019-II', 'Proyectos de Tesis 2019-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2019II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2020-I', 'Proyectos de Tesis 2020-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2020I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2020-II', 'Proyectos de Tesis 2020-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2020II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2021-I', 'Proyectos de Tesis 2021-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2021I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2021-II', 'Proyectos de Tesis 2021-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2021II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2022-I', 'Proyectos de Tesis 2022-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CO-proyectos-tesis-fceac-2022i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2022-II', 'Proyectos de Tesis 2022-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2022ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2023-I', 'Proyectos de Tesis 2023-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2023i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2023-II', 'Proyectos de Tesis 2023-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CA-proyectos-tesis-fceac-2023ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2024-I', 'Proyectos de Tesis 2024-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CO-proyectos-tesis-fceac-2024i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Contabilidad', '2024-II', 'Proyectos de Tesis 2024-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/CO-proyectos-tesis-fceac-2024ii.pdf');

-- ECONOMÍA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2016-I / 2016-II', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2016.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2017-I', 'Proyectos de Tesis 2017-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2017I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2017-II', 'Proyectos de Tesis 2017-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2017II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2018-I', 'Proyectos de Tesis 2018-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2018I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2018-II', 'Proyectos de Tesis 2018-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2018II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2019-I', 'Proyectos de Tesis 2019-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2019I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2019-II', 'Proyectos de Tesis 2019-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2019II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2020-I', 'Proyectos de Tesis 2020-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2020I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2020-II', 'Proyectos de Tesis 2020-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2020II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2021-I', 'Proyectos de Tesis 2021-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2021I.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2021-II', 'Proyectos de Tesis 2021-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2021II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2022-I', 'Proyectos de Tesis 2022-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2022i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2022-II', 'Proyectos de Tesis 2022-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2022ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2023-I', 'Proyectos de Tesis 2023-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2023i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2023-II', 'Proyectos de Tesis 2023-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2023ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2024-I', 'Proyectos de Tesis 2024-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2024i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Economía', '2024-II', 'Proyectos de Tesis 2024-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EC-proyectos-tesis-fceac-2024ii.pdf');

-- ADMINISTRACIÓN DE NEGOCIOS INTERNACIONALES
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración de Negocios Internacionales', '2021-II', 'Proyectos de Tesis 2021-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ADNI-proyectos-tesis-fceac-2021II.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración de Negocios Internacionales', '2022-I', 'Proyectos de Tesis 2022-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ADNI-proyectos-tesis-fceac-2022i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración de Negocios Internacionales', '2022-II', 'Proyectos de Tesis 2022-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ADNI-proyectos-tesis-fceac-2022ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración de Negocios Internacionales', '2023-I', 'Proyectos de Tesis 2023-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ADNI-proyectos-tesis-fceac-2023i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración de Negocios Internacionales', '2023-II', 'Proyectos de Tesis 2023-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ADNI-proyectos-tesis-fceac-2023ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración de Negocios Internacionales', '2024-I', 'Proyectos de Tesis 2024-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AN-proyectos-tesis-fceac-2024i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Administración de Negocios Internacionales', '2024-II', 'Proyectos de Tesis 2024-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/AN-proyectos-tesis-fceac-2024ii.pdf');

-- MARKETING
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Marketing', '2022-I', 'Proyectos de Tesis 2022-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MKT-proyectos-tesis-fceac-2022i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Marketing', '2022-II', 'Proyectos de Tesis 2022-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MKT-proyectos-tesis-fceac-2022ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Marketing', '2023-I', 'Proyectos de Tesis 2023-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MKT-proyectos-tesis-fceac-2023i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Marketing', '2023-II', 'Proyectos de Tesis 2023-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MKT-proyectos-tesis-fceac-2023ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Marketing', '2024-I', 'Proyectos de Tesis 2024-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MK-proyectos-tesis-fceac-2024i.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Marketing', '2024-II', 'Proyectos de Tesis 2024-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MK-proyectos-tesis-fceac-2024ii.pdf');

-- FINANZAS
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Finanzas', '2023-II', 'Proyectos de Tesis 2023-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/FIN-proyectos-tesis-fceac-2023ii.pdf'),
('TESIS', 'Ciencias Económicas, Administrativas y Contables', 'Finanzas', '2024-II', 'Proyectos de Tesis 2024-II', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/FIN-proyectos-tesis-fceac-2024ii.pdf');

-- =========================================================
-- FACULTAD DE CIENCIAS DE LA SALUD
-- =========================================================

-- ENFERMERÍA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2015', 'Proyectos de Tesis 2015', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2015.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2016-1.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2017', 'Proyectos de Tesis 2017', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2017.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2018.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2019.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2020.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2021.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2022.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2024.pdf'),
('TESIS', 'Ciencias de la Salud', 'Enfermería', '2025-I', 'Proyectos de Tesis 2025-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/ENF-proyectos-tesis-facsa-2025i.pdf');

-- ESTOMATOLOGÍA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2015', 'Proyectos de Tesis 2015', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2015.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2016-1.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2018.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2019.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2020.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2021.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2022.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2023.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2024.pdf'),
('TESIS', 'Ciencias de la Salud', 'Estomatología', '2025-I', 'Proyectos de Tesis 2025-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/EST-proyectos-tesis-facsa-2025i.pdf');

-- OBSTETRICIA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2015', 'Proyectos de Tesis 2015', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2015.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2016-1.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2017', 'Proyectos de Tesis 2017', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2017.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2018.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2019.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2020.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2021.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2022.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2023.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2024.pdf'),
('TESIS', 'Ciencias de la Salud', 'Obstetricia', '2025-I', 'Proyectos de Tesis 2025-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/OBS-proyectos-tesis-facsa-2025i.pdf');

-- PSICOLOGÍA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias de la Salud', 'Psicología', '2015', 'Proyectos de Tesis 2015', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2015.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2016-1.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2017', 'Proyectos de Tesis 2017', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2017.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2018.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2019.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2020.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2021.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2022.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2023.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2024.pdf'),
('TESIS', 'Ciencias de la Salud', 'Psicología', '2025-I', 'Proyectos de Tesis 2025-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/PSI-proyectos-tesis-facsa-2025i.pdf');

-- MEDICINA HUMANA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2017', 'Proyectos de Tesis 2017', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2017.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2018', 'Proyectos de Tesis 2018', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2018.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2019', 'Proyectos de Tesis 2019', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2019.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2020', 'Proyectos de Tesis 2020', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2020.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2021', 'Proyectos de Tesis 2021', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2021.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2022.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2023.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2024.pdf'),
('TESIS', 'Ciencias de la Salud', 'Medicina Humana', '2025-I', 'Proyectos de Tesis 2025-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/MH-proyectos-tesis-facsa-2025i.pdf');

-- TECNOLOGÍA MÉDICA
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias de la Salud', 'Tecnología Médica', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/TM-proyectos-tesis-facsa-2024.pdf'),
('TESIS', 'Ciencias de la Salud', 'Tecnología Médica', '2025-I', 'Proyectos de Tesis 2025-I', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/TM-proyectos-tesis-facsa-2025-i.pdf');

-- =========================================================
-- FACULTAD DE CIENCIAS Y HUMANIDADES
-- =========================================================
INSERT INTO proyectos_investigacion (tipo_proyecto, facultad, escuela_profesional, anio, nombre_documento, enlace_pdf) VALUES
('TESIS', 'Ciencias y Humanidades', 'Turismo - Educación', '2016', 'Proyectos de Tesis 2016', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/cchh-proyecto-tesis-2016.pdf'),
('TESIS', 'Ciencias y Humanidades', 'Turismo - Educación', '2022', 'Proyectos de Tesis 2022', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/proyectos-tesis-fch-2022.pdf'),
('TESIS', 'Ciencias y Humanidades', 'Turismo - Educación', '2023', 'Proyectos de Tesis 2023', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/proyectos-tesis-fch-2023.pdf'),
('TESIS', 'Ciencias y Humanidades', 'Turismo - Educación', '2024', 'Proyectos de Tesis 2024', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/proyectos-tesis-fch-2024.pdf'),
('TESIS', 'Ciencias y Humanidades', 'Turismo - Educación', '2025', 'Proyectos de Tesis 2025', 'https://www.uandina.edu.pe/descargas/transparencia/investigacion/proyectos-tesis-fch-2025.pdf');





-- Inserción de todos los registros con URLs completas
INSERT INTO uac_resoluciones 
    (grupo, subgrupo, descripcion, enlace_pdf, numero_resolucion, es_subresolucion) 
VALUES
    -- Grupo: RESOLUCIONES
    ('RESOLUCIONES', NULL, 
     'GUÍA DE ATENCIÓN PREFERENTE AL PÚBLICO USUARIO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R_R-258-2025-UAC-guia-atencion-preferente.pdf', 
     'Res. N°258-2025/R-UAC', FALSE),
     
    ('RESOLUCIONES', NULL, 
     'POLÍTICA, OBJETIVOS DE CALIDAD Y MAPA DE PROCESOS DE LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-214-2025-UAC-politica-objetivos-calidad.pdf', 
     'Res. N°214-2025/CU-UAC', FALSE),
     
    ('RESOLUCIONES', NULL, 
     'DECLARAN FERIADOS NO LABORABLES EN LA UNIVERSIDAD ANDINA DEL CUSCO PARA EL AÑO 2025', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R_R-005-2025-UAC-dias-no-laborables-2025.pdf', 
     'Res. N° 005-2025/R-UAC', FALSE),
     
    ('RESOLUCIONES', NULL, 
     'Trasladan la celebración del aniversario de la Universidad Andina del Cusco al 30 de mayo de 2025', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R-R-114-2025-UAC-modificacion-Res005R2025.pdf', 
     'Res. N° 114-2025/R-UAC', TRUE),
     
    ('RESOLUCIONES', NULL, 
     'Rectifican el error material contenido en la resolución N° 005 en lo que corresponde en la fecha de la festividad del Corpus Christi', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R-R-40-2025-UAC-rectificacion-Res005R2025.pdf', 
     'Res. N° 040-2025/R-UAC', TRUE),
     
    ('RESOLUCIONES', NULL, 
     'APRUEBAN LAS TASAS DE MATRÍCULAS Y CUOTA DE PENSIÓN EDUCATIVAS DE LA UNIVERSIDAD ANDINA DEL CUSCO, PARA INGRESANTES A ESTUDIOS DE PREGRADO AÑO 2025 – MODALIDAD PRESENCIAL', 
     'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-542-2024-UAC-tasas-matricula-cuota-pension-2025.pdf', 
     'Res. N°542-2024/CU-UAC', FALSE),
     
    ('RESOLUCIONES', NULL, 
     'APRUEBAN EL “MODELO EDUCATIVO DE LA UNIVERSIDAD ANDINA DEL CUSCO VERSIÓN 2″', 
     'https://www.uandina.edu.pe/descargas/transparencia/2022/R_CU-326-2022-UAC-modelo-educativo-v2.pdf', 
     'Res. N°326-2022/CU-UAC', FALSE),
     
    -- ... (continúan los demás del grupo RESOLUCIONES) ...
    ('RESOLUCIONES', NULL, 
     'RECOMENDACIONES PARA EL REPOSITORIO DE LA UNIVERSIDAD ANDINA DEL CUSCO Y FORMATO DE AUTORIZACIÓN DE DEPÓSITO DE TESIS EN EL MENCIONADO REPOSITORIO', 
     'https://www.uandina.edu.pe/descargas/transparencia/R_CU-357-2017-UAC-recomendaciones-repositorio-formato.pdf', 
     'Res. N° 357-2017/CU-UAC', FALSE),

    -- Grupo: SOBRE ADMISIÓN → Pregrado
    ('SOBRE ADMISIÓN', 'Pregrado', 
     'APRUEBAN LAS VACANTES PARA LOS PROCESOS DE ADMISIÓN 2025-II Y 2026-I, SEDE CENTRAL Y FILIALES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-130-2025-UAC-vacantes-2025ii-2026i.pdf', 
     'Res. N°130-2025/CU-UAC', FALSE),
     
    ('SOBRE ADMISIÓN', 'Pregrado', 
     'Disponen la adecuación del cuadro de vacantes correspondiente al examen de admisión para estudiantes de quinto de secundaria 2026-I de la Universidad Andina del Cusco', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R_R-278-2025-UAC-adecuacion-vacantes-5to-secundaria-2026i.pdf', 
     'Res. N°278-2025/R-UAC', TRUE),
     
    -- (continúan todas las demás de Pregrado con sus modificaciones y adecuaciones de vacantes...)
    
    ('SOBRE ADMISIÓN', 'Pregrado', 
     'APRUEBAN NUEVAS MODALIDADES DE INGRESO A LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2024/R_R-368-2024-UAC-nuevas-modalidades-ingreso.pdf', 
     'Res. N°368-2024/R-UAC', FALSE),

    -- Grupo: SOBRE PENSIONES
    ('SOBRE PENSIONES', NULL, 
     'CRONOGRAMA DE PAGO DE CUOTA DE PENSIONES EDUCATIVAS DE PREGRADO, SEGUNDAS ESPECIALIDADES SEMESTRES ACADÉMICOS 2025-I, 2025-II ASÍ COMO DE LA ESCUELA DE POSGRADO SEMESTRES ACADÉMICOS 2025-I, 2025-II Y 2025-III DE LA UNIVERSIDAD ANDINA DEL CUSCO, CORRESPONDIENTE AL AÑO 2025', 
     'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-626-2024-UAC-cronograma-pagos-2025.pdf', 
     'Res. N° 626-2024/CU-UAC', FALSE),

    -- Grupo: SOBRE MODALIDADES → Pregrado
    ('SOBRE MODALIDADES', 'Pregrado', 
     'APRUEBAN LA AMPLIACIÓN DEL SERVICIO EDUCATIVO DE LA UNIVERSIDAD ANDINA DEL CUSCO CON LA IMPLEMENTACIÓN DE LAS MODALIDADES DE SEMIPRESENCIAL Y A DISTANCIA A NIVEL DE PREGRADO DE LA SEDE CUSCO Y FILIALES DE LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2022/R_R-485-2022-UAC-ampliacion-servicio-educativo-pregrado.pdf', 
     'Res. N°485-2022/R-UAC', FALSE),
     
    ('SOBRE MODALIDADES', 'Pregrado', 
     'Rectifican el error material contenido en la resolución N°485-R-2022-UAC en el extremo que corresponde al encabezado del citado acto administrativo', 
     'https://www.uandina.edu.pe/descargas/transparencia/2022/R_R-494-2022-UAC-rectificacion-error-material-485R2022.pdf', 
     'Res. N°494-2022/R-UAC', TRUE),

    -- Grupo: SOBRE MODALIDADES → Posgrado
    ('SOBRE MODALIDADES', 'Posgrado', 
     'EXTIENDEN LOS EFECTOS DE LA RESOLUCIÓN N.°485-R-2022-UAC, MODIFICADO CON RESOLUCIÓN N.° 494-R-2022-UAC Y, POR CONSIGUIENTE, AMPLÍAN EL SERVICIO EDUCATIVO DE LA UNIVERSIDAD ANDINA DEL CUSCO CON LA IMPLEMENTACIÓN DE LAS MODALIDADES DE SEMIPRESENCIAL Y A DISTANCIA A NIVEL DE POSGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2023/R_CU-246-2023-UAC-modalidades-posgrado.pdf', 
     'Res. N°246-2023/CU-UAC', FALSE),

    -- Grupo: SOBRE ADMISIÓN → Posgrado: 2025
    ('SOBRE ADMISIÓN', 'Posgrado: 2025', 
     'APRUEBAN EL CUADRO DE VACANTES PARA LOS DISTINTOS PROGRAMAS DE MAESTRÍA Y DOCTORADO EN MODALIDAD PRESENCIAL Y A DISTANCIA, PARA EL PROCESO DE ADMISIÓN 2025-III DE LA ESCUELA DE POSGRADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-440-2025-UAC-cuadro-vacantes-epg-2025iii.pdf', 
     'Res. N° 440-2025/CU-UAC', FALSE),
     
    ('SOBRE ADMISIÓN', 'Posgrado: 2025', 
     'AUTORIZAN LA EXONERACIÓN DEL PAGO DE DERECHOS DE INSCRIPCIÓN PARA EL PROCESO DE ADMISIÓN 2025-III DE LA ESCUELA DE POSGRADO DE LA UAC', 
     'https://www.uandina.edu.pe/descargas/transparencia/2025/R_CU-229-2025-UAC-exoneran-pago-inscripcion-epg-2025iii.pdf', 
     'Res. N° 229-2025/CU-UAC', FALSE),
     
    ('SOBRE ADMISIÓN', 'Posgrado: 2025', 
     'AUTORIZAN LA EXONERACIÓN DEL PAGO DE DERECHOS DE INSCRIPCIÓN PARA EL PROCESO DE ADMISIÓN DE LA ESCUELA DE POSGRADO 2025-II PARA LOS PROGRAMAS DE MAESTRÍA Y DOCTORADO DE LA UNIVERSIDAD ANDINA DEL CUSCO', 
     'https://www.uandina.edu.pe/descargas/transparencia/2024/R_CU-651-2024-UAC-exoneran-pago-inscripcion-epg-2025ii.pdf', 
     'Res. N° 651-2024/CU-UAC', FALSE);




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
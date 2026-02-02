-- =========================================================
-- SISTEMA COMPLETO DE PROYECTOS DE INVESTIGACIÓN
-- Universidad Andina del Cusco
-- Incluye: DGI, Instituto Científico y TODOS los Proyectos de Tesis
-- =========================================================

-- Tabla principal
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


-- ============================================================================
-- BASE DE DATOS: DOCUMENTOS NORMATIVOS UANDINA
-- URLs COMPLETAS Y VERIFICADAS + SECCIÓN DECÁLOGOS
-- ============================================================================

CREATE DATABASE IF NOT EXISTS portal_transparencia 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE portal_transparencia;

-- ============================================================================
-- TABLA: doc_normativos
-- ============================================================================

DROP TABLE IF EXISTS doc_normativos;

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

-- ============================================================================
-- DATOS: Documentos Normativos
-- ============================================================================

-- === ESTATUTO UAC ===
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'ESTATUTO UAC', 'Res. N°009-2014/AU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_AU-009-2014-UAC-estatuto-260422.pdf', NULL);

SET @estatuto_id = LAST_INSERT_ID();

-- Modificaciones al Estatuto UAC (52 modificaciones en orden cronológico inverso)
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

-- === TUPA Y TARIFARIO ===
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'TEXTO ÚNICO DE PROCEDIMIENTOS ADMINISTRATIVOS – TUPA UAC 2026', 'Res. N° 710-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/tupa-uac.pdf', NULL),
('Documentos normativos', 'TARIFARIO UAC 2026', 'Res. N° 710-2025/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/tarifario-uac.pdf', NULL);

-- === OTROS DOCUMENTOS NORMATIVOS ===
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'PROYECTO GENERAL DE DESARROLLO 2015 – 2025', 'Res. N°295-2015/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/documentos/planificacion/PGD-2015-2025-UAC-280416.pdf', NULL),
('Documentos normativos', 'PLAN OPERATIVO INSTITUCIONAL 2025', 'Res. N°696-2024/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-696-2024-UAC-poi-2025.pdf', NULL),
('Documentos normativos', 'PLAN ESTRATÉGICO INSTITUCIONAL 2023-2026', 'Res. N°507-2022/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-507-2022-UAC-pei-2023-2026.pdf', NULL);

-- === REGLAMENTO ORGANIZACIONAL DE FUNCIONES (ROF) ===
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'REGLAMENTO ORGANIZACIONAL DE FUNCIONES – ROF', 'Res. N°477-2017/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/rof-uac.pdf', NULL);

SET @rof_id = LAST_INSERT_ID();

-- Modificaciones al ROF (13 modificaciones)
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

-- === REGLAMENTO GENERAL ===
INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'REGLAMENTO GENERAL DE LA UNIVERSIDAD ANDINA DEL CUSCO', 'Res. N°293-2015/CU-UAC', 0, 'https://www.uandina.edu.pe/descargas/transparencia/2015/R_CU-293-2015-UAC-reglamento-general-uac.pdf', NULL);

SET @reglamento_general_id = LAST_INSERT_ID();

INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Documentos normativos', 'Modifican artículo 57° del Reglamento General de la Universidad Andina del Cusco', 'Res. N° 464-2017/CU-UAC', 1, 'https://www.uandina.edu.pe/descargas/transparencia/R_CU-464-2017-UAC-modificacion-reglamento-general-uac.pdf', @reglamento_general_id);

-- === OTROS DOCUMENTOS ===
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

-- ============================================================================
-- DECÁLOGOS
-- ============================================================================

INSERT INTO doc_normativos (seccion, titulo, resolucion, es_subitem, enlace, parent_id) VALUES
('Decálogos', 'DECÁLOGO DEL ESTUDIANTE UNIVERSITARIO PERUANO', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-estudiante-universitario.pdf', NULL),
('Decálogos', 'DECÁLOGO DEL DOCENTE UNIVERSITARIO PERUANO', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-docente-universitario.pdf', NULL),
('Decálogos', 'DECÁLOGO DEL ADMINISTRATIVO UNIVERSITARIO PERUANO', NULL, 0, 'https://www.uandina.edu.pe/descargas/documentos/normativos/decalogo-administrativo-universitario.pdf', NULL);

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
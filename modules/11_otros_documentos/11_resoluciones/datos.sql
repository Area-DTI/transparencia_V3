-- Crear la tabla (sin cambios)
CREATE TABLE IF NOT EXISTS uac_resoluciones (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    grupo               VARCHAR(255) NOT NULL,
    subgrupo            VARCHAR(255) DEFAULT NULL,
    descripcion         TEXT NOT NULL,
    enlace_pdf          VARCHAR(255) NOT NULL,
    numero_resolucion   VARCHAR(100) NOT NULL,
    es_subresolucion    BOOLEAN DEFAULT FALSE
);

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
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

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


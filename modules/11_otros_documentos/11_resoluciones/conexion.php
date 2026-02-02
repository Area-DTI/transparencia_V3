<?php
/**
 * ============================================================================
 * CONEXIÓN A BASE DE DATOS - RESOLUCIONES UAC
 * ============================================================================
 */

// Configuración de la base de datos
define('DB_HOST', 'localhost');
define('DB_NAME', 'portal_transparencia');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

// Zona horaria
date_default_timezone_set('America/Lima');

// Mostrar errores solo en desarrollo (comentar en producción)
error_reporting(E_ALL);
ini_set('display_errors', 1);

/**
 * Obtener conexión PDO
 */
function getConexion() {
    try {
        $dsn = sprintf(
            "mysql:host=%s;dbname=%s;charset=%s",
            DB_HOST,
            DB_NAME,
            DB_CHARSET
        );
        
        $opciones = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES " . DB_CHARSET
        ];
        
        return new PDO($dsn, DB_USER, DB_PASS, $opciones);
        
    } catch (PDOException $e) {
        error_log("Error de conexión DB: " . $e->getMessage());
        return null;
    }
}

/**
 * Cerrar conexión
 */
function cerrarConexion(&$conexion) {
    $conexion = null;
}
?>
<?php
/**
 * ============================================================================
 * CONEXIÓN A BASE DE DATOS - PORTAL DE TRANSPARENCIA UANDINA
 * ============================================================================
 * Archivo de configuración para la conexión a MySQL usando MySQLi
 */

// Configuración de la base de datos
define('DB_HOST', 'localhost');
define('DB_NAME', 'portal_transparencia');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_PORT', '3306');
define('DB_CHARSET', 'utf8mb4');

// Configuración de zona horaria
date_default_timezone_set('America/Lima');

// Configuración de errores (COMENTAR EN PRODUCCIÓN)
error_reporting(E_ALL);
ini_set('display_errors', 1);

/**
 * Crear conexión MySQLi
 * Esta variable se usa en api.php
 */
$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT);

// Verificar conexión
if ($conn->connect_error) {
    error_log("❌ Error de conexión: " . $conn->connect_error);
    die(json_encode([
        'success' => false,
        'error' => 'Error de conexión a la base de datos',
        'details' => $conn->connect_error
    ]));
}

// Configurar charset
if (!$conn->set_charset(DB_CHARSET)) {
    error_log("❌ Error al establecer charset: " . $conn->error);
}

// Log de conexión exitosa
error_log("✅ Conexión exitosa a la base de datos: " . DB_NAME);

/**
 * Función de verificación de conexión
 * Puedes ejecutar este archivo directamente para probar
 */
if (basename(__FILE__) == basename($_SERVER['PHP_SELF'])) {
    header('Content-Type: application/json; charset=utf-8');
    
    $response = [
        'success' => true,
        'message' => 'Conexión exitosa a la base de datos',
        'database' => DB_NAME,
        'host' => DB_HOST,
        'charset' => DB_CHARSET
    ];
    
    // Verificar si existe la tabla directivas
    $table_check = $conn->query("SHOW TABLES LIKE 'directivas'");
    
    if ($table_check && $table_check->num_rows > 0) {
        $response['table_exists'] = true;
        
        // Contar registros
        $count_query = $conn->query("SELECT COUNT(*) as total FROM directivas");
        if ($count_query) {
            $count = $count_query->fetch_assoc();
            $response['total_records'] = (int)$count['total'];
        }
        
        // Contar secciones diferentes
        $sections_query = $conn->query("SELECT COUNT(DISTINCT seccion) as total_sections FROM directivas");
        if ($sections_query) {
            $sections = $sections_query->fetch_assoc();
            $response['total_sections'] = (int)$sections['total_sections'];
        }
        
        // Contar subdirectivas
        $sub_query = $conn->query("SELECT COUNT(*) as total_sub FROM directivas WHERE es_subdirectiva = 1");
        if ($sub_query) {
            $sub = $sub_query->fetch_assoc();
            $response['total_subdirectivas'] = (int)$sub['total_sub'];
        }
    } else {
        $response['table_exists'] = false;
        $response['warning'] = 'La tabla "directivas" no existe en la base de datos';
    }
    
    echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    
    $conn->close();
    exit;
}
?>
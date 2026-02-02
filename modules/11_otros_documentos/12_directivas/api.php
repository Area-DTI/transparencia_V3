<?php
/**
 * =====================================================
 * API - DIRECTIVAS
 * =====================================================
 * API para el Portal de Transparencia de UANDINA
 * Retorna directivas agrupadas por sección
 */

// Mostrar errores (SOLO para desarrollo, comentar en producción)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Establecer headers
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

// Conexión a la base de datos
require_once 'conexion.php';

// Verificar conexión
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error de conexión a la base de datos',
        'details' => $conn->connect_error
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

try {
    // Consulta SQL - obteniendo todos los campos necesarios
    $sql = "
        SELECT
            id,
            seccion,
            titulo,
            resolucion,
            es_subdirectiva,
            enlace_pdf
        FROM directivas
        ORDER BY seccion, es_subdirectiva, id
    ";
    
    $result = $conn->query($sql);
    
    if (!$result) {
        throw new Exception("Error en la consulta SQL: " . $conn->error);
    }
    
    // Agrupar directivas por sección
    $directivasPorSeccion = [];
    
    while ($row = $result->fetch_assoc()) {
        $seccion = $row['seccion'];
        
        if (!isset($directivasPorSeccion[$seccion])) {
            $directivasPorSeccion[$seccion] = [];
        }
        
        $directivasPorSeccion[$seccion][] = [
            'id' => (int)$row['id'],
            'seccion' => $row['seccion'],
            'titulo' => $row['titulo'],
            'resolucion' => $row['resolucion'],
            'es_subdirectiva' => (int)$row['es_subdirectiva'],
            'enlace_pdf' => $row['enlace_pdf']
        ];
    }
    
    // Contar totales
    $totalDirectivas = 0;
    foreach ($directivasPorSeccion as $directivas) {
        $totalDirectivas += count($directivas);
    }
    
    // Log para debug
    error_log("✅ API: Se retornaron " . $totalDirectivas . " directivas en " . count($directivasPorSeccion) . " secciones");
    
    // Respuesta exitosa
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'total' => $totalDirectivas,
        'secciones' => count($directivasPorSeccion),
        'data' => $directivasPorSeccion
    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    // Manejo de errores
    error_log("❌ Error en API: " . $e->getMessage());
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error al obtener los datos',
        'message' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}

// Cerrar conexión
$conn->close();
?>
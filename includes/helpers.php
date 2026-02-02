<?php
/**
 * FUNCIONES HELPER GLOBALES
 * Funciones reutilizables en todo el sistema
 */

// Cargar configuración
require_once __DIR__ . '/../config/app.php';
require_once __DIR__ . '/../config/database.php';

/**
 * Sanitizar entrada de usuario
 */
function sanitize($data) {
    if (is_array($data)) {
        return array_map('sanitize', $data);
    }
    return htmlspecialchars(strip_tags(trim($data)), ENT_QUOTES, 'UTF-8');
}

/**
 * Validar email
 */
function isValidEmail($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}

/**
 * Generar token CSRF
 */
function generateCSRFToken() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    
    return $_SESSION['csrf_token'];
}

/**
 * Validar token CSRF
 */
function validateCSRFToken($token) {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    
    return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
}

/**
 * Respuesta JSON
 */
function jsonResponse($data, $statusCode = 200) {
    http_response_code($statusCode);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    exit;
}

/**
 * Respuesta de error JSON
 */
function jsonError($message, $statusCode = 400) {
    jsonResponse(['error' => true, 'message' => $message], $statusCode);
}

/**
 * Respuesta de éxito JSON
 */
function jsonSuccess($message, $data = null) {
    $response = ['success' => true, 'message' => $message];
    if ($data !== null) {
        $response['data'] = $data;
    }
    jsonResponse($response);
}

/**
 * Verificar si usuario está autenticado
 */
function isAuthenticated() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    return isset($_SESSION['admin_user']) && isset($_SESSION['admin_id']);
}

/**
 * Requerir autenticación
 */
function requireAuth() {
    if (!isAuthenticated()) {
        header('Location: /admin/login.php');
        exit;
    }
}

/**
 * Obtener usuario actual
 */
function getCurrentUser() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    
    if (!isset($_SESSION['admin_user'])) {
        return null;
    }
    
    return [
        'id' => $_SESSION['admin_id'] ?? null,
        'email' => $_SESSION['admin_user'] ?? null,
        'name' => $_SESSION['admin_name'] ?? null,
        'picture' => $_SESSION['admin_picture'] ?? null,
    ];
}

/**
 * Registrar actividad en log
 */
function logActivity($action, $table_name = null, $record_id = null, $old_values = null, $new_values = null) {
    try {
        $db = getDB();
        $user = getCurrentUser();
        
        $stmt = $db->prepare("
            INSERT INTO activity_logs 
            (user_id, action, table_name, record_id, old_values, new_values, ip_address, user_agent)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ");
        
        $stmt->execute([
            $user['id'] ?? null,
            $action,
            $table_name,
            $record_id,
            $old_values ? json_encode($old_values) : null,
            $new_values ? json_encode($new_values) : null,
            $_SERVER['REMOTE_ADDR'] ?? null,
            $_SERVER['HTTP_USER_AGENT'] ?? null,
        ]);
        
        return true;
    } catch (Exception $e) {
        error_log("Error logging activity: " . $e->getMessage());
        return false;
    }
}

/**
 * Formatear fecha
 */
function formatDate($date, $format = 'd/m/Y H:i') {
    if (empty($date)) return '';
    $dt = new DateTime($date);
    return $dt->format($format);
}

/**
 * Obtener ruta absoluta desde cualquier nivel
 */
function getBasePath() {
    return rtrim(dirname(dirname(__FILE__)), '/');
}

/**
 * Incluir vista
 */
function view($file, $data = []) {
    extract($data);
    $path = getBasePath() . '/views/' . $file . '.php';
    
    if (file_exists($path)) {
        include $path;
    } else {
        die("Vista no encontrada: $file");
    }
}

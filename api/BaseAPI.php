<?php
/**
 * Clase Base para todas las APIs
 * Portal de Transparencia - Universidad Andina del Cusco
 */

// Configuración de errores para desarrollo (cambiar en producción)
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

class BaseAPI {
    protected $db;
    protected $table;
    
    public function __construct($db, $table = '') {
        $this->db = $db;
        $this->table = $table;
        
        // Headers CORS y JSON
        $this->setCorsHeaders();
        header('Content-Type: application/json; charset=utf-8');
    }
    
    /**
     * Configurar headers CORS
     */
    protected function setCorsHeaders() {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization');
        header('Access-Control-Max-Age: 86400');
        
        // Manejar preflight OPTIONS
        if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
            http_response_code(200);
            exit;
        }
    }
    
    /**
     * Respuesta exitosa
     */
    protected function success($data, $message = 'Operación exitosa') {
        http_response_code(200);
        echo json_encode([
            'success' => true,
            'message' => $message,
            'data' => $data
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
    
    /**
     * Respuesta de error
     */
    protected function error($message, $code = 400, $details = null) {
        http_response_code($code);
        $response = [
            'success' => false,
            'error' => $message
        ];
        
        if ($details !== null) {
            $response['details'] = $details;
        }
        
        echo json_encode($response, JSON_UNESCAPED_UNICODE);
        exit;
    }
    
    /**
     * Validar método HTTP
     */
    protected function validateMethod($allowedMethods) {
        $method = $_SERVER['REQUEST_METHOD'];
        
        if (!in_array($method, $allowedMethods)) {
            $this->error(
                'Método no permitido', 
                405, 
                ['allowed' => $allowedMethods, 'received' => $method]
            );
        }
        
        return $method;
    }
    
    /**
     * Obtener parámetros GET
     */
    protected function getParams() {
        return $_GET;
    }
    
    /**
     * Obtener datos POST (JSON o form-data)
     */
    protected function getPostData() {
        $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
        
        if (strpos($contentType, 'application/json') !== false) {
            $json = file_get_contents('php://input');
            return json_decode($json, true);
        }
        
        return $_POST;
    }
    
    /**
     * Ejecutar query segura
     */
    protected function query($sql, $params = []) {
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->execute($params);
            return $stmt;
        } catch (PDOException $e) {
            error_log("Query error: " . $e->getMessage());
            $this->error('Error en la consulta a la base de datos', 500);
        }
    }
    
    /**
     * Obtener todos los registros
     */
    protected function getAll($sql, $params = []) {
        $stmt = $this->query($sql, $params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    /**
     * Obtener un registro
     */
    protected function getOne($sql, $params = []) {
        $stmt = $this->query($sql, $params);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    
    /**
     * Sanitizar entrada
     */
    protected function sanitize($data) {
        if (is_array($data)) {
            return array_map([$this, 'sanitize'], $data);
        }
        return htmlspecialchars(trim($data), ENT_QUOTES, 'UTF-8');
    }
    
    /**
     * Validar campo requerido
     */
    protected function required($value, $fieldName) {
        if (empty($value) && $value !== '0') {
            $this->error("El campo '{$fieldName}' es requerido", 400);
        }
        return $value;
    }
    
    /**
     * Log de actividad
     */
    protected function log($action, $details = '') {
        try {
            $ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
            $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? 'unknown';
            
            $sql = "INSERT INTO activity_logs (action, table_name, ip_address, user_agent, old_values) 
                    VALUES (?, ?, ?, ?, ?)";
            
            $this->query($sql, [$action, $this->table, $ip, $userAgent, $details]);
        } catch (Exception $e) {
            // No detener la ejecución si falla el log
            error_log("Log error: " . $e->getMessage());
        }
    }
}
<?php
/**
 * ==========================================
 * CONEXIÓN CENTRAL A BASE DE DATOS
 * Portal de Transparencia - Universidad Andina del Cusco
 * Archivo: conexion.php (raíz del proyecto)
 * 
 * Este es el archivo de conexión principal
 * Compatible con todos los módulos del sistema
 * ==========================================
 */

// ============================================================================
// CONFIGURACIÓN DE BASE DE DATOS
// ============================================================================
define('DB_HOST', 'localhost');
define('DB_NAME', 'portal_transparencia');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');
define('DB_PORT', 3306);

// ============================================================================
// CONFIGURACIÓN DE ERRORES
// ============================================================================
define('DEBUG_MODE', true); // Cambiar a false en producción

if (DEBUG_MODE) {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
}

// ============================================================================
// TIMEZONE
// ============================================================================
date_default_timezone_set('America/Lima');

// ============================================================================
// CLASE DATABASE (Patrón Singleton)
// ============================================================================
class Database {
    private static $instance = null;
    private $conn;

    /**
     * Constructor privado (Singleton)
     */
    private function __construct() {
        try {
            $dsn = "mysql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
            
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES " . DB_CHARSET,
                PDO::ATTR_PERSISTENT => false
            ];
            
            $this->conn = new PDO($dsn, DB_USER, DB_PASS, $options);
            
        } catch (PDOException $e) {
            $this->handleConnectionError($e);
        }
    }

    /**
     * Manejar errores de conexión
     */
    private function handleConnectionError($e) {
        error_log("Error de conexión DB: " . $e->getMessage());
        
        if (DEBUG_MODE) {
            $error_msg = "❌ Error de conexión: " . $e->getMessage();
        } else {
            $error_msg = "❌ Error de conexión a la base de datos. Contacte al administrador.";
        }
        
        // Si es una petición AJAX, devolver JSON
        if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && 
            strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
            header('Content-Type: application/json; charset=utf-8');
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'error' => 'Error de conexión a la base de datos',
                'details' => DEBUG_MODE ? $e->getMessage() : null
            ], JSON_UNESCAPED_UNICODE);
        } else {
            die($error_msg);
        }
        exit;
    }

    /**
     * Obtener instancia única
     */
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Obtener conexión PDO
     */
    public function getConnection() {
        return $this->conn;
    }

    /**
     * Prevenir clonación
     */
    private function __clone() {}

    /**
     * Prevenir deserialización
     */
    public function __wakeup() {
        throw new Exception("No se puede deserializar un Singleton");
    }
}

// ============================================================================
// FUNCIONES HELPER GLOBALES
// ============================================================================

/**
 * Obtener conexión PDO desde cualquier parte del sistema
 * Esta es la función principal recomendada
 * 
 * @return PDO Conexión a la base de datos
 * 
 * Uso:
 *   $db = getDB();
 *   $stmt = $db->prepare("SELECT * FROM tabla");
 */
function getDB() {
    return Database::getInstance()->getConnection();
}

/**
 * Función alternativa para compatibilidad
 * Algunos módulos usan getConexion() en lugar de getDB()
 * 
 * @return PDO Conexión a la base de datos
 */
function getConexion() {
    return getDB();
}

/**
 * Función alternativa para compatibilidad
 * 
 * @return PDO Conexión a la base de datos
 */
function conectar() {
    return getDB();
}

// ============================================================================
// VARIABLES GLOBALES LEGACY (Compatibilidad)
// ============================================================================

/**
 * Variable global $conexion para módulos antiguos
 * Se mantiene para compatibilidad con código legacy
 */
$conexion = getDB();

/**
 * Variable global $db para nuevo código
 */
$db = getDB();

/**
 * Variable global $pdo para algunos módulos
 */
$pdo = getDB();

// ============================================================================
// FUNCIONES DE UTILIDAD PARA QUERIES
// ============================================================================

/**
 * Ejecutar query y obtener todos los resultados
 * 
 * @param string $sql Query SQL
 * @param array $params Parámetros preparados
 * @return array|false Array de resultados o false en error
 */
function db_query($sql, $params = []) {
    try {
        $db = getDB();
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        error_log("Error en db_query: " . $e->getMessage());
        if (DEBUG_MODE) {
            die("❌ Error en query: " . $e->getMessage() . "\nSQL: " . $sql);
        }
        return false;
    }
}

/**
 * Ejecutar INSERT y obtener ID generado
 * 
 * @param string $sql Query INSERT
 * @param array $params Parámetros preparados
 * @return int|false ID insertado o false en error
 */
function db_insert($sql, $params = []) {
    try {
        $db = getDB();
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $db->lastInsertId();
    } catch (PDOException $e) {
        error_log("Error en db_insert: " . $e->getMessage());
        if (DEBUG_MODE) {
            die("❌ Error en INSERT: " . $e->getMessage() . "\nSQL: " . $sql);
        }
        return false;
    }
}

/**
 * Ejecutar UPDATE/DELETE y obtener filas afectadas
 * 
 * @param string $sql Query UPDATE o DELETE
 * @param array $params Parámetros preparados
 * @return int|false Número de filas afectadas o false en error
 */
function db_execute($sql, $params = []) {
    try {
        $db = getDB();
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount();
    } catch (PDOException $e) {
        error_log("Error en db_execute: " . $e->getMessage());
        if (DEBUG_MODE) {
            die("❌ Error en ejecución: " . $e->getMessage() . "\nSQL: " . $sql);
        }
        return false;
    }
}

/**
 * Obtener un solo registro
 * 
 * @param string $sql Query SQL
 * @param array $params Parámetros preparados
 * @return array|false Array asociativo o false en error
 */
function db_fetch_one($sql, $params = []) {
    try {
        $db = getDB();
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetch();
    } catch (PDOException $e) {
        error_log("Error en db_fetch_one: " . $e->getMessage());
        if (DEBUG_MODE) {
            die("❌ Error en fetch: " . $e->getMessage() . "\nSQL: " . $sql);
        }
        return false;
    }
}

/**
 * Obtener un solo valor (primera columna del primer registro)
 * 
 * @param string $sql Query SQL
 * @param array $params Parámetros preparados
 * @return mixed|false Valor o false en error
 */
function db_fetch_value($sql, $params = []) {
    try {
        $db = getDB();
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchColumn();
    } catch (PDOException $e) {
        error_log("Error en db_fetch_value: " . $e->getMessage());
        if (DEBUG_MODE) {
            die("❌ Error en fetch value: " . $e->getMessage());
        }
        return false;
    }
}

/**
 * Verificar si existe al menos un registro
 * 
 * @param string $sql Query SQL
 * @param array $params Parámetros preparados
 * @return bool true si existe, false si no
 */
function db_exists($sql, $params = []) {
    try {
        $db = getDB();
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount() > 0;
    } catch (PDOException $e) {
        error_log("Error en db_exists: " . $e->getMessage());
        return false;
    }
}

/**
 * Contar registros
 * 
 * @param string $table Nombre de la tabla
 * @param string $where Condición WHERE (opcional)
 * @param array $params Parámetros preparados
 * @return int|false Cantidad de registros o false en error
 */
function db_count($table, $where = '', $params = []) {
    try {
        $sql = "SELECT COUNT(*) FROM `$table`";
        if ($where) {
            $sql .= " WHERE $where";
        }
        return (int)db_fetch_value($sql, $params);
    } catch (Exception $e) {
        error_log("Error en db_count: " . $e->getMessage());
        return false;
    }
}

/**
 * Verificar conexión a la base de datos
 * 
 * @return bool true si hay conexión, false si no
 */
function db_check_connection() {
    try {
        $db = getDB();
        $db->query("SELECT 1");
        return true;
    } catch (PDOException $e) {
        error_log("Error verificando conexión: " . $e->getMessage());
        return false;
    }
}

/**
 * Obtener información de la base de datos
 * 
 * @return array Información de la BD
 */
function db_info() {
    try {
        $db = getDB();
        $info = [
            'host' => DB_HOST,
            'database' => DB_NAME,
            'charset' => DB_CHARSET,
            'driver' => $db->getAttribute(PDO::ATTR_DRIVER_NAME),
            'server_version' => $db->getAttribute(PDO::ATTR_SERVER_VERSION),
            'connection_status' => $db->getAttribute(PDO::ATTR_CONNECTION_STATUS),
            'connected' => true
        ];
        return $info;
    } catch (PDOException $e) {
        return [
            'connected' => false,
            'error' => $e->getMessage()
        ];
    }
}

/**
 * Cerrar conexión (útil en scripts de larga duración)
 * 
 * @param PDO $pdo Conexión a cerrar
 */
function cerrarConexion(&$pdo) {
    $pdo = null;
}

// ============================================================================
// FUNCIONES PARA TRANSACCIONES
// ============================================================================

/**
 * Iniciar transacción
 * 
 * @return bool
 */
function db_begin_transaction() {
    try {
        return getDB()->beginTransaction();
    } catch (PDOException $e) {
        error_log("Error al iniciar transacción: " . $e->getMessage());
        return false;
    }
}

/**
 * Confirmar transacción
 * 
 * @return bool
 */
function db_commit() {
    try {
        return getDB()->commit();
    } catch (PDOException $e) {
        error_log("Error al confirmar transacción: " . $e->getMessage());
        return false;
    }
}

/**
 * Revertir transacción
 * 
 * @return bool
 */
function db_rollback() {
    try {
        return getDB()->rollBack();
    } catch (PDOException $e) {
        error_log("Error al revertir transacción: " . $e->getMessage());
        return false;
    }
}

// ============================================================================
// FUNCIONES DE ESCAPE Y SEGURIDAD
// ============================================================================

/**
 * Escapar valor para SQL (usar prepared statements es mejor)
 * 
 * @param mixed $value Valor a escapar
 * @return string Valor escapado
 */
function db_escape($value) {
    $db = getDB();
    return $db->quote($value);
}

/**
 * Sanitizar nombre de tabla/columna
 * 
 * @param string $name Nombre a sanitizar
 * @return string Nombre sanitizado
 */
function db_sanitize_identifier($name) {
    // Solo permitir caracteres alfanuméricos y guión bajo
    return preg_replace('/[^a-zA-Z0-9_]/', '', $name);
}

// ============================================================================
// VERIFICACIÓN AUTOMÁTICA DE CONEXIÓN (Solo en modo debug)
// ============================================================================
if (DEBUG_MODE && php_sapi_name() !== 'cli') {
    // Verificar conexión al cargar el archivo (silencioso si funciona)
    if (!db_check_connection()) {
        error_log("❌ No se pudo establecer conexión con la base de datos al cargar conexion.php");
        if (DEBUG_MODE) {
            // No mostramos error aquí para no romper includes
            // El error se mostrará cuando se intente usar getDB()
        }
    }
}

// ============================================================================
// LOG DE CARGA (Solo en modo debug extremo)
// ============================================================================
if (defined('DEBUG_VERBOSE') && DEBUG_VERBOSE) {
    error_log("✅ Archivo conexion.php cargado correctamente");
    error_log("   - Base de datos: " . DB_NAME);
    error_log("   - Host: " . DB_HOST);
    error_log("   - Charset: " . DB_CHARSET);
}

// ============================================================================
// FIN DEL ARCHIVO
// ============================================================================
?>
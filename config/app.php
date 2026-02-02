<?php
/**
 * CONFIGURACIÓN MAESTRA DEL SISTEMA
 * ===================================
 * ⚠️ ESTE ES EL ÚNICO ARCHIVO QUE DEBES MODIFICAR
 * Todos los módulos leen esta configuración automáticamente
 */

// ============================================================================
// INFORMACIÓN DE LA APLICACIÓN
// ============================================================================
define('APP_NAME', 'Portal de Transparencia UAC');
define('APP_VERSION', '2.0.0');
define('APP_URL', 'http://localhost'); // Cambiar en producción
define('ADMIN_URL', APP_URL . '/admin');

// ============================================================================
// CONFIGURACIÓN DE MÓDULOS
// ============================================================================
// Array maestro de todos los módulos del sistema
// Para agregar un nuevo módulo, solo añádelo aquí
$MODULES_CONFIG = [
    [
        'id' => 'doc_normativos',
        'name' => 'Doc. Normativos',
        'icon' => '📘',
        'description' => 'Consulta normas y documentos oficiales institucionales',
        'folder' => '1_doc_normativos',
        'link_text' => 'Ver Documentos',
        'order' => 1,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'documentos_normativos',
    ],
    [
        'id' => 'actas',
        'name' => 'Actas',
        'icon' => '📋',
        'description' => 'Consulta las actas de sesiones y reuniones institucionales',
        'folder' => '2_actas_php',
        'link_text' => 'Ver Actas',
        'order' => 2,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'actas',
    ],
    [
        'id' => 'contabilidad',
        'name' => 'Estados Financieros',
        'icon' => '💰',
        'description' => 'Información financiera y estados contables',
        'folder' => '3_contabilidad_php',
        'link_text' => 'Ver Estados Financieros',
        'order' => 3,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'contabilidad',
    ],
    [
        'id' => 'becas',
        'name' => 'Becas',
        'icon' => '🎓',
        'description' => 'Programas de becas y beneficios estudiantiles',
        'folder' => '4_becas_php',
        'link_text' => 'Ver Becas',
        'order' => 4,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'becas',
    ],
    [
        'id' => 'inversiones',
        'name' => 'Inversiones Reinversiones',
        'icon' => '📊',
        'description' => 'Proyectos de inversión y ejecución presupuestal',
        'folder' => '5_inversiones',
        'link_text' => 'Ver Inversiones',
        'order' => 5,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'inversiones',
    ],
    [
        'id' => 'investigacion',
        'name' => 'Investigación',
        'icon' => '🔬',
        'description' => 'Proyectos y publicaciones de investigación',
        'folder' => '6_investigacion',
        'link_text' => 'Ver Investigación',
        'order' => 6,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'investigacion',
    ],
    [
        'id' => 'alumnos',
        'name' => 'Alumnos',
        'icon' => '👨🏼‍🎓',
        'description' => 'Información sobre estudiantes y matrícula',
        'folder' => '7_alumnos',
        'link_text' => 'Ver Alumnos',
        'order' => 7,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'alumnos',
    ],
    [
        'id' => 'docentes',
        'name' => 'Docentes',
        'icon' => '👨🏼‍🏫',
        'description' => 'Información del personal docente',
        'folder' => '8_docentes',
        'link_text' => 'Ver Docentes',
        'order' => 8,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'docentes',
    ],
    [
        'id' => 'remuneraciones',
        'name' => 'Remuneraciones',
        'icon' => '💵',
        'description' => 'Planilla de pagos y remuneraciones',
        'folder' => '9_remuneraciones',
        'link_text' => 'Ver Remuneraciones',
        'order' => 9,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'remuneraciones',
    ],
    [
        'id' => 'pagos',
        'name' => 'Pagos',
        'icon' => '💳',
        'description' => 'Información sobre pagos, tasas y conceptos',
        'folder' => '9_pagos',
        'link_text' => 'Ver Pagos',
        'order' => 10,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'pagos',
    ],
    [
        'id' => 'reglamentos',
        'name' => 'Reglamentos',
        'icon' => '📜',
        'description' => 'Reglamentos y normativas institucionales',
        'folder' => '10_reglamentos',
        'link_text' => 'Ver Reglamentos',
        'order' => 11,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'reglamentos',
    ],
    [
        'id' => 'otros_documentos',
        'name' => 'Otros Documentos',
        'icon' => '📂',
        'description' => 'Documentos institucionales diversos',
        'folder' => '11_otros_documentos',
        'link_text' => 'Ver Documentos',
        'order' => 12,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'otros_documentos',
    ],
    [
        'id' => 'decalogos',
        'name' => 'Decálogos',
        'icon' => '📋',
        'description' => 'Decálogos institucionales',
        'folder' => '13_decalogos',
        'link_text' => 'Ver Decálogos',
        'order' => 13,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'decalogos',
    ],
    [
        'id' => 'proyecto_desarrollo',
        'name' => 'Proyecto General de Desarrollo',
        'icon' => '📊',
        'description' => 'Lineamientos y estrategias de desarrollo',
        'folder' => '14_proyecto_general_desarrollo',
        'link_text' => 'Ver Proyecto',
        'order' => 14,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'proyecto_desarrollo',
    ],
    [
        'id' => 'plan_estudio',
        'name' => 'Plan de Estudios',
        'icon' => '🎓',
        'description' => 'Mallas curriculares y planes de estudio',
        'folder' => '15_plan_estudio',
        'link_text' => 'Ver Planes',
        'order' => 15,
        'active' => true,
        'has_crud' => true,
        'db_table' => 'plan_estudio',
    ],
];

// Hacer disponible globalmente
define('MODULES_CONFIG', $MODULES_CONFIG);

// ============================================================================
// FUNCIONES HELPER PARA MÓDULOS
// ============================================================================

/**
 * Obtener todos los módulos activos
 */
function getActiveModules() {
    $modules = MODULES_CONFIG;
    return array_filter($modules, function($m) {
        return $m['active'] === true;
    });
}

/**
 * Obtener módulo por ID
 */
function getModuleById($id) {
    $modules = MODULES_CONFIG;
    foreach ($modules as $module) {
        if ($module['id'] === $id) {
            return $module;
        }
    }
    return null;
}

/**
 * Obtener módulo por carpeta
 */
function getModuleByFolder($folder) {
    $modules = MODULES_CONFIG;
    foreach ($modules as $module) {
        if ($module['folder'] === $folder) {
            return $module;
        }
    }
    return null;
}

/**
 * Obtener URL de un módulo
 */
function getModuleUrl($moduleId) {
    $module = getModuleById($moduleId);
    if ($module) {
        return APP_URL . '/' . $module['folder'] . '/index.html';
    }
    return '#';
}

/**
 * Generar tarjetas para el portal principal
 */
function generatePortalCards() {
    $modules = getActiveModules();
    
    // Ordenar por order
    usort($modules, function($a, $b) {
        return $a['order'] - $b['order'];
    });
    
    return $modules;
}

// ============================================================================
// CONFIGURACIÓN DE RUTAS
// ============================================================================
define('ROUTES', [
    'home' => '/',
    'admin' => '/admin',
    'admin_login' => '/admin/login.php',
    'admin_logout' => '/admin/logout.php',
    'api' => '/api',
    'assets' => '/assets',
]);

// ============================================================================
// CONFIGURACIÓN DE ARCHIVOS COMUNES
// ============================================================================
define('COMMON_FILES', [
    'header' => '/header.html',
    'footer' => '/footer.html',
    'css_base' => '/assets/css/base.css',
    'css_header' => '/assets/css/header.css',
    'css_footer' => '/assets/css/footer.css',
    'css_responsive' => '/assets/css/responsive.css',
]);

// ============================================================================
// CONFIGURACIÓN DE SEGURIDAD
// ============================================================================
define('SECURITY', [
    'session_lifetime' => 7200, // 2 horas
    'session_name' => 'portal_admin_session',
    'password_min_length' => 8,
    'max_login_attempts' => 5,
    'lockout_time' => 900, // 15 minutos
]);

// ============================================================================
// TIMEZONE Y LOCALE
// ============================================================================
define('TIMEZONE', 'America/Lima');
define('LOCALE', 'es_PE');
date_default_timezone_set(TIMEZONE);

// ============================================================================
// MODO DEBUG
// ============================================================================
define('DEBUG', true); // Cambiar a false en producción

if (DEBUG) {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
}

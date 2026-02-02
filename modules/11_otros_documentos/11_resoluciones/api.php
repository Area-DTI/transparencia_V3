<?php
/**
 * ============================================================================
 * API - RESOLUCIONES UAC
 * Obtiene resoluciones organizadas por grupo y subgrupo desde MySQL
 * ============================================================================
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');
header('Cache-Control: no-cache, must-revalidate');
header('Expires: 0');

// Incluir archivo de conexión
require_once 'conexion.php';

try {
    // Obtener conexión
    $pdo = getConexion();
    
    if (!$pdo) {
        throw new Exception('No se pudo conectar a la base de datos');
    }
    
    // =========================================================================
    // CONSULTAR RESOLUCIONES
    // =========================================================================
    
    $sql = "SELECT 
                id,
                grupo,
                subgrupo,
                descripcion,
                enlace_pdf,
                numero_resolucion,
                es_subresolucion
            FROM uac_resoluciones 
            ORDER BY 
                CASE grupo
                    WHEN 'RESOLUCIONES' THEN 1
                    WHEN 'SOBRE ADMISIÓN' THEN 2
                    WHEN 'SOBRE PENSIONES' THEN 3
                    WHEN 'SOBRE MODALIDADES' THEN 4
                    ELSE 5
                END,
                subgrupo ASC,
                id ASC";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    $registros = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Organizar datos por grupo y subgrupo
    $resolucionesPorGrupo = [];
    $resolucionesById = [];
    
    // Indexar todas las resoluciones por ID
    foreach ($registros as $reg) {
        $resolucionesById[$reg['id']] = [
            'id' => $reg['id'],
            'descripcion' => trim($reg['descripcion']),
            'numero_resolucion' => trim($reg['numero_resolucion']),
            'enlace_pdf' => trim($reg['enlace_pdf']),
            'es_subresolucion' => (bool)$reg['es_subresolucion'],
            'subresoluciones' => []
        ];
    }
    
    // Organizar por grupo/subgrupo con jerarquía
    foreach ($registros as $reg) {
        $grupo = trim($reg['grupo']);
        $subgrupo = $reg['subgrupo'] ? trim($reg['subgrupo']) : null;
        
        // Inicializar grupo si no existe
        if (!isset($resolucionesPorGrupo[$grupo])) {
            $resolucionesPorGrupo[$grupo] = [
                'nombre' => $grupo,
                'subgrupos' => []
            ];
        }
        
        // Si tiene subgrupo
        if ($subgrupo) {
            // Inicializar subgrupo si no existe
            if (!isset($resolucionesPorGrupo[$grupo]['subgrupos'][$subgrupo])) {
                $resolucionesPorGrupo[$grupo]['subgrupos'][$subgrupo] = [
                    'nombre' => $subgrupo,
                    'resoluciones' => []
                ];
            }
            
            // Si NO es sub-resolución, agregarlo directamente
            if (!$reg['es_subresolucion']) {
                $resolucionesPorGrupo[$grupo]['subgrupos'][$subgrupo]['resoluciones'][] = $resolucionesById[$reg['id']];
            }
        } else {
            // Sin subgrupo - agregar directamente al grupo
            // Inicializar array de resoluciones si no existe
            if (!isset($resolucionesPorGrupo[$grupo]['resoluciones'])) {
                $resolucionesPorGrupo[$grupo]['resoluciones'] = [];
            }
            
            // Si NO es sub-resolución, agregarlo directamente
            if (!$reg['es_subresolucion']) {
                $resolucionesPorGrupo[$grupo]['resoluciones'][] = $resolucionesById[$reg['id']];
            }
        }
    }
    
    // Segunda pasada: agregar sub-resoluciones
    foreach ($registros as $reg) {
        if ($reg['es_subresolucion']) {
            $grupo = trim($reg['grupo']);
            $subgrupo = $reg['subgrupo'] ? trim($reg['subgrupo']) : null;
            
            // Buscar la resolución padre (la anterior que NO es subresolucion)
            if ($subgrupo) {
                // Con subgrupo
                if (isset($resolucionesPorGrupo[$grupo]['subgrupos'][$subgrupo]['resoluciones'])) {
                    $resoluciones = &$resolucionesPorGrupo[$grupo]['subgrupos'][$subgrupo]['resoluciones'];
                    if (count($resoluciones) > 0) {
                        // Agregar a la última resolución
                        $ultimaKey = count($resoluciones) - 1;
                        $resoluciones[$ultimaKey]['subresoluciones'][] = $resolucionesById[$reg['id']];
                    }
                }
            } else {
                // Sin subgrupo
                if (isset($resolucionesPorGrupo[$grupo]['resoluciones'])) {
                    $resoluciones = &$resolucionesPorGrupo[$grupo]['resoluciones'];
                    if (count($resoluciones) > 0) {
                        // Agregar a la última resolución
                        $ultimaKey = count($resoluciones) - 1;
                        $resoluciones[$ultimaKey]['subresoluciones'][] = $resolucionesById[$reg['id']];
                    }
                }
            }
        }
    }
    
    // Convertir a array indexado
    $grupos = [];
    foreach ($resolucionesPorGrupo as $grupo) {
        $grupoData = [
            'nombre' => $grupo['nombre'],
            'resoluciones' => $grupo['resoluciones'] ?? []
        ];
        
        // Convertir subgrupos a array indexado
        if (!empty($grupo['subgrupos'])) {
            $grupoData['subgrupos'] = array_values($grupo['subgrupos']);
        }
        
        $grupos[] = $grupoData;
    }
    
    // =========================================================================
    // RESPUESTA FINAL
    // =========================================================================
    
    $response = [
        'success' => true,
        'data' => [
            'grupos' => $grupos
        ],
        'timestamp' => date('Y-m-d H:i:s'),
        'source' => 'mysql',
        'total_registros' => count($registros)
    ];
    
    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error de base de datos',
        'message' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
    
} finally {
    if (isset($pdo)) {
        cerrarConexion($pdo);
    }
}
?>
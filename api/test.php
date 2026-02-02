<?php
/**
 * TESTER DE APIs PÚBLICAS - transparencia_V3
 * Verifica que cada endpoint responda con HTTP 200 y devuelva JSON válido
 * Fecha: 2025
 */

header('Content-Type: text/html; charset=utf-8');
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<!DOCTYPE html>\n";
echo "<html lang='es'>\n<head>\n";
echo "<meta charset='UTF-8'>\n";
echo "<title>Test Todas las APIs Públicas</title>\n";
echo "<style>
    body { font-family: Consolas, monospace; background:#0d1117; color:#c9d1d9; padding:20px; }
    h1 { color:#58a6ff; }
    table { border-collapse: collapse; width:100%; max-width:1100px; }
    th, td { border:1px solid #30363d; padding:10px; text-align:left; }
    th { background:#161b22; }
    .ok    { background:#1f6e3a; color:#aff5b4; }
    .warn  { background:#9e6a03; color:#ffe599; }
    .error { background:#5d1f1f; color:#ffcccc; }
    .url   { color:#79c0ff; }
    pre    { margin:0; white-space:pre-wrap; }
</style>\n";
echo "</head><body>\n";

echo "<h1>Test de APIs públicas (".date('Y-m-d H:i:s').")</h1>\n";
echo "<p>Ruta base detectada: <code>" . dirname(__DIR__) . "/api/</code></p>\n";
echo "<hr>\n";

$apis = [
    'actas.php',
    'alumnos.php',
    'becas.php',
    'contabilidad.php',
    'docentes.php',
    'doc_normativos.php',
    'inversiones.php',
    'investigacion.php',
    'pagos.php',
    'plan_estudios.php',
    'proyecto_desarrollo.php',
    'reglamentos.php',
    'remuneraciones.php',
    
    // endpoints especiales / con parámetros de prueba
    'get_cards.php'           => '?tipo=principal',   // ejemplo
    'test.php'                => '',                  // si existe
];

// Opcional: si alguna API necesita parámetros mínimos para no dar error
$apis_con_parametros = [
    'get_cards.php' => '?tipo=principal&limit=3',
    // agrega aquí otras que fallen sin parámetros
];

$base_url = 'http://' . $_SERVER['HTTP_HOST'] . str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'])) . '/';
$base_dir = __DIR__ . '/';

echo "<table>
    <tr>
        <th>Endpoint</th>
        <th>URL completa</th>
        <th>Estado HTTP</th>
        <th>Respuesta</th>
        <th>Observación</th>
    </tr>\n";

foreach ($apis as $file => $extra) {
    if (is_numeric($file)) {
        $file = $extra;
        $extra = '';
    }

    $url = $base_url . $file . $extra;
    $full_path = $base_dir . $file;

    echo "<tr>\n";
    echo "<td>$file</td>\n";
    echo "<td><a href='$url' target='_blank' class='url'>$url</a></td>\n";

    // Verificar si el archivo existe
    if (!file_exists($full_path)) {
        echo "<td class='error'>404</td>\n";
        echo "<td colspan='2' class='error'>Archivo físico no existe</td>\n";
        echo "</tr>\n";
        continue;
    }

    // Hacer la petición interna (mejor que file_get_contents por https y timeout)
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_HEADER, false);
    // Si tu servidor local tiene problemas con SSL en desarrollo
    // curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error_curl = curl_error($ch);
    curl_close($ch);

    $class = ($http_code >= 200 && $http_code < 300) ? 'ok' : 'error';

    echo "<td class='$class'>$http_code</td>\n";

    if ($error_curl) {
        echo "<td colspan='2' class='error'>cURL error: $error_curl</td>\n";
    } else {
        // Intentar parsear como JSON
        $json = json_decode($response, true);
        if (json_last_error() === JSON_ERROR_NONE) {
            $status_text = isset($json['status']) ? $json['status'] : '—';
            $count = isset($json['data']) && is_array($json['data']) ? count($json['data']) : '—';

            echo "<td class='ok'>JSON válido • status: $status_text • items: $count</td>\n";
            echo "<td>";
            if ($http_code !== 200) {
                echo "<strong>Respuesta no 200 aunque sea JSON</strong><br>";
            }
            echo "<pre>" . htmlspecialchars(substr($response, 0, 300)) . (strlen($response)>300?'...':'') . "</pre>";
            echo "</td>\n";
        } else {
            // No es JSON válido
            $class = 'warn';
            echo "<td class='$class'>No es JSON válido (".json_last_error_msg().")</td>\n";
            echo "<td><pre>" . htmlspecialchars(substr($response, 0, 400)) . (strlen($response)>400?'...':'') . "</pre></td>\n";
        }
    }

    echo "</tr>\n";
}

echo "</table>\n";
echo "<hr>\n";
echo "<p>Si muchas APIs devuelven 500 → revisa:</p>
<ul>
    <li>conexion.php / config/database.php</li>
    <li>permisos de base de datos</li>
    <li>errores fatales en PHP (ver log de Apache)</li>
    <li>BaseAPI.php está siendo incluido correctamente</li>
</ul>\n";

echo "</body></html>";
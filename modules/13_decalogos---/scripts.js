// =============================================================================
// DECÁLOGOS UNIVERSITARIOS - CONEXIÓN A MYSQL CON DATATABLES
// =============================================================================

let decalogosData = [];
let dataTable = null;

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('🚀 Portal de Decálogos iniciado - Versión MySQL con DataTables');
    console.log('📡 URL API:', API_URL);
    
    // Configuración de idioma para DataTables
    $.extend($.fn.dataTable.defaults, {
        language: {
            url: '//cdn.datatables.net/plug-ins/1.13.8/i18n/es-ES.json'
        }
    });
    
    cargarDecalogos();
});

// =============================================================================
// CARGAR DECÁLOGOS DESDE API.PHP (MySQL)
// =============================================================================

function cargarDecalogos() {
    console.log('📥 Cargando decálogos desde MySQL...');
    mostrarLoading(true);
    
    $.ajax({
        url: API_URL,
        method: 'GET',
        dataType: 'json',
        timeout: 30000,
        cache: false,
        success: function(response) {
            console.log('✅ Respuesta recibida:', response);
            
            try {
                if (!response.success || !response.data) {
                    throw new Error('Formato de respuesta incorrecto');
                }
                
                decalogosData = response.data;
                console.log(`📊 ${response.total} decálogos cargados desde MySQL`);
                
                mostrarDecalogos();
                mostrarLoading(false);
                mostrarToast(`✅ ${response.total} decálogos cargados exitosamente`, 'success');
                
            } catch (error) {
                console.error('❌ Error al procesar datos:', error);
                mostrarLoading(false);
                mostrarError('Error al procesar los datos recibidos: ' + error.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('❌ Error en la petición AJAX:');
            console.error('  Status:', status);
            console.error('  Error:', error);
            console.error('  Response:', xhr.responseText);
            
            mostrarLoading(false);
            
            let mensaje = 'Error al cargar datos desde el servidor';
            
            if (status === 'timeout') {
                mensaje = 'La conexión tardó demasiado. Intenta nuevamente.';
            } else if (status === 'error') {
                if (xhr.status === 404) {
                    mensaje = 'No se encontró el archivo api.php. Verifica la ruta.';
                } else if (xhr.status === 500) {
                    mensaje = 'Error en el servidor. Verifica la configuración de la base de datos.';
                } else if (xhr.status === 0) {
                    mensaje = 'No se pudo conectar con el servidor.';
                } else {
                    mensaje = `Error del servidor (${xhr.status}): ${xhr.statusText}`;
                }
            }
            
            // Intentar parsear mensaje de error del servidor
            try {
                const errorResponse = JSON.parse(xhr.responseText);
                if (errorResponse.error) {
                    mensaje += '<br><small>' + errorResponse.error + '</small>';
                }
            } catch (e) {
                // No hay JSON de error
            }
            
            mostrarError(mensaje);
        }
    });
}

// =============================================================================
// MOSTRAR DECÁLOGOS CON DATATABLES
// =============================================================================

function mostrarDecalogos() {
    const $container = $('#decalogosContainer');
    
    if (decalogosData.length === 0) {
        $container.html(`
            <div class="mensaje-vacio">
                <i class="fas fa-inbox"></i>
                <h3>No se encontraron decálogos</h3>
                <p>No hay decálogos disponibles en este momento</p>
            </div>
        `);
        return;
    }
    
    // Destruir DataTable existente si existe
    if (dataTable && $.fn.DataTable.isDataTable('#tablaDecalogos')) {
        dataTable.destroy();
    }
    
    // Crear la tabla HTML
    let html = `
        <div class="tabla-container">
            <table id="tablaDecalogos" class="tabla-decalogos" style="width: 100%;">
                <thead>
                    <tr>
                        <th><i class="fas fa-list-ol"></i> #</th>
                        <th><i class="fas fa-book"></i> Decálogo</th>
                        <th class="text-center"><i class="fas fa-download"></i> Documento</th>
                    </tr>
                </thead>
                <tbody>
                    ${decalogosData.map((decalogo, idx) => `
                        <tr>
                            <td class="text-center">
                                <span class="numero-badge">${idx + 1}</span>
                            </td>
                            <td>
                                <div class="decalogo-titulo">
                                    ${escapeHtml(decalogo.titulo)}
                                </div>
                            </td>
                            <td class="text-center">
                                ${decalogo.enlace_pdf ? `
                                    <a href="${escapeHtml(decalogo.enlace_pdf)}" 
                                       target="_blank" 
                                       class="btn-pdf" 
                                       rel="noopener noreferrer"
                                       title="Ver decálogo PDF">
                                        <i class="fas fa-file-pdf"></i> Ver PDF
                                    </a>
                                ` : '<span class="sin-enlace">Sin enlace</span>'}
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `;
    
    $container.html(html);
    
    // Inicializar DataTable después de insertar HTML
    setTimeout(() => {
        inicializarDataTable();
    }, 100);
    
    console.log('✅ Decálogos renderizados con DataTables');
}

// =============================================================================
// INICIALIZAR DATATABLE
// =============================================================================

function inicializarDataTable() {
    console.log('🔧 Inicializando DataTable...');
    
    try {
        dataTable = $('#tablaDecalogos').DataTable({
            // Paginación (deshabilitada por pocos registros)
            paging: false,
            
            // Búsqueda
            searching: true,
            
            // Ordenamiento
            ordering: true,
            order: [[0, 'asc']], // Ordenar por número
            
            // Información
            info: false, // Ocultar "Mostrando X de Y"
            
            // Otros
            autoWidth: false,
            responsive: true,
            
            // Idioma
            language: {
                search: "Buscar:",
                emptyTable: "No hay decálogos disponibles",
                zeroRecords: "No se encontraron decálogos que coincidan con la búsqueda"
            },
            
            // Configuración de columnas
            columnDefs: [
                { 
                    width: "10%", 
                    targets: 0,
                    className: "text-center",
                    orderable: true
                },
                { 
                    width: "60%", 
                    targets: 1,
                    orderable: true
                },
                { 
                    width: "30%", 
                    targets: 2, 
                    className: "text-center",
                    orderable: false
                }
            ],
            
            // DOM personalizado (solo buscador y tabla)
            dom: '<"datatable-search"f>rt'
        });
        
        console.log('✅ DataTable inicializado correctamente');
        
    } catch (e) {
        console.error('❌ Error al inicializar DataTable:', e);
    }
}

// =============================================================================
// UTILIDADES
// =============================================================================

function mostrarLoading(show) {
    if (show) {
        $('#loadingOverlay').fadeIn(300);
    } else {
        $('#loadingOverlay').fadeOut(300);
    }
}

function mostrarToast(mensaje, tipo = 'info') {
    const $toast = $('#toast');
    const icons = {
        success: 'fa-check-circle',
        error: 'fa-exclamation-circle',
        info: 'fa-info-circle'
    };
    
    $toast.html(`<i class="fas ${icons[tipo]}"></i> ${mensaje}`)
          .removeClass()
          .addClass(`toast ${tipo}`)
          .fadeIn(300);
    
    setTimeout(() => $toast.fadeOut(300), 4000);
}

function mostrarError(mensaje) {
    $('#decalogosContainer').html(`
        <div class="mensaje-vacio">
            <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i>
            <h3 style="color: #dc3545;">Error al cargar decálogos</h3>
            <p>${mensaje}</p>
            <button class="btn-reintentar" onclick="cargarDecalogos()">
                <i class="fas fa-sync-alt"></i> Reintentar
            </button>
        </div>
    `);
    mostrarToast('❌ ' + mensaje, 'error');
}

function escapeHtml(text) {
    if (!text) return '';
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.toString().replace(/[&<>"']/g, m => map[m]);
}

// =============================================================================
// DEBUG Y UTILIDADES PARA CONSOLA
// =============================================================================

window.decalogosDebug = {
    datos: () => decalogosData,
    recargar: () => cargarDecalogos(),
    tabla: () => dataTable,
    total: () => decalogosData.length
};

console.log('💡 Utilidades de debug disponibles:');
console.log('   decalogosDebug.datos() - Ver todos los datos');
console.log('   decalogosDebug.recargar() - Recargar datos');
console.log('   decalogosDebug.tabla() - Ver instancia DataTable');
console.log('   decalogosDebug.total() - Total de decálogos');
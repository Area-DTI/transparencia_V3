// =============================================================================
// ESTADOS FINANCIEROS (CONTABILIDAD)
// Versión: Google Apps Script + JS API (migrado desde PHP)
// =============================================================================

let datosCompletos = null;
let tablasInicializadas = {};
let intentosRecarga = 0;
const MAX_INTENTOS = 3;

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 MÓDULO ESTADOS FINANCIEROS INICIADO');
    console.log('📡 Conectado a: Google Apps Script via JS API');
    console.log('═══════════════════════════════════════════════════════');
    
    // Verificar que database.js esté cargado
    if (typeof getDB === 'undefined') {
        console.error('❌ ERROR: database.js no cargado');
        mostrarError('Configuración incorrecta: database.js no está cargado');
        return;
    }
    
    // Verificar que la API JS esté cargada
    if (typeof getContabilidadData === 'undefined') {
        console.error('❌ ERROR: contabilidad.js (API) no cargada');
        mostrarError('Configuración incorrecta: API de contabilidad no está cargada');
        return;
    }
    
    if (typeof jQuery === 'undefined') {
        console.error('❌ ERROR: jQuery no cargado');
        mostrarError('Error: jQuery no se cargó');
        return;
    }
    
    if (typeof $.fn.DataTable === 'undefined') {
        console.error('❌ ERROR: DataTables no cargado');
        mostrarError('Error: DataTables no se cargó');
        return;
    }
    
    console.log('✅ jQuery:', jQuery.fn.jquery);
    console.log('✅ DataTables:', $.fn.DataTable.version);
    console.log('✅ Database.js: OK');
    console.log('✅ API Contabilidad JS: OK');
    
    configurarDataTablesEspanol();
    cargarDatos();
});

// =============================================================================
// CONFIGURAR DATATABLES EN ESPAÑOL
// =============================================================================

function configurarDataTablesEspanol() {
    $.extend(true, $.fn.dataTable.defaults, {
        language: {
            "decimal": "",
            "emptyTable": "No hay estados financieros disponibles",
            "info": "Mostrando _START_ a _END_ de _TOTAL_ documentos",
            "infoEmpty": "Mostrando 0 a 0 de 0 documentos",
            "infoFiltered": "(filtrado de _MAX_ documentos totales)",
            "lengthMenu": "Mostrar _MENU_ documentos",
            "loadingRecords": "Cargando...",
            "processing": "Procesando...",
            "search": "Buscar:",
            "zeroRecords": "No se encontraron documentos",
            "paginate": {
                "first": "Primero",
                "last": "Último",
                "next": "Siguiente",
                "previous": "Anterior"
            }
        }
    });
}

// =============================================================================
// CARGAR DATOS (ACTUALIZADO PARA API JS)
// =============================================================================

async function cargarDatos(forzarActualizacion = false) {
    console.log('───────────────────────────────────────────────────────');
    console.log('📥 CARGANDO ESTADOS FINANCIEROS DESDE GOOGLE APPS SCRIPT');
    console.log('───────────────────────────────────────────────────────');
    console.log('🔄 Forzar actualización:', forzarActualizacion);
    console.log('🔢 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
    
    mostrarLoading(true);
    
    try {
        console.log('📤 Llamando a getContabilidadData()...');
        
        // Llamar a la API JS directamente
        const response = await getContabilidadData();
        
        console.log('───────────────────────────────────────────────────────');
        console.log('✅ RESPUESTA RECIBIDA DE APPS SCRIPT');
        console.log('───────────────────────────────────────────────────────');
        console.log('📦 Respuesta completa:', response);
        
        // Validar respuesta
        if (!response) {
            throw new Error('Respuesta vacía del servidor');
        }
        
        if (!response.success) {
            throw new Error(response.message || response.error || 'Error del servidor');
        }
        
        if (!response.data) {
            throw new Error('Respuesta sin datos');
        }
        
        const documentos = response.data;
        
        if (documentos.length === 0) {
            console.warn('⚠️ No hay estados financieros en Google Sheets');
            mostrarLoading(false);
            $('#tabsContent').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-folder-open fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                    <p>No hay estados financieros disponibles en Google Sheets</p>
                    <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-top: 15px;">
                        <i class="fas fa-sync-alt"></i> Actualizar desde Google Sheets
                    </button>
                </div>
            `);
            return;
        }
        
        datosCompletos = documentos;
        intentosRecarga = 0; // Resetear intentos
        
        console.log('✅ Estados financieros cargados:', datosCompletos.length);
        console.log('📊 Fuente:', response.source || 'API JS');
        console.log('📊 Timestamp:', response.timestamp);
        
        renderizarTabs(datosCompletos);
        
        mostrarLoading(false);
        mostrarToast(`✅ ${datosCompletos.length} estados financieros cargados desde Google Sheets`, 'success');
        
        console.log('───────────────────────────────────────────────────────');
        console.log('✅ CARGA COMPLETADA');
        console.log('───────────────────────────────────────────────────────');
        
    } catch (error) {
        console.error('───────────────────────────────────────────────────────');
        console.error('❌ ERROR AL CARGAR ESTADOS FINANCIEROS');
        console.error('───────────────────────────────────────────────────────');
        console.error('📊 Error:', error);
        console.error('📊 Mensaje:', error.message);
        console.error('📊 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
        
        mostrarLoading(false);
        
        let mensaje = 'Error al cargar estados financieros desde Google Sheets';
        let detalles = error.message || 'Error desconocido';
        
        // Reintentar automáticamente si no se alcanzó el límite
        if (intentosRecarga < MAX_INTENTOS) {
            intentosRecarga++;
            console.log('🔄 Reintentando automáticamente en 2 segundos...');
            mostrarToast(`⚠️ Reintentando... (${intentosRecarga}/${MAX_INTENTOS})`, 'warning');
            setTimeout(() => cargarDatos(forzarActualizacion), 2000);
            return;
        }
        
        // Si se agotaron los intentos, mostrar error
        console.error('❌ Se agotaron los intentos de recarga');
        intentosRecarga = 0; // Resetear para futuros intentos manuales
        
        $('#tabsContent').html(`
            <div class="mensaje-error">
                <div class="error-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3>${mensaje}</h3>
                <div class="error-details">
                    <strong>Detalles:</strong><br>
                    ${detalles}
                </div>
                <div class="error-actions">
                    <button class="btn-reintentar" onclick="cargarDatos(false)">
                        <i class="fas fa-sync-alt"></i> Reintentar
                    </button>
                    <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-left: 10px;">
                        <i class="fas fa-cloud-download-alt"></i> Forzar actualización
                    </button>
                </div>
            </div>
        `);
        
        mostrarToast('❌ ' + mensaje, 'error');
    }
}

// =============================================================================
// RENDERIZAR TABS POR AÑO
// =============================================================================

function renderizarTabs(documentos) {
    console.log('📊 Renderizando tabs con', documentos.length, 'documentos');
    
    // Agrupar por año
    const documentosPorAnio = {};
    
    documentos.forEach(doc => {
        const anio = doc.Año || doc.anio || 'Sin año';
        if (!documentosPorAnio[anio]) {
            documentosPorAnio[anio] = [];
        }
        documentosPorAnio[anio].push(doc);
    });
    
    console.log('📊 Años encontrados:', Object.keys(documentosPorAnio));
    
    // Ordenar años de mayor a menor
    const aniosOrdenados = Object.keys(documentosPorAnio).sort((a, b) => {
        const numA = parseInt(a) || 0;
        const numB = parseInt(b) || 0;
        return numB - numA; // Descendente
    });
    
    console.log('📊 Años ordenados:', aniosOrdenados);
    
    // Limpiar contenedores
    const $tabsNav = $('#tabsNav');
    const $tabsContent = $('#tabsContent');
    
    $tabsNav.empty();
    $tabsContent.empty();
    
    // Resetear tablas inicializadas
    tablasInicializadas = {};
    
    // Crear tabs
    aniosOrdenados.forEach((anio, index) => {
        const isActive = index === 0;
        const tabId = `tab-${anio.replace(/\s+/g, '-')}`;
        const tableId = `table-${anio.replace(/\s+/g, '-')}`;
        
        // Tab navigation
        const $navItem = $(`
            <button 
                class="tab-nav-item ${isActive ? 'active' : ''}" 
                data-tab="${tabId}"
                role="tab"
                aria-selected="${isActive}"
                aria-controls="${tabId}">
                <i class="fas fa-calendar-alt"></i>
                ${anio}
                <span class="tab-count">${documentosPorAnio[anio].length}</span>
            </button>
        `);
        
        $navItem.on('click', function() {
            // Cambiar tab activo
            $('.tab-nav-item').removeClass('active').attr('aria-selected', 'false');
            $(this).addClass('active').attr('aria-selected', 'true');
            
            $('.tab-pane').removeClass('active');
            $(`#${tabId}`).addClass('active');
            
            // Inicializar tabla si no está inicializada
            if (!tablasInicializadas[tableId]) {
                setTimeout(() => {
                    inicializarDataTable(tableId, documentosPorAnio[anio]);
                }, 100);
            }
        });
        
        $tabsNav.append($navItem);
        
        // Tab content
        const $tabPane = $(`
            <div 
                class="tab-pane ${isActive ? 'active' : ''}" 
                id="${tabId}"
                role="tabpanel"
                aria-labelledby="${tabId}-tab">
            </div>
        `);
        
        const $table = $(`<table id="${tableId}" class="display nowrap" style="width:100%"></table>`);
        const $thead = $(`
            <thead>
                <tr>
                    <th>Documento</th>
                    <th>Tipo</th>
                    <th class="text-center">Documento</th>
                </tr>
            </thead>
        `);
        
        $table.append($thead);
        $table.append('<tbody></tbody>');
        
        $tabPane.append($table);
        $tabsContent.append($tabPane);
        
        // Inicializar la primera tabla
        if (isActive) {
            setTimeout(() => {
                inicializarDataTable(tableId, documentosPorAnio[anio]);
            }, 100);
        }
    });
    
    console.log('✅ Tabs renderizados:', aniosOrdenados.length);
}

// =============================================================================
// INICIALIZAR DATATABLE
// =============================================================================

function inicializarDataTable(tableId, documentos) {
    if (tablasInicializadas[tableId]) {
        console.log('⚠️ Tabla', tableId, 'ya inicializada');
        return;
    }
    
    console.log('📊 Inicializando DataTable:', tableId);
    console.log('📊 Documentos a cargar:', documentos.length);
    
    // Preparar datos
    const data = [];
    
    documentos.forEach(doc => {
        data.push({
            nombre: doc.Nombre || doc.nombre || 'Sin nombre',
            tipo: doc.TipoEstadoFinanciero || doc.tipo_estado_financiero || '-',
            enlace: doc.Enlace || doc.enlace || '#'
        });
    });
    
    console.log('📊 Datos preparados:', data.length, 'filas');
    
    // Inicializar DataTable
    const table = $(`#${tableId}`).DataTable({
        data: data,
        responsive: false,
        pageLength: 25,
        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "Todos"]],
        order: [[0, 'asc']],
        columns: [
            {
                data: 'nombre',
                render: function(data) {
                    return `<div class="doc-titulo">
                                <i class="fas fa-file-invoice-dollar doc-icon"></i>
                                <span>${escapeHtml(data)}</span>
                            </div>`;
                }
            },
            {
                data: 'tipo',
                width: '25%',
                render: function(data) {
                    return escapeHtml(data);
                }
            },
            {
                data: 'enlace',
                orderable: false,
                className: 'text-center',
                width: '15%',
                render: function(data) {
                    if (!data || data === '#') {
                        return '<span style="color: #999;">Sin enlace</span>';
                    }
                    return `<a href="${data}" target="_blank" class="btn-principal" title="Ver documento PDF">
                                <i class="fas fa-file-pdf"></i> Ver
                            </a>`;
                }
            }
        ],
        columnDefs: [
            {
                targets: [2],
                orderable: false
            }
        ],
        dom: '<"table-controls"<"table-length"l><"table-search"f>>rtip',
        drawCallback: function() {
            $(this).find('tbody tr').each(function(index) {
                $(this).css('animation-delay', (index * 0.03) + 's');
            });
        }
    });
    
    tablasInicializadas[tableId] = true;
    console.log('✅ DataTable', tableId, 'inicializado exitosamente');
}

// =============================================================================
// UTILIDADES
// =============================================================================

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

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
        info: 'fa-info-circle',
        warning: 'fa-exclamation-triangle'
    };
    
    $toast.html(`<i class="fas ${icons[tipo]}"></i> ${mensaje}`)
          .removeClass()
          .addClass(`toast ${tipo}`)
          .fadeIn(300);
    
    setTimeout(() => $toast.fadeOut(300), 5000);
}

function mostrarError(mensaje) {
    $('#tabsContent').html(`
        <div class="mensaje-error">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3>Error al cargar estados financieros</h3>
            <div class="error-details">${mensaje}</div>
            <div class="error-actions">
                <button class="btn-reintentar" onclick="cargarDatos(false)">
                    <i class="fas fa-sync-alt"></i> Reintentar
                </button>
                <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-left: 10px;">
                    <i class="fas fa-cloud-download-alt"></i> Forzar actualización desde Google Sheets
                </button>
            </div>
        </div>
    `);
    
    const mensajeSimple = mensaje.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim();
    mostrarToast('❌ ' + mensajeSimple, 'error');
}

// =============================================================================
// DEBUG
// =============================================================================

window.estadosFinancierosDebug = {
    datos: () => {
        console.table(datosCompletos);
        return datosCompletos;
    },
    recargar: (forzar = false) => {
        console.log('🔄 Recargando...');
        intentosRecarga = 0;
        cargarDatos(forzar);
    },
    tablas: () => {
        console.log('📊 Tablas:', tablasInicializadas);
        return tablasInicializadas;
    },
    info: () => {
        console.log('═══════════════════════════════════════════════════════');
        console.log('📊 INFORMACIÓN DEL SISTEMA - ESTADOS FINANCIEROS');
        console.log('═══════════════════════════════════════════════════════');
        console.log('API: JavaScript nativo (no PHP)');
        console.log('jQuery:', jQuery.fn.jquery);
        console.log('DataTables:', $.fn.DataTable.version);
        console.log('Datos cargados:', datosCompletos !== null);
        console.log('Total documentos:', datosCompletos ? datosCompletos.length : 0);
        console.log('Intentos de recarga:', intentosRecarga);
        console.log('Tablas inicializadas:', Object.keys(tablasInicializadas).length);
        console.log('═══════════════════════════════════════════════════════');
    }
};

console.log('═══════════════════════════════════════════════════════');
console.log('💡 Funciones de debug disponibles:');
console.log('   estadosFinancierosDebug.datos()        - Ver datos');
console.log('   estadosFinancierosDebug.recargar()     - Recargar');
console.log('   estadosFinancierosDebug.recargar(true) - Forzar actualización');
console.log('   estadosFinancierosDebug.tablas()       - Ver tablas');
console.log('   estadosFinancierosDebug.info()         - Info del sistema');
console.log('═══════════════════════════════════════════════════════');
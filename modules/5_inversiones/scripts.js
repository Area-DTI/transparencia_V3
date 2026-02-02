// =============================================================================
// INVERSIONES - Sistema con acordeones y filtros
// Versión: Google Apps Script + JS API (migrado desde PHP)
// =============================================================================

let datosCompletos = null;
let datosFiltrados = null;
let tablasInicializadas = {};
let intentosRecarga = 0;
const MAX_INTENTOS = 3;

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 MÓDULO INVERSIONES INICIADO');
    console.log('📡 Conectado a: Google Apps Script via JS API');
    console.log('═══════════════════════════════════════════════════════');
    
    // Verificar que database.js esté cargado
    if (typeof getDB === 'undefined') {
        console.error('❌ ERROR: database.js no cargado');
        mostrarError('Configuración incorrecta: database.js no está cargado');
        return;
    }
    
    // Verificar que la API JS esté cargada
    if (typeof getInversionesData === 'undefined') {
        console.error('❌ ERROR: inversiones.js (API) no cargada');
        mostrarError('Configuración incorrecta: API de inversiones no está cargada');
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
    console.log('✅ API Inversiones JS: OK');
    
    configurarDataTablesEspanol();
    configurarEventos();
    cargarDatos();
});

// =============================================================================
// CONFIGURAR DATATABLES EN ESPAÑOL
// =============================================================================

function configurarDataTablesEspanol() {
    $.extend(true, $.fn.dataTable.defaults, {
        language: {
            "decimal": "",
            "emptyTable": "No hay inversiones disponibles",
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
// CONFIGURAR EVENTOS
// =============================================================================

function configurarEventos() {
    // Filtro por año
    $('#filtro-anio').on('change', function() {
        aplicarFiltros();
    });
    
    // Botón limpiar filtros
    $('#btn-limpiar-filtros').on('click', function() {
        $('#filtro-anio').val('');
        aplicarFiltros();
    });
}

// =============================================================================
// CARGAR DATOS (ACTUALIZADO PARA API JS)
// =============================================================================

async function cargarDatos(forzarActualizacion = false) {
    console.log('───────────────────────────────────────────────────────');
    console.log('📥 CARGANDO INVERSIONES DESDE GOOGLE APPS SCRIPT');
    console.log('───────────────────────────────────────────────────────');
    console.log('🔄 Forzar actualización:', forzarActualizacion);
    console.log('🔢 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
    
    mostrarLoading(true);
    
    try {
        console.log('📤 Llamando a getInversionesData()...');
        
        // Llamar a la API JS directamente
        const response = await getInversionesData();
        
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
        
        if (!response.secciones) {
            throw new Error('Respuesta sin secciones');
        }
        
        const secciones = response.secciones;
        
        if (secciones.length === 0) {
            console.warn('⚠️ No hay inversiones en Google Sheets');
            mostrarLoading(false);
            $('#secciones-container').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-folder-open fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                    <p>No hay información de inversiones disponible en Google Sheets</p>
                    <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-top: 15px;">
                        <i class="fas fa-sync-alt"></i> Actualizar desde Google Sheets
                    </button>
                </div>
            `);
            return;
        }
        
        datosCompletos = secciones;
        datosFiltrados = secciones;
        intentosRecarga = 0; // Resetear intentos
        
        console.log('✅ Secciones de inversiones cargadas:', datosCompletos.length);
        console.log('📊 Total documentos:', response.total);
        console.log('📊 Fuente:', response.source || 'API JS');
        console.log('📊 Timestamp:', response.timestamp);
        
        popularFiltroAnios();
        renderizarSecciones(datosCompletos);
        actualizarContadorTotal();
        
        mostrarLoading(false);
        mostrarToast(`✅ ${response.total} documentos de inversiones cargados desde Google Sheets`, 'success');
        
        console.log('───────────────────────────────────────────────────────');
        console.log('✅ CARGA COMPLETADA');
        console.log('───────────────────────────────────────────────────────');
        
    } catch (error) {
        console.error('───────────────────────────────────────────────────────');
        console.error('❌ ERROR AL CARGAR INVERSIONES');
        console.error('───────────────────────────────────────────────────────');
        console.error('📊 Error:', error);
        console.error('📊 Mensaje:', error.message);
        console.error('📊 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
        
        mostrarLoading(false);
        
        let mensaje = 'Error al cargar inversiones desde Google Sheets';
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
        intentosRecarga = 0;
        
        $('#secciones-container').html(`
            <div class="mensaje-vacio">
                <i class="fas fa-exclamation-triangle fa-3x" style="color: #dc3545; margin-bottom: 15px;"></i>
                <h3>${mensaje}</h3>
                <p style="color: #666; max-width: 600px; margin: 15px auto;">${detalles}</p>
                <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;">
                    <button class="btn-reintentar" onclick="cargarDatos(false)">
                        <i class="fas fa-sync-alt"></i> Reintentar
                    </button>
                    <button class="btn-reintentar" onclick="cargarDatos(true)">
                        <i class="fas fa-cloud-download-alt"></i> Forzar actualización
                    </button>
                </div>
            </div>
        `);
        
        mostrarToast('❌ ' + mensaje, 'error');
    }
}

// =============================================================================
// POPULAR FILTRO DE AÑOS
// =============================================================================

function popularFiltroAnios() {
    const aniosSet = new Set();
    
    datosCompletos.forEach(seccion => {
        seccion.documentos.forEach(doc => {
            if (doc.anio && doc.anio.trim() !== '') {
                aniosSet.add(doc.anio.trim());
            }
        });
    });
    
    const aniosOrdenados = Array.from(aniosSet).sort((a, b) => {
        const numA = parseInt(a) || 0;
        const numB = parseInt(b) || 0;
        return numB - numA; // Descendente
    });
    
    const $filtroAnio = $('#filtro-anio');
    $filtroAnio.find('option:not(:first)').remove();
    
    aniosOrdenados.forEach(anio => {
        $filtroAnio.append(`<option value="${anio}">${anio}</option>`);
    });
    
    console.log('📅 Años disponibles:', aniosOrdenados);
}

// =============================================================================
// APLICAR FILTROS
// =============================================================================

function aplicarFiltros() {
    const anioSeleccionado = $('#filtro-anio').val();
    
    console.log('🔍 Aplicando filtros:', { anio: anioSeleccionado });
    
    if (!anioSeleccionado) {
        // Sin filtros, mostrar todo
        datosFiltrados = datosCompletos;
        renderizarSecciones(datosFiltrados);
    } else {
        // Filtrar por año
        datosFiltrados = datosCompletos.map(seccion => {
            const docsFiltrados = seccion.documentos.filter(doc => 
                doc.anio === anioSeleccionado
            );
            
            if (docsFiltrados.length > 0) {
                return {
                    nombre: seccion.nombre,
                    documentos: docsFiltrados,
                    total: docsFiltrados.length
                };
            }
            return null;
        }).filter(s => s !== null);
        
        if (datosFiltrados.length > 0) {
            renderizarSecciones(datosFiltrados);
        } else {
            $('#secciones-container').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-filter fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                    <p>No se encontraron documentos para el año ${anioSeleccionado}</p>
                </div>
            `);
        }
    }
    
    actualizarContadorTotal();
}

// =============================================================================
// RENDERIZAR SECCIONES CON ACORDEONES
// =============================================================================

function renderizarSecciones(secciones) {
    console.log('📊 Renderizando secciones:', secciones.length);
    
    const $container = $('#secciones-container');
    $container.empty();
    
    // Resetear tablas inicializadas
    tablasInicializadas = {};
    
    secciones.forEach((seccion, index) => {
        const seccionId = `seccion-${index}`;
        const isFirst = index === 0;
        
        // Crear sección colapsable
        const $seccion = $(`
            <div class="seccion-agrupada">
                <div class="seccion-header ${isFirst ? '' : 'collapsed'}" data-target="${seccionId}">
                    <div class="seccion-titulo">
                        <i class="fas fa-chart-line"></i>
                        <span>${escapeHtml(seccion.nombre)}</span>
                    </div>
                    <span class="seccion-count">${seccion.total} documentos</span>
                    <i class="fas fa-chevron-down collapse-icon"></i>
                </div>
                <div class="seccion-body" id="${seccionId}" style="display: ${isFirst ? 'block' : 'none'};">
                </div>
            </div>
        `);
        
        // Evento click para toggle
        $seccion.find('.seccion-header').on('click', function() {
            const $header = $(this);
            const $body = $(`#${$header.data('target')}`);
            const isCollapsed = $header.hasClass('collapsed');
            
            if (isCollapsed) {
                $header.removeClass('collapsed');
                $body.slideDown(300);
                
                // Inicializar tabla si no está inicializada
                const tableId = `table-${seccionId}`;
                if (!tablasInicializadas[tableId]) {
                    crearYInicializarTabla(tableId, $body, seccion.documentos);
                }
            } else {
                $header.addClass('collapsed');
                $body.slideUp(300);
            }
        });
        
        // Si es la primera sección, inicializar tabla inmediatamente
        if (isFirst) {
            const tableId = `table-${seccionId}`;
            const $body = $seccion.find('.seccion-body');
            
            setTimeout(() => {
                crearYInicializarTabla(tableId, $body, seccion.documentos);
            }, 100);
        }
        
        $container.append($seccion);
    });
    
    console.log('✅ Secciones renderizadas:', secciones.length);
}

// =============================================================================
// CREAR Y INICIALIZAR TABLA
// =============================================================================

function crearYInicializarTabla(tableId, $container, documentos) {
    if (tablasInicializadas[tableId]) {
        console.log('⚠️ Tabla', tableId, 'ya inicializada');
        return;
    }
    
    console.log('📊 Creando e inicializando tabla:', tableId);
    console.log('📊 Documentos:', documentos.length);
    
    // Crear estructura HTML de la tabla
    const $table = $(`
        <table id="${tableId}" class="tabla-documentos display" style="width:100%">
            <thead>
                <tr>
                    <th>Tipo</th>
                    <th>Año</th>
                    <th class="text-center">Enlace</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    `);
    
    $container.html($table);
    
    // Preparar datos para DataTable
    const data = [];
    
    documentos.forEach(doc => {
        data.push({
            tipo: doc.tipo || '-',
            anio: doc.anio || '-',
            enlace: doc.enlace || '#'
        });
    });
    
    // Inicializar DataTable
    $(`#${tableId}`).DataTable({
        data: data,
        pageLength: 15,
        lengthMenu: [[10, 15, 25, -1], [10, 15, 25, "Todos"]],
        order: [[1, 'desc'], [0, 'asc']], // Año DESC, Tipo ASC
        columns: [
            {
                data: 'tipo',
                render: function(data) {
                    return escapeHtml(data);
                }
            },
            {
                data: 'anio',
                width: '12%',
                className: 'text-center',
                render: function(data) {
                    return `<strong>${escapeHtml(data)}</strong>`;
                }
            },
            {
                data: 'enlace',
                orderable: false,
                className: 'text-center',
                width: '14%',
                render: function(data) {
                    if (!data || data === '#') {
                        return '<span class="sin-enlace">Sin enlace</span>';
                    }
                    return `<a href="${data}" target="_blank" class="btn-pdf" title="Ver documento PDF">
                                <i class="fas fa-file-pdf"></i> Ver
                            </a>`;
                }
            }
        ]
    });
    
    tablasInicializadas[tableId] = true;
    console.log('✅ Tabla', tableId, 'inicializada');
}

// =============================================================================
// ACTUALIZAR CONTADOR TOTAL
// =============================================================================

function actualizarContadorTotal() {
    let total = 0;
    
    if (datosFiltrados) {
        datosFiltrados.forEach(seccion => {
            total += seccion.documentos.length;
        });
    }
    
    $('#total-documentos').text(total);
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
    const $overlay = $('#loading-overlay');
    if (show) {
        $overlay.css('display', 'flex');
    } else {
        $overlay.css('display', 'none');
    }
}

function mostrarToast(mensaje, tipo = 'info') {
    const iconos = {
        success: 'fa-check-circle',
        error: 'fa-exclamation-circle',
        info: 'fa-info-circle',
        warning: 'fa-exclamation-triangle'
    };
    
    const colores = {
        success: '#28a745',
        error: '#dc3545',
        info: '#17a2b8',
        warning: '#f59e0b'
    };
    
    const $toast = $(`
        <div class="toast" style="border-left-color: ${colores[tipo]};">
            <i class="fas ${iconos[tipo]}" style="color: ${colores[tipo]}; font-size: 20px;"></i>
            <span>${mensaje}</span>
        </div>
    `);
    
    $('#toast-container').append($toast);
    
    setTimeout(() => $toast.addClass('show'), 100);
    
    setTimeout(() => {
        $toast.removeClass('show');
        setTimeout(() => $toast.remove(), 300);
    }, 5000);
}

function mostrarError(mensaje) {
    $('#secciones-container').html(`
        <div class="mensaje-vacio">
            <i class="fas fa-exclamation-triangle fa-3x" style="color: #dc3545; margin-bottom: 15px;"></i>
            <h3>Error al cargar inversiones</h3>
            <p style="color: #666;">${mensaje}</p>
        </div>
    `);
    
    mostrarToast('❌ ' + mensaje, 'error');
}

// =============================================================================
// DEBUG
// =============================================================================

window.inversionesDebug = {
    datos: () => {
        console.log('📊 Datos completos:', datosCompletos);
        console.log('📊 Datos filtrados:', datosFiltrados);
        return { completos: datosCompletos, filtrados: datosFiltrados };
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
        console.log('📊 INFORMACIÓN DEL SISTEMA - INVERSIONES');
        console.log('═══════════════════════════════════════════════════════');
        console.log('API: JavaScript nativo (no PHP)');
        console.log('jQuery:', jQuery.fn.jquery);
        console.log('DataTables:', $.fn.DataTable.version);
        console.log('Datos cargados:', datosCompletos !== null);
        console.log('Secciones:', datosCompletos ? datosCompletos.length : 0);
        console.log('Intentos de recarga:', intentosRecarga);
        console.log('Tablas inicializadas:', Object.keys(tablasInicializadas).length);
        console.log('═══════════════════════════════════════════════════════');
    }
};

console.log('═══════════════════════════════════════════════════════');
console.log('💡 Funciones de debug disponibles:');
console.log('   inversionesDebug.datos()        - Ver datos');
console.log('   inversionesDebug.recargar()     - Recargar');
console.log('   inversionesDebug.recargar(true) - Forzar actualización');
console.log('   inversionesDebug.tablas()       - Ver tablas');
console.log('   inversionesDebug.info()         - Info del sistema');
console.log('═══════════════════════════════════════════════════════');
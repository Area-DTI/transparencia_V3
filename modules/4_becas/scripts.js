// =============================================================================
// BECAS - Sistema con acordeones por sección
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
    console.log('🚀 MÓDULO BECAS INICIADO');
    console.log('📡 Conectado a: Google Apps Script via JS API');
    console.log('═══════════════════════════════════════════════════════');
    
    // Verificar que database.js esté cargado
    if (typeof getDB === 'undefined') {
        console.error('❌ ERROR: database.js no cargado');
        mostrarError('Configuración incorrecta: database.js no está cargado');
        return;
    }
    
    // Verificar que la API JS esté cargada
    if (typeof getBecasData === 'undefined') {
        console.error('❌ ERROR: becas.js (API) no cargada');
        mostrarError('Configuración incorrecta: API de becas no está cargada');
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
    console.log('✅ API Becas JS: OK');
    
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
            "emptyTable": "No hay becas disponibles",
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
    // Botón limpiar filtros
    $('#btn-limpiar-filtros').on('click', function() {
        $('#filtro-anio').val('');
        aplicarFiltros();
    });
    
    // Cambio en filtro de año
    $('#filtro-anio').on('change', function() {
        aplicarFiltros();
    });
}

// =============================================================================
// CARGAR DATOS (ACTUALIZADO PARA API JS)
// =============================================================================

async function cargarDatos(forzarActualizacion = false) {
    console.log('───────────────────────────────────────────────────────');
    console.log('📥 CARGANDO BECAS DESDE GOOGLE APPS SCRIPT');
    console.log('───────────────────────────────────────────────────────');
    console.log('🔄 Forzar actualización:', forzarActualizacion);
    console.log('🔢 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
    
    mostrarLoading(true);
    
    try {
        console.log('📤 Llamando a getBecasData()...');
        
        // Llamar a la API JS directamente
        const response = await getBecasData();
        
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
            console.warn('⚠️ No hay becas en Google Sheets');
            mostrarLoading(false);
            $('#secciones-container').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-folder-open fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                    <p>No hay información de becas disponible en Google Sheets</p>
                    <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-top: 15px;">
                        <i class="fas fa-sync-alt"></i> Actualizar desde Google Sheets
                    </button>
                </div>
            `);
            return;
        }
        
        datosCompletos = secciones;
        intentosRecarga = 0; // Resetear intentos
        
        console.log('✅ Secciones de becas cargadas:', datosCompletos.length);
        console.log('📊 Total documentos:', response.total);
        console.log('📊 Fuente:', response.source || 'API JS');
        console.log('📊 Timestamp:', response.timestamp);
        
        renderizarSecciones(datosCompletos);
        popularFiltroAnios();
        actualizarContadorTotal();
        
        mostrarLoading(false);
        mostrarToast(`✅ ${response.total} documentos de becas cargados desde Google Sheets`, 'success');
        
        console.log('───────────────────────────────────────────────────────');
        console.log('✅ CARGA COMPLETADA');
        console.log('───────────────────────────────────────────────────────');
        
    } catch (error) {
        console.error('───────────────────────────────────────────────────────');
        console.error('❌ ERROR AL CARGAR BECAS');
        console.error('───────────────────────────────────────────────────────');
        console.error('📊 Error:', error);
        console.error('📊 Mensaje:', error.message);
        console.error('📊 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
        
        mostrarLoading(false);
        
        let mensaje = 'Error al cargar becas desde Google Sheets';
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
        
        $('#secciones-container').html(`
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
        const tableId = `table-${index}`;
        const isFirst = index === 0;
        
        // Crear acordeón
        const $acordeon = $(`
            <div class="acordeon-item">
                <div class="acordeon-header ${isFirst ? 'active' : ''}" data-target="${seccionId}">
                    <div class="acordeon-titulo">
                        <i class="fas fa-graduation-cap"></i>
                        <span>${escapeHtml(seccion.nombre)}</span>
                    </div>
                    <div class="acordeon-badge">
                        ${seccion.total} documentos
                    </div>
                    <i class="fas fa-chevron-down acordeon-icono"></i>
                </div>
                <div class="acordeon-content ${isFirst ? 'show' : ''}" id="${seccionId}">
                </div>
            </div>
        `);
        
        // Evento de acordeón
        $acordeon.find('.acordeon-header').on('click', function() {
            const $header = $(this);
            const $content = $(`#${$header.data('target')}`);
            const wasActive = $header.hasClass('active');
            
            // Cerrar otros acordeones
            $('.acordeon-header').removeClass('active');
            $('.acordeon-content').removeClass('show');
            
            // Toggle este acordeón
            if (!wasActive) {
                $header.addClass('active');
                $content.addClass('show');
                
                // Inicializar tabla si no está inicializada
                if (!tablasInicializadas[tableId]) {
                    const $tableWrapper = crearTabla(tableId);
                    $content.html($tableWrapper);
                    
                    setTimeout(() => {
                        inicializarDataTable(tableId, seccion.documentos);
                    }, 100);
                }
            }
        });
        
        // Si es el primero, inicializar tabla inmediatamente
        if (isFirst) {
            const $tableWrapper = crearTabla(tableId);
            $acordeon.find('.acordeon-content').html($tableWrapper);
            
            setTimeout(() => {
                inicializarDataTable(tableId, seccion.documentos);
            }, 100);
        }
        
        $container.append($acordeon);
    });
    
    console.log('✅ Secciones renderizadas:', secciones.length);
}

// =============================================================================
// CREAR TABLA
// =============================================================================

function crearTabla(tableId) {
    const $wrapper = $('<div class="table-wrapper"></div>');
    const $table = $(`<table id="${tableId}" class="display nowrap" style="width:100%"></table>`);
    const $thead = $(`
        <thead>
            <tr>
                <th>Periodo</th>
                <th>Documento</th>
                <th class="text-center">Enlace</th>
            </tr>
        </thead>
    `);
    
    $table.append($thead);
    $table.append('<tbody></tbody>');
    $wrapper.append($table);
    
    return $wrapper;
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
        let periodo = '';
        
        if (doc.tipo_periodo && doc.anio) {
            periodo = `${doc.tipo_periodo} ${doc.anio}`;
        } else if (doc.semestre && doc.anio) {
            periodo = `${doc.semestre} - ${doc.anio}`;
        } else if (doc.anio) {
            periodo = doc.anio;
        } else {
            periodo = '-';
        }
        
        let nombreDoc = doc.nombre_original || doc.categoria || doc.subcategoria || 'Documento';
        
        data.push({
            periodo: periodo,
            nombre: nombreDoc,
            enlace: doc.enlace || '#',
            anio: doc.anio || '' // Para filtros
        });
    });
    
    console.log('📊 Datos preparados:', data.length, 'filas');
    
    // Inicializar DataTable
    const table = $(`#${tableId}`).DataTable({
        data: data,
        responsive: false,
        pageLength: 15,
        lengthMenu: [[10, 15, 25, -1], [10, 15, 25, "Todos"]],
        order: [[0, 'desc']], // Ordenar por periodo descendente
        columns: [
            {
                data: 'periodo',
                width: '20%',
                render: function(data) {
                    return `<span class="periodo-badge">${escapeHtml(data)}</span>`;
                }
            },
            {
                data: 'nombre',
                render: function(data) {
                    return `<div class="doc-titulo">
                                <i class="fas fa-graduation-cap doc-icon"></i>
                                <span>${escapeHtml(data)}</span>
                            </div>`;
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
// FILTROS
// =============================================================================

function popularFiltroAnios() {
    const anios = new Set();
    
    datosCompletos.forEach(seccion => {
        seccion.documentos.forEach(doc => {
            if (doc.anio) {
                anios.add(doc.anio);
            }
        });
    });
    
    const aniosOrdenados = Array.from(anios).sort((a, b) => b.localeCompare(a));
    
    const $filtroAnio = $('#filtro-anio');
    $filtroAnio.find('option:not(:first)').remove();
    
    aniosOrdenados.forEach(anio => {
        $filtroAnio.append(`<option value="${anio}">${anio}</option>`);
    });
}

function aplicarFiltros() {
    const anioSeleccionado = $('#filtro-anio').val();
    
    if (!anioSeleccionado) {
        // Si no hay filtro, mostrar todas las secciones
        renderizarSecciones(datosCompletos);
    } else {
        // Filtrar secciones que tengan documentos del año seleccionado
        const seccionesFiltradas = datosCompletos.map(seccion => {
            const docsFiltrados = seccion.documentos.filter(doc => doc.anio === anioSeleccionado);
            
            if (docsFiltrados.length > 0) {
                return {
                    nombre: seccion.nombre,
                    documentos: docsFiltrados,
                    total: docsFiltrados.length
                };
            }
            return null;
        }).filter(s => s !== null);
        
        if (seccionesFiltradas.length > 0) {
            renderizarSecciones(seccionesFiltradas);
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

function actualizarContadorTotal() {
    let total = 0;
    
    if (datosCompletos) {
        datosCompletos.forEach(seccion => {
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
        $overlay.fadeIn(300);
    } else {
        $overlay.fadeOut(300);
    }
}

function mostrarToast(mensaje, tipo = 'info') {
    const icons = {
        success: 'fa-check-circle',
        error: 'fa-exclamation-circle',
        info: 'fa-info-circle',
        warning: 'fa-exclamation-triangle'
    };
    
    const $toast = $('<div class="toast"></div>')
        .addClass(tipo)
        .html(`<i class="fas ${icons[tipo]}"></i> ${mensaje}`);
    
    $('#toast-container').append($toast);
    
    setTimeout(() => {
        $toast.addClass('show');
    }, 100);
    
    setTimeout(() => {
        $toast.removeClass('show');
        setTimeout(() => $toast.remove(), 300);
    }, 5000);
}

function mostrarError(mensaje) {
    $('#secciones-container').html(`
        <div class="mensaje-error">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3>Error al cargar becas</h3>
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

window.becasDebug = {
    datos: () => {
        console.log('📊 Datos completos:', datosCompletos);
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
        console.log('📊 INFORMACIÓN DEL SISTEMA - BECAS');
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
console.log('   becasDebug.datos()        - Ver datos cargados');
console.log('   becasDebug.recargar()     - Recargar datos');
console.log('   becasDebug.recargar(true) - Forzar actualización');
console.log('   becasDebug.tablas()       - Ver tablas');
console.log('   becasDebug.info()         - Info del sistema');
console.log('═══════════════════════════════════════════════════════');
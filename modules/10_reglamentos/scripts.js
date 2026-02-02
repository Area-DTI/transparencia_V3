// =============================================================================
// REGLAMENTOS - Sistema con acordeones y DataTables
// =============================================================================
// Flujo:
//   config/database.js   → window.getDB('reglamentos')
//   api/reglamentos.js   → window.getReglamentosData()
//   scripts.js (este)    → renderiza acordeones + DataTables
// =============================================================================

let datosOriginales = [];
let datosFiltrados = [];
let tablasInicializadas = {};

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 MÓDULO REGLAMENTOS INICIADO');
    console.log('═══════════════════════════════════════════════════════');

    configurarDataTablesEspanol();
    configurarEventos();
    cargarDatos();
});

// =============================================================================
// DATATABLES EN ESPAÑOL
// =============================================================================

function configurarDataTablesEspanol() {
    $.extend(true, $.fn.dataTable.defaults, {
        language: {
            "emptyTable": "No hay reglamentos disponibles",
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
// EVENTOS DE FILTROS
// =============================================================================

function configurarEventos() {
    $('#filtroSeccion').on('change', aplicarFiltros);
    $('#filtroAnio').on('change', aplicarFiltros);
    $('#filtroBusqueda').on('keyup', aplicarFiltros);
}

// =============================================================================
// CARGAR DATOS (usa api/reglamentos.js)
// =============================================================================

async function cargarDatos() {
    console.log('📥 Cargando reglamentos...');
    mostrarLoading(true);

    try {
        if (typeof window.getReglamentosData !== 'function') {
            throw new Error('getReglamentosData no disponible. Verificar que api/reglamentos.js se cargó.');
        }

        const response = await window.getReglamentosData();

        console.log('📦 Respuesta procesada:', response);

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        const documentos = response.data || [];

        if (documentos.length === 0) {
            mostrarLoading(false);
            $('#documentosAgrupados').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-balance-scale"></i>
                    <h3>No hay reglamentos disponibles</h3>
                </div>
            `);
            return;
        }

        datosOriginales = documentos;
        datosFiltrados = [...documentos];

        console.log('✅ Reglamentos cargados:', datosOriginales.length);

        cargarFiltros();
        renderizarDocumentos(datosFiltrados);
        actualizarContador();

        mostrarLoading(false);
        mostrarToast(`✅ ${datosOriginales.length} reglamentos cargados`, 'success');

    } catch (error) {
        console.error('❌ Error:', error);
        mostrarLoading(false);
        mostrarError(error.message);
    }
}

// =============================================================================
// CARGAR OPCIONES DE FILTROS
// =============================================================================

function cargarFiltros() {
    const secciones = new Set();
    const anios = new Set();

    datosOriginales.forEach(doc => {
        if (doc.Seccion) secciones.add(doc.Seccion);
        if (doc.Año)     anios.add(doc.Año);
    });

    // Secciones
    const $selectSeccion = $('#filtroSeccion');
    $selectSeccion.find('option:not(:first)').remove();
    Array.from(secciones).sort().forEach(s => {
        $selectSeccion.append(`<option value="${s}">${s}</option>`);
    });

    // Años (descendente)
    const $selectAnio = $('#filtroAnio');
    $selectAnio.find('option:not(:first)').remove();
    Array.from(anios).sort((a, b) => parseInt(b) - parseInt(a)).forEach(a => {
        $selectAnio.append(`<option value="${a}">${a}</option>`);
    });

    console.log('📅 Filtros cargados — Secciones:', secciones.size, '| Años:', anios.size);
}

// =============================================================================
// APLICAR FILTROS
// =============================================================================

function aplicarFiltros() {
    const seccion  = $('#filtroSeccion').val();
    const anio     = $('#filtroAnio').val();
    const busqueda = $('#filtroBusqueda').val().toLowerCase().trim();

    datosFiltrados = datosOriginales.filter(doc => {
        if (seccion && doc.Seccion !== seccion) return false;
        if (anio    && doc.Año !== anio)        return false;
        if (busqueda) {
            const texto = [doc.Seccion, doc.Subcategoria, doc.resolucion].join(' ').toLowerCase();
            if (!texto.includes(busqueda)) return false;
        }
        return true;
    });

    renderizarDocumentos(datosFiltrados);
    actualizarContador();
}

// =============================================================================
// RENDERIZAR DOCUMENTOS AGRUPADOS POR SECCIÓN (acordeones)
// =============================================================================

function renderizarDocumentos(documentos) {
    const $container = $('#documentosAgrupados');
    $container.empty();
    tablasInicializadas = {};

    if (!documentos || documentos.length === 0) {
        $container.html(`
            <div class="mensaje-vacio">
                <i class="fas fa-search"></i>
                <h3>No se encontraron documentos con los filtros seleccionados</h3>
            </div>
        `);
        return;
    }

    // Agrupar por sección
    const agrupado = {};
    documentos.forEach(doc => {
        const sec = doc.Seccion || 'Sin sección';
        if (!agrupado[sec]) agrupado[sec] = [];
        agrupado[sec].push(doc);
    });

    const seccionesOrdenadas = Object.keys(agrupado).sort();

    seccionesOrdenadas.forEach((seccion, index) => {
        const docs    = agrupado[seccion];
        const secId   = `seccion-${index}`;
        const tableId = `table-${secId}`;
        const isFirst = index === 0;

        // Acordeón wrapper
        const $acordeon = $('<div>', { class: 'seccion-acordeon' });

        // Header
        const $header = $('<div>', {
            class: `seccion-header ${isFirst ? '' : 'collapsed'}`,
            html: `
                <div class="seccion-titulo">
                    <i class="fas fa-chevron-down collapse-icon"
                       style="${isFirst ? '' : 'transform: rotate(-90deg);'}"></i>
                    <span>${escapeHtml(seccion)}</span>
                </div>
                <span class="seccion-count">
                    ${docs.length} documento${docs.length !== 1 ? 's' : ''}
                </span>
            `
        });

        // Toggle acordeón
        $header.on('click', function() {
            const $this  = $(this);
            const $body  = $this.next('.seccion-body');
            const $icon  = $this.find('.collapse-icon');

            $this.toggleClass('collapsed');

            if ($this.hasClass('collapsed')) {
                $body.slideUp(300);
                $icon.css('transform', 'rotate(-90deg)');
            } else {
                $body.slideDown(300);
                $icon.css('transform', 'rotate(0deg)');

                // Inicializar DataTable lazy si aún no existe
                if (!tablasInicializadas[tableId]) {
                    setTimeout(() => inicializarDataTable(tableId, docs), 100);
                } else {
                    // Re-ajustar columnas
                    setTimeout(() => {
                        $(`#${tableId}`).DataTable().columns.adjust();
                    }, 350);
                }
            }
        });

        $acordeon.append($header);

        // Body
        const $body = $('<div>', {
            class: 'seccion-body',
            style: isFirst ? '' : 'display: none;'
        });

        // Tabla (solo estructura, DataTable la llena)
        $body.append($(`
            <div class="table-wrapper">
                <table id="${tableId}" class="reglamentos-table display responsive nowrap" style="width:100%">
                    <thead>
                        <tr>
                            <th>Documento</th>
                            <th class="text-center">PDF</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        `));

        $acordeon.append($body);
        $container.append($acordeon);

        // Inicializar DataTable de la primera sección inmediatamente
        if (isFirst) {
            setTimeout(() => inicializarDataTable(tableId, docs), 100);
        }
    });

    console.log('✅ Documentos renderizados en', seccionesOrdenadas.length, 'secciones');
}

// =============================================================================
// INICIALIZAR DATATABLE
// =============================================================================

function inicializarDataTable(tableId, documentos) {
    if (tablasInicializadas[tableId]) return;

    console.log('📊 Inicializando DataTable:', tableId, '—', documentos.length, 'docs');

    const data = documentos.map(doc => ({
        subcategoria: doc.Subcategoria || '-',
        es_subitem: doc.es_subitem || 0,
        enlace: doc.Enlace || ''
    }));

    $(`#${tableId}`).DataTable({
        data: data,
        responsive: false,
        pageLength: 15,
        lengthMenu: [[10, 15, 25, 50, -1], [10, 15, 25, 50, "Todos"]],
        order: [],  // mantener el orden que ya tiene el array (por sección > subitem > id)
        columns: [
            {
                data: 'subcategoria',
                render: function(data, type, row) {
                    const cls = row.es_subitem === 1 ? 'doc-subitem' : 'doc-titulo';
                    return `<div class="${cls}">
                                <i class="fas fa-file-alt doc-icon"></i>
                                <span>${escapeHtml(data)}</span>
                            </div>`;
                }
            },
            {
                data: 'enlace',
                orderable: false,
                className: 'text-center',
                width: '12%',
                render: function(data) {
                    if (!data) return '<span class="no-disponible">-</span>';
                    return `<a href="${data}" target="_blank" class="btn-principal" title="Ver documento PDF">
                                <i class="fas fa-file-pdf"></i> Ver
                            </a>`;
                }
            }
        ],
        dom: '<"table-controls"<"table-length"l><"table-search"f>>rtip'
    });

    tablasInicializadas[tableId] = true;
    console.log('✅ DataTable', tableId, 'inicializado');
}

// =============================================================================
// CONTADOR
// =============================================================================

function actualizarContador() {
    $('#totalDocumentos').text(datosFiltrados.length);
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
    $('#loadingOverlay')[show ? 'fadeIn' : 'fadeOut'](300);
}

function mostrarToast(mensaje, tipo = 'success') {
    const icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', info: 'fa-info-circle' };
    $('#toast').html(`<i class="fas ${icons[tipo]}"></i> ${mensaje}`)
               .removeClass().addClass(`toast ${tipo}`).fadeIn(300);
    setTimeout(() => $('#toast').fadeOut(300), 5000);
}

function mostrarError(mensaje) {
    $('#documentosAgrupados').html(`
        <div class="mensaje-error">
            <div class="error-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h3>Error al cargar reglamentos</h3>
            <p>${mensaje}</p>
            <button class="btn-reintentar" onclick="cargarDatos()">
                <i class="fas fa-sync-alt"></i> Reintentar
            </button>
        </div>
    `);
}

// Debug
window.reglamentosDebug = {
    datos: () => datosOriginales,
    filtrados: () => datosFiltrados,
    recargar: () => cargarDatos()
};

console.log('💡 Debug: reglamentosDebug.datos(), reglamentosDebug.recargar()');
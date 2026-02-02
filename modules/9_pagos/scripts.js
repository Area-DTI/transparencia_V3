// =============================================================================
// PAGOS - Sistema con acordeones y DataTables
// =============================================================================
// Flujo:
//   config/database.js   → window.getDB('pagos')
//   api/pagos.js         → window.getPagosData()
//   scripts.js (este)    → renderiza acordeones + DataTables
// =============================================================================

let datosCompletos = [];
let tablasInicializadas = {};

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 MÓDULO PAGOS INICIADO');
    console.log('═══════════════════════════════════════════════════════');

    configurarDataTablesEspanol();
    cargarDatos();
});

// =============================================================================
// DATATABLES EN ESPAÑOL
// =============================================================================

function configurarDataTablesEspanol() {
    $.extend(true, $.fn.dataTable.defaults, {
        language: {
            "emptyTable": "No hay documentos disponibles",
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
// CARGAR DATOS (usa api/pagos.js)
// =============================================================================

async function cargarDatos() {
    console.log('📥 Cargando pagos...');
    mostrarLoading(true);

    try {
        if (typeof window.getPagosData !== 'function') {
            throw new Error('getPagosData no disponible. Verificar que api/pagos.js se cargó correctamente.');
        }

        const response = await window.getPagosData();

        console.log('📦 Respuesta procesada:', response);

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        const documentos = response.data || [];

        if (documentos.length === 0) {
            mostrarLoading(false);
            $('#documentosAgrupados').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-credit-card"></i>
                    <h3>No hay información de pagos disponible</h3>
                    <p>Los documentos se publican próximamente</p>
                </div>
            `);
            return;
        }

        datosCompletos = documentos;

        console.log('✅ Documentos cargados:', datosCompletos.length);

        renderizarDocumentos(datosCompletos);

        mostrarLoading(false);
        mostrarToast(`✅ ${datosCompletos.length} documentos cargados`, 'success');

    } catch (error) {
        console.error('❌ Error:', error);
        mostrarLoading(false);
        mostrarError(error.message);
    }
}

// =============================================================================
// RENDERIZAR DOCUMENTOS AGRUPADOS POR CATEGORÍA (acordeones)
// =============================================================================

function renderizarDocumentos(documentos) {
    const $container = $('#documentosAgrupados');
    $container.empty();
    tablasInicializadas = {};

    if (!documentos || documentos.length === 0) {
        $container.html(`
            <div class="mensaje-vacio">
                <i class="fas fa-credit-card"></i>
                <h3>No hay información de pagos disponible</h3>
            </div>
        `);
        return;
    }

    // Agrupar por categoría
    const agrupado = {};
    documentos.forEach(doc => {
        const cat = doc.Categoria || 'Sin categoría';
        if (!agrupado[cat]) agrupado[cat] = [];
        agrupado[cat].push(doc);
    });

    const categoriasOrdenadas = Object.keys(agrupado).sort();

    categoriasOrdenadas.forEach((categoria, index) => {
        const docs    = agrupado[categoria];
        const catId   = `categoria-${index}`;
        const tableId = `table-${catId}`;
        const isFirst = index === 0;

        // Acordeón wrapper
        const $acordeon = $('<div>', { class: 'categoria-acordeon' });

        // Header
        const $header = $('<div>', {
            class: `categoria-header ${isFirst ? '' : 'collapsed'}`,
            html: `
                <div class="categoria-titulo">
                    <i class="fas fa-chevron-down collapse-icon"
                       style="${isFirst ? '' : 'transform: rotate(-90deg);'}"></i>
                    <span>${escapeHtml(categoria)}</span>
                </div>
                <span class="categoria-count">
                    ${docs.length} documento${docs.length !== 1 ? 's' : ''}
                </span>
            `
        });

        // Toggle acordeón
        $header.on('click', function() {
            const $this = $(this);
            const $body = $this.next('.categoria-body');
            const $icon = $this.find('.collapse-icon');

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
                    setTimeout(() => {
                        $(`#${tableId}`).DataTable().columns.adjust();
                    }, 350);
                }
            }
        });

        $acordeon.append($header);

        // Body
        const $body = $('<div>', {
            class: 'categoria-body',
            style: isFirst ? '' : 'display: none;'
        });

        // Tabla (solo estructura, DataTable la llena)
        $body.append($(`
            <div class="table-wrapper">
                <table id="${tableId}" class="pagos-table display responsive nowrap" style="width:100%">
                    <thead>
                        <tr>
                            <th>Título</th>
                            <th>Resolución</th>
                            <th class="text-center">PDF</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        `));

        $acordeon.append($body);
        $container.append($acordeon);

        // Inicializar DataTable de la primera categoría inmediatamente
        if (isFirst) {
            setTimeout(() => inicializarDataTable(tableId, docs), 100);
        }
    });

    console.log('✅ Documentos renderizados en', categoriasOrdenadas.length, 'categorías');
}

// =============================================================================
// INICIALIZAR DATATABLE
// =============================================================================

function inicializarDataTable(tableId, documentos) {
    if (tablasInicializadas[tableId]) return;

    console.log('📊 Inicializando DataTable:', tableId, '—', documentos.length, 'docs');

    const data = documentos.map(doc => ({
        titulo:    doc.Titulo || '-',
        resolucion: doc.Resolucion || '-',
        enlace:    doc.Enlace || ''
    }));

    $(`#${tableId}`).DataTable({
        data: data,
        responsive: false,
        pageLength: 15,
        lengthMenu: [[10, 15, 25, 50, -1], [10, 15, 25, 50, "Todos"]],
        order: [[0, 'asc']], // Ordenar por título ascendente
        columns: [
            {
                data: 'titulo',
                width: '50%',
                render: function(data) {
                    return `<div class="doc-titulo">
                                <i class="fas fa-file-invoice-dollar doc-icon"></i>
                                <span>${escapeHtml(data)}</span>
                            </div>`;
                }
            },
            {
                data: 'resolucion',
                width: '30%',
                render: function(data) {
                    return `<span class="resolucion-text">${escapeHtml(data)}</span>`;
                }
            },
            {
                data: 'enlace',
                orderable: false,
                className: 'text-center',
                width: '20%',
                render: function(data) {
                    if (!data) return '<span class="sin-enlace">Sin enlace</span>';
                    return `<a href="${data}" target="_blank" class="btn-pdf" title="Ver documento PDF">
                                <i class="fas fa-file-pdf"></i> Ver PDF
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
            <h3>Error al cargar documentos</h3>
            <p>${mensaje}</p>
            <button class="btn-reintentar" onclick="cargarDatos()">
                <i class="fas fa-sync-alt"></i> Reintentar
            </button>
        </div>
    `);
}

// Debug
window.pagosDebug = {
    datos: () => datosCompletos,
    recargar: () => cargarDatos()
};

console.log('💡 Debug: pagosDebug.datos(), pagosDebug.recargar()');

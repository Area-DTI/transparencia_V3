// =============================================================================
// REMUNERACIONES - Tabla simple con DataTable
// =============================================================================
// Flujo:
//   config/database.js          → window.getDB('remuneraciones')
//   api/remuneraciones.js       → window.getRemuneracionesData()
//   scripts.js (este)           → renderiza tabla con DataTable
// =============================================================================

let datosOriginales = [];
let dataTableInstance = null;

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 MÓDULO REMUNERACIONES INICIADO');
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
// CARGAR DATOS (usa api/remuneraciones.js)
// =============================================================================

async function cargarDatos() {
    console.log('📥 Cargando remuneraciones...');
    mostrarLoading(true);

    try {
        if (typeof window.getRemuneracionesData !== 'function') {
            throw new Error('getRemuneracionesData no disponible. Verificar que api/remuneraciones.js se cargó correctamente.');
        }

        const response = await window.getRemuneracionesData();

        console.log('📦 Respuesta procesada:', response);

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        const documentos = response.data || [];

        if (documentos.length === 0) {
            mostrarLoading(false);
            $('#documentosAgrupados').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <h3>No hay documentos disponibles</h3>
                    <p>Los documentos de remuneraciones se publican próximamente</p>
                </div>
            `);
            $('#totalDocumentos').text(0);
            return;
        }

        datosOriginales = documentos;

        console.log('✅ Documentos cargados:', datosOriginales.length);

        $('#totalDocumentos').text(datosOriginales.length);

        renderizarTabla(datosOriginales);

        mostrarLoading(false);
        mostrarToast(`✅ ${datosOriginales.length} documento${datosOriginales.length !== 1 ? 's' : ''} cargado${datosOriginales.length !== 1 ? 's' : ''}`, 'success');

    } catch (error) {
        console.error('❌ Error:', error);
        mostrarLoading(false);
        mostrarError(error.message);
    }
}

// =============================================================================
// RENDERIZAR TABLA
// =============================================================================

function renderizarTabla(documentos) {
    const $contenedor = $('#documentosAgrupados');
    $contenedor.empty();

    // Destruir DataTable previo si existe
    if (dataTableInstance) {
        try { dataTableInstance.destroy(); } catch (e) {}
        dataTableInstance = null;
    }

    // Crear tabla
    $contenedor.html(`
        <div class="seccion-agrupada">
            <div class="seccion-header">
                <div class="seccion-titulo">
                    <i class="fas fa-folder-open"></i>
                    <span>REMUNERACIONES</span>
                </div>
                <span class="seccion-count">
                    ${documentos.length} documento${documentos.length !== 1 ? 's' : ''}
                </span>
            </div>
            <div class="seccion-body">
                <table id="tabla-remuneraciones" class="tabla-documentos display nowrap" style="width:100%">
                    <thead>
                        <tr>
                            <th class="text-center" style="width: 70px;">#</th>
                            <th>Documento</th>
                            <th class="text-center" style="width: 140px;">Archivo</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    `);

    // Preparar datos para DataTable
    const data = documentos.map((doc, index) => ({
        numero: index + 1,
        titulo: doc.Titulo || '-',
        enlace: doc.Enlace || ''
    }));

    // Inicializar DataTable
    dataTableInstance = $('#tabla-remuneraciones').DataTable({
        data: data,
        responsive: false,
        paging: false,
        searching: false,
        ordering: false,
        info: false,
        autoWidth: false,
        dom: 't',
        columns: [
            {
                data: 'numero',
                className: 'text-center',
                render: function(data) {
                    return `<span class="numero-fila">#${data}</span>`;
                }
            },
            {
                data: 'titulo',
                render: function(data) {
                    return `<div class="doc-info">
                                <i class="fas fa-file-invoice-dollar doc-icon"></i>
                                <span class="doc-nombre">${escapeHtml(data)}</span>
                            </div>`;
                }
            },
            {
                data: 'enlace',
                className: 'text-center',
                render: function(data) {
                    if (!data) return '<span class="sin-enlace">Sin enlace</span>';
                    return `<a href="${data}" target="_blank" class="btn-pdf" rel="noopener noreferrer" title="Ver documento PDF">
                                <i class="fas fa-file-pdf"></i> Ver PDF
                            </a>`;
                }
            }
        ]
    });

    console.log('✅ Tabla de remuneraciones renderizada');
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
    setTimeout(() => $('#toast').fadeOut(300), 4500);
}

function mostrarError(mensaje) {
    $('#documentosAgrupados').html(`
        <div class="mensaje-vacio">
            <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i>
            <h3 style="color: #dc3545;">Error al cargar datos</h3>
            <p>${mensaje}</p>
            <button class="btn-reintentar" onclick="cargarDatos()">
                <i class="fas fa-sync-alt"></i> Reintentar
            </button>
        </div>
    `);
    mostrarToast('❌ ' + mensaje, 'error');
}

// Debug
window.remuneracionesDebug = {
    datos: () => datosOriginales,
    recargar: () => cargarDatos()
};

console.log('💡 Debug: remuneracionesDebug.datos(), remuneracionesDebug.recargar()');
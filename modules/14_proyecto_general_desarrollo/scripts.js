// =============================================================================
// PROYECTO GENERAL DE DESARROLLO - Script de presentación (UI)
// =============================================================================
// Flujo:
//   config/database.js            → window.getDB('proyecto_desarrollo')
//   api/proyecto_desarrollo.js    → window.ProyectoDesarrolloAPI.getAll()
//   scripts.js (este)             → renderiza la UI
// =============================================================================

let datosCompletos = null;

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 PROYECTO GENERAL DE DESARROLLO INICIADO');
    console.log('═══════════════════════════════════════════════════════');
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS
// =============================================================================

async function cargarDatos() {
    console.log('📥 Cargando documentos...');
    mostrarLoading(true);

    try {
        if (typeof window.ProyectoDesarrolloAPI === 'undefined') {
            throw new Error('ProyectoDesarrolloAPI no disponible. Verificar que api/proyecto_desarrollo.js se cargó.');
        }

        const response = await window.ProyectoDesarrolloAPI.getAll();

        console.log('📦 Respuesta procesada:', response);

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        const tablas = response.data && response.data.tablas ? response.data.tablas : {};

        if (Object.keys(tablas).length === 0) {
            mostrarLoading(false);
            $('#tabsContent').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-folder-open"></i>
                    <h3>No hay documentos disponibles</h3>
                </div>
            `);
            return;
        }

        datosCompletos = response.data;
        console.log('✅ Datos cargados');
        console.log('📊 Facultades:', Object.keys(tablas).length);
        console.log('📊 Total registros:', response.total_registros);

        renderizarPestanas(tablas);

        mostrarLoading(false);
        mostrarToast('✅ Documentos cargados', 'success');

    } catch (error) {
        console.error('❌ Error:', error);
        mostrarLoading(false);
        mostrarError(error.message);
    }
}

// =============================================================================
// RENDERIZAR PESTAÑAS
// =============================================================================

function renderizarPestanas(tablas) {
    const $tabsButtons = $('#tabsButtons');
    const $tabsContent = $('#tabsContent');

    $tabsButtons.empty();
    $tabsContent.empty();

    const facultades = Object.keys(tablas);

    facultades.forEach((facultad, index) => {
        const tabId = `tab-${index}`;
        const isActive = index === 0;

        const nombreCorto = obtenerNombreCorto(facultad);
        const icono = obtenerIcono(facultad);

        // Botón de pestaña
        const $btn = $(`
            <button class="tab-button ${isActive ? 'active' : ''}" data-tab="${tabId}">
                <i class="fas ${icono}"></i>
                <span>${nombreCorto}</span>
            </button>
        `);

        $btn.on('click', function() {
            $('.tab-button').removeClass('active');
            $(this).addClass('active');
            $('.tab-pane').removeClass('active');
            $(`#${tabId}`).addClass('active');
        });

        $tabsButtons.append($btn);

        // Contenido de pestaña
        const $pane = $(`<div class="tab-pane ${isActive ? 'active' : ''}" id="${tabId}"></div>`);

        // Header
        $pane.append($(`
            <div class="facultad-header">
                <h3>
                    <i class="fas fa-building"></i>
                    ${facultad}
                </h3>
            </div>
        `));

        // Tabla
        $pane.append(crearTablaDocumentos(tablas[facultad]));

        $tabsContent.append($pane);
    });

    console.log('✅ Pestañas renderizadas:', facultades.length);
}

// =============================================================================
// CREAR TABLA DE DOCUMENTOS
// =============================================================================

function crearTablaDocumentos(filas) {
    const $wrapper = $('<div>', { class: 'table-responsive' });
    const $table = $('<table>', { class: 'tabla-facultad' });

    // Header
    const $thead = $('<thead>');
    $thead.append(`
        <tr>
            <th>ESCUELA PROFESIONAL</th>
            <th><i class="fas fa-file-pdf"></i> PEI</th>
            <th><i class="fas fa-file-pdf"></i> PGD</th>
            <th><i class="fas fa-file-pdf"></i> COPEA</th>
        </tr>
    `);
    $table.append($thead);

    // Body
    const $tbody = $('<tbody>');

    filas.forEach(fila => {
        const esFacultad = fila.nivel === 'Facultad';

        const $tr = $('<tr>', {
            class: esFacultad ? 'fila-facultad' : 'fila-escuela'
        });

        // Nombre / icono según nivel
        const nombre = esFacultad ? 'Documentos de la Facultad' : fila.escuela;
        const iconoNombre = esFacultad ? 'fa-building' : 'fa-school';

        $tr.append($('<td>', {
            class: 'celda-nombre',
            html: `<i class="fas ${iconoNombre}"></i> ${nombre}`
        }));

        // PEI | PGD | COPEA
        const campos = [
            { key: 'pei_enlace',   colorClass: 'pdf-azul',    etiqueta: 'PEI' },
            { key: 'pgd_enlace',   colorClass: 'pdf-celeste', etiqueta: 'PGD' },
            { key: 'copea_enlace', colorClass: 'pdf-verde',   etiqueta: 'COPEA' }
        ];

        campos.forEach(campo => {
            const enlace = fila[campo.key];
            const $td = $('<td>', { class: 'celda-icono' });

            if (enlace && enlace.trim() !== '') {
                $td.append($('<a>', {
                    href: enlace,
                    target: '_blank',
                    class: `icono-pdf ${campo.colorClass}`,
                    title: `Ver ${campo.etiqueta}`,
                    html: '<i class="fas fa-file-pdf"></i>'
                }));
            } else {
                $td.html('<span class="no-disponible">-</span>');
            }

            $tr.append($td);
        });

        $tbody.append($tr);
    });

    $table.append($tbody);
    $wrapper.append($table);

    return $wrapper;
}

// =============================================================================
// UTILIDADES
// =============================================================================

function obtenerNombreCorto(nombreCompleto) {
    const nombres = {
        'FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES': 'Ciencias Económicas',
        'FACULTAD DE CIENCIAS Y HUMANIDADES': 'Ciencias y Humanidades',
        'FACULTAD DE DERECHO Y CIENCIA POLÍTICA': 'Derecho y C. Política',
        'FACULTAD DE INGENIERÍA Y ARQUITECTURA': 'Ingeniería y Arquitectura',
        'FACULTAD DE CIENCIAS DE LA SALUD': 'Ciencias de la Salud'
    };
    return nombres[nombreCompleto] || nombreCompleto;
}

function obtenerIcono(nombreCompleto) {
    const iconos = {
        'FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES': 'fa-chart-line',
        'FACULTAD DE CIENCIAS Y HUMANIDADES': 'fa-book',
        'FACULTAD DE DERECHO Y CIENCIA POLÍTICA': 'fa-gavel',
        'FACULTAD DE INGENIERÍA Y ARQUITECTURA': 'fa-drafting-compass',
        'FACULTAD DE CIENCIAS DE LA SALUD': 'fa-heartbeat'
    };
    return iconos[nombreCompleto] || 'fa-university';
}

function mostrarLoading(show) {
    $('#loadingOverlay')[show ? 'fadeIn' : 'fadeOut'](300);
}

function mostrarToast(mensaje, tipo = 'info') {
    const icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', info: 'fa-info-circle' };
    $('#toast').html(`<i class="fas ${icons[tipo]}"></i> ${mensaje}`)
               .removeClass().addClass(`toast ${tipo}`).fadeIn(300);
    setTimeout(() => $('#toast').fadeOut(300), 4000);
}

function mostrarError(mensaje) {
    $('#tabsContent').html(`
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
window.proyectoDebug = {
    datos: () => datosCompletos,
    recargar: () => cargarDatos()
};

console.log('💡 Debug: proyectoDebug.datos(), proyectoDebug.recargar()');
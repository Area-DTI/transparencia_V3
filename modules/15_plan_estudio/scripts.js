// =============================================================================
// PLANES DE ESTUDIO - Sistema con pestañas tipo botón
// =============================================================================
// Flujo de datos:
//   config/database.js  → window.getDB('plan_estudios')  → fetch a Apps Script
//   api/plan_estudios.js → window.getPlanEstudiosData()  → organiza en { facultades, anios_disponibles }
//   scripts.js (este)   → llama getPlanEstudiosData()    → renderiza la UI
// =============================================================================

let datosCompletos = null;

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 PLANES DE ESTUDIO INICIADO');
    console.log('═══════════════════════════════════════════════════════');
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS (usa api/plan_estudios.js)
// =============================================================================

async function cargarDatos() {
    console.log('📥 Cargando datos...');
    mostrarLoading(true);

    try {
        // Verificar que la API layer está disponible
        if (typeof window.getPlanEstudiosData !== 'function') {
            throw new Error('getPlanEstudiosData no disponible. Verificar que api/plan_estudios.js se cargó correctamente.');
        }

        // Llamar a la API centralizada que retorna { success, data: { facultades, anios_disponibles } }
        const response = await window.getPlanEstudiosData();

        console.log('📦 Respuesta procesada:', response);

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        if (!response.data || !response.data.facultades) {
            throw new Error('Estructura de datos incompleta');
        }

        datosCompletos = response.data;
        console.log('✅ Datos cargados');
        console.log('📊 Facultades:', datosCompletos.facultades.length);
        console.log('📅 Años disponibles:', datosCompletos.anios_disponibles);

        renderizarPestanas(datosCompletos);

        mostrarLoading(false);
        mostrarToast('✅ Planes de estudio cargados', 'success');

    } catch (error) {
        console.error('❌ Error:', error);
        mostrarLoading(false);
        mostrarError(error.message);
    }
}

// =============================================================================
// RENDERIZAR PESTAÑAS
// =============================================================================

function renderizarPestanas(data) {
    const $tabsButtons = $('#tabsButtons');
    const $tabsContent = $('#tabsContent');

    $tabsButtons.empty();
    $tabsContent.empty();

    if (!data.facultades || data.facultades.length === 0) {
        $tabsContent.html(`
            <div class="mensaje-vacio">
                <i class="fas fa-info-circle"></i>
                <h3>No hay planes disponibles</h3>
            </div>
        `);
        return;
    }

    const aniosDisponibles = data.anios_disponibles || [];

    data.facultades.forEach((facultad, index) => {
        const tabId = `tab-${index}`;
        const isActive = index === 0;

        const nombreCorto = obtenerNombreCorto(facultad.nombre);
        const icono = obtenerIcono(facultad.nombre);

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

        // Header de facultad
        $pane.append($(`
            <div class="facultad-header">
                <h3>
                    <i class="fas fa-building"></i>
                    ${facultad.nombre}
                </h3>
            </div>
        `));

        // Tabla de planes
        $pane.append(crearTablaPlanes(facultad, aniosDisponibles));

        $tabsContent.append($pane);
    });

    console.log('✅ Pestañas renderizadas');
}

// =============================================================================
// CREAR TABLA DE PLANES
// =============================================================================

function crearTablaPlanes(facultad, aniosDisponibles) {
    const $wrapper = $('<div>', { class: 'table-responsive' });
    const $table = $('<table>', { class: 'planes-table' });

    // --- THEAD ---
    const $thead = $('<thead>');

    // Fila 1: ESCUELA PROFESIONAL | PLANES DE ESTUDIO (colspan)
    const $row1 = $('<tr>');
    $row1.append($('<th>', { class: 'th-escuela', text: 'ESCUELA PROFESIONAL' }));
    $row1.append($('<th>', {
        class: 'th-anios',
        colspan: aniosDisponibles.length,
        html: '<i class="fas fa-calendar-alt"></i> PLANES DE ESTUDIO'
    }));
    $thead.append($row1);

    // Fila 2: años individuales
    const $row2 = $('<tr>', { class: 'sub-header' });
    $row2.append($('<th>'));
    aniosDisponibles.forEach(anio => {
        $row2.append($('<th>', { class: 'th-anio', text: anio }));
    });
    $thead.append($row2);

    $table.append($thead);

    // --- TBODY ---
    const $tbody = $('<tbody>');

    facultad.escuelas.forEach(escuela => {
        const $row = $('<tr>');

        // Nombre de escuela
        $row.append($('<td>', {
            class: 'td-escuela',
            html: `<i class="fas fa-graduation-cap"></i> ${escuela.escuela}`
        }));

        // Una celda por año
        aniosDisponibles.forEach(anio => {
            const plan = escuela.planes[anio];
            const $td = $('<td>', { class: 'td-pdf text-center' });

            if (plan && plan.tiene_pdf && plan.url_pdf) {
                const color = plan.color || '#00417b';
                $td.append($('<a>', {
                    href: plan.url_pdf,
                    target: '_blank',
                    class: 'btn-pdf',
                    html: `<i class="fas fa-file-pdf" style="color: ${color};"></i>`,
                    title: `Ver plan de estudio ${anio}`
                }));
            } else {
                $td.html('<span class="no-disponible">-</span>');
            }

            $row.append($td);
        });

        $tbody.append($row);
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
            <h3>Error al cargar planes</h3>
            <p>${mensaje}</p>
            <button class="btn-reintentar" onclick="cargarDatos()">
                <i class="fas fa-sync-alt"></i> Reintentar
            </button>
        </div>
    `);
}

// Debug en consola
window.planesDebug = {
    datos: () => datosCompletos,
    recargar: () => cargarDatos()
};

console.log('💡 Debug: planesDebug.datos(), planesDebug.recargar()');
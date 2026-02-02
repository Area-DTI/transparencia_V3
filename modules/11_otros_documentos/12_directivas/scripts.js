// =============================================================================
// DIRECTIVAS UAC - Sistema de Secciones y Tablas
// Universidad Andina del Cusco - Portal de Transparencia
// =============================================================================

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('🚀 Módulo Directivas Iniciado');
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS
// =============================================================================

async function cargarDatos() {
    mostrarLoading(true);

    try {
        // Verificar que la función de datos está disponible
        if (typeof window.getDirectivasData !== 'function') {
            throw new Error('getDirectivasData no disponible. Verificar que /api/directivas.js se cargó correctamente.');
        }

        const response = await window.getDirectivasData();

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido al obtener datos');
        }

        const secciones = response.secciones || [];

        if (secciones.length === 0) {
            $('#directivasContainer').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-book"></i>
                    <h3>No hay directivas disponibles</h3>
                    <p>Las directivas se publicarán próximamente</p>
                </div>
            `);
            mostrarLoading(false);
            return;
        }

        console.log('✅ Secciones cargadas:', secciones.length);

        renderizarSecciones(secciones);
        mostrarLoading(false);
        mostrarToast(`${response.total} directivas cargadas`, 'success');

    } catch (error) {
        console.error('❌ Error al cargar datos:', error);
        mostrarLoading(false);
        
        $('#directivasContainer').html(`
            <div class="mensaje-vacio">
                <i class="fas fa-exclamation-triangle" style="color: var(--error);"></i>
                <h3 style="color: var(--error);">Error al cargar directivas</h3>
                <p>${escapeHtml(error.message)}</p>
                <button class="btn-reintentar" onclick="cargarDatos()">
                    <i class="fas fa-sync-alt"></i> Reintentar
                </button>
            </div>
        `);
    }
}

// =============================================================================
// RENDERIZAR TODAS LAS SECCIONES
// =============================================================================

function renderizarSecciones(secciones) {
    const $container = $('#directivasContainer');
    $container.empty();

    secciones.forEach((seccion, index) => {
        $container.append(construirSeccion(seccion, index));
    });

    console.log('✅ Secciones renderizadas:', secciones.length);
}

// =============================================================================
// CONSTRUIR UNA SECCIÓN (título + tabla)
// =============================================================================

function construirSeccion(seccion, uid) {
    // Contar subdirectivas para el badge
    let totalSubs = 0;
    seccion.directivas.forEach(d => { 
        totalSubs += (d.subdirectivas ? d.subdirectivas.length : 0); 
    });

    const totalPrincipales = seccion.directivas.length;

    // Construir filas
    let filas = '';

    seccion.directivas.forEach(dir => {
        // Fila directiva principal
        filas += `
            <tr class="fila-principal">
                <td class="celda-titulo">${escapeHtml(dir.titulo)}</td>
                <td class="celda-resolucion">${dir.resolucion ? escapeHtml(dir.resolucion) : '—'}</td>
                <td class="celda-pdf">
                    <a href="${escapeHtml(dir.enlace)}" 
                       target="_blank" 
                       rel="noopener noreferrer" 
                       class="btn-pdf-icon" 
                       title="Ver documento PDF"
                       aria-label="Ver PDF: ${escapeHtml(dir.titulo)}">
                        <i class="fas fa-file-pdf"></i>
                    </a>
                </td>
            </tr>`;

        // Subdirectivas anidadas
        if (dir.subdirectivas && dir.subdirectivas.length > 0) {
            dir.subdirectivas.forEach(sub => {
                filas += `
                    <tr class="fila-subdirectiva">
                        <td class="celda-titulo">
                            <span class="sub-indicador">↳</span>
                            ${escapeHtml(sub.titulo)}
                        </td>
                        <td class="celda-resolucion">${sub.resolucion ? escapeHtml(sub.resolucion) : '—'}</td>
                        <td class="celda-pdf">
                            <a href="${escapeHtml(sub.enlace)}" 
                               target="_blank" 
                               rel="noopener noreferrer" 
                               class="btn-pdf-icon btn-pdf-sub" 
                               title="Ver documento PDF"
                               aria-label="Ver PDF: ${escapeHtml(sub.titulo)}">
                                <i class="fas fa-file-pdf"></i>
                            </a>
                        </td>
                    </tr>`;
            });
        }
    });

    // Badge con conteo
    let badgeText = `<i class="fas fa-file-alt"></i> ${totalPrincipales} directiva${totalPrincipales !== 1 ? 's' : ''}`;
    if (totalSubs > 0) {
        badgeText += ` · ${totalSubs} modificación${totalSubs !== 1 ? 'es' : ''}`;
    }

    return `
        <section class="seccion-directivas" aria-labelledby="seccion-titulo-${uid}">
            <div class="seccion-head">
                <h2 class="seccion-titulo" id="seccion-titulo-${uid}">${escapeHtml(seccion.nombre.toUpperCase())}</h2>
                <span class="seccion-badge">${badgeText}</span>
            </div>
            <div class="tabla-wrapper">
                <table class="tabla-directivas" id="tabla-${uid}" role="table">
                    <thead>
                        <tr>
                            <th class="th-titulo" scope="col">Título</th>
                            <th class="th-resolucion" scope="col">Resolución</th>
                            <th class="th-pdf" scope="col">PDF</th>
                        </tr>
                    </thead>
                    <tbody>${filas}</tbody>
                </table>
            </div>
        </section>`;
}

// =============================================================================
// UTILIDADES
// =============================================================================

/**
 * Escapa caracteres HTML para prevenir XSS
 */
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * Muestra u oculta el overlay de carga
 */
function mostrarLoading(show) {
    const $overlay = $('#loadingOverlay');
    if (show) {
        $overlay.fadeIn(200);
    } else {
        $overlay.fadeOut(300);
    }
}

/**
 * Muestra una notificación toast
 */
function mostrarToast(mensaje, tipo = 'success') {
    const icons = {
        success: 'fa-check-circle',
        error: 'fa-exclamation-circle',
        info: 'fa-info-circle',
        warning: 'fa-exclamation-triangle'
    };

    const $toast = $('#toast');
    
    $toast
        .html(`<i class="fas ${icons[tipo] || icons.info}"></i> ${escapeHtml(mensaje)}`)
        .removeClass('success error info warning')
        .addClass(`toast ${tipo}`)
        .fadeIn(300);

    setTimeout(() => {
        $toast.fadeOut(400);
    }, 4000);
}

// =============================================================================
// DEBUG
// =============================================================================

window.directivasDebug = {
    recargar: () => cargarDatos(),
    version: '2.0.0'
};

console.log('📋 Debug disponible: window.directivasDebug.recargar()');
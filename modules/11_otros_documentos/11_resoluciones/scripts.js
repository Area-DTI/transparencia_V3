// =============================================================================
// RESOLUCIONES UAC - Sistema de Tabs y Tablas
// Universidad Andina del Cusco - Portal de Transparencia
// =============================================================================

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('🚀 Módulo Resoluciones Iniciado');
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS
// =============================================================================

async function cargarDatos() {
    mostrarLoading(true);

    try {
        // Verificar que la función de datos está disponible
        if (typeof window.getResolucionesData !== 'function') {
            throw new Error('getResolucionesData no disponible. Verificar que /api/resoluciones.js se cargó correctamente.');
        }

        const response = await window.getResolucionesData();

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido al obtener datos');
        }

        const grupos = response.grupos || [];

        if (grupos.length === 0) {
            $('#tabsContent').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-file-contract"></i>
                    <h3>No hay resoluciones disponibles</h3>
                    <p>Las resoluciones se publicarán próximamente</p>
                </div>
            `);
            mostrarLoading(false);
            return;
        }

        console.log('✅ Grupos cargados:', grupos.length);

        renderizarTabs(grupos);
        mostrarLoading(false);
        mostrarToast(`${response.total} resoluciones cargadas`, 'success');

    } catch (error) {
        console.error('❌ Error al cargar datos:', error);
        mostrarLoading(false);
        
        $('#tabsContent').html(`
            <div class="mensaje-vacio">
                <i class="fas fa-exclamation-triangle" style="color: var(--error);"></i>
                <h3 style="color: var(--error);">Error al cargar resoluciones</h3>
                <p>${escapeHtml(error.message)}</p>
                <button class="btn-reintentar" onclick="cargarDatos()">
                    <i class="fas fa-sync-alt"></i> Reintentar
                </button>
            </div>
        `);
    }
}

// =============================================================================
// RENDERIZAR TABS (uno por Grupo)
// =============================================================================

function renderizarTabs(grupos) {
    const $header = $('#tabsHeader');
    const $content = $('#tabsContent');

    $header.empty();
    $content.empty();

    grupos.forEach((grupo, index) => {
        const tabId = `tab-${index}`;
        const isActive = index === 0;

        // ── Botón de tab ──
        const $btn = $('<button>', {
            class: `tab-btn ${isActive ? 'active' : ''}`,
            'data-tab': tabId,
            'aria-selected': isActive,
            'role': 'tab',
            html: `<i class="fas fa-folder"></i> ${escapeHtml(grupo.nombre)}`
        });

        $btn.on('click', function() {
            // Remover activo de todos
            $('.tab-btn').removeClass('active').attr('aria-selected', 'false');
            $('.tab-pane').removeClass('active');
            
            // Activar el seleccionado
            $(this).addClass('active').attr('aria-selected', 'true');
            $(`#${tabId}`).addClass('active');
        });

        $header.append($btn);

        // ── Panel de contenido ──
        const $pane = $('<div>', {
            class: `tab-pane ${isActive ? 'active' : ''}`,
            id: tabId,
            'role': 'tabpanel'
        });

        // Agregar subgrupos
        grupo.subgrupos.forEach((subgrupo, subIndex) => {
            $pane.append(construirSubgrupo(subgrupo, `${index}-${subIndex}`));
        });

        $content.append($pane);
    });

    console.log('✅ Tabs renderizados:', grupos.length);
}

// =============================================================================
// CONSTRUIR SECCIÓN DE UN SUBGRUPO
// =============================================================================

function construirSubgrupo(subgrupo, uid) {
    const $section = $('<div>', { class: 'subgrupo-section' });

    // Si tiene nombre de subgrupo → agregar header
    if (subgrupo.nombre) {
        $section.append(
            $('<div>', {
                class: 'subgrupo-header',
                html: `<h3><i class="fas fa-folder-open"></i> ${escapeHtml(subgrupo.nombre)}</h3>`
            })
        );
    }

    // Tabla de resoluciones
    $section.append(construirTabla(subgrupo.resoluciones, `tabla-${uid}`));

    return $section;
}

// =============================================================================
// CONSTRUIR TABLA DE RESOLUCIONES
// =============================================================================

function construirTabla(resoluciones, tableId) {
    let filas = '';

    resoluciones.forEach(res => {
        // Fila principal
        filas += `
            <tr class="fila-principal">
                <td class="celda-descripcion">${escapeHtml(res.descripcion)}</td>
                <td class="celda-numero">${escapeHtml(res.numero)}</td>
                <td class="celda-pdf">
                    <a href="${escapeHtml(res.enlace)}" 
                       target="_blank" 
                       rel="noopener noreferrer" 
                       class="btn-pdf-icon" 
                       title="Ver PDF"
                       aria-label="Ver documento PDF: ${escapeHtml(res.numero)}">
                        <i class="fas fa-file-pdf"></i>
                    </a>
                </td>
            </tr>`;

        // Subresoluciones anidadas
        if (res.subresoluciones && res.subresoluciones.length > 0) {
            res.subresoluciones.forEach(sub => {
                filas += `
                    <tr class="fila-subresolucion">
                        <td class="celda-descripcion">
                            <span class="sub-indicador">↳</span>
                            ${escapeHtml(sub.descripcion)}
                        </td>
                        <td class="celda-numero">${escapeHtml(sub.numero)}</td>
                        <td class="celda-pdf">
                            <a href="${escapeHtml(sub.enlace)}" 
                               target="_blank" 
                               rel="noopener noreferrer" 
                               class="btn-pdf-icon btn-pdf-sub" 
                               title="Ver PDF"
                               aria-label="Ver documento PDF: ${escapeHtml(sub.numero)}">
                                <i class="fas fa-file-pdf"></i>
                            </a>
                        </td>
                    </tr>`;
            });
        }
    });

    return `
        <div class="tabla-wrapper">
            <table class="tabla-resoluciones" id="${tableId}">
                <thead>
                    <tr>
                        <th class="th-descripcion" scope="col">Descripción</th>
                        <th class="th-numero" scope="col">N° Resolución</th>
                        <th class="th-pdf" scope="col">PDF</th>
                    </tr>
                </thead>
                <tbody>${filas}</tbody>
            </table>
        </div>`;
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
// ACCESIBILIDAD - Navegación por teclado
// =============================================================================

$(document).on('keydown', '.tab-btn', function(e) {
    const $tabs = $('.tab-btn');
    const currentIndex = $tabs.index(this);
    let newIndex = currentIndex;

    switch(e.key) {
        case 'ArrowLeft':
        case 'ArrowUp':
            newIndex = currentIndex > 0 ? currentIndex - 1 : $tabs.length - 1;
            e.preventDefault();
            break;
        case 'ArrowRight':
        case 'ArrowDown':
            newIndex = currentIndex < $tabs.length - 1 ? currentIndex + 1 : 0;
            e.preventDefault();
            break;
        case 'Home':
            newIndex = 0;
            e.preventDefault();
            break;
        case 'End':
            newIndex = $tabs.length - 1;
            e.preventDefault();
            break;
        default:
            return;
    }

    $tabs.eq(newIndex).focus().click();
});

// =============================================================================
// DEBUG
// =============================================================================

window.resolucionesDebug = {
    recargar: () => cargarDatos(),
    version: '2.0.0'
};

console.log('📋 Debug disponible: window.resolucionesDebug.recargar()');
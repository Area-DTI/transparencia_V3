// =============================================================================
// DOCUMENTOS NORMATIVOS UAC — Tabs Pill + Dropdown Subitems
// =============================================================================
//
// Layout:
//
//   ( DOCUMENTOS NORMATIVOS )  ( POLÍTICAS )  ( PLANES )  ( DECÁLOGOS )   ← pill tabs
//   ┌────────────────────────────────────────────┬──────────────────┬─────┐
//   │ TÍTULO                                     │ RESOLUCIÓN       │ PDF │
//   ├────────────────────────────────────────────┼──────────────────┼─────┤
//   │ ▼ ESTATUTO UAC          [51 mods]          │ Res. N°009-...   │  📄 │  ← clickeable
//   │   ├─ Reforman en parte…                    │ Res. N°015-...   │  📄 │  ← dropdown abierto
//   │   ├─ Reforman en parte…                    │ Res. N°014-...   │  📄 │
//   │   └─ …                                     │ …                │  📄 │
//   │ TUPA UAC 2026                              │ Res. N°710-...   │  📄 │  ← sin dropdown
//   │ ▶ ROF                   [13 mods]          │ Res. N°477-...   │  📄 │  ← cerrado
//   └────────────────────────────────────────────┴──────────────────┴─────┘
//
// =============================================================================

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('🚀 MÓDULO DOCUMENTOS NORMATIVOS INICIADO');
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS
// =============================================================================

async function cargarDatos() {
    mostrarLoading(true);

    try {
        if (typeof window.getDocNormativosData !== 'function') {
            throw new Error('getDocNormativosData no disponible. Verificar que api/doc_normativos.js se cargó.');
        }

        const response = await window.getDocNormativosData();

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        const secciones = response.secciones || [];

        if (secciones.length === 0) {
            $('#tabsContent').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-folder-open"></i>
                    <h3>No hay documentos disponibles</h3>
                    <p>Los documentos normativos se publican próximamente</p>
                </div>
            `);
            mostrarLoading(false);
            return;
        }

        console.log('✅ Secciones cargadas:', secciones.length);

        renderizarTabs(secciones);
        mostrarLoading(false);
        mostrarToast(`✅ ${response.total} documentos cargados`, 'success');

    } catch (error) {
        console.error('❌ Error:', error);
        mostrarLoading(false);
        $('#tabsContent').html(`
            <div class="mensaje-vacio">
                <i class="fas fa-exclamation-triangle" style="color:#dc3545;"></i>
                <h3 style="color:#dc3545;">Error al cargar documentos</h3>
                <p>${error.message}</p>
                <button class="btn-reintentar" onclick="cargarDatos()">
                    <i class="fas fa-sync-alt"></i> Reintentar
                </button>
            </div>
        `);
    }
}

// =============================================================================
// RENDERIZAR TABS
// =============================================================================

function renderizarTabs(secciones) {
    const $header  = $('#tabsHeader');
    const $content = $('#tabsContent');

    $header.empty();
    $content.empty();

    secciones.forEach((seccion, index) => {
        const isActive = (index === 0);
        const tabId    = `tab-${index}`;

        // Total documentos (principales + subitems)
        const totalDocs = seccion.documentos.length;
        const totalSubs = seccion.documentos.reduce((acc, d) => acc + (d.subitems ? d.subitems.length : 0), 0);

        // Botón pill
        $header.append(`
            <button class="tab-btn ${isActive ? 'active' : ''}" data-tab="${tabId}">
                <i class="fas fa-folder"></i>
                ${seccion.nombre}
                <span class="tab-badge">${totalDocs + totalSubs}</span>
            </button>
        `);

        // Panel de contenido
        $content.append(`
            <div class="tab-pane ${isActive ? 'active' : ''}" id="${tabId}">
                ${construirTabla(seccion, index)}
            </div>
        `);
    });

    // Eventos tabs
    $('.tab-btn').off('click').on('click', function() {
        const tabId = $(this).data('tab');

        $('.tab-btn').removeClass('active');
        $(this).addClass('active');

        $('.tab-pane').removeClass('active');
        $(`#${tabId}`).addClass('active');
    });

    // Delegar eventos de expand/collapse en las filas principales con subitems
    $('#tabsContent').off('click', '.fila-principal.tiene-subitems')
                    .on('click', '.fila-principal.tiene-subitems', function(e) {
        // Si hizo click en el botón PDF, no expandir
        if ($(e.target).closest('.btn-pdf-icon').length) return;

        const $fila = $(this);
        const dropdownId = $fila.data('dropdown');
        const $dropdown  = $(`#${dropdownId}`);

        $fila.toggleClass('open');
        $dropdown.toggleClass('open');
    });

    console.log('✅ Tabs renderizados:', secciones.length);
}

// =============================================================================
// CONSTRUIR TABLA DE UNA SECCIÓN
// =============================================================================

function construirTabla(seccion, uid) {
    let filas = '';

    seccion.documentos.forEach((doc, docIndex) => {
        const hasSubs      = doc.subitems && doc.subitems.length > 0;
        const dropdownId   = `dropdown-${uid}-${docIndex}`;
        const tieneSubsClass = hasSubs ? 'tiene-subitems' : '';

        // ── Fila principal ──
        let titleContent = escapeHtml(doc.titulo);

        if (hasSubs) {
            titleContent = `
                <span class="expand-caret"><i class="fas fa-chevron-down"></i></span>
                <span>${escapeHtml(doc.titulo)}</span>
                <span class="mod-badge"><i class="fas fa-pen"></i> ${doc.subitems.length} modif.</span>
            `;
        }

        filas += `
            <tr class="fila-principal ${tieneSubsClass}" ${hasSubs ? `data-dropdown="${dropdownId}"` : ''}>
                <td class="celda-titulo">${titleContent}</td>
                <td class="celda-resolucion">${doc.resolucion ? escapeHtml(doc.resolucion) : '—'}</td>
                <td class="celda-pdf">
                    <a href="${doc.enlace}" target="_blank" rel="noopener noreferrer" class="btn-pdf-icon" title="Ver PDF">
                        <i class="fas fa-file-pdf"></i>
                    </a>
                </td>
            </tr>`;

        // ── Dropdown de subitems ──
        if (hasSubs) {
            let subFilas = '';
            doc.subitems.forEach(sub => {
                subFilas += `
                    <tr class="fila-subitem">
                        <td class="celda-titulo">
                            <span class="sub-indicador">↳</span>
                            <span>${escapeHtml(sub.titulo)}</span>
                        </td>
                        <td class="celda-resolucion">${sub.resolucion ? escapeHtml(sub.resolucion) : '—'}</td>
                        <td class="celda-pdf">
                            <a href="${sub.enlace}" target="_blank" rel="noopener noreferrer" class="btn-pdf-icon btn-pdf-sub" title="Ver PDF">
                                <i class="fas fa-file-pdf"></i>
                            </a>
                        </td>
                    </tr>`;
            });

            filas += `
                <tr>
                    <td colspan="3" style="padding:0; border-bottom: 1px solid var(--border-soft);">
                        <div class="dropdown-subitems" id="${dropdownId}">
                            <table>
                                <tbody>${subFilas}</tbody>
                            </table>
                        </div>
                    </td>
                </tr>`;
        }
    });

    return `
        <div class="tabla-wrapper">
            <table class="tabla-doc-normativos" id="tabla-${uid}">
                <thead>
                    <tr>
                        <th class="th-titulo">TÍTULO</th>
                        <th class="th-resolucion">RESOLUCIÓN</th>
                        <th class="th-pdf">PDF</th>
                    </tr>
                </thead>
                <tbody>${filas}</tbody>
            </table>
        </div>`;
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

// =============================================================================
// DEBUG
// =============================================================================
window.docNormativosDebug = {
    recargar: () => cargarDatos()
};
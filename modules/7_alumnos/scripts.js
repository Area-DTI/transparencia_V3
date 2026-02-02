// =============================================================================
// ALUMNOS - Tablas Pivot por Sección (TRANSPUESTO)
// =============================================================================
// Layout:
//   Primera columna = AÑO
//   Columnas siguientes = cada categoría (texto abreviado + tooltip completo)
//   Celdas = icono PDF si hay enlace, vacía si no
// =============================================================================

const ORDEN_SECCIONES = ['Pregrado', 'Posgrado', 'Segundas Especialidades'];

// =============================================================================
// ABREVIAR CATEGORÍA
// Extrae la palabra clave del texto sin importar la variación exacta.
// Funciona para cualquier dato que contenga alguna de esas palabras.
// El texto completo se muestra en el title (tooltip al hover).
// =============================================================================
function abreviarCategoria(texto) {
    if (!texto) return texto;

    const str = texto.toUpperCase();

    if (str.includes('MATRICULAD'))  return 'Matriculados';
    if (str.includes('POSTULANT'))   return 'Postulantes';
    if (str.includes('INGRESANT'))   return 'Ingresantes';
    if (str.includes('EGRESAD'))     return 'Egresados';
    if (str.includes('GRADUAD'))     return 'Graduados';

    // Si no matchea ninguna palabra clave, retorna el texto original
    return texto;
}

const COLOR_SECCION = {
    'Pregrado':                'seccion-pregrado',
    'Posgrado':                'seccion-posgrado',
    'Segundas Especialidades': 'seccion-segesp'
};

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('🚀 MÓDULO ALUMNOS (pivot transpuesto) INICIADO');
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS
// =============================================================================

async function cargarDatos() {
    mostrarLoading(true);

    try {
        if (typeof window.getAlumnosData !== 'function') {
            throw new Error('getAlumnosData no disponible. Verificar que api/alumnos.js se cargó.');
        }

        const response = await window.getAlumnosData();

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        const documentos = response.data || [];

        if (documentos.length === 0) {
            $('#documentosAgrupados').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-user-graduate"></i>
                    <h3>No hay documentos disponibles</h3>
                    <p>Los documentos de alumnos se publican próximamente</p>
                </div>
            `);
            mostrarLoading(false);
            return;
        }

        console.log('✅ Documentos cargados:', documentos.length);

        renderizarTodas(documentos);
        mostrarLoading(false);
        mostrarToast(`✅ ${documentos.length} documentos cargados`, 'success');

    } catch (error) {
        console.error('❌ Error:', error);
        mostrarLoading(false);
        $('#documentosAgrupados').html(`
            <div class="mensaje-vacio">
                <i class="fas fa-exclamation-triangle" style="color:#dc3545;"></i>
                <h3 style="color:#dc3545;">Error al cargar datos</h3>
                <p>${error.message}</p>
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

function renderizarTodas(documentos) {
    const $container = $('#documentosAgrupados');
    $container.empty();

    // Agrupar por sección
    const agrupados = {};
    documentos.forEach(doc => {
        const sec = doc.Seccion || 'Sin sección';
        if (!agrupados[sec]) agrupados[sec] = [];
        agrupados[sec].push(doc);
    });

    // Ordenar secciones
    const secciones = Object.keys(agrupados).sort((a, b) => {
        const iA = ORDEN_SECCIONES.indexOf(a);
        const iB = ORDEN_SECCIONES.indexOf(b);
        if (iA === -1 && iB === -1) return a.localeCompare(b);
        if (iA === -1) return 1;
        if (iB === -1) return -1;
        return iA - iB;
    });

    secciones.forEach(seccion => {
        $container.append(construirSeccionPivot(seccion, agrupados[seccion]));
    });

    console.log('✅ Tablas pivot renderizadas:', secciones.length, 'secciones');
}

// =============================================================================
// CONSTRUIR TABLA PIVOT TRANSPUESTO
// Filas = años | Columnas = categorías
// =============================================================================

function construirSeccionPivot(seccion, docs) {

    const claseColor = COLOR_SECCION[seccion] || 'seccion-pregrado';

    // 1) Años únicos ordenados cronológicamente
    const aniosSet = new Set();
    docs.forEach(d => aniosSet.add(d.Anio));

    const anios = Array.from(aniosSet).sort((a, b) => {
        const numA = parseInt(a, 10) || 0;
        const numB = parseInt(b, 10) || 0;
        return numA - numB;
    });

    // 2) Categorías únicas (orden de aparición en el dato)
    const categorias = [];
    docs.forEach(d => {
        if (!categorias.includes(d.Categoria)) categorias.push(d.Categoria);
    });

    // 3) Lookup: categoria → año → enlace
    const pivot = {};
    docs.forEach(d => {
        if (!pivot[d.Categoria]) pivot[d.Categoria] = {};
        pivot[d.Categoria][d.Anio] = d.Enlace;
    });

    // 4) Header: AÑO + categorías abreviadas (title = texto completo para tooltip)
    const headerCategorias = categorias.map(cat =>
        `<th class="th-categoria-col" title="${escapeHtml(cat)}">${escapeHtml(abreviarCategoria(cat))}</th>`
    ).join('');

    // 5) Filas: una por año
    let filas = '';

    anios.forEach(anio => {
        let fila = `<tr>
                        <td class="celda-anio">${escapeHtml(String(anio))}</td>`;

        categorias.forEach(cat => {
            const enlace = pivot[cat]?.[anio] || '';
            if (enlace) {
                fila += `<td class="celda-pdf">
                            <a href="${enlace}" target="_blank" rel="noopener noreferrer" class="btn-pdf-icon" title="${escapeHtml(cat)} – ${anio}">
                                <i class="fas fa-file-pdf"></i>
                            </a>
                        </td>`;
            } else {
                fila += '<td class="celda-pdf"></td>';
            }
        });

        fila += '</tr>';
        filas += fila;
    });

    // 6) HTML completo
    return `
        <div class="seccion-pivot">
            <h2 class="seccion-titulo seccion-titulo-${claseColor}">ALUMNOS ${seccion.toUpperCase()}</h2>
            <div class="tabla-wrapper">
                <table class="tabla-pivot ${claseColor}">
                    <thead>
                        <tr class="header-row">
                            <th class="th-anio">AÑO</th>
                            ${headerCategorias}
                        </tr>
                    </thead>
                    <tbody>
                        ${filas}
                    </tbody>
                </table>
            </div>
        </div>
    `;
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
window.alumnosDebug = {
    recargar: () => cargarDatos()
};
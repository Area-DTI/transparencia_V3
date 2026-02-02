// =============================================================================
// DOCENTES - Tablas Pivot por Sección
// =============================================================================
// Layout:
//   Pregrado          → SEMESTRE | PREGRADO
//   Posgrado          → SEMESTRE | MES | MAESTRÍA | DOCTORADO
//   Seg. Especialidades → SEMESTRE | MES | ESTOMATOLOGÍA | OBSTETRICIA | ENFERMERÍA
//
// Programas se convierten en columnas.
// Meses se convierten en filas.
// Semestre usa rowspan cuando agrupa varios meses.
// =============================================================================

// Orden canónico de secciones
const ORDEN_SECCIONES = ['Pregrado', 'Posgrado', 'Segundas Especialidades'];

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('🚀 MÓDULO DOCENTES (pivot) INICIADO');
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS
// =============================================================================

async function cargarDatos() {
    mostrarLoading(true);

    try {
        if (typeof window.getDocentesData !== 'function') {
            throw new Error('getDocentesData no disponible. Verificar que api/docentes.js se cargó.');
        }

        const response = await window.getDocentesData();

        if (!response.success) {
            throw new Error(response.message || response.error || 'Error desconocido');
        }

        const documentos = response.data || [];

        if (documentos.length === 0) {
            $('#documentosAgrupados').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-chalkboard-teacher"></i>
                    <h3>No hay documentos disponibles</h3>
                    <p>Los documentos de docentes se publican próximamente</p>
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

    // Ordenar secciones según orden canónico
    const secciones = Object.keys(agrupados).sort((a, b) => {
        const iA = ORDEN_SECCIONES.indexOf(a);
        const iB = ORDEN_SECCIONES.indexOf(b);
        if (iA === -1 && iB === -1) return a.localeCompare(b);
        if (iA === -1) return 1;
        if (iB === -1) return -1;
        return iA - iB;
    });

    secciones.forEach(seccion => {
        const docs = agrupados[seccion];
        const html = construirSeccionPivot(seccion, docs);
        $container.append(html);
    });

    console.log('✅ Tablas pivot renderizadas:', secciones.length, 'secciones');
}

// =============================================================================
// CONSTRUIR TABLA PIVOT DE UNA SECCIÓN
// =============================================================================

function construirSeccionPivot(seccion, docs) {
    // 1) Obtener programas únicos (orden de aparición en datos)
    const programas = [];
    docs.forEach(d => {
        if (d.Programa && !programas.includes(d.Programa)) {
            programas.push(d.Programa);
        }
    });

    // 2) Detectar si esta sección usa Mes
    const hasMes = docs.some(d => d.Mes && d.Mes !== '');

    // 3) Construir lookup: semestre → mes → programa → enlace
    //    Para secciones sin mes, usamos mes = '' (una sola fila por semestre)
    const pivot = {};
    docs.forEach(d => {
        const sem = d.Semestre || '-';
        const mes = hasMes ? (d.Mes || '') : '';
        if (!pivot[sem]) pivot[sem] = {};
        if (!pivot[sem][mes]) pivot[sem][mes] = {};
        pivot[sem][mes][d.Programa] = d.Enlace;
    });

    // 4) Obtener semestres ordenados (más reciente primero)
    const semestres = Object.keys(pivot).sort().reverse();

    // 5) Obtener categoría (es la misma para todos los docs de la sección)
    const categoria = docs[0]?.Categoria || '';

    // 6) Construir HTML de la tabla
    let filas = '';

    semestres.forEach(semestre => {
        const meses = Object.keys(pivot[semestre]);
        // Ordenar meses cronológicamente
        const ordenMeses = ['', 'Enero','Febrero','Marzo','Abril','Mayo','Junio',
                            'Julio','Agosto','Setiembre','Septiembre','Octubre','Noviembre','Diciembre'];
        meses.sort((a, b) => {
            const iA = ordenMeses.indexOf(a);
            const iB = ordenMeses.indexOf(b);
            return (iA === -1 ? 999 : iA) - (iB === -1 ? 999 : iB);
        });

        const rowspan = meses.length;

        meses.forEach((mes, index) => {
            let fila = '<tr>';

            // Celda SEMESTRE (solo en la primera fila del grupo, con rowspan)
            if (index === 0) {
                fila += `<td class="celda-semestre" rowspan="${rowspan}">${semestre}</td>`;
            }

            // Celda MES (solo si la sección tiene mes)
            if (hasMes) {
                fila += `<td class="celda-mes">${mes || '-'}</td>`;
            }

            // Celdas de cada programa (PDF o vacío)
            programas.forEach(programa => {
                const enlace = pivot[semestre][mes]?.[programa] || '';
                if (enlace) {
                    fila += `<td class="celda-pdf">
                                <a href="${enlace}" target="_blank" rel="noopener noreferrer" class="btn-pdf-icon" title="Ver PDF - ${programa}">
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
    });

    // 7) Construir headers de columna
    let headerProgramas = programas.map(p =>
        `<th>${p.toUpperCase()}</th>`
    ).join('');

    let headerMes = hasMes ? '<th>MES</th>' : '';

    // 8) HTML completo de la sección
    return `
        <div class="seccion-pivot">
            <h2 class="seccion-titulo">DOCENTES ${seccion.toUpperCase()}</h2>
            <div class="tabla-wrapper">
                <table class="tabla-pivot">
                    <thead>
                        <tr>
                            <th colspan="${2 + programas.length - (hasMes ? 0 : 1)}" class="caption-row">
                                ${categoria}
                            </th>
                        </tr>
                        <tr class="header-row">
                            <th>SEMESTRE</th>
                            ${headerMes}
                            ${headerProgramas}
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
window.docentesDebug = {
    recargar: () => cargarDatos()
};


// =============================================================================
// INVESTIGACIÓN - Sistema con pestañas: DGI, Instituto Científico, Tesis
// Versión: Google Apps Script + JS API + CACHÉ + CORRECCIÓN TIPOS
// =============================================================================

let datosCompletos = null;
let intentosRecarga = 0;
const MAX_INTENTOS = 3;

// =============================================================================
// SISTEMA DE CACHÉ
// =============================================================================

const CACHE_CONFIG = {
    KEY: 'investigacion_cache_data',
    DURACION_MINUTOS: 30,
    VERSION: 'v2' // Incrementado para invalidar cachés antiguos
};

function guardarEnCache(datos) {
    try {
        const cacheData = {
            version: CACHE_CONFIG.VERSION,
            timestamp: Date.now(),
            data: datos
        };
        localStorage.setItem(CACHE_CONFIG.KEY, JSON.stringify(cacheData));
        console.log('✅ Datos guardados en caché —', datos.length, 'proyectos');
        return true;
    } catch (error) {
        console.error('❌ Error al guardar en caché:', error);
        return false;
    }
}

function obtenerDeCache() {
    try {
        const cacheString = localStorage.getItem(CACHE_CONFIG.KEY);
        if (!cacheString) return null;

        const cacheData = JSON.parse(cacheString);
        if (cacheData.version !== CACHE_CONFIG.VERSION) { 
            limpiarCache(); 
            return null; 
        }

        const tiempoTranscurrido = Date.now() - cacheData.timestamp;
        if (tiempoTranscurrido > CACHE_CONFIG.DURACION_MINUTOS * 60000) { 
            limpiarCache(); 
            return null; 
        }

        const minutosRestantes = Math.floor((CACHE_CONFIG.DURACION_MINUTOS * 60000 - tiempoTranscurrido) / 60000);
        console.log('✅ Caché válido —', cacheData.data.length, 'proyectos — expira en', minutosRestantes, 'min');
        return cacheData.data;
    } catch (error) {
        console.error('❌ Error al leer caché:', error);
        limpiarCache();
        return null;
    }
}

function limpiarCache() {
    try { 
        localStorage.removeItem(CACHE_CONFIG.KEY); 
        console.log('🗑️ Caché limpiado'); 
        return true; 
    }
    catch (e) { 
        console.error('❌ Error al limpiar caché:', e); 
        return false; 
    }
}

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('🚀 MÓDULO INVESTIGACIÓN INICIADO');

    if (typeof window.getDB === 'undefined') {
        mostrarError('Configuración incorrecta: database.js no está cargado'); 
        return;
    }
    if (typeof window.getInvestigacionData === 'undefined') {
        mostrarError('Configuración incorrecta: API de investigación no está cargada'); 
        return;
    }

    console.log('✅ jQuery:', jQuery.fn.jquery, '| Database.js: OK | API: OK');
    cargarDatos(false);
});

// =============================================================================
// CARGAR DATOS CON CACHÉ
// =============================================================================

async function cargarDatos(forzarActualizacion = false) {
    console.log('📥 CARGANDO PROYECTOS | Forzar:', forzarActualizacion, '| Intento:', intentosRecarga + 1);

    // Intentar desde caché
    if (!forzarActualizacion) {
        const datosCache = obtenerDeCache();
        if (datosCache && datosCache.length > 0) {
            datosCompletos = datosCache;
            intentosRecarga = 0;
            renderizarPestanas(datosCompletos);
            mostrarToast(`⚡ ${datosCompletos.length} proyectos cargados desde caché`, 'info');
            return;
        }
        console.log('ℹ️ Sin caché válido, consultando Google Sheets...');
    } else {
        console.log('🔄 Actualización forzada');
        limpiarCache();
    }

    mostrarLoading(true);

    try {
        const response = await window.getInvestigacionData();

        if (!response || !response.success || !response.data) {
            throw new Error(response?.message || response?.error || 'Respuesta inválida del servidor');
        }

        const proyectos = response.data;

        if (proyectos.length === 0) {
            mostrarLoading(false);
            $('#tabsContent').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-microscope fa-3x"></i>
                    <p>No hay proyectos de investigación disponibles</p>
                    <button class="btn-reintentar" onclick="cargarDatos(true)">
                        <i class="fas fa-sync-alt"></i> Actualizar
                    </button>
                </div>
            `);
            return;
        }

        datosCompletos = proyectos;
        intentosRecarga = 0;
        guardarEnCache(datosCompletos);
        renderizarPestanas(datosCompletos);
        mostrarLoading(false);

        const msg = forzarActualizacion
            ? `🔄 ${datosCompletos.length} proyectos actualizados`
            : `✅ ${datosCompletos.length} proyectos cargados`;
        mostrarToast(msg, 'success');

    } catch (error) {
        console.error('❌ ERROR:', error.message);
        mostrarLoading(false);

        if (intentosRecarga < MAX_INTENTOS) {
            intentosRecarga++;
            mostrarToast(`⚠️ Reintentando... (${intentosRecarga}/${MAX_INTENTOS})`, 'info');
            setTimeout(() => cargarDatos(forzarActualizacion), 2000);
            return;
        }

        intentosRecarga = 0;
        $('#tabsContent').html(`
            <div class="mensaje-error">
                <div class="error-icon"><i class="fas fa-exclamation-triangle"></i></div>
                <h3>Error al cargar proyectos</h3>
                <p>${error.message || 'Error desconocido'}</p>
                <div style="display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
                    <button class="btn-reintentar" onclick="cargarDatos(false)"><i class="fas fa-sync-alt"></i> Reintentar</button>
                    <button class="btn-reintentar" onclick="cargarDatos(true)"><i class="fas fa-cloud-download-alt"></i> Forzar actualización</button>
                    <button class="btn-reintentar" onclick="limpiarCache(); cargarDatos(false);" style="background:#dc3545;"><i class="fas fa-trash"></i> Limpiar caché</button>
                </div>
            </div>
        `);
        mostrarToast('❌ Error al cargar proyectos', 'error');
    }
}

// =============================================================================
// RENDERIZAR PESTAÑAS
// =============================================================================

function renderizarPestanas(proyectos) {
    const $tabsButtons = $('#tabsButtons');
    const $tabsContent = $('#tabsContent');
    $tabsButtons.empty();
    $tabsContent.empty();

    if (!proyectos || proyectos.length === 0) {
        $tabsContent.html('<div class="mensaje-vacio"><i class="fas fa-microscope fa-3x"></i><p>Sin proyectos disponibles</p></div>');
        return;
    }

    // Clasificar proyectos por tipo
    // Los tipos ya vienen normalizados desde el API como: 'DGI', 'INSTITUTO_CIENTIFICO', 'TESIS'
    const clasificacion = { DGI: [], INSTITUTO_CIENTIFICO: [], TESIS: [] };

    proyectos.forEach(p => {
        const tipo = (p.tipo || '').toUpperCase().trim();
        
        // Clasificación directa por tipo normalizado
        if (tipo === 'DGI') {
            clasificacion.DGI.push(p);
        } else if (tipo === 'INSTITUTO_CIENTIFICO') {
            clasificacion.INSTITUTO_CIENTIFICO.push(p);
        } else if (tipo === 'TESIS') {
            clasificacion.TESIS.push(p);
        } else {
            // Si el tipo no coincide exactamente, intentar clasificar por contenido
            if (tipo.includes('DGI')) {
                clasificacion.DGI.push(p);
            } else if (tipo.includes('INSTITUTO') || tipo.includes('CIENTIFICO')) {
                clasificacion.INSTITUTO_CIENTIFICO.push(p);
            } else if (tipo.includes('TESIS')) {
                clasificacion.TESIS.push(p);
            } else {
                console.warn('⚠️ Proyecto con tipo desconocido:', tipo, p);
            }
        }
    });

    console.log('📊 Clasificación:');
    console.log('   DGI:', clasificacion.DGI.length);
    console.log('   INSTITUTO_CIENTIFICO:', clasificacion.INSTITUTO_CIENTIFICO.length);
    console.log('   TESIS:', clasificacion.TESIS.length);

    const tabs = [
        { 
            id: 'DGI', 
            label: 'DGI', 
            icon: 'fa-download', 
            datos: clasificacion.DGI 
        },
        { 
            id: 'INSTITUTO_CIENTIFICO', 
            label: 'Instituto Científico', 
            icon: 'fa-flask', 
            datos: clasificacion.INSTITUTO_CIENTIFICO 
        },
        { 
            id: 'TESIS', 
            label: 'Tesis', 
            icon: 'fa-graduation-cap', 
            datos: clasificacion.TESIS 
        }
    ];

    let firstActive = true;

    tabs.forEach(tab => {
        if (tab.datos.length === 0) return;

        const isActive = firstActive;
        if (firstActive) firstActive = false;

        // Botón pestaña
        const $btn = $(`
            <button class="tab-button ${isActive ? 'active' : ''}" data-tab="${tab.id}">
                <i class="fas ${tab.icon}"></i>
                <span>${tab.label}</span>
                <span class="tab-badge">${tab.datos.length}</span>
            </button>
        `);

        $btn.on('click', function() {
            $('.tab-button').removeClass('active');
            $(this).addClass('active');
            $('.tab-pane').removeClass('active');
            $(`#tab-${tab.id}`).addClass('active');

            // Mostrar/ocultar selector de facultades solo en Tesis
            if (tab.id === 'TESIS') {
                $('#facultadesSelector').slideDown(300);
            } else {
                $('#facultadesSelector').slideUp(300);
            }
        });

        $tabsButtons.append($btn);

        // Contenido
        if (tab.id === 'TESIS') {
            renderizarTesisPorFacultad(tab.datos, tab.id, $tabsContent, isActive);
        } else {
            renderizarTablaDGI_IC(tab.datos, tab.id, $tabsContent, isActive);
        }
    });

    console.log('✅ Pestañas renderizadas');
}

// =============================================================================
// RENDERIZAR TABLA DGI / INSTITUTO CIENTÍFICO
// Cada fila tiene su propia celda de año (sin rowspan).
// =============================================================================

function renderizarTablaDGI_IC(proyectos, tabId, $containerContent, isActive) {
    // Ordenar por año descendente (numérico cuando es posible)
    const ordenados = [...proyectos].sort((a, b) => {
        const aNum = parseInt(a.anio) || 0;
        const bNum = parseInt(b.anio) || 0;
        
        // Si ambos son numéricos, ordenar por número (descendente)
        if (aNum && bNum) return bNum - aNum;
        
        // Si uno es numérico y otro no, el numérico va primero
        if (aNum && !bNum) return -1;
        if (!aNum && bNum) return 1;
        
        // Ambos no numéricos: comparar como strings (descendente)
        return String(b.anio || '').localeCompare(String(a.anio || ''));
    });

    let html = '<div class="tabla-dgi-wrapper"><table class="tabla-dgi-ic">';

    // Cabecera
    html += '<thead><tr>';
    html += '<th class="col-anio">AÑO</th>';
    html += '<th class="col-titulo">TÍTULO</th>';
    //html += '<th class="col-facultad">FACULTAD</th>';
    //html += '<th class="col-escuela">ESCUELA</th>';
    html += '<th class="col-doc">DOCUMENTO</th>';
    html += '</tr></thead>';

    // Cuerpo — cada fila independiente con su año
    html += '<tbody>';

    ordenados.forEach(proyecto => {
        const anio = proyecto.anio || 'General';
        const titulo = proyecto.documento || 'Sin título';
        const facultad = proyecto.facultad;
        const escuela = proyecto.escuela;

        html += '<tr>';

        // Celda año: siempre presente
        html += `<td class="anio-cell">${escapeHtml(String(anio))}</td>`;

        // Título
        html += `<td class="titulo-cell">${escapeHtml(titulo)}</td>`;

        // Facultad
        //html += facultad
            //? `<td class="col-facultad">${escapeHtml(facultad)}</td>`
            //: '<td class="col-facultad dato-vacio">—</td>';

        // Escuela
        //html += escuela
            //? `<td class="col-escuela">${escapeHtml(escuela)}</td>`
            //: '<td class="col-escuela dato-vacio">—</td>';

        // PDF
        if (proyecto.pdf && proyecto.pdf !== '#') {
            html += `<td class="text-center">
                <a href="${proyecto.pdf}" target="_blank" class="btn-pdf-texto">
                    <i class="fas fa-file-pdf"></i><span>Ver PDF</span>
                </a>
            </td>`;
        } else {
            html += '<td class="text-center"><span class="sin-dato"><i class="fas fa-minus"></i></span></td>';
        }

        html += '</tr>';
    });

    html += '</tbody></table></div>';

    const $pane = $(`<div class="tab-pane ${isActive ? 'active' : ''}" id="tab-${tabId}"></div>`);
    $pane.html(html);
    $containerContent.append($pane);
}

// =============================================================================
// RENDERIZAR TESIS POR FACULTAD
// =============================================================================

function renderizarTesisPorFacultad(proyectos, tabId, $containerContent, isActive) {
    // Agrupar: facultad → escuela → array de tesis (ordenadas por año desc)
    const estructura = {};

    proyectos.forEach(p => {
        const fac = p.facultad || 'Sin Facultad';
        const esc = p.escuela || 'Sin Escuela';
        if (!estructura[fac]) estructura[fac] = {};
        if (!estructura[fac][esc]) estructura[fac][esc] = [];
        estructura[fac][esc].push(p);
    });

    // Ordenar tesis dentro de cada escuela por año desc
    Object.values(estructura).forEach(escuelas => {
        Object.keys(escuelas).forEach(esc => {
            escuelas[esc].sort((a, b) => {
                const aNum = parseInt(a.anio) || 0;
                const bNum = parseInt(b.anio) || 0;
                return bNum - aNum;
            });
        });
    });

    // Poblar selector de facultades
    const $select = $('#selectFacultad');
    $select.find('option:not(:first)').remove();
    Object.keys(estructura).sort().forEach(fac => {
        $select.append(`<option value="${escapeHtml(fac)}">${escapeHtml(fac)}</option>`);
    });

    $select.off('change').on('change', function() {
        const val = $(this).val();
        if (val) {
            mostrarTesis(val, estructura[val]);
        } else {
            mostrarTodasLasTesis(estructura);
        }
    });

    const $pane = $(`<div class="tab-pane ${isActive ? 'active' : ''}" id="tab-${tabId}"></div>`);
    $pane.html('<div id="tesisContent"></div>');
    $containerContent.append($pane);

    setTimeout(() => mostrarTodasLasTesis(estructura), 100);
}

// Función compartida para generar tabla de tesis de una escuela
function generarTablaTesis(tesisArray) {
    let html = '<div class="tabla-tesis-wrapper"><table class="tabla-tesis">';
    html += '<thead><tr>';
    html += '<th style="width:50px;">#</th>';
    html += '<th>TÍTULO</th>';
    html += '<th style="width:100px;">AÑO</th>';
    html += '<th style="width:150px;">DOCUMENTO</th>';
    html += '</tr></thead><tbody>';

    tesisArray.forEach((tesis, i) => {
        const anio = tesis.anio || 'S/A';
        html += '<tr>';
        html += `<td class="text-center"><span class="numero-badge">${i + 1}</span></td>`;
        html += `<td>${escapeHtml(tesis.documento || 'Sin título')}</td>`;
        html += `<td class="text-center">${escapeHtml(String(anio))}</td>`;

        if (tesis.pdf && tesis.pdf !== '#') {
            html += `<td class="text-center">
                <a href="${tesis.pdf}" target="_blank" class="btn-pdf-icono">
                    <i class="fas fa-file-pdf"></i><span>PDF</span>
                </a>
            </td>`;
        } else {
            html += '<td class="text-center"><span class="sin-dato"><i class="fas fa-minus"></i></span></td>';
        }

        html += '</tr>';
    });

    html += '</tbody></table></div>';
    return html;
}

// Función compartida para generar secciones colapsibles de escuelas
function generarSeccionesEscuelas(escuelas, prefijo) {
    let html = '';

    Object.keys(escuelas).sort().forEach((escuela, index) => {
        const tesisArr = escuelas[escuela];
        const escuelaId = `${prefijo}-${escuela.replace(/[^a-zA-Z0-9]/g, '-')}`;
        const isFirst = index === 0;

        html += `<div class="escuela-seccion">`;

        // Header colapsible
        html += `<div class="escuela-header ${isFirst ? '' : 'collapsed'}" data-toggle="${escuelaId}">
            <div class="escuela-titulo">
                <i class="fas fa-chevron-down collapse-icon" style="transform: ${isFirst ? 'rotate(0deg)' : 'rotate(-90deg)'}"></i>
                <i class="fas fa-university"></i>
                <span>${escapeHtml(escuela)}</span>
            </div>
            <span class="escuela-count">${tesisArr.length} ${tesisArr.length === 1 ? 'tesis' : 'tesis'}</span>
        </div>`;

        // Body
        html += `<div class="escuela-body" id="${escuelaId}" style="display: ${isFirst ? 'block' : 'none'};">`;
        html += generarTablaTesis(tesisArr);
        html += '</div></div>';
    });

    return html;
}

function mostrarTodasLasTesis(estructura) {
    const $content = $('#tesisContent');
    $content.empty();

    let html = '';
    Object.keys(estructura).sort().forEach(facultad => {
        html += `<div class="facultad-container">`;
        // Header de facultad (solo informativo, sin colapsar)
        html += `<div style="padding: 10px 22px; background: #f1f5f9; border-bottom: 1px solid #e2e8f0; display:flex; align-items:center; gap:8px;">
            <i class="fas fa-university" style="color: var(--color-primary); font-size: 0.95rem;"></i>
            <strong style="font-size:0.88rem; color: var(--color-secondary);">${escapeHtml(facultad)}</strong>
        </div>`;
        html += generarSeccionesEscuelas(estructura[facultad], `esc-${facultad.replace(/[^a-zA-Z0-9]/g, '-')}`);
        html += '</div>';
    });

    $content.html(html);
    bindCollapseEvents();
}

function mostrarTesis(facultad, escuelas) {
    const $content = $('#tesisContent');
    let html = '<div class="facultad-container">';
    html += generarSeccionesEscuelas(escuelas, `esc-filt-${facultad.replace(/[^a-zA-Z0-9]/g, '-')}`);
    html += '</div>';
    $content.html(html);
    bindCollapseEvents();
}

// Delegar eventos de collapse después de renderizar
function bindCollapseEvents() {
    $('.escuela-header').off('click').on('click', function() {
        const targetId = $(this).data('toggle');
        const $body = $(`#${targetId}`);
        const $icon = $(this).find('.collapse-icon');

        $body.slideToggle(300);
        $(this).toggleClass('collapsed');

        if ($(this).hasClass('collapsed')) {
            $icon.css('transform', 'rotate(-90deg)');
        } else {
            $icon.css('transform', 'rotate(0deg)');
        }
    });
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
    if (show) {
        $('#loadingOverlay').fadeIn(300);
    } else {
        $('#loadingOverlay').fadeOut(300);
    }
}

function mostrarToast(mensaje, tipo = 'success') {
    const icons = { 
        success: 'fa-check-circle', 
        error: 'fa-exclamation-circle', 
        info: 'fa-info-circle' 
    };
    
    $('#toast')
        .html(`<i class="fas ${icons[tipo] || 'fa-info-circle'}"></i> ${mensaje}`)
        .removeClass()
        .addClass(`toast ${tipo}`)
        .fadeIn(300);
    
    setTimeout(() => $('#toast').fadeOut(300), 4500);
}

function mostrarError(mensaje) {
    $('#tabsContent').html(`
        <div class="mensaje-error">
            <div class="error-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h3>Error de configuración</h3>
            <p>${mensaje}</p>
            <button class="btn-reintentar" onclick="cargarDatos(false)">
                <i class="fas fa-sync-alt"></i> Reintentar
            </button>
        </div>
    `);
    mostrarToast('❌ ' + mensaje.replace(/<[^>]*>/g, '').trim(), 'error');
}

// Actualizar info del caché en la UI (se llama desde index.html)
function actualizarInfoCache() {
    try {
        const cacheString = localStorage.getItem(CACHE_CONFIG.KEY);
        if (!cacheString) {
            document.getElementById('cacheStatus').innerHTML = 
                '<span style="color:#94a3b8;">Sin caché</span>';
            return;
        }
        
        const cacheData = JSON.parse(cacheString);
        const minRestantes = CACHE_CONFIG.DURACION_MINUTOS - 
            Math.floor((Date.now() - cacheData.timestamp) / 60000);

        if (minRestantes > 0) {
            document.getElementById('cacheStatus').innerHTML =
                `<span style="color:#28a745;">Caché válido</span> · ${cacheData.data.length} proyectos · Expira en ${minRestantes} min`;
        } else {
            document.getElementById('cacheStatus').innerHTML = 
                '<span style="color:#dc3545;">Caché expirado</span>';
        }
    } catch (e) {
        document.getElementById('cacheStatus').innerHTML = 
            '<span style="color:#94a3b8;">Error al verificar caché</span>';
    }
}

// =============================================================================
// DEBUG
// =============================================================================

window.investigacionDebug = {
    datos: () => { 
        console.log('📊 Datos actuales:', datosCompletos); 
        return datosCompletos; 
    },
    
    recargar: (forzar = false) => { 
        intentosRecarga = 0; 
        cargarDatos(forzar); 
    },
    
    limpiarCache: () => { 
        limpiarCache(); 
    },
    
    verCache: () => { 
        const d = obtenerDeCache(); 
        if (d) {
            console.log('✅ Caché válido:', d.length, 'proyectos'); 
        } else {
            console.log('❌ Sin caché válido'); 
        }
        return d; 
    },
    
    info: () => {
        console.log('═══════════════════════════════════════');
        console.log('📊 INFORMACIÓN DEL MÓDULO');
        console.log('═══════════════════════════════════════');
        console.log('Datos cargados:', datosCompletos !== null);
        console.log('Total proyectos:', datosCompletos?.length || 0);
        console.log('Caché duración:', CACHE_CONFIG.DURACION_MINUTOS, 'minutos');
        console.log('Caché versión:', CACHE_CONFIG.VERSION);
        
        if (datosCompletos) {
            const tiposCuenta = {};
            datosCompletos.forEach(p => {
                tiposCuenta[p.tipo] = (tiposCuenta[p.tipo] || 0) + 1;
            });
            console.log('Distribución por tipo:', tiposCuenta);
        }
        console.log('═══════════════════════════════════════');
    },
    
    clasificar: () => {
        if (!datosCompletos) {
            console.warn('⚠️ No hay datos cargados');
            return null;
        }
        
        const clasificacion = { DGI: [], INSTITUTO_CIENTIFICO: [], TESIS: [], OTROS: [] };
        
        datosCompletos.forEach(p => {
            const tipo = (p.tipo || '').toUpperCase().trim();
            
            if (tipo === 'DGI') {
                clasificacion.DGI.push(p);
            } else if (tipo === 'INSTITUTO_CIENTIFICO') {
                clasificacion.INSTITUTO_CIENTIFICO.push(p);
            } else if (tipo === 'TESIS') {
                clasificacion.TESIS.push(p);
            } else {
                clasificacion.OTROS.push(p);
            }
        });
        
        console.log('📊 Clasificación de proyectos:');
        console.log('   DGI:', clasificacion.DGI.length);
        console.log('   INSTITUTO_CIENTIFICO:', clasificacion.INSTITUTO_CIENTIFICO.length);
        console.log('   TESIS:', clasificacion.TESIS.length);
        console.log('   OTROS:', clasificacion.OTROS.length);
        
        if (clasificacion.OTROS.length > 0) {
            console.warn('⚠️ Proyectos sin clasificar:', clasificacion.OTROS);
        }
        
        return clasificacion;
    }
};

console.log('✅ Módulo Investigación cargado');
console.log('💡 Usa window.investigacionDebug para debugging');
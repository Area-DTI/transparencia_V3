/**
 * =============================================================================
 * MÓDULO ACTAS - SCRIPTS DE PRESENTACIÓN
 * =============================================================================
 * 
 * Este archivo SE ENFOCA EN LA PRESENTACIÓN/UI
 * La lógica de conexión está en api/actas.js
 * 
 * Ubicación: modules/2_actas_php/scripts.js
 * Versión: 3.0 - JavaScript puro (compatible Netlify)
 */

// =============================================================================
// VERIFICAR DEPENDENCIAS
// =============================================================================

if (typeof ActasAPI === 'undefined') {
    console.error('❌ ERROR: api/actas.js no está cargado');
    alert('Error de configuración: falta cargar api/actas.js');
}

// =============================================================================
// VARIABLES GLOBALES
// =============================================================================

let datosCompletos = null;
let tablasPorAnio = {};
let facultadesData = {};
let intentosRecarga = 0;
const MAX_INTENTOS = 3;

// =============================================================================
// INICIALIZACIÓN
// =============================================================================

$(document).ready(function() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🚀 MÓDULO ACTAS INICIADO');
    console.log('📡 Usando: api/actas.js → config/database.js → Google Apps Script');
    console.log('═══════════════════════════════════════════════════════');
    
    cargarDatos();
});

// =============================================================================
// CARGAR DATOS
// =============================================================================

async function cargarDatos(forzarActualizacion = false) {
    console.log('───────────────────────────────────────────────────────');
    console.log('📥 CARGANDO ACTAS');
    console.log('───────────────────────────────────────────────────────');
    console.log('🔄 Forzar actualización:', forzarActualizacion);
    console.log('🔢 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
    
    mostrarLoading(true);
    
    try {
        // Llamar a ActasAPI (que maneja la conexión)
        const response = await ActasAPI.getAll(forzarActualizacion);
        
        console.log('───────────────────────────────────────────────────────');
        console.log('✅ RESPUESTA RECIBIDA');
        console.log('───────────────────────────────────────────────────────');
        console.log('📦 Respuesta:', response);
        
        // Extraer datos
        const datos = response.data || [];
        
        if (datos.length === 0) {
            console.warn('⚠️ No hay actas disponibles');
            mostrarLoading(false);
            $('#tabsContent').html(`
                <div class="mensaje-vacio">
                    <i class="fas fa-folder-open fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                    <p>No hay actas disponibles en Google Sheets</p>
                    <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-top: 15px;">
                        <i class="fas fa-sync-alt"></i> Actualizar desde Google Sheets
                    </button>
                </div>
            `);
            return;
        }
        
        datosCompletos = datos;
        intentosRecarga = 0; // Resetear intentos
        
        console.log('✅ Actas cargadas:', datosCompletos.length);
        console.log('📊 Fuente:', response.source);
        console.log('📊 Timestamp:', response.timestamp);
        
        // Renderizar pestañas
        renderizarPestanas(datosCompletos);
        
        mostrarLoading(false);
        mostrarToast(`✅ ${datosCompletos.length} actas cargadas desde Google Sheets`, 'success');
        
        console.log('───────────────────────────────────────────────────────');
        console.log('✅ CARGA COMPLETADA');
        console.log('───────────────────────────────────────────────────────');
        
    } catch (error) {
        console.error('───────────────────────────────────────────────────────');
        console.error('❌ ERROR AL CARGAR ACTAS');
        console.error('───────────────────────────────────────────────────────');
        console.error('Error:', error);
        console.error('Mensaje:', error.message);
        console.error('📊 Intento:', intentosRecarga + 1, 'de', MAX_INTENTOS);
        
        mostrarLoading(false);
        
        let mensaje = 'Error al cargar actas desde Google Sheets';
        let detalles = '';
        
        if (error.message) {
            detalles = error.message;
        }
        
        if (error.message && error.message.includes('Timeout')) {
            mensaje = 'Tiempo de espera agotado';
            detalles = 'Google Apps Script tardó demasiado en responder.';
        }
        
        console.error('💡 Diagnóstico:', mensaje);
        console.error('💡 Detalles:', detalles);
        
        // Reintentar automáticamente
        if (intentosRecarga < MAX_INTENTOS - 1) {
            intentosRecarga++;
            console.log('🔄 Reintentando automáticamente en 3 segundos...');
            mostrarToast(`⚠️ Reintentando... (${intentosRecarga}/${MAX_INTENTOS})`, 'info');
            
            setTimeout(() => {
                cargarDatos(forzarActualizacion);
            }, 3000);
        } else {
            mostrarError(mensaje + (detalles ? '<br><small>' + detalles + '</small>' : ''));
        }
    }
}

// =============================================================================
// RENDERIZAR PESTAÑAS TIPO BOTONES
// =============================================================================

function renderizarPestanas(datos) {
    const $tabsButtons = $('#tabsButtons');
    const $tabsContent = $('#tabsContent');
    
    $tabsButtons.empty();
    $tabsContent.empty();
    
    if (!datos || datos.length === 0) {
        $tabsContent.html(`
            <div class="mensaje-vacio">
                <i class="fas fa-folder-open fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                <p>No hay actas disponibles en Google Sheets</p>
                <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-top: 15px;">
                    <i class="fas fa-sync-alt"></i> Actualizar desde Google Sheets
                </button>
            </div>
        `);
        return;
    }
    
    // Clasificar actas por tipo
    const clasificacion = clasificarActas(datos);
    
    console.log('📂 Clasificación:', clasificacion);
    
    let index = 0;
    
    // 1. ASAMBLEA UNIVERSITARIA
    if (clasificacion['ASAMBLEA UNIVERSITARIA'] && clasificacion['ASAMBLEA UNIVERSITARIA'].length > 0) {
        crearBotonPestana('ASAMBLEA UNIVERSITARIA', clasificacion['ASAMBLEA UNIVERSITARIA'], index++, $tabsButtons, $tabsContent);
    }
    
    // 2. CONSEJO UNIVERSITARIO
    if (clasificacion['CONSEJO UNIVERSITARIA'] && clasificacion['CONSEJO UNIVERSITARIO'].length > 0) {
        crearBotonPestana('CONSEJO UNIVERSITARIO', clasificacion['CONSEJO UNIVERSITARIO'], index++, $tabsButtons, $tabsContent);
    }
    
    // 3. ESCUELA DE POSGRADO
    if (clasificacion['ESCUELA DE POSGRADO'] && clasificacion['ESCUELA DE POSGRADO'].length > 0) {
        crearBotonPestana('ESCUELA DE POSGRADO', clasificacion['ESCUELA DE POSGRADO'], index++, $tabsButtons, $tabsContent);
    }
    
    // 4. FACULTADES
    if (Object.keys(clasificacion.facultades).length > 0) {
        crearBotonFacultades(clasificacion.facultades, index++, $tabsButtons, $tabsContent);
    }
    
    // Activar primera pestaña
    $('.tab-button').first().addClass('active');
    $('.tab-pane').first().addClass('active');
}

// =============================================================================
// CLASIFICAR ACTAS POR TIPO
// =============================================================================

function clasificarActas(datos) {
    const clasificacion = {
        'ASAMBLEA UNIVERSITARIA': [],
        'CONSEJO UNIVERSITARIO': [],
        'ESCUELA DE POSGRADO': [],
        'facultades': {}
    };
    
    datos.forEach(acta => {
        const seccion = (acta.seccion || acta.Seccion || '').toString().toUpperCase().trim();
        
        if (seccion.includes('ASAMBLEA')) {
            clasificacion['ASAMBLEA UNIVERSITARIA'].push(acta);
        } 
        else if (seccion.includes('CONSEJO') && !seccion.includes('FACULTAD')) {
            clasificacion['CONSEJO UNIVERSITARIO'].push(acta);
        } 
        else if (seccion.includes('ESCUELA') && seccion.includes('POSGRADO')) {
            clasificacion['ESCUELA DE POSGRADO'].push(acta);
        }
        else if (seccion.includes('POSGRADO')) {
            clasificacion['ESCUELA DE POSGRADO'].push(acta);
        }
        else if (seccion.includes('FACULTAD')) {
            if (!clasificacion.facultades[seccion]) {
                clasificacion.facultades[seccion] = [];
            }
            clasificacion.facultades[seccion].push(acta);
        } 
        else {
            if (!clasificacion.facultades[seccion]) {
                clasificacion.facultades[seccion] = [];
            }
            clasificacion.facultades[seccion].push(acta);
        }
    });
    
    return clasificacion;
}

// =============================================================================
// CREAR BOTÓN DE PESTAÑA INDIVIDUAL
// =============================================================================

function crearBotonPestana(seccion, actas, index, $container, $contentContainer) {
    const tabId = `tab-${index}`;
    const icono = obtenerIconoSeccion(seccion);
    const nombreCorto = obtenerNombreCorto(seccion);
    
    const $btn = $(`
        <button class="tab-button" data-tab="${tabId}">
            <i class="fas ${icono}"></i>
            <span>${nombreCorto}</span>
            <span class="badge">${actas.length}</span>
        </button>
    `);
    
    $btn.on('click', function() {
        $('.tab-button').removeClass('active');
        $(this).addClass('active');
        $('.tab-pane').removeClass('active');
        $(`#${tabId}`).addClass('active');
        $('#facultadesSelector').hide();
    });
    
    $container.append($btn);
    
    const $pane = $(`<div class="tab-pane" id="${tabId}"></div>`);
    const $colapsables = crearColapsablesPorAnio(actas, tabId, seccion);
    $pane.append($colapsables);
    $contentContainer.append($pane);
}

// =============================================================================
// CREAR BOTÓN DE FACULTADES CON SELECTOR
// =============================================================================

function crearBotonFacultades(facultades, index, $container, $contentContainer) {
    const tabId = `tab-facultades`;
    
    facultadesData = facultades;
    
    // Contar total de actas de facultades
    let totalActas = 0;
    Object.values(facultades).forEach(actas => {
        totalActas += actas.length;
    });
    
    const $btn = $(`
        <button class="tab-button" data-tab="${tabId}">
            <i class="fas fa-building"></i>
            <span>Facultades</span>
            <span class="badge">${totalActas}</span>
        </button>
    `);
    
    $btn.on('click', function() {
        $('.tab-button').removeClass('active');
        $(this).addClass('active');
        $('.tab-pane').removeClass('active');
        $(`#${tabId}`).addClass('active');
        $('#facultadesSelector').fadeIn(300);
    });
    
    $container.append($btn);
    
    const $select = $('#selectFacultad');
    $select.empty().append('<option value="">-- Todas las facultades --</option>');
    
    Object.keys(facultades).sort().forEach(fac => {
        $select.append(`<option value="${fac}">${fac} (${facultades[fac].length})</option>`);
    });
    
    $select.on('change', function() {
        const facultadSeleccionada = $(this).val();
        if (facultadSeleccionada) {
            mostrarFacultad(facultadSeleccionada);
        } else {
            mostrarTodasLasFacultades();
        }
    });
    
    const $pane = $(`<div class="tab-pane" id="${tabId}"></div>`);
    $pane.html('<div id="facultadesContent"></div>');
    $contentContainer.append($pane);
    
    setTimeout(() => mostrarTodasLasFacultades(), 100);
}

function mostrarTodasLasFacultades() {
    const $content = $('#facultadesContent');
    $content.empty();
    
    Object.keys(facultadesData).sort().forEach((fac, idx) => {
        const $colapsables = crearColapsablesPorAnio(facultadesData[fac], `fac-${idx}`, fac);
        $content.append($colapsables);
    });
}

function mostrarFacultad(nombreFacultad) {
    const $content = $('#facultadesContent');
    $content.empty();
    
    if (facultadesData[nombreFacultad]) {
        const $colapsables = crearColapsablesPorAnio(facultadesData[nombreFacultad], 'fac-selected', nombreFacultad);
        $content.append($colapsables);
    }
}

// =============================================================================
// CREAR COLAPSABLES POR AÑO
// =============================================================================

function crearColapsablesPorAnio(actas, tabId, nombreSeccion) {
    const $container = $('<div>', { class: 'colapsables-container' });
    
    const actasPorAnio = {};
    actas.forEach(acta => {
        const anio = acta.anio || acta.Año || 'Sin año';
        if (!actasPorAnio[anio]) actasPorAnio[anio] = [];
        actasPorAnio[anio].push(acta);
    });
    
    const aniosOrdenados = Object.keys(actasPorAnio).sort((a, b) => {
        return (parseInt(b) || 0) - (parseInt(a) || 0);
    });
    
    const anioMasReciente = aniosOrdenados[0];
    
    aniosOrdenados.forEach((anio, index) => {
        const collapseId = `${tabId}-anio-${index}`;
        const isOpen = anio === anioMasReciente;
        
        const $colapsable = $('<div>', { class: 'seccion-agrupada' });
        
        const $header = $('<div>', {
            class: `seccion-header ${isOpen ? '' : 'collapsed'}`,
            'data-target': collapseId,
            html: `
                <div class="seccion-titulo">
                    <i class="fas fa-chevron-down collapse-icon" 
                       style="${isOpen ? '' : 'transform: rotate(-90deg);'}"></i>
                    <span>${nombreSeccion} ${anio}</span>
                </div>
                <span class="seccion-count">${actasPorAnio[anio].length} documento${actasPorAnio[anio].length !== 1 ? 's' : ''}</span>
            `
        });
        
        $header.on('click', function() {
            const $this = $(this);
            const $body = $this.next('.seccion-body');
            const $icon = $this.find('.collapse-icon');
            
            $this.toggleClass('collapsed');
            
            if ($this.hasClass('collapsed')) {
                $body.slideUp(300);
                $icon.css('transform', 'rotate(-90deg)');
            } else {
                $body.slideDown(300);
                $icon.css('transform', 'rotate(0deg)');
                
                const tableId = `table-${collapseId}`;
                if (tablasPorAnio[tableId]) {
                    setTimeout(() => tablasPorAnio[tableId].columns.adjust(), 350);
                }
            }
        });
        
        $colapsable.append($header);
        
        const $body = $('<div>', {
            class: 'seccion-body',
            style: isOpen ? '' : 'display: none;'
        });
        
        const $tabla = crearTablaActas(actasPorAnio[anio], `table-${collapseId}`);
        $body.append($tabla);
        
        $colapsable.append($body);
        $container.append($colapsable);
    });
    
    return $container;
}

// =============================================================================
// CREAR TABLA DE ACTAS
// =============================================================================

function crearTablaActas(actas, tableId) {
    const $wrapper = $('<div>', { class: 'table-wrapper' });
    const $table = $(`
        <table id="${tableId}" class="actas-table display responsive nowrap" style="width:100%">
            <thead>
                <tr>
                    <th>FECHA DE DOCUMENTO</th>
                    <th>DOCUMENTO</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    `);
    
    const $tbody = $table.find('tbody');
    
    actas.forEach(acta => {
        const fecha = acta.fecha || acta.Fecha;
        const fechaFormateada = fecha ? formatearFecha(fecha) : (acta.titulo || acta.Titulo || 'Sin título');
        const enlace = acta.enlace_pdf || acta.Enlace || acta.enlace;
        
        $tbody.append(`
            <tr>
                <td>${fechaFormateada}</td>
                <td class="text-center">
                    ${enlace && enlace !== '#'
                        ? `<a href="${enlace}" target="_blank" class="btn-ver-pdf"><i class="fas fa-file-pdf"></i> Ver</a>` 
                        : '<span class="sin-enlace">Sin documento</span>'}
                </td>
            </tr>
        `);
    });
    
    $wrapper.append($table);
    
    setTimeout(() => {
        if (!$.fn.DataTable.isDataTable(`#${tableId}`)) {
            const dt = $(`#${tableId}`).DataTable({
                responsive: true,
                paging: true,
                pageLength: 10,
                lengthMenu: [[10, 20, 30, -1], [10, 20, 30, "Todos"]],
                searching: false,
                ordering: false,
                info: true,
                autoWidth: false,
                language: {
                    lengthMenu: "Mostrar _MENU_ registros",
                    info: "Mostrando _START_ a _END_ de _TOTAL_",
                    infoEmpty: "No hay documentos",
                    paginate: {
                        first: "Primero",
                        last: "Último",
                        next: "Siguiente",
                        previous: "Anterior"
                    }
                },
                columnDefs: [
                    { width: "65%", targets: 0 },
                    { width: "35%", targets: 1, className: "text-center" }
                ]
            });
            tablasPorAnio[tableId] = dt;
            console.log(`✅ DataTable inicializado: ${tableId}`);
        }
    }, 100);
    
    return $wrapper;
}

// =============================================================================
// UTILIDADES
// =============================================================================

function obtenerIconoSeccion(seccion) {
    if (seccion.includes('ASAMBLEA')) return 'fa-users';
    if (seccion.includes('CONSEJO')) return 'fa-users-cog';
    if (seccion.includes('POSGRADO')) return 'fa-graduation-cap';
    if (seccion.includes('FACULTAD')) return 'fa-building';
    return 'fa-folder';
}

function obtenerNombreCorto(seccion) {
    const nombres = {
        'ASAMBLEA UNIVERSITARIA': 'Asamblea Univ.',
        'CONSEJO UNIVERSITARIO': 'Consejo Univ.',
        'ESCUELA DE POSGRADO': 'Escuela Posgrado'
    };
    return nombres[seccion] || seccion;
}

function formatearFecha(fecha) {
    if (!fecha) return '-';
    try {
        const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
                       'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
        const partes = fecha.toString().split('-');
        const dia = parseInt(partes[2]);
        const mes = meses[parseInt(partes[1]) - 1];
        return `${dia} de ${mes}`;
    } catch (e) {
        return fecha;
    }
}

function mostrarLoading(show) {
    $('#loadingOverlay')[show ? 'fadeIn' : 'fadeOut'](300);
}

function mostrarToast(mensaje, tipo = 'info') {
    const icons = { 
        success: 'fa-check-circle', 
        error: 'fa-exclamation-circle', 
        info: 'fa-info-circle',
        warning: 'fa-exclamation-triangle'
    };
    $('#toast').html(`<i class="fas ${icons[tipo]}"></i> ${mensaje}`)
               .removeClass().addClass(`toast ${tipo}`).fadeIn(300);
    setTimeout(() => $('#toast').fadeOut(300), 5000);
}

function mostrarError(mensaje) {
    $('#tabsContent').html(`
        <div class="mensaje-error">
            <div class="error-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h3>Error al cargar actas</h3>
            <div class="error-details">${mensaje}</div>
            <div class="error-actions">
                <button class="btn-reintentar" onclick="cargarDatos(false)">
                    <i class="fas fa-sync-alt"></i> Reintentar
                </button>
                <button class="btn-reintentar" onclick="cargarDatos(true)" style="margin-left: 10px;">
                    <i class="fas fa-cloud-download-alt"></i> Forzar actualización
                </button>
            </div>
        </div>
    `);
    
    const mensajeSimple = mensaje.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim();
    mostrarToast('❌ ' + mensajeSimple, 'error');
}

// =============================================================================
// DEBUG
// =============================================================================

window.actasDebug = {
    datos: () => {
        console.table(datosCompletos);
        return datosCompletos;
    },
    facultades: () => {
        console.log('Facultades:', facultadesData);
        return facultadesData;
    },
    recargar: (forzar = false) => {
        intentosRecarga = 0;
        cargarDatos(forzar);
    },
    info: () => {
        console.log('═══════════════════════════════════════════════════════');
        console.log('📊 INFORMACIÓN DEL SISTEMA - ACTAS');
        console.log('═══════════════════════════════════════════════════════');
        console.log('Actas cargadas:', datosCompletos !== null);
        console.log('Total actas:', datosCompletos ? datosCompletos.length : 0);
        console.log('Intentos de recarga:', intentosRecarga);
        console.log('Tablas inicializadas:', Object.keys(tablasPorAnio).length);
        console.log('═══════════════════════════════════════════════════════');
    }
};

console.log('═══════════════════════════════════════════════════════');
console.log('💡 Funciones de debug disponibles:');
console.log('   actasDebug.datos()        - Ver datos cargados');
console.log('   actasDebug.recargar()     - Recargar datos');
console.log('   actasDebug.recargar(true) - Forzar actualización');
console.log('   actasDebug.facultades()   - Ver facultades');
console.log('   actasDebug.info()         - Info del sistema');
console.log('═══════════════════════════════════════════════════════');
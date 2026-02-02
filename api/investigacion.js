/**
 * =============================================================================
 * API CENTRALIZADA - INVESTIGACIÓN
 * =============================================================================
 * Ubicación: api/investigacion.js
 * Versión: 4.0 - CORREGIDA para estructura de datos agrupada (DGI, IC, TESIS)
 * 
 * ESTRUCTURA DE DATOS ESPERADA:
 * {
 *   success: true,
 *   data: {
 *     DGI: { count: N, records: [...] },
 *     IC: { count: N, records: [...] },
 *     TESIS: { count: N, records: [...] }
 *   }
 * }
 * 
 * COLUMNAS EN CADA RECORD:
 * - ID
 * - Tipo Proyecto
 * - Año
 * - Nombre Documento
 * - Enlace PDF
 * - Estado
 * - Facultad (solo en TESIS)
 * - Escuela Profesional (solo en TESIS)
 */

(function() {
    'use strict';
    
    console.log('📥 Cargando InvestigacionAPI v4.0...');
    
    // Orden de prioridad de tipos
    const PRIORIDAD_TIPOS_INVESTIGACION = {
        'DGI': 1,
        'INSTITUTO_CIENTIFICO': 2,
        'TESIS': 3
    };
    
    /**
     * Función auxiliar para obtener valor de diferentes variaciones de columna
     */
    function obtenerValor(fila, nombres) {
        for (const nombre of nombres) {
            const valor = fila[nombre];
            if (valor !== undefined && valor !== null && valor !== '' && valor !== 'NaN') {
                return String(valor).trim();
            }
        }
        return '';
    }
    
    /**
     * Función auxiliar para normalizar tipo de proyecto
     */
    function normalizarTipo(tipoOriginal) {
        const tipo = (tipoOriginal || '').toUpperCase().trim();
        
        if (tipo === 'DGI') return 'DGI';
        if (tipo === 'INSTITUTO_CIENTIFICO' || tipo.includes('INSTITUTO')) return 'INSTITUTO_CIENTIFICO';
        if (tipo === 'TESIS') return 'TESIS';
        
        return tipoOriginal || 'Sin tipo';
    }
    
    /**
     * Función para procesar un array de registros
     */
    function procesarRegistros(registros, tipoGrupo) {
        const proyectosProcesados = [];
        let contadorFiltrados = 0;
        
        registros.forEach((fila, index) => {
            // Obtener ID
            const id = parseInt(fila.ID || fila.id || fila.Id || 0);
            
            // Obtener tipo de proyecto
            const tipoOriginal = obtenerValor(fila, [
                'Tipo Proyecto',
                'Tipo_Proyecto',
                'tipo_proyecto',
                'tipo',
                'Tipo'
            ]);
            const tipo = normalizarTipo(tipoOriginal);
            
            // Obtener año
            const anio = obtenerValor(fila, [
                'Año',
                'anio',
                'año',
                'Anio',
                'AÑO'
            ]);
            
            // Obtener documento
            const documento = obtenerValor(fila, [
                'Nombre Documento',
                'Nombre_Documento',
                'nombre_documento',
                'documento',
                'Documento',
                'Nombre del documento',
                'titulo',
                'Titulo'
            ]);
            
            // Obtener PDF
            const pdf = obtenerValor(fila, [
                'Enlace PDF',
                'Enlace_PDF',
                'enlace_pdf',
                'pdf',
                'PDF',
                'Link PDF',
                'link',
                'enlace',
                'Enlace'
            ]);
            
            // Obtener estado
            const estado = obtenerValor(fila, [
                'Estado',
                'estado',
                'ESTADO',
                'vigente',
                'Vigente'
            ]);
            
            // Obtener facultad y escuela (solo para TESIS)
            const facultad = obtenerValor(fila, [
                'Facultad',
                'facultad',
                'FACULTAD'
            ]);
            
            const escuela = obtenerValor(fila, [
                'Escuela Profesional',
                'Escuela_Profesional',
                'escuela_profesional',
                'escuela',
                'Escuela'
            ]);
            
            // Filtros de validación
            if (id === 0) {
                contadorFiltrados++;
                console.log(`   ⏭️ ${tipoGrupo} - Fila ${index + 1}: ID inválido (0 o vacío)`);
                return;
            }
            
            if (!documento) {
                contadorFiltrados++;
                console.log(`   ⏭️ ${tipoGrupo} - Fila ${index + 1}: Sin documento`);
                return;
            }
            
            if (!pdf || pdf === '#' || pdf === 'N/A' || pdf === 'n/a') {
                contadorFiltrados++;
                console.log(`   ⏭️ ${tipoGrupo} - Fila ${index + 1}: Sin enlace PDF válido`);
                return;
            }
            
            // Filtrar por estado (solo activos)
            if (estado && estado.toLowerCase() !== 'activo') {
                contadorFiltrados++;
                console.log(`   ⏭️ ${tipoGrupo} - Fila ${index + 1}: Estado no activo (${estado})`);
                return;
            }
            
            // Crear proyecto normalizado
            const proyecto = {
                id: id,
                tipo: tipo,
                facultad: facultad || null,
                escuela: escuela || null,
                anio: anio || 'Sin año',
                documento: documento,
                pdf: pdf,
                estado: estado || 'activo'
            };
            
            proyectosProcesados.push(proyecto);
        });
        
        console.log(`✅ ${tipoGrupo}: Procesados ${proyectosProcesados.length} | Filtrados ${contadorFiltrados}`);
        
        return {
            procesados: proyectosProcesados,
            filtrados: contadorFiltrados
        };
    }
    
    /**
     * Función principal
     */
    async function getInvestigacionData() {
        try {
            console.log('═══════════════════════════════════════════════════════');
            console.log('📊 [API INVESTIGACIÓN] INICIANDO PETICIÓN');
            console.log('═══════════════════════════════════════════════════════');
            
            // Verificar que getDB está disponible
            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no está disponible. Asegúrate de cargar config/database.js ANTES.');
            }
            
            // Obtener instancia de Database
            const db = window.getDB('investigacion');
            
            if (!db || !db.getUrl()) {
                throw new Error('Módulo "investigacion" no configurado en database.js');
            }
            
            console.log('🔗 URL Apps Script:', db.getUrl());
            console.log('📤 Enviando petición a Google Sheets...');
            
            // Obtener datos desde Google Apps Script
            const rawResponse = await db.get();
            
            console.log('───────────────────────────────────────────────────────');
            console.log('📦 RESPUESTA RECIBIDA');
            console.log('───────────────────────────────────────────────────────');
            console.log('Tipo:', typeof rawResponse);
            console.log('Success:', rawResponse?.success);
            
            // Validación básica
            if (!rawResponse || typeof rawResponse !== 'object') {
                throw new Error('Respuesta inválida del Apps Script (no es objeto)');
            }
            
            if (!rawResponse.success) {
                const errorMsg = rawResponse.error || rawResponse.message || 'Error desconocido';
                throw new Error('Error en Google Apps Script: ' + errorMsg);
            }
            
            const dataAgrupada = rawResponse.data || {};
            
            if (typeof dataAgrupada !== 'object' || Array.isArray(dataAgrupada)) {
                console.error('❌ Los datos NO tienen la estructura esperada:', dataAgrupada);
                throw new Error('Los datos recibidos no tienen la estructura esperada (debe ser objeto con DGI, IC, TESIS)');
            }
            
            console.log('📋 Grupos encontrados:', Object.keys(dataAgrupada));
            
            console.log('───────────────────────────────────────────────────────');
            console.log('🔄 PROCESANDO PROYECTOS POR GRUPO');
            console.log('───────────────────────────────────────────────────────');
            
            const proyectosTotales = [];
            let totalFiltrados = 0;
            
            // Procesar DGI
            if (dataAgrupada.DGI && dataAgrupada.DGI.records) {
                console.log(`📊 Procesando DGI: ${dataAgrupada.DGI.records.length} registros`);
                const resultado = procesarRegistros(dataAgrupada.DGI.records, 'DGI');
                proyectosTotales.push(...resultado.procesados);
                totalFiltrados += resultado.filtrados;
            }
            
            // Procesar IC (Instituto Científico)
            if (dataAgrupada.IC && dataAgrupada.IC.records) {
                console.log(`📊 Procesando IC: ${dataAgrupada.IC.records.length} registros`);
                const resultado = procesarRegistros(dataAgrupada.IC.records, 'IC');
                proyectosTotales.push(...resultado.procesados);
                totalFiltrados += resultado.filtrados;
            }
            
            // Procesar TESIS
            if (dataAgrupada.TESIS && dataAgrupada.TESIS.records) {
                console.log(`📊 Procesando TESIS: ${dataAgrupada.TESIS.records.length} registros`);
                const resultado = procesarRegistros(dataAgrupada.TESIS.records, 'TESIS');
                proyectosTotales.push(...resultado.procesados);
                totalFiltrados += resultado.filtrados;
            }
            
            console.log(`✅ Total proyectos procesados: ${proyectosTotales.length}`);
            console.log(`⏭️ Total proyectos filtrados: ${totalFiltrados}`);
            
            if (proyectosTotales.length === 0) {
                console.warn('⚠️ Ningún proyecto pasó los filtros de validación');
                return {
                    success: true,
                    total: 0,
                    timestamp: new Date().toISOString(),
                    data: [],
                    source: 'API Centralizada - Google Apps Script',
                    message: 'No hay proyectos activos disponibles'
                };
            }
            
            console.log('───────────────────────────────────────────────────────');
            console.log('🔢 ORDENANDO PROYECTOS');
            console.log('───────────────────────────────────────────────────────');
            
            // Ordenar proyectos
            proyectosTotales.sort((a, b) => {
                // 1. Por tipo (DGI > INSTITUTO > TESIS)
                const prioA = PRIORIDAD_TIPOS_INVESTIGACION[a.tipo] || 999;
                const prioB = PRIORIDAD_TIPOS_INVESTIGACION[b.tipo] || 999;
                
                if (prioA !== prioB) {
                    return prioA - prioB;
                }
                
                // 2. Por facultad (alfabético)
                const facultadA = a.facultad || '';
                const facultadB = b.facultad || '';
                const compFacultad = facultadA.localeCompare(facultadB);
                
                if (compFacultad !== 0) {
                    return compFacultad;
                }
                
                // 3. Por escuela (alfabético)
                const escuelaA = a.escuela || '';
                const escuelaB = b.escuela || '';
                const compEscuela = escuelaA.localeCompare(escuelaB);
                
                if (compEscuela !== 0) {
                    return compEscuela;
                }
                
                // 4. Por año (descendente - más reciente primero)
                // Convertir año a número cuando sea posible
                const anioA = parseInt(a.anio) || 0;
                const anioB = parseInt(b.anio) || 0;
                
                return anioB - anioA;
            });
            
            console.log('✅ Proyectos ordenados correctamente');
            
            // Estadísticas por tipo
            const estadisticas = {};
            proyectosTotales.forEach(p => {
                estadisticas[p.tipo] = (estadisticas[p.tipo] || 0) + 1;
            });
            
            console.log('───────────────────────────────────────────────────────');
            console.log('📊 ESTADÍSTICAS POR TIPO');
            console.log('───────────────────────────────────────────────────────');
            Object.keys(estadisticas).sort().forEach(tipo => {
                console.log(`   ${tipo}: ${estadisticas[tipo]}`);
            });
            
            // Respuesta final
            const response = {
                success: true,
                total: proyectosTotales.length,
                timestamp: new Date().toISOString(),
                data: proyectosTotales,
                source: 'API Centralizada - Google Apps Script',
                estadisticas: estadisticas
            };
            
            console.log('═══════════════════════════════════════════════════════');
            console.log('✅ RESPUESTA GENERADA EXITOSAMENTE');
            console.log(`📊 Total proyectos: ${proyectosTotales.length}`);
            console.log('═══════════════════════════════════════════════════════');
            
            return response;
            
        } catch (error) {
            console.error('═══════════════════════════════════════════════════════');
            console.error('❌ ERROR EN API INVESTIGACIÓN');
            console.error('═══════════════════════════════════════════════════════');
            console.error('Tipo de error:', error.name);
            console.error('Mensaje:', error.message);
            console.error('Stack:', error.stack);
            console.error('═══════════════════════════════════════════════════════');
            
            return {
                success: false,
                error: 'Error al procesar proyectos de investigación',
                message: error.message,
                timestamp: new Date().toISOString(),
                total: 0,
                data: []
            };
        }
    }
    
    // Exportar a window
    window.getInvestigacionData = getInvestigacionData;
    window.PRIORIDAD_TIPOS_INVESTIGACION = PRIORIDAD_TIPOS_INVESTIGACION;
    
    console.log('✅ InvestigacionAPI v4.0 cargada y disponible en window');
    console.log('📋 Estructura esperada: { success, data: { DGI, IC, TESIS } }');
    console.log('📋 Columnas por registro:');
    console.log('   - ID');
    console.log('   - Tipo Proyecto');
    console.log('   - Año');
    console.log('   - Nombre Documento');
    console.log('   - Enlace PDF');
    console.log('   - Estado');
    console.log('   - Facultad (solo TESIS)');
    console.log('   - Escuela Profesional (solo TESIS)');
    
})();
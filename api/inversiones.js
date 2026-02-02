/**
 * =============================================================================
 * API CENTRALIZADA - INVERSIONES
 * =============================================================================
 * Ubicación: api/inversiones.js
 * Versión: Migrada de PHP a JS (2026)
 * Fuente de datos: Google Apps Script
 * 
 * ARQUITECTURA DE 3 CAPAS:
 * 1. Presentación: modules/5_inversiones/index.html + scripts.js
 * 2. Lógica (ESTA CAPA): api/inversiones.js
 * 3. Datos: Google Sheets via Apps Script (config/database.js)
 * 
 * CARACTERÍSTICAS:
 * - Agrupa por SECCIONES (similar a Becas)
 * - Orden de prioridad específico para secciones
 */

// =============================================================================
// ORDEN DE PRIORIDAD DE SECCIONES
// =============================================================================

const PRIORIDAD_SECCIONES_INVERSIONES = {
    'INVERSIONES Y REINVERSIONES': 1,
    'OBRAS DE INFRAESTRUCTURA': 2,
    'RECURSOS DE DIVERSA FUENTE': 3
};

// =============================================================================
// FUNCIÓN PRINCIPAL DE LA API
// =============================================================================

async function getInversionesData() {
    try {
        console.log('📊 [API INVERSIONES] Iniciando petición...');
        
        // 1. Obtener instancia de Database para el módulo 'inversiones'
        const db = getDB('inversiones');
        
        if (!db || !db.getUrl()) {
            throw new Error('Módulo "inversiones" no configurado en database.js');
        }
        
        console.log('🔗 [API INVERSIONES] URL Apps Script:', db.getUrl());
        
        // 2. Obtener datos desde Google Apps Script
        const rawResponse = await db.get();
        
        console.log('📦 [API INVERSIONES] Respuesta cruda recibida:', rawResponse);
        
        // 3. Validación básica de la respuesta del Apps Script
        if (!rawResponse || typeof rawResponse !== 'object') {
            throw new Error('Respuesta inválida del Apps Script');
        }
        
        if (!rawResponse.success) {
            throw new Error('Error en respuesta del Apps Script: ' + (rawResponse.error || 'desconocido'));
        }
        
        const datosCrudos = rawResponse.data || [];
        
        if (!Array.isArray(datosCrudos)) {
            throw new Error('Los datos recibidos no son un array');
        }
        
        console.log(`📄 [API INVERSIONES] Documentos crudos recibidos: ${datosCrudos.length}`);
        
        // Si no hay documentos, retornar respuesta vacía válida
        if (datosCrudos.length === 0) {
            console.log('⚠️ [API INVERSIONES] No se encontraron documentos');
            return {
                success: true,
                secciones: [],
                total: 0,
                timestamp: new Date().toISOString(),
                source: 'API Centralizada - Google Apps Script',
                message: 'No se encontraron documentos de inversiones'
            };
        }
        
        // 4. Agrupar por sección (igual que la versión MySQL/PHP)
        const secciones = {};
        
        datosCrudos.forEach(fila => {
            // Normalización flexible de campos
            const seccion = String(
                fila.Sección || 
                fila.seccion || 
                fila.Seccion || 
                'Sin sección'
            ).trim();
            
            // Crear sección si no existe
            if (!secciones[seccion]) {
                secciones[seccion] = {
                    nombre: seccion,
                    documentos: []
                };
            }
            
            // Agregar documento a la sección
            secciones[seccion].documentos.push({
                id: parseInt(fila.ID || fila.id || 0),
                subseccion: String(
                    fila.Subsección || 
                    fila.subseccion || 
                    fila.Subseccion || 
                    ''
                ).trim(),
                tipo: String(fila.Tipo || fila.tipo || '').trim(),
                anio: String(fila.Año || fila.anio || '').trim(),
                nombre_original: String(
                    fila.Nombre_Original || 
                    fila.nombre_original || 
                    fila['Nombre Original'] || 
                    fila['Nombre del documento'] || 
                    ''
                ).trim(),
                enlace: String(
                    fila.Enlace || 
                    fila.enlace || 
                    fila.Link || 
                    fila.URL || 
                    ''
                ).trim()
            });
        });
        
        console.log('📁 [API INVERSIONES] Secciones agrupadas:', Object.keys(secciones));
        
        // 5. Convertir a array indexado y agregar total por sección
        let seccionesArray = Object.values(secciones);
        
        seccionesArray.forEach(seccion => {
            seccion.total = seccion.documentos.length;
        });
        
        console.log(`✅ [API INVERSIONES] Total de secciones: ${seccionesArray.length}`);
        
        // 6. Ordenar secciones con la misma prioridad que tenía el FIELD en MySQL
        seccionesArray.sort((a, b) => {
            const prioA = PRIORIDAD_SECCIONES_INVERSIONES[a.nombre] || 999;
            const prioB = PRIORIDAD_SECCIONES_INVERSIONES[b.nombre] || 999;
            return prioA - prioB;
        });
        
        console.log('🔄 [API INVERSIONES] Secciones ordenadas por prioridad');
        
        // 7. Respuesta final (mantiene compatibilidad con el frontend anterior)
        const response = {
            success: true,
            secciones: seccionesArray,
            total: datosCrudos.length,
            timestamp: new Date().toISOString(),
            source: 'API Centralizada - Google Apps Script'
        };
        
        console.log('✅ [API INVERSIONES] Respuesta final generada:', {
            secciones: response.secciones.length,
            totalDocumentos: response.total,
            timestamp: response.timestamp
        });
        
        return response;
        
    } catch (error) {
        console.error('❌ [API INVERSIONES] Error:', error);
        
        // Respuesta de error estructurada
        return {
            success: false,
            error: 'Error al procesar datos de inversiones',
            message: error.message,
            timestamp: new Date().toISOString()
        };
    }
}

// =============================================================================
// EXPORTAR PARA USO GLOBAL
// =============================================================================

if (typeof window !== 'undefined') {
    window.getInversionesData = getInversionesData;
    window.PRIORIDAD_SECCIONES_INVERSIONES = PRIORIDAD_SECCIONES_INVERSIONES;
    console.log('✅ API Inversiones JS cargada correctamente');
}

// =============================================================================
// SOPORTE PARA NODE.JS (OPCIONAL)
// =============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { getInversionesData, PRIORIDAD_SECCIONES_INVERSIONES };
}
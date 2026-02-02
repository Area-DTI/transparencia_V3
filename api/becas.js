/**
 * =============================================================================
 * API CENTRALIZADA - BECAS
 * =============================================================================
 * Ubicación: api/becas.js
 * Versión: Migrada de PHP a JS (2026)
 * Fuente de datos: Google Apps Script
 * 
 * ARQUITECTURA DE 3 CAPAS:
 * 1. Presentación: modules/4_becas/index.html + scripts.js
 * 2. Lógica (ESTA CAPA): api/becas.js
 * 3. Datos: Google Sheets via Apps Script (config/database.js)
 * 
 * DIFERENCIA CON CONTABILIDAD:
 * - Agrupa por SECCIONES (no por años)
 * - Tiene orden de prioridad específico para las secciones
 */

// =============================================================================
// ORDEN DE PRIORIDAD DE SECCIONES
// =============================================================================

const PRIORIDAD_SECCIONES = {
    'NÚMERO DE BECAS OFERTADAS Y NÚMERO DE BENEFICIARIOS': 1,
    'BECAS OFRECIDAS': 2,
    'RESUMEN DE BECAS OFRECIDAS Y OTORGADAS': 3,
    'CRÉDITOS EDUCATIVOS': 4,
    'BECAS: NIVEL POSGRADO Y SEGUNDAS ESPECIALIDADES': 5
};

// =============================================================================
// FUNCIÓN PRINCIPAL DE LA API
// =============================================================================

async function getBecasData() {
    try {
        console.log('📊 [API BECAS] Iniciando petición...');
        
        // 1. Obtener instancia de Database para el módulo 'becas'
        const db = getDB('becas');
        
        if (!db || !db.getUrl()) {
            throw new Error('Módulo "becas" no configurado en database.js');
        }
        
        console.log('🔗 [API BECAS] URL Apps Script:', db.getUrl());
        
        // 2. Obtener datos desde Google Apps Script
        const rawResponse = await db.get();
        
        console.log('📦 [API BECAS] Respuesta cruda recibida:', rawResponse);
        
        // 3. Validación básica de la respuesta del Apps Script
        if (!rawResponse || typeof rawResponse !== 'object') {
            throw new Error('Respuesta inválida del Apps Script');
        }
        
        if (!rawResponse.success) {
            throw new Error('Error en respuesta del Apps Script: ' + (rawResponse.error || 'desconocido'));
        }
        
        const datos = rawResponse.data || [];
        
        if (!Array.isArray(datos)) {
            throw new Error('Los datos recibidos no son un array');
        }
        
        console.log(`📄 [API BECAS] Documentos crudos recibidos: ${datos.length}`);
        
        // Si no hay documentos, retornar respuesta vacía válida
        if (datos.length === 0) {
            console.log('⚠️ [API BECAS] No se encontraron documentos');
            return {
                success: true,
                secciones: [],
                total: 0,
                timestamp: new Date().toISOString(),
                source: 'API Centralizada - Google Apps Script',
                message: 'No se encontraron documentos de becas'
            };
        }
        
        // 4. Agrupar por sección (igual que la versión MySQL/PHP)
        const secciones = {};
        
        datos.forEach(fila => {
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
                categoria: String(fila.Categoría || fila.categoria || '').trim(),
                subcategoria: String(fila.Subcategoría || fila.subcategoria || '').trim(),
                semestre: String(fila.Semestre || fila.semestre || '').trim(),
                tipo_periodo: String(fila.Tipo_Periodo || fila.tipo_periodo || '').trim(),
                anio: String(fila.Año || fila.anio || '').trim(),
                nombre_original: String(
                    fila.Nombre_Original || 
                    fila.nombre_original || 
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
        
        console.log('📁 [API BECAS] Secciones agrupadas:', Object.keys(secciones));
        
        // 5. Convertir a array indexado y agregar total por sección
        let seccionesArray = Object.values(secciones);
        
        seccionesArray.forEach(seccion => {
            seccion.total = seccion.documentos.length;
        });
        
        console.log(`✅ [API BECAS] Total de secciones: ${seccionesArray.length}`);
        
        // 6. Ordenar secciones con la misma prioridad que tenía el FIELD en MySQL
        seccionesArray.sort((a, b) => {
            const prioA = PRIORIDAD_SECCIONES[a.nombre] || 999;
            const prioB = PRIORIDAD_SECCIONES[b.nombre] || 999;
            return prioA - prioB;
        });
        
        console.log('🔄 [API BECAS] Secciones ordenadas por prioridad');
        
        // 7. Respuesta final (mantiene compatibilidad con el frontend anterior)
        const response = {
            success: true,
            secciones: seccionesArray,
            total: datos.length,
            timestamp: new Date().toISOString(),
            source: 'API Centralizada - Google Apps Script'
        };
        
        console.log('✅ [API BECAS] Respuesta final generada:', {
            secciones: response.secciones.length,
            totalDocumentos: response.total,
            timestamp: response.timestamp
        });
        
        return response;
        
    } catch (error) {
        console.error('❌ [API BECAS] Error:', error);
        
        // Respuesta de error estructurada
        return {
            success: false,
            error: 'Error al procesar datos de becas',
            message: error.message,
            timestamp: new Date().toISOString()
        };
    }
}

// =============================================================================
// EXPORTAR PARA USO GLOBAL
// =============================================================================

if (typeof window !== 'undefined') {
    window.getBecasData = getBecasData;
    window.PRIORIDAD_SECCIONES = PRIORIDAD_SECCIONES;
    console.log('✅ API Becas JS cargada correctamente');
}

// =============================================================================
// SOPORTE PARA NODE.JS (OPCIONAL)
// =============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { getBecasData, PRIORIDAD_SECCIONES };
}
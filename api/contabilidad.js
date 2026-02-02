/**
 * =============================================================================
 * API CENTRALIZADA - ESTADOS FINANCIEROS (CONTABILIDAD)
 * =============================================================================
 * Ubicación: api/contabilidad.js
 * Versión: Migrada de PHP a JS (2026)
 * Fuente de datos: Google Apps Script
 * 
 * ARQUITECTURA DE 3 CAPAS:
 * 1. Presentación: modules/3_contabilidad/index.html + scripts.js
 * 2. Lógica (ESTA CAPA): api/contabilidad.js
 * 3. Datos: Google Sheets via Apps Script (config/database.js)
 */

// =============================================================================
// IMPORTAR CONFIGURACIÓN DE BASE DE DATOS
// =============================================================================

// Este script debe cargarse DESPUÉS de config/database.js en el HTML
// O usar import si trabajas con módulos ES6

// =============================================================================
// FUNCIÓN PRINCIPAL DE LA API
// =============================================================================

async function getContabilidadData() {
    try {
        console.log('📊 [API CONTABILIDAD] Iniciando petición...');
        
        // 1. Obtener instancia de Database para el módulo 'contabilidad'
        const db = getDB('contabilidad');
        
        if (!db || !db.getUrl()) {
            throw new Error('Módulo "contabilidad" no configurado en database.js');
        }
        
        console.log('🔗 [API CONTABILIDAD] URL Apps Script:', db.getUrl());
        
        // 2. Obtener datos desde Google Apps Script
        const rawResponse = await db.get();
        
        console.log('📦 [API CONTABILIDAD] Respuesta cruda recibida:', rawResponse);
        
        // 3. Validación básica de la respuesta del Apps Script
        if (!rawResponse || typeof rawResponse !== 'object') {
            throw new Error('Respuesta inválida del Apps Script');
        }
        
        if (!rawResponse.success) {
            throw new Error('Error en respuesta del Apps Script: ' + (rawResponse.error || 'desconocido'));
        }
        
        const documentosCrudos = rawResponse.data || [];
        
        if (!Array.isArray(documentosCrudos)) {
            throw new Error('Los datos recibidos no son un array');
        }
        
        console.log(`📄 [API CONTABILIDAD] Documentos crudos recibidos: ${documentosCrudos.length}`);
        
        // Si no hay documentos, retornar respuesta vacía válida
        if (documentosCrudos.length === 0) {
            console.log('⚠️ [API CONTABILIDAD] No se encontraron documentos');
            return {
                success: true,
                data: [],
                total: 0,
                timestamp: new Date().toISOString(),
                source: 'API Centralizada - Google Apps Script',
                message: 'No se encontraron documentos de contabilidad'
            };
        }
        
        // 4. Normalizar y mapear campos (mantener compatibilidad con frontend)
        const documentos = documentosCrudos.map(fila => {
            // Normalización flexible de campos (múltiples nombres posibles)
            return {
                id: parseInt(fila.ID || fila.id || 0),
                Nombre: String(fila.Nombre || fila.nombre || fila['Nombre del documento'] || '').trim(),
                Año: String(fila.Año || fila.anio || fila['AÃ±o'] || '').trim(),
                TipoEstadoFinanciero: String(fila.TipoEstadoFinanciero || fila.tipo_estado_financiero || fila.Tipo || '').trim(),
                Dia: String(fila.Dia || fila.dia || fila['DÃ­a'] || '').trim(),
                Mes: String(fila.Mes || fila.mes || '').trim(),
                Año_Detalle: String(fila.Año_Detalle || fila.anio_detalle || fila['Año Detalle'] || '').trim(),
                NombreOriginal: String(fila.NombreOriginal || fila.nombre_original || fila['Nombre Original'] || '').trim(),
                Enlace: String(fila.Enlace || fila.enlace || fila.Link || fila.URL || '').trim()
            };
        });
        
        console.log(`✅ [API CONTABILIDAD] Documentos normalizados: ${documentos.length}`);
        
        // 5. Ordenar igual que en la versión MySQL (año DESC, nombre ASC)
        documentos.sort((a, b) => {
            // Año DESC (convertir a número si es posible, sino 0)
            const anioA = isNaN(a.Año) ? 0 : parseInt(a.Año);
            const anioB = isNaN(b.Año) ? 0 : parseInt(b.Año);
            
            if (anioA !== anioB) {
                return anioB - anioA; // Descendente
            }
            
            // Nombre ASC (alfabético)
            return a.Nombre.localeCompare(b.Nombre);
        });
        
        console.log('🔄 [API CONTABILIDAD] Documentos ordenados correctamente');
        
        // 6. Respuesta final (mismo formato que antes con MySQL/PHP)
        const response = {
            success: true,
            data: documentos,
            total: documentos.length,
            timestamp: new Date().toISOString(),
            source: 'API Centralizada - Google Apps Script'
        };
        
        console.log('✅ [API CONTABILIDAD] Respuesta final generada:', {
            total: response.total,
            timestamp: response.timestamp
        });
        
        return response;
        
    } catch (error) {
        console.error('❌ [API CONTABILIDAD] Error:', error);
        
        // Respuesta de error estructurada
        return {
            success: false,
            error: 'Error al procesar datos de contabilidad',
            message: error.message,
            timestamp: new Date().toISOString()
        };
    }
}

// =============================================================================
// EXPORTAR PARA USO GLOBAL
// =============================================================================

if (typeof window !== 'undefined') {
    window.getContabilidadData = getContabilidadData;
    console.log('✅ API Contabilidad JS cargada correctamente');
}

// =============================================================================
// SOPORTE PARA NODE.JS (OPCIONAL)
// =============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { getContabilidadData };
}
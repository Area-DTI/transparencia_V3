/**
 * =============================================================================
 * API CENTRALIZADA - REMUNERACIONES
 * =============================================================================
 * Ubicación: api/remuneraciones.js
 * Conecta a Google Apps Script via config/database.js
 * Transforma array crudo → array normalizado
 *
 * Columnas en Google Sheets:
 *   ID | Título | Enlace PDF
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando RemuneracionesAPI...');

    // Extraer campo con múltiples posibles nombres de clave
    function getField(obj, keys, defaultVal = '') {
        for (const key of keys) {
            if (obj[key] !== undefined && obj[key] !== null && String(obj[key]).trim() !== '') {
                return obj[key];
            }
        }
        return defaultVal;
    }

    // Validar URL
    function isValidUrl(url) {
        try { new URL(url); return true; }
        catch (e) { return false; }
    }

    /**
     * Obtener todos los documentos de remuneraciones normalizados
     */
    async function getRemuneracionesData() {
        try {
            console.log('📊 [Remuneraciones] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/remuneraciones.js');
            }

            const db = window.getDB('remuneraciones');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "remuneraciones" no configurado en database.js');
            }

            console.log('🔗 [Remuneraciones] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [Remuneraciones] Respuesta cruda:', rawResponse);

            if (!rawResponse || typeof rawResponse !== 'object') {
                throw new Error('Respuesta inválida del Apps Script');
            }

            // Normalizar formato de respuesta
            let registros = [];

            if (Array.isArray(rawResponse)) {
                registros = rawResponse;
            } else if (rawResponse.success && Array.isArray(rawResponse.data)) {
                registros = rawResponse.data;
            } else if (!rawResponse.success) {
                throw new Error('Apps Script error: ' + (rawResponse.error || rawResponse.message || 'desconocido'));
            } else {
                throw new Error('Formato de respuesta no reconocido');
            }

            console.log(`📄 [Remuneraciones] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, data: [], total: 0 };
            }

            // ============================================================
            // PROCESAR cada registro
            // ============================================================
            const datos = [];

            registros.forEach(reg => {
                const id = parseInt(getField(reg, ['ID', 'id'], 0), 10);

                const titulo = String(getField(reg, [
                    'Título', 'Titulo', 'titulo', 'TÍTULO'
                ], '')).trim();

                const enlacePdf = String(getField(reg, [
                    'Enlace PDF', 'Enlace_PDF', 'enlace_pdf', 'EnlacePDF', 'Enlace', 'enlace'
                ], '')).trim();

                // Filtrar: debe tener título y enlace válido
                if (!titulo || !enlacePdf || !isValidUrl(enlacePdf)) {
                    return; // skip
                }

                datos.push({
                    id: id,
                    Titulo: titulo,
                    Enlace: enlacePdf
                });
            });

            // Ordenar por ID ascendente
            datos.sort((a, b) => a.id - b.id);

            console.log(`✅ [Remuneraciones] Datos procesados: ${datos.length}`);

            return {
                success: true,
                data: datos,
                total: datos.length
            };

        } catch (error) {
            console.error('❌ [Remuneraciones] Error:', error);
            return {
                success: false,
                error: 'Error al procesar remuneraciones',
                message: error.message
            };
        }
    }

    // Exportar a window
    window.getRemuneracionesData = getRemuneracionesData;

    console.log('✅ RemuneracionesAPI cargada → window.getRemuneracionesData()');

})();
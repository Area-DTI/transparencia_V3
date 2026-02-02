/**
 * =============================================================================
 * API CENTRALIZADA - REGLAMENTOS
 * =============================================================================
 * Ubicación: api/reglamentos.js
 * Conecta a Google Apps Script via config/database.js
 * Transforma array crudo → array normalizado con Seccion, Año, etc.
 *
 * Columnas en Google Sheets:
 *   ID | Sección | Título | Resolución | Es Subitem | Enlace
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando ReglamentosAPI...');

    // Extraer campo con múltiples posibles nombres de clave
    function getField(obj, keys, defaultVal = '') {
        for (const key of keys) {
            if (obj[key] !== undefined && obj[key] !== null && String(obj[key]).trim() !== '') {
                return obj[key];
            }
        }
        return defaultVal;
    }

    // Extraer año de un string de resolución, ej: "Res. N°573-2025/CU-UAC" → "2025"
    function extraerAnioDeResolucion(resolucion) {
        if (!resolucion) return '';
        const match = resolucion.match(/(\d{4})/);
        return match ? match[1] : '';
    }

    // Validar URL
    function isValidUrl(url) {
        try { new URL(url); return true; }
        catch (e) { return false; }
    }

    /**
     * Obtener todos los reglamentos normalizados
     */
    async function getReglamentosData() {
        try {
            console.log('📊 [Reglamentos] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/reglamentos.js');
            }

            const db = window.getDB('reglamentos');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "reglamentos" no configurado en database.js');
            }

            console.log('🔗 [Reglamentos] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [Reglamentos] Respuesta cruda:', rawResponse);

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

            console.log(`📄 [Reglamentos] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, data: [], total: 0 };
            }

            // ============================================================
            // PROCESAR cada registro
            // ============================================================
            const datos = [];

            registros.forEach(reg => {
                const id = parseInt(getField(reg, ['ID', 'id'], 0), 10);

                const seccion = String(getField(reg, [
                    'Sección', 'Seccion', 'seccion', 'SECCIÓN'
                ], 'Sin sección')).trim();

                const titulo = String(getField(reg, [
                    'Título', 'Titulo', 'titulo', 'TÍTULO'
                ], '')).trim();

                const resolucion = String(getField(reg, [
                    'Resolución', 'Resolucion', 'resolucion', 'RESOLUCIÓN'
                ], '')).trim();

                const enlace = String(getField(reg, [
                    'Enlace', 'enlace', 'ENLACE', 'URL', 'url'
                ], '')).trim();

                // Es Subitem: puede venir como 0, 1, "0", "1", true, false
                const esSubitemRaw = getField(reg, [
                    'Es Subitem', 'Es_Subitem', 'EsSubitem', 'es_subitem', 'es subitem'
                ], 0);

                let esSubitem = 0;
                if (typeof esSubitemRaw === 'number') {
                    esSubitem = esSubitemRaw >= 1 ? 1 : 0;
                } else if (typeof esSubitemRaw === 'string') {
                    esSubitem = ['1', 'si', 'sí', 'yes', 'true'].includes(esSubitemRaw.toLowerCase().trim()) ? 1 : 0;
                } else if (typeof esSubitemRaw === 'boolean') {
                    esSubitem = esSubitemRaw ? 1 : 0;
                }

                // Filtrar: debe tener título y enlace válido
                if (!titulo || !enlace || !isValidUrl(enlace)) {
                    return; // skip
                }

                // Extraer año de la resolución
                const anio = extraerAnioDeResolucion(resolucion);

                // Construir nombre del documento para mostrar
                let nombreDocumento = titulo;
                if (resolucion) {
                    nombreDocumento += ` — ${resolucion}`;
                }

                datos.push({
                    id: id,
                    Seccion: seccion,
                    Subcategoria: nombreDocumento,
                    resolucion: resolucion,
                    Año: anio,
                    Enlace: enlace,
                    es_subitem: esSubitem
                });
            });

            // Ordenar: por sección, luego items antes que subitems, luego por id
            datos.sort((a, b) => {
                const cmpSeccion = a.Seccion.localeCompare(b.Seccion);
                if (cmpSeccion !== 0) return cmpSeccion;
                if (a.es_subitem !== b.es_subitem) return a.es_subitem - b.es_subitem;
                return a.id - b.id;
            });

            console.log(`✅ [Reglamentos] Datos procesados: ${datos.length}`);

            return {
                success: true,
                data: datos,
                total: datos.length
            };

        } catch (error) {
            console.error('❌ [Reglamentos] Error:', error);
            return {
                success: false,
                error: 'Error al procesar reglamentos',
                message: error.message
            };
        }
    }

    // Exportar a window
    window.getReglamentosData = getReglamentosData;

    console.log('✅ ReglamentosAPI cargada → window.getReglamentosData()');

})();
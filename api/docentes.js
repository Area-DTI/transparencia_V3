/**
 * =============================================================================
 * API CENTRALIZADA - DOCENTES
 * =============================================================================
 * Ubicación: api/docentes.js
 * Conecta a Google Apps Script via config/database.js
 *
 * Columnas en Google Sheets (exactas):
 *   ID | Sección | Categoría | Semestre | Mes | Programa | Enlace PDF
 *
 * Mes puede ser null (ej: Pregrado sin mes específico)
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando DocentesAPI...');

    // Extraer campo con múltiples posibles nombres de clave
    function getField(obj, keys, defaultVal = '') {
        for (const key of keys) {
            if (obj[key] !== undefined && obj[key] !== null && String(obj[key]).trim() !== '') {
                return obj[key];
            }
        }
        return defaultVal;
    }

    function isValidUrl(url) {
        try { new URL(url); return true; }
        catch (e) { return false; }
    }

    // Orden canónico de secciones
    const ORDEN_SECCIONES = {
        'Pregrado': 1,
        'Posgrado': 2,
        'Segundas Especialidades': 3
    };

    /**
     * Obtener todos los documentos de docentes normalizados
     */
    async function getDocentesData() {
        try {
            console.log('📊 [Docentes] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/docentes.js');
            }

            const db = window.getDB('docentes');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "docentes" no configurado en database.js');
            }

            console.log('🔗 [Docentes] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [Docentes] Respuesta cruda:', rawResponse);

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

            console.log(`📄 [Docentes] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, data: [], total: 0 };
            }

            // Log columnas detectadas
            console.log('📋 Columnas detectadas:', Object.keys(registros[0]));

            // ============================================================
            // PROCESAR cada registro
            // ============================================================
            const datos = [];

            registros.forEach((reg) => {
                const id = parseInt(getField(reg, ['ID', 'id'], 0), 10);

                const seccion = String(getField(reg, [
                    'Sección', 'Seccion', 'seccion', 'SECCIÓN'
                ], '')).trim();

                const categoria = String(getField(reg, [
                    'Categoría', 'Categoria', 'categoria', 'CATEGORÍA'
                ], '')).trim();

                const semestre = String(getField(reg, [
                    'Semestre', 'semestre', 'SEMESTRE'
                ], '')).trim();

                const mes = String(getField(reg, [
                    'Mes', 'mes', 'MES'
                ], '')).trim();

                const programa = String(getField(reg, [
                    'Programa', 'programa', 'PROGRAMA'
                ], '')).trim();

                const enlacePdf = String(getField(reg, [
                    'Enlace PDF', 'Enlace_PDF', 'enlace_pdf', 'EnlacePDF', 'Enlace', 'enlace'
                ], '')).trim();

                // Filtrar: debe tener ID y enlace válido
                if (id === 0) return;
                if (!enlacePdf || !isValidUrl(enlacePdf)) return;

                datos.push({
                    id: id,
                    Seccion: seccion || 'Sin sección',
                    Categoria: categoria || 'Sin categoría',
                    Semestre: semestre || '-',
                    Mes: mes || '',          // Puede estar vacío (ej: Pregrado)
                    Programa: programa || 'Sin programa',
                    Enlace: enlacePdf
                });
            });

            // ============================================================
            // ORDENAR: Sección → Programa → Mes
            // ============================================================
            datos.sort((a, b) => {
                const secA = ORDEN_SECCIONES[a.Seccion] || 999;
                const secB = ORDEN_SECCIONES[b.Seccion] || 999;
                if (secA !== secB) return secA - secB;

                if (a.Programa !== b.Programa) return a.Programa.localeCompare(b.Programa);

                return a.Mes.localeCompare(b.Mes);
            });

            console.log(`✅ [Docentes] Datos procesados y ordenados: ${datos.length}`);

            // Estadísticas por sección
            const stats = {};
            datos.forEach(d => { stats[d.Seccion] = (stats[d.Seccion] || 0) + 1; });
            console.log('📊 [Docentes] Por sección:', stats);

            return {
                success: true,
                data: datos,
                total: datos.length,
                estadisticas: stats
            };

        } catch (error) {
            console.error('❌ [Docentes] Error:', error);
            return {
                success: false,
                error: 'Error al procesar docentes',
                message: error.message,
                data: [],
                total: 0
            };
        }
    }

    // Exportar a window
    window.getDocentesData = getDocentesData;

    console.log('✅ DocentesAPI cargada → window.getDocentesData()');
    console.log('📋 Columnas esperadas: ID | Sección | Categoría | Semestre | Mes | Programa | Enlace PDF');

})();
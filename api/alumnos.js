/**
 * =============================================================================
 * API CENTRALIZADA - ALUMNOS
 * =============================================================================
 * Ubicación: api/alumnos.js
 * Conecta a Google Apps Script via config/database.js
 *
 * Columnas en Google Sheets (exactas):
 *   ID | Sección | Categoría | Año | Enlace PDF
 *
 * Año puede ser un número (2024) o un rango con comas ("2017, 2018, ..., 2023")
 * → Se normaliza a "2017-2023" para mostrar en la tabla pivot.
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando AlumnosAPI...');

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

    /**
     * Normaliza el campo Año:
     *   - 2024.0          → "2024"
     *   - "2017, 2018, 2019, 2020, 2021, 2022, 2023" → "2017-2023"
     *   - "2017"          → "2017"
     */
    function normalizarAnio(valor) {
        const str = String(valor).trim();

        // Si contiene comas es un rango multi-año
        if (str.includes(',')) {
            const nums = str.split(',')
                .map(s => parseInt(s.trim(), 10))
                .filter(n => !isNaN(n))
                .sort((a, b) => a - b);

            if (nums.length >= 2) {
                return nums[0] + '-' + nums[nums.length - 1];
            }
            if (nums.length === 1) return String(nums[0]);
            return str;
        }

        // Número suelto (posiblemente con .0)
        const num = parseInt(str, 10);
        if (!isNaN(num)) return String(num);

        return str;
    }

    const ORDEN_SECCIONES = {
        'Pregrado': 1,
        'Posgrado': 2,
        'Segundas Especialidades': 3
    };

    async function getAlumnosData() {
        try {
            console.log('📊 [Alumnos] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/alumnos.js');
            }

            const db = window.getDB('alumnos');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "alumnos" no configurado en database.js');
            }

            console.log('🔗 [Alumnos] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [Alumnos] Respuesta cruda:', rawResponse);

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

            console.log(`📄 [Alumnos] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, data: [], total: 0 };
            }

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

                const anioRaw = getField(reg, [
                    'Año', 'Anio', 'año', 'anio', 'AÑO', 'ANIO'
                ], '');

                const enlacePdf = String(getField(reg, [
                    'Enlace PDF', 'Enlace_PDF', 'enlace_pdf', 'EnlacePDF', 'Enlace', 'enlace'
                ], '')).trim();

                // Filtrar
                if (id === 0) return;
                if (!enlacePdf || !isValidUrl(enlacePdf)) return;

                datos.push({
                    id: id,
                    Seccion: seccion || 'Sin sección',
                    Categoria: categoria || 'Sin categoría',
                    Anio: normalizarAnio(anioRaw),
                    Enlace: enlacePdf
                });
            });

            // ============================================================
            // ORDENAR: Sección → Categoría → Año
            // ============================================================
            datos.sort((a, b) => {
                const secA = ORDEN_SECCIONES[a.Seccion] || 999;
                const secB = ORDEN_SECCIONES[b.Seccion] || 999;
                if (secA !== secB) return secA - secB;

                if (a.Categoria !== b.Categoria) return a.Categoria.localeCompare(b.Categoria);

                // Ordenar por primer número del año
                const numA = parseInt(a.Anio, 10) || 0;
                const numB = parseInt(b.Anio, 10) || 0;
                return numA - numB;
            });

            console.log(`✅ [Alumnos] Datos procesados: ${datos.length}`);

            const stats = {};
            datos.forEach(d => { stats[d.Seccion] = (stats[d.Seccion] || 0) + 1; });
            console.log('📊 [Alumnos] Por sección:', stats);

            return {
                success: true,
                data: datos,
                total: datos.length,
                estadisticas: stats
            };

        } catch (error) {
            console.error('❌ [Alumnos] Error:', error);
            return {
                success: false,
                error: 'Error al procesar alumnos',
                message: error.message,
                data: [],
                total: 0
            };
        }
    }

    window.getAlumnosData = getAlumnosData;

    console.log('✅ AlumnosAPI cargada → window.getAlumnosData()');
    console.log('📋 Columnas esperadas: ID | Sección | Categoría | Año | Enlace PDF');

})();
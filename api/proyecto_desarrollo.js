/**
 * =============================================================================
 * API CENTRALIZADA - PROYECTO GENERAL DE DESARROLLO
 * =============================================================================
 * Ubicación: api/proyecto_desarrollo.js
 * Conecta a Google Apps Script via config/database.js
 * Transforma el array crudo en estructura agrupada por facultad
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando ProyectoDesarrolloAPI...');

    // Orden de prioridad de facultades
    const PRIORIDAD_FACULTADES = {
        'FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES': 1,
        'FACULTAD DE CIENCIAS Y HUMANIDADES': 2,
        'FACULTAD DE DERECHO Y CIENCIA POLÍTICA': 3,
        'FACULTAD DE INGENIERÍA Y ARQUITECTURA': 4,
        'FACULTAD DE CIENCIAS DE LA SALUD': 5
    };

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
     * Obtener todos los documentos agrupados por facultad
     */
    async function getAll() {
        try {
            console.log('📡 [ProyectoDesarrollo] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/proyecto_desarrollo.js');
            }

            const db = window.getDB('proyecto_desarrollo');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "proyecto_desarrollo" no configurado en database.js');
            }

            console.log('🔗 [ProyectoDesarrollo] URL:', db.getUrl());

            // Obtener datos crudos
            const rawResponse = await db.get();

            console.log('📦 [ProyectoDesarrollo] Respuesta cruda:', rawResponse);

            if (!rawResponse || typeof rawResponse !== 'object') {
                throw new Error('Respuesta inválida del Apps Script');
            }

            // Normalizar: puede venir como array directo o envuelto en { success, data }
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

            console.log(`📄 [ProyectoDesarrollo] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, data: { tablas: {} }, total_registros: 0 };
            }

            // ============================================================
            // ORGANIZAR por facultad
            // Columnas en Google Sheets: ID | Facultad | Nivel | Escuela | Enlace PEI | Enlace PGD | Enlace COPEA
            // ============================================================
            const planesPorFacultad = {};

            registros.forEach(reg => {
                const facultad = String(getField(reg, [
                    'Facultad', 'facultad', 'FACULTAD', 'Nombre Facultad', 'Nombre_Facultad'
                ], 'Sin facultad')).trim();

                const nivel = String(getField(reg, [
                    'Nivel', 'nivel'
                ], '')).trim();

                const escuela = String(getField(reg, [
                    'Escuela', 'escuela',
                    'Escuela Profesional', 'Escuela_Profesional', 'escuela_profesional'
                ], '')).trim();

                const pei = String(getField(reg, [
                    'Enlace PEI', 'Enlace_PEI', 'PEI_Enlace', 'pei_enlace', 'URL_PEI'
                ], '')).trim();

                const pgd = String(getField(reg, [
                    'Enlace PGD', 'Enlace_PGD', 'PGD_Enlace', 'pgd_enlace', 'URL_PGD'
                ], '')).trim();

                const copea = String(getField(reg, [
                    'Enlace COPEA', 'Enlace_COPEA', 'COPEA_Enlace', 'copea_enlace', 'URL_COPEA'
                ], '')).trim();

                if (!planesPorFacultad[facultad]) {
                    planesPorFacultad[facultad] = [];
                }

                planesPorFacultad[facultad].push({
                    nivel: nivel,
                    escuela: escuela,
                    pei_enlace: pei,
                    pgd_enlace: pgd,
                    copea_enlace: copea,
                    tiene_pei: pei !== '' && isValidUrl(pei),
                    tiene_pgd: pgd !== '' && isValidUrl(pgd),
                    tiene_copea: copea !== '' && isValidUrl(copea)
                });
            });

            // Ordenar facultades por prioridad
            const tablasOrdenadas = {};
            const facultadesOrdenadas = Object.keys(planesPorFacultad).sort((a, b) => {
                return (PRIORIDAD_FACULTADES[a] || 999) - (PRIORIDAD_FACULTADES[b] || 999);
            });

            facultadesOrdenadas.forEach(f => {
                // Dentro de cada facultad: primero "Facultad", luego escuelas alfabéticamente
                const filas = planesPorFacultad[f];
                const facultadRow = filas.filter(r => r.nivel === 'Facultad');
                const escuelaRows = filas.filter(r => r.nivel !== 'Facultad')
                    .sort((a, b) => a.escuela.localeCompare(b.escuela));
                tablasOrdenadas[f] = [...facultadRow, ...escuelaRows];
            });

            console.log('📁 [ProyectoDesarrollo] Facultades:', Object.keys(tablasOrdenadas));

            return {
                success: true,
                data: { tablas: tablasOrdenadas },
                total_registros: registros.length
            };

        } catch (error) {
            console.error('❌ [ProyectoDesarrollo] Error:', error);
            return {
                success: false,
                error: 'Error al procesar documentos',
                message: error.message
            };
        }
    }

    // Exportar a window
    window.ProyectoDesarrolloAPI = { getAll: getAll };

    console.log('✅ ProyectoDesarrolloAPI cargado → window.ProyectoDesarrolloAPI.getAll()');

})();
/**
 * =============================================================================
 * API CENTRALIZADA - PLANES DE ESTUDIO
 * =============================================================================
 * Ubicación: api/plan_estudios.js
 * Conecta a Google Apps Script via config/database.js
 * Transforma el array crudo en la estructura { facultades, anios_disponibles }
 */

(function() {
    'use strict';

    console.log('📥 Cargando PlanEstudiosAPI...');

    // Orden de prioridad de facultades
    const PRIORIDAD_FACULTADES = {
        'FACULTAD DE CIENCIAS ECONÓMICAS, ADMINISTRATIVAS Y CONTABLES': 1,
        'FACULTAD DE CIENCIAS Y HUMANIDADES': 2,
        'FACULTAD DE DERECHO Y CIENCIA POLÍTICA': 3,
        'FACULTAD DE INGENIERÍA Y ARQUITECTURA': 4,
        'FACULTAD DE CIENCIAS DE LA SALUD': 5
    };

    // Validar URL
    function isValidUrl(url) {
        try {
            new URL(url);
            return true;
        } catch (e) {
            return false;
        }
    }

    // Extraer campo de un objeto con múltiples posibles nombres de clave
    // Google Sheets retorna las claves EXACTAMENTE como están en la hoja
    // Ej: "Escuela Profesional" (con espacio), NO "Escuela_Profesional"
    function getField(obj, keys, defaultVal = '') {
        for (const key of keys) {
            if (obj[key] !== undefined && obj[key] !== null && String(obj[key]).trim() !== '') {
                return obj[key];
            }
        }
        return defaultVal;
    }

    // Función principal
    async function getPlanEstudiosData() {
        try {
            console.log('📊 [PlanEstudios] Iniciando petición...');

            // Verificar que getDB está disponible (viene de config/database.js)
            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/plan_estudios.js');
            }

            const db = window.getDB('plan_estudios');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "plan_estudios" no configurado en database.js');
            }

            console.log('🔗 [PlanEstudios] URL:', db.getUrl());

            // Obtener datos crudos desde Google Apps Script
            const rawResponse = await db.get();

            console.log('📦 [PlanEstudios] Respuesta cruda:', rawResponse);

            if (!rawResponse || typeof rawResponse !== 'object') {
                throw new Error('Respuesta inválida del Apps Script');
            }

            // Apps Script puede retornar:
            //   { success: true, data: [...registros...] }
            // o directamente un array: [...]
            let registros = [];

            if (Array.isArray(rawResponse)) {
                registros = rawResponse;
            } else if (rawResponse.success && Array.isArray(rawResponse.data)) {
                registros = rawResponse.data;
            } else if (!rawResponse.success && rawResponse.error) {
                throw new Error('Apps Script error: ' + (rawResponse.error || rawResponse.message || 'desconocido'));
            } else {
                throw new Error('Formato de respuesta no reconocido');
            }

            console.log(`📄 [PlanEstudios] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return {
                    success: true,
                    data: { facultades: [], anios_disponibles: [] },
                    total_registros: 0
                };
            }

            // ============================================================
            // ORGANIZAR: array plano → estructura por facultad/escuela
            // ============================================================
            const planesPorFacultad = {};
            const todosLosAnios = new Set();

            registros.forEach(reg => {
                // Mapeo flexible: soporta claves con espacio Y con guión bajo
                const facultad = String(getField(reg, [
                    'Facultad', 'facultad', 'FACULTAD',
                    'Nombre_Facultad', 'Nombre Facultad'
                ], 'Sin facultad')).trim();

                const escuela = String(getField(reg, [
                    'Escuela Profesional',    // ← como lo retorna Google Sheets
                    'Escuela_Profesional',    // ← alternativa con guión bajo
                    'escuela_profesional',
                    'Escuela', 'escuela'
                ], 'Sin escuela')).trim();

                const anioRaw = getField(reg, [
                    'Año Plan',    // ← como lo retorna Google Sheets
                    'Año_Plan',
                    'anio_plan',
                    'Año', 'anio'
                ], '');

                // Normalizar año: 2016.0 → "2016", "2016 ó 2017" se deja como string
                let anio = String(anioRaw).trim();
                if (anio.match(/^\d+\.0$/)) {
                    anio = anio.replace('.0', '');
                }

                const url_pdf = String(getField(reg, [
                    'URL PDF',     // ← como lo retorna Google Sheets
                    'URL_PDF',
                    'url_pdf',
                    'Enlace', 'enlace_pdf', 'PDF'
                ], '')).trim();

                const color = String(getField(reg, [
                    'Color Icono', // ← como lo retorna Google Sheets
                    'Color_Icono',
                    'color_icono',
                    'Color'
                ], '#0066cc')).trim();

                if (anio) {
                    todosLosAnios.add(anio);
                }

                if (!planesPorFacultad[facultad]) {
                    planesPorFacultad[facultad] = {};
                }

                if (!planesPorFacultad[facultad][escuela]) {
                    planesPorFacultad[facultad][escuela] = {
                        escuela: escuela,
                        planes: {}
                    };
                }

                planesPorFacultad[facultad][escuela].planes[anio] = {
                    anio: anio,
                    url_pdf: url_pdf,
                    color: color,
                    tiene_pdf: url_pdf !== '' && url_pdf !== '#' && isValidUrl(url_pdf)
                };
            });

            // Convertir a array de facultades
            let facultades = Object.entries(planesPorFacultad).map(([nombre, escuelas]) => ({
                nombre: nombre,
                escuelas: Object.values(escuelas)
            }));

            // Ordenar facultades por prioridad definida
            facultades.sort((a, b) => {
                return (PRIORIDAD_FACULTADES[a.nombre] || 999) - (PRIORIDAD_FACULTADES[b.nombre] || 999);
            });

            // Ordenar escuelas alfabéticamente dentro de cada facultad
            facultades.forEach(f => {
                f.escuelas.sort((a, b) => a.escuela.localeCompare(b.escuela));
            });

            // Ordenar años: numéricos primero, strings al final
            const aniosDisponibles = Array.from(todosLosAnios).sort((a, b) => {
                const numA = parseInt(a);
                const numB = parseInt(b);
                if (!isNaN(numA) && !isNaN(numB)) return numA - numB;
                if (!isNaN(numA)) return -1;
                if (!isNaN(numB)) return 1;
                return a.localeCompare(b);
            });

            console.log('📁 [PlanEstudios] Facultades:', facultades.map(f => f.nombre));
            console.log('📅 [PlanEstudios] Años:', aniosDisponibles);

            return {
                success: true,
                data: {
                    facultades: facultades,
                    anios_disponibles: aniosDisponibles
                },
                total_registros: registros.length
            };

        } catch (error) {
            console.error('❌ [PlanEstudios] Error:', error);
            return {
                success: false,
                error: 'Error al procesar planes de estudio',
                message: error.message
            };
        }
    }

    // Exportar a window
    window.getPlanEstudiosData = getPlanEstudiosData;

    console.log('✅ PlanEstudiosAPI cargada → window.getPlanEstudiosData()');

})();
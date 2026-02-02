/**
 * =============================================================================
 * API CENTRALIZADA - DIRECTIVAS
 * =============================================================================
 * Ubicación: api/directivas.js
 * Conecta a Google Apps Script via config/database.js
 *
 * Columnas en Google Sheets (exactas):
 *   ID | Sección | Título | Resolución | Es Subdirectiva | Enlace PDF
 *
 * - Resolución puede ser null/vacío (ej IDs 24,25,26) → se muestra como "-"
 * - Es Subdirectiva = 1 → se anida bajo la directiva padre inmediata anterior
 * - Secciones: "Directivas", "Investigación"
 *
 * Estructura de salida:
 *   [
 *     { nombre: "Directivas", directivas: [
 *         { titulo, resolucion, enlace, subdirectivas: [...] },
 *         ...
 *     ]},
 *     { nombre: "Investigación", directivas: [...] }
 *   ]
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando DirectivasAPI...');

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

    const ORDEN_SECCIONES = ['Directivas', 'Investigación'];

    async function getDirectivasData() {
        try {
            console.log('📊 [Directivas] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/directivas.js');
            }

            const db = window.getDB('directivas');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "directivas" no configurado en database.js');
            }

            console.log('🔗 [Directivas] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [Directivas] Respuesta cruda:', rawResponse);

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

            console.log(`📄 [Directivas] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, secciones: [], total: 0 };
            }

            console.log('📋 Columnas detectadas:', Object.keys(registros[0]));

            // ============================================================
            // PASO 1: Normalizar cada registro
            // ============================================================
            const items = [];

            registros.forEach((reg) => {
                const id = parseInt(getField(reg, ['ID', 'id'], 0), 10);

                const seccion = String(getField(reg, [
                    'Sección', 'Seccion', 'seccion', 'SECCIÓN'
                ], '')).trim();

                const titulo = String(getField(reg, [
                    'Título', 'Titulo', 'titulo', 'TÍTULO'
                ], '')).trim();

                // Resolución puede ser null → se permite
                const resolucionRaw = getField(reg, [
                    'Resolución', 'Resolucion', 'resolucion', 'RESOLUCIÓN'
                ], '');
                const resolucion = resolucionRaw ? String(resolucionRaw).trim() : '';

                const esSubRaw = getField(reg, [
                    'Es Subdirectiva', 'Es_Subdirectiva', 'es_subdirectiva',
                    'Es Subdirectiva', 'EsSubdirectiva'
                ], 0);
                const esSub = parseInt(esSubRaw, 10) === 1;

                const enlace = String(getField(reg, [
                    'Enlace PDF', 'Enlace_PDF', 'enlace_pdf', 'EnlacePDF', 'Enlace', 'enlace'
                ], '')).trim();

                // Filtrar
                if (id === 0) return;
                if (!enlace || !isValidUrl(enlace)) return;
                if (!titulo) return;

                items.push({
                    id: id,
                    seccion: seccion || 'Directivas',
                    titulo: titulo,
                    resolucion: resolucion,   // puede estar vacío
                    esSub: esSub,
                    enlace: enlace
                });
            });

            console.log(`✅ [Directivas] Items normalizados: ${items.length}`);

            // ============================================================
            // PASO 2: Ordenar por ID ascending (mantener orden original del Excel)
            // ============================================================
            items.sort((a, b) => a.id - b.id);

            // ============================================================
            // PASO 3: Agrupar por Sección y anidar subdirectivas
            // ============================================================
            const seccionesMap = new Map();

            items.forEach(item => {
                if (!seccionesMap.has(item.seccion)) {
                    seccionesMap.set(item.seccion, []);
                }
                seccionesMap.get(item.seccion).push(item);
            });

            const secciones = [];

            seccionesMap.forEach((items, seccionNombre) => {
                const directivas = [];
                let ultimoPadre = null;

                items.forEach(item => {
                    if (item.esSub && ultimoPadre) {
                        // Es subdirectiva → anida bajo el último padre
                        ultimoPadre.subdirectivas.push({
                            titulo: item.titulo,
                            resolucion: item.resolucion,
                            enlace: item.enlace
                        });
                    } else {
                        // Es directiva principal
                        ultimoPadre = {
                            titulo: item.titulo,
                            resolucion: item.resolucion,
                            enlace: item.enlace,
                            subdirectivas: []
                        };
                        directivas.push(ultimoPadre);
                    }
                });

                secciones.push({
                    nombre: seccionNombre,
                    directivas: directivas
                });
            });

            // Ordenar secciones según ORDEN_SECCIONES
            secciones.sort((a, b) => {
                const iA = ORDEN_SECCIONES.indexOf(a.nombre);
                const iB = ORDEN_SECCIONES.indexOf(b.nombre);
                if (iA === -1 && iB === -1) return a.nombre.localeCompare(b.nombre);
                if (iA === -1) return 1;
                if (iB === -1) return -1;
                return iA - iB;
            });

            console.log(`✅ [Directivas] Secciones construidas: ${secciones.length}`);
            secciones.forEach(s => {
                const subs = s.directivas.reduce((acc, d) => acc + d.subdirectivas.length, 0);
                console.log(`   • ${s.nombre}: ${s.directivas.length} principales, ${subs} subdirectiva(s)`);
            });

            return {
                success: true,
                secciones: secciones,
                total: items.length
            };

        } catch (error) {
            console.error('❌ [Directivas] Error:', error);
            return {
                success: false,
                error: 'Error al procesar directivas',
                message: error.message,
                secciones: [],
                total: 0
            };
        }
    }

    window.getDirectivasData = getDirectivasData;

    console.log('✅ DirectivasAPI cargada → window.getDirectivasData()');
    console.log('📋 Columnas esperadas: ID | Sección | Título | Resolución | Es Subdirectiva | Enlace PDF');

})();
/**
 * =============================================================================
 * API CENTRALIZADA - RESOLUCIONES
 * =============================================================================
 * Ubicación: api/resoluciones.js
 * Conecta a Google Apps Script via config/database.js
 *
 * Columnas en Google Sheets (exactas):
 *   ID | Grupo | Subgrupo | Descripción | Enlace PDF | Número Resolución | Es Subresolución
 *
 * Es Subresolución = 1 → se anida bajo la resolución padre inmediata anterior (Es Subresolución = 0)
 * Estructura de salida:
 *   [
 *     { nombre: "RESOLUCIONES", subgrupos: [
 *         { nombre: "(sin subgrupo)", resoluciones: [
 *             { descripcion, numero, enlace, subresoluciones: [...] }
 *         ]}
 *     ]},
 *     { nombre: "SOBRE ADMISIÓN", subgrupos: [
 *         { nombre: "Pregrado", resoluciones: [...] },
 *         { nombre: "Posgrado: 2025", resoluciones: [...] }
 *     ]}
 *   ]
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando ResolucionesAPI...');

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

    async function getResolucionesData() {
        try {
            console.log('📊 [Resoluciones] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/resoluciones.js');
            }

            const db = window.getDB('resoluciones');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "resoluciones" no configurado en database.js');
            }

            console.log('🔗 [Resoluciones] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [Resoluciones] Respuesta cruda:', rawResponse);

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

            console.log(`📄 [Resoluciones] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, grupos: [], total: 0 };
            }

            console.log('📋 Columnas detectadas:', Object.keys(registros[0]));

            // ============================================================
            // PASO 1: Normalizar cada registro
            // ============================================================
            const items = [];

            registros.forEach((reg) => {
                const id = parseInt(getField(reg, ['ID', 'id'], 0), 10);

                const grupo = String(getField(reg, [
                    'Grupo', 'grupo', 'GRUPO'
                ], '')).trim();

                const subgrupo = String(getField(reg, [
                    'Subgrupo', 'subgrupo', 'SUBGRUPO'
                ], '')).trim();

                const descripcion = String(getField(reg, [
                    'Descripción', 'Descripcion', 'descripcion', 'DESCRIPCIÓN'
                ], '')).trim();

                const enlace = String(getField(reg, [
                    'Enlace PDF', 'Enlace_PDF', 'enlace_pdf', 'EnlacePDF', 'Enlace', 'enlace'
                ], '')).trim();

                const numero = String(getField(reg, [
                    'Número Resolución', 'Numero_Resolucion', 'numero_resolucion',
                    'Número Resolución', 'NumeroResolucion', 'numero'
                ], '')).trim();

                const esSubResRaw = getField(reg, [
                    'Es Subresolución', 'Es_Subresolucion', 'es_subresolucion',
                    'Es Subresolución', 'EsSubresolucion', 'es_sub'
                ], 0);
                const esSubRes = parseInt(esSubResRaw, 10) === 1;

                // Filtrar
                if (id === 0) return;
                if (!enlace || !isValidUrl(enlace)) return;
                if (!grupo) return;

                items.push({
                    id: id,
                    grupo: grupo,
                    subgrupo: subgrupo,   // puede estar vacío
                    descripcion: descripcion || 'Sin descripción',
                    numero: numero || '-',
                    enlace: enlace,
                    esSubRes: esSubRes
                });
            });

            console.log(`✅ [Resoluciones] Items normalizados: ${items.length}`);

            // ============================================================
            // PASO 2: Ordenar por ID ascending (mantener orden original)
            // ============================================================
            items.sort((a, b) => a.id - b.id);

            // ============================================================
            // PASO 3: Agrupar → Subgrupo → Resoluciones con subresoluciones anidadas
            // ============================================================
            // Estructura: Map<grupo, Map<subgrupo, Array>>
            const gruposMap = new Map();

            items.forEach(item => {
                if (!gruposMap.has(item.grupo)) {
                    gruposMap.set(item.grupo, new Map());
                }

                const subgruposMap = gruposMap.get(item.grupo);
                const subgrupoKey = item.subgrupo || '';

                if (!subgruposMap.has(subgrupoKey)) {
                    subgruposMap.set(subgrupoKey, []);
                }

                subgruposMap.get(subgrupoKey).push(item);
            });

            // ============================================================
            // PASO 4: Construir estructura final con subresoluciones anidadas
            // ============================================================
            const grupos = [];

            gruposMap.forEach((subgruposMap, grupoNombre) => {
                const subgrupos = [];

                subgruposMap.forEach((resoluciones, subgrupoNombre) => {
                    // Anida subresoluciones bajo su padre inmediato
                    const resolucionesNested = [];
                    let ultimoPadre = null;

                    resoluciones.forEach(item => {
                        if (item.esSubRes && ultimoPadre) {
                            // Es subresolución → anida bajo el último padre
                            ultimoPadre.subresoluciones.push({
                                descripcion: item.descripcion,
                                numero: item.numero,
                                enlace: item.enlace
                            });
                        } else {
                            // Es resolución principal
                            ultimoPadre = {
                                descripcion: item.descripcion,
                                numero: item.numero,
                                enlace: item.enlace,
                                subresoluciones: []
                            };
                            resolucionesNested.push(ultimoPadre);
                        }
                    });

                    subgrupos.push({
                        nombre: subgrupoNombre || null,  // null = sin subgrupo
                        resoluciones: resolucionesNested
                    });
                });

                grupos.push({
                    nombre: grupoNombre,
                    subgrupos: subgrupos
                });
            });

            console.log(`✅ [Resoluciones] Grupos construidos: ${grupos.length}`);
            grupos.forEach(g => {
                console.log(`   • ${g.nombre}: ${g.subgrupos.length} subgrupo(s)`);
            });

            return {
                success: true,
                grupos: grupos,
                total: items.length
            };

        } catch (error) {
            console.error('❌ [Resoluciones] Error:', error);
            return {
                success: false,
                error: 'Error al procesar resoluciones',
                message: error.message,
                grupos: [],
                total: 0
            };
        }
    }

    window.getResolucionesData = getResolucionesData;

    console.log('✅ ResolucionesAPI cargada → window.getResolucionesData()');
    console.log('📋 Columnas esperadas: ID | Grupo | Subgrupo | Descripción | Enlace PDF | Número Resolución | Es Subresolución');

})();
/**
 * =============================================================================
 * API CENTRALIZADA - DOCUMENTOS NORMATIVOS
 * =============================================================================
 * Ubicación: api/doc_normativos.js
 * Conecta a Google Apps Script via config/database.js
 *
 * Columnas en Google Sheets (exactas, con espacios):
 *   ID | Sección | Título | Resolución | Es Subitem | Enlace | Parent ID
 *
 * - Resolución puede ser null (ej. TEMARIO DE ADMISIÓN, Decálogos)
 * - Es Subitem = 1 → se anida bajo el documento con ID = Parent ID
 * - Parent ID es EXPLÍCITO (no implícito por orden de fila)
 * - Secciones: "Documentos normativos", "Políticas", "Planes", "Decálogos"
 *
 * Estructura de salida (array de secciones):
 *   [
 *     { nombre: "Documentos normativos", documentos: [
 *         { titulo, resolucion, enlace, subitems: [
 *             { titulo, resolucion, enlace }, ...
 *         ]},
 *         ...
 *     ]},
 *     { nombre: "Políticas", documentos: [...] },
 *     ...
 *   ]
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando DocNormativosAPI...');

    // ================================================================
    // UTILIDADES
    // ================================================================

    function getField(obj, keys, defaultVal = '') {
        for (const key of keys) {
            if (obj[key] !== undefined && obj[key] !== null && String(obj[key]).trim() !== '') {
                return obj[key];
            }
        }
        return defaultVal;
    }

    function isValidUrl(str) {
        try { new URL(str); return true; }
        catch (e) { return false; }
    }

    // Orden canónico de secciones
    const ORDEN_SECCIONES = [
        'Documentos normativos',
        'Políticas',
        'Planes',
        'Decálogos'
    ];

    // ================================================================
    // FUNCIÓN PRINCIPAL
    // ================================================================

    async function getDocNormativosData() {
        try {
            console.log('📊 [DocNormativos] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/doc_normativos.js');
            }

            const db = window.getDB('doc_normativos');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "doc_normativos" no configurado en database.js');
            }

            console.log('🔗 [DocNormativos] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [DocNormativos] Respuesta cruda:', rawResponse);

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

            console.log(`📄 [DocNormativos] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, secciones: [], total: 0 };
            }

            console.log('📋 Columnas detectadas:', Object.keys(registros[0]));

            // ============================================================
            // PASO 1: Normalizar todos los registros → Map por ID
            // ============================================================
            const itemsById = new Map();

            registros.forEach((reg) => {
                const id = parseInt(getField(reg, ['ID', 'id'], 0), 10);
                if (id === 0) return;

                const seccion = String(getField(reg, [
                    'Sección', 'Seccion', 'seccion', 'SECCIÓN'
                ], '')).trim();

                const titulo = String(getField(reg, [
                    'Título', 'Titulo', 'titulo', 'TÍTULO'
                ], '')).trim();

                // Resolución puede ser null → se permite vacío
                const resolucionRaw = getField(reg, [
                    'Resolución', 'Resolucion', 'resolucion', 'RESOLUCIÓN'
                ], '');
                const resolucion = resolucionRaw ? String(resolucionRaw).trim() : '';

                // Es Subitem: columna con espacio "Es Subitem"
                const esSubRaw = getField(reg, [
                    'Es Subitem', 'Es_Subitem', 'es_subitem', 'EsSubitem', 'es subitem'
                ], 0);
                const esSub = parseInt(esSubRaw, 10) === 1;

                // Enlace: solo "Enlace" (no "Enlace PDF")
                const enlace = String(getField(reg, [
                    'Enlace', 'enlace', 'Enlace PDF', 'enlace_pdf', 'EnlacePDF', 'Link', 'URL'
                ], '')).trim();

                // Parent ID: columna con espacio "Parent ID"
                const parentIdRaw = getField(reg, [
                    'Parent ID', 'Parent_ID', 'parent_id', 'ParentID', 'parent id'
                ], '');
                const parentId = parentIdRaw ? parseInt(parentIdRaw, 10) : null;

                // Filtro de calidad
                if (!titulo) return;
                if (!enlace || !isValidUrl(enlace)) return;

                itemsById.set(id, {
                    id: id,
                    seccion: seccion || 'Documentos normativos',
                    titulo: titulo,
                    resolucion: resolucion,   // puede estar vacío → se muestra como "-"
                    esSub: esSub,
                    enlace: enlace,
                    parentId: parentId,
                    subitems: []              // se pobla en paso 2
                });
            });

            console.log(`✅ [DocNormativos] Items normalizados: ${itemsById.size}`);

            // ============================================================
            // PASO 2: Nesting explícito por Parent ID (dos pasadas)
            //
            //   Si esSub = true Y parentId es válido → se anida bajo el padre
            //   Si esSub = true pero parentId no existe → se trata como principal
            //   Si esSub = false → es documento principal
            // ============================================================
            const principalesPorSeccion = new Map(); // seccion → [items principales]

            itemsById.forEach((item) => {
                if (item.esSub && item.parentId && itemsById.has(item.parentId)) {
                    // Subitem con padre válido → anidar
                    const padre = itemsById.get(item.parentId);
                    padre.subitems.push({
                        titulo: item.titulo,
                        resolucion: item.resolucion,
                        enlace: item.enlace
                    });
                } else {
                    // Principal (o subitem huérfano → se trata como principal)
                    if (!principalesPorSeccion.has(item.seccion)) {
                        principalesPorSeccion.set(item.seccion, []);
                    }
                    principalesPorSeccion.get(item.seccion).push(item);
                }
            });

            // ============================================================
            // PASO 3: Construir array de secciones ordenadas
            // ============================================================
            const secciones = [];

            principalesPorSeccion.forEach((items, seccionNombre) => {
                // Ordenar items por ID dentro de la sección
                items.sort((a, b) => a.id - b.id);

                secciones.push({
                    nombre: seccionNombre,
                    documentos: items.map(item => ({
                        titulo: item.titulo,
                        resolucion: item.resolucion,
                        enlace: item.enlace,
                        subitems: item.subitems   // ya populados en paso 2
                    }))
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

            // Log de resumen
            console.log(`✅ [DocNormativos] Secciones construidas: ${secciones.length}`);
            secciones.forEach(s => {
                const totalSubs = s.documentos.reduce((acc, d) => acc + d.subitems.length, 0);
                console.log(`   • ${s.nombre}: ${s.documentos.length} principales, ${totalSubs} subitem(s)`);
            });

            return {
                success: true,
                secciones: secciones,
                total: itemsById.size
            };

        } catch (error) {
            console.error('❌ [DocNormativos] Error:', error);
            return {
                success: false,
                error: 'Error al procesar documentos normativos',
                message: error.message,
                secciones: [],
                total: 0
            };
        }
    }

    // Exportar
    window.getDocNormativosData = getDocNormativosData;

    console.log('✅ DocNormativosAPI cargada → window.getDocNormativosData()');
    console.log('📋 Columnas esperadas: ID | Sección | Título | Resolución | Es Subitem | Enlace | Parent ID');

})();
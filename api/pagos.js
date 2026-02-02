/**
 * =============================================================================
 * API CENTRALIZADA - PAGOS
 * =============================================================================
 * Ubicación: api/pagos.js
 * Conecta a Google Apps Script via config/database.js
 * Transforma array crudo → array normalizado con Categoria, Estado, Fecha, etc.
 *
 * Columnas en Google Sheets:
 *   ID | Categoría | Título | Resolución | Vigente | Enlace PDF | Fecha Publicación
 * =============================================================================
 */

(function() {
    'use strict';

    console.log('📥 Cargando PagosAPI...');

    // Extraer campo con múltiples posibles nombres de clave
    function getField(obj, keys, defaultVal = '') {
        for (const key of keys) {
            if (obj[key] !== undefined && obj[key] !== null && String(obj[key]).trim() !== '') {
                return obj[key];
            }
        }
        return defaultVal;
    }

    // Parsear fecha: acepta ISO string, objeto Date serializado, o formato libre
    function parsearFecha(valor) {
        if (!valor) return null;
        // Si ya es objeto Date (no va a pasar desde JSON, pero por si acaso)
        if (valor instanceof Date && !isNaN(valor)) return valor;
        // Intentar parsear string
        const fecha = new Date(valor);
        return isNaN(fecha.getTime()) ? null : fecha;
    }

    // Formatear fecha a dd/mm/yyyy en español
    function formatearFecha(fecha) {
        if (!fecha) return '';
        return fecha.toLocaleDateString('es-PE', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });
    }

    // Validar URL
    function isValidUrl(url) {
        try { new URL(url); return true; }
        catch (e) { return false; }
    }

    /**
     * Obtener todos los documentos de pagos normalizados
     */
    async function getPagosData() {
        try {
            console.log('📊 [Pagos] Iniciando petición...');

            if (typeof window.getDB !== 'function') {
                throw new Error('getDB no disponible. Cargar config/database.js ANTES de api/pagos.js');
            }

            const db = window.getDB('pagos');

            if (!db || !db.getUrl()) {
                throw new Error('Módulo "pagos" no configurado en database.js');
            }

            console.log('🔗 [Pagos] URL:', db.getUrl());

            const rawResponse = await db.get();

            console.log('📦 [Pagos] Respuesta cruda:', rawResponse);

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

            console.log(`📄 [Pagos] Registros recibidos: ${registros.length}`);

            if (registros.length === 0) {
                return { success: true, data: [], total: 0 };
            }

            // ============================================================
            // PROCESAR cada registro
            // ============================================================
            const datos = [];

            registros.forEach(reg => {
                const id = parseInt(getField(reg, ['ID', 'id'], 0), 10);

                const categoria = String(getField(reg, [
                    'Categoría', 'Categoria', 'categoria', 'CATEGORÍA'
                ], 'Sin categoría')).trim();

                const titulo = String(getField(reg, [
                    'Título', 'Titulo', 'titulo', 'TÍTULO'
                ], '')).trim();

                const resolucion = String(getField(reg, [
                    'Resolución', 'Resolucion', 'resolucion', 'RESOLUCIÓN'
                ], '')).trim();

                const enlacePdf = String(getField(reg, [
                    'Enlace PDF', 'Enlace_PDF', 'enlace_pdf', 'EnlacePDF', 'Enlace', 'enlace'
                ], '')).trim();

                const fechaRaw = getField(reg, [
                    'Fecha Publicación', 'Fecha_Publicacion', 'fecha_publicacion',
                    'FechaPublicacion', 'Fecha', 'fecha'
                ], '');

                // Vigente: puede venir como 0, 1, "0", "1", true, false
                const vigenteRaw = getField(reg, [
                    'Vigente', 'vigente', 'VIGENTE'
                ], 0);

                let esVigente = false;
                if (typeof vigenteRaw === 'number') {
                    esVigente = vigenteRaw >= 1;
                } else if (typeof vigenteRaw === 'string') {
                    esVigente = ['1', 'si', 'sí', 'yes', 'true', 'vigente'].includes(vigenteRaw.toLowerCase().trim());
                } else if (typeof vigenteRaw === 'boolean') {
                    esVigente = vigenteRaw;
                }

                // Filtrar: debe tener título y enlace válido
                if (!titulo || !enlacePdf || !isValidUrl(enlacePdf)) {
                    return; // skip
                }

                // Procesar fecha
                const fecha = parsearFecha(fechaRaw);
                const fechaFormateada = formatearFecha(fecha);
                const fechaISO = fecha ? fecha.toISOString().split('T')[0] : '1900-01-01';
                const anio = fecha ? fecha.getFullYear() : new Date().getFullYear();

                datos.push({
                    id: id,
                    Categoria: categoria,
                    Titulo: titulo,
                    Resolucion: resolucion,
                    Vigente: esVigente,
                    Estado: esVigente ? 'Vigente' : 'No vigente',
                    Año: anio,
                    Fecha: fechaISO,
                    FechaFormateada: fechaFormateada,
                    Enlace: enlacePdf
                });
            });

            // Ordenar: por categoría, luego por fecha DESC, luego por id DESC
            datos.sort((a, b) => {
                const cmpCat = a.Categoria.localeCompare(b.Categoria);
                if (cmpCat !== 0) return cmpCat;

                if (a.Fecha !== b.Fecha) return b.Fecha.localeCompare(a.Fecha); // DESC
                return b.id - a.id; // DESC
            });

            console.log(`✅ [Pagos] Datos procesados: ${datos.length}`);

            return {
                success: true,
                data: datos,
                total: datos.length
            };

        } catch (error) {
            console.error('❌ [Pagos] Error:', error);
            return {
                success: false,
                error: 'Error al procesar pagos',
                message: error.message
            };
        }
    }

    // Exportar a window
    window.getPagosData = getPagosData;

    console.log('✅ PagosAPI cargada → window.getPagosData()');

})();
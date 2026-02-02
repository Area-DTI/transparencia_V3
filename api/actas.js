/**
 * =============================================================================
 * API CENTRALIZADA - ACTAS (JavaScript)
 * =============================================================================
 * 
 * Este archivo REEMPLAZA api/actas.php
 * Ubicación: api/actas.js
 * Versión: 3.0 - JavaScript puro (compatible Netlify)
 * 
 * @author Universidad Andina del Cusco
 */

// =============================================================================
// VERIFICAR QUE config/database.js ESTÉ CARGADO
// =============================================================================

if (typeof getDB !== 'function') {
    console.error('❌ ERROR: config/database.js no está cargado');
    throw new Error('Falta cargar config/database.js antes que api/actas.js');
}

// =============================================================================
// API DE ACTAS
// =============================================================================

const ActasAPI = {
    
    /**
     * Obtener todas las actas desde Google Apps Script
     * Equivalente a la lógica del api/actas.php
     */
    async getAll(forzarActualizacion = false) {
        console.log('═══════════════════════════════════════════════════════');
        console.log('📥 API ACTAS: Cargando datos...');
        console.log('═══════════════════════════════════════════════════════');
        console.log('🔄 Forzar actualización:', forzarActualizacion);
        
        try {
            // Obtener instancia de Database para actas
            const db = getDB('actas');
            console.log('✅ Database instance created for: actas');
            console.log('📡 Apps Script URL:', db.getUrl());
            
            // Realizar petición al Apps Script
            console.log('📤 Calling Apps Script...');
            
            const params = {};
            if (forzarActualizacion) {
                params.refresh = 'true';
                params.t = Date.now();
            } else {
                params.t = Date.now();
            }
            
            const response = await db.get(params);
            console.log('✅ Apps Script response received:', response);
            
            // Verificar respuesta
            if (!response) {
                throw new Error('Respuesta vacía del Apps Script');
            }
            
            // Extraer actas del response
            let actas = [];
            
            if (Array.isArray(response)) {
                actas = response;
            } else if (response.data && Array.isArray(response.data)) {
                actas = response.data;
            } else if (response.success && response.data) {
                actas = response.data;
            } else {
                throw new Error('Formato de respuesta no reconocido');
            }
            
            console.log('📊 Actas encontradas:', actas.length);
            
            if (actas.length === 0) {
                return {
                    success: true,
                    data: [],
                    total: 0,
                    timestamp: new Date().toISOString(),
                    message: 'No hay actas disponibles',
                    source: 'API Centralizada - Google Apps Script'
                };
            }
            
            // Procesar y normalizar actas
            const actasProcesadas = this._procesarActas(actas);
            
            // Ordenar actas
            const actasOrdenadas = this._ordenarActas(actasProcesadas);
            
            // Respuesta final
            const finalResponse = {
                success: true,
                data: actasOrdenadas,
                total: actasOrdenadas.length,
                timestamp: new Date().toISOString(),
                message: 'Datos cargados correctamente desde Google Sheets',
                source: 'API Centralizada - Google Apps Script',
                apps_script_response: {
                    timestamp: response.timestamp || null,
                    count: response.count || actas.length
                }
            };
            
            console.log('✅ API ACTAS: Success');
            console.log('📊 Total procesadas:', finalResponse.total);
            console.log('═══════════════════════════════════════════════════════');
            
            return finalResponse;
            
        } catch (error) {
            console.error('═══════════════════════════════════════════════════════');
            console.error('❌ API ACTAS ERROR');
            console.error('═══════════════════════════════════════════════════════');
            console.error('Error:', error.message);
            console.error('Stack:', error.stack);
            console.error('═══════════════════════════════════════════════════════');
            
            throw {
                success: false,
                error: 'Error al procesar solicitud',
                message: error.message,
                debug_info: {
                    name: error.name,
                    stack: error.stack
                }
            };
        }
    },
    
    /**
     * Procesar y normalizar actas
     * Equivalente a la lógica de normalización del PHP
     * @private
     */
    _procesarActas(actas) {
        console.log('🔧 Procesando actas...');
        
        const actasProcesadas = [];
        
        for (const acta of actas) {
            try {
                // Normalizar nombres de campos (soportar minúsculas y mayúsculas)
                const actaNormalizada = {
                    id: acta.id || acta.ID || null,
                    Seccion: this._trim(acta.seccion || acta.Seccion || ''),
                    Categoria: this._trim(acta.categoria || acta.Categoria || ''),
                    Subcategoria: this._trim(acta.subcategoria || acta.Subcategoria || ''),
                    Dia: acta.dia || acta.Dia || '',
                    Mes: acta.mes || acta.Mes || '',
                    Año: acta.anio || acta.año || acta.Año || acta.Anio || '',
                    Fecha: acta.fecha || acta.Fecha || '',
                    Enlace: this._trim(acta.enlace || acta.Enlace || acta.enlace_pdf || '')
                };
                
                // Crear campos adicionales para compatibilidad con JavaScript
                actaNormalizada.anio = actaNormalizada.Año;
                actaNormalizada.seccion = actaNormalizada.Seccion;
                actaNormalizada.fecha = actaNormalizada.Fecha;
                actaNormalizada.enlace_pdf = actaNormalizada.Enlace;
                actaNormalizada.categoria = actaNormalizada.Categoria;
                actaNormalizada.subcategoria = actaNormalizada.Subcategoria;
                actaNormalizada.dia = actaNormalizada.Dia;
                actaNormalizada.mes = actaNormalizada.Mes;
                
                actasProcesadas.push(actaNormalizada);
                
            } catch (error) {
                console.warn('⚠️ Error procesando acta:', error, acta);
                // Continuar con la siguiente
            }
        }
        
        console.log('✅ Actas procesadas:', actasProcesadas.length);
        return actasProcesadas;
    },
    
    /**
     * Ordenar actas (más reciente primero)
     * @private
     */
    _ordenarActas(actas) {
        const MESES = {
            'Enero': 1, 'Febrero': 2, 'Marzo': 3, 'Abril': 4,
            'Mayo': 5, 'Junio': 6, 'Julio': 7, 'Agosto': 8,
            'Septiembre': 9, 'Octubre': 10, 'Noviembre': 11, 'Diciembre': 12
        };
        
        return actas.sort((a, b) => {
            // Ordenar por año descendente
            const anioA = parseInt(a.Año) || 0;
            const anioB = parseInt(b.Año) || 0;
            
            if (anioA !== anioB) {
                return anioB - anioA;
            }
            
            // Ordenar por mes
            const mesA = MESES[a.Mes] || 0;
            const mesB = MESES[b.Mes] || 0;
            
            if (mesA !== mesB) {
                return mesB - mesA;
            }
            
            // Ordenar por día
            const diaA = parseInt(a.Dia) || 0;
            const diaB = parseInt(b.Dia) || 0;
            
            return diaB - diaA;
        });
    },
    
    /**
     * Trim helper
     * @private
     */
    _trim(value) {
        return value ? value.toString().trim() : '';
    }
};

// =============================================================================
// EXPORTAR API
// =============================================================================

// Hacer disponible globalmente
window.ActasAPI = ActasAPI;

console.log('✅ ActasAPI loaded');
console.log('📦 Funciones disponibles: ActasAPI.getAll()');
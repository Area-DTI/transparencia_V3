/**
 * =============================================================================
 * API - GET CARDS (Tarjetas del portal principal)
 * =============================================================================
 *
 * Este archivo REEMPLAZA api/get_cards.php
 * Ubicación: api/get_cards.js
 * Versión: 3.1 - JavaScript puro (compatible Netlify)
 * Migrada a Google Apps Script (2026)
 *
 * @author Universidad Andina del Cusco
 */

// =============================================================================
// VERIFICAR QUE config/database.js ESTÉ CARGADO
// =============================================================================

if (typeof getDB !== 'function') {
    console.error('❌ ERROR: config/database.js no está cargado');
    throw new Error('Falta cargar config/database.js antes que api/get_cards.js');
}

// =============================================================================
// API DE CARDS
// =============================================================================

const CardsAPI = {

    /**
     * Obtener todas las cards desde Google Apps Script
     * Equivalente a la lógica del api/get_cards.php
     */
    async getAll() {
        console.log('═══════════════════════════════════════════════════════');
        console.log('📥 CARDS API: Cargando tarjetas...');
        console.log('═══════════════════════════════════════════════════════');

        try {
            // Obtener instancia de Database para cards
            const db = getDB('cards');
            console.log('✅ Database instance created for: cards');
            console.log('📡 Apps Script URL:', db.getUrl());

            // Realizar petición al Apps Script
            console.log('📤 Calling Apps Script...');
            const rawResponse = await db.get();

            console.log('✅ Apps Script response received:', rawResponse);

            // Validar respuesta
            if (!rawResponse) {
                throw new Error('Respuesta vacía del Apps Script');
            }

            // Extraer cards del response
            let cardsCrudas = [];

            if (Array.isArray(rawResponse)) {
                cardsCrudas = rawResponse;
            } else if (rawResponse.data && Array.isArray(rawResponse.data)) {
                cardsCrudas = rawResponse.data;
            } else if (rawResponse.success && rawResponse.data) {
                cardsCrudas = rawResponse.data;
            } else {
                throw new Error('Formato de respuesta no reconocido');
            }

            console.log('📊 Cards encontradas:', cardsCrudas.length);

            if (cardsCrudas.length === 0) {
                console.warn('⚠️ No hay cards disponibles');
                return [];
            }

            // Normalizar campos (compatible con frontend antiguo)
            const cards = this._normalizarCards(cardsCrudas);

            // Filtrar solo las cards activas y ordenarlas
            const cardsActivas = cards
                .filter(card => card.is_active === true || card.is_active === "VERDADERO")
                .sort((a, b) => a.display_order - b.display_order);

            console.log('✅ Cards procesadas y activas:', cardsActivas.length);
            console.log('═══════════════════════════════════════════════════════');

            // Devolver directamente el array (como esperaba el frontend original)
            return cardsActivas;

        } catch (error) {
            console.error('═══════════════════════════════════════════════════════');
            console.error('❌ CARDS API ERROR');
            console.error('═══════════════════════════════════════════════════════');
            console.error('Error:', error.message);
            console.error('Stack:', error.stack);
            console.error('═══════════════════════════════════════════════════════');

            throw {
                error: true,
                message: error.message
            };
        }
    },

    /**
     * Normalizar cards (compatible con frontend antiguo)
     * Equivalente a la normalización del PHP
     * @private
     */
    _normalizarCards(cardsCrudas) {
        console.log('🔧 Normalizando cards...');

        const cardsNormalizadas = [];

        for (const card of cardsCrudas) {
            try {
                const cardNormalizada = {
                    id: this._trim(card.id || card.Id || card.ID || ''),
                    icon: this._trim(card.icon || card.Icon || card.Icono || 'fas fa-info-circle'),
                    title: this._trim(card.title || card.Title || card.Título || 'Sin título'),
                    description: this._trim(card.description || card.Description || card.Descripción || ''),
                    link_url: this._trim(card.link_url || card.Link_URL || card.URL || card.Enlace || '#'),
                    link_text: this._trim(card.link_text || card.Link_Text || card.Texto_Enlace || 'Ver más'),
                    display_order: parseInt(this._trim(card.display_order || card.Display_Order || card.Orden || '0'), 10),
                    is_active: this._parseBoolean(this._trim(card.is_active || card.Is_Active || card.Activo || 'VERDADERO'))
                };

                cardsNormalizadas.push(cardNormalizada);

            } catch (error) {
                console.warn('⚠️ Error normalizando card:', error, card);
                // Continuar con la siguiente
            }
        }

        console.log('✅ Cards normalizadas:', cardsNormalizadas.length);
        return cardsNormalizadas;
    },

    /**
     * Parse boolean from string (for "VERDADERO"/"FALSO" or true/false)
     * @private
     */
    _parseBoolean(value) {
        if (typeof value === 'boolean') return value;
        if (value === 'VERDADERO' || value === 'TRUE' || value === '1') return true;
        if (value === 'FALSO' || value === 'FALSE' || value === '0') return false;
        return true; // Default: true
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
window.CardsAPI = CardsAPI;

console.log('✅ CardsAPI loaded');
console.log('📦 Funciones disponibles: CardsAPI.getAll()');

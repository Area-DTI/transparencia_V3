/**
 * =============================================================================
 * CONFIGURACIÓN DE BASE DE DATOS - VERSIÓN CORREGIDA CORS
 * =============================================================================
 * 
 * PROBLEMA RESUELTO: Headers en GET causaban preflight CORS
 * SOLUCIÓN: Solo enviar headers en POST/PUT/DELETE
 */

// =============================================================================
// URLS DE GOOGLE APPS SCRIPT POR MÓDULO
// =============================================================================

const APPS_SCRIPT_URLS = {
    'cards': 'https://script.google.com/macros/s/AKfycbwdCk81UTfX4RmugRSAtseKHEe2CAvvX_MpbWEenruddZ9baMQagnEKhtTvGh4ikMRJ/exec',
    'doc_normativos': 'https://script.google.com/macros/s/AKfycbyMOeOgrsbmGklXet5q536p7Vu_X2D6h0BAL2ITD5hsowDBZ-TfPcrApaOv8reH8CO0Dw/exec',
    'actas': 'https://script.google.com/macros/s/AKfycbzo4NZ4sQpHcnO8bj1ojJdf7ic9rEiUZOwHLHhuVSEw8QPpc2x1TI0X5KR0YEf3i67O5g/exec',
    'contabilidad': 'https://script.google.com/macros/s/AKfycbxHn6wxNkLi5e1kVWwbgYdDSyodijJuMMORUmeFw825x6O0avWFoIfxIx_mf1c2RlFzgw/exec',
    'becas': 'https://script.google.com/macros/s/AKfycbyVSqra__0xdJyaKSj7R0TfpTC0xbjT0XCK9VHZ6qIMYjr9BKvzm-SOCl-E-veu71WS/exec',
    'inversiones': 'https://script.google.com/macros/s/AKfycbx2gbfPMm2YUuUQ08VlWCwu8R3E0eFK_HyL3JlcHFhnxSLM9ExkboIRVQuMMObfp7DE/exec',
    'investigacion': 'https://script.google.com/macros/s/AKfycbxPX4Pvhz04fpsqw_CwwNpDor8XuRPZ4ls-iSaCI-qzTyqKuYhj8Aeh7js9yIWME37O/exec',
    'alumnos': 'https://script.google.com/macros/s/AKfycbwGMxHi8bkfODH2DaCMMyEzK6ZrRE5wben4l-qI1PRFnEYWSd9uyM3xAV3cROJYr9A/exec',
    'docentes': 'https://script.google.com/macros/s/AKfycbyv5GBc9m1LAaQv-SI5zeE18Y2Lt6w4YdNK0lhcTmA2ZC6Vyu7u2ynD4sSA6WA8O31m/exec',
    'remuneraciones': 'https://script.google.com/macros/s/AKfycbyTmaf9b9ahz_U4EFwgaSxeRTc3PZlddlt0ovLP0_ZxBFDTZe7sooXhA6sWWxmKOO2f/exec',
    'pagos': 'https://script.google.com/macros/s/AKfycbxL8dV7Fn_pu8YUnpr7pxX2x2WT6cC3aD5WBTlmzUY12QjnZirOW3zDrBZT50lFky9D/exec',
    'reglamentos': 'https://script.google.com/macros/s/AKfycbxGkwRVeKpDXBrBJetcF-47quAqtyfHdtojc0e0Vbt5nc80c_fcqAIJS9FJkD3ez7hj/exec',
    'resoluciones': 'https://script.google.com/macros/s/AKfycbzQxHQoUvJ-ii64WValb2-R08Jsr1WZ1T4SeePGpK-tze5wcGTrdyhIOqfE4IuwR8w8/exec',
    'directivas': 'https://script.google.com/macros/s/AKfycbwBWcHxBTX_VVo2W0VdLO3sY-HDUW_1kqaa3KxpCeV4Mf-shPpGCXJ_gWzt1nYp1PyC/exec',
    'proyecto_desarrollo': 'https://script.google.com/macros/s/AKfycbyFsfoQGasQiXYQUgkGfHB9dBPqMdHcC01zVlt9V0zSOZ6OIQXEXKJ8AlzWcq7GBwQHMQ/exec',
    'plan_estudios': 'https://script.google.com/macros/s/AKfycbw3yfYHRmpAqw4zozWFUNMKcFZPAgpQkVCrT5373mGknRFJbqFNMcMOv8dfVS1qEZX3rQ/exec'
};

// =============================================================================
// CONFIGURACIÓN
// =============================================================================

const REQUEST_TIMEOUT = 30000;
const MAX_RETRIES = 3;
const RETRY_DELAY = 500;

// =============================================================================
// CLASE DATABASE - CORS CORREGIDO
// =============================================================================

class Database {
    constructor(module = null) {
        this.module = module;
        this.url = module && APPS_SCRIPT_URLS[module] ? APPS_SCRIPT_URLS[module] : null;
        
        if (module && !this.url) {
            console.error(`❌ Módulo '${module}' no configurado en APPS_SCRIPT_URLS`);
        }
    }
    
    static getInstance(module = null) {
        return new Database(module);
    }
    
    setModule(module) {
        if (APPS_SCRIPT_URLS[module]) {
            this.module = module;
            this.url = APPS_SCRIPT_URLS[module];
        } else {
            throw new Error(`Módulo '${module}' no configurado`);
        }
        return this;
    }
    
    getUrl() {
        return this.url;
    }
    
    async request(method = 'GET', data = {}) {
        if (!this.url) {
            throw new Error('No se ha establecido un módulo');
        }
        
        let lastError = null;
        
        for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                const result = await this._makeRequest(method, data);
                return result;
            } catch (error) {
                lastError = error;
                console.warn(`⚠️ Intento ${attempt}/${MAX_RETRIES} falló:`, error.message);
                
                if (attempt < MAX_RETRIES) {
                    await this._delay(RETRY_DELAY * attempt);
                }
            }
        }
        
        throw new Error(`Error después de ${MAX_RETRIES} intentos: ${lastError.message}`);
    }
    
    async _makeRequest(method, data) {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), REQUEST_TIMEOUT);
        
        try {
            let url = this.url;
            let options = {
                method: method === 'GET' ? 'GET' : 'POST',
                signal: controller.signal
            };
            
            // ===================================================================
            // CORRECCIÓN CORS: Solo enviar headers en POST/PUT/DELETE
            // ===================================================================
            // GET no necesita headers y evita preflight CORS
            if (method !== 'GET') {
                options.headers = {
                    'Content-Type': 'application/json'
                };
            }
            
            // Para GET, añadir parámetros a la URL
            if (method === 'GET' && Object.keys(data).length > 0) {
                const params = new URLSearchParams(data);
                url += (url.includes('?') ? '&' : '?') + params.toString();
            }
            
            // Para POST/PUT/DELETE, enviar en el body
            if (method !== 'GET') {
                data.action = method.toLowerCase();
                options.body = JSON.stringify(data);
            }
            
            const response = await fetch(url, options);
            clearTimeout(timeoutId);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            
            const result = await response.json();
            return result;
            
        } catch (error) {
            clearTimeout(timeoutId);
            
            if (error.name === 'AbortError') {
                throw new Error('Timeout: La petición tardó demasiado');
            }
            
            throw error;
        }
    }
    
    _delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
    
    async get(params = {}) {
        return await this.request('GET', params);
    }
    
    async post(data) {
        return await this.request('POST', data);
    }
    
    async put(id, data) {
        data.id = id;
        return await this.request('PUT', data);
    }
    
    async delete(id) {
        return await this.request('DELETE', { id });
    }
    
    getConnection() {
        return this;
    }
}

// =============================================================================
// FUNCIONES HELPER GLOBALES
// =============================================================================

function getDB(module = null) {
    return Database.getInstance(module);
}

function getAppsScriptUrl(module) {
    return APPS_SCRIPT_URLS[module] || null;
}

function getAvailableModules() {
    return Object.keys(APPS_SCRIPT_URLS);
}

// =============================================================================
// EXPORTAR PARA USO EN NAVEGADOR
// =============================================================================

window.APPS_SCRIPT_URLS = APPS_SCRIPT_URLS;
window.Database = Database;
window.getDB = getDB;
window.getAppsScriptUrl = getAppsScriptUrl;
window.getAvailableModules = getAvailableModules;

console.log('✅ Database configuration loaded (CORS fixed)');
console.log('📦 Módulos disponibles:', getAvailableModules());
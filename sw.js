// =============================================================================
// SERVICE WORKER — TRANSPARENCIA UAC
// =============================================================================
// Estrategias de caché:
//
//   1. APP SHELL (HTML, CSS, JS del portal)
//        → Cache-first: se sirve desde caché inmediatamente.
//          En background se revalida; si cambió, se actualiza el caché silencioso.
//          El usuario ve los cambios en la SIGUIENTE visita.
//
//   2. API de Google Sheets (script.google.com)
//        → Stale-while-revalidate: se retorna caché inmediatamente (datos rápidos),
//          se hace fetch en background, se actualiza caché.
//          Si no hay caché aún (primera vez), espera la red.
//
//   3. CDN externos (jQuery, FontAwesome, DataTables)
//        → Cache-first: se cachean al primer uso y después se sirven local.
//
//   4. Cualquier otra cosa
//        → Network-first con fallback a caché.
//
// Para forzar actualización de caché tras un deploy:
//   → Incrementar CACHE_VERSION abajo.
// =============================================================================

const CACHE_VERSION = 'v1';
const CACHE_NAME    = `transparencia-${CACHE_VERSION}`;

// -----------------------------------------------------------------------------
// Assets críticos que se precachean en install (app shell)
// -----------------------------------------------------------------------------
const PRECACHE = [
    '/',
    '/index.html',
    '/header.html',
    '/footer.html',
    '/sw.js',
    // CSS global
    '/assets/css/base.css',
    '/assets/css/header.css',
    '/assets/css/footer.css',
    '/assets/css/responsive.css',
    // Capa de datos
    '/config/database.js',
    // APIs (JS)
    '/api/actas.js',
    '/api/alumnos.js',
    '/api/becas.js',
    '/api/contabilidad.js',
    '/api/directivas.js',
    '/api/docentes.js',
    '/api/doc_normativos.js',
    '/api/get_cards.js',
    '/api/inversiones.js',
    '/api/investigacion.js',
    '/api/pagos.js',
    '/api/plan_estudios.js',
    '/api/proyecto_desarrollo.js',
    '/api/reglamentos.js',
    '/api/remuneraciones.js',
    '/api/resoluciones.js',
    // Módulos — HTML + JS + CSS
    '/modules/index.html',
    '/modules/1_doc_normativos/index.html',
    '/modules/1_doc_normativos/scripts.js',
    '/modules/1_doc_normativos/styles.css',
    '/modules/2_actas/index.html',
    '/modules/2_actas/scripts.js',
    '/modules/2_actas/styles.css',
    '/modules/3_contabilidad/index.html',
    '/modules/3_contabilidad/scripts.js',
    '/modules/3_contabilidad/styles.css',
    '/modules/4_becas/index.html',
    '/modules/4_becas/scripts.js',
    '/modules/4_becas/styles.css',
    '/modules/5_inversiones/index.html',
    '/modules/5_inversiones/scripts.js',
    '/modules/5_inversiones/styles.css',
    '/modules/6_investigacion/index.html',
    '/modules/6_investigacion/scripts.js',
    '/modules/6_investigacion/styles.css',
    '/modules/7_alumnos/index.html',
    '/modules/7_alumnos/scripts.js',
    '/modules/8_docentes/index.html',
    '/modules/8_docentes/scripts.js',
    '/modules/8_docentes/styles.css',
    '/modules/9_pagos/index.html',
    '/modules/9_pagos/scripts.js',
    '/modules/9_pagos/styles.css',
    '/modules/9_remuneraciones/index.html',
    '/modules/9_remuneraciones/scripts.js',
    '/modules/9_remuneraciones/styles.css',
    '/modules/10_reglamentos/index.html',
    '/modules/10_reglamentos/scripts.js',
    '/modules/10_reglamentos/styles.css',
    '/modules/11_otros_documentos/index.html',
    '/modules/11_otros_documentos/11_resoluciones/index.html',
    '/modules/11_otros_documentos/11_resoluciones/scripts.js',
    '/modules/11_otros_documentos/11_resoluciones/styles.css',
    '/modules/11_otros_documentos/12_directivas/index.html',
    '/modules/11_otros_documentos/12_directivas/scripts.js',
    '/modules/11_otros_documentos/12_directivas/styles.css',
    '/modules/13_decalogos---/index.html',
    '/modules/13_decalogos---/scripts.js',
    '/modules/13_decalogos---/styles.css',
    '/modules/14_proyecto_general_desarrollo/index.html',
    '/modules/14_proyecto_general_desarrollo/scripts.js',
    '/modules/14_proyecto_general_desarrollo/styles.css',
    '/modules/15_plan_estudio/index.html',
    '/modules/15_plan_estudio/scripts.js',
    '/modules/15_plan_estudio/styles.css'
];

// -----------------------------------------------------------------------------
// INSTALL — precachear app shell
// -----------------------------------------------------------------------------
self.addEventListener('install', event => {
    console.log('[SW] install — cachéando app shell...');

    event.waitUntil(
        caches.open(CACHE_NAME).then(cache => {
            // addAll falla silenciosamente si un archivo no existe; usamos add individual
            const promises = PRECACHE.map(url =>
                cache.add(url).catch(() => {
                    console.warn('[SW] no se precacheó:', url);
                })
            );
            return Promise.all(promises);
        }).then(() => {
            console.log('[SW] install completado — app shell cacheado');
            // Activa inmediatamente sin esperar cierre de tabs
            return self.skipWaiting();
        })
    );
});

// -----------------------------------------------------------------------------
// ACTIVATE — eliminar cachés de versiones anteriores
// -----------------------------------------------------------------------------
self.addEventListener('activate', event => {
    console.log('[SW] activate — limpiando cachés viejos...');

    event.waitUntil(
        caches.keys().then(keys =>
            Promise.all(
                keys
                    .filter(key => key !== CACHE_NAME)
                    .map(key => {
                        console.log('[SW] eliminando caché antiguo:', key);
                        return caches.delete(key);
                    })
            )
        ).then(() => {
            console.log('[SW] activate completado');
            return clients.claim(); // toma control de tabs abiertos
        })
    );
});

// =============================================================================
// FETCH — interceptar peticiones
// =============================================================================
self.addEventListener('fetch', event => {
    const request = event.request;
    const url     = new URL(request.url);

    // Ignorar peticiones no-GET (POST, PUT, etc.)
    if (request.method !== 'GET') return;

    // ---- 1) API de Google Apps Script → stale-while-revalidate ----
    if (isGoogleAppsScriptAPI(url)) {
        event.respondWith(staleWhileRevalidate(request));
        return;
    }

    // ---- 2) Assets del mismo origen (portal) → cache-first ----
    if (url.origin === self.location.origin) {
        event.respondWith(cacheFirst(request));
        return;
    }

    // ---- 3) CDN externos conocidos → cache-first ----
    if (isCDN(url)) {
        event.respondWith(cacheFirst(request));
        return;
    }

    // ---- 4) Todo lo demás → network-first ----
    event.respondWith(networkFirst(request));
});

// =============================================================================
// ESTRATEGIAS
// =============================================================================

// -----------------------------------------------------------------------------
// Cache-first con revalidación en background
//   Retorna caché si existe (instantáneo).
//   Hace fetch en background; si la respuesta cambió, actualiza caché.
//   Si no hay caché, espera la red.
// -----------------------------------------------------------------------------
async function cacheFirst(request) {
    const cache    = await caches.open(CACHE_NAME);
    const cached   = await cache.match(request);

    // Lanzar fetch en background para revalidar (sin bloquear)
    const fetchPromise = fetch(request).then(response => {
        if (response && response.ok) {
            cache.put(request, response.clone());
        }
        return response;
    }).catch(() => null); // si la red falla, no importa — tenemos caché

    // Si hay caché, retornarlo inmediatamente
    if (cached) {
        // El fetch sigue corriendo en background (actualiza caché para la próxima vez)
        fetchPromise; // no-await intencional
        return cached;
    }

    // Sin caché → esperar la red
    const networkResponse = await fetchPromise;
    if (networkResponse) return networkResponse;

    // Sin red ni caché → respuesta de error
    return new Response('Sin conexión y sin datos en caché', { status: 503 });
}

// -----------------------------------------------------------------------------
// Stale-while-revalidate (para API de Sheets)
//   Si hay caché → retorna inmediatamente + actualiza en background.
//   Si no hay caché → espera la red (primera carga inevitable).
// -----------------------------------------------------------------------------
async function staleWhileRevalidate(request) {
    const cache  = await caches.open(CACHE_NAME);
    const cached = await cache.match(request);

    const fetchPromise = fetch(request).then(response => {
        if (response && response.ok) {
            cache.put(request, response.clone());
            console.log('[SW] API actualizada en caché:', request.url);
        }
        return response;
    }).catch(() => null);

    if (cached) {
        console.log('[SW] API servida desde caché (background revalidate)');
        return cached;
    }

    // Primera vez: esperar red
    console.log('[SW] API sin caché — esperando red...');
    const networkResponse = await fetchPromise;
    if (networkResponse) return networkResponse;

    return new Response(
        JSON.stringify({ success: false, error: 'Sin conexión' }),
        { status: 503, headers: { 'Content-Type': 'application/json' } }
    );
}

// -----------------------------------------------------------------------------
// Network-first con fallback a caché
// -----------------------------------------------------------------------------
async function networkFirst(request) {
    try {
        const response = await fetch(request);
        if (response && response.ok) {
            const cache = await caches.open(CACHE_NAME);
            cache.put(request, response.clone());
        }
        return response;
    } catch {
        const cache  = await caches.open(CACHE_NAME);
        const cached = await cache.match(request);
        if (cached) return cached;
        return new Response('Sin conexión', { status: 503 });
    }
}

// =============================================================================
// HELPERS — identificar tipos de petición
// =============================================================================

function isGoogleAppsScriptAPI(url) {
    // Las llamadas a Google Apps Script van a script.google.com
    return url.hostname === 'script.google.com'
        || url.hostname === 'script.gstatic.com';
}

function isCDN(url) {
    const cdnHosts = [
        'code.jquery.com',
        'cdnjs.cloudflare.com',
        'cdn.datatables.net',
        'fonts.googleapis.com',
        'fonts.gstatic.com',
        'www.uandina.edu.pe'   // favicon
    ];
    return cdnHosts.some(host => url.hostname === host);
}
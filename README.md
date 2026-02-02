# Portal de Transparencia - Universidad Andina del Cusco

![Universidad Andina del Cusco](https://via.placeholder.com/800x200?text=Portal+de+Transparencia) <!-- Placeholder para una imagen representativa; reemplazar con una real si está disponible -->

## Sistema Desarrollado por Wilbert Junior Cardenas Alejo

## Descripción General

Este repositorio contiene el **Portal de Transparencia** de la Universidad Andina del Cusco (UAC), un sistema web diseñado para promover la transparencia institucional mediante la publicación y gestión de información pública relevante. El proyecto sigue una arquitectura de **tres capas** (presentación, lógica de negocio y datos), lo que asegura una separación clara de responsabilidades, facilitando el mantenimiento, la escalabilidad y la seguridad.

### Arquitectura de Tres Capas
- **Capa de Presentación**: Interfaz de usuario frontend, compuesta por HTML, CSS y JavaScript. Incluye el portal principal (`index.html`), módulos individuales y componentes reutilizables como encabezados y pies de página. Esta capa se encarga de la visualización de datos y la interacción con el usuario.
- **Capa de Lógica de Negocio**: Maneja las operaciones CRUD (Create, Read, Update, Delete) a través de APIs centralizadas en JavaScript. Todas las solicitudes de datos se realizan vía APIs JS, que actúan como intermediarios para procesar lógica empresarial, validar entradas y orquestar flujos de datos.
- **Capa de Datos**: Centralizada en `config/database.js`, donde se gestionan todas las conexiones a fuentes de datos. El sistema no utiliza bases de datos tradicionales directamente en el código; en su lugar, integra **Google Sheets** mediante **Google Apps Script** para recopilar, almacenar y recuperar datos de manera dinámica y colaborativa.

El enfoque en Google Sheets con Apps Script permite una recolección de datos en tiempo real, colaborativa y de bajo costo, ideal para entornos institucionales donde múltiples usuarios contribuyen con información. Las APIs JS "jalan" (pull) datos de estas hojas de cálculo, procesándolos para su presentación en el portal.

### Características Principales
- **Conexión Centralizada**: Todas las conexiones a datos se manejan exclusivamente en `config/database.js`, promoviendo la consistencia y reduciendo la duplicación de código.
- **APIs JS Centralizadas**: Ubicadas en la carpeta `api/`, estas APIs gestionan operaciones para cada módulo, utilizando JavaScript para interactuar con Google Sheets vía Apps Script.
- **Integración con Google Sheets y Apps Script**: Todo el proyecto depende de Google Sheets para la recolección de datos. Apps Script actúa como backend serverless, exponiendo endpoints que las APIs JS consumen para operaciones CRUD.
- **Panel de Administración**: Acceso seguro con OAuth 2.0 (configurado en `config/app.php`, pero adaptado para integración JS).
- **Módulos Modulares**: Cada módulo (ej. reglamentos, actas, etc.) es independiente pero comparte la conexión central y APIs.
- **Responsive Design**: Estilos en `assets/css/` aseguran compatibilidad con dispositivos móviles.
- **Service Worker**: Incluye `sw.js` para funcionalidades offline y PWA (Progressive Web App).

Este sistema es ideal para instituciones educativas que buscan cumplir con normativas de transparencia, como las establecidas por la Superintendencia Nacional de Educación Superior Universitaria (SUNEDU) en Perú.

## Requisitos Previos
- Node.js (para ejecutar scripts JS si es necesario en desarrollo).
- Cuenta de Google con acceso a Google Sheets y Apps Script.
- Navegador web moderno (Chrome, Firefox, etc.).
- Servidor web local (ej. XAMPP, WAMP o Node.js server) para pruebas.

## Instalación
Siga estos pasos para configurar el proyecto localmente:

1. **Clonar el Repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/portal-transparencia-uac.git
   cd portal-transparencia-uac
   ```

2. **Configurar Google Sheets y Apps Script**:
   - Crea una nueva hoja de cálculo en Google Sheets para cada módulo (ej. "Reglamentos", "Actas").
   - En Apps Script (accesible desde la hoja de cálculo: Extensiones > Apps Script):
     - Implementa scripts para exponer datos como web apps (doGet/doPost para CRUD).
     - Publica el script como "Web app" con acceso "Cualquiera, incluso anónimos" (para pruebas; restringir en producción).
     - Copia la URL de la web app y configúrala en `config/database.js` como endpoint base.
   Ejemplo en `config/database.js`:
   ```javascript
   const SHEET_API_URL = 'https://script.google.com/macros/s/tu-id-apps-script/exec';
   export default SHEET_API_URL;
   ```

3. **Configurar Conexión Centralizada**:
   - Edita `config/database.js` para incluir credenciales o URLs de Apps Script.
   - Asegúrate de que todas las APIs JS importen esta configuración:
     ```javascript
     import DB_URL from '../config/database.js';
     // Uso en API: fetch(DB_URL + '?action=read');
     ```

4. **Instalar Dependencias (si aplica)**:
   - Si usas Node.js para desarrollo: `npm install` (agrega un `package.json` si no existe).
   - No se requieren dependencias externas pesadas; el proyecto es vanilla JS/HTML/CSS.

5. **Ejecutar Localmente**:
   - Usa un servidor local: `npx http-server` o abre `index.html` directamente (pero APIs requieren CORS habilitado en Apps Script).
   - Verifica: Abre `http://localhost:8080/index.html` y navega por los módulos.

6. **Despliegue en Producción**:
   - Sube a un hosting (ej. GitHub Pages, Vercel o servidor dedicado).
   - Configura OAuth 2.0 para el panel de admin si se integra autenticación Google.
   - Asegura HTTPS para APIs.

## Estructura de Carpetas
La estructura del proyecto está organizada para reflejar la arquitectura de tres capas, con énfasis en modularidad:

```
.
├── api/                  # Capa de Lógica: APIs JS centralizadas para operaciones CRUD
│   ├── actas.js          # API para módulo de actas
│   ├── alumnos.js        # API para alumnos
│   ├── BaseAPI.php       # (Ignorado: legado PHP)
│   ├── becas.js          # API para becas
│   ├── contabilidad.js   # API para contabilidad
│   ├── directivas.js     # API para directivas
│   ├── docentes.js       # API para docentes
│   ├── doc_normativos.js # API para documentos normativos
│   ├── get_cards.js      # API para tarjetas/dashboards
│   ├── inversiones.js    # API para inversiones
│   ├── investigacion.js  # API para investigación
│   ├── pagos.js          # API para pagos
│   ├── plan_estudios.js  # API para planes de estudio
│   ├── proyecto_desarrollo.js # API para proyectos de desarrollo
│   ├── reglamentos.js    # API para reglamentos
│   ├── remuneraciones.js # API para remuneraciones
│   ├── resoluciones.js   # API para resoluciones
│   ├── test.html         # Pruebas HTML
│   └── test.php          # (Ignorado: legado PHP)
├── assets/               # Recursos estáticos para presentación
│   └── css/              # Estilos CSS
│       ├── base.css      # Estilos base
│       ├── footer.css    # Estilos para footer
│       ├── header.css    # Estilos para header
│       └── responsive.css # Estilos responsivos
├── conexion.php          # (Ignorado: legado PHP)
├── config/               # Configuraciones centrales (Capa de Datos)
│   ├── app.php           # Configuración de app (OAuth, etc.; adaptado para JS)
│   └── database.js       # Conexión centralizada a Google Sheets/Apps Script
├── docs/                 # Documentación adicional
│   └── README.md         # Este archivo
├── footer.html           # Componente reutilizable: pie de página
├── header.html           # Componente reutilizable: encabezado
├── includes/             # Archivos comunes y helpers
│   ├── db_adapter.php    # (Ignorado: legado PHP)
│   └── helpers.php       # (Ignorado: legado PHP)
├── index.html            # Portal principal (Capa de Presentación)
├── install_database.sql  # (Ignorado: script SQL legado; usar Google Sheets)
├── modules/              # Módulos individuales (Capa de Presentación + Lógica por módulo)
│   ├── 10_reglamentos/   # Módulo de reglamentos
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal del módulo
│   │   ├── scripts.js    # Scripts JS para pull de APIs
│   │   └── styles.css    # Estilos específicos
│   ├── 11_otros_documentos/ # Módulo de otros documentos
│   │   ├── 11_resoluciones/ # Submódulo resoluciones
│   │   │   ├── api.php   # (Ignorado: legado PHP)
│   │   │   ├── conexion.php # (Ignorado: legado PHP)
│   │   │   ├── datos.sql # (Ignorado: datos legado)
│   │   │   ├── index.html # Página principal
│   │   │   ├── scripts.js # Scripts JS
│   │   │   └── styles.css # Estilos
│   │   ├── 12_directivas/ # Submódulo directivas
│   │   │   ├── api.php   # (Ignorado: legado PHP)
│   │   │   ├── conexion.php # (Ignorado: legado PHP)
│   │   │   ├── datos.sql # (Ignorado: datos legado)
│   │   │   ├── index.html # Página principal
│   │   │   ├── scripts.js # Scripts JS
│   │   │   └── styles.css # Estilos
│   │   └── index.html    # Índice del módulo
│   ├── 13_decalogos---/  # Módulo de decálogos (nota: nombre con guiones)
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 14_proyecto_general_desarrollo/ # Módulo de proyectos de desarrollo
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   ├── styles.css    # Estilos
│   │   └── test.html     # Pruebas HTML
│   ├── 15_plan_estudio/  # Módulo de planes de estudio
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 1_doc_normativos/ # Módulo de documentos normativos
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 2_actas/          # Módulo de actas
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   ├── styles.css    # Estilos
│   │   └── test.html     # Pruebas HTML
│   ├── 3_contabilidad/   # Módulo de contabilidad
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 4_becas/          # Módulo de becas
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 5_inversiones/    # Módulo de inversiones
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 6_investigacion/  # Módulo de investigación
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 7_alumnos/        # Módulo de alumnos
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 8_docentes/       # Módulo de docentes
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 9_pagos/          # Módulo de pagos
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   ├── 9_remuneraciones/ # Módulo de remuneraciones
│   │   ├── datos.sql     # (Ignorado: datos legado)
│   │   ├── index.html    # Página principal
│   │   ├── scripts.js    # Scripts JS
│   │   └── styles.css    # Estilos
│   └── index.html        # Índice de módulos
├── README.md             # Este archivo de documentación
├── REORGANIZAR-COMPLETO.sh # Script de reorganización (utilidad interna)
├── sw.js                 # Service Worker para PWA
└── test.html             # Archivo de pruebas general
```

## Uso
- **Navegación**: Accede al portal principal en `index.html`. Cada módulo se encuentra en `modules/[nombre]/index.html`.
- **Pull de Datos**: En scripts.js de cada módulo, usa fetch para llamar APIs:
  ```javascript
  fetch('../api/reglamentos.js')
    .then(response => response.json())
    .then(data => console.log(data)); // Datos de Google Sheets
  ```
- **Administración**: Usa el panel admin (integrado vía OAuth) para actualizar Sheets.
- **Actualización de Datos**: Edita Google Sheets; Apps Script sincroniza automáticamente.


## Contacto
- Desarrollado por: Equipo DTI - Universidad Andina del Cusco.
- Rol de practicante pre
- Email: WJ918xd@hotmail.com
- Año: 2026

Universidad Andina del Cusco - Promoviendo la Transparencia Institucional.
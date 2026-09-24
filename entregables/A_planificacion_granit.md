# A. Planificación — Integrante 2 (Granit)

**Proyecto 1 · CS5383 · Caso 3 OpenCart**
Alcance: FUN-05 checkout, FUN-06 confirmación, FUN-07 catálogo y stock administrativo, FUN-08 pedidos, RNF-01, RNF-02 y RNF-03.

## 1. Elementos de prueba

| Elemento | Ubicación | Requisitos |
|---|---|---|
| Checkout invitado y registrado | Sitio público, `route=checkout/checkout` | RF CHK 01–05 |
| Confirmación y resumen del pedido | Etapa final del checkout y página de éxito | RF CON 01–04 |
| Catalog > Products | Panel administrativo | RF ADM 01–07 |
| Sales > Orders | Panel administrativo | RF PED 01–05 |
| Sincronización sitio–panel | Interfaz entre ambos | RNF 01, RF ADM 07, RF PED 01 |
| Compatibilidad del flujo crítico | Sitio público | RNF 02 |
| Tiempo de respuesta de página de categoría | Sitio público | RNF 03 |

Lo no listado queda fuera del bloque.

## 2. Ambiente de prueba

**Escenario A — demo público compartido (`demo.opencart.com`).** Ambiente multiusuario, sin aislamiento de sesión ni control del dato: terceros modifican catálogo y pedidos de forma concurrente y el sitio se restablece periódicamente, lo que invalida precondiciones entre ejecuciones. El usuario `demo` opera con permisos administrativos restringidos, por lo que guardar en Catalog > Products puede ser rechazado.

Restricción verificada el 24-09-2026: el host responde HTTP 403 con bloqueo de Cloudflare ("Sorry, you have been blocked"), tanto en el storefront como en el panel administrativo, cuya ruta real es `https://demo.opencart.com/TlbeVW/` con credenciales publicadas por opencart.com (`demo` / `demo`). Ray IDs observados: `a3ffd6a6fe936f20` y `a3ffdaf1d8966f2f`. El sitio `opencart.com` sí carga, de modo que el bloqueo es del host del demo y no de la red del equipo. Mientras persista, el bloque queda Bloqueado por impedimento externo: la **tasa de bloqueo** se calcula sobre los casos **planificados**, no sobre los ejecutados, y la **tasa de aprobación** sobre los casos **ejecutados**.

Validez de la evidencia en A: una captura prueba el estado del sistema solo en ese instante y no es reproducible. Toda evidencia se fecha en el nombre del archivo y cita el identificador del pedido o producto observado.

**Escenario B — instancia controlada desplegada localmente (contingencia).** Base de datos y datos semilla bajo control del equipo. Habilita permisos administrativos plenos, creación de pedidos reales y configuración explícita de `Stock Checkout`, precondición de CP-CON-01, CP-CON-02, CP-PED-01, CP-RNF-01 y CP-ADM-01.

Validez de la evidencia en B: es reproducible, y las Pruebas de Confirmación y de Regresión pueden repetirse sobre el mismo estado inicial. A cambio, los hallazgos se atribuyen a esa instancia y no al demo oficial. Cada caso declara su escenario de ejecución.

- Versión de OpenCart (demo e instancia local): [PENDIENTE: versión exacta al momento de ejecución]
- Escenario definitivo: [PENDIENTE: confirmación tras reintento del demo en la ventana de ejecución]

## 3. Navegadores seleccionados

Se adopta el conjunto propuesto por el caso, sin ampliarlo: **Chrome**, **Edge** y **Firefox** de escritorio. Chrome y Edge comparten motor Chromium, por lo que Firefox aporta la única variación real de renderizado; Edge se conserva por ser el navegador preinstalado del parque corporativo típico.

RNF-02 se verifica con CP-RNF-02, ejecutando el flujo crítico completo —catálogo, ficha, carrito y checkout— en cada navegador con un único juego de datos, de modo que las diferencias sean atribuibles al navegador, y registrando veredicto y errores bloqueantes por navegador. Versiones: [PENDIENTE: versión exacta al momento de ejecución].

## 4. Herramientas

| Propósito | Herramienta |
|---|---|
| Ejecución manual | Chrome, Edge y Firefox, ventana privada por sesión |
| Captura de evidencia | Utilidad de captura del sistema operativo, nombre trazable (§10) |
| Registro del Testware | Hoja de cálculo: casos, ejecución, defectos, trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto |
| Medición RNF-03 | DevTools > Network, caché deshabilitada, varias mediciones; cronómetro como control cruzado |
| Medición RNF-01 | Marca de tiempo de confirmación frente a aparición en Sales > Orders |
| Gestión de pruebas | Opción principal: **Qase (`app.qase.io`)**, la herramienta de gestión de pruebas usada en clase. Alternativas conservadas: Jira/Zephyr, TestLink o tablas en el informe. [PENDIENTE: decisión de Granit] |

## 5. Datos de prueba

| Dato | Uso | Volatilidad |
|---|---|---|
| Producto físico disponible y elegible | CP-CHK-01, CP-CON-01, CP-RNF-02 | Volátil en A |
| Producto con cantidad cero y estado *Out Of Stock* | CP-ADM-01 | Volátil; exige escritura en el panel |
| Datos de invitado (nombre, correo, teléfono, dirección, código postal) | CP-CHK-01 | Estable, definidos por el equipo |
| Credenciales administrativas | CP-ADM-01, CP-PED-01, CP-RNF-01 | Publicadas; permisos restringidos en A |
| Pedido de referencia generado por el equipo | CP-CON-01, CP-CON-02, CP-PED-01 | Volátil; se recrea en cada ejecución |
| Página de categoría con volumen representativo | CP-RNF-03 | Volátil en A |

Los datos volátiles se re-verifican antes de cada ejecución. Si la precondición no se cumple, el caso se marca Bloqueado con su causa, no Fallido.

## 6. Recursos y responsabilidades

| Rol | Persona | Responsabilidad |
|---|---|---|
| Analista de QA — bloque transaccional y administrativo | Granit | Checkout, confirmación de pedidos, administración de catálogo y pedidos, requisitos no funcionales, consolidación, Gestión de la Configuración del Testware y Lecciones Aprendidas |
| Analista de QA — bloque de navegación y carrito | Franco | Catálogo, ficha de producto, carrito y cupones |

## 7. Estimación de esfuerzo

Criterio declarado: **juicio experto por analogía** con bloques de pruebas funcionales manuales de tamaño comparable. Horas de esfuerzo neto, sin holgura por reintentos del demo.

| Actividad | Horas |
|---|---|
| Planificación y riesgos del bloque | 3 |
| Análisis de condiciones y trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto (con la condición de prueba CT como paso intermedio) | 4 |
| Diseño de los 8 casos | 6 |
| Preparación de ambiente y datos, incluida la contingencia local | 4 |
| Ejecución de casos de prioridad Alta | 6 |
| Pruebas de Confirmación y de Regresión | 3 |
| Registro de defectos y evidencia | 3 |
| Consolidación, estado frente a los criterios de salida y Lecciones Aprendidas | 4 |
| **Total** | **33** |

## 8. Cronograma

Ancla: [PENDIENTE: fecha de entrega]. Duraciones relativas; no se declaran fechas absolutas.

| Hito | Duración | Posición |
|---|---|---|
| H1 · Planificación y riesgos aprobados | 1 día | Entrega − 9 |
| H2 · Análisis y trazabilidad cerrados | 1 día | Entrega − 8 |
| H3 · Casos diseñados y revisados con Franco | 2 días | Entrega − 7 a − 6 |
| H4 · Ambiente y datos confirmados (línea base) | 1 día | Entrega − 5 |
| H5 · Ejecución de casos Alta | 2 días | Entrega − 4 a − 3 |
| H6 · Pruebas de Confirmación y de Regresión | 1 día | Entrega − 2 |
| H7 · Consolidación, estado frente a los criterios de salida y cierre | 1 día | Entrega − 1 |

## 9. Entregables de mi bloque

- Esta sección de planificación.
- Registro de riesgos de proceso y de producto del bloque.
- Análisis de FUN-05 a FUN-08 y RNF-01 a RNF-03, con matriz de trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto, conservando la condición de prueba (CT) como paso intermedio del análisis.
- Ocho casos diseñados: CP-CHK-01, CP-CON-01, CP-CON-02, CP-ADM-01, CP-PED-01, CP-RNF-01, CP-RNF-02, CP-RNF-03.
- Registro de ejecución con veredicto por caso y causa explícita de cada Bloqueado.
- Evidencia gráfica nombrada según convención.
- Reporte de defectos con título `[Módulo/Funcionalidad] + [qué falla] + [bajo qué condición]`.
- Consolidado global, **estado frente a los Criterios de Salida CS1–CS4** (`00_gestion/CRITERIOS_SALIDA.md`) y Lecciones Aprendidas. La conclusión se redacta como estado frente a los criterios —«no se cumplen los criterios de salida CSx y CSy → el release no está listo»—, nunca como una etiqueta de dictamen.

## 10. Gestión de la Configuración del Testware

- **Control de versiones del documento:** identificador `vMAJOR.MINOR` con autor, fecha y motivo del cambio en el encabezado de control. No se edita sobre una versión ya publicada.
- **Convención de nombres de evidencia:** `CP-XXX-NN_pasoNN_descripcion_AAAAMMDD.png`. La fecha es obligatoria porque el ambiente es compartido y el dato observado no es reproducible.
- **Repositorio:** carpeta `entregables/` del proyecto, con subcarpetas `evidencia/` por caso y `defectos/`. Repositorio remoto: [PENDIENTE: decisión de Granit].
- **Línea base:** se establece al cierre de H3 sobre casos diseñados y datos acordados; desde ese punto ningún caso se modifica sin control de cambios.
- **Control de cambios:** toda modificación posterior a la línea base se registra con caso afectado, motivo, responsable y fecha, e incrementa la versión. Un cambio sobre un caso ya ejecutado obliga a Pruebas de Confirmación de ese caso y a evaluar Pruebas de Regresión sobre los que comparten precondiciones.

## 11. Supuestos y restricciones del demo

- Supuesto: la funcionalidad del demo es representativa de una instalación estándar de OpenCart.
- Supuesto: las credenciales `demo` / `demo` siguen siendo las publicadas por el proveedor.
- Supuesto: de persistir el bloqueo, la ejecución se traslada al Escenario B y los resultados se atribuyen explícitamente a esa instancia.
- Restricción: al 24-09-2026 `demo.opencart.com` devuelve HTTP 403 por bloqueo de Cloudflare en storefront y panel; el bloqueo es del host del demo, no de la red del equipo.
- Restricción: el usuario `demo` tiene permisos administrativos restringidos y puede no guardar cambios en Catalog > Products.
- Restricción: los datos del demo son compartidos y volátiles y pueden ser alterados por terceros durante la ejecución.
- Restricción: no hay control sobre servidor, caché ni red, lo que condiciona la medición de RNF-03.
- Restricción: sin acceso a logs ni a base de datos en el Escenario A, los defectos se documentan solo por comportamiento observable de caja negra.
- Restricción: el caso no define el umbral numérico de RNF-01. [PENDIENTE: umbral acordado con la docente]

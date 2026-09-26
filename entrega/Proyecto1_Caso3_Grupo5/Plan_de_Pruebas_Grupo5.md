# Plan de Pruebas — Grupo 5

**Proyecto:** OpenCart Demo 4.0.2.3 (Caso 3) · **Plan:** PP-G5-C3-v1.0 · **v1.0** · 25/09/2026 · Franco y Granit

## 1. Identificación del documento

| Campo | Valor |
| --- | --- |
| Identificador | PP-G5-C3-v1.0 |
| Versión / fecha | 1.0 · 25/09/2026 |
| Autores | Franco, Granit |
| Aprobación | Docente CS5383; no hay aprobación de cliente |
| Gestión de la Configuración | Cada elemento del testware tiene ID único, versión y registro de cambios; evidencias con SHA-256 en `manifest_integrado.json` |

## 2. Contexto

Ronda de pruebas manuales del flujo comercial de OpenCart Demo 4.0.2.3 y su reflejo en el panel. Marco de referencia: temario ISTQB.

Referencias: enunciado Caso 3; `Proyecto1_Caso3_Grupo5.pdf`; `EJECUCION_INTEGRADA_20260925.md`.

## 3. Ítems de prueba y alcance

| Ítem | En alcance | Fuera de alcance |
| --- | --- | --- |
| E-RF01 Catálogo | Orden por nombre y precio, filtros | CRUD de categorías |
| E-RF02 Opciones de producto | Opción requerida, ajuste de precio | Combinatoria total |
| E-RF03 Carrito y recálculo | Cantidades válidas e inválidas, totales | — |
| E-RF04 Cupones | Vigencia, elegibilidad, no acumulación | Alta de cupones |
| E-RF05 Checkout invitado | Campos, método de pago | Registro/login |
| E-RF06 Confirmación | ID de orden, idempotencia | Pagos reales |
| E-RF07 Pedidos en panel | Orden propia visible | Devoluciones |
| E-RF08 Stock administrativo | Guardado de agotado y propagación | — |
| RNF-01 Propagación público→panel | Latencia < 60 s | — |
| RNF-02 Compatibilidad | Chrome, Edge, Firefox | Móviles |
| RNF-03 Respuesta de catálogo | Carga < 2000 ms | Carga y estrés |

Build: 4.0.2.3, inglés, USD. Excluidos además: modificar código, seguridad, carga y pruebas de componente.

### 3.1 Priorización de requisitos por riesgo (guía 2.2)

| Requisito | Riesgo | Justificación (solo Alta) |
| --- | --- | --- |
| E-RF03 Carrito/recálculo | Alta | Error aritmético cobra importes incorrectos |
| E-RF04 Cupones | Alta | Descuento indebido reduce ingreso sin autorización |
| E-RF05 Checkout invitado | Alta | Si no completa, no hay venta |
| E-RF06 Confirmación | Alta | Sin ID no hay seguimiento; duplicados cobran dos veces |
| E-RF08 Stock | Alta | Sobreventa: queja central del caso |
| E-RF02 Opciones | Alta | La variante define qué se entrega |
| E-RF07 Pedidos | Alta | Orden invisible impide su atención operativa |
| E-RF01 Catálogo | Media | — |
| RNF-01 Propagación | Alta | La demora causa reintentos |
| RNF-03 Respuesta catálogo | Media | — |
| RNF-02 Compatibilidad | Baja | — |

## 4. Supuestos y restricciones

| Supuesto | Restricción |
| --- | --- |
| Demo accesible con datos ficticios | Demo compartido: los datos cambian |
| Cupones y opciones disponibles | Los 3 cupones leídos estaban vencidos o deshabilitados |
| Permisos de escritura en el panel | El panel denegó el guardado |
| Instrumentación exportable | No disponible; RNF-03 no medible |
| 24 h estimadas | Dos ejecutores, sin código fuente |

## 5. Riesgos

| Riesgo | Tipo | Probabilidad | Impacto | Tratamiento |
| --- | --- | --- | --- | --- |
| R01 Inventario divergente ficha/carrito/panel | Producto | Alta | Crítico | CP-CAR-02, CP-ADM-01 |
| R02 Cupón válido rechazado o descuento incorrecto | Producto | Alta | Crítico | CP-CUP-01/02; verificar vigencia antes |
| R03 Importes o impuestos inconsistentes | Producto | Alta | Crítico | CP-CAR-01, CP-PRO-02, CP-CON-01 |
| R04 Opción obligatoria ausente o distinta | Producto | Media | Crítico | CP-PRO-01/02 |
| R05 Venta sobre el stock real | Producto | Alta | Crítico | CP-CAR-02 (S, S+1) |
| R06 Acumulación indebida de descuentos | Producto | Media | Crítico | CP-CUP-02 |
| R07 Checkout invitado no completado | Producto | Alta | Crítico | CP-CHK-01, CP-CON-01 |
| R08 Pedido perdido o duplicado | Producto | Media | Crítico | CP-CON-02, CP-PED-01, CP-RNF-01 |
| R09 Catálogo lento u orden de precio incorrecto | Producto | Media | Operacional | CP-CAT-02, CP-RNF-03 |
| R10 Incompatibilidad de navegador | Producto | Media | Operacional | CP-RNF-02 |
| R11 Orden por nombre o filtros confusos | Producto | Media | Operacional | CP-CAT-01/03 |
| R12 Certificado aceptado indebidamente | Producto | Baja | Crítico | CP-VAL-01 |
| P01 Permisos limitados en el panel | Proceso | Alta | Operacional | Registrar Bloqueado, no Falló |
| P02 Datos del demo cambian | Proceso | Alta | Operacional | Revalidar precondiciones por corrida |
| P03 Sin instrumentación | Proceso | Alta | Operacional | Declarar RNF-03 no medible |
| P04 Fecha de entrega fija | Proceso | Media | Operacional | Reserva de 2 h |

## 6. Estrategia de pruebas

### 6.1 Estrategias elegidas y descartadas

| Estrategia del curso | Uso | Razón |
| --- | --- | --- |
| Analítica basada en riesgos | **Principal** | El daño se concentra en dinero, inventario y descuentos; el riesgo fija la profundidad |
| Basada en requisitos | Complementaria | Asegura diseño y trazabilidad de los 11 requisitos |
| Exploración acotada (reactiva) | Solo reconocimiento | Identificar datos, cupones y bloqueos; no genera veredictos |
| Basada en modelos | No usada | No hay modelo formal ni especificación interna |
| Consultiva / dirigida por interesados | No usada | No hay interesado del negocio en un demo público |
| Preventiva de regresión | Diseñada, no ejecutada | Sin corrección aplicada no hay base para prueba de confirmación ni pruebas de regresión |
| Conforme a estándar / proceso | **No se reclama** | El marco es el temario ISTQB; afirmar cumplimiento de ISO/IEC/IEEE 29119 exigiría auditoría |

### 6.2 Niveles y profundidad

| Nivel | Profundidad real |
| --- | --- |
| Componente | No ejecutado: sin código |
| Integración | Observada por interfaz: carrito↔checkout, sitio↔panel. Sin cobertura de APIs |
| Sistema | **Nivel principal**: comportamiento externo del sistema desplegado |
| Aceptación | Limitada a los criterios del caso; sin firma del cliente |

### 6.3 Riesgo por ítem y profundidad asignada

| Ítem | Riesgo | Profundidad |
| --- | --- | --- |
| E-RF03, E-RF04, E-RF05, E-RF06 | Alta | Positivos, negativos, fronteras y variantes; ejecución obligatoria |
| E-RF02, E-RF07, E-RF08, RNF-01 | Alta | Un positivo y un negativo; ejecución obligatoria |
| E-RF01, RNF-03 | Media | Un caso ejecutado; complementarios solo diseñados |
| RNF-02 | Baja | Diseñado, no ejecutado |

Tipos: funcionales positivos y negativos; rendimiento y compatibilidad planificados; revisión estática del testware.

### 6.4 Técnicas de diseño

| Técnica | Casos | Por qué esa y no otra |
| --- | --- | --- |
| Partición de equivalencia | CP-CAR-02, CP-CUP-02 | Cantidad y código agrupan clases válidas e inválidas; enumerar valores sería redundante |
| Análisis de valores límite | CP-CAR-02 (S=147, S+1=148) | La sobreventa ocurre en el borde del stock, no dentro de la clase |
| Tabla de decisión | CP-CUP-01, CP-CUP-02 | El descuento combina vigencia, elegibilidad y mínimo: reglas, no rangos |
| Transición de estados | CP-CON-02, CP-ADM-01 | Idempotencia y propagación dependen del estado previo |
| Basada en casos de uso | CP-CHK-01, CP-CON-01, CP-PED-01 | El recorrido invitado solo falla como secuencia extremo a extremo |

### 6.5 Criterios de entrada y salida por nivel/fase

| Fase / nivel | Entrada | Salida |
| --- | --- | --- |
| Análisis y diseño | Base versionada; 11 requisitos | 26 condiciones trazadas; 18 casos completos |
| Integración | Carrito controlado; acceso al panel | Discrepancias registradas o declaradas bloqueadas |
| Sistema | Demo accesible; datos ficticios; evidencia con fecha y URL | 14 casos Alta con veredicto o bloqueo documentado |
| Aceptación | Resultados del nivel sistema | No se afirma calidad con fallos monetarios o de checkout y riesgos Altos sin verificar |
| Suspensión | — | Pérdida de sesión, cambio de fixture, permiso o precondición ausente: suspender el caso, continuar los independientes |
| Reanudación | Acceso normal, fixture revalidado, permisos concedidos | Nueva corrida registrada sin sobrescribir evidencia previa |

Estado frente a los criterios de salida: cumplidos los de análisis, diseño y registro; **no cumplidos** los de aceptación, por DEF-01 y la ausencia de método de pago. Para evitar **métricas engañosas**, la aprobación se calcula sobre concluyentes: 3 Pasó y 2 Falló de 5, con 9 bloqueados informados aparte.

## 7. Entregables de prueba

Plan de pruebas · registro de riesgos · 26 condiciones · 18 casos · registro de ejecución de los 14 Alta · hallazgos con evidencia · informe de finalización · manifiesto SHA-256.

## 8. Tareas de prueba

| Sub-proceso | Tareas |
| --- | --- |
| Planificación | Analizar el caso; valorar riesgos; priorizar requisitos; estimar 24 h; definir criterios |
| Diseño e implementación | Derivar 26 condiciones; escribir 18 casos con técnica declarada; preparar fixtures |
| Ejecución | Verificar precondiciones; ejecutar los 14 Alta; registrar veredicto y evidencia; reportar hallazgos |
| Cierre | Consolidar métricas con contexto; declarar riesgo residual; archivar el testware bajo Gestión de la Configuración |

## 9. Necesidades de entorno y datos de prueba

| Necesidad | Detalle |
| --- | --- |
| Software | OpenCart Demo 4.0.2.3, sitio público y panel |
| Hardware / red | PC Windows, navegador de escritorio, red sin instrumentación |
| Herramientas | Capturas PNG, registro JSON, manifiesto SHA-256 |
| Datos | Ficticios, generados por el equipo: invitado, direcciones, cantidades 0/-1/1.5/abc/vacío, S=147, S+1=148 |
| Datos del demo | Cupones vigentes y productos con opciones completas: no disponibles |

## 10. Responsabilidades y comunicación

| Responsable | Alcance |
| --- | --- |
| Franco | E-RF01 a E-RF04; apoyo RNF-03 |
| Granit | E-RF05 a E-RF08; RNF-01 y RNF-02 |
| Ambos | Revisión cruzada, Gestión de la Configuración, entrega |

Comunicación: coordinación diaria y repositorio compartido del testware. Escalamiento: todo bloqueo de permisos o datos se documenta en el registro y se eleva a la docente.

## 11. Cronograma e hitos

| Fecha | Hito | Resultado |
| --- | --- | --- |
| 18/09/2026 | Exploración acotada | Funcionalidades y datos identificados |
| 24/09/2026 | Planificación, análisis y diseño | 26 condiciones, 16 riesgos, 18 casos |
| 24–25/09/2026 | Ejecución | 14 casos Alta con evidencia |
| 25/09/2026 | Cierre | Métricas, hallazgos y estado frente a criterios de salida |
| Tras habilitar el ambiente | Reejecución | Casos bloqueados, prueba de confirmación de DEF-01 y pruebas de regresión |

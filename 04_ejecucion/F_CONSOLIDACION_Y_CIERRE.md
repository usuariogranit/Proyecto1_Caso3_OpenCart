# CONSOLIDACIÓN DE RESULTADOS Y CIERRE — Bloque Integrante 2 (Granit)
Proyecto 1 · CS5383 · Caso 3 OpenCart · Corte: 24-09-2026
Ambiente y limitaciones: `00_gestion/BITACORA_AMBIENTE.md` · Criterios: `00_gestion/CRITERIOS_SALIDA.md`

---
## 1. Criterios de salida declarados (antes de cualquier métrica)
| ID | Criterio | Umbral |
|---|---|---|
| CS1 | Casos de prueba de alta prioridad ejecutados | 100 % |
| CS2 | Tasa de aprobación sobre los casos ejecutados | ≥ 90 % |
| CS3 | Defectos críticos abiertos | 0 |
| CS4 | Defectos de severidad alta abiertos | máximo 2 |

Definición de los denominadores usada en este informe:
- **Tasa de ejecución** = casos ejecutados / casos **planificados**
- **Tasa de aprobación** = casos aprobados / casos **ejecutados**
- **Tasa de bloqueo** = casos bloqueados / casos **planificados**

Un caso bloqueado no entra en el denominador de aprobación: no llegó a ejecutarse. Medir el bloqueo contra lo
ejecutado ocultaría la porción del alcance que nunca pudo entrar a ejecución.

---
## 2. Tabla global de resultados
| Caso | Prioridad | Veredicto | Causa / defecto asociado |
|---|---|---|---|
| CP-CHK-01 Checkout como invitado | Alta | **Falló** | DEF-04 (impide completar), DEF-01 (importes inconsistentes) |
| CP-CON-01 Número y resumen del pedido | Alta | **Bloqueado** | Por defecto DEF-04 |
| CP-CON-02 Prevención de pedido duplicado | Alta | **Bloqueado** | Por defecto DEF-04 |
| CP-ADM-01 Stock cero reflejado públicamente | Alta | **Bloqueado** | Ambiente: sin permisos de escritura |
| CP-PED-01 Pedido visible en administración | Alta | **Bloqueado** | Por defecto DEF-04 |
| CP-RNF-01 Sincronización sitio–panel | Alta | **Bloqueado** | Ambiente: sin permisos de escritura |
| CP-RNF-02 Flujo crítico en navegadores | Media | **Ejecución parcial** | Verificado en Chrome; faltan Edge y Firefox |
| CP-RNF-03 Tiempo de respuesta del catálogo | Alta | **Pasó** | 4 mediciones bajo el umbral |

## 3. Métricas
| Métrica | Cálculo | Valor |
|---|---|---|
| Casos diseñados | — | 8 |
| Casos planificados para ejecución | Todos los de prioridad alta (7) más CP-RNF-02 | 8 |
| Casos ejecutados por completo | CP-CHK-01, CP-RNF-03 | 2 |
| Casos con ejecución parcial | CP-RNF-02 | 1 |
| Casos pasados | CP-RNF-03 | 1 |
| Casos fallidos | CP-CHK-01 | 1 |
| Casos bloqueados | CON-01, CON-02, ADM-01, PED-01, RNF-01 | 5 |
| **Tasa de ejecución** | 2 / 8 | **25.0 %** |
| **Tasa de aprobación** | 1 / 2 | **50.0 %** |
| **Tasa de bloqueo** | 5 / 8 | **62.5 %** |

Desglose de la causa del bloqueo: **3 casos bloqueados por defecto del producto** (DEF-04) y **2 por restricción del
ambiente** (permisos del usuario `demo`). La distinción importa: la primera causa es responsabilidad del equipo de
desarrollo; la segunda, de la disponibilidad del ambiente de prueba.

## 4. Defectos por severidad y prioridad
| Severidad \ Prioridad | Alta | Media | Baja | Total |
|---|---|---|---|---|
| Crítica | 1 (DEF-04) | — | — | **1** |
| Alta | 2 (DEF-01, DEF-02) | — | — | **2** |
| Media | — | 1 (DEF-03) | — | **1** |
| Baja | — | — | — | 0 |
| **Total** | **3** | **1** | **0** | **4** |

Todos en estado **Nuevo**. Escala de severidad propia del equipo, declarada en `05_defectos/HALLAZGOS.md`; el
temario CTFL no impone una escala única.

## 5. Cumplimiento de los criterios de salida
| Criterio | Umbral | Resultado | Estado | Evidencia |
|---|---|---|---|---|
| CS1 | 100 % de alta prioridad ejecutados | 2 de 7 ejecutados | **No se cumple** | Tabla global, sección 2 |
| CS2 | Aprobación ≥ 90 % de los ejecutados | 50.0 % | **No se cumple** | Métricas, sección 3 |
| CS3 | Cero defectos críticos abiertos | 1 abierto (DEF-04) | **No se cumple** | `05_defectos/HALLAZGOS.md` |
| CS4 | Máximo 2 defectos altos abiertos | 2 abiertos (DEF-01, DEF-02) | **Se cumple** | `05_defectos/HALLAZGOS.md` |

### Estado frente a los criterios de salida
Tres de los cuatro criterios de salida no se cumplen. El defecto DEF-04 inutiliza por completo el flujo de compra: el
sitio público no ofrece ningún método de pago aunque el panel administrativo tiene Cash On Delivery habilitado para
todas las zonas geográficas. Ningún cliente puede completar una transacción. **El release no está listo**, y la tasa de
ejecución del 25 % no es un dato menor: no se trata de que las pruebas hayan salido mayoritariamente bien, sino de que
la mayor parte del alcance nunca pudo entrar a ejecución.

Un informe que presentara "1 de 2 casos ejecutados aprobados" como resultado positivo sería una métrica engañosa.
El dato que gobierna la decisión es que el 62.5 % del alcance planificado quedó bloqueado y que existe un defecto
crítico abierto en el flujo transaccional.

## 6. Riesgos residuales
1. **Cobertura no alcanzada:** confirmación de pedidos, prevención de duplicados y consistencia sitio–panel quedan sin verificar. Son los riesgos de producto de mayor impacto del caso y hoy están sin evidencia.
2. **Señal no confirmada de duplicación:** las órdenes 3633, 3634 y 3635 (mismo cliente, mismo monto, mismo día) son compatibles con el riesgo que evalúa CP-CON-02, pero no se puede atribuir al sistema sin generar pedidos propios (OBS-03).
3. **Volatilidad del ambiente:** el inventario y los cupones cambian por acción de terceros; cualquier reejecución puede arrojar un estado distinto.
4. **Compatibilidad sin verificar:** RNF-02 solo se comprobó en Chrome.
5. **Margen estrecho de rendimiento:** RNF-03 cumple, pero la primera carga sin caché quedó a 68 ms del umbral de 2 s.

## 7. Reflexión sobre automatización para el Proyecto 2
Sustentada en lo observado durante esta ejecución, no en criterios generales.

**Sí automatizar:**
- **CP-RNF-03 (tiempo de respuesta del catálogo).** Es la candidata más clara: criterio numérico, ejecución idéntica en cada corrida y resultado sensible a cualquier degradación. Ya se midió con la Navigation Timing API, o sea que el mecanismo está probado. Además el margen observado fue de solo 68 ms, así que la repetición frecuente tiene valor real.
- **Verificación de consistencia entre inventario del panel y disponibilidad publicada.** El contraste que expuso DEF-02 (HTC Touch HD con cantidad 0 publicado como "In Stock") es una comparación de datos entre dos fuentes, sin interacción compleja: es exactamente lo que una automatización hace mejor y más rápido que una persona, sobre todo repetida en todo el catálogo.
- **Los pasos previos del checkout de invitado** (carga del formulario, validación de campos obligatorios, guardado de datos de invitado). Ese tramo se comportó de forma estable y determinista en las dos ejecuciones, con países distintos, y es el prerrequisito de toda prueba de compra: conviene tenerlo automatizado como base.

**No automatizar todavía:**
- **CP-CON-01, CP-CON-02 y CP-PED-01.** No se pueden completar ni una sola vez de forma manual: automatizar un flujo que aún no se logra ejecutar implica escribir código contra un comportamiento que nadie ha observado. Primero debe corregirse DEF-04 y validarse manualmente el flujo completo.
- **CP-ADM-01 y CP-RNF-01.** Dependen de permisos que el ambiente público no otorga. La automatización no resuelve una restricción de permisos; solo trasladaría el bloqueo a un script.
- **CP-RNF-02 (compatibilidad multinavegador).** Exige infraestructura de varios navegadores y versiones, con alto costo de mantenimiento frente a un flujo crítico que hoy ni siquiera se completa. Tiene sentido después de estabilizar el flujo, no antes.

**Criterio transversal:** la automatización rinde sobre flujos estables, repetitivos y de validación objetiva. Hoy el
flujo de compra de este sistema no es estable, y automatizarlo ahora produciría pruebas frágiles que fallarían por el
defecto conocido en lugar de detectar defectos nuevos.

## 8. Lecciones aprendidas
1. **El ambiente es parte del alcance de pruebas, no un supuesto.** Se perdió tiempo diseñando ejecución sobre un demo que primero fue inaccesible por bloqueo de red y luego resultó tener permisos de escritura restringidos. Verificar el ambiente debe ser la primera actividad, no una consecuencia.
2. **Distinguir bloqueo por ambiente de bloqueo por defecto cambia la conclusión.** La ausencia de métodos de pago se clasificó inicialmente como limitación del ambiente (OBS-01). Contrastarla contra el panel administrativo la convirtió en DEF-04, un defecto crítico. La hipótesis inicial y su refutación quedaron registradas: revisar una clasificación con evidencia nueva es parte del análisis, no un error que ocultar.
3. **Contrastar el sitio público contra el panel administrativo reveló causas raíz que la exploración del front no explicaba.** La cantidad real en inventario frente a la etiqueta de disponibilidad publicada es lo que convirtió una observación superficial en un defecto con causa identificada.
4. **En un ambiente compartido, la evidencia sin fecha y hora no es evidencia.** El inventario, los cupones y los pedidos cambian por acción de terceros.
5. **Un bloqueo bien documentado vale más que un caso aprobado sin trazabilidad.** El 62.5 % de bloqueo es un resultado legítimo del proceso, sustentado en mensajes literales del sistema y registrado en bitácora.

## 9. Testware entregado (Gestión de la Configuración)
| Artefacto | Ruta |
|---|---|
| Bitácora de ambiente | `00_gestion/BITACORA_AMBIENTE.md` |
| Estrategia de resiliencia | `00_gestion/ESTRATEGIA_RESILIENCIA.md` |
| Criterios de salida | `00_gestion/CRITERIOS_SALIDA.md` |
| Planificación | `entregables/A_planificacion_granit.md` |
| Riesgos | `entregables/B_riesgos_granit.md` |
| Análisis y condiciones | `entregables/C_analisis_condiciones_granit.md` |
| Diseño de casos | `03_diseno/D_casos_de_prueba_granit.md` |
| Ejecución | `04_ejecucion/EJECUCION_GRANIT_20260924.md` |
| Mediciones de rendimiento | `04_ejecucion/MEDICIONES_RNF03_20260924.md` |
| Consolidación y cierre | `04_ejecucion/F_CONSOLIDACION_Y_CIERRE.md` |
| Defectos y hallazgos | `05_defectos/HALLAZGOS.md` |
| Evidencias | `evidencias/CP-XXX-NN/` |


## Complemento de gestión v1.1

Alta prioridad ejecutada: 2/7 = 28.6 %. Pendientes de completar: 5 bloqueados + 1 parcial = 6 (5 Alta, 1 Media). No hay ritmo observado ni fecha final confirmada para calcular capacidad; se requieren ambos antes de comprometer un plazo.

Acciones: investigar DEF-04 y repetir CP-CHK-01 para desbloquear CON-01, CON-02 y PED-01; disponer de un ambiente con escritura para ADM-01 y RNF-01; completar RNF-02 en Edge y Firefox. Asignaciones y fechas pendientes. Riesgo residual documentado, sin aceptación de negocio registrada.

El corte de resultados anterior no se sustituye por una captura complementaria. Ver `00_gestion/REVISION_CLASE7_20260924.md` para evidencias y limitaciones nuevas.

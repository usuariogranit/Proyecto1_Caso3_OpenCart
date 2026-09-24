# CRITERIOS DE SALIDA — Caso 3 OpenCart · Bloque del Integrante 2 (Granit)

**CS5383 · Proyecto 1** · Alcance: FUN-05 a FUN-08 y RNF-01 a RNF-03 · Corte: 24-09-2026
Responsable: Granit (Integrante 2). Ambiente vigente: `00_gestion/BITACORA_AMBIENTE.md`.

---

## 0. Nota metodológica

Los criterios de salida **se declaran ANTES de presentar métricas o gráficos**. El tablero muestra; la decisión se toma
contra estos umbrales. Un porcentaje de aprobados alto no es, por sí solo, una autorización de release: hay que mirar
qué casos se ejecutaron, los criterios de salida, los defectos abiertos y lo bloqueado o no ejecutado.

La conclusión de cierre se redacta siempre como **estado frente a los criterios de salida** —«no se cumplen los
criterios de salida CSx y CSy → el release no está listo»—, nunca como una etiqueta de dictamen.

**Denominadores fijados (no se mezclan):**

| Métrica | Fórmula | Denominador |
|---|---|---|
| % ejecutado | ejecutados / planificados | **Planificados** |
| **Tasa de bloqueo** | bloqueados / planificados | **Planificados** |
| **Tasa de aprobación** | aprobados / ejecutados | **Ejecutados** |
| % de alta prioridad ejecutada | casos Alta ejecutados / casos Alta planificados | Casos Alta planificados |
| Pendientes | bloqueados + no ejecutados | — |

No se emplean fórmulas que el curso no presenta (en particular, **no se usa «densidad de defectos»**), ni se habla de
«métricas de vanidad»: el término del curso es **métricas engañosas** («sin contexto engañan», «lo que se mide, se
distorsiona», «aprobados no es calidad»).

---

## 1. Los cuatro criterios de salida (criterio del curso, Clase 7 — Gestión de pruebas)

| ID | Enunciado del curso |
|---|---|
| **CS1** | 100 % de casos de alta prioridad ejecutados |
| **CS2** | Aprobación ≥ 90 % **de los ejecutados** |
| **CS3** | 0 defectos críticos abiertos |
| **CS4** | Máximo 2 defectos de severidad alta abiertos |

Regla maestra del curso: *los criterios de salida del plan son las métricas con las que se decide*.

---

## 2. Adaptación al Caso 3 OpenCart — bloque del Integrante 2 (8 casos)

Casos planificados del bloque: **CP-CHK-01, CP-CON-01, CP-CON-02, CP-ADM-01, CP-PED-01, CP-RNF-01, CP-RNF-02, CP-RNF-03**
(total: **8 planificados**).

Prioridad de cada caso, **derivada de la prioridad de sus condiciones** en `entregables/C_analisis_condiciones_granit.md`:

| Caso | Condiciones que cubre | Prioridad derivada |
|---|---|---|
| CP-CHK-01 | CT-CHK-01, 02, 04, 05, 06 · CT-CON-06 | **Alta** |
| CP-CON-01 | CT-CON-01, 02, 03, 04 | **Alta** |
| CP-CON-02 | CT-CON-05 | **Alta** |
| CP-ADM-01 | CT-ADM-02, 03, 04, 05 | **Alta** |
| CP-PED-01 | CT-PED-01, 02 | **Alta** |
| CP-RNF-01 | CT-RNF-01, 02 · CT-ADM-10 | **Alta** |
| CP-RNF-02 | CT-RNF-03 | Media |
| CP-RNF-03 | CT-RNF-04, 05 | **Alta** |

→ **7 casos de alta prioridad** y **1 de prioridad media**.

**Qué significa cada criterio con nuestros 8 casos:**

- **CS1 — 100 % de casos de alta prioridad ejecutados.** Los **7 casos Alta** deben tener veredicto **Aprobado o
  Fallido**. Un caso **Bloqueado** o **Pendiente** **no cuenta como ejecutado**: un impedimento de ambiente se registra
  como Bloqueado, nunca como Fallido, y tampoco como ejecutado. CP-RNF-02 (Media) no entra en el cómputo de CS1, pero sí
  en el % ejecutado general y en los pendientes.
- **CS2 — aprobación ≥ 90 % de los ejecutados.** El denominador son los casos con veredicto Aprobado o Fallido, **no los
  8 planificados**. Con nuestro tamaño, sobre 7 ejecutados el umbral obliga a 7 aprobados (6/7 = 85.7 % ya no cumple);
  sobre 8 ejecutados, a 8 aprobados. Con **0 ejecutados el criterio no es calculable**, y no calculable no equivale a
  cumplido.
- **CS3 — 0 defectos críticos abiertos.** Ningún defecto de severidad **Crítica** puede quedar en un estado distinto de
  **Cerrado** (ni Nuevo, ni En análisis, ni Asignado, ni En corrección, ni Listo para reprueba, ni Reabierto). Escala
  declarada por el equipo: Crítica · Alta · Media · Baja; el CTFL no impone una escala, así que rige la nuestra, con el
  mismo significado en todo el bloque.
- **CS4 — máximo 2 defectos de severidad alta abiertos.** Como máximo **2** defectos de severidad **Alta** sin Cerrar
  al momento del corte. Hoy el bloque registra exactamente 2 (DEF-01 y DEF-02): el criterio está **en el límite**, y
  cualquier defecto Alto adicional lo incumple.

Los cuatro criterios se evalúan sobre el bloque del Integrante 2. El consolidado global del equipo los evalúa de nuevo
sobre el total de casos de ambos integrantes.

---

## 3. Tabla de evaluación

| Criterio | Umbral | Estado actual | Evidencia |
|---|---|---|---|
| **CS1** · Casos de alta prioridad ejecutados | 100 % (7 de 7) | **No se cumple al 24-09-2026: 0 de 7 casos Alta ejecutados (0 %)** — 4 Bloqueado (CP-CHK-01, CP-CON-01, CP-CON-02, CP-PED-01) y 3 Pendiente (CP-ADM-01, CP-RNF-01, CP-RNF-03). Cifra definitiva: [PENDIENTE: al cierre de la ejecución] | `04_ejecucion/EJECUCION_GRANIT_20260924.md` (tabla «Resultados por caso»); `00_gestion/BITACORA_AMBIENTE.md` (24-09-2026: sin métodos de pago ni de envío) |
| **CS2** · Tasa de aprobación sobre ejecutados | ≥ 90 % | **No calculable al 24-09-2026: 0 casos ejecutados (denominador cero)**; ningún caso alcanzó veredicto Aprobado ni Fallido. No calculable ≠ cumplido. [PENDIENTE: al cierre de la ejecución] | `04_ejecucion/EJECUCION_GRANIT_20260924.md` |
| **CS3** · Defectos críticos abiertos | 0 | **Se cumple al 24-09-2026: 0 defectos de severidad Crítica registrados.** Los 3 defectos abiertos son Alta, Alta y Media, todos en estado **Nuevo**. [PENDIENTE: al cierre de la ejecución — quedan 7 casos sin ejecutar] | `05_defectos/HALLAZGOS.md` (DEF-01, DEF-02, DEF-03) |
| **CS4** · Defectos de severidad alta abiertos | ≤ 2 | **Se cumple en el límite al 24-09-2026: 2 defectos Alta abiertos** (DEF-01 y DEF-02, estado Nuevo). Un tercer defecto Alto lo incumpliría. [PENDIENTE: al cierre de la ejecución] | `05_defectos/HALLAZGOS.md` (DEF-01, DEF-02) |

**Métricas de apoyo con dato duro al 24-09-2026** (se presentan *después* de los criterios, no antes):

| Métrica | Valor | Denominador aplicado |
|---|---|---|
| % ejecutado | 0 / 8 = **0 %** | Planificados |
| Tasa de bloqueo | 4 / 8 = **50 %** | Planificados |
| Tasa de aprobación | **no calculable** (0 ejecutados) | Ejecutados |
| % de alta prioridad ejecutada | 0 / 7 = **0 %** | Casos Alta planificados |
| Pendientes (bloqueados + no ejecutados) | 4 + 4 = **8** | — |

**Contexto obligatorio de estas cifras:** el 50 % bloqueado no está repartido al azar. Se concentra en la cadena
transaccional pago → confirmación → visibilidad operativa, que es justamente el área de mayor riesgo económico del
bloque; hoy su cobertura efectiva es cero. La causa está registrada con texto literal del sistema en la bitácora
(demo público sin métodos de pago ni de envío configurados).

**Estado frente a los criterios de salida al 24-09-2026:** *no se cumplen los criterios de salida CS1 y CS2 —este
último ni siquiera es calculable, con 0 casos ejecutados—, y CS4 se sostiene en el límite exacto de 2 defectos altos
abiertos; por tanto, con la evidencia disponible hoy, el release no está listo.* CS3 se cumple hoy, pero su valor es
provisional mientras queden 7 casos de alta prioridad sin ejecutar.

---

## 4. Ciclo de vida del defecto (criterio del curso)

**Cadena principal:**

`Nuevo → En análisis → Asignado → En corrección → Listo para reprueba → Cerrado`

**Ramas:**

- Desde **En análisis**: **Rechazado** · **Duplicado** · **Diferido**.
- Desde **Listo para reprueba**: **Reabierto → En corrección**.

**Precisiones del curso:**

- **Listo para reprueba → prueba de confirmación:** se repite el caso que falló. La **regresión** es distinta: evita que
  la corrección rompa otra cosa. (El término «re-testing» no se usa en este proyecto.)
- **Rechazado** aparece más de lo que parece: malentendido del requisito, problema de entorno o de datos, o
  comportamiento esperado.
- **Severidad** (grado de impacto; la propone el tester) y **prioridad** (urgencia de corregir; la define el Product
  Owner o el negocio) son **dos ejes independientes** y no se fusionan en un solo campo.

**Estado de los defectos del bloque al 24-09-2026:** DEF-01, DEF-02 y DEF-03 están en estado **Nuevo**
(`05_defectos/HALLAZGOS.md`). Ninguno ha pasado por triage ni por prueba de confirmación.

---

## 5. Herramienta de gestión de pruebas

Opción principal: **Qase (`app.qase.io`)**, la herramienta de gestión de pruebas usada en clase. Alternativas
conservadas en el plan: Jira/Zephyr, TestLink, o las tablas del propio informe (ver
`entregables/A_planificacion_granit.md`, §4). Cualquiera que se elija debe sostener la trazabilidad
**Requisito ↔ caso ↔ ejecución ↔ defecto**; la condición de prueba (CT) se conserva como paso intermedio del análisis.

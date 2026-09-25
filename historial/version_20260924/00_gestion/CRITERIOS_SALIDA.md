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
| **CS1** · Casos de alta prioridad ejecutados | 100 % (7 de 7) | **No se cumple: 2 de 7 casos de prioridad Alta ejecutados (28.6 %).** Ejecutados: CP-CHK-01 (Falló) y CP-RNF-03 (Pasó). Bloqueados: CP-CON-01, CP-CON-02 y CP-PED-01 por el defecto DEF-04; CP-ADM-01 y CP-RNF-01 por restricción de permisos del ambiente | Registro de ejecución y cierre del 24-09-2026 |
| **CS2** · Tasa de aprobación sobre ejecutados | ≥ 90 % | **No se cumple: 50.0 %** (1 aprobado de 2 ejecutados). Aprobado: CP-RNF-03. Fallido: CP-CHK-01 | `04_ejecucion/F_CONSOLIDACION_Y_CIERRE.md` |
| **CS3** · Defectos críticos abiertos | 0 | **No se cumple: 1 defecto de severidad Crítica abierto** — DEF-04, estado Nuevo. El sitio público no ofrece ningún método de pago pese a que el panel tiene Cash On Delivery habilitado en todas las zonas | `05_defectos/HALLAZGOS.md`, DEF-04 |
| **CS4** · Defectos de severidad alta abiertos | ≤ 2 | **Se cumple, en el límite: 2 defectos Alta abiertos** (DEF-01 y DEF-02, estado Nuevo). Un tercer defecto Alto incumpliría el criterio | `05_defectos/HALLAZGOS.md` |

**Métricas vigentes del cierre del 24-09-2026:**

| Métrica | Cálculo | Resultado |
|---|---|---|
| Ejecución | 2 / 8 planificados | 25.0 % |
| Aprobación | 1 / 2 ejecutados | 50.0 % |
| Bloqueo | 5 / 8 planificados | 62.5 % |
| Alta prioridad ejecutada | 2 / 7 | 28.6 % |
| Pendientes de completar | 5 bloqueados + 1 parcial | 6: 5 Alta y 1 Media |

El parcial permanece pendiente de completar y no cuenta como ejecutado en estas métricas. Tres bloqueos dependen de DEF-04 y dos de permisos administrativos. Las cifras anteriores 0/8 y 4/8 describían un corte previo, no el cierre.

**Estado frente a los criterios de salida al cierre del 24-09-2026:** *no se cumplen CS1, CS2 ni CS3.* Solo 2 de 7
casos de prioridad Alta pudieron ejecutarse (28.6 %), la tasa de aprobación sobre ejecutados es de 50.0 % frente al
umbral de 90 %, y existe un defecto de severidad **Crítica** abierto (DEF-04) que inutiliza por completo el flujo de
compra. CS4 se cumple, pero en el límite exacto de dos defectos altos abiertos. **El release no está listo.**

Nota de trazabilidad del propio análisis: una versión anterior de esta tabla registraba CS3 como cumplido, porque la
ausencia de métodos de pago se había clasificado inicialmente como limitación del ambiente. La verificación posterior
en el panel administrativo demostró que los métodos están habilitados, lo que convirtió esa observación en el defecto
crítico DEF-04 y cambió la evaluación de CS3.

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

**Estado de los defectos del bloque al 24-09-2026:** DEF-01, DEF-02, DEF-03 y DEF-04 están en estado **Nuevo**
(`05_defectos/HALLAZGOS.md`). Ninguno ha pasado por triage ni por prueba de confirmación.

---

## 5. Herramienta de gestión de pruebas

Opción principal: **Qase (`app.qase.io`)**, la herramienta de gestión de pruebas usada en clase. Alternativas
conservadas en el plan: Jira/Zephyr, TestLink, o las tablas del propio informe (ver
`entregables/A_planificacion_granit.md`, §4). Cualquiera que se elija debe sostener la trazabilidad
**Requisito ↔ caso ↔ ejecución ↔ defecto**; la condición de prueba (CT) se conserva como paso intermedio del análisis.

# C. Análisis de Pruebas — Condiciones de prueba y trazabilidad
**Integrante 2 (Granit) · CS5383 · Proyecto 1 · Caso 3 OpenCart**
Bloque: FUN 05 Checkout · FUN 06 Confirmación · FUN 07 Productos, categorías y stock · FUN 08 Gestión de pedidos · RNF 01–03.
Fecha de análisis: 24-09-2026.

---

## 1. Base de pruebas y criterio de derivación

La base de pruebas son los requisitos verificables del Avance 1 (RF CHK 01–05, RF CON 01–04, RF ADM 01–07, RF PED 01–05 y RNF 01–03), derivados del enunciado del Caso 3 y de la exploración inicial. Cada condición surge de descomponer el requisito en sus aspectos verificables independientes: flujo feliz, campos obligatorios, formatos inválidos, reglas de negocio y consistencia sitio–panel. Según ISTQB, una **condición de prueba** es un aspecto de la base de pruebas verificable por uno o más casos: describe **qué** comprobar, nunca **cómo** ni con qué datos. Ninguna fila contiene pasos, valores ni resultados de ejecución.

**Nota de ambiente (24-09-2026):** `demo.opencart.com` responde **HTTP 403** por bloqueo de Cloudflare (storefront y admin); en la exploración del 18-09-2026 el usuario `demo` no podía modificar configuración ni se logró generar una orden. Esto **no altera el análisis** —las condiciones derivan de la base de pruebas, no de la disponibilidad—, pero se registra en la columna **Ejecutabilidad prevista**: **Ejecutable** (observable desde el sitio público) · **Requiere permisos admin** (exige escritura en el panel) · **Requiere pedido completado** (exige una orden real confirmada).

---

## 2. Condiciones de prueba

### FUN 05 — Checkout como invitado o registrado

| ID | Condición de prueba | Requisito(s) | Riesgo | Prioridad | Ejecutabilidad prevista |
|---|---|---|---|---|---|
| CT-CHK-01 | Acceso al checkout como invitado sin exigir la creación de una cuenta | RF CHK 01 | Alto | Alta | Ejecutable |
| CT-CHK-02 | Finalización del checkout de invitado con producto físico elegible | RF CHK 01, RF CHK 04 | Alto | Alta | Requiere pedido completado |
| CT-CHK-03 | Uso de direcciones y métodos asociados a la cuenta en cliente registrado | RF CHK 02 | Medio | Media | Requiere pedido completado |
| CT-CHK-04 | Bloqueo del avance ante campos obligatorios vacíos | RF CHK 03 | Alto | Alta | Ejecutable |
| CT-CHK-05 | Rechazo de formatos inválidos en correo, teléfono y código postal, con indicación comprensible por campo | RF CHK 03 | Medio | Alta | Ejecutable |
| CT-CHK-06 | Exigencia de método de envío y de pago aplicables antes de habilitar la confirmación | RF CHK 04 | Alto | Alta | Ejecutable |
| CT-CHK-07 | Correspondencia del resumen del checkout con productos, cantidades, opciones y descuentos del carrito | RF CHK 05 | Alto | Alta | Ejecutable |

### FUN 06 — Confirmación y resumen del pedido

| ID | Condición de prueba | Requisito(s) | Riesgo | Prioridad | Ejecutabilidad prevista |
|---|---|---|---|---|---|
| CT-CON-01 | Generación de un identificador de orden único al confirmar una compra válida | RF CON 01 | Alto | Alta | Requiere pedido completado |
| CT-CON-02 | Presentación de la pantalla de confirmación como evidencia visible de la operación | RF CON 01, RF CON 04 | Alto | Alta | Requiere pedido completado |
| CT-CON-03 | Exactitud del resumen confirmado: productos, opciones, cantidades, impuestos, envío y descuento | RF CON 02 | Alto | Alta | Requiere pedido completado |
| CT-CON-04 | Igualdad entre el total mostrado antes de confirmar y el total del pedido creado | RF CON 02 | Alto | Alta | Requiere pedido completado |
| CT-CON-05 | Ausencia de órdenes duplicadas ante doble clic, recarga o retorno a la página final | RF CON 03 | Alto | Alta | Requiere pedido completado |
| CT-CON-06 | Cierre del pedido de invitado sin convertir el registro en condición para finalizar | RF CON 04 | Medio | Alta | Requiere pedido completado |

### FUN 07 — Productos, categorías y stock (panel)

| ID | Condición de prueba | Requisito(s) | Riesgo | Prioridad | Ejecutabilidad prevista |
|---|---|---|---|---|---|
| CT-ADM-01 | Persistencia de nombre, código, precio, estado, cantidad y categoría al reabrir el producto | RF ADM 01 | Alto | Alta | Requiere permisos admin |
| CT-ADM-02 | Guardado de cantidad cero junto con el estado Out Of Stock | RF ADM 02 | Alto | Alta | Requiere permisos admin |
| CT-ADM-03 | Reflejo público de la falta de disponibilidad del producto agotado | RF ADM 02, RF ADM 07 | Alto | Alta | Requiere permisos admin |
| CT-ADM-04 | Imposibilidad de confirmar una compra superior al stock con Stock Checkout deshabilitado | RF ADM 03 | Alto | Alta | Ejecutable |
| CT-ADM-05 | Emisión de advertencia al cliente al solicitar una cantidad no disponible | RF ADM 03 | Medio | Media | Ejecutable |
| CT-ADM-06 | Retorno del producto a disponible al reponer inventario y habilitarlo | RF ADM 04 | Alto | Alta | Requiere permisos admin |
| CT-ADM-07 | Aparición del producto únicamente en las categorías asociadas | RF ADM 05 | Medio | Media | Requiere permisos admin |
| CT-ADM-08 | Conservación en la ficha pública de las opciones, su obligatoriedad y sus ajustes de precio | RF ADM 06 | Alto | Alta | Requiere permisos admin |
| CT-ADM-09 | Existencia de al menos un valor seleccionable en toda opción marcada como requerida | RF ADM 06 | Medio | Media | Ejecutable |
| CT-ADM-10 | Propagación al sitio público de stock, precio, categoría u opción sin reiniciar el sistema | RF ADM 07, RNF 01 | Alto | Alta | Requiere permisos admin |

### FUN 08 — Gestión de pedidos (panel)

| ID | Condición de prueba | Requisito(s) | Riesgo | Prioridad | Ejecutabilidad prevista |
|---|---|---|---|---|---|
| CT-PED-01 | Aparición del pedido confirmado en la lista administrativa conservando el mismo identificador | RF PED 01 | Alto | Alta | Requiere pedido completado |
| CT-PED-02 | Coincidencia del detalle administrativo con el resumen público del pedido | RF PED 02 | Alto | Alta | Requiere pedido completado |
| CT-PED-03 | Recuperación del pedido por los filtros disponibles, excluyendo registros no coincidentes | RF PED 03 | Medio | Media | Requiere pedido completado |
| CT-PED-04 | Registro del nuevo estado y su fecha en el historial del pedido | RF PED 04 | Medio | Media | Requiere permisos admin |
| CT-PED-05 | Invariancia de productos, cantidades, descuentos y total ante consulta o cambio de estado | RF PED 05 | Alto | Alta | Requiere permisos admin |

### RNF 01–03

| ID | Condición de prueba | Requisito(s) | Riesgo | Prioridad | Ejecutabilidad prevista |
|---|---|---|---|---|---|
| CT-RNF-01 | Visibilidad en el panel de pedidos y cambios del sitio público sin reinicio de servicios | RNF 01 | Alto | Alta | Requiere pedido completado |
| CT-RNF-02 | Existencia de un umbral numérico de sincronización acordado antes del diseño | RNF 01 | Medio | Media | Ejecutable |
| CT-RNF-03 | Completitud de catálogo, ficha, carrito y checkout en Chrome, Edge y Firefox sin errores bloqueantes | RNF 02 | Medio | Media | Ejecutable |
| CT-RNF-04 | Tiempo de respuesta de la página de categoría por debajo de dos segundos en mediciones repetidas | RNF 03 | Alto | Alta | Ejecutable |
| CT-RNF-05 | Documentación del criterio de medición: caché, red y número de mediciones | RNF 03 | Medio | Media | Ejecutable |

**Total: 33 condiciones derivadas.**

---

## 3. Justificación de las condiciones de prioridad Alta (riesgo de negocio)

- **CT-CHK-01** — Forzar el registro pierde la venta en el punto de mayor intención de compra: abandono directo del carrito.
- **CT-CHK-02** — Un checkout de invitado que no cierra anula el canal de venta completo; es el flujo donde el negocio no puede permitirse fallar.
- **CT-CHK-04** — Datos obligatorios vacíos generan envíos fallidos y costo operativo de reproceso y devolución.
- **CT-CHK-05** — Correo o teléfono inválidos impiden notificar y coordinar la entrega: reclamos, reembolsos y desgaste reputacional.
- **CT-CHK-06** — Confirmar sin envío o pago válido produce órdenes impagas o no despachables que operaciones cancela a mano.
- **CT-CHK-07** — Diferencia entre carrito y checkout es cobro indebido o descuento perdido: pérdida directa y disputa con el medio de pago.
- **CT-CON-01** — Sin número de orden único no hay soporte, seguimiento ni conciliación contable de la venta.
- **CT-CON-02** — Sin confirmación visible el cliente repite la compra o reclama un cobro que no reconoce.
- **CT-CON-03** — El resumen es la evidencia del contrato de venta; toda discrepancia deriva en devolución y reclamo formal.
- **CT-CON-04** — Que el total cambie al confirmar es cobro no consentido: máxima exposición legal y de contracargos.
- **CT-CON-05** — El pedido duplicado cobra y despacha dos veces: pérdida de inventario, costo logístico y daño reputacional inmediato.
- **CT-CON-06** — Exigir registro después de pagar niega al invitado su evidencia de compra y dispara contacto con soporte.
- **CT-ADM-01** — Datos que no persisten obligan a reeditar el catálogo y publican precios o estados equivocados.
- **CT-ADM-02 / CT-ADM-03** — Vender lo inexistente causa incumplimiento de entrega, reembolso y pérdida de confianza: el riesgo operativo más caro del bloque.
- **CT-ADM-04** — Sin control de stock al confirmar se comprometen unidades inexistentes y se acumulan cancelaciones masivas.
- **CT-ADM-06** — Si la reposición no se refleja, se pierden ventas de producto disponible: costo de oportunidad invisible.
- **CT-ADM-08** — Opciones u obligatoriedad perdidas producen pedidos incompletos o mal tarifados que operaciones corrige a mano.
- **CT-ADM-10** — Sin propagación, cada cambio comercial exige intervención técnica y frena campañas y ajustes de precio.
- **CT-PED-01** — Un pedido cobrado que no llega al panel no se despacha: incumplimiento con el cobro ya efectuado.
- **CT-PED-02** — Detalle divergente entre cliente y panel provoca envíos equivocados y reprocesos logísticos completos.
- **CT-PED-05** — Que importes o productos cambien sin acción explícita destruye la integridad contable y la auditabilidad de las ventas.
- **CT-RNF-01** — La demora de sincronización retrasa la preparación del pedido y degrada el compromiso de entrega.
- **CT-RNF-04** — Un catálogo por encima de dos segundos reduce la conversión en la etapa más alta del embudo.

---

## 4. Matriz de trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto

La cadena de trazabilidad tiene **cuatro eslabones: Requisito ↔ caso ↔ ejecución ↔ defecto**. La **condición de prueba (CT)** se conserva como paso intermedio del análisis entre el requisito y el caso. Esta matriz documenta los eslabones requisito ↔ caso; el eslabón **ejecución** se registra en `04_ejecucion/EJECUCION_GRANIT_20260924.md` y el eslabón **defecto** en `05_defectos/HALLAZGOS.md`, donde cada DEF cita su requisito, su condición, su caso y su ejecución.

| Requisito | Condición(es) | Caso(s) de prueba previstos |
|---|---|---|
| RF CHK 01 | CT-CHK-01, CT-CHK-02 | CP-CHK-01 |
| RF CHK 02 | CT-CHK-03 | **No cubierta en esta iteración** — el bloque prioriza el flujo de invitado, de mayor volumen y riesgo. |
| RF CHK 03 | CT-CHK-04, CT-CHK-05 | CP-CHK-01 |
| RF CHK 04 | CT-CHK-06 | CP-CHK-01 |
| RF CHK 05 | CT-CHK-07 | **No cubierta en esta iteración** — el arrastre carrito→checkout depende del bloque de carrito y cupones (Integrante 1). |
| RF CON 01 | CT-CON-01, CT-CON-02 | CP-CON-01 |
| RF CON 02 | CT-CON-03, CT-CON-04 | CP-CON-01 |
| RF CON 03 | CT-CON-05 | CP-CON-02 |
| RF CON 04 | CT-CON-06 | CP-CHK-01 (cierre del flujo de invitado) |
| RF ADM 01 | CT-ADM-01 | **No cubierta en esta iteración** — requiere escritura en el panel, no permitida al usuario `demo`. |
| RF ADM 02 | CT-ADM-02, CT-ADM-03 | CP-ADM-01 |
| RF ADM 03 | CT-ADM-04, CT-ADM-05 | CP-ADM-01 |
| RF ADM 04 | CT-ADM-06 | **No cubierta en esta iteración** — la reposición exige permisos de escritura no disponibles. |
| RF ADM 05 | CT-ADM-07 | **No cubierta en esta iteración** — la asociación de categorías exige permisos de escritura. |
| RF ADM 06 | CT-ADM-08, CT-ADM-09 | **No cubierta en esta iteración** — las opciones de producto pertenecen al alcance de FUN 02 (Integrante 1). |
| RF ADM 07 | CT-ADM-10 | CP-RNF-01 |
| RF PED 01 | CT-PED-01 | CP-PED-01 |
| RF PED 02 | CT-PED-02 | CP-PED-01 |
| RF PED 03 | CT-PED-03 | **No cubierta en esta iteración** — prioridad Media y dependencia de un pedido propio localizable. |
| RF PED 04 | CT-PED-04 | **No cubierta en esta iteración** — el cambio de estado exige permisos administrativos. |
| RF PED 05 | CT-PED-05 | **No cubierta en esta iteración** — su verificación presupone CT-PED-04, hoy bloqueada. |
| RNF 01 | CT-RNF-01, CT-RNF-02 | CP-RNF-01 |
| RNF 02 | CT-RNF-03 | CP-RNF-02 |
| RNF 03 | CT-RNF-04, CT-RNF-05 | CP-RNF-03 |

Sin elementos huérfanos: los 24 requisitos tienen al menos una condición y las 33 condiciones tienen destino (caso asignado o justificación explícita de no cobertura).

---

## 5. Análisis de cobertura

| Bloque | Requisitos | Condiciones | Condiciones Alta | Cubiertas por caso diseñado |
|---|---|---|---|---|
| FUN 05 Checkout | 5 | 7 | 6 | 5 |
| FUN 06 Confirmación | 4 | 6 | 6 | 6 |
| FUN 07 Admin. productos y stock | 7 | 10 | 7 | 5 |
| FUN 08 Gestión de pedidos | 5 | 5 | 3 | 2 |
| RNF 01–03 | 3 | 5 | 2 | 5 |
| **Total** | **24** | **33** | **24** | **23** |

Cobertura de condiciones por caso diseñado: **23 de 33 (70 %)**; **10 condiciones** quedan fuera de esta iteración y **9 requisitos** (RF CHK 02, RF CHK 05, RF ADM 01, RF ADM 04, RF ADM 05, RF ADM 06, RF PED 03, RF PED 04, RF PED 05) no tienen caso asignado.

**Huecos conscientes.** No son aleatorios: se concentran en las condiciones que exigen **escritura en el panel** (CT-ADM-01, 06, 07, 08; CT-PED-04, 05) y en las de prioridad Media con baja relación riesgo/esfuerzo frente a los ocho casos asignados (CT-CHK-03, CT-PED-03). Se priorizó cubrir por completo la cadena transaccional pago → confirmación → visibilidad operativa (FUN 06 y RNF al 100 %), donde se concentra el riesgo económico y reputacional. Además, **17 de las 33 condiciones dependen de un pedido completado o de permisos administrativos**: más de la mitad del bloque puede quedar **Bloqueado** si se ejecuta sobre `demo.opencart.com`. La mitigación planificada es una instancia propia del demo oficial; si no se concreta, la **tasa de bloqueo** se reportará sobre el total **planificado** —no sobre lo ejecutado—, la **tasa de aprobación** sobre los casos **ejecutados**, y el hueco se declarará como riesgo residual en el cierre.

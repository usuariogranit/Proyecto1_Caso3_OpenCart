# REGISTRO DE EJECUCIÓN MANUAL — Bloque Granit (Integrante 2)
Fecha de ejecución: 24-09-2026 · Sistema: OpenCart Demo (demo.opencart.com) · Ambiente: ver `00_gestion/BITACORA_AMBIENTE.md`
Origen de acceso: navegador local del responsable (el entorno automatizado estaba bloqueado por Cloudflare).

## Datos de prueba utilizados
| Dato | Valor |
|---|---|
| Producto elegible | iPod Nano (product_id 36) — único sin advertencia de stock entre los evaluados |
| Cantidad | 2 |
| Identidad de invitado | Test / QA CS5383 / qa.cs5383.test@example.com (ficticios) |
| Dirección | Av. Prueba 123, London, SW1A 1AA, United Kingdom, Greater London |

## Estado del catálogo observado (24-09-2026)
| Producto | Disponibilidad publicada | Observación |
|---|---|---|
| HTC Touch HD (28) | In Stock | Rechazado por control de stock en el carrito (***) |
| iPod Nano (36) | In Stock | Aceptado, sin advertencia |
| Product 8 (35) | In Stock | Exige opción: "Size required!" |
| Apple Cinema 30" (42) | In Stock | Exige Radio, Checkbox, Text, Select y Textarea required |
| iPhone (40), iMac (41), MacBook (43), MacBook Air (44), MacBook Pro (45) | Out Of Stock | MacBook conserva botón "Add to Cart" activo |
| Canon EOS 5D (30), Nikon D300 (31), iPod Touch (32), Palm Treo Pro (29) | 2-3 Days | iPod Touch rechazado por stock en carrito (***) |

## Resultados por caso
| Caso | Resultado esperado | Resultado obtenido | Veredicto | Causa |
|---|---|---|---|---|
| CP-CHK-01 Checkout como invitado | El flujo continúa sin exigir creación de cuenta y permite completar la compra | Guest Checkout disponible; datos guardados con "Success: Your guest account information has been saved!"; el flujo se detiene antes del pago: "No Payment options are available. Please contact us for assistance!" y no existe sección "Shipping Method" | **Bloqueado** (parcialmente verificado) | Ambiente sin métodos de pago ni envío configurados |
| CP-CON-01 Generación de número y resumen del pedido | Se crea un único número de orden y se muestra confirmación | "Confirm Order" no genera pedido, no navega y no emite mensaje alguno | **Bloqueado** | Dependencia de CP-CHK-01 |
| CP-CON-02 Prevención de pedido duplicado | Doble clic o recarga no generan dos órdenes | No ejecutable: no es posible generar una primera orden | **Bloqueado** | Dependencia de CP-CON-01 |
| CP-ADM-01 Stock cero reflejado públicamente | El sitio público impide comprar el producto agotado | Pendiente: requiere sesión administrativa autenticada por el responsable | **Pendiente** | Login manual no realizado aún |
| CP-PED-01 Pedido público visible en administración | El pedido aparece en Sales > Orders con el mismo identificador | No ejecutable: no existe pedido que consultar | **Bloqueado** | Dependencia de CP-CON-01 |
| CP-RNF-01 Sincronización sitio–panel | El cambio administrativo se refleja en el sitio público sin reinicio | Pendiente: requiere permisos de escritura en el panel | **Pendiente** | Login manual + permisos |
| CP-RNF-02 Flujo crítico en navegadores | El flujo se completa en los navegadores seleccionados | Pendiente | **Pendiente** | Falta ejecución multi-navegador |
| CP-RNF-03 Tiempo de respuesta del catálogo | Respuesta menor a 2 segundos | Pendiente | **Pendiente** | Falta medición instrumentada |

## Observación metodológica
Los veredictos **Bloqueado** se sustentan en impedimentos del ambiente registrados en bitácora con texto literal del
sistema, no en supuestos. Ninguno se contabiliza como aprobado ni como fallido.

**Denominadores.** La **tasa de bloqueo** se calcula sobre los casos **planificados** (4 Bloqueado de 8 planificados
= 50 %). La **tasa de aprobación** se calcula sobre los casos **ejecutados**; hoy no es calculable, porque ningún caso
alcanzó veredicto Aprobado ni Fallido (0 ejecutados). El **% de alta prioridad ejecutada** se reporta por separado.

**Trazabilidad.** Este registro es el eslabón **ejecución** de la cadena **Requisito ↔ caso ↔ ejecución ↔ defecto**.
La condición de prueba (CT) queda como paso intermedio del análisis en `entregables/C_analisis_condiciones_granit.md`;
los defectos derivados de esta ejecución están en `05_defectos/HALLAZGOS.md`.

**Estado frente a los criterios de salida.** El cierre no se expresa con una etiqueta, sino como estado frente a los
criterios declarados en `00_gestion/CRITERIOS_SALIDA.md`: con 0 casos de alta prioridad ejecutados **no se cumple CS1**
y **CS2 no es calculable** (denominador cero), de modo que, con la evidencia disponible hoy, **el release no está listo**.

**Prueba de confirmación y regresión.** Cuando un defecto pase al estado **Listo para reprueba**, se repetirá el caso
que falló mediante **prueba de confirmación**, y se evaluará **regresión** sobre los casos que comparten precondiciones.

---
# ACTUALIZACIÓN DE VEREDICTOS — 24-09-2026, tras acceso al panel administrativo
La verificación administrativa (Extensions > Payments y > Shipping) demostró que los métodos de pago y envío están
habilitados y sin restricción de zona. Por lo tanto, la imposibilidad de pagar **no es una limitación del ambiente sino
el defecto DEF-04**. Esto cambia los veredictos previos:

| Caso | Veredicto anterior | Veredicto actualizado | Sustento |
|---|---|---|---|
| CP-CHK-01 | Bloqueado (ambiente) | **Falló** | RF CHK 01 exige completar la compra sin crear cuenta; el sistema lo impide por DEF-04. Además arrastra DEF-01 en los importes |
| CP-CON-01 | Bloqueado (ambiente) | **Bloqueado por defecto DEF-04** | No es posible confirmar un pedido mientras el sitio no ofrezca método de pago |
| CP-CON-02 | Bloqueado (ambiente) | **Bloqueado por defecto DEF-04** | Requiere una primera orden existente |
| CP-PED-01 | Bloqueado (ambiente) | **Bloqueado por defecto DEF-04** | Requiere una orden propia rastreable |
| CP-RNF-03 | Pendiente | **Pasó** | Cuatro mediciones bajo el umbral; ver MEDICIONES_RNF03_20260924.md |
| CP-RNF-02 | Pendiente | **Parcialmente ejecutado** | Flujo crítico verificado en Chrome; faltan Edge y Firefox |
| CP-ADM-01 | Pendiente | **Pendiente** | Requiere escritura en el panel (cambio de stock a cero) |
| CP-RNF-01 | Pendiente | **Pendiente** | Requiere escritura en el panel para medir la propagación |

## Datos administrativos verificados (lectura, 24-09-2026)
| Producto | Cantidad en panel | Disponibilidad publicada en el sitio |
|---|---|---|
| HTC Touch HD | 0 | "In Stock" — contradice el inventario real |
| Canon EOS 5D | 0 | "2-3 Days" |
| iPod Touch | 0 | "2-3 Days" |
| iPhone, iMac, iPod Classic, iPod Shuffle | 0 | "Out Of Stock" |
| iPod Nano | 147 | "In Stock" (coherente) |
| Apple Cinema 30" | 447 | "In Stock" (coherente) |
| HP LP3065 | 1000 | — |

Este contraste es la evidencia directa de DEF-02: el sitio publica etiquetas de disponibilidad que no corresponden al
inventario registrado en el panel, y la validación real recién ocurre en el carrito.

## Métricas parciales al 24-09-2026 (denominadores según el criterio del curso)
- Casos **planificados**: 8
- Casos **ejecutados**: 2 (CP-CHK-01, CP-RNF-03) + 1 parcial (CP-RNF-02)
- **Tasa de bloqueo = 3 / 8 = 37.5 %** (sobre planificados)
- **Tasa de aprobación = 1 / 2 = 50.0 %** (sobre ejecutados)
- Defectos abiertos: 1 crítico (DEF-04), 2 altos (DEF-01, DEF-02), 1 medio (DEF-03)

Estado frente a los criterios de salida: **CS1 no se cumple** (no todos los casos de alta prioridad se ejecutaron),
**CS2 no se cumple** (50 % contra el umbral de 90 % de los ejecutados), **CS3 no se cumple** (existe un defecto
crítico abierto), **CS4 se cumple** (2 defectos altos abiertos, el máximo admitido). Con tres de los cuatro criterios
incumplidos y el flujo de compra inutilizable, **el release no está listo**.

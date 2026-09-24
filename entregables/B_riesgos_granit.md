# B. Registro de Riesgos — Integrante 2 (Granit)
**CS5383 · Proyecto 1 · Caso 3 OpenCart** · Bloque FUN-05 a FUN-08 y RNF 01–03 · Corte: 24-09-2026

---

## 1. Método de evaluación

**Probabilidad** (dentro de la ventana de ejecución):
- **Alta:** ya ocurrió o es condición estructural del ambiente.
- **Media:** plausible y conocida en entornos equivalentes; depende de condiciones ajenas.
- **Baja:** exige condiciones poco frecuentes.

**Impacto** (consecuencia si se materializa):
- **Alto:** invalida un flujo transaccional crítico; pérdida económica o incumplimiento con el cliente.
- **Medio:** degrada cobertura u operación; retrabajo acotado.
- **Bajo:** molestia operativa; no afecta la decisión de release.

**Matriz Probabilidad × Impacto → Nivel de Riesgo**

| Prob. \ Impacto | Alto | Medio | Bajo |
|---|---|---|---|
| **Alta** | Alto | Alto | Medio |
| **Media** | Alto | Medio | Bajo |
| **Baja** | Medio | Bajo | Bajo |

**Producto vs. proceso.** El riesgo de **producto** es que el sistema falle frente a un requisito y dañe al negocio (venta sin inventario, pedido duplicado, datos inconsistentes). El riesgo de **proyecto/proceso** es que el equipo no pueda ejecutar la prueba prevista (ambiente, permisos, datos, tiempo): no dice nada sobre la calidad del sistema, pero determina cuánta evidencia podremos obtener.

---

## 2. Riesgos de proceso

| ID | Riesgo | Causa | Efecto sobre las pruebas | Prob | Imp | Nivel | Mitigación | Contingencia | Estado |
|---|---|---|---|---|---|---|---|---|---|
| RPR-01 | Sin permisos de escritura en el panel | Usuario `demo` restringido por el proveedor | CP-ADM-01 y precondiciones administrativas no ejecutables | Alta | Alto | **Alto** | Rediseñar lo administrativo como solo-lectura | Instancia propia desde el acceso oficial | **MATERIALIZADO** 18-09-2026: al guardar, el panel responde `Warning: You do not have permission to modify coupons` |
| RPR-02 | Datos alterados por otros usuarios | Ambiente público multiusuario | Precondiciones caducan; resultados no reproducibles | Alta | Medio | **Alto** | Verificar precondición justo antes de cada caso | Re-ejecutar con producto alterno | Vigente |
| RPR-03 | Indisponibilidad del ambiente | Bloqueo perimetral del host del demo | Ejecución detenida; bloque completo Bloqueado | Alta | Alto | **Alto** | Verificar disponibilidad antes de cada sesión | Instancia propia y replanificar cronograma | **MATERIALIZADO** 24-09-2026: `demo.opencart.com` devuelve HTTP 403 con página Cloudflare "Sorry, you have been blocked", en sitio público y en el panel (`https://demo.opencart.com/TlbeVW/`). Ray IDs `a3ffd6a6fe936f20` y `a3ffdaf1d8966f2f`. `opencart.com` sí responde: el bloqueo es del host del demo |
| RPR-04 | Sesiones contaminadas entre casos | Carrito, cookies y sesión persistentes | Veredictos falsos por estado heredado | Media | Medio | **Medio** | Ventana limpia por caso; cerrar sesión | Repetir en perfil nuevo | Vigente |
| RPR-05 | Imposibilidad de generar un pedido real | Checkout interrumpido por control de inventario | CP-CON-01/02, CP-PED-01 y CP-RNF-01 sin precondición | Alta | Alto | **Alto** | Verificar stock antes de iniciar | Instancia propia con Stock Checkout controlado | **MATERIALIZADO** 18-09-2026: no fue posible completar el checkout; el flujo se detuvo por stock |
| RPR-06 | Productos sin datos válidos | Catálogo degradado por uso público | Datos insuficientes para RF CHK 05 y RF ADM 06 | Media | Medio | **Medio** | Inventariar productos aptos al abrir sesión | Sustituir por equivalente y documentarlo | Vigente |
| RPR-07 | Flujos bloqueados por configuración | Guest Checkout, pago o envío deshabilitados | Requisitos no verificables aun con ambiente arriba | Alta | Alto | **Alto** | Revisar configuración antes de diseñar pasos | Declarar Bloqueado con su causa | Vigente |
| RPR-08 | Ambiente único sin alterno aprobado | Instancia propia aún como decisión pendiente | Un solo punto de falla para todo el bloque | Media | Alto | **Alto** | Escalar la decisión antes de ejecutar | Preparar instancia propia en paralelo | Vigente |
| RPR-09 | Evidencia no reproducible por deriva del ambiente | El dato cambia entre captura y revisión | Hallazgos cuestionables en revisión | Media | Medio | **Medio** | Captura fechada; registrar URL y hora | Re-capturar y anotar la discrepancia | Vigente |
| RPR-10 | Umbrales de RNF 01 y RNF 03 sin acordar | El avance los deja "por acordar" | Sin criterio de aceptación no hay veredicto | Alta | Medio | **Alto** | Acordar umbral y método antes del diseño | Reportar la medición como observación | Vigente |
| RPR-11 | Pérdida o descontrol del testware | Gestión de la configuración informal | Versiones divergentes de casos y evidencia | Baja | Medio | **Bajo** | Repositorio único versionado | Reconstruir desde la última línea base | Vigente |

---

## 3. Riesgos de producto de mi bloque

| ID | Riesgo | Requisito(s) afectado(s) | Causa | Efecto sobre las pruebas | Prob | Imp | Nivel | Mitigación | Contingencia | Estado |
|---|---|---|---|---|---|---|---|---|---|---|
| RPD-01 | El checkout no completa la compra con datos válidos | RF CHK 01–04 | Validaciones o métodos de envío/pago mal aplicados | Invalida el flujo transaccional principal | Media | Alto | **Alto** | CP-CHK-01 Alta; equivalencia y valores límite | Aislar la etapa y trazar el defecto a su RF | Potencial |
| RPD-02 | El checkout no conserva productos, cantidades u opciones | RF CHK 05 | Recálculo entre etapas | Cobro distinto al aceptado | Baja | Alto | **Medio** | Comparar campo a campo carrito vs. resumen | Reproducir con carrito multiproducto | Potencial |
| RPD-03 | Sin identificador de orden o resumen no coincidente | RF CON 01, 02, 04 | Falla en la creación de la orden | Cliente sin evidencia de la operación | Baja | Alto | **Medio** | CP-CON-01: total antes y después de confirmar | Contrastar con el detalle administrativo | Potencial |
| RPD-04 | Pedidos duplicados por doble clic, recarga o retorno | RF CON 03 | Confirmación sin idempotencia | Doble cargo y reclamo | Media | Alto | **Alto** | CP-CON-02 con las tres variantes de reenvío | Verificar conteo de órdenes en el panel | Potencial |
| RPD-05 | Inconsistencia entre sitio público y panel | RF ADM 02, 04, 07 · RNF 01 | Caché o propagación diferida | Operación decide sobre datos falsos | Media | Alto | **Alto** | CP-ADM-01 y CP-RNF-01 con marca de tiempo | Medir el desfase contra el umbral | Potencial |
| RPD-06 | Pedido confirmado ausente en la lista administrativa | RF PED 01, 02 | Falla de persistencia o sincronización | Pedido invisible para operaciones | Baja | Alto | **Medio** | CP-PED-01: comparar identificador y detalle | Buscar por filtros alternos antes de reportar | Potencial |
| RPD-07 | Pérdida de sesión administrativa | RF ADM 01–07 · RF PED 01–05 | Expiración del token de sesión | Simula bloqueos falsos | Media | Medio | **Medio** | Reautenticar al inicio de cada caso | Repetir con sesión recién abierta | Potencial |
| RPD-08 | Desfase de sincronización sobre el umbral | RNF 01 · RF ADM 07 | Latencia de propagación | Sobreventa durante la ventana de desfase | Media | Medio | **Medio** | Medición repetida en CP-RNF-01 | Observación si falta umbral (RPR-10) | Potencial |
| RPD-09 | Flujo crítico fallido en algún navegador seleccionado | RNF 02 · RF CHK 01–05 | Diferencias de motor de render o scripting | Segmento de clientes sin poder comprar | Media | Medio | **Medio** | CP-RNF-02 en Chrome, Edge y Firefox | Documentar navegador y versión exactos | Potencial |
| RPD-10 | La gestión del pedido altera importes o productos | RF PED 04, 05 | Efecto lateral del cambio de estado | Descuadre contable | Baja | Alto | **Medio** | Comparar totales antes y después del cambio | Contrastar con el historial del pedido | Potencial |
| RPD-11 | Compra permitida por encima del stock disponible | RF ADM 03 | Política de Stock Checkout mal aplicada | Venta sin inventario real | Media | Alto | **Alto** | CP-ADM-01 con cantidad cero y sobre stock | Verificar configuración antes de calificar | Potencial |
| RPD-12 | Catálogo responde por encima de dos segundos | RNF 03 | Carga del demo compartido | Abandono de navegación | Media | Bajo | **Bajo** | CP-RNF-03: varias mediciones, caché y red documentadas | Medición sin veredicto si falta umbral | Potencial |

> Los riesgos **Potencial** no han sido observados: son hipótesis de falla que orientan el diseño. Solo los tres **MATERIALIZADO** cuentan con evidencia fechada.

---

## 4. Riesgos residuales

Aun ejecutando todo mi bloque queda sin cubrir: (a) la **concurrencia** —dos clientes comprando la última unidad—, que el demo no permite controlar; (b) la **integración real de pago**, al operar con métodos de prueba; (c) la **persistencia a largo plazo** de los pedidos, porque el ambiente compartido se restablece; (d) los **navegadores móviles**, fuera del conjunto de RNF 02; y (e) toda verificación que exija escritura administrativa mientras persista RPR-01. Se trasladan al cierre como **riesgo residual documentado, pendiente de aceptación por negocio**, dentro del estado frente a los criterios de salida, no como cobertura lograda.

---

## 5. Vínculo riesgo → prioridad de prueba

La prioridad de cada condición y caso se deriva del **nivel de riesgo**, no del orden del enunciado: los casos que atacan riesgos Altos se ejecutan primero y son los que condicionan el **estado frente a los criterios de salida** (CS1–CS4, `00_gestion/CRITERIOS_SALIDA.md`). El criterio es el impacto de negocio. Una **venta sin inventario real** (RPD-11) genera incumplimiento con el cliente y costo operativo de reposición o cancelación: por eso CP-ADM-01 es Alta. Un **pedido duplicado** (RPD-04) implica doble cargo y reclamo, lo que sostiene la prioridad Alta de CP-CON-02. Una **inconsistencia sitio–panel** (RPD-05, RPD-06) hace que operaciones decida sobre datos falsos —despachar lo que no existe o ignorar un pedido real—, de ahí la prioridad Alta de CP-PED-01 y CP-RNF-01. Los riesgos Medio y Bajo sustentan casos de prioridad menor, ejecutables solo si el ambiente lo permite. En sentido inverso, los riesgos de proceso Altos determinan qué casos se declaran **Bloqueados**: la **tasa de bloqueo** se calcula sobre los casos **planificados**, no sobre los ejecutados, mientras que la **tasa de aprobación** se calcula sobre los casos **ejecutados**.

# Proyecto 1 — Caso 3: OpenCart
### CS5383 · Verificación y Pruebas de Software · Planificación, Análisis y Diseño de Pruebas

Sistema bajo prueba: **OpenCart Demo** — https://demo.opencart.com/
Panel administrativo: `https://demo.opencart.com/TlbeVW/` (credenciales publicadas por opencart.com: `demo` / `demo`)

---

## División del trabajo

| Integrante | Bloque | Estado |
|---|---|---|
| **Franco** | FUN-01 catálogo · FUN-02 ficha y opciones · FUN-03 carrito · FUN-04 cupones y certificados · RNF-03 | Pendiente |
| **Granit** | FUN-05 checkout · FUN-06 confirmación · FUN-07 productos y stock admin · FUN-08 pedidos · RNF-01 · RNF-02 | Completo — ver `04_ejecucion/F_CONSOLIDACION_Y_CIERRE.md` |

---

## Estructura del repositorio

```
00_gestion/      Bitácora de ambiente, estrategia de resiliencia, criterios de salida
01_planificacion/
02_analisis/
03_diseno/       Fichas de casos de prueba
04_ejecucion/    Registros de ejecución manual y mediciones
05_defectos/     Reporte de hallazgos y defectos
entregables/     Planificación, riesgos y análisis de condiciones
evidencias/      Capturas, una carpeta por caso de prueba
snapshots/       Copias locales de páginas evaluadas
```

---

## Convenciones obligatorias del proyecto

1. **Nombre de defecto:** `[Módulo / Funcionalidad] + [Qué falla] + [Bajo qué condición]`
2. **Trazabilidad de cuatro eslabones:** Requisito ↔ caso ↔ ejecución ↔ defecto
3. **Denominadores de métricas:** tasa de bloqueo sobre **planificados**; tasa de aprobación sobre **ejecutados**
4. **Criterios de salida declarados ANTES** de presentar métricas o gráficos
5. **Severidad** (impacto técnico, la evalúa QA) ≠ **Prioridad** (urgencia, la define negocio)
6. Terminología: *prueba de confirmación*, *pruebas de regresión*, *Gestión de la Configuración*, *testware*, *lecciones aprendidas*
7. Un impedimento se registra como **Bloqueado**, nunca como **Fallido**, y se sustenta en la bitácora de ambiente
8. **Nombre de evidencia:** `CP-XXX-NN_pasoNN_descripcion_AAAAMMDD.png`

---

## Criterios de salida del proyecto

| ID | Criterio | Umbral |
|---|---|---|
| CS1 | Casos de alta prioridad ejecutados | 100 % |
| CS2 | Tasa de aprobación sobre ejecutados | ≥ 90 % |
| CS3 | Defectos críticos abiertos | 0 |
| CS4 | Defectos altos abiertos | máximo 2 |

---

## Estado del bloque de Granit al 24-09-2026

Cierre completo en `04_ejecucion/F_CONSOLIDACION_Y_CIERRE.md` (métricas, criterios de salida, riesgos residuales, automatización y lecciones aprendidas).

| Caso | Veredicto |
|---|---|
| CP-CHK-01 Checkout como invitado | Falló |
| CP-CON-01 Número y resumen del pedido | Bloqueado por DEF-04 |
| CP-CON-02 Prevención de pedido duplicado | Bloqueado por DEF-04 |
| CP-PED-01 Pedido visible en administración | Bloqueado por DEF-04 |
| CP-ADM-01 Stock cero reflejado públicamente | Bloqueado — "Warning: You do not have permission to modify products!" |
| CP-RNF-01 Sincronización sitio–panel | Bloqueado — dependencia de CP-ADM-01 |
| CP-RNF-02 Flujo crítico en navegadores | Parcialmente ejecutado (Chrome) |
| CP-RNF-03 Tiempo de respuesta del catálogo | Pasó |

### Defectos abiertos

| ID | Título | Severidad | Prioridad |
|---|---|---|---|
| DEF-04 | [Checkout / Sincronización sitio–panel] El sitio público no ofrece ningún método de pago pese a que el panel tiene Cash On Delivery habilitado en todas las zonas | Crítica | Alta |
| DEF-01 | [Carrito y resumen de checkout] El total de línea omite el Eco Tax por unidad, mostrando $242.00 en lugar de $244.00 para 2 unidades | Alta | Alta |
| DEF-02 | [Ficha de producto y carrito] Un producto publicado "In Stock" es rechazado por el control de inventario al llegar al carrito y bloquea el checkout | Alta | Alta |
| DEF-03 | [Checkout] El botón "Confirm Order" no entrega retroalimentación cuando no existe método de pago disponible | Media | Media |

Métricas finales: ejecución **2/8 = 25 %** · aprobación **1/2 = 50 %** (sobre ejecutados) · bloqueo **5/8 = 62.5 %** (sobre planificados).
De los 5 bloqueados, **3 lo están por el defecto DEF-04** y **2 por restricción de permisos del ambiente**.
Estado frente a los criterios de salida: CS1 ✗ · CS2 ✗ · CS3 ✗ · CS4 ✓ → **el release no está listo**.

---

## Para Franco

Tu bloque cubre FUN-01 a FUN-04 y aporta al RNF-03. Lo que ya está verificado en vivo y te sirve de base:

- **Inventario real del panel** (24-09-2026): HTC Touch HD `0`, Canon EOS 5D `0`, iPod Touch `0`, iPhone `0`, iMac `0`, iPod Classic `0`, iPod Shuffle `0`, **iPod Nano `147`**, **Apple Cinema 30" `447`**, **HP LP3065 `1000`**.
- **El único producto comprable sin opciones obligatorias es iPod Nano** (product_id 36).
- Product 8 (35) exige `Size required!`; Apple Cinema 30" (42) exige Radio, Checkbox, Text, Select y Textarea required.
- El carrito marca con `***` y muestra: *"Products marked with \*\*\* are not available in the desired quantity or not in stock!"*.
- **DEF-01 y DEF-02 nacen en tu bloque** (carrito y ficha de producto) pero se propagan al checkout. Están documentados en `05_defectos/HALLAZGOS.md` con pasos reproducibles: puedes tomarlos como base y profundizarlos.
- **OBS-04 está pendiente de verificación tuya:** el 18-09 se observó que un producto agotado se podía agregar al carrito con mensaje de éxito; el 24-09 no se reprodujo. Requiere reejecución controlada antes de afirmar nada.
- El cupón `2222` (-10 %, categoría Cámaras) existe en Marketing > Coupons; el usuario `demo` puede consultarlo pero rechaza modificarlo.

Sigue las convenciones de este README para que ambos bloques encajen sin retrabajo.

---

## Aviso sobre el ambiente

OpenCart Demo es un ambiente **público, compartido y volátil**: el inventario, los cupones y los pedidos cambian por
acción de terceros. Toda evidencia debe llevar fecha y hora, y toda ejecución debe citar la entrada correspondiente de
`00_gestion/BITACORA_AMBIENTE.md`. Ver también `00_gestion/ESTRATEGIA_RESILIENCIA.md`.

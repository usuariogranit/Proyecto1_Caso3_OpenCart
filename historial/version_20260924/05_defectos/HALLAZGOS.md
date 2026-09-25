# REPORTE DE HALLAZGOS Y DEFECTOS — Bloque Granit
Nomenclatura aplicada: **[Módulo / Funcionalidad] + [Qué falla] + [Bajo qué condición]**
Severidad = impacto técnico/funcional evaluado por QA · Prioridad = urgencia de atención definida por negocio (Product Owner). Son **dos ejes independientes** y por eso van en campos separados.
Escala declarada por el equipo: **Crítica · Alta · Media · Baja**. El CTFL no impone una escala: cada organización define la suya, y lo esencial es usar la misma escala con el mismo significado en todos los defectos.
Trazabilidad: **Requisito ↔ caso ↔ ejecución ↔ defecto**; la condición de prueba (CT) se conserva como paso intermedio del análisis.

**Ciclo de vida del defecto aplicado:** Nuevo → En análisis → Asignado → En corrección → **Listo para reprueba** → Cerrado.
Ramas desde «En análisis»: **Rechazado · Duplicado · Diferido**. Rama desde «Listo para reprueba»: **Reabierto → En corrección**.
«Listo para reprueba» dispara la **prueba de confirmación** (se repite el caso que falló); la **regresión** verifica que la corrección no rompa otra cosa.

---
## DEF-01 · [Carrito y resumen de checkout] El total de línea difiere de precio unitario × cantidad, mostrando $242.00 en lugar de $244.00 para 2 unidades
- **Trazabilidad:** RF CAR 03 / RF CHK 05 / RF CON 02 ↔ CP-CHK-01 ↔ ejecución del 24-09-2026 (`04_ejecucion/EJECUCION_GRANIT_20260924.md`) ↔ DEF-01 · condición de prueba intermedia: CT-CHK-05
- **Pasos para reproducir:** 1) Agregar iPod Nano al carrito. 2) Fijar cantidad 2. 3) Abrir Shopping Cart. 4) Continuar a Checkout y observar el resumen.
- **Resultado esperado:** El total de línea es coherente con precio unitario × cantidad y con el total general.
- **Resultado obtenido:** Mini-carrito "iPod Nano x 2 — $244.00"; tabla del carrito "Unit Price $122.00 / Total $242.00"; resumen de checkout "2x iPod Nano $242.00"; Total general "$244.00". Desglose: Sub-Total $200.00 + Eco Tax (-2.00) $4.00 + VAT (20%) $40.00 = $244.00. La diferencia es compatible con aplicar Eco Tax una sola vez; es una hipótesis pendiente de confirmar.
- **Severidad:** Alta (dos importes contradictorios para la misma compra, en la misma pantalla, arrastrados hasta el resumen del pedido)
- **Prioridad:** Alta (afecta la confianza en el monto a pagar y el margen del negocio)
- **Evidencia:** `evidencias/CP-CHK-01/` — captura del resumen de checkout con ambas cifras visibles
- **Estado:** Nuevo
- **Fecha:** 24-09-2026

## DEF-02 · [Ficha de producto y carrito] Un producto publicado como "In Stock" es rechazado por el control de inventario al llegar al carrito y bloquea el checkout
- **Trazabilidad:** RF PRO 01 / RF PRO 05 / RF ADM 03 / RF CHK 01 ↔ CP-CHK-01 ↔ ejecución del 24-09-2026 (`04_ejecucion/EJECUCION_GRANIT_20260924.md`) ↔ DEF-02 · condición de prueba intermedia: CT-ADM-03
- **Pasos para reproducir:** 1) Abrir HTC Touch HD (product_id 28); la ficha indica "Availability: In Stock". 2) Agregar al carrito. 3) Abrir Shopping Cart. 4) Pulsar Checkout.
- **Resultado esperado:** Un producto publicado como disponible puede comprarse, o bien la ficha informa la indisponibilidad antes de agregarlo.
- **Resultado obtenido:** El carrito marca el producto con `***` y muestra "Products marked with *** are not available in the desired quantity or not in stock!". El intento de checkout devuelve al carrito. El mismo comportamiento se reprodujo con iPod Touch (32).
- **Severidad:** Alta (inconsistencia entre disponibilidad publicada e inventario real; la validación se ejecuta tarde y bloquea la venta)
- **Prioridad:** Alta (es exactamente la queja de negocio que originó el caso: clientes que compran productos sin stock real)
- **Evidencia:** `evidencias/CP-CHK-01/`
- **Estado:** Nuevo
- **Fecha:** 24-09-2026

## DEF-03 · [Checkout] El botón "Confirm Order" no entrega retroalimentación al usuario cuando no existe método de pago disponible
- **Trazabilidad:** RF CHK 04 / RF CON 01 ↔ CP-CON-01 ↔ ejecución del 24-09-2026 (`04_ejecucion/EJECUCION_GRANIT_20260924.md`) ↔ DEF-03 · condición de prueba intermedia: CT-CON-01
- **Pasos para reproducir:** 1) Completar Guest Checkout con datos válidos. 2) Sin método de pago seleccionable, pulsar "Confirm Order".
- **Resultado esperado:** El sistema impide la confirmación e informa explícitamente qué falta.
- **Resultado obtenido:** La acción no produce navegación, ni pedido, ni mensaje. Solo persiste el aviso previo del módulo de pago.
- **Severidad:** Media (falta de retroalimentación ante acción bloqueada)
- **Prioridad:** Media (impacta la experiencia, no el dinero)
- **Nota de alcance:** la ausencia de métodos de pago es una **limitación del ambiente**, no un defecto del producto; el defecto reportado es la falta de retroalimentación.
- **Estado:** Nuevo
- **Fecha:** 24-09-2026

---
## OBS-01 · Limitación de ambiente (no es defecto de producto)
El demo público no tiene métodos de pago ni de envío configurados: "No Payment options are available. Please contact us for assistance!" y no se renderiza la sección "Shipping Method". Esto bloquea CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01. Registrado en `00_gestion/BITACORA_AMBIENTE.md`.

## OBS-02 · Referencia cruzada al bloque del Integrante 1
Productos marcados "Out Of Stock" (MacBook, iPhone, iMac) conservan el botón "Add to Cart" activo. Pertenece a FUN-02, bloque de Franco; se documenta aquí solo por su efecto sobre el flujo de checkout.

---
## DEF-04 · [Checkout / Sincronización sitio–panel] El sitio público no ofrece ningún método de pago pese a que el panel administrativo tiene Cash On Delivery habilitado para todas las zonas geográficas
- **Trazabilidad:** RF CHK 04 / RF CON 01 / RF ADM 07 / RNF 01 → CT-CHK-04, CT-RNF-01 → CP-CHK-01, CP-CON-01, CP-RNF-01 → ejecución del 24-09-2026 → DEF-04
- **Pasos para reproducir:**
  1. Agregar iPod Nano (product_id 36) al carrito, cantidad 2.
  2. Ir a Checkout y seleccionar Guest Checkout.
  3. Completar los datos obligatorios (probado con dirección de Reino Unido y de Estados Unidos).
  4. Pulsar Continue; el sistema responde "Success: Your guest account information has been saved!".
  5. Pulsar "Choose" en Payment Method.
- **Resultado esperado:** Se ofrece al menos el método habilitado en el panel (Cash On Delivery), permitiendo continuar hasta la confirmación del pedido.
- **Resultado obtenido:** "No Payment options are available. Please contact us for assistance!". No se renderiza sección "Shipping Method". La consulta directa al recurso `index.php?route=checkout/payment_method` responde **HTTP 200 con cuerpo vacío**. El comportamiento se reproduce con dos países distintos, por lo que no depende de la zona geográfica del cliente.
- **Evidencia contrastada en el panel administrativo (24-09-2026):**
  - Extensions > Payments: **Cash On Delivery = Enabled** (Sort Order 5), Free Checkout = Enabled, Bank Transfer = Disabled, Cheque / Money Order = Disabled.
  - Configuración de Cash On Delivery: **Geo Zone = All Zones**, Order Status = Pending.
  - Extensions > Shipping: **Flat Rate = Enabled**, Cost 5.00, **Geo Zone = All Zones**.
  - Sales > Orders contiene pedidos recientes (el más nuevo, 3639 del 23/09/2026 por $740.00), lo que demuestra que el flujo sí operó antes.
- **Severidad:** Crítica (ningún cliente puede completar una compra; el flujo transaccional completo queda inutilizable)
- **Prioridad:** Alta (pérdida total de ventas mientras persista)
- **Estado:** Nuevo
- **Impacto sobre el alcance de pruebas:** bloquea CP-CON-01, CP-CON-02 y CP-PED-01. Estos casos se registran como **bloqueados por defecto**, no como bloqueados por ambiente.
- **Fecha:** 24-09-2026

---
## CORRECCIÓN A OBS-01 (registrada el 24-09-2026, posterior a la verificación administrativa)
OBS-01 clasificaba la ausencia de métodos de pago como **limitación del ambiente**. La verificación en el panel
administrativo descartó esa hipótesis: los métodos están habilitados y sin restricción de zona. La observación se
reclasifica como el defecto **DEF-04**. Se conserva el registro original para dejar trazable la evolución del análisis:
una hipótesis inicial razonable, refutada con evidencia posterior, es parte del proceso de análisis y no se oculta.

## OBS-03 · Señal a investigar sobre duplicación de pedidos (no confirmada)
En Sales > Orders se observan las órdenes **3633, 3634 y 3635**, todas del cliente "John smith", todas por **$105.00**
y todas con fecha **21/09/2026**. Es un patrón compatible con el riesgo de duplicación que evalúa CP-CON-02, pero el
demo es un ambiente compartido y esas órdenes pueden provenir de pruebas legítimas repetidas por terceros. **No se
declara defecto**: se registra como señal a verificar cuando DEF-04 permita generar pedidos propios.

## OBS-04 · Dato pendiente de verificación controlada
El intento de agregar al carrito un producto agotado (iPhone, product_id 40, "Availability: Out Of Stock") no modificó
el contenido del carrito en la sesión del 24-09-2026, a diferencia de lo observado por el equipo el 18-09-2026. La
discrepancia puede deberse a la interacción o al estado del demo. **Pendiente de reejecución controlada** antes de
afirmar cualquier comportamiento. Pertenece al bloque del Integrante 1.


## Revisión de evidencia VC-20260924-01

Ver `00_gestion/REVISION_CLASE7_20260924.md` y las capturas en `informe/evidencias/gestion-20260924/`. Los resultados anteriores conservan su corte histórico.

- DEF-01: diferencia de importes reproducida; causa tributaria propuesta, no confirmada.
- DEF-04: ausencia de pago reproducida para los datos ensayados; configuración COD habilitada verificada. Alcance global y causa raíz pendientes de investigación.
- DEF-02: el formulario existente tiene Quantity 0 y Out Of Stock Status In Stock; revisar si el hallazgo procede de configuración. No se modificó ni se recargó el formulario para comprobar persistencia.
- DEF-03: Confirm Order está deshabilitado y existe mensaje de ausencia de pago. El clic del registro original no se reprodujo; requiere triage.

Las prioridades publicadas son propuestas de QA pendientes de ratificación por negocio. La revisión local de posibles duplicados identifica el par DEF-03/DEF-04 para triage, sin asegurar causa común ni cerrar registros. Reportante histórico: Granit, QA; OpenCart Demo 4.0.2.3, Chrome/macOS. La versión exacta de Chrome original no consta.

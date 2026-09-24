# D. Diseño de casos de prueba — Integrante 2 (Granit)

**CS5383 · Proyecto 1 · Caso 3 OpenCart** · FUN 05–08 y RNF 01–03 · Diseño: 24-09-2026.
Sistema bajo prueba: OpenCart Demo (`demo.opencart.com`; panel `https://demo.opencart.com/TlbeVW/`, credenciales `demo`/`demo` publicadas por opencart.com).

---

## A. Introducción

Los ocho casos derivan de las condiciones **CT-XX** de `entregables/C_analisis_condiciones_granit.md`, que descomponen los requisitos RF CHK, RF CON, RF ADM, RF PED y RNF 01–03. La condición dice **qué** comprobar; el caso añade **cómo**, con qué datos y contra qué resultado verificable. Cada ficha cierra la primera mitad de la cadena **Requisito ↔ caso ↔ ejecución ↔ defecto**: el eslabón *ejecución* está en `04_ejecucion/EJECUCION_GRANIT_20260924.md` y el *defecto*, en `05_defectos/HALLAZGOS.md`.

Se diseñan los ocho aunque parte del ambiente esté bloqueada: **la ejecutabilidad no condiciona el diseño**. El caso es el testware contra el que se medirá la corrección y lo que permite repetir la **prueba de confirmación** cuando un defecto pase a *Listo para reprueba*, además de evaluar la **regresión**. Ninguna ficha contiene resultados: los valores citados son datos de entrada y referencias de ambiente verificadas el 24-09-2026.

---

## B. Fichas de los ocho casos

### CP-CHK-01 · Checkout como invitado
- **Condición:** CT-CHK-01, 02, 04, 06; CT-CON-06 · **Requisito(s):** RF CHK 01, 03, 04; RF CON 04 · **Prioridad:** Alta
- **Técnica y justificación:** **Partición de equivalencia**: los campos admiten infinitos valores, así que se agrupan en clases que el sistema debe tratar igual —válida (completa) e inválida (vacía)— y se prueba un representante de cada una.
- **Precondiciones:** Ventana privada, sin sesión ni carrito previo, desde origen de red autorizado (desde IP de datacenter el demo da HTTP 403).
- **Datos:** iPod Nano (`product_id 36`) ×`2`. Invitado `Test` / `QA CS5383` / `qa.cs5383.test@example.com`; `Av. Prueba 123`, `London`, `SW1A 1AA`, `United Kingdom`, `Greater London`. Clase inválida: apellido vacío.
- **Pasos:**
  1. Abrir `https://demo.opencart.com/` en ventana privada.
  2. Abrir la ficha `product_id=36` (iPod Nano).
  3. Fijar cantidad `2`; pulsar "Add to Cart".
  4. Abrir el carrito; comprobar que la línea no lleva `***`.
  5. Pulsar "Checkout" y seleccionar **Guest Checkout**.
  6. Con el apellido vacío y el resto completo, pulsar "Continue".
  7. Registrar el mensaje; escribir el apellido `QA CS5383` y pulsar "Continue".
  8. Registrar el mensaje del paso.
  9. Avanzar a método de envío y de pago; registrar las opciones ofrecidas.
- **Resultado esperado:** El flujo avanza sin crear cuenta. Con apellido vacío bloquea e indica el campo; completo, guarda la identidad ("Success: Your guest account information has been saved!") y ofrece al menos un envío y un pago seleccionables.
- **Criterio de aceptación:** Confirmación alcanzada sin registro, bloqueo específico del campo vacío y envío y pago seleccionables. Si no hay ninguno: **Bloqueado**, no Fallido.

### CP-CON-01 · Generación de número y resumen del pedido
- **Condición:** CT-CON-01, 02, 03, 04 · **Requisito(s):** RF CON 01, 02 · **Prioridad:** Alta
- **Técnica y justificación:** **Pruebas basadas en casos de uso**: se verifica el recorrido completo de "confirmar una compra" hasta su salida observable —identificador y resumen—, que es donde afloran las discrepancias de totales entre etapas.
- **Precondiciones:** CP-CHK-01 alcanzó la confirmación con envío y pago seleccionados.
- **Datos:** iPod Nano (36) ×2. Referencias del 24-09-2026: Sub-Total `$200.00`, Eco Tax (-2.00) `$4.00`, VAT (20 %) `$40.00`, Total `$244.00`; línea `$242.00`; resumen `2x iPod Nano $242.00`.
- **Pasos:**
  1. Capturar el resumen final: descripción, cantidad, importe de línea y los cuatro totales.
  2. Comprobar que Sub-Total + Eco Tax + VAT es igual al Total.
  3. Comprobar que el importe de línea de `2x iPod Nano` es igual al Sub-Total.
  4. Pulsar "Confirm Order" una sola vez.
  5. Registrar la URL de destino y el identificador de orden.
  6. Comparar campo por campo el resumen confirmado contra el del paso 1.
- **Resultado esperado:** Aparece una confirmación con identificador único y no vacío, cuyo resumen repite sin diferencias productos, cantidades, impuestos y Total. Se cumple `$200.00 + $4.00 + $40.00 = $244.00` y el importe de línea iguala al Sub-Total `$200.00`; otro valor, como `$242.00`, incumple.
- **Criterio de aceptación:** Hay identificador, el Total antes y después de confirmar es idéntico y ningún importe difiere del carrito.

### CP-CON-02 · Prevención de pedido duplicado
- **Condición:** CT-CON-05 · **Requisito(s):** RF CON 03 · **Prioridad:** Alta
- **Técnica y justificación:** **Transición de estados**: el proceso tiene estados definidos —*carrito con contenido* → *pedido creado* → *reintento*— y el defecto buscado es una transición inválida: que un evento repetido desde "pedido creado" genere un segundo pedido. Sólo el modelo de estados lo hace explícito.
- **Precondiciones:** CP-CON-01 completado, con identificador de orden registrado.
- **Datos:** El pedido de CP-CON-01 (iPod Nano ×2, Total `$244.00`) y su identificador; invitado `qa.cs5383.test@example.com`.
- **Pasos:**
  1. Repetir el flujo de CP-CHK-01 hasta la etapa final con los mismos datos.
  2. Pulsar "Confirm Order" dos veces, con menos de un segundo entre pulsaciones.
  3. Registrar el identificador de orden mostrado.
  4. Recargar la confirmación (F5); aceptar el reenvío si se solicita.
  5. Registrar si aparece un identificador distinto del paso 3.
  6. Pulsar Atrás hasta la confirmación; intentar confirmar de nuevo.
  7. Consultar el estado del carrito tras cada intento.
- **Resultado esperado:** Los eventos de los pasos 2, 4 y 6 no crean un segundo pedido: se repite el identificador del paso 3 o se redirige a una página neutra (carrito vacío o error controlado). El carrito queda vacío tras confirmar.
- **Criterio de aceptación:** Un solo identificador por recorrido del checkout en los tres reintentos; dos para una misma intención de compra es incumplimiento.

### CP-ADM-01 · Producto con stock cero reflejado públicamente
- **Condición:** CT-ADM-02, 03, 04, 05 · **Requisito(s):** RF ADM 02, 03 · **Prioridad:** Alta
- **Técnica y justificación:** **Tabla de decisión**: el comportamiento depende de tres variables combinadas —cantidad, estado publicado y política de venta sin inventario (`Stock Checkout`)—, y es la única técnica que obliga a enunciar la acción esperada de cada combinación.
- **Precondiciones:** Sesión autenticada con escritura en Catalog > Products y lectura de System > Settings > Option > `Stock Checkout`.

  | Regla | Cantidad | Estado publicado | Stock Checkout | Acción esperada |
  |---|---|---|---|---|
  | R1 | 0 | Out Of Stock | No | Ficha no disponible; carrito marca `***`; checkout no avanza |
  | R2 | 0 | Out Of Stock | Sí | Compra sin inventario admitida; el checkout avanza pese al aviso |
  | R3 | Mayor que la pedida | In Stock | Indiferente | Compra permitida, sin `***` ni aviso |
  | R4 | Menor que la pedida | In Stock | No | Carrito marca `***`; checkout no avanza |

- **Datos:** R1/R2 — **MacBook (43)**, *Out Of Stock*, conserva activo "Add to Cart". R3 — **iPod Nano (36)** ×2. R4 — **HTC Touch HD (28)** e **iPod Touch (32)**, publicados disponibles pero marcados `***`. Aviso: `Products marked with *** are not available in the desired quantity or not in stock!`.
- **Pasos:**
  1. Autenticarse en el panel; anotar el valor vigente de `Stock Checkout`.
  2. Abrir Catalog > Products > MacBook (43); verificar cantidad `0` y *Out Of Stock*.
  3. Abrir su ficha pública; registrar disponibilidad y estado de "Add to Cart".
  4. Pulsar "Add to Cart" y abrir el carrito; registrar si hay `***` y el aviso.
  5. Pulsar "Checkout"; registrar si el flujo avanza.
  6. Repetir los pasos 3 a 5 con HTC Touch HD (28) e iPod Touch (32) — R4.
  7. Repetir los pasos 3 a 5 con iPod Nano (36) ×2 — R3.
  8. Contrastar cada resultado con su fila de la tabla de decisión.
- **Resultado esperado:** Cada combinación produce la acción de su regla: con `Stock Checkout = No`, R1 y R4 impiden avanzar al checkout y muestran el aviso literal, y R3 avanza sin aviso.
- **Criterio de aceptación:** Las cuatro reglas se cumplen. Que un agotado conserve "Add to Cart" activo sólo vale si el bloqueo llega en carrito o checkout; avanzar hasta la confirmación con `Stock Checkout = No` es incumplimiento.

### CP-PED-01 · Pedido público visible en administración
- **Condición:** CT-PED-01, 02 · **Requisito(s):** RF PED 01, 02 · **Prioridad:** Alta
- **Técnica y justificación:** **Pruebas basadas en casos de uso**: "preparar un pedido recibido" atraviesa dos interfaces y sólo tiene sentido de extremo a extremo: que el mismo pedido sea legible, con igual identificador y detalle, por quien debe despacharlo.
- **Precondiciones:** Existe el pedido de CP-CON-01 con identificador registrado; sesión autenticada con lectura de Sales > Orders.
- **Datos:** Identificador del pedido de CP-CON-01; correo `qa.cs5383.test@example.com`; detalle esperado iPod Nano (36) ×2 y Total `$244.00`.
- **Pasos:**
  1. Anotar la hora de confirmación pública y el identificador del pedido.
  2. Autenticarse en `https://demo.opencart.com/TlbeVW/` y abrir Sales > Orders.
  3. Localizar el pedido por su identificador y abrir su detalle.
  4. Comparar producto, cantidad, los cuatro totales y los datos del cliente contra el resumen público de CP-CON-01.
- **Resultado esperado:** El pedido aparece en Sales > Orders con **el mismo identificador** mostrado al cliente y su detalle reproduce el resumen público sin diferencias: iPod Nano ×2, Total `$244.00`.
- **Criterio de aceptación:** Identificador idéntico en ambas vistas; cero diferencias en producto, cantidad e importes.

### CP-RNF-01 · Sincronización entre sitio y panel
- **Condición:** CT-ADM-10; CT-RNF-01, 02 · **Requisito(s):** RNF 01; RF ADM 07 · **Prioridad:** Alta
- **Técnica y justificación:** **Transición de estados**: el dato recorre estados observables —*publicado anterior* → *guardado* → *propagado*— y el requisito prohíbe quedarse en "guardado pero no propagado"; modelar los estados hace medible el instante de la transición.
- **Precondiciones:** Sesión autenticada con escritura en Catalog > Products. **Umbral de sincronización acordado por el equipo antes del diseño: 60 segundos** (CT-RNF-02); es un parámetro acordado, no una medición.
- **Datos:** iPod Nano (36). Cambio: cantidad a `0`, estado a *Out Of Stock*. Reversión: el valor vigente anotado antes del cambio.
- **Pasos:**
  1. Abrir la ficha pública de iPod Nano (36); registrar disponibilidad y hora.
  2. Abrir Catalog > Products > iPod Nano (36); anotar la cantidad vigente.
  3. Cambiar la cantidad a `0` y el estado a *Out Of Stock*; guardar y registrar la hora.
  4. Sin reiniciar servicios ni limpiar caché, recargar la ficha pública en ventana privada.
  5. Repetir la recarga cada 15 segundos hasta ver el valor nuevo o cumplir 60 s.
  6. Registrar el tiempo entre el paso 3 y la primera recarga con el valor nuevo.
  7. Revertir al valor del paso 2 y verificar su propagación igual.
- **Resultado esperado:** El valor nuevo aparece en el sitio público en 60 s o menos desde el guardado, sin reinicio ni intervención técnica; la reversión se propaga igual.
- **Criterio de aceptación:** Propagación ≤ 60 s en cambio y reversión, sin reinicio. Si el guardado se rechaza por permisos ("Warning: You do not have permission to modify…"): **Bloqueado**.

### CP-RNF-02 · Flujo crítico en navegadores seleccionados
- **Condición:** CT-RNF-03 · **Requisito(s):** RNF 02 · **Prioridad:** Media
- **Técnica y justificación:** **Partición de equivalencia**: el universo de navegadores es inabarcable, así que se particiona por motor de renderizado —Chromium (Chrome, Edge) y Gecko (Firefox)—, la variable que produce diferencias reales; Edge se conserva por ser el navegador preinstalado del parque corporativo típico.
- **Precondiciones:** Chrome, Edge y Firefox de escritorio, en ventana privada, con sus versiones anotadas.
- **Datos:** Un único juego para los tres: categoría `Laptops & Notebooks` (`path=18`), iPod Nano (36) ×2 y la identidad y dirección de invitado de CP-CHK-01.
- **Pasos:**
  1. Anotar la versión exacta del navegador en uso.
  2. Entrar en la categoría; comprobar que los productos se listan con imagen y precio.
  3. Abrir la ficha de iPod Nano (36); comprobar precio, disponibilidad y botón "Add to Cart".
  4. Añadir cantidad `2` y abrir el carrito; comprobar que línea y totales se renderizan completos.
  5. Pulsar "Checkout", elegir Guest Checkout e introducir los datos de prueba.
  6. Registrar la etapa alcanzada y todo error bloqueante, con su texto literal.
  7. Repetir los pasos 1 a 6 en los tres navegadores; comparar las etapas.
- **Resultado esperado:** Catálogo, ficha, carrito y checkout se completan en los tres navegadores sin error bloqueante propio del navegador y se detienen en la misma etapa.
- **Criterio de aceptación:** Cero errores bloqueantes propios de un navegador y comportamiento equivalente entre Chromium y Gecko. Una detención idéntica en los tres por configuración del ambiente es impedimento, no defecto de compatibilidad.

### CP-RNF-03 · Medición del tiempo de respuesta del catálogo
- **Condición:** CT-RNF-04, 05 · **Requisito(s):** RNF 03 · **Prioridad:** Alta
- **Técnica y justificación:** **Análisis de valores límite**: el riesgo se concentra junto al umbral, no en el centro de las clases «≤ 1999 ms cumple» y «≥ 2000 ms incumple»; los límites examinados son **1999, 2000 y 2001 ms**, y se exige medir la condición más próxima al límite: la primera visita sin caché.
- **Precondiciones:** Navegador con DevTools, red y equipo declarados, ventana privada. Criterio de medición en `04_ejecucion/MEDICIONES_RNF03_20260924.md`.
- **Datos:** Categorías `Cameras` (`path=33`), `Desktops` (`path=20`), `Laptops & Notebooks` (`path=18`). Umbral `2000 ms`. Métrica principal: carga completa (`loadEventEnd` menos inicio de navegación, Navigation Timing API); apoyo: TTFB, respuesta del HTML y DOMContentLoaded.
- **Pasos:**
  1. Abrir ventana privada; deshabilitar la caché en DevTools > Network. Registrar las cuatro métricas en cada medición siguiente.
  2. Medición 1: cargar `Cameras` (`path=33`) sin caché.
  3. Medición 2: cargar `Desktops` (`path=20`) como navegación subsecuente.
  4. Medición 3: cargar `Laptops & Notebooks` (`path=18`) como navegación subsecuente.
  5. Medición 4: recargar `Cameras` (`path=33`) con caché habilitada.
  6. Anotar red, equipo, hora y número de recursos cargados en la medición 1.
  7. Clasificar cada medición contra los límites 1999 / 2000 / 2001 ms; calcular su margen.
- **Resultado esperado:** Las cuatro mediciones de carga completa son **estrictamente menores que 2000 ms**; exactamente 2000 ms cuenta como incumplimiento, porque el requisito exige *menos de* dos segundos.
- **Criterio de aceptación:** Cuatro mediciones bajo 2000 ms y criterio documentado —caché, red, equipo y número de mediciones— según CT-RNF-05. Un margen inferior al 5 % del umbral se consigna como riesgo, no como defecto.

---

## C. Tabla resumen

| ID | Prioridad | Técnica | Condición | Requisito(s) | Ejecutabilidad prevista |
|---|---|---|---|---|---|
| CP-CHK-01 | Alta | Partición de equivalencia | CT-CHK-01, 02, 04, 06; CT-CON-06 | RF CHK 01, 03, 04; RF CON 04 | Requiere pedido completado |
| CP-CON-01 | Alta | Casos de uso | CT-CON-01, 02, 03, 04 | RF CON 01, 02 | Requiere pedido completado |
| CP-CON-02 | Alta | Transición de estados | CT-CON-05 | RF CON 03 | Requiere pedido completado |
| CP-ADM-01 | Alta | Tabla de decisión | CT-ADM-02, 03, 04, 05 | RF ADM 02, 03 | Requiere permisos administrativos |
| CP-PED-01 | Alta | Casos de uso | CT-PED-01, 02 | RF PED 01, 02 | Requiere pedido completado |
| CP-RNF-01 | Alta | Transición de estados | CT-ADM-10; CT-RNF-01, 02 | RNF 01; RF ADM 07 | Requiere permisos administrativos |
| CP-RNF-02 | Media | Partición de equivalencia | CT-RNF-03 | RNF 02 | Ejecutable |
| CP-RNF-03 | Alta | Análisis de valores límite | CT-RNF-04, 05 | RNF 03 | Ejecutable |

**Técnicas y dónde se aplican** (el porqué de cada una consta en su ficha): **partición de equivalencia** en CP-CHK-01 (clases de campo) y CP-RNF-02 (clases de motor de renderizado); **análisis de valores límite** en CP-RNF-03 (umbral de 2 s); **tabla de decisión** en CP-ADM-01 (stock, estado, política de venta sin inventario); **transición de estados** en CP-CON-02 (carrito → pedido creado → reintento) y CP-RNF-01 (publicado → guardado → propagado); **casos de uso** en CP-CON-01 y CP-PED-01.

**Ejecutabilidad.** Dos casos son **Ejecutables** hoy (CP-RNF-02, CP-RNF-03); cuatro requieren pedido completado y dos, permisos administrativos. Los seis restantes se declaran **Bloqueados**, nunca Fallidos, y la tasa de bloqueo se calcula sobre los casos **planificados**.

---

## D. Especificación de datos de prueba

| Dato | Valor concreto | ¿Volátil? | Verificación antes de ejecutar |
|---|---|---|---|
| Producto elegible | iPod Nano `36` | Sí | *In Stock*; añadir 2 unidades y comprobar que no lleva `***` |
| Cantidad de compra | `2` | No | Fijada por el diseño |
| Disponibles pero rechazados en carrito | HTC Touch HD `28`, iPod Touch `32` | Sí | Añadirlos y comprobar `***` y el aviso "Products marked with \*\*\* are not available…" |
| Agotados | MacBook `43` (conserva "Add to Cart" activo); iPhone `40`, iMac `41`, MacBook Air `44`, MacBook Pro `45` | Sí | Confirmar *Out Of Stock* antes de usarlos |
| Con opción obligatoria, excluidos como dato base | Product 8 `35` ("Size required!"); Apple Cinema 30" `42` (Radio, Checkbox, Text, Select y Textarea required) | Bajo | No usarlos como sustitutos: añaden una variable ajena |
| Identidad de invitado | `Test` / `QA CS5383` / `qa.cs5383.test@example.com` | No | Ficticia, definida por el equipo |
| Dirección de invitado | `Av. Prueba 123`, `London`, `SW1A 1AA`, `United Kingdom`, `Greater London` | No | País y región presentes en los desplegables |
| Totales de referencia (2 × iPod Nano) | Sub-Total `$200.00`; Eco Tax (-2.00) `$4.00`; VAT (20 %) `$40.00`; Total `$244.00` | Sí | Recapturar el carrito ese día y comparar |
| Credenciales administrativas | `demo` / `demo` en `https://demo.opencart.com/TlbeVW/` | Permisos volátiles | Probar un guardado inocuo; ante "Warning: You do not have permission to modify…" los casos de escritura nacen Bloqueados |
| `Stock Checkout` | System > Settings > Option | Sí | Anotar el valor al inicio y al final; sin él la tabla de CP-ADM-01 no es interpretable |
| Identificador del pedido de referencia | Generado en CP-CON-01 | Sí | Anotarlo con su hora; es clave de CP-CON-02 y CP-PED-01 |
| Categorías de medición | `Cameras 33`, `Desktops 20`, `Laptops & Notebooks 18` | Bajo | La categoría lista productos |
| Umbrales | `2000 ms` de carga completa; `60 s` de sincronización | No | RNF 03 y acuerdo previo del equipo (CT-RNF-02) |
| Origen de red | Navegador local del responsable | Sí | La portada carga; desde IP de datacenter responde HTTP 403 |

**Regla común a todo dato volátil:** se registra el valor observado y su hora en `00_gestion/BITACORA_AMBIENTE.md` antes de ejecutar; sin esa entrada del día la ejecución no es válida.

# CP-CHK-01 - Checkout invitado hasta pago

owner: Granit

priority: Alta

conditions: CT-CHK-01; CT-CHK-02; CT-CHK-03

req: E-RF05

tech: Partición de equivalencia

why: Campo vacío y completo; identidad invitada válida sin contraseña.

pre: Carrito con iPod Nano disponible; sin sesión de cliente; dirección ficticia; no suscribirse al boletín.

data: Test / QA CS5383 / qa.cs 5383.test@example.com; Av. Prueba 123, London, SW1 A1 AA, United Kingdom, Greater London.1 unidad en corrida 25/09; 2 en historial 24/09.

expected: Apellido vacío produce error específico; datos completos se guardan sin cuenta y existe método aplicable para continuar. La confirmación final de E-RF05 se verifica en CP-CON-01. Sin pago aplicable se registra fallo de este recorrido, sin inferir causa raíz ni fallo para todo cliente.

1. Abrir Checkout y seleccionar Guest Checkout.
2. Completar todo excepto apellido y pulsar Continue; registrar validación.
3. Completar apellido y continuar; verificar datos guardados sin registro.
4. Pulsar Choose en Payment Method; registrar opciones o error.
5. Si hay pago aplicable, dejar preparado para CP-CON-01; no declarar orden confirmada en este caso.

# CP-CON-01 - Número y resumen del pedido

owner: Granit

priority: Alta

conditions: CT-CON-01; CT-CON-02; CT-CHK-01

req: E-RF06 / E-RF05

tech: Prueba de caso de uso

why: Verificación de extremo a extremo desde intención de compra hasta orden confirmada.

pre: CP-CHK-01 llega a pago y envío aplicables; sin advertencias; entorno de demostración y datos ficticios. Si falta pago, Bloqueado.

data: Pedido propio; capturar producto, opciones, cantidad y desglose actual. No fijar 244 si hay envío u otro impuesto. Para 2 Nano sin envío, referencia neto 200 +eco 4 +VAT40 =244.

expected: Identificador no vacío; resumen confirmado idéntico a intención válida; importe de línea se compara con unitario de igual base fiscal, nunca con neto 200 de forma automática. E-RF05 completo sólo si la orden final existe.

1. Capturar resumen previo con todas las líneas e importes.
2. Verificar suma neto+impuestos+envío-descuentos y coherencia de cada línea.
3. Confirmar una vez; registrar número de orden y mensaje.
4. Comparar productos, opciones, cantidades y total antes/después; comprobar que siguió siendo invitado.

# CP-CON-02 - Prevención de pedidos duplicados

owner: Granit

priority: Alta

conditions: CT-CON-03

req: E-RF06 derivado

tech: Transición de estados

why: Modela carrito preparado -> orden creada -> reintento sin nueva orden.

pre: Checkout funcional, permiso de lectura de Orders y datos propios identificables. Preparar una compra independiente para cada variante.

data: Tres carritos de prueba distinguibles con comentario QA-G5-A/B/C y correo ficticio; capturar número previo de órdenes de cada intención.

expected: Exactamente una orden por intención en cada variante. Una pantalla con el mismo ID no basta para descartar duplicados en administración.

1. Variante A: doble clic en Confirm Order y consultar todas las órdenes de esa intención en panel.
2. Variante B: confirmar otra compra una vez, recargar su confirmación y volver a contar órdenes.
3. Variante C: confirmar otra compra, volver atrás e intentar confirmar de nuevo; consultar panel.
4. Comparar IDs, cantidades e importes; no usar pedidos de terceros como prueba.

# CP-ADM-01 - Agotado en panel reflejado públicamente

owner: Granit

priority: Alta

conditions: CT-ADM-01

req: E-RF08

tech: Tabla de decisión

why: Cruza stock 0/positivo y política de compra sin stock, distinguiendo aviso de bloqueo.

pre: Permiso de escritura sobre producto de prueba dedicado, lectura de política Stock Checkout y posibilidad de restaurar. No alterar configuración global de un demo compartido sin ambiente reservado.

data: Producto dedicado equivalente a HP LP3065; guardar stock, etiqueta y configuración previos. R1: S0/Out Of Stock/política No; R2: S0/Out Of Stock/política Sí; R3: S>=cantidad/In Stock.

expected: El estado agotado guardado se refleja públicamente. El requisito original admite aviso o impedimento; no exige siempre deshabilitar Add to Cart. Sin permisos no se declara fallo de propagación ni ejecución de las tres reglas.

1. Registrar política efectiva y datos previos.
2. Guardar stock 0 y etiqueta Out Of Stock; verificar persistencia reabriendo. Si permiso denegado, parar y registrar Bloqueado.
3. Abrir ficha pública y carrito; comprobar aviso de agotado.
4. Intentar checkout conforme a fila aplicable; R1 bloquea, R2 puede admitir con aviso.
5. En entorno controlado, repetir otras filas configurables; restaurar datos y verificar.

# CP-PED-01 - Pedido público visible en panel

owner: Granit

priority: Alta

conditions: CT-PED-01

req: E-RF07

tech: Prueba de caso de uso

why: La comparación atraviesa las dos interfaces con la misma orden propia.

pre: CP-CON-01 produjo ID propio; lectura de Sales>Orders.

data: ID y resumen de esa orden; no un ID encontrado al azar en el demo.

expected: Orden presente con mismo ID y detalle; sin orden propia, Bloqueado. Pedidos ajenos no satisfacen la condición.

1. Abrir Sales>Orders y filtrar por ID propio.
2. Abrir detalle y cotejar cliente ficticio, productos, opciones, cantidades, impuestos y total.
3. Guardar captura pública y administrativa y registrar diferencias.

# CP-RNF-01 - Tiempo de actualización público a administración

owner: Granit

priority: Alta

conditions: CT-RNF-01

req: E-RNF01

tech: Transición de estados y medición temporal

why: Orden confirmada públicamente -> visible en panel; dirección correcta del enunciado.

pre: Orden propia realizable y reloj común; acceso de lectura al panel; referencia interna 60 s adoptada por este plan, pendiente de validación docente/negocio.

data: ID de CP-CON-01; t 0 confirmación pública; consultas del panel cada 5 s hasta 60 s.

expected: Orden visible sin reinicios; latencia reportada con resolución 5 s. <=60 s cumple referencia interna, no un umbral literal del enunciado. No sustituir por cambio de stock admin->público, cubierto en CP-ADM-01.

1. Registrar t 0 al confirmarse la orden en sitio público.
2. Sin reiniciar servicios, consultar panel cada 5 s por ID.
3. Registrar instante de primera aparición y consulta anterior; reportar intervalo de latencia.
4. Comparar contra 60 s como referencia interna, conservando el dato bruto.

# CP-RNF-02 - Compatibilidad en navegadores

owner: Granit

priority: Media

conditions: CT-RNF-02

req: E-RNF02

tech: Partición de equivalencia

why: Muestra por motor y aplicación: Chrome/Edge(Chromium), Firefox(Gecko). No prueba todos los navegadores populares.

pre: Instalaciones disponibles, versiones exactas anotadas, mismas condiciones de red/datos y sesiones limpias.

data: Chrome, Edge, Firefox de escritorio; catálogo Desktops, Nano 1 y datos invitados del caso CHK.

expected: Flujo equivalente sin fallos atribuibles al navegador; alcance de muestra explícito. Diseñado, no seleccionado para nueva ejecución por prioridad Media.

1. Anotar versión, sistema y tamaño de ventana en cada navegador.
2. Recorrer catálogo, ficha, carrito y checkout sin cambiar datos entre navegadores.
3. Comparar renderizado y validaciones; separar fallos comunes del demo de incompatibilidad específica.

# CP-RNF-03 - Tiempo de respuesta del catálogo

owner: Granit / Franco

priority: Alta

conditions: CT-RNF-03

req: E-RNF03

tech: Medición de rendimiento con umbral

why: No se considera análisis de valores límite ejecutado: no se controlaron tiempos 1999/2000/2001 como entradas.

pre: Instrumentación NavigationTiming/Dev Tools, registro exportable, red y equipo documentados, caché controlada. Sin instrumento verificable, Bloqueado.

data: Cameras, Desktops, Laptops&Notebooks; para cada una 3 navegaciones frías y 3 cálidas, 18 muestras. Umbral<2000 ms; métrica operacional loadEventEnd-startTime enms.

expected: Todas las muestras válidas del protocolo deben estar debajo de 2000 ms; 2000 ms exactos incumple. Se deben conservar los datos de cada medición y limitar la conclusión al ambiente evaluado.

1. Anotar equipo, versión, red, URL, hora y caché.
2. Ejecutar secuencia de muestras con Dev Tools y conservar datos brutos de cada navegación.
3. Registrar loadEventEnd-startTime, TTFB y DOMContentLoaded como apoyo.
4. Calcular mínimo, mediana, p 95, máximo; juzgar cada muestra contra 2000 ms. Separar desafíos de seguridad de carga del catálogo.
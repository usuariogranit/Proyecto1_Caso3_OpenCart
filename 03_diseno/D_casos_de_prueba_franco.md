# CP-CAT-01 - Ordenamiento por nombre

owner: Franco

priority: Media

conditions: CT-CAT-01

req: E-RF01

tech: Partición de equivalencia

why: Se comparan las clases A-Z y Z-A, incluyendo empate sin exigir un desempate no especificado.

pre: Categoría accesible con al menos dos nombres distintos; idioma inglés; registrar listado completo y número de páginas.

data: Desktops; mostrar 25 (12 productos observados como referencia, recapturar en nueva corrida).

expected: Orden lexicográfico correcto en ambos sentidos para nombres de la muestra; sin pérdidas ni duplicados. No ejecutado por prioridad Media.

1. Abrir categoría y guardar conjunto inicial de nombres.
2. Seleccionar Name (A - Z); leer todas las páginas o mostrar todos.
3. Comparar nombres consecutivos; registrar empates.
4. Seleccionar Name (Z - A) y repetir; comparar conjunto final con inicial.

# CP-CAT-02 - Ordenamiento por precio

owner: Franco

priority: Alta

conditions: CT-CAT-02

req: E-RF01

tech: Partición de equivalencia

why: Ascendente y descendente son clases del criterio; se incluyen precios iguales y promociones.

pre: Catálogo disponible, misma moneda USD y al menos dos precios distintos. Usar precio vigente, no precio tachado.

data: Desktops; Show 25; 12 productos. Referencias: Canon 98, Apple 110, HP122, HTC122, iPod Classic 122, Product 8 122, i Phone 123.20, Samsung 242, Palm 337.99, MacBook 602, MacBook Air 1202, Sony 1202.

expected: Ascendente no decrece; descendente no crece; los 12 productos se conservan. Empates permitidos. Precio especial 98 de Canon se ordena por 98, no por 122.

1. Abrir Desktops, seleccionar Show 25 y anotar productos/precios.
2. Seleccionar Price (Low > High); comparar cada precio con el siguiente.
3. Capturar lista y criterio.
4. Seleccionar Price (High > Low); repetir y comprobar igualdad del conjunto.

# CP-PRO-01 - Omisión de opción obligatoria

owner: Franco

priority: Alta

conditions: CT-PRO-01

req: E-RF02

tech: Partición de equivalencia

why: Una opción requerida ausente representa la clase inválida; se aísla de otros campos.

pre: Carrito vacío; producto con una opción obligatoria identificada; resto de datos válido. Registrar si carece de alternativas válidas, sin confundirlo con la validación de ausencia.

data: Canon EOS5 D, Select sin elegir, cantidad 1. El 25/09 sólo se ofreció el placeholder.

expected: No se añade el producto y el mensaje identifica Select. No demuestra que existan opciones válidas ni valida su precio.

1. Abrir ficha; identificar campo requerido y contador del carrito.
2. Dejar Select sin seleccionar, cantidad 1 y pulsar Add to Cart una vez.
3. Esperar respuesta, registrar mensaje y verificar que el carrito permanece vacío.

# CP-PRO-02 - Opciones válidas y variación de precio

owner: Franco

priority: Alta

conditions: CT-PRO-02; CT-PRO-03

req: E-RF02 / E-RF03 derivados

tech: Partición de equivalencia

why: Comparar opción sin recargo y con recargo manteniendo constantes producto, cantidad e impuestos.

pre: Producto con todas las opciones requeridas seleccionables, stock suficiente y ajuste fiscalmente interpretable; carrito limpio. Registrar precio base, ajuste y si incluye impuestos antes de ejecutar.

data: Candidato Apple Cinema 30: Select Blue +5.60, Green +3.20 y Checkbox 3 +38 mostrados; faltan alternativas Radio. Alternativos Canon y Product 8 tampoco tienen opciones seleccionables. Datos válidos completos pendientes de provisión.

expected: Cada configuración agrega exactamente lo solicitado; diferencia de precio corresponde al ajuste configurado e impuestos aplicables. Sin alternativas o regla fiscal verificable: Bloqueado.

1. Verificar todas las alternativas requeridas; si alguna falta, registrar bloqueo sin inventar selección.
2. En ambiente habilitado, completar opciones válidas y añadir una unidad o el mínimo del producto.
3. Comparar opciones y precio en carrito contra base más ajustes con igual criterio fiscal.
4. Vaciar, cambiar sólo una opción de recargo conocido y repetir.

# CP-CAR-01 - Actualización de cantidad válida

owner: Franco

priority: Alta

conditions: CT-CAR-01

req: E-RF03

tech: Partición de equivalencia

why: Se verifica una cantidad válida antes y después del cambio; se separa importe neto del gravado.

pre: Carrito limpio, iPod Nano disponible sin opciones, sin cupón ni envío aplicado; cantidad 2 dentro de stock.

data: USD; iPod Nano 1 y 2. Referencia: base 100, precio mostrado 122, Eco Tax 2/unidad, VAT20/unidad.

expected: Para los datos observados: 1 unidad línea 122 total 122; 2 unidades línea 244 total 244, neto 200 y tributos 44. Si la interfaz usa otra base fiscal debe explicitarla; no comparar línea gravada con subtotal neto.

1. Añadir 1 iPod Nano y guardar unitario, línea, subtotal, impuestos y total.
2. Cambiar cantidad a 2 y pulsar actualizar; esperar respuesta.
3. Recalcular línea usando unitario mostrado por cantidad cuando ambos representan la misma base fiscal.
4. Comparar subtotal 200, Eco Tax 4, VAT40 y total 244; registrar cualquier discrepancia de línea.

# CP-CAR-02 - Cantidad inválida o superior al stock

owner: Franco

priority: Alta

conditions: CT-CAR-02; CT-CAR-03

req: E-RF03 / E-RF08 derivados

tech: Partición de equivalencia y valores límite

why: Clases inválidas y frontera real del inventario: 0, 1 y S, S+1. Los tiempos 1999/2000/2001 no se presentan como datos ejecutados.

pre: Stock S leído en panel; producto sin opciones; carrito de prueba; anotar política de venta sin stock si es accesible. Restablecer una unidad entre variantes destructivas; verificar que S no cambió por terceros.

data: iPod Nano: stock S = 147 observado el 25/09; variantes 0, -1, 1.5, abc, vacío, 147 y 148.

expected: Ninguna cantidad negativa, fraccionaria o no numérica queda comprable. Cero puede retirar línea. Normalización silenciosa se informa como observación. Con política restrictiva S+1 debe bloquear checkout y S no debe marcar insuficiencia. La aritmética monetaria se juzga en CP-CAR-01; no se declara compra de 147 completada.

1. Con 1 unidad, probar por separado 0,-1, 1.5, abc y vacío; actualizar y registrar cantidad persistida, avisos y total. Reponer 1 antes de cada variante.
2. Fijar 147; comprobar ausencia de marca de insuficiencia.
3. Fijar 148; comprobar advertencia y pulsar Checkout.
4. Registrar si el sistema impide la compra; no generar pedidos con unidades inválidas. Limpiar carrito.

# CP-CUP-01 - Aplicación de cupón válido

owner: Franco

priority: Alta

conditions: CT-CUP-01

req: E-RF04

tech: Partición de equivalencia

why: Representante de código vigente, activo y elegible; oráculo calculado antes de aplicar.

pre: Cupón activo, fechas vigentes, usos disponibles, condiciones de login/mínimo y productos verificadas; carrito elegible. Registrar tipo, valor y base antes de probar.

data: Candidato 2222, descuento de 10 por ciento según el panel: el 25/09 estaba deshabilitado y vencido desde el 01/01/2020. Para ejecutar el caso se requiere un cupón activo, vigente y con condiciones conocidas.

expected: Una aplicación, descuento exacto según tipo/valor y base; total nunca negativo y tributos coherentes. No fijar total final usando una política fiscal desconocida.

1. Leer configuración vigente y registrar elegibilidad. Si no hay cupón válido, documentar bloqueo.
2. Con fixture válido, registrar subtotal e impuestos iniciales.
3. Aplicar código una vez y registrar línea de descuento y total.
4. Calcular descuento sobre base elegible; si base 100 y 10%, descuento neto 10; recalcular impuestos según configuración verificada.

# CP-CUP-02 - Cupón inválido, no aplicable o duplicado

owner: Franco

priority: Alta

conditions: CT-CUP-02; CT-CUP-03; CT-CUP-04; CT-CUP-05

req: E-RF04 y riesgo de duplicación

tech: Tabla de decisión y transición de estados

why: Cruza validez/elegibilidad y modela sin cupón -> aplicado -> reaplicado -> carrito cambiado.

pre: Carrito iPod Nano 1 sin descuento. Para variantes C-D-E, cupón válido de CP-CUP-01, restricciones y mínimo conocidos. Reiniciar estado entre variantes independientes.

data: A: QA-NO-EXISTE-20260924; B: 2222 vencido/deshabilitado; C: cupón vigente limitado a otro producto; D: mismo cupón dos veces; E: retirar producto elegible o bajar del mínimo.

expected: A/B/C: error y ningún descuento nuevo. D: descuento único no acumulado. E: descuento revalidado. Si C-D-E carecen de cupón válido, registrar variantes Bloqueadas y no aprobar todo el caso.

1. A: aplicar código inexistente; guardar error y total.
2. B: aplicar 2222 y contrastar con estado leído en panel.
3. C: con cupón válido, usar carrito no elegible y aplicar.
4. D: restablecer carrito elegible, aplicar una vez y reaplicar; comparar descuento.
5. E: cambiar elegibilidad y actualizar; verificar retiro/recalculo del beneficio.

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

# CP-CAT-03 - Categoría y filtros del catálogo

owner: Franco

priority: Media

conditions: CT-CAT-03

req: Alcance funcional p.4

tech: Partición de equivalencia

why: Conjunto con resultados y conjunto vacío.

pre: Categorías accesibles; sólo aplicar filtros efectivamente configurados.

data: Desktops y subcategoría PC; registrar conjunto esperado por membresía administrativa cuando sea accesible.

expected: Resultados pertinentes y mensaje de vacío sin error técnico. Falta de filtros configurados se consigna como limitación de datos, no se inventa ejecución.

1. Abrir categoría y verificar pertenencia.
2. Aplicar subcategoría o filtro configurado; comparar productos con regla.
3. Elegir una combinación conocida sin resultados y comprobar mensaje.

# CP-VAL-01 - Certificados de regalo

owner: Franco

priority: Media

conditions: CT-CUP-06

req: Alcance funcional p.4

tech: Tabla de decisión

why: Combina código existente/vigente y saldo suficiente/insuficiente.

pre: Certificado de prueba dedicado con saldo conocido; sin fondos reales ni certificados de terceros; total y política fiscal documentados.

data: Fixture futuro QA-G5-VALE saldo 10 y código QA-VALE-INVALIDO; total superior e inferior a 10. No creados en este demo.

expected: Sólo vale elegible descuenta; no se supera saldo ni aparece total negativo; saldo restante conforme a configuración. Diseñado, no ejecutado por prioridad Media.

1. Registrar saldo y reglas del certificado.
2. Aplicar válido y comparar descuento y total no negativo.
3. Restablecer y aplicar inválido; comprobar error sin nuevo descuento.
4. Evaluar compra con total menor al saldo y documentar remanente según regla configurada.
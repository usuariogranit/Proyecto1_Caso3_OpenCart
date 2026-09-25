# GUION DE EXPOSICIÓN — Granit (Integrante 2)
Proyecto 1 · CS5383 · Caso 3 OpenCart · Bloque: checkout, pedidos, administración, no funcionales y cierre

**Dos audiencias en la misma sala.** Tus compañeros necesitan entender *qué estaba en juego*; la docente necesita
oír *el rigor con que lo probaste*. Por eso cada bloque tiene dos capas:

> 🗣 **LA HISTORIA** — se cuenta mirando al aula, en lenguaje de negocio, sin siglas.
> 🎯 **EL RESPALDO** — se dice mirándola a ella, con el término exacto. Es la frase que sostiene lo anterior.

Duración: **12–14 minutos**. Las frases ▶ van literales.
Regla de oro del ritmo: **nunca sueltes una sigla sin haber contado antes para qué sirve.**

---

## BLOQUE 0 · El gancho (40 s) — *mira al aula, no a la pantalla*

🗣 "Imaginen que administran una tienda en línea. Es lunes, va a empezar la campaña más fuerte del año, y llegan
dos quejas de clientes: una persona compró un producto que en realidad ya no tenían en almacén, y otra aplicó un
cupón de descuento que nunca se descontó. Ustedes no saben si son dos casos aislados o la punta de algo peor."

"Esa tienda existe, corre sobre OpenCart, y fue el sistema que nos tocó. Nosotros entramos como el equipo de
pruebas, antes de la campaña, para responder una sola pregunta: **¿esta tienda puede vender sin fallar?**"

▶ **"Profesora, estructuramos nuestro plan evaluando primero cuáles son los flujos transaccionales donde el negocio no puede permitirse fallar."**

"Y la respuesta corta, que voy a sustentar en los próximos diez minutos, es que encontramos algo bastante peor que
las dos quejas originales."

*No adelantes cuál. Que se queden con la pregunta.*

---

## BLOQUE 1 · Quién hace qué, y por dónde entramos (1 min)

🗣 "Una tienda tiene dos caras. La que ve el cliente —el catálogo, el carrito, el pago— y la que ve el equipo de
operaciones: un panel interno donde se cargan productos, se ajusta el stock y se revisan los pedidos. Las dos
tienen que contar la misma verdad. Cuando no coinciden, el cliente compra humo."

"Franco se encargó de la cara del cliente antes de pagar: catálogo, ficha de producto, carrito y cupones. Yo tomé
**desde el momento en que el cliente decide pagar hacia adelante**: el pago, la confirmación del pedido, el panel
de administración y la consistencia entre ambas caras."

🎯 "En términos del caso: mi bloque cubre FUN-05 checkout, FUN-06 confirmación, FUN-07 productos y stock
administrativo, FUN-08 gestión de pedidos, y los no funcionales RNF-01 a RNF-03."

▶ "Ahí se concentra el dinero: pago → confirmación → visibilidad en operaciones."

---

## BLOQUE 2 · De qué partimos (1 min)

🗣 "No se prueba lo que a uno se le ocurre. Se parte de lo que el sistema **promete hacer**. Nosotros escribimos
esas promesas como requisitos verificables: frases que se pueden comprobar con un sí o un no, no opiniones."

🎯 "Esa es la **base de pruebas**: los 48 requisitos verificables del primer avance. De los 24 que corresponden a
mi bloque derivé **33 condiciones de prueba** y, de las de mayor riesgo, **8 casos**."

🗣 "La diferencia entre las dos cosas es simple: la condición dice **qué** hay que comprobar; el caso dice **cómo**,
con qué datos y contra qué resultado. Por eso en mi análisis no hay ni un solo paso escrito: si lo tuviera, ya no
sería análisis."

---

## BLOQUE 3 · Qué puede salir mal, y a quién le duele (1.5 min)

🗣 "Antes de probar, uno se pregunta qué es lo que más duele si falla. Y hay dos familias distintas de problema."

"La primera: **que el sistema falle y el negocio pierda**. Vender algo que no existe, cobrar dos veces, aplicar mal
un descuento. La segunda, que casi nadie menciona: **que nosotros no podamos probar**. Que el sitio se caiga, que
no nos den permisos, que los datos cambien mientras trabajamos."

🎯 "La primera es **riesgo de producto**; la segunda, **riesgo de proyecto o de proceso**. El segundo no dice nada
sobre la calidad del sistema, pero determina cuánta evidencia podemos obtener. Los evalué con una matriz
probabilidad × impacto declarada antes de las tablas."

🗣 "Y les cuento algo que no estaba en el plan: **tres de esos riesgos se nos materializaron el mismo día**."

"El sitio nos bloqueó el acceso desde una red y tuvimos que cambiar de origen. El usuario administrativo que
publica el propio OpenCart resultó ser de solo lectura. Y no logramos generar ni un pedido de prueba."

🎯 "Los tres están registrados en la bitácora con fecha, hora, origen de acceso, el texto literal que devolvió el
sistema y los identificadores del bloqueo. Un riesgo materializado sin evidencia fechada es una excusa; con
evidencia es un resultado de prueba."

---

## BLOQUE 4 · Cómo se sigue el rastro (1 min)
**Muestra:** §4.3, Figura 1.

🗣 "Cuando reportas un problema, lo primero que te preguntan es: ¿de dónde salió esto? Si no puedes responder,
tu hallazgo es una anécdota."

🎯 "Por eso la trazabilidad tiene cuatro eslabones: **requisito ↔ caso ↔ ejecución ↔ defecto**, y la condición de
prueba queda como paso intermedio del análisis. La cadena real de mi hallazgo principal es
**RF CHK 04 → CT-CHK-04 → CP-CHK-01 → ejecución del 24 de septiembre → DEF-04**, y se recorre en los dos sentidos."

🗣 "En cristiano: puedo tomar cualquier defecto y llegar hasta la promesa del sistema que rompe, o al revés."

🎯 "Y donde no hubo cobertura lo digo: 10 condiciones quedaron declaradas como no cubiertas en esta iteración, con
su motivo. No las escondí en el total."

---

## BLOQUE 5 · Cómo se eligen las pruebas (1.5 min)

🗣 "No se puede probar todo. Un formulario de pago admite infinitas combinaciones: probarlas todas tomaría años.
Las técnicas de prueba son formas de elegir **pocos casos que representen muchos**."

"Se los traduzco con las que usé:"

- 🗣 "Si un campo acepta infinitos valores, los agrupo en familias que el sistema debería tratar igual y pruebo una
  de cada familia." 🎯 **Partición de equivalencia**, en CP-CHK-01.
- 🗣 "Si el requisito dice 'menos de dos segundos', el riesgo no está en un segundo: está pegado al borde. Pruebo
  justo antes, justo en, y justo después." 🎯 **Análisis de valores límite**, en CP-RNF-03: 1999, 2000 y 2001 ms.
- 🗣 "Si el comportamiento depende de varias condiciones combinadas, armo una tabla con todas las combinaciones
  posibles para que ninguna quede sin respuesta." 🎯 **Tabla de decisión**, en CP-ADM-01: cantidad, estado
  publicado y política de venta sin inventario, cuatro reglas.
- 🗣 "Si el error aparece al repetir una acción —el famoso doble clic en Comprar— lo que hay que modelar son los
  estados por los que pasa el pedido." 🎯 **Transición de estados**, en CP-CON-02.
- 🗣 "Y cuando el problema solo aparece al recorrer todo de punta a punta, se prueba el recorrido completo."
  🎯 **Basadas en casos de uso**, en CP-CON-01 y CP-PED-01.

---

## BLOQUE 6 · La investigación: tres pistas (2.5 min) — *el tramo que engancha a la sala*

🗣 "Ahora sí, lo que encontramos. Les voy a contar tres pistas, en el orden en que aparecieron."

### Pista 1 — La cuenta que no cuadra
🗣 "Pongo dos unidades de un producto de 122 dólares en el carrito. La pantalla me dice, en la línea del producto,
que eso cuesta **242 dólares**. Y tres centímetros más abajo, en el total a pagar, dice **244**. Dos números
distintos para la misma compra, en la misma pantalla."

"La diferencia son dos dólares de un impuesto ecológico que se cobra por unidad, pero en la línea se sumó una sola
vez. Y ese número equivocado viaja hasta el resumen final del pedido."

🎯 "Es DEF-01, severidad Alta: afecta la confianza en el monto a pagar y el margen del negocio."

### Pista 2 — El producto fantasma
🗣 "Abro un teléfono que la tienda anuncia como **disponible**. Lo agrego al carrito. Y el carrito me lo marca con
tres asteriscos y me dice que no hay stock. ¿Entonces por qué lo anunciaste como disponible?"

"Entré al panel de administración a ver el inventario real de ese producto: **cero unidades**. La tienda estaba
publicando disponibilidad de algo que no existía, y solo lo admitía cuando el cliente ya había decidido comprarlo."

🎯 "Es DEF-02. Y es exactamente la queja de negocio que originó el caso: clientes que compran productos sin stock
real."

### Pista 3 — El pago que desaparece
🗣 "Llego al último paso, el momento de pagar. Y el sitio me dice que **no hay ningún método de pago disponible**."

*Pausa. Deja que caiga.*

"Mi primera conclusión fue la cómoda: 'este es un sitio de demostración, seguro no le configuraron ninguna forma
de pago'. Es decir, culpa del ambiente, no del sistema. Con eso podía cerrar el informe."

▶ **"Pero antes de escribirlo, entré al panel administrativo a verificarlo. Y encontré lo contrario."**

🗣 "Pago contra entrega: **habilitado**, para todas las zonas geográficas. Envío con tarifa plana: **habilitado**,
misma cobertura. Y en la lista de pedidos había ventas reales, la más reciente del día anterior, por 740 dólares.
O sea: los métodos existen, están encendidos, y el flujo funcionó antes."

▶ **"Lo que el cliente ve contradice lo que el panel administra. Eso no es una carencia del ambiente: es un defecto del producto, de severidad crítica."**

🗣 "Traducido al negocio: **si esta tienda abriera mañana, ningún cliente podría pagar**. No es que se venda poco.
Es que no se vende."

🎯 "Es DEF-04, y el título lo dice completo: *[Checkout / Sincronización sitio–panel] El sitio público no ofrece
ningún método de pago pese a que el panel administrativo tiene Cash On Delivery habilitado para todas las zonas
geográficas*. Módulo, qué falla, bajo qué condición."

▶ **"Un desarrollador que lo lea un lunes a las ocho de la mañana, sin haber estado en mi sesión, puede reproducirlo con mi informe y nada más."**

🎯 "Y corregí mi propia clasificación: lo que había registrado como limitación del ambiente pasó a ser el defecto
DEF-04. Ese cambio está escrito en el informe, en §8.4, porque cambia la conclusión."

---

## BLOQUE 7 · Por qué casi no pudimos ejecutar (1.5 min)

🗣 "Aquí viene la parte incómoda. De ocho pruebas que diseñé, **una pasó, una falló y cinco ni siquiera pude
ejecutarlas**."

"Y quiero ser preciso con las palabras, porque no son lo mismo."

▶ **"Un caso bloqueado no es un caso fallido. Fallido significa que el sistema se comportó distinto de lo esperado. Bloqueado significa que un impedimento externo impidió ejecutarlo. Por eso el bloqueado nunca entra en el denominador de la tasa de aprobación: no llegó a ejecutarse."**

🗣 "Y las cinco bloqueadas no lo están por la misma razón. **Tres** están bloqueadas por el defecto que acabo de
contarles: sin poder pagar, no hay pedido que confirmar, ni pedido duplicado que prevenir, ni pedido que buscar en
el panel. Las otras **dos** están bloqueadas porque el usuario administrativo del sitio es de solo lectura: intenté
poner un producto en stock cero y el sistema me respondió que no tengo permiso."

🎯 "La distinción importa porque asigna responsables distintos: la primera causa es del equipo de desarrollo; la
segunda, de la disponibilidad del ambiente de prueba. Mezclarlas ocultaría quién tiene que actuar."

---

## BLOQUE 8 · La decisión: primero la regla, después el número (2 min)
**Muestra §8.1 y solo después §8.3. Nunca al revés.**

🗣 "Ahora, la pregunta que le importa al dueño de la tienda: **¿se lanza o no se lanza?**"

"Y aquí hay una trampa clásica. Si yo les digo 'de las pruebas que ejecuté, la mitad pasó', ustedes no pueden
decidir nada, porque no saben **cuáles** ejecuté ni **qué** quedó sin probar."

▶ **"Por eso, antes de mostrar cualquier número, quiero declarar contra qué se mide: los criterios de salida del plan son las métricas con las que se decide."**

🎯 "CS1: cien por ciento de los casos de alta prioridad ejecutados. CS2: aprobación mayor o igual al noventa por
ciento de los ejecutados. CS3: cero defectos críticos abiertos. CS4: máximo dos defectos altos abiertos."

*Recién ahora cambias al tablero.*

🎯 "Tasa de ejecución **25 %**. Tasa de aprobación **50 %**. Tasa de bloqueo **62.5 %**. Y los denominadores no se
mezclan: **bloqueo sobre planificados, aprobación sobre ejecutados**."

🗣 "Por qué esa diferencia, en criollo: el bloqueo mide cuánto del trabajo total nunca arrancó, así que se compara
contra todo lo planificado. La aprobación mide qué tan bien salió lo que sí se probó, así que se compara solo
contra eso. Son dos preguntas distintas y responderlas con el mismo denominador engaña."

▶ **"No se cumplen CS1, CS2 ni CS3: solo dos de siete casos de alta prioridad pudieron ejecutarse, la aprobación es del 50 % frente a un umbral del 90 %, y hay un defecto crítico abierto en el flujo transaccional. CS4 se cumple, pero en el límite exacto. Con tres de los cuatro criterios incumplidos, el release no está listo."**

▶ **"Y señalo la lectura correcta de estas cifras: presentar 'una de dos pruebas aprobadas' como resultado positivo sería una métrica engañosa. El dato que gobierna la decisión es que el 62.5 % del alcance nunca pudo entrar a ejecución, y que está concentrado justo en la cadena de pago."**

---

## BLOQUE 9 · Qué automatizar el próximo ciclo (1 min)

🗣 "Nos toca recomendar qué de todo esto conviene automatizar. Y la respuesta no es 'todo'."

"**Sí automatizaría** la medición de velocidad del catálogo: es un número contra un umbral, se repite igual siempre,
y el margen que medimos fue de 68 milisegundos. Está tan al borde que conviene vigilarlo seguido. También la
comparación entre el stock del panel y lo que publica la tienda: es cotejar dos listas, algo que una máquina hace
mejor que una persona sobre todo el catálogo. Y el llenado del formulario de compra, que se comportó igual las dos
veces que lo corrí."

"**No automatizaría todavía** la confirmación de pedidos ni la prevención de duplicados."

▶ **"Automatizar un flujo que nadie ha logrado completar ni una sola vez a mano es escribir código contra un comportamiento que no se ha observado. La automatización rinde sobre flujos estables; hoy este no lo es, y las pruebas fallarían por el defecto conocido en lugar de detectar defectos nuevos."**

---

## BLOQUE 10 · Cierre (50 s) — *mira al aula*

🗣 "Cierro con lo que me llevo, que no es una lista de errores ajenos."

1. 🗣 "El ambiente donde pruebas es parte del trabajo, no un supuesto. Perdimos horas diseñando ejecución sobre un
   sitio que primero no nos dejaba entrar y después no nos dejaba escribir. Eso se verifica el primer día."
2. 🗣 "La diferencia entre 'no se pudo probar por el ambiente' y 'no se pudo probar por un defecto' cambia la
   conclusión del informe. A nosotros nos cambió: lo que clasificamos como problema del ambiente resultó ser el
   defecto crítico. Lo dejamos escrito."
3. 🗣 "Y la más importante: la respuesta apareció **comparando las dos caras del sistema**. Mirando solo la tienda
   nunca habríamos sabido que el panel decía lo contrario."

▶ **"El resultado de mi bloque no es que las pruebas salieran bien o mal: es que la mayor parte del alcance no pudo ejecutarse, sabemos exactamente por qué, y está sustentado con el texto literal del sistema y su fecha. Un bloqueo bien documentado y trazable vale más que un caso aprobado sin evidencia."**

---

# CÓMO MANEJAR LAS DOS AUDIENCIAS

| Situación | Qué hacer |
|---|---|
| Vas a soltar una sigla (RF, CT, CP, CS, RNF) | Di primero qué es en una frase, después la sigla. Nunca al revés. |
| Estás contando una pista | Mira al aula. Es narración, no defensa. |
| Estás dando una cifra o un criterio | Mírala a ella. Es sustento, no relato. |
| La sala se pierde | Vuelve a la tienda: "en plata, esto significa que…" |
| Ella interrumpe con una pregunta | Responde con el término exacto primero, y recién después la analogía. |
| Te quedas sin tiempo | Sacrifica el Bloque 5 (técnicas), nunca el 6 (pistas) ni el 8 (criterios). |

**Tres anclas por si te pierdes:** contra qué medimos · qué encontramos · qué decidimos.

---
# BANCO DE RESPUESTAS

### 1. "El tablero dice 95 % de casos aprobados. ¿Pasa a producción?" *(su pregunta trampa)*
▶ "Depende de cuatro cosas: **qué casos se ejecutaron**, **los criterios de salida**, **los defectos abiertos** y **lo bloqueado o no ejecutado**. Un 95 % de aprobados puede convivir con un defecto crítico en pagos. En mi bloque es literal: si mirara solo la aprobación vería 50 %, pero la decisión la toma el 62.5 % bloqueado y el crítico abierto."

### 2. "¿Por qué el porcentaje de bloqueados se calculó sobre los planificados?"
▶ "Porque los casos bloqueados representan una porción del alcance total del proyecto que no pudo ingresar a ejecución por un impedimento externo. Medirlo sobre lo ejecutado distorsionaría la métrica real de avance."

### 3. "¿Y la aprobación por qué sí va sobre ejecutados?"
"Porque mide la calidad de lo que efectivamente se probó. Son dos preguntas distintas: cuánto del alcance avanzó, y de lo que avanzó cuánto salió bien. Por eso los denominadores no se mezclan."

### 4. "Diferencia entre severidad y prioridad."
▶ "La severidad la evaluamos como QA según el impacto técnico y funcional sobre el requisito especificado. La prioridad la define el Product Owner o el negocio considerando la urgencia operativa y el impacto financiero." — "Es la sala de emergencias: la severidad es qué tan grave es la lesión; la prioridad es a quién atiendes primero. Son dos ejes independientes, por eso van en campos separados. DEF-03 es un ejemplo: severidad Media y prioridad Media, pero podrían no coincidir."

### 5. "¿Qué escala de severidad usaron y por qué?"
"Crítica, Alta, Media, Baja, declarada en §7.1. El CTFL no impone una escala; cada organización define la suya. Lo esencial es usar la misma con el mismo significado en todos los defectos, y eso lo cumplimos."

### 6. "¿Usaron IA?"
▶ "Utilizamos la herramienta como copiloto para acelerar el formato y la estructura, pero la lógica de caja negra, la contextualización y la decisión final las validamos y asumimos directamente nosotros como equipo." — Y si insiste, demuéstralo: explica por qué CP-ADM-01 es tabla de decisión y no partición de equivalencia, o por qué DEF-04 es defecto y no limitación de ambiente.

### 7. "¿Por qué no dicen GO o NO GO?"
"Porque la conclusión correcta se expresa como **estado frente a los criterios de salida**: no se cumplen CS1, CS2 ni CS3, por lo tanto el release no está listo. La etiqueta sola no dice contra qué se midió."

### 8. "¿Qué harían cuando corrijan DEF-04?"
"Pasa a **Listo para reprueba** y se ejecuta una **prueba de confirmación**: se repite el caso que falló, CP-CHK-01. Después, **pruebas de regresión** sobre los casos que comparten precondiciones —CP-CON-01, CP-CON-02 y CP-PED-01—, para verificar que la corrección no rompió otra cosa. Son actividades distintas."

### 9. "¿Por qué CP-ADM-01 está bloqueado y no fallido?"
"Porque el sistema nunca llegó a comportarse: el panel rechazó la operación con *'Warning: You do not have permission to modify products!'*. No obtuvimos evidencia sobre el requisito, así que declararlo fallido sería inventar un resultado. Está en la bitácora con hora, 02:45 del 24 de septiembre, y con captura."

### 10. "¿Qué herramienta usaron y por qué?"
"**Qase**. Organiza, conecta e informa: mantiene la cadena requisito ↔ caso ↔ ejecución ↔ defecto en un solo lugar. Los 8 casos están cargados con su Test Run y los veredictos reales. Y lo digo con la advertencia de la clase: **la herramienta no prueba por ti**, y ninguna arregla un proceso mal definido; la elegimos por integración y trazabilidad, no por la tabla comparativa."

### 11. "¿Y la gestión de la configuración?"
"Versionado del documento con identificador, autor, fecha y motivo del cambio; convención de nombres de evidencia que incluye caso, paso y fecha; y repositorio remoto en GitHub con todo el testware, que además es el punto de integración con el bloque de Franco. La fecha en la evidencia es obligatoria porque el demo es compartido y volátil."

### 12. "¿Qué riesgos quedan sin cubrir?"
"Cinco, declarados como **riesgo residual explícitamente aceptado**: confirmación de pedidos, prevención de duplicados y consistencia sitio–panel siguen sin verificar; la señal de posible duplicación que vi en Sales > Orders no está confirmada; la compatibilidad solo se probó en Chrome; y el margen de rendimiento es de 68 milisegundos. No los presento como cobertura lograda."

### 13. "¿Por qué solo ejecutaron 8 casos?"
"Ocho **diseñados** en mi bloque; el equipo suma dieciséis. El enunciado pide ejecutar los de prioridad alta, y de mis siete altos solo dos pudieron ejecutarse. El resto está bloqueado con causa registrada, no omitido."

---

# LO QUE NO DEBES DECIR

| No digas | Di |
|---|---|
| "Re-testing" | "Prueba de confirmación" |
| "Métricas de vanidad" | "Métricas engañosas" |
| "NO GO" / "GO" | "No se cumplen CS1, CS2 y CS3 → el release no está listo" |
| "Versionamiento" | "Gestión de la Configuración" |
| "Densidad de defectos" | *(no la uses: no aparece en su clase)* |
| "No se pudo probar porque el demo estaba caído" | "Se registró como Bloqueado, con el texto literal del sistema y su fecha" |
| "Nos salió bien, aprobamos lo que ejecutamos" | "El 62.5 % del alcance nunca entró a ejecución" |
| "La IA nos generó los casos" | "La IA aceleró formato y estructura; la lógica y la decisión son nuestras" |
| "Falla el pago" | "[Checkout / Sincronización sitio–panel] El sitio público no ofrece método de pago pese a…" |

---

# SI TE QUEDAS EN BLANCO
Vuelve siempre a estos tres pilares, en este orden:
1. **Contra qué medimos** — los criterios de salida.
2. **Qué encontramos** — DEF-04 y su cadena de trazabilidad.
3. **Qué decidimos** — el release no está listo, y por qué el número que lo decide es el bloqueo, no la aprobación.

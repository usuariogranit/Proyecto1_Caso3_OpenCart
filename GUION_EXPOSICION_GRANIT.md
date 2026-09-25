# GUION DE EXPOSICIÓN — Granit (Integrante 2)
Proyecto 1 · CS5383 · Caso 3 OpenCart · Bloque: checkout, pedidos, administración, no funcionales y cierre

Duración objetivo: **10–12 minutos** de exposición + preguntas.
Las frases marcadas ▶ son de impacto: dilas tal cual, no las parafrasees.

---

## ANTES DE EMPEZAR — checklist de 2 minutos
- [ ] PDF abierto en la página del **resumen ejecutivo**, no en la portada.
- [ ] Ten a un clic: §8.1 criterios de salida · §8.3 tablero · §7.5 DEF-04 · §4.3 diagrama de trazabilidad.
- [ ] Qase abierto en otra pestaña con los 8 casos y el Test Run cargado.
- [ ] Repo de GitHub abierto: es tu Gestión de la Configuración, no un adorno.
- [ ] Ten memorizados tres números: **25 % ejecución · 50 % aprobación · 62.5 % bloqueo**.
- [ ] Ten memorizada una frase: *el sitio público no ofrece método de pago aunque el panel lo tiene habilitado*.

---

## BLOQUE 1 · Apertura (30 s)

▶ **"Profesora, estructuramos nuestro plan evaluando primero cuáles son los flujos transaccionales donde el negocio no puede permitirse fallar."**

"En el Caso 3, ese flujo es la cadena **pago → confirmación del pedido → visibilidad en el panel de operaciones**. Ahí se concentra el dinero y ahí concentré mi bloque como Integrante 2. Franco cubre catálogo, ficha de producto, carrito y cupones."

*No leas la portada. No presentes al equipo. Entra por el riesgo de negocio.*

---

## BLOQUE 2 · Alcance y base de pruebas (1 min)
**Muestra:** §1.2 y la tabla de elementos de prueba.

"La base de pruebas son los 48 requisitos verificables del primer avance. De los 24 que corresponden a mi bloque —RF CHK, RF CON, RF ADM, RF PED y los tres RNF— derivé **33 condiciones de prueba**, y de las de mayor riesgo, **8 casos**."

"Una condición de prueba dice **qué** comprobar; el caso dice **cómo**, con qué datos y contra qué resultado esperado. Por eso ninguna fila de mi análisis contiene pasos: si los tuviera, ya no sería análisis, sería diseño."

*Esto le demuestra que no confundes las actividades del proceso ISTQB.*

---

## BLOQUE 3 · Riesgos: producto frente a proceso (1 min)
**Muestra:** §3.1 la matriz Probabilidad × Impacto, y las filas MATERIALIZADO.

"Separé **riesgo de producto** —que el sistema falle y dañe al negocio— de **riesgo de proyecto o proceso** —que nosotros no podamos ejecutar la prueba prevista—. El segundo no dice nada sobre la calidad del sistema, pero determina cuánta evidencia podemos obtener."

"Tres riesgos de proceso **se materializaron** y están registrados con fecha y texto literal del sistema: el usuario administrativo sin permisos de escritura, la indisponibilidad del host por bloqueo de Cloudflare con sus Ray IDs, y la imposibilidad de generar un pedido."

*Si pregunta por los Ray IDs: son el identificador que Cloudflare emite por cada bloqueo; permiten que un tercero verifique el evento.*

---

## BLOQUE 4 · Trazabilidad (1 min)
**Muestra:** §4.3, Figura 1 — el diagrama de los cuatro eslabones.

"La trazabilidad tiene cuatro eslabones: **requisito ↔ caso ↔ ejecución ↔ defecto**, y la condición de prueba queda como paso intermedio del análisis. La cadena real de mi hallazgo principal es: **RF CHK 04 → CT-CHK-04 → CP-CHK-01 → ejecución del 24 de septiembre → DEF-04**."

"Es recorrible en ambos sentidos. Ningún defecto queda flotando y ningún requisito queda sin cobertura o sin una justificación explícita de por qué no se cubrió en esta iteración: son 10 condiciones marcadas como no cubiertas, con su motivo."

*Decir en voz alta que hay huecos, y que están declarados, vale más que fingir 100 % de cobertura.*

---

## BLOQUE 5 · Diseño y técnicas (1.5 min)
**Muestra:** §5.12, tabla de técnicas.

"Apliqué cinco técnicas de caja negra y cada una responde a la naturaleza del problema, no a un checklist:"

- **Partición de equivalencia** en CP-CHK-01: los campos del checkout admiten infinitos valores, así que los agrupo en clases que el sistema debe tratar igual.
- **Valores límite** en CP-RNF-03: el riesgo del umbral de dos segundos está en el borde, no en el centro; examiné 1999, 2000 y 2001 ms.
- **Tabla de decisión** en CP-ADM-01: el comportamiento depende de tres variables combinadas —cantidad, estado publicado y política de venta sin inventario—, cuatro reglas.
- **Transición de estados** en CP-CON-02: el pedido duplicado es un defecto de transición, carrito → pedido creado → reintento.
- **Basadas en casos de uso** en CP-CON-01 y CP-PED-01: recorridos de extremo a extremo donde afloran las discrepancias entre etapas.

*Si te pregunta "¿y por qué no otra técnica?", responde por el problema, nunca por la teoría.*

---

## BLOQUE 6 · Ejecución y la distinción que sostiene todo (2 min)
**Muestra:** §8.5, tabla global con los badges de veredicto.

"De 8 casos planificados: **1 pasó, 1 falló, 5 bloqueados y 1 con ejecución parcial**."

▶ **"Un caso bloqueado no es un caso fallido. Fallido significa que el sistema se comportó distinto de lo esperado; bloqueado significa que un impedimento externo impidió ejecutarlo. Por eso el bloqueado nunca entra en el denominador de la tasa de aprobación: no llegó a ejecutarse."**

"Y de los 5 bloqueados, la causa no es la misma: **3 están bloqueados por un defecto del producto** —DEF-04— y **2 por una restricción de permisos del ambiente**. La primera causa es responsabilidad del equipo de desarrollo; la segunda, de la disponibilidad del ambiente de prueba. Mezclarlas ocultaría quién tiene que actuar."

---

## BLOQUE 7 · El hallazgo principal (2 min) — *el corazón de tu exposición*
**Muestra:** §7.5, DEF-04.

"El defecto crítico se titula así:"

▶ **"[Checkout / Sincronización sitio–panel] El sitio público no ofrece ningún método de pago pese a que el panel administrativo tiene Cash On Delivery habilitado para todas las zonas geográficas."**

"Módulo, qué falla, bajo qué condición. Un desarrollador que lo lea un lunes a las ocho de la mañana, sin haber estado en mi sesión, puede reproducirlo solo con el informe."

"Lo importante es **cómo llegué**. En el sitio público el checkout se detiene con el mensaje literal *'No Payment options are available. Please contact us for assistance!'*. Mi primera lectura fue que el demo no tenía pasarelas configuradas, o sea una **limitación del ambiente**. Entré al panel administrativo a verificarlo y encontré lo contrario: Cash On Delivery habilitado con Geo Zone en *All Zones*, Flat Rate habilitado con la misma cobertura, y pedidos recientes en Sales > Orders, el más nuevo del 23 de septiembre."

▶ **"Es decir: los métodos existen, están habilitados, sin restricción geográfica, y el flujo operó antes. Lo que el cliente ve contradice lo que el panel administra. Eso no es una carencia del ambiente: es un defecto del producto, de severidad crítica."**

"Reclasifiqué mi propia observación OBS-01 como DEF-04, y eso cambió la evaluación de CS3 de cumplido a incumplido. Dejé registrado el cambio en el informe, en §8.4, porque afecta la conclusión."

*Si dice "¿por qué dejaste el error escrito?": porque revisar una clasificación cuando aparece evidencia nueva es parte del análisis; lo inadmisible sería sostener la primera lectura habiendo visto el panel.*

**Los otros tres defectos, en 20 segundos cada uno:**
- **DEF-01** — el carrito muestra un total de línea de **$242.00** mientras cobra **$244.00**: omite el Eco Tax por unidad. Dos cifras distintas para la misma compra, en la misma pantalla, arrastradas hasta el resumen del pedido.
- **DEF-02** — HTC Touch HD se publica como *In Stock* con **cantidad 0 en el panel**; el rechazo ocurre recién en el carrito. Es exactamente la queja de negocio que originó el caso.
- **DEF-03** — el botón *Confirm Order* no entrega retroalimentación cuando no hay método de pago. Severidad Media: afecta la experiencia, no el dinero.

---

## BLOQUE 8 · Criterios de salida, y RECIÉN DESPUÉS las métricas (2 min)
**Muestra primero §8.1, después §8.3. Nunca al revés.**

▶ **"Antes de mostrar cualquier número quiero declarar contra qué se mide, porque los criterios de salida del plan son las métricas con las que se decide."**

"CS1: cien por ciento de los casos de alta prioridad ejecutados. CS2: aprobación mayor o igual al noventa por ciento de los ejecutados. CS3: cero defectos críticos abiertos. CS4: máximo dos defectos altos abiertos."

*Ahora sí, cambia de lámina al tablero.*

"Tasa de ejecución **25 %**, dos de ocho planificados. Tasa de aprobación **50 %**, uno aprobado de dos ejecutados. Tasa de bloqueo **62.5 %**, cinco de ocho planificados."

"Los denominadores no se mezclan: **bloqueo sobre planificados, aprobación sobre ejecutados**."

▶ **"Definimos previamente nuestros criterios de salida. No se cumplen CS1, CS2 ni CS3: solo dos de siete casos de alta prioridad pudieron ejecutarse, la aprobación es del 50 % frente a un umbral del 90 %, y hay un defecto crítico abierto en el flujo transaccional. CS4 se cumple, pero en el límite exacto. Con tres de los cuatro criterios incumplidos, el release no está listo."**

▶ **"Y quiero señalar la lectura correcta de estas cifras: presentar 'una de dos pruebas aprobadas' como resultado positivo sería una métrica engañosa. El dato que gobierna la decisión es que el 62.5 % del alcance planificado nunca pudo entrar a ejecución, y que ese porcentaje está concentrado justo en la cadena de pago."**

---

## BLOQUE 9 · Automatización para el Proyecto 2 (1 min)
**Muestra:** §9.

"Mi recomendación sale de lo observado, no de la teoría general:"

"**Sí automatizaría** la medición del tiempo de respuesta del catálogo: criterio numérico, ejecución idéntica en cada corrida, y un margen observado de apenas 68 milisegundos bajo el umbral, así que repetirla tiene valor real. También la verificación de consistencia entre el inventario del panel y la disponibilidad publicada: es una comparación de datos entre dos fuentes, sin interacción compleja, y repetida sobre todo el catálogo. Y los pasos previos del checkout de invitado, que se comportaron de forma estable y determinista con dos países distintos."

"**No automatizaría todavía** la confirmación de pedidos ni la prevención de duplicados: no se pueden completar ni una sola vez de forma manual. Automatizar un flujo que nadie ha logrado ejecutar es escribir código contra un comportamiento que no se ha observado."

▶ **"La automatización rinde sobre flujos estables. Hoy el flujo de compra de este sistema no es estable, y automatizarlo ahora produciría pruebas frágiles que fallarían por el defecto conocido en lugar de detectar defectos nuevos."**

---

## BLOQUE 10 · Cierre (40 s)

"Tres lecciones aprendidas:"

1. "El ambiente es parte del alcance de pruebas, no un supuesto. Verificarlo debe ser la primera actividad."
2. "Distinguir bloqueo por ambiente de bloqueo por defecto cambia la conclusión del informe: nos pasó, y quedó documentado."
3. "Contrastar el sitio público contra el panel administrativo reveló la causa raíz que la sola exploración del front no explicaba."

▶ **"El resultado de mi bloque no es que las pruebas salieran bien o mal: es que la mayor parte del alcance no pudo ejecutarse, sabemos exactamente por qué, y está sustentado con el texto literal del sistema y su fecha. Un bloqueo bien documentado y trazable vale más que un caso aprobado sin evidencia."**

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

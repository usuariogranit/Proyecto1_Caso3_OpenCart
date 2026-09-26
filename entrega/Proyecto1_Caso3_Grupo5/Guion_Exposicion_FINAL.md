# GUION FINAL DE EXPOSICIÓN — Grupo 5

**Proyecto 1 · CS5383 Pruebas y Verificación de Software · Caso 3 OpenCart**
**Sistema bajo prueba:** OpenCart Demo 4.0.2.3 · **Fecha de ejecución:** 25/09/2026
**Expositores:** Franco Roque Castillo · Granit Espinoza Salazar

**Presentación que acompaña este guion:** `Proyecto1_Caso3_Grupo5_Exposicion_FINAL.pptx` — 17 láminas, 16:9.
**Alineación:** este documento va lámina por lámina, en el mismo orden del archivo. Cada lámina lleva además
su guion completo en las **notas del orador** del propio .pptx.

**Fuente de datos:** informe final integrado del 25/09/2026 (`04_ejecucion/EJECUCION_INTEGRADA_20260925.md`).
Todas las cifras de este guion son las de la ejecución integrada; no se usan resultados históricos sustituidos.

**Duración:** 12 minutos, 6 por integrante. Preguntas después, fuera del tiempo.

---

## CÓMO USAR ESTE GUION — dos audiencias en la misma sala

> 🗣 **LA HISTORIA** — se cuenta mirando al aula, en lenguaje de negocio, sin siglas.
> 🎯 **EL RESPALDO** — se dice mirándola a ella, con el término exacto.
> ▶ **FRASE LITERAL** — dila tal cual, no la parafrasees.

**Regla de ritmo:** nunca sueltes una sigla sin haber dicho antes para qué sirve.

### Checklist de 2 minutos antes de empezar
- [ ] PPT en la lámina 1; informe abierto en otra ventana por si piden ir a una tabla.
- [ ] A un clic: DEF-01 · DEF-04 · tabla de los 14 casos Alta · matriz de trazabilidad.
- [ ] Qase abierto con los casos y el Test Run.
- [ ] Repo de GitHub abierto: es la Gestión de la Configuración, no un adorno.
- [ ] **Números memorizados:** 18 diseñados · 14 Alta · 3 pasaron · 2 fallaron · 9 bloqueados · 35.7 % concluyente · 60 % aprobación · 64.3 % bloqueo.
- [ ] **Una frase memorizada:** *el checkout no ofrece método de pago aplicable, y sin eso no hay orden que confirmar ni que rastrear*.

---

## MAPA DE LA PRESENTACIÓN

| Lámina | Título | Expositor | Tiempo | Diapositiva del guion fuente |
|---|---|---|---|---|
| 1 | Portada · Pruebas de software en OpenCart | Franco | 0:00–0:25 | 1 |
| 2 | Alcance y planificación | Franco | 0:25–1:10 | 2 |
| 3 | Priorización y riesgo | Franco | 1:10–1:40 | 3 (1ª parte) |
| 4 | Trazabilidad de cuatro eslabones *(diagrama)* | Franco | 1:40–2:05 | 3 (2ª parte) |
| 5 | Técnicas de caja negra | Franco | 2:05–3:00 | 4 |
| 6 | Catálogo y opciones de producto | Franco | 3:00–3:55 | 5 |
| 7 | DEF-01 · defecto abierto | Franco | 3:55–5:10 | 6 |
| 8 | Frontera de stock y alcance del veredicto | Franco | 5:10–6:00 | 7 |
| 9 | DEF-04 · defecto abierto | Granit | 6:00–7:05 | 8 |
| 10 | Los nueve bloqueos tienen causas distintas | Granit | 7:05–8:00 | 9 |
| 11 | Cómo se leen estos números *(criterios y denominadores)* | Granit | 8:00–8:25 | 10 (1ª parte) |
| 12 | Resultados de los 14 casos de prioridad Alta | Granit | 8:25–9:00 | 10 (2ª parte) |
| 13 | Defectos, observaciones y ciclo de vida *(diagrama)* | Granit | 9:00–9:45 | 11 |
| 14 | Automatización para el Proyecto 2 | Granit | 9:45–10:40 | 12 |
| 15 | Condiciones para continuar | Granit | 10:40–11:25 | 13 |
| 16 | Conclusión | Granit | 11:25–12:00 | 14 |
| 17 | Preguntas | ambos | fuera de los 12 min | cierre |

> **Responsables según el guion fuente:** Franco cubre las diapositivas 1 a 7 del guion (láminas 1 a 8 del
> archivo, 0:00–6:00); Granit cubre las diapositivas 8 a 14 (láminas 9 a 16, 6:00–12:00). Las diapositivas 3
> y 10 del guion se presentan divididas en dos láminas cada una, para que la trazabilidad tenga su propio
> diagrama y para que **los criterios de salida y los denominadores aparezcan antes que cualquier métrica**.

---
---

# PARTE A · FRANCO — láminas 1 a 8 (0:00 – 6:00)

## Lámina 1 · Portada — Pruebas de software en OpenCart
**Franco · 25 s · 0:00–0:25** · *(Diapositiva 1 del guion fuente)*

**En pantalla:** fondo tinta. Distintivo «GRUPO 5» y el curso CS5383. Título *Pruebas de software en
OpenCart*. Debajo: Proyecto 1 · Caso 3 · Sistema bajo prueba: OpenCart Demo 4.0.2.3. Equipo: Franco Roque
Castillo · Granit Espinoza Salazar. Fecha 25/09/2026.

**Texto a decir:**

🗣 "Imaginen que administran una tienda en línea. Va a empezar la campaña más fuerte del año y llegan quejas de
clientes: alguien compró un producto que ya no estaba en almacén, y a alguien un descuento no se le aplicó. No
saben si son casos aislados o la punta de algo peor."

"Somos Franco Roque Castillo y Granit Espinoza Salazar, del Grupo 5. Esa tienda existe, corre sobre OpenCart, y
fue nuestro Caso 3. Entramos como equipo de pruebas antes de la campaña para responder una sola pregunta:
**¿esta tienda puede vender sin fallar?**"

🎯 "Evaluamos el flujo comercial y su relación con el panel administrativo. Vamos a explicar cómo priorizamos, qué
evidencia obtuvimos y qué impide recomendar el sistema para producción."

*No adelantes el hallazgo. Que se queden con la pregunta.*

---

## Lámina 2 · Alcance y planificación
**Franco · 45 s · 0:25–1:10** · *(Diapositiva 2 del guion fuente)*

**En pantalla:** tres tarjetas — *Dentro del alcance* (8 funcionalidades · 3 requisitos no funcionales · nivel
de sistema), *Diseño de pruebas* (18 casos · 11 requisitos · 26 condiciones), *Fuera del alcance* (pagos reales
· pruebas de carga · modificación de código). Banda inferior con el distintivo «REGLA DE EJECUCIÓN» y la
estimación de 24 horas.

**Texto a decir:**

🗣 "Una tienda tiene dos caras: la que ve el cliente —catálogo, carrito, pago— y la que ve el equipo de
operaciones, un panel interno donde se cargan productos, se ajusta el stock y se revisan pedidos. Las dos tienen
que contar la misma verdad. Cuando no coinciden, el cliente compra humo. Probamos las dos."

🎯 "El alcance integra ocho funcionalidades y tres requisitos no funcionales. Diseñamos **18 casos** para 11
requisitos y 26 condiciones. El nivel principal es **sistema**, sobre el demo desplegado; la integración se observa
desde la interfaz, sin afirmar cobertura de APIs ni de código."

🎯 "Estimamos 24 horas entre ambos, con reserva por bloqueos. Antes de cada caso verificamos acceso, datos y
permisos: si falta una precondición, **suspendemos ese caso y seguimos con los independientes**. Excluimos pagos
reales, pruebas de carga y modificación de código."

---

## Lámina 3 · Priorización y riesgo
**Franco · 30 s · 1:10–1:40** · *(Diapositiva 3 del guion fuente, primera parte)*

**En pantalla:** matriz 3×3 de probabilidad × impacto con la celda 9 destacada; tarjeta «R03 · Riesgo monetario
— 3 × 3 = 9 → prioridad Alta»; distintivos *Dinero · Inventario · Descuentos · Compra*; pie con 14 casos Alta y
4 Media.

**Texto a decir:**

🗣 "No se puede probar todo, así que hay que decidir por dónde empezar. Nosotros priorizamos donde el negocio
sangra: **el dinero, el inventario, los descuentos y la compra**."

🎯 "Combinamos probabilidad e impacto en una escala de uno a tres; de seis a nueve es prioridad Alta. Al riesgo
monetario R03 le asignamos tres por tres: nueve."

*Enlace a la lámina siguiente:* 🗣 "Y cuando reportas algo, lo primero que te preguntan es: ¿de dónde salió esto?"

---

## Lámina 4 · Trazabilidad de cuatro eslabones *(diagrama)*
**Franco · 25 s · 1:40–2:05** · *(Diapositiva 3 del guion fuente, segunda parte)*

**En pantalla:** diagrama de cuatro cajas unidas por flechas bidireccionales — **Requisito** (recalcular el total
al cambiar la cantidad) ↔ **Caso** (CP-CAR-01 · iPod Nano, 1 → 2 unidades) ↔ **Ejecución** (25/09/2026 · Falló) ↔
**Defecto** (DEF-01 · Abierto). Banda ámbar con la advertencia.

**Texto a decir:**

🗣 "Y cuando reportas algo, lo primero que te preguntan es: ¿de dónde salió esto? Si no puedes responder, tu
hallazgo es una anécdota."

🎯 "Por eso mostramos la cadena completa: el requisito pide recalcular el total, la condición exige coherencia
monetaria, y el caso cambia un iPod Nano de una a dos unidades. Ese caso originó **DEF-01**. La cadena permite
justificar la prioridad y volver a la evidencia."

▶ **"Y una advertencia sobre nuestra propia tabla: cubrir un requisito en diseño no significa que haya pasado."**

---

## Lámina 5 · Técnicas de caja negra
**Franco · 55 s · 2:05–3:00** · *(Diapositiva 4 del guion fuente)*

**En pantalla:** tabla de cinco filas — técnica y dónde se aplicó. Banda inferior con el distintivo «ALCANCE».

**Texto a decir:**

🗣 "Un formulario admite infinitas combinaciones: probarlas todas tomaría años. Las técnicas son formas de elegir
**pocos casos que representen muchos**. Se los traduzco:"

- 🗣 "Si un campo acepta infinitos valores, los agrupo en familias que el sistema debería tratar igual." 🎯 **Partición de equivalencia**: opciones presentes y ausentes.
- 🗣 "Si el requisito habla de un tope, el riesgo está pegado al borde, no en el centro." 🎯 **Valores límite**: cero y uno, y el stock disponible frente a una unidad más.
- 🗣 "Si el resultado depende de varias condiciones a la vez, armo la tabla de todas las combinaciones." 🎯 **Tabla de decisión**: vigencia, elegibilidad y repetición del cupón.
- 🗣 "Si el error aparece al repetir una acción —el famoso doble clic en Comprar— hay que modelar los estados." 🎯 **Transición de estados**.
- 🗣 "Y si solo aparece recorriendo todo de punta a punta, se prueba el recorrido completo." 🎯 **Casos de uso**: la compra y su consulta administrativa.

▶ **"Las técnicas justifican el diseño. Como varias pruebas quedaron bloqueadas, no afirmamos que todas estas reglas se hayan verificado."**

---

## Lámina 6 · Catálogo y opciones de producto
**Franco · 55 s · 3:00–3:55** · *(Diapositiva 5 del guion fuente)*

**En pantalla:** cuatro tarjetas con su veredicto escrito y en color — **Pasó** CP-CAT-02, **Pasó** CP-PRO-01,
**Bloqueado** CP-PRO-02, **Bloqueado** CP-CUP-01 / CP-CUP-02. Banda inferior con la regla de agregación.

**Texto a decir:**

🗣 "Empiezo por lo que **sí funcionó**, porque también es un resultado."

🎯 "El orden por precio pasó en ambos sentidos sobre el mismo conjunto de 12 productos: ascendente de 98 a 1202 y
descendente en el orden inverso, sin perder ni duplicar elementos."

🎯 "En ficha de producto aislé la omisión de **una sola** opción obligatoria: Canon mostró *Select required!* y no
agregó el producto. El carrito quedó vacío. Es la validación funcionando como debe."

🗣 "Ahora lo que no pudimos comprobar, y es importante decirlo con precisión."

🎯 "El caso positivo —elegir todas las opciones y verificar el ajuste de precio— quedó **Bloqueado**: los tres
productos candidatos tenían opciones requeridas **sin valores seleccionables**. No se puede completar lo que no
ofrece alternativas."

🎯 "En cupones, los tres códigos leídos en el panel estaban **deshabilitados y vencidos**. Rechazamos correctamente
un código inexistente y uno vencido, pero eso no alcanza para aprobar un caso que además exige probar elegibilidad
y duplicación **con un cupón válido**."

▶ **"Dos variantes negativas correctas no aprueban un caso al que le falta la variante positiva obligatoria."**

---

## Lámina 7 · DEF-01 · defecto abierto
**Franco · 75 s · 3:55–5:10** · *(Diapositiva 6 del guion fuente)* — *el tramo que engancha a la sala*

**En pantalla:** título completo del defecto — **«[Carrito] El total de línea no coincide con el total a pagar al
aumentar la cantidad de una a dos unidades»**. Tres cifras grandes: **122** (precio unitario) · **242** (total de
línea mostrado, en rojo, *esperado 244*) · **244** (total a pagar mostrado). Debajo, en columnas separadas:
Severidad **Alta** | Prioridad propuesta **Alta** | Estado **Abierto · reproducido 25/09**.

**Texto a decir:**

🗣 "Esta es la primera cosa rara que encontramos."

"Agrego un producto de 122 dólares al carrito y subo la cantidad a dos. La pantalla me dice, en la línea del
producto, que eso cuesta **242 dólares**. Y unos centímetros más abajo, en el total a pagar, dice **244**."

*Pausa. Señala las dos cifras en la captura.*

▶ **"Dos números distintos para la misma compra, en la misma pantalla."**

🎯 "Con una unidad, precio y línea coincidían en 122. Con dos, el unitario se mantuvo en 122, la línea mostró 242 y
el total general 244. Bajo la misma base fiscal, la línea debía mostrar 244. La captura permite ver todos los
importes."

🎯 "Severidad y prioridad propuestas: **Altas**, por impacto monetario directo. Reproducido el 25 de septiembre."

▶ **"Una tasa fija como el Eco Tax podría intervenir, pero eso es una hipótesis: no inspeccionamos código ni confirmamos la causa raíz. Reportamos el comportamiento observable, no una causa que no probamos. El defecto permanece abierto."**

*Esa última frase es la que te separa de un reporte de aficionado.*

---

## Lámina 8 · Frontera de stock y alcance del veredicto
**Franco · 50 s · 5:10–6:00** · *(Diapositiva 7 del guion fuente)*

**En pantalla:** dos tarjetas, **147 unidades** (sin señal de insuficiencia) y **148 unidades** (marca de falta de
stock · el checkout devuelve al carrito). Tarjeta de cantidades no válidas: 0 · −1 · abc retiran la línea; 1.5 ·
vacío se normalizan a 1. Banda con el veredicto **Pasó** de CP-CAR-02 y su acotación. Pie con el cierre del bloque
de Franco.

**Texto a decir:**

🗣 "Probamos también qué pasa si alguien pide más unidades de las que hay."

🎯 "Con el stock observado de **147** unidades, esa cantidad no mostró señal de insuficiencia. Con **148** apareció
la marca de falta de stock y el intento de checkout devolvió al carrito. Cero, negativo y texto retiran la línea;
decimal y vacío se normalizan a uno, sin mensaje específico: lo registramos como observación de usabilidad."

▶ **"Y quiero acotar el alcance de este veredicto: CP-CAR-02 pasó para integridad de cantidades y frontera de stock. No demuestra que el cálculo monetario sea correcto —eso lo cubre CP-CAR-01, que falló— ni que se haya completado una compra."**

🎯 "Mis siete casos Alta cierran con **tres Pasó, un Falló y tres Bloqueados**."

🗣 **[TRANSICIÓN]** "Hasta aquí el cliente todavía no ha pagado. Granit tomó desde el momento en que decide pagar
hacia adelante, y ahí es donde esto se pone serio."

---
---

# PARTE B · GRANIT — láminas 9 a 16 (6:00 – 12:00)

## Lámina 9 · DEF-04 · defecto abierto
**Granit · 65 s · 6:00–7:05** · *(Diapositiva 8 del guion fuente)* — *el clímax*

**En pantalla:** título completo del defecto — **«[Checkout] No se ofrece método de pago aplicable en el recorrido
de invitado ensayado»**. Mensaje literal del sistema *«No Payment options are available»* y *Confirm Order queda
deshabilitado*. Tarjeta verde con lo que sí funcionó. En columnas separadas: Severidad **Crítica para este
recorrido** | Prioridad propuesta **Alta** | Estado **Abierto · causa en análisis**.

**Texto a decir:**

🗣 "Retomo donde lo dejó Franco: el cliente ya eligió, ya tiene su carrito, y va a pagar."

🎯 "El formulario se comportó bien en lo suyo: identificó el apellido vacío y guardó correctamente los datos del
invitado."

🗣 "Y entonces llego al último paso, el momento de pagar, y el sitio me dice que **no hay ningún método de pago
disponible**."

*Pausa. Deja que caiga.*

🎯 "El mensaje literal es *No Payment options are available*. La confirmación queda deshabilitada. **CP-CHK-01
falló**: severidad Crítica para este recorrido, prioridad propuesta Alta."

🗣 "Traducido al negocio: **en el recorrido que probamos, el cliente no puede pagar**. No es que se venda poco."

▶ **"Y aquí soy deliberadamente cuidadoso: vimos en el panel que Cash on Delivery figura habilitado para todas las zonas, pero esa captura no demuestra que se cumplan todas las reglas de aplicabilidad. Es una pista, no una causa confirmada. Nuestra conclusión se limita al recorrido y a los datos ensayados; la configuración debe investigarse."**

🎯 "Al no poder generar una orden propia, varios casos que dependen de ella no pudieron completarse."

---

## Lámina 10 · Los nueve bloqueos tienen causas distintas
**Granit · 55 s · 7:05–8:00** · *(Diapositiva 9 del guion fuente)*

**En pantalla:** distintivo **«BLOQUEADO ≠ FALLÓ»** con ambas definiciones y el contador **9 de 14**. Cuatro
tarjetas de causa: **4** sin orden propia · **3** datos del ambiente · **1** permisos · **1** sin instrumentación.
Banda con la decisión sobre los 1932 ms. Pie con el cierre del bloque de Granit.

**Texto a decir:**

🗣 "Quiero ser preciso con una palabra que la gente confunde."

▶ **"Un caso bloqueado no es un caso fallido. Fallido significa que el sistema se comportó distinto de lo esperado. Bloqueado significa que un impedimento impidió ejecutarlo. Por eso un bloqueado nunca entra en el denominador de la aprobación: no llegó a ejecutarse."**

🎯 "Y los nueve bloqueos no tienen la misma causa. **Cuatro dependen de tener una orden propia**: confirmación y
resumen, prevención de duplicados, consulta en pedidos y sincronización desde el sitio público. Todos quedaron
bloqueados tras la falta de pago."

🎯 "**Tres** vienen de los datos del ambiente, en el bloque de Franco: opciones requeridas sin valores
seleccionables y cupones no vigentes."

🎯 "**Uno** se bloqueó por permisos: al intentar guardar un cambio de stock, el panel respondió que el usuario no
tiene permiso para modificar productos."

🎯 "**Rendimiento** se bloqueó por falta de mediciones instrumentales verificables. Su protocolo exige 18 muestras,
separando navegación fría y cálida."

▶ **"Y lo digo explícitamente: teníamos una medición anterior de 1932 milisegundos y decidimos NO presentarla como aprobación, porque no identifica red, caché, versión de navegador ni el evento medido. Un número sin trazabilidad no es evidencia."**

🎯 "En mi bloque: **un fallo y seis bloqueos** entre los siete Alta. Compatibilidad, de prioridad Media, quedó
diseñada sin ejecución."

---

## Lámina 11 · Cómo se leen estos números *(criterios y denominadores)*
**Granit · 25 s · 8:00–8:25** · *(Diapositiva 10 del guion fuente, primera parte)*

**En pantalla:** tarjeta *Criterios de salida: qué decide* — «Los criterios de salida del plan, no el tablero» y
los cuatro ejes. Tarjeta *Denominadores declarados* — ejecución concluyente **5 / 14** sobre planificados Alta;
aprobación **3 / 5** sobre concluyentes; bloqueo **9 / 14** sobre planificados Alta. Banda tinta: **Registro ≠
ejecución. Ejecución ≠ aprobación.**

> **Esta lámina va deliberadamente ANTES de la de resultados:** los criterios y los denominadores se muestran
> antes que cualquier métrica o gráfico.

**Texto a decir:**

🗣 "Ahora los números. Y antes de darlos, cómo se leen, porque aquí hay una trampa clásica."

▶ **"Si yo les digo 'el 100 % de los casos Alta tiene registro', ustedes no pueden decidir nada: registro no es lo mismo que ejecución completa, y ejecución no es lo mismo que aprobación."**

🎯 "Lo que decide son los criterios de salida del plan, no el tablero: qué casos se ejecutaron, los criterios de
salida, los defectos abiertos y lo bloqueado o no ejecutado."

🎯 "Y cada tasa lleva su denominador declarado: la ejecución concluyente y el bloqueo se miden sobre los 14 casos
Alta planificados; la aprobación, sólo sobre los 5 concluyentes."

---

## Lámina 12 · Resultados de los 14 casos de prioridad Alta
**Granit · 35 s · 8:25–9:00** · *(Diapositiva 10 del guion fuente, segunda parte)*

**En pantalla:** tres veredictos, cada uno con su color y su palabra — **3 Pasó** (verde) · **2 Falló** (rojo) ·
**9 Bloqueado** (ámbar). Debajo, las tres tasas con su denominador en la misma lámina: **35.7 %** ejecución
concluyente (5 de 14 planificados Alta) · **60 %** aprobación (3 de 5 concluyentes) · **64.3 %** bloqueo (9 de 14
planificados Alta). Pie: 18 casos diseñados · 14 Alta · 4 Media.

**Texto a decir:**

🎯 "Diseñamos 18 casos: 14 Alta y cuatro Media. Los 14 Alta tienen registro, **incluidos los nueve bloqueados**. De
ellos, **tres pasaron y dos fallaron**."

🎯 "Por eso la ejecución con **veredicto concluyente** es cinco sobre catorce: **35.7 %**. La **aprobación** se
calcula sobre los concluyentes: tres sobre cinco, **60 %**. Y el **bloqueo** es nueve sobre catorce: **64.3 %**."

🗣 "En criollo: de todo lo que nos propusimos probar en serio, **casi dos tercios ni siquiera arrancó**. Y de lo
poco que sí llegó a un veredicto, la mitad larga pasó. Son dos preguntas distintas y por eso se miden contra
denominadores distintos."

🎯 "Los cuatro casos Media se diseñaron y no se ejecutaron en esta selección."

---

## Lámina 13 · Defectos, observaciones y ciclo de vida *(diagrama)*
**Granit · 45 s · 9:00–9:45** · *(Diapositiva 11 del guion fuente)*

**En pantalla:** tabla con **Severidad** y **Prioridad propuesta** en columnas separadas — DEF-01 (Alta / Alta /
Abierto · reproducido), DEF-04 (Crítica / Alta / Abierto · causa en análisis) y las 3 observaciones (— / — /
Registradas con ficha). Debajo, el **ciclo de vida del defecto**: Nuevo → En análisis → Asignado → En corrección →
Listo para reprueba → Cerrado, con las ramas *Rechazado · Duplicado · Diferido* y *Reabierto → vuelve a En
corrección*. Pie: prueba de confirmación y pruebas de regresión.

**Texto a decir:**

🗣 "No todo lo que estorba es un defecto del programa. Esa distinción es la que más nos costó y la que más
defendemos."

🎯 "**DEF-01** sigue abierto y reproducido. **DEF-04** está abierto, con causa o configuración en análisis. En
cambio, las opciones sin valores seleccionables, los cupones no vigentes y la normalización silenciosa de
cantidades quedaron como **observaciones**, cada una con su ficha."

▶ **"No convertimos cada impedimento en un defecto de código: eso inflaría el conteo y nos haría perder credibilidad."**

🎯 "Sobre severidad y prioridad: la **severidad** estima el impacto técnico y funcional, la propone quien prueba; la
**prioridad** propone la urgencia de atención. La escribimos como *propuesta* porque el negocio no participó en esta
evaluación, y no le atribuimos una decisión que no tomó."

🎯 "Para cerrar un defecto hará falta una corrección y una nueva ejecución satisfactoria: la **prueba de
confirmación** repite el caso que falló; las **pruebas de regresión** revisan que la corrección no haya roto
funciones relacionadas."

---

## Lámina 14 · Automatización para el Proyecto 2
**Granit · 55 s · 9:45–10:40** · *(Diapositiva 12 del guion fuente)*

**En pantalla:** tres tarjetas numeradas — **1** CP-CAR-01, **2** CP-CAT-02, **3** CP-PRO-01. Tarjeta *Sólo con
ambiente preparado* (CP-CAR-02, cupones, pedidos) y tarjeta *Se queda manual*. Banda de cierre: es una
recomendación, no una suite implementada.

**Texto a decir:**

🗣 "Nos toca recomendar qué automatizar. Y la respuesta no es 'todo'."

🎯 "**Primero CP-CAR-01**, por el riesgo monetario: usando cálculos decimales y comparando la misma base fiscal. Es
donde está el dinero y ya sabemos que falla."

🎯 "**CP-CAT-02** tiene una comparación de 12 precios repetible y determinista. **CP-PRO-01** ofrece una validación
observable y estable, previendo variación de idioma."

🎯 "**CP-CAR-02** solo cuando podamos fijar y restaurar el stock: 147 no será estable en un demo compartido. Para
cupones necesitamos datos vigentes y restaurables. Para pedidos, pago de prueba y permisos."

▶ **"Automatizar un flujo que no se ha logrado completar ni una sola vez a mano sería escribir código contra un comportamiento que nadie ha observado: esas pruebas fallarían por el bloqueo conocido en lugar de detectar defectos nuevos."**

▶ **"Y aclaramos que esto es una recomendación de automatización futura, no una suite ya implementada."**

🎯 "La exploración de configuraciones ambiguas y la claridad de los mensajes siguen siendo manuales: requieren
interpretar intención."

---

## Lámina 15 · Condiciones para continuar
**Granit · 45 s · 10:40–11:25** · *(Diapositiva 13 del guion fuente)*

**En pantalla:** tres pasos numerados — **01** habilitar un ambiente controlado, **02** reejecutar y repetir, **03**
regresión y recálculo. Banda con el distintivo «GESTIÓN DE LA CONFIGURACIÓN» y la advertencia final.

**Texto a decir:**

🗣 "¿Qué haría falta para poder responder lo que hoy no podemos responder?"

🎯 "El siguiente ciclo empieza por **habilitar un ambiente controlado**: productos con opciones completas, un cupón
vigente, un método de pago de prueba, permisos de escritura y medición exportable."

🎯 "Después reejecutamos los **nueve bloqueados** y repetimos los casos fallidos cuando exista corrección.
Conservamos la evidencia anterior y registramos cada nueva corrida. Luego aplicamos **regresión** en carrito,
checkout y pedidos, y recalculamos los indicadores."

▶ **"Esa secuencia evita algo que pasa más de lo que parece: que un cambio en los datos del demo se confunda con una corrección del sistema."**

---

## Lámina 16 · Conclusión
**Granit · 35 s · 11:25–12:00** · *(Diapositiva 14 del guion fuente)*

**En pantalla:** fondo tinta. Tres cifras: **18** casos diseñados · **9 de 14** casos Alta Bloqueados · **2**
defectos abiertos. Distintivo «ESTADO FRENTE A LOS CRITERIOS DE SALIDA» y la conclusión: *Los resultados no son
suficientes para recomendar el sistema para producción.*

**Texto a decir:**

🗣 "Cierro con lo que dejamos, que no es una lista de errores ajenos."

🎯 "Un proceso trazable con 18 casos diseñados y resultado documentado para **todos** los de prioridad Alta: tres
pasaron, dos fallaron y nueve quedaron bloqueados, cada uno con su causa registrada."

▶ **"Los fallos monetarios y de checkout, junto con los riesgos que siguen sin verificar, impiden recomendar el sistema para producción. El informe deja claro qué volver a probar y bajo qué condiciones."**

🗣 "Y lo que nos llevamos como equipo: el ambiente donde pruebas es parte del trabajo, no un supuesto. La diferencia
entre 'no se pudo probar por el ambiente' y 'no se pudo probar por un defecto' cambia la conclusión del informe. Y
la mayoría de nuestras respuestas aparecieron **comparando las dos caras del sistema**, no mirando solo la tienda."

"Gracias. Estamos listos para sus preguntas."

*Las preguntas quedan fuera de los doce minutos acordados.*

---

## Lámina 17 · Preguntas
**Franco y Granit · fuera de los 12 minutos acordados**

**En pantalla:** fondo tinta. «Preguntas», los dos nombres y los tres anclajes: *Contra qué medimos · Qué
encontramos · Qué decidimos*. Esta lámina queda proyectada durante todo el turno de preguntas.

---
---

# BANCO DE RESPUESTAS

### 1. "El tablero dice que el 100 % de los casos Alta tiene registro. ¿Pasa a producción?" *(la pregunta trampa)*
▶ "Depende de cuatro cosas: **qué casos se ejecutaron**, **los criterios de salida**, **los defectos abiertos** y
**lo bloqueado o no ejecutado**. Registro no es ejecución: de 14 Alta, solo 5 llegaron a veredicto concluyente, hay
dos defectos abiertos —uno crítico para el recorrido probado— y 9 casos bloqueados. No pasa."

### 2. "¿Por qué 60 % de aprobación y no 3 de 14?"
"Porque la aprobación mide la calidad de **lo que efectivamente se probó**: tres aprobados entre cinco
concluyentes. Los nueve bloqueados se reportan aparte, como tasa de bloqueo sobre los 14 planificados. Mezclarlos
en un solo porcentaje escondería que casi dos tercios del alcance nunca arrancó."

### 3. "¿Por qué el bloqueo se mide sobre los planificados?"
▶ "Porque los casos bloqueados representan una porción del alcance total que no pudo ingresar a ejecución por un
impedimento externo. Medirlo sobre lo ejecutado distorsionaría la métrica real de avance."

### 4. "¿Por qué cupones está bloqueado si probaron dos variantes?"
"Pasaron las dos variantes negativas —código inexistente y vencido, ambos rechazados con aviso y sin cambiar el
total— pero faltaron las obligatorias que exigen un **cupón válido**: elegibilidad, duplicación y revalidación. Un
caso no se aprueba por sus variantes fáciles."

### 5. "¿Por qué rendimiento no está aprobado si tenían una medición?"
"Porque esa medición no identifica red, caché, versión de navegador ni el evento medido, y el protocolo del caso
exige 18 muestras separando navegación fría y cálida. Teníamos el número y decidimos no presentarlo: **un dato sin
trazabilidad no es evidencia**."

### 6. "¿El Eco Tax es la causa de DEF-01?"
"Es una hipótesis razonable, no una causa confirmada. No inspeccionamos código. Reportamos el comportamiento
observable y reproducible; atribuir una causa que no probamos sería inventar."

### 7. "¿Qué demuestra la prueba de stock?"
"Demuestra el comportamiento en la frontera: con 147 no hay señal de insuficiencia, con 148 aparece la marca y el
checkout devuelve al carrito. No demuestra que el cálculo monetario sea correcto ni que se completara una compra."

### 8. "Diferencia entre severidad y prioridad."
▶ "La severidad la evaluamos como QA según el impacto técnico y funcional sobre el requisito. La prioridad es la
urgencia de atención, y en condiciones normales la define el Product Owner o el negocio según lanzamiento, cliente
e impacto financiero." — "Es la sala de emergencias: la severidad es qué tan grave es la lesión; la prioridad es a
quién atiendes primero. Son ejes independientes y por eso van en campos separados. En nuestro informe la prioridad
figura como **propuesta**, porque el negocio no participó."

### 9. "¿Qué escala de severidad usaron?"
"Crítica, Alta, Media, Baja, declarada en el informe. El CTFL no impone una escala; cada organización define la
suya. Lo esencial es usar la misma con el mismo significado en todos los defectos."

### 10. "¿Usaron IA?"
▶ "La usamos como copiloto para acelerar formato y estructura, pero la lógica de caja negra, la contextualización y
la decisión final las validamos y asumimos nosotros como equipo." — *Si insiste, demuéstralo*: explica por qué
CP-CUP-02 usa tabla de decisión y no partición de equivalencia, o por qué DEF-04 se reporta como fallo del recorrido
y no como causa de configuración confirmada.

### 11. "¿Por qué no dicen GO o NO GO?"
"Porque la conclusión correcta se expresa como **estado frente a los criterios de salida**: con dos defectos
abiertos y 9 de 14 casos Alta bloqueados, los resultados no son suficientes para recomendar el sistema para
producción. La etiqueta sola no dice contra qué se midió."

### 12. "¿Qué harán cuando corrijan DEF-01 o DEF-04?"
"El defecto pasa a **Listo para reprueba** y se ejecuta una **prueba de confirmación**: se repite exactamente el
caso que falló. Después, **pruebas de regresión** sobre lo que comparte precondiciones —carrito, checkout y
pedidos— para verificar que la corrección no rompió otra cosa. Son actividades distintas."

### 13. "¿Por qué CP-ADM-01 está bloqueado y no fallido?"
"Porque el sistema nunca llegó a comportarse: el panel rechazó el guardado por permisos. No obtuvimos evidencia
sobre el requisito, así que declararlo fallido sería inventar un resultado. La captura demuestra el bloqueo, no un
cambio persistido."

### 14. "¿Qué herramienta usaron?"
"**Qase**: organiza, conecta e informa, y mantiene la cadena requisito ↔ caso ↔ ejecución ↔ defecto en un solo
lugar. Con la advertencia de que **la herramienta no prueba por ti**, y ninguna arregla un proceso mal definido: la
elegimos por integración y trazabilidad."

### 15. "¿Y la Gestión de la Configuración?"
"Versionado del documento con autor, fecha y motivo del cambio; convención de nombres de evidencia con caso, paso y
fecha; inventario de evidencias con SHA-256; y repositorio remoto con todo el testware. La fecha es obligatoria
porque el demo es compartido y volátil."

### 16. "¿Qué riesgos quedan sin cubrir?"
"Los declaramos como riesgo residual: confirmación de pedidos, prevención de duplicados, consistencia sitio–panel,
el caso positivo de opciones, el caso positivo de cupón y el rendimiento. No los presentamos como cobertura
lograda."

### 17. "¿Por qué solo 18 casos?"
"18 diseñados para 11 requisitos y 26 condiciones, 14 de prioridad Alta. El enunciado pide ejecutar los Alta, y de
esos 14 solo 5 llegaron a veredicto concluyente. El resto está bloqueado con causa registrada, no omitido."

---

# LO QUE NO DEBEMOS DECIR

| No digas | Di |
|---|---|
| "Re-testing" | "Prueba de confirmación" |
| "Métricas de vanidad" | "Métricas engañosas" |
| "GO" / "NO GO" | "Los resultados no son suficientes para recomendar el sistema para producción" |
| "Versionamiento" | "Gestión de la Configuración" |
| "Densidad de defectos" | *(no la uses)* |
| "El Eco Tax causa el error" | "Es una hipótesis; no confirmamos causa raíz" |
| "El demo estaba caído, por eso no probamos" | "Se registró como Bloqueado, con el texto literal del sistema y su fecha" |
| "Aprobamos el 60 %" | "60 % entre los concluyentes; 64.3 % del alcance Alta quedó bloqueado" |
| "Tenemos automatización" | "Es una recomendación de automatización para el Proyecto 2" |
| "Falla el pago" | "[Checkout] No se ofrece método de pago aplicable en el recorrido de invitado ensayado" |

> Ninguno de los términos de la columna izquierda aparece en el archivo `.pptx`: la tabla vive aquí, en el guion,
> únicamente como recordatorio de lo que no se dice en voz alta.

---

# SI TE QUEDAS EN BLANCO
Vuelve a estos tres pilares, en orden:
1. **Contra qué medimos** — riesgo priorizado y criterios de salida.
2. **Qué encontramos** — DEF-01, DEF-04, y su cadena de trazabilidad.
3. **Qué decidimos** — no es recomendable para producción, y el número que lo decide es el bloqueo, no la aprobación.

// =====================================================================
//  VARIABLES EDITABLES  <-- cambiar aquí antes de entregar
// =====================================================================
#let GRUPO = "X"        // <-- cambiar por el número de grupo
#let FECHA = "24 de septiembre de 2026"
// =====================================================================

#set document(
  title: "Proyecto 1 — Planificación, Análisis y Diseño de Pruebas",
  author: ("Granit Espinoza Salazar", "Franco Roque Castillo"),
)

#set text(font: "Times New Roman", size: 10pt, lang: "es", hyphenate: true)
#set par(justify: true, leading: 0.62em, spacing: 0.9em)

#set page(
  paper: "a4",
  margin: 2.5cm,
  header: context {
    set text(size: 8pt, fill: luma(90))
    grid(
      columns: (1fr, auto),
      align: (left, right),
      [Proyecto 1 · Pruebas del Caso 3 — OpenCart],
      [CS5383 · Bloque del Integrante 2],
    )
    v(-0.35em)
    line(length: 100%, stroke: 0.4pt + luma(180))
  },
  footer: context {
    set text(size: 8pt, fill: luma(90))
    line(length: 100%, stroke: 0.4pt + luma(180))
    v(-0.35em)
    grid(
      columns: (1fr, auto, 1fr),
      align: (left, center, right),
      [Grupo #GRUPO],
      [Página #counter(page).display("1") de #counter(page).final().first()],
      [#FECHA],
    )
  },
)

#set heading(numbering: "1.1.")
#show heading.where(level: 1): it => {
  block(above: 1.4em, below: 0.9em)[#text(size: 15pt, fill: rgb("#13334f"))[#it]]
}
#show heading.where(level: 2): it => {
  block(above: 1.1em, below: 0.6em)[#text(size: 12pt, fill: rgb("#1c4f74"))[#it]]
}
#show heading.where(level: 3): it => {
  block(above: 0.9em, below: 0.5em)[#text(size: 10.5pt, fill: rgb("#24618c"))[#it]]
}

#set table(
  stroke: 0.45pt + luma(165),
  fill: (x, y) => if y == 0 { luma(226) },
  inset: 4.5pt,
)
#show table.cell.where(y: 0): set text(weight: "bold", hyphenate: false)
#show table: set par(justify: false, leading: 0.55em)
#set figure(gap: 0.7em)
#show figure.caption: set text(size: 8.5pt)

// ---------------------------------------------------------------------
//  FUNCIONES AUXILIARES
// ---------------------------------------------------------------------

// Marca visible y resaltada para los pendientes heredados de las fuentes.
#let pendiente(txt) = box(
  fill: rgb("#ffe08a"),
  stroke: 0.5pt + rgb("#b07000"),
  radius: 2pt,
  outset: (y: 2.5pt),
  inset: (x: 3pt),
)[#text(fill: rgb("#7a3e00"), weight: "bold")[\[PENDIENTE: #txt\]]]

// Marcador para las evidencias gráficas todavía no capturadas.
#let evidencia-pendiente(id, desc) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  stroke: (dash: "dashed"),
  fill: luma(245),
)[*EVIDENCIA PENDIENTE #id* — #desc]

// Cita literal de un mensaje del sistema (texto conservado sin alterar).
#let lit(m) = [“#m”]

// Caja de nota metodológica.
#let nota(body) = block(
  width: 100%,
  inset: 8pt,
  radius: 3pt,
  fill: rgb("#eef4fa"),
  stroke: (left: 2.5pt + rgb("#1c4f74")),
)[#body]

// Texto pequeño para tablas anchas.
#let chico(body) = text(size: 7.6pt)[#body]
#let mini(body) = text(size: 6.8pt)[#body]

// Ficha de caso de prueba: etiqueta en negrita + contenido.
#let campo(etiqueta, contenido) = grid(
  columns: (4.0cm, 1fr),
  gutter: 6pt,
  [#text(weight: "bold")[#etiqueta]], [#contenido],
)

// ---------------------------------------------------------------------
//  PALETA Y BADGES DE VEREDICTO
//  El color NUNCA es el único indicador: el texto del veredicto viaja
//  siempre dentro del badge, de modo que el significado se conserva en
//  impresión monocroma o para lectores con visión de color reducida.
// ---------------------------------------------------------------------

#let C-PASO   = (fondo: rgb("#dff0dd"), borde: rgb("#1f6b32"), texto: rgb("#145225"))
#let C-FALLO  = (fondo: rgb("#fadfdf"), borde: rgb("#9e2020"), texto: rgb("#7d1717"))
#let C-BLOQ   = (fondo: rgb("#fdecc8"), borde: rgb("#9a6400"), texto: rgb("#6f4800"))
#let C-PARC   = (fondo: rgb("#e6e6e6"), borde: rgb("#5a5e62"), texto: rgb("#3c4043"))

// Clasifica una etiqueta de veredicto en una de las cuatro familias.
#let clase-veredicto(etiqueta) = {
  let e = lower(etiqueta)
  if e.starts-with("pasó") or e.starts-with("paso") or e.starts-with("aprob") { C-PASO }
  else if e.starts-with("falló") or e.starts-with("fallo") { C-FALLO }
  else if e.starts-with("bloqueado") { C-BLOQ }
  else { C-PARC }
}

// Badge de veredicto: color de familia + texto siempre visible.
#let veredicto(etiqueta, detalle: none) = {
  let c = clase-veredicto(etiqueta)
  box(
    fill: c.fondo,
    stroke: 0.6pt + c.borde,
    radius: 2.5pt,
    outset: (y: 2.2pt),
    inset: (x: 3.5pt),
  )[#text(fill: c.texto, weight: "bold", size: 0.95em, hyphenate: false)[#etiqueta]]
  if detalle != none [ #text(size: 0.9em)[#detalle]]
}

// Leyenda de la codificación de veredictos.
#let leyenda-veredictos = block(width: 100%)[
  #set text(size: 8.5pt)
  #grid(
    columns: (auto, auto, auto, auto),
    column-gutter: 10pt,
    veredicto("Pasó"), veredicto("Falló"), veredicto("Bloqueado"), veredicto("Parcial"),
  )
]

// ---------------------------------------------------------------------
//  GRÁFICOS NATIVOS (rect / grid / stack) — sin paquetes externos
// ---------------------------------------------------------------------

// Gráfico de barras verticales. `datos` es una lista de diccionarios
// (etiqueta, valor, color).
#let grafico-barras(datos, alto: 3.1cm, ancho-barra: 1.35cm, unidad: "") = {
  let maxv = calc.max(..datos.map(d => d.valor))
  let n = datos.len()
  block(width: 100%, breakable: false)[
    #grid(
      columns: (1fr,) * n,
      align: center + bottom,
      row-gutter: 3pt,
      ..datos.map(d => text(size: 9.5pt, weight: "bold", fill: d.color.texto)[#d.valor#unidad]),
      ..datos.map(d => box(
        width: ancho-barra,
        height: alto * d.valor / maxv,
        fill: d.color.fondo,
        stroke: 0.7pt + d.color.borde,
        radius: (top: 2.5pt),
      )),
    )
    #v(-0.35em)
    #line(length: 100%, stroke: 0.8pt + luma(110))
    #v(-0.2em)
    #grid(
      columns: (1fr,) * n,
      align: center + top,
      ..datos.map(d => text(size: 8.2pt, hyphenate: false)[#d.etiqueta]),
    )
  ]
}

// ---------------------------------------------------------------------
//  DIAGRAMAS NATIVOS: cajas y flechas
// ---------------------------------------------------------------------

// Caja de diagrama.
#let caja(cuerpo, fondo: rgb("#eef4fa"), borde: rgb("#1c4f74"), tam: 7.8pt) = block(
  width: 100%,
  inset: (x: 4pt, y: 5pt),
  radius: 3pt,
  fill: fondo,
  stroke: 0.7pt + borde,
)[#align(center)[#text(size: tam, hyphenate: false)[#cuerpo]]]

// Flecha horizontal y vertical para encadenar cajas.
#let flecha-h = align(horizon + center)[#text(size: 11pt, fill: rgb("#1c4f74"))[#sym.arrow.r]]
#let flecha-v = align(center)[#text(size: 11pt, fill: rgb("#1c4f74"))[#sym.arrow.b]]

// =====================================================================
//  PORTADA
// =====================================================================
#page(header: none, footer: none, numbering: none)[
  #align(center)[
    #v(1.6cm)
    #text(size: 11pt, fill: luma(80))[CS5383 — Verificación y Pruebas de Software]
    #v(0.2cm)
    #line(length: 45%, stroke: 0.8pt + rgb("#13334f"))
    #v(0.9cm)
    #text(size: 22pt, weight: "bold", fill: rgb("#13334f"))[
      Proyecto 1 — Planificación, Análisis y Diseño de Pruebas
    ]
    #v(0.7cm)
    #text(size: 13pt)[Caso 3 — E-commerce con panel administrativo (OpenCart)]
    #v(0.3cm)
    #line(length: 45%, stroke: 0.8pt + rgb("#13334f"))
    #v(1.1cm)

    #block(width: 85%)[
      #set align(left)
      #table(
        columns: (4.6cm, 1fr),
        stroke: none,
        fill: none,
        inset: 5pt,
        [*Curso*], [CS5383 Verificación y Pruebas de Software],
        [*Caso asignado*], [Caso 3 — E-commerce con panel administrativo (OpenCart)],
        [*Sistema bajo prueba*], [OpenCart Demo 4.0.2.3 — #link("https://demo.opencart.com/")[https://demo.opencart.com/] \
          Panel administrativo: `https://demo.opencart.com/TlbeVW/`],
        [*Integrantes*], [Granit Espinoza Salazar (Integrante 2) \ Franco Roque Castillo (Integrante 1)],
        [*Grupo*], [Grupo #GRUPO],
        [*Fecha*], [#FECHA],
      )
    ]

    #v(1.1cm)
    #block(width: 88%, inset: 11pt, radius: 4pt, fill: rgb("#eef4fa"),
           stroke: (left: 2.5pt + rgb("#1c4f74")))[
      #set align(left)
      #text(size: 9.5pt)[
        *Nota de alcance.* Este informe documenta el bloque del *Integrante 2*: checkout (FUN-05),
        confirmación del pedido (FUN-06), administración de productos y stock (FUN-07), gestión
        administrativa de pedidos (FUN-08), los requisitos no funcionales RNF-01 a RNF-03, la ejecución
        manual, el reporte de hallazgos y el cierre. El bloque del *Integrante 1* —catálogo, ficha de
        producto, carrito y cupones— se integra por separado y no forma parte de este documento.
      ]
    ]
    #v(1fr)
    #text(size: 9pt, fill: luma(90))[Corte de la información: 24-09-2026]
  ]
]

// =====================================================================
//  CONTROL DOCUMENTAL
// =====================================================================
#heading(level: 1, numbering: none)[Control documental]

#figure(
  table(
    columns: (2.2cm, 2.6cm, 1fr, 4.6cm),
    table.header([Versión], [Fecha], [Autor], [Estado]),
    [v1.0], [24-09-2026], [Granit Espinoza Salazar — Integrante 2, Analista de QA del bloque transaccional y administrativo], [Emitido — línea base de entrega con corte de información al 24-09-2026],
    [v1.1], [24-09-2026], [Revisión asistida; validación final a cargo del responsable], [Borrador revisado con Clase 7, capturas reales y corrección de métricas; pendiente de aprobación humana],
  ),
  caption: [Control de versiones del documento.],
)

Este informe se rige por la *Gestión de la Configuración del Testware* declarada en la planificación
(§2.10): identificador `vMAJOR.MINOR` con autor, fecha y motivo del cambio; no se edita sobre una versión
ya publicada; toda modificación posterior a la línea base se registra con caso afectado, motivo,
responsable y fecha, e incrementa la versión.

#pagebreak()

// =====================================================================
//  RESUMEN EJECUTIVO
// =====================================================================
#heading(level: 1, numbering: none)[Resumen ejecutivo]

*Contexto.* El Caso 3 es un e-commerce con panel administrativo sobre *OpenCart Demo 4.0.2.3*
(`demo.opencart.com`, panel en `/TlbeVW/`). Este informe cubre el bloque del *Integrante 2*: checkout
(FUN-05), confirmación del pedido (FUN-06), productos y stock desde el panel (FUN-07), gestión
administrativa de pedidos (FUN-08) y los requisitos no funcionales RNF-01 a RNF-03. Corte de la
información: 24-09-2026.

*Alcance del bloque.* De 24 requisitos verificables se derivaron *33 condiciones de prueba* y se
diseñaron *8 casos*, los 8 planificados para ejecución. La cobertura de condiciones por caso diseñado es
de *23 de 33 (70 %)*; los huecos son conscientes y se concentran en lo que exige escritura en el panel.

*Hallazgo crítico.* *DEF-04* — el sitio público no ofrece *ningún* método de pago pese a que el panel
administrativo tiene *Cash On Delivery habilitado para todas las zonas geográficas* (Geo Zone = All
Zones). El checkout se detiene con #lit[No Payment options are available. Please contact us for
assistance!] y no se renderiza la sección #lit[Shipping Method]. *Impacto de negocio:* el recorrido de compra probado no puede completarse. No se han probado todas las combinaciones de cliente, producto y país; la causa raíz permanece en investigación. Severidad *Crítica*, prioridad *Alta*, estado *Nuevo*. DEF-04 bloquea por sí solo tres
casos de alta prioridad (CP-CON-01, CP-CON-02, CP-PED-01) y hace fallar a CP-CHK-01. Se documentan además
DEF-01 y DEF-02 (severidad Alta) y DEF-03 (Media).

*Criterios previos a la decisión (Clase 7, diapositiva 10).* CS1: 100 % de casos Alta ejecutados; CS2: aprobación ≥ 90 % de ejecutados; CS3: 0 críticos abiertos; CS4: máximo 2 altos abiertos. Se adoptan para este bloque los umbrales del ejercicio de clase.

*Métricas del cierre* (denominadores declarados en §8.1, sin mezclar):

#block(inset: (left: 0.6em))[
  #grid(
    columns: (auto, auto, 1fr),
    column-gutter: 8pt,
    row-gutter: 3pt,
    [*Tasa de ejecución*], [*25 %*], [2 de 8 casos planificados ejecutados por completo],
    [*Tasa de aprobación*], [*50 %*], [1 aprobado sobre 2 ejecutados],
    [*Tasa de bloqueo*], [*62.5 %*], [5 de 8 casos planificados: 3 por defecto del producto (DEF-04) y 2 por restricción de permisos del ambiente],
  )
]

*Estado frente a los criterios de salida.* *CS1 no se cumple* (2 de 7 casos de alta prioridad
ejecutados, frente al 100 % exigido). *CS2 no se cumple* (50 % de aprobación frente al umbral de 90 %).
*CS3 no se cumple* (1 defecto crítico abierto, DEF-04, frente a un umbral de cero). *CS4 se cumple en el
límite* (2 defectos Alta abiertos sobre un máximo de 2: un tercero lo incumpliría). Tres de los cuatro
criterios de salida no se cumplen, por lo que *el release no está listo*.

*Lectura correcta de las cifras.* Presentar «1 de 2 casos ejecutados aprobados» como resultado positivo
sería una métrica engañosa. El dato que gobierna la decisión es que el *62.5 % del alcance planificado
quedó bloqueado* —concentrado en la cadena transaccional pago → confirmación → visibilidad operativa, el
área de mayor riesgo económico— y que existe un *defecto crítico abierto* en ese mismo flujo.

*Recomendación.*

+ *Corregir DEF-04 con máxima prioridad* y reejecutar CP-CHK-01 mediante *prueba de confirmación*; al
  desbloquearse, ejecutar CP-CON-01, CP-CON-02 y CP-PED-01, y aplicar *pruebas de regresión* sobre los
  casos que comparten precondiciones.
+ *Habilitar un ambiente con permisos de escritura* (instancia propia del demo oficial, Escenario B del
  §2.2) para levantar el bloqueo de CP-ADM-01 y CP-RNF-01, hoy imputable al ambiente y no al producto.
+ *Cerrar los umbrales pendientes* —fecha de entrega como ancla del cronograma y umbral numérico de
  RNF-01— antes del siguiente ciclo, para que esos casos tengan criterio de aceptación verificable.
+ *Completar CP-RNF-02 en Edge y Firefox* y la evidencia E-02 pendiente. E-01, E-03 y E-04 ya tienen capturas complementarias; E-05 dispone de una captura parcial del formulario de stock.
+ *No abrir automatización todavía* sobre el flujo de compra: hoy no es estable y las pruebas fallarían
  por el defecto conocido en lugar de detectar defectos nuevos (§9).

#pagebreak()

#heading(level: 1, numbering: none)[Índice]

#outline(title: none, depth: 3, indent: 1.2em)

#heading(level: 1, numbering: none)[Índice de figuras]

#outline(title: none, target: figure.where(kind: image))

#heading(level: 1, numbering: none)[Índice de tablas]

#outline(title: none, target: figure.where(kind: table))

#pagebreak()

// =====================================================================
= Contexto del caso y base de pruebas
// =====================================================================

== El caso y el sistema bajo prueba

El Caso 3 corresponde a un *e-commerce con panel administrativo* implementado sobre OpenCart. El sistema
bajo prueba es la instalación pública de demostración *OpenCart Demo 4.0.2.3*
(#link("https://demo.opencart.com/")[https://demo.opencart.com/]), cuyo panel administrativo se encuentra
en la ruta real `https://demo.opencart.com/TlbeVW/` —no en `/admin/`— con las credenciales `demo` / `demo`
publicadas por opencart.com.

El bloque documentado aquí abarca *FUN-05* (checkout como invitado o registrado), *FUN-06* (confirmación
y resumen del pedido), *FUN-07* (productos, categorías y stock desde el panel), *FUN-08* (gestión
administrativa de pedidos) y los requisitos no funcionales *RNF-01* (sincronización sitio–panel sin
reinicios), *RNF-02* (compatibilidad entre navegadores) y *RNF-03* (tiempo de respuesta del catálogo).

== Base de pruebas y criterio de derivación

La base de pruebas son los requisitos verificables del Avance 1 —*RF CHK 01–05*, *RF CON 01–04*,
*RF ADM 01–07*, *RF PED 01–05* y *RNF 01–03*—, derivados del enunciado del Caso 3 y de la exploración
inicial. Cada condición surge de descomponer el requisito en sus aspectos verificables independientes:
flujo feliz, campos obligatorios, formatos inválidos, reglas de negocio y consistencia sitio–panel.

#nota[
  Según ISTQB, una *condición de prueba* es un aspecto de la base de pruebas verificable por uno o más
  casos: describe *qué* comprobar, nunca *cómo* ni con qué datos. Ninguna fila del análisis (§4) contiene
  pasos, valores ni resultados de ejecución.
]

La cadena de trazabilidad tiene *cuatro eslabones: Requisito ↔ caso ↔ ejecución ↔ defecto*. La condición
de prueba (CT) se conserva como *paso intermedio del análisis* entre el requisito y el caso.

== Nota de ambiente vigente (24-09-2026)

`demo.opencart.com` respondió *HTTP 403* por bloqueo de Cloudflare —storefront y panel— desde el entorno
de automatización; en la exploración del 18-09-2026 el usuario `demo` no podía modificar configuración y
no se logró generar una orden. Esto *no altera el análisis* —las condiciones derivan de la base de
pruebas, no de la disponibilidad—, pero se registra en la columna *Ejecutabilidad prevista* de cada
condición, con tres valores: *Ejecutable* (observable desde el sitio público), *Requiere permisos admin*
(exige escritura en el panel) y *Requiere pedido completado* (exige una orden real confirmada). El
registro fechado completo está en el Anexo A (§11.1).

#pagebreak()

// =====================================================================
= Planificación de pruebas
// =====================================================================

Alcance de la planificación: FUN-05 checkout, FUN-06 confirmación, FUN-07 catálogo y stock
administrativo, FUN-08 pedidos, RNF-01, RNF-02 y RNF-03.

== Elementos de prueba

#figure(
  table(
    columns: (5.0cm, 5.4cm, 1fr),
    table.header([Elemento], [Ubicación], [Requisitos]),
    [Checkout invitado y registrado], [Sitio público, `route=checkout/checkout`], [RF CHK 01–05],
    [Confirmación y resumen del pedido], [Etapa final del checkout y página de éxito], [RF CON 01–04],
    [Catalog \> Products], [Panel administrativo], [RF ADM 01–07],
    [Sales \> Orders], [Panel administrativo], [RF PED 01–05],
    [Sincronización sitio–panel], [Interfaz entre ambos], [RNF 01, RF ADM 07, RF PED 01],
    [Compatibilidad del flujo crítico], [Sitio público], [RNF 02],
    [Tiempo de respuesta de página de categoría], [Sitio público], [RNF 03],
  ),
  caption: [Elementos de prueba del bloque del Integrante 2.],
)

Lo no listado queda fuera del bloque.

== Ambiente de prueba

*Escenario A — demo público compartido (`demo.opencart.com`).* Ambiente multiusuario, sin aislamiento de
sesión ni control del dato: terceros modifican catálogo y pedidos de forma concurrente y el sitio se
restablece periódicamente, lo que invalida precondiciones entre ejecuciones. El usuario `demo` opera con
permisos administrativos restringidos, por lo que guardar en Catalog \> Products puede ser rechazado.

Restricción verificada el 24-09-2026: el host responde HTTP 403 con bloqueo de Cloudflare
(#lit[Sorry, you have been blocked]), tanto en el storefront como en el panel administrativo, cuya ruta
real es `https://demo.opencart.com/TlbeVW/` con credenciales publicadas por opencart.com
(`demo` / `demo`). Ray IDs observados: `a3ffd6a6fe936f20` y `a3ffdaf1d8966f2f`. El sitio `opencart.com`
sí carga, de modo que el bloqueo es del host del demo y no de la red del equipo. Mientras persista, el
bloque queda Bloqueado por impedimento externo: la *tasa de bloqueo* se calcula sobre los casos
*planificados*, no sobre los ejecutados, y la *tasa de aprobación* sobre los casos *ejecutados*.

*Validez de la evidencia en A:* una captura prueba el estado del sistema solo en ese instante y no es
reproducible. Toda evidencia se fecha en el nombre del archivo y cita el identificador del pedido o
producto observado.

*Escenario B — instancia controlada desplegada localmente (contingencia).* Base de datos y datos semilla
bajo control del equipo. Habilita permisos administrativos plenos, creación de pedidos reales y
configuración explícita de `Stock Checkout`, precondición de CP-CON-01, CP-CON-02, CP-PED-01, CP-RNF-01 y
CP-ADM-01.

*Validez de la evidencia en B:* es reproducible, y las pruebas de confirmación y de regresión pueden
repetirse sobre el mismo estado inicial. A cambio, los hallazgos se atribuyen a esa instancia y no al demo
oficial. Cada caso declara su escenario de ejecución.

- *Versión de OpenCart (demo e instancia local):* *4.0.2.3* (confirmada).
- *Escenario definitivo:* se ejecutó sobre el *escenario A, demo público* `demo.opencart.com`, accesible desde la red del responsable el 24-09-2026. No fue necesario desplegar la instancia local del escenario B, dado que el impedimento encontrado fue de permisos y de configuración publicada, no de disponibilidad.

== Navegadores seleccionados

Se adopta el conjunto propuesto por el caso, sin ampliarlo: *Chrome*, *Edge* y *Firefox* de escritorio.
Chrome y Edge comparten motor Chromium, por lo que Firefox aporta la única variación real de renderizado;
Edge se conserva por ser el navegador preinstalado del parque corporativo típico.

RNF-02 se verifica con CP-RNF-02, ejecutando el flujo crítico completo —catálogo, ficha, carrito y
checkout— en cada navegador con un único juego de datos, de modo que las diferencias sean atribuibles al
navegador, y registrando veredicto y errores bloqueantes por navegador.
Versiones: la ejecución del 24-09-2026 se realizó en *Google Chrome 153* sobre macOS. Las versiones de Edge y Firefox se registrarán cuando se complete CP-RNF-02, hoy en ejecución parcial.

== Herramientas

#figure(
  table(
    columns: (5.2cm, 1fr),
    table.header([Propósito], [Herramienta]),
    [Ejecución manual], [Chrome, Edge y Firefox, ventana privada por sesión],
    [Captura de evidencia], [Utilidad de captura del sistema operativo, nombre trazable (§2.10)],
    [Registro del testware], [Hoja de cálculo: casos, ejecución, defectos, trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto],
    [Medición RNF-03], [DevTools \> Network, caché deshabilitada, varias mediciones; cronómetro como control cruzado],
    [Medición RNF-01], [Marca de tiempo de confirmación frente a aparición en Sales \> Orders],
    [Gestión de pruebas], [*Qase* (`app.qase.io`), la herramienta de gestión de pruebas presentada en clase. Los ocho casos de este bloque se entregan además en formato CSV importable (`informe/qase_casos_granit.csv`), con su guía de importación y de registro del Test Run. Las tablas del presente informe se mantienen como respaldo autónomo del testware.],
  ),
  caption: [Herramientas de apoyo al bloque.],
)

Cualquier herramienta que se elija debe sostener la trazabilidad *Requisito ↔ caso ↔ ejecución ↔ defecto*;
la condición de prueba (CT) se conserva como paso intermedio del análisis.

== Datos de prueba

#figure(
  table(
    columns: (5.8cm, 5.2cm, 1fr),
    table.header([Dato], [Uso], [Volatilidad]),
    [Producto físico disponible y elegible], [CP-CHK-01, CP-CON-01, CP-RNF-02], [Volátil en A],
    [Producto con cantidad cero y estado #emph[Out Of Stock]], [CP-ADM-01], [Volátil; exige escritura en el panel],
    [Datos de invitado (nombre, correo, teléfono, dirección, código postal)], [CP-CHK-01], [Estable, definidos por el equipo],
    [Credenciales administrativas], [CP-ADM-01, CP-PED-01, CP-RNF-01], [Publicadas; permisos restringidos en A],
    [Pedido de referencia generado por el equipo], [CP-CON-01, CP-CON-02, CP-PED-01], [Volátil; se recrea en cada ejecución],
    [Página de categoría con volumen representativo], [CP-RNF-03], [Volátil en A],
  ),
  caption: [Datos de prueba previstos en la planificación.],
)

Los datos volátiles se re-verifican antes de cada ejecución. Si la precondición no se cumple, el caso se
marca *Bloqueado* con su causa, no *Fallido*.

== Recursos y responsabilidades

#figure(
  table(
    columns: (5.4cm, 2.2cm, 1fr),
    table.header([Rol], [Persona], [Responsabilidad]),
    [Analista de QA — bloque transaccional y administrativo], [Granit], [Checkout, confirmación de pedidos, administración de catálogo y pedidos, requisitos no funcionales, consolidación, Gestión de la Configuración del testware y lecciones aprendidas],
    [Analista de QA — bloque de navegación y carrito], [Franco], [Catálogo, ficha de producto, carrito y cupones],
  ),
  caption: [Recursos y responsabilidades.],
)

== Estimación de esfuerzo

Criterio declarado: *juicio experto por analogía* con bloques de pruebas funcionales manuales de tamaño
comparable. Horas de esfuerzo neto, sin holgura por reintentos del demo.

#figure(
  table(
    columns: (1fr, 2.2cm),
    align: (left, center),
    table.header([Actividad], [Horas]),
    [Planificación y riesgos del bloque], [3],
    [Análisis de condiciones y trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto (con la condición de prueba CT como paso intermedio)], [4],
    [Diseño de los 8 casos], [6],
    [Preparación de ambiente y datos, incluida la contingencia local], [4],
    [Ejecución de casos de prioridad Alta], [6],
    [Pruebas de confirmación y de regresión], [3],
    [Registro de defectos y evidencia], [3],
    [Consolidación, estado frente a los criterios de salida y lecciones aprendidas], [4],
    [*Total*], [*33*],
  ),
  caption: [Estimación de esfuerzo del bloque (juicio experto por analogía).],
)

== Cronograma

Ancla: #pendiente[fecha de entrega]. Duraciones relativas; no se declaran fechas absolutas.

#figure(
  table(
    columns: (1fr, 2.4cm, 3.6cm),
    table.header([Hito], [Duración], [Posición]),
    [H1 · Planificación y riesgos aprobados], [1 día], [Entrega − 9],
    [H2 · Análisis y trazabilidad cerrados], [1 día], [Entrega − 8],
    [H3 · Casos diseñados y revisados con Franco], [2 días], [Entrega − 7 a − 6],
    [H4 · Ambiente y datos confirmados (línea base)], [1 día], [Entrega − 5],
    [H5 · Ejecución de casos Alta], [2 días], [Entrega − 4 a − 3],
    [H6 · Pruebas de confirmación y de regresión], [1 día], [Entrega − 2],
    [H7 · Consolidación, estado frente a los criterios de salida y cierre], [1 día], [Entrega − 1],
  ),
  caption: [Cronograma de hitos con duraciones relativas.],
)

== Entregables del bloque

- Esta sección de planificación.
- Registro de riesgos de proceso y de producto del bloque.
- Análisis de FUN-05 a FUN-08 y RNF-01 a RNF-03, con matriz de trazabilidad
  Requisito ↔ caso ↔ ejecución ↔ defecto, conservando la condición de prueba (CT) como paso intermedio
  del análisis.
- Ocho casos diseñados: CP-CHK-01, CP-CON-01, CP-CON-02, CP-ADM-01, CP-PED-01, CP-RNF-01, CP-RNF-02,
  CP-RNF-03.
- Registro de ejecución con veredicto por caso y causa explícita de cada Bloqueado.
- Evidencia gráfica nombrada según convención.
- Reporte de defectos con título `[Módulo/Funcionalidad] + [qué falla] + [bajo qué condición]`.
- Consolidado global, *estado frente a los criterios de salida CS1–CS4* y lecciones aprendidas. La
  conclusión se redacta como estado frente a los criterios —«no se cumplen los criterios de salida CSx y
  CSy → el release no está listo»—, nunca como una etiqueta de dictamen.

== Gestión de la Configuración del testware

- *Control de versiones del documento:* identificador `vMAJOR.MINOR` con autor, fecha y motivo del cambio
  en el encabezado de control. No se edita sobre una versión ya publicada.
- *Convención de nombres de evidencia:* `CP-XXX-NN_pasoNN_descripcion_AAAAMMDD.png`. La fecha es
  obligatoria porque el ambiente es compartido y el dato observado no es reproducible.
- *Repositorio:* carpeta `entregables/` del proyecto, con subcarpetas `evidencia/` por caso y `defectos/`.
  Repositorio remoto: `https://github.com/usuariogranit/Proyecto1_Caso3_OpenCart` (público, rama `main`), que contiene el testware completo y sirve de punto de integración con el bloque del Integrante 1.
- *Línea base:* se establece al cierre de H3 sobre casos diseñados y datos acordados; desde ese punto
  ningún caso se modifica sin control de cambios.
- *Control de cambios:* toda modificación posterior a la línea base se registra con caso afectado, motivo,
  responsable y fecha, e incrementa la versión. Un cambio sobre un caso ya ejecutado obliga a *pruebas de
  confirmación* de ese caso y a evaluar *pruebas de regresión* sobre los que comparten precondiciones.

== Supuestos y restricciones del demo

*Supuestos*

- La funcionalidad del demo es representativa de una instalación estándar de OpenCart.
- Las credenciales `demo` / `demo` siguen siendo las publicadas por el proveedor.
- De persistir el bloqueo, la ejecución se traslada al Escenario B y los resultados se atribuyen
  explícitamente a esa instancia.

*Restricciones*

- Al 24-09-2026 `demo.opencart.com` devuelve HTTP 403 por bloqueo de Cloudflare en storefront y panel; el
  bloqueo es del host del demo, no de la red del equipo.
- El usuario `demo` tiene permisos administrativos restringidos y puede no guardar cambios en
  Catalog \> Products.
- Los datos del demo son compartidos y volátiles y pueden ser alterados por terceros durante la ejecución.
- No hay control sobre servidor, caché ni red, lo que condiciona la medición de RNF-03.
- Sin acceso a logs ni a base de datos en el Escenario A, los defectos se documentan solo por
  comportamiento observable de caja negra.
- El caso no define el umbral numérico de RNF-01. #pendiente[umbral acordado con la docente]

#pagebreak()

// =====================================================================
= Gestión de riesgos
// =====================================================================

== Método de evaluación

*Probabilidad* (dentro de la ventana de ejecución):

- *Alta:* ya ocurrió o es condición estructural del ambiente.
- *Media:* plausible y conocida en entornos equivalentes; depende de condiciones ajenas.
- *Baja:* exige condiciones poco frecuentes.

*Impacto* (consecuencia si se materializa):

- *Alto:* invalida un flujo transaccional crítico; pérdida económica o incumplimiento con el cliente.
- *Medio:* degrada cobertura u operación; retrabajo acotado.
- *Bajo:* molestia operativa; no afecta la decisión de release.

#figure(
  table(
    columns: (4.2cm, 3.0cm, 3.0cm, 3.0cm),
    align: center,
    table.header([Probabilidad \\ Impacto], [Alto], [Medio], [Bajo]),
    [*Alta*], [Alto], [Alto], [Medio],
    [*Media*], [Alto], [Medio], [Bajo],
    [*Baja*], [Medio], [Bajo], [Bajo],
  ),
  caption: [Matriz Probabilidad × Impacto → Nivel de riesgo.],
)

#nota[
  *Producto frente a proceso.* El riesgo de *producto* es que el sistema falle frente a un requisito y
  dañe al negocio (venta sin inventario, pedido duplicado, datos inconsistentes). El riesgo de
  *proyecto/proceso* es que el equipo no pueda ejecutar la prueba prevista (ambiente, permisos, datos,
  tiempo): no dice nada sobre la calidad del sistema, pero determina cuánta evidencia podremos obtener.
]

Las dos tablas de registro se presentan en orientación horizontal por su ancho (§3.2 y §3.3).

#page(flipped: true)[
  == Riesgos de proceso

  #figure(
    mini[
      #table(
        columns: (1.15cm, 2.7cm, 2.2cm, 2.9cm, 1.3cm, 1.3cm, 1.3cm, 2.4cm, 2.4cm, 1fr),
        table.header(
          [ID], [Riesgo], [Causa], [Efecto sobre las pruebas], [Prob], [Imp], [Nivel],
          [Mitigación], [Contingencia], [Estado],
        ),
        [RPR-01], [Sin permisos de escritura en el panel], [Usuario `demo` restringido por el proveedor], [CP-ADM-01 y precondiciones administrativas no ejecutables], [Alta], [Alto], [*Alto*], [Rediseñar lo administrativo como solo-lectura], [Instancia propia desde el acceso oficial], [*MATERIALIZADO* 18-09-2026: al guardar, el panel responde #lit[Warning: You do not have permission to modify coupons]],
        [RPR-02], [Datos alterados por otros usuarios], [Ambiente público multiusuario], [Precondiciones caducan; resultados no reproducibles], [Alta], [Medio], [*Alto*], [Verificar precondición justo antes de cada caso], [Re-ejecutar con producto alterno], [Vigente],
        [RPR-03], [Indisponibilidad del ambiente], [Bloqueo perimetral del host del demo], [Ejecución detenida; bloque completo Bloqueado], [Alta], [Alto], [*Alto*], [Verificar disponibilidad antes de cada sesión], [Instancia propia y replanificar cronograma], [*MATERIALIZADO* 24-09-2026: `demo.opencart.com` devuelve HTTP 403 con página Cloudflare #lit[Sorry, you have been blocked], en sitio público y en el panel (`https://demo.opencart.com/TlbeVW/`). Ray IDs `a3ffd6a6fe936f20` y `a3ffdaf1d8966f2f`. `opencart.com` sí responde: el bloqueo es del host del demo],
        [RPR-04], [Sesiones contaminadas entre casos], [Carrito, cookies y sesión persistentes], [Veredictos falsos por estado heredado], [Media], [Medio], [*Medio*], [Ventana limpia por caso; cerrar sesión], [Repetir en perfil nuevo], [Vigente],
        [RPR-05], [Imposibilidad de generar un pedido real], [Checkout interrumpido por control de inventario], [CP-CON-01/02, CP-PED-01 y CP-RNF-01 sin precondición], [Alta], [Alto], [*Alto*], [Verificar stock antes de iniciar], [Instancia propia con `Stock Checkout` controlado], [*MATERIALIZADO* 18-09-2026: no fue posible completar el checkout; el flujo se detuvo por stock],
        [RPR-06], [Productos sin datos válidos], [Catálogo degradado por uso público], [Datos insuficientes para RF CHK 05 y RF ADM 06], [Media], [Medio], [*Medio*], [Inventariar productos aptos al abrir sesión], [Sustituir por equivalente y documentarlo], [Vigente],
        [RPR-07], [Flujos bloqueados por configuración], [Guest Checkout, pago o envío deshabilitados], [Requisitos no verificables aun con ambiente arriba], [Alta], [Alto], [*Alto*], [Revisar configuración antes de diseñar pasos], [Declarar Bloqueado con su causa], [Vigente],
        [RPR-08], [Ambiente único sin alterno aprobado], [Instancia propia aún como decisión pendiente], [Un solo punto de falla para todo el bloque], [Media], [Alto], [*Alto*], [Escalar la decisión antes de ejecutar], [Preparar instancia propia en paralelo], [Vigente],
        [RPR-09], [Evidencia no reproducible por deriva del ambiente], [El dato cambia entre captura y revisión], [Hallazgos cuestionables en revisión], [Media], [Medio], [*Medio*], [Captura fechada; registrar URL y hora], [Re-capturar y anotar la discrepancia], [Vigente],
        [RPR-10], [Umbrales de RNF 01 y RNF 03 sin acordar], [El avance los deja «por acordar»], [Sin criterio de aceptación no hay veredicto], [Alta], [Medio], [*Alto*], [Acordar umbral y método antes del diseño], [Reportar la medición como observación], [Vigente],
        [RPR-11], [Pérdida o descontrol del testware], [Gestión de la Configuración informal], [Versiones divergentes de casos y evidencia], [Baja], [Medio], [*Bajo*], [Repositorio único versionado], [Reconstruir desde la última línea base], [Vigente],
      )
    ],
    caption: [Registro de riesgos de proceso del bloque del Integrante 2.],
  )
]

#page(flipped: true)[
  == Riesgos de producto

  #figure(
    mini[
      #table(
        columns: (1.15cm, 3.0cm, 2.3cm, 2.5cm, 1fr, 1.3cm, 1.3cm, 1.3cm, 2.6cm, 2.6cm, 1.9cm),
        table.header(
          [ID], [Riesgo], [Requisito(s) afectado(s)], [Causa], [Efecto sobre las pruebas],
          [Prob], [Imp], [Nivel], [Mitigación], [Contingencia], [Estado],
        ),
        [RPD-01], [El checkout no completa la compra con datos válidos], [RF CHK 01–04], [Validaciones o métodos de envío/pago mal aplicados], [Invalida el flujo transaccional principal], [Media], [Alto], [*Alto*], [CP-CHK-01 Alta; equivalencia y valores límite], [Aislar la etapa y trazar el defecto a su RF], [Potencial],
        [RPD-02], [El checkout no conserva productos, cantidades u opciones], [RF CHK 05], [Recálculo entre etapas], [Cobro distinto al aceptado], [Baja], [Alto], [*Medio*], [Comparar campo a campo carrito frente a resumen], [Reproducir con carrito multiproducto], [Potencial],
        [RPD-03], [Sin identificador de orden o resumen no coincidente], [RF CON 01, 02, 04], [Falla en la creación de la orden], [Cliente sin evidencia de la operación], [Baja], [Alto], [*Medio*], [CP-CON-01: total antes y después de confirmar], [Contrastar con el detalle administrativo], [Potencial],
        [RPD-04], [Pedidos duplicados por doble clic, recarga o retorno], [RF CON 03], [Confirmación sin idempotencia], [Doble cargo y reclamo], [Media], [Alto], [*Alto*], [CP-CON-02 con las tres variantes de reenvío], [Verificar conteo de órdenes en el panel], [Potencial],
        [RPD-05], [Inconsistencia entre sitio público y panel], [RF ADM 02, 04, 07 · RNF 01], [Caché o propagación diferida], [Operación decide sobre datos falsos], [Media], [Alto], [*Alto*], [CP-ADM-01 y CP-RNF-01 con marca de tiempo], [Medir el desfase contra el umbral], [Potencial],
        [RPD-06], [Pedido confirmado ausente en la lista administrativa], [RF PED 01, 02], [Falla de persistencia o sincronización], [Pedido invisible para operaciones], [Baja], [Alto], [*Medio*], [CP-PED-01: comparar identificador y detalle], [Buscar por filtros alternos antes de reportar], [Potencial],
        [RPD-07], [Pérdida de sesión administrativa], [RF ADM 01–07 · RF PED 01–05], [Expiración del token de sesión], [Simula bloqueos falsos], [Media], [Medio], [*Medio*], [Reautenticar al inicio de cada caso], [Repetir con sesión recién abierta], [Potencial],
        [RPD-08], [Desfase de sincronización sobre el umbral], [RNF 01 · RF ADM 07], [Latencia de propagación], [Sobreventa durante la ventana de desfase], [Media], [Medio], [*Medio*], [Medición repetida en CP-RNF-01], [Observación si falta umbral (RPR-10)], [Potencial],
        [RPD-09], [Flujo crítico fallido en algún navegador seleccionado], [RNF 02 · RF CHK 01–05], [Diferencias de motor de render o scripting], [Segmento de clientes sin poder comprar], [Media], [Medio], [*Medio*], [CP-RNF-02 en Chrome, Edge y Firefox], [Documentar navegador y versión exactos], [Potencial],
        [RPD-10], [La gestión del pedido altera importes o productos], [RF PED 04, 05], [Efecto lateral del cambio de estado], [Descuadre contable], [Baja], [Alto], [*Medio*], [Comparar totales antes y después del cambio], [Contrastar con el historial del pedido], [Potencial],
        [RPD-11], [Compra permitida por encima del stock disponible], [RF ADM 03], [Política de `Stock Checkout` mal aplicada], [Venta sin inventario real], [Media], [Alto], [*Alto*], [CP-ADM-01 con cantidad cero y sobre stock], [Verificar configuración antes de calificar], [Potencial],
        [RPD-12], [Catálogo responde por encima de dos segundos], [RNF 03], [Carga del demo compartido], [Abandono de navegación], [Media], [Bajo], [*Bajo*], [CP-RNF-03: varias mediciones, caché y red documentadas], [Medición sin veredicto si falta umbral], [Potencial],
      )
    ],
    caption: [Registro de riesgos de producto del bloque del Integrante 2.],
  )
]

Los riesgos marcados *Potencial* no han sido observados: son hipótesis de falla que orientan el diseño.
Solo los tres *MATERIALIZADO* cuentan con evidencia fechada.

== Riesgos residuales del análisis de riesgos

Aun ejecutando todo el bloque queda sin cubrir:

+ la *concurrencia* —dos clientes comprando la última unidad—, que el demo no permite controlar;
+ la *integración real de pago*, al operar con métodos de prueba;
+ la *persistencia a largo plazo* de los pedidos, porque el ambiente compartido se restablece;
+ los *navegadores móviles*, fuera del conjunto de RNF 02;
+ toda verificación que exija *escritura administrativa* mientras persista RPR-01.

Se trasladan al cierre como *riesgo residual documentado, pendiente de aceptación por el responsable de negocio*, dentro del estado frente a los
criterios de salida, no como cobertura lograda.

== Vínculo riesgo → prioridad de prueba

La prioridad de cada condición y caso se deriva del *nivel de riesgo*, no del orden del enunciado: los
casos que atacan riesgos Altos se ejecutan primero y son los que condicionan el *estado frente a los
criterios de salida* (CS1–CS4, §8). El criterio es el impacto de negocio.

- Una *venta sin inventario real* (RPD-11) genera incumplimiento con el cliente y costo operativo de
  reposición o cancelación: por eso CP-ADM-01 es Alta.
- Un *pedido duplicado* (RPD-04) implica doble cargo y reclamo, lo que sostiene la prioridad Alta de
  CP-CON-02.
- Una *inconsistencia sitio–panel* (RPD-05, RPD-06) hace que operaciones decida sobre datos falsos
  —despachar lo que no existe o ignorar un pedido real—, de ahí la prioridad Alta de CP-PED-01 y
  CP-RNF-01.
- Los riesgos Medio y Bajo sustentan casos de prioridad menor, ejecutables solo si el ambiente lo permite.

En sentido inverso, los riesgos de proceso Altos determinan qué casos se declaran *Bloqueados*: la *tasa
de bloqueo* se calcula sobre los casos *planificados*, no sobre los ejecutados, mientras que la *tasa de
aprobación* se calcula sobre los casos *ejecutados*.

#pagebreak()

// =====================================================================
= Análisis de pruebas
// =====================================================================

Fecha de análisis: 24-09-2026. Bloque: FUN 05 Checkout · FUN 06 Confirmación · FUN 07 Productos,
categorías y stock · FUN 08 Gestión de pedidos · RNF 01–03.

== Condiciones de prueba

=== FUN 05 — Checkout como invitado o registrado

#figure(
  chico[
    #table(
      columns: (1.85cm, 1fr, 2.1cm, 1.15cm, 1.65cm, 2.9cm),
      table.header([ID], [Condición de prueba], [Requisito(s)], [Riesgo], [Prioridad], [Ejecutabilidad prevista]),
      [CT-CHK-01], [Acceso al checkout como invitado sin exigir la creación de una cuenta], [RF CHK 01], [Alto], [Alta], [Ejecutable],
      [CT-CHK-02], [Finalización del checkout de invitado con producto físico elegible], [RF CHK 01, RF CHK 04], [Alto], [Alta], [Requiere pedido completado],
      [CT-CHK-03], [Uso de direcciones y métodos asociados a la cuenta en cliente registrado], [RF CHK 02], [Medio], [Media], [Requiere pedido completado],
      [CT-CHK-04], [Bloqueo del avance ante campos obligatorios vacíos], [RF CHK 03], [Alto], [Alta], [Ejecutable],
      [CT-CHK-05], [Rechazo de formatos inválidos en correo, teléfono y código postal, con indicación comprensible por campo], [RF CHK 03], [Medio], [Alta], [Ejecutable],
      [CT-CHK-06], [Exigencia de método de envío y de pago aplicables antes de habilitar la confirmación], [RF CHK 04], [Alto], [Alta], [Ejecutable],
      [CT-CHK-07], [Correspondencia del resumen del checkout con productos, cantidades, opciones y descuentos del carrito], [RF CHK 05], [Alto], [Alta], [Ejecutable],
    )
  ],
  caption: [Condiciones de prueba de FUN 05 — Checkout.],
)

=== FUN 06 — Confirmación y resumen del pedido

#figure(
  chico[
    #table(
      columns: (1.85cm, 1fr, 2.1cm, 1.15cm, 1.65cm, 2.9cm),
      table.header([ID], [Condición de prueba], [Requisito(s)], [Riesgo], [Prioridad], [Ejecutabilidad prevista]),
      [CT-CON-01], [Generación de un identificador de orden único al confirmar una compra válida], [RF CON 01], [Alto], [Alta], [Requiere pedido completado],
      [CT-CON-02], [Presentación de la pantalla de confirmación como evidencia visible de la operación], [RF CON 01, RF CON 04], [Alto], [Alta], [Requiere pedido completado],
      [CT-CON-03], [Exactitud del resumen confirmado: productos, opciones, cantidades, impuestos, envío y descuento], [RF CON 02], [Alto], [Alta], [Requiere pedido completado],
      [CT-CON-04], [Igualdad entre el total mostrado antes de confirmar y el total del pedido creado], [RF CON 02], [Alto], [Alta], [Requiere pedido completado],
      [CT-CON-05], [Ausencia de órdenes duplicadas ante doble clic, recarga o retorno a la página final], [RF CON 03], [Alto], [Alta], [Requiere pedido completado],
      [CT-CON-06], [Cierre del pedido de invitado sin convertir el registro en condición para finalizar], [RF CON 04], [Medio], [Alta], [Requiere pedido completado],
    )
  ],
  caption: [Condiciones de prueba de FUN 06 — Confirmación.],
)

=== FUN 07 — Productos, categorías y stock (panel)

#figure(
  chico[
    #table(
      columns: (1.85cm, 1fr, 2.1cm, 1.15cm, 1.65cm, 2.9cm),
      table.header([ID], [Condición de prueba], [Requisito(s)], [Riesgo], [Prioridad], [Ejecutabilidad prevista]),
      [CT-ADM-01], [Persistencia de nombre, código, precio, estado, cantidad y categoría al reabrir el producto], [RF ADM 01], [Alto], [Alta], [Requiere permisos admin],
      [CT-ADM-02], [Guardado de cantidad cero junto con el estado #emph[Out Of Stock]], [RF ADM 02], [Alto], [Alta], [Requiere permisos admin],
      [CT-ADM-03], [Reflejo público de la falta de disponibilidad del producto agotado], [RF ADM 02, RF ADM 07], [Alto], [Alta], [Requiere permisos admin],
      [CT-ADM-04], [Imposibilidad de confirmar una compra superior al stock con `Stock Checkout` deshabilitado], [RF ADM 03], [Alto], [Alta], [Ejecutable],
      [CT-ADM-05], [Emisión de advertencia al cliente al solicitar una cantidad no disponible], [RF ADM 03], [Medio], [Media], [Ejecutable],
      [CT-ADM-06], [Retorno del producto a disponible al reponer inventario y habilitarlo], [RF ADM 04], [Alto], [Alta], [Requiere permisos admin],
      [CT-ADM-07], [Aparición del producto únicamente en las categorías asociadas], [RF ADM 05], [Medio], [Media], [Requiere permisos admin],
      [CT-ADM-08], [Conservación en la ficha pública de las opciones, su obligatoriedad y sus ajustes de precio], [RF ADM 06], [Alto], [Alta], [Requiere permisos admin],
      [CT-ADM-09], [Existencia de al menos un valor seleccionable en toda opción marcada como requerida], [RF ADM 06], [Medio], [Media], [Ejecutable],
      [CT-ADM-10], [Propagación al sitio público de stock, precio, categoría u opción sin reiniciar el sistema], [RF ADM 07, RNF 01], [Alto], [Alta], [Requiere permisos admin],
    )
  ],
  caption: [Condiciones de prueba de FUN 07 — Productos, categorías y stock.],
)

=== FUN 08 — Gestión de pedidos (panel)

#figure(
  chico[
    #table(
      columns: (1.85cm, 1fr, 2.1cm, 1.15cm, 1.65cm, 2.9cm),
      table.header([ID], [Condición de prueba], [Requisito(s)], [Riesgo], [Prioridad], [Ejecutabilidad prevista]),
      [CT-PED-01], [Aparición del pedido confirmado en la lista administrativa conservando el mismo identificador], [RF PED 01], [Alto], [Alta], [Requiere pedido completado],
      [CT-PED-02], [Coincidencia del detalle administrativo con el resumen público del pedido], [RF PED 02], [Alto], [Alta], [Requiere pedido completado],
      [CT-PED-03], [Recuperación del pedido por los filtros disponibles, excluyendo registros no coincidentes], [RF PED 03], [Medio], [Media], [Requiere pedido completado],
      [CT-PED-04], [Registro del nuevo estado y su fecha en el historial del pedido], [RF PED 04], [Medio], [Media], [Requiere permisos admin],
      [CT-PED-05], [Invariancia de productos, cantidades, descuentos y total ante consulta o cambio de estado], [RF PED 05], [Alto], [Alta], [Requiere permisos admin],
    )
  ],
  caption: [Condiciones de prueba de FUN 08 — Gestión de pedidos.],
)

=== RNF 01–03

#figure(
  chico[
    #table(
      columns: (1.85cm, 1fr, 2.1cm, 1.15cm, 1.65cm, 2.9cm),
      table.header([ID], [Condición de prueba], [Requisito(s)], [Riesgo], [Prioridad], [Ejecutabilidad prevista]),
      [CT-RNF-01], [Visibilidad en el panel de pedidos y cambios del sitio público sin reinicio de servicios], [RNF 01], [Alto], [Alta], [Requiere pedido completado],
      [CT-RNF-02], [Existencia de un umbral numérico de sincronización acordado antes del diseño], [RNF 01], [Medio], [Media], [Ejecutable],
      [CT-RNF-03], [Completitud de catálogo, ficha, carrito y checkout en Chrome, Edge y Firefox sin errores bloqueantes], [RNF 02], [Medio], [Media], [Ejecutable],
      [CT-RNF-04], [Tiempo de respuesta de la página de categoría por debajo de dos segundos en mediciones repetidas], [RNF 03], [Alto], [Alta], [Ejecutable],
      [CT-RNF-05], [Documentación del criterio de medición: caché, red y número de mediciones], [RNF 03], [Medio], [Media], [Ejecutable],
    )
  ],
  caption: [Condiciones de prueba de RNF 01–03.],
)

*Total: 33 condiciones derivadas.*

== Justificación de las condiciones de prioridad Alta (riesgo de negocio)

- *CT-CHK-01* — Forzar el registro pierde la venta en el punto de mayor intención de compra: abandono
  directo del carrito.
- *CT-CHK-02* — Un checkout de invitado que no cierra anula el canal de venta completo; es el flujo donde
  el negocio no puede permitirse fallar.
- *CT-CHK-04* — Datos obligatorios vacíos generan envíos fallidos y costo operativo de reproceso y
  devolución.
- *CT-CHK-05* — Correo o teléfono inválidos impiden notificar y coordinar la entrega: reclamos, reembolsos
  y desgaste reputacional.
- *CT-CHK-06* — Confirmar sin envío o pago válido produce órdenes impagas o no despachables que
  operaciones cancela a mano.
- *CT-CHK-07* — Diferencia entre carrito y checkout es cobro indebido o descuento perdido: pérdida directa
  y disputa con el medio de pago.
- *CT-CON-01* — Sin número de orden único no hay soporte, seguimiento ni conciliación contable de la venta.
- *CT-CON-02* — Sin confirmación visible el cliente repite la compra o reclama un cobro que no reconoce.
- *CT-CON-03* — El resumen es la evidencia del contrato de venta; toda discrepancia deriva en devolución y
  reclamo formal.
- *CT-CON-04* — Que el total cambie al confirmar es cobro no consentido: máxima exposición legal y de
  contracargos.
- *CT-CON-05* — El pedido duplicado cobra y despacha dos veces: pérdida de inventario, costo logístico y
  daño reputacional inmediato.
- *CT-CON-06* — Exigir registro después de pagar niega al invitado su evidencia de compra y dispara
  contacto con soporte.
- *CT-ADM-01* — Datos que no persisten obligan a reeditar el catálogo y publican precios o estados
  equivocados.
- *CT-ADM-02 / CT-ADM-03* — Vender lo inexistente causa incumplimiento de entrega, reembolso y pérdida de
  confianza: el riesgo operativo más caro del bloque.
- *CT-ADM-04* — Sin control de stock al confirmar se comprometen unidades inexistentes y se acumulan
  cancelaciones masivas.
- *CT-ADM-06* — Si la reposición no se refleja, se pierden ventas de producto disponible: costo de
  oportunidad invisible.
- *CT-ADM-08* — Opciones u obligatoriedad perdidas producen pedidos incompletos o mal tarifados que
  operaciones corrige a mano.
- *CT-ADM-10* — Sin propagación, cada cambio comercial exige intervención técnica y frena campañas y
  ajustes de precio.
- *CT-PED-01* — Un pedido cobrado que no llega al panel no se despacha: incumplimiento con el cobro ya
  efectuado.
- *CT-PED-02* — Detalle divergente entre cliente y panel provoca envíos equivocados y reprocesos
  logísticos completos.
- *CT-PED-05* — Que importes o productos cambien sin acción explícita destruye la integridad contable y la
  auditabilidad de las ventas.
- *CT-RNF-01* — La demora de sincronización retrasa la preparación del pedido y degrada el compromiso de
  entrega.
- *CT-RNF-04* — Un catálogo por encima de dos segundos reduce la conversión en la etapa más alta del
  embudo.

== Matriz de trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto

Esta matriz documenta los eslabones *requisito ↔ caso*; el eslabón *ejecución* se registra en §6 y el
eslabón *defecto* en §7, donde cada DEF cita su requisito, su condición, su caso y su ejecución. La
condición de prueba (CT) se conserva como paso intermedio del análisis.

#figure(
  block(width: 100%, breakable: false)[
    #let sep = 0.60cm
    #let cols = (1fr, sep, 1fr, sep, 1fr, sep, 1fr, sep, 1fr)
    #grid(
      columns: cols,
      align: center + horizon,
      row-gutter: 4pt,
      // Fila 1 — nombre del eslabón
      text(size: 7pt, fill: luma(90))[ESLABÓN 1 · Requisito], [],
      text(size: 7pt, fill: luma(90))[paso intermedio · Condición], [],
      text(size: 7pt, fill: luma(90))[ESLABÓN 2 · Caso], [],
      text(size: 7pt, fill: luma(90))[ESLABÓN 3 · Ejecución], [],
      text(size: 7pt, fill: luma(90))[ESLABÓN 4 · Defecto],
      // Fila 2 — cajas encadenadas
      caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"))[*RF CHK 04*], flecha-h,
      caja(fondo: rgb("#f2f2f2"), borde: rgb("#5a5e62"))[*CT-CHK-04*], flecha-h,
      caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"))[*CP-CHK-01*], flecha-h,
      caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"))[*Ejecución\ 24-09-2026*], flecha-h,
      caja(fondo: C-FALLO.fondo, borde: C-FALLO.borde)[*DEF-04*],
      // Fila 3 — qué aporta cada eslabón
      text(size: 7pt)[Qué debe cumplir el sistema], [],
      text(size: 7pt)[Qué comprobar, sin cómo], [],
      text(size: 7pt)[Cómo comprobarlo, con datos], [],
      text(size: 7pt)[Qué se observó y cuándo], [],
      text(size: 7pt)[Qué falló y con qué impacto],
    )
    #v(4pt)
    #align(center)[#text(size: 7.6pt, fill: luma(80))[Cadena real registrada en la trazabilidad de DEF-04 (§7.5): se muestra el primer elemento de cada conjunto declarado.]]
  ],
  kind: image,
  supplement: [Figura],
  caption: [Cadena de trazabilidad de cuatro eslabones (Requisito ↔ caso ↔ ejecución ↔ defecto), con la condición de prueba como paso intermedio del análisis.],
)

La cadena completa que DEF-04 declara en §7.5 es
*RF CHK 04 / RF CON 01 / RF ADM 07 / RNF 01 → CT-CHK-04, CT-RNF-01 → CP-CHK-01, CP-CON-01, CP-RNF-01 →
ejecución del 24-09-2026 → DEF-04*: un mismo defecto puede colgar de varios requisitos y afectar a varios
casos, pero cada eslabón conserva su identificador exacto y es recorrible en ambos sentidos.

#figure(
  chico[
    #table(
      columns: (2.4cm, 3.4cm, 1fr),
      table.header([Requisito], [Condición(es)], [Caso(s) de prueba previstos]),
      [RF CHK 01], [CT-CHK-01, CT-CHK-02], [CP-CHK-01],
      [RF CHK 02], [CT-CHK-03], [*No cubierta en esta iteración* — el bloque prioriza el flujo de invitado, de mayor volumen y riesgo.],
      [RF CHK 03], [CT-CHK-04, CT-CHK-05], [CP-CHK-01],
      [RF CHK 04], [CT-CHK-06], [CP-CHK-01],
      [RF CHK 05], [CT-CHK-07], [*No cubierta en esta iteración* — el arrastre carrito→checkout depende del bloque de carrito y cupones (Integrante 1).],
      [RF CON 01], [CT-CON-01, CT-CON-02], [CP-CON-01],
      [RF CON 02], [CT-CON-03, CT-CON-04], [CP-CON-01],
      [RF CON 03], [CT-CON-05], [CP-CON-02],
      [RF CON 04], [CT-CON-06], [CP-CHK-01 (cierre del flujo de invitado)],
      [RF ADM 01], [CT-ADM-01], [*No cubierta en esta iteración* — requiere escritura en el panel, no permitida al usuario `demo`.],
      [RF ADM 02], [CT-ADM-02, CT-ADM-03], [CP-ADM-01],
      [RF ADM 03], [CT-ADM-04, CT-ADM-05], [CP-ADM-01],
      [RF ADM 04], [CT-ADM-06], [*No cubierta en esta iteración* — la reposición exige permisos de escritura no disponibles.],
      [RF ADM 05], [CT-ADM-07], [*No cubierta en esta iteración* — la asociación de categorías exige permisos de escritura.],
      [RF ADM 06], [CT-ADM-08, CT-ADM-09], [*No cubierta en esta iteración* — las opciones de producto pertenecen al alcance de FUN 02 (Integrante 1).],
      [RF ADM 07], [CT-ADM-10], [CP-RNF-01],
      [RF PED 01], [CT-PED-01], [CP-PED-01],
      [RF PED 02], [CT-PED-02], [CP-PED-01],
      [RF PED 03], [CT-PED-03], [*No cubierta en esta iteración* — prioridad Media y dependencia de un pedido propio localizable.],
      [RF PED 04], [CT-PED-04], [*No cubierta en esta iteración* — el cambio de estado exige permisos administrativos.],
      [RF PED 05], [CT-PED-05], [*No cubierta en esta iteración* — su verificación presupone CT-PED-04, hoy bloqueada.],
      [RNF 01], [CT-RNF-01, CT-RNF-02], [CP-RNF-01],
      [RNF 02], [CT-RNF-03], [CP-RNF-02],
      [RNF 03], [CT-RNF-04, CT-RNF-05], [CP-RNF-03],
    )
  ],
  caption: [Matriz de trazabilidad requisito ↔ condición ↔ caso.],
)

Sin elementos huérfanos: los 24 requisitos tienen al menos una condición y las 33 condiciones tienen
destino (caso asignado o justificación explícita de no cobertura).

== Análisis de cobertura

#figure(
  table(
    columns: (1fr, 2.2cm, 2.2cm, 2.6cm, 4.0cm),
    align: (left, center, center, center, center),
    table.header([Bloque], [Requisitos], [Condiciones], [Condiciones Alta], [Cubiertas por caso diseñado]),
    [FUN 05 Checkout], [5], [7], [6], [5],
    [FUN 06 Confirmación], [4], [6], [6], [6],
    [FUN 07 Admin. productos y stock], [7], [10], [7], [5],
    [FUN 08 Gestión de pedidos], [5], [5], [3], [2],
    [RNF 01–03], [3], [5], [2], [5],
    [*Total*], [*24*], [*33*], [*24*], [*23*],
  ),
  caption: [Análisis de cobertura por bloque funcional.],
)

Cobertura de condiciones por caso diseñado: *23 de 33 (70 %)*; *10 condiciones* quedan fuera de esta
iteración y *9 requisitos* (RF CHK 02, RF CHK 05, RF ADM 01, RF ADM 04, RF ADM 05, RF ADM 06, RF PED 03,
RF PED 04, RF PED 05) no tienen caso asignado.

*Huecos conscientes.* No son aleatorios: se concentran en las condiciones que exigen *escritura en el
panel* (CT-ADM-01, 06, 07, 08; CT-PED-04, 05) y en las de prioridad Media con baja relación
riesgo/esfuerzo frente a los ocho casos asignados (CT-CHK-03, CT-PED-03). Se priorizó cubrir por completo
la cadena transaccional pago → confirmación → visibilidad operativa (FUN 06 y RNF al 100 %), donde se
concentra el riesgo económico y reputacional. Además, *17 de las 33 condiciones dependen de un pedido
completado o de permisos administrativos*: más de la mitad del bloque puede quedar *Bloqueado* si se
ejecuta sobre `demo.opencart.com`. La mitigación planificada es una instancia propia del demo oficial; si
no se concreta, la *tasa de bloqueo* se reportará sobre el total *planificado* —no sobre lo ejecutado—, la
*tasa de aprobación* sobre los casos *ejecutados*, y el hueco se declarará como riesgo residual en el
cierre.

#pagebreak()

// =====================================================================
= Diseño de pruebas
// =====================================================================

== Introducción al diseño

Los ocho casos derivan de las condiciones *CT-XX* del §4, que descomponen los requisitos RF CHK, RF CON,
RF ADM, RF PED y RNF 01–03. La condición dice *qué* comprobar; el caso añade *cómo*, con qué datos y
contra qué resultado verificable. Cada ficha cierra la primera mitad de la cadena
*Requisito ↔ caso ↔ ejecución ↔ defecto*: el eslabón *ejecución* está en §6 y el *defecto* en §7.

Se diseñan los ocho aunque parte del ambiente esté bloqueada: *la ejecutabilidad no condiciona el diseño*.
El caso es el testware contra el que se medirá la corrección y lo que permite repetir la *prueba de
confirmación* cuando un defecto pase a #emph[Listo para reprueba], además de evaluar la *regresión*.
Ninguna ficha contiene resultados: los valores citados son datos de entrada y referencias de ambiente
verificadas el 24-09-2026.

== CP-CHK-01 · Checkout como invitado

#campo[Condición:][CT-CHK-01, 02, 04, 06; CT-CON-06]
#campo[Requisito(s):][RF CHK 01, 03, 04; RF CON 04]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Partición de equivalencia*: los campos admiten infinitos valores, así que se agrupan en clases que el sistema debe tratar igual —válida (completa) e inválida (vacía)— y se prueba un representante de cada una.]
#campo[Precondiciones:][Ventana privada, sin sesión ni carrito previo, desde origen de red autorizado (desde IP de datacenter el demo da HTTP 403).]
#campo[Datos:][iPod Nano (`product_id 36`) × `2`. Invitado `Test` / `QA CS5383` / `qa.cs5383.test@example.com`; `Av. Prueba 123`, `London`, `SW1A 1AA`, `United Kingdom`, `Greater London`. Clase inválida: apellido vacío.]

*Pasos:*

+ Abrir `https://demo.opencart.com/` en ventana privada.
+ Abrir la ficha `product_id=36` (iPod Nano).
+ Fijar cantidad `2`; pulsar #lit[Add to Cart].
+ Abrir el carrito; comprobar que la línea no lleva `***`.
+ Pulsar #lit[Checkout] y seleccionar *Guest Checkout*.
+ Con el apellido vacío y el resto completo, pulsar #lit[Continue].
+ Registrar el mensaje; escribir el apellido `QA CS5383` y pulsar #lit[Continue].
+ Registrar el mensaje del paso.
+ Avanzar a método de envío y de pago; registrar las opciones ofrecidas.

#campo[Resultado esperado:][El flujo avanza sin crear cuenta. Con apellido vacío bloquea e indica el campo; completo, guarda la identidad (#lit[Success: Your guest account information has been saved!]) y ofrece al menos un envío y un pago seleccionables.]
#campo[Criterio de aceptación:][Confirmación alcanzada sin registro, bloqueo específico del campo vacío y envío y pago seleccionables. Si el caso alcanza el selector y no ofrece el pago habilitado, *Falló* (DEF-04). Los casos dependientes que no pueden alcanzar su precondición quedan *Bloqueados*.]

== CP-CON-01 · Generación de número y resumen del pedido

#campo[Condición:][CT-CON-01, 02, 03, 04]
#campo[Requisito(s):][RF CON 01, 02]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Pruebas basadas en casos de uso*: se verifica el recorrido completo de «confirmar una compra» hasta su salida observable —identificador y resumen—, que es donde afloran las discrepancias de totales entre etapas.]
#campo[Precondiciones:][CP-CHK-01 alcanzó la confirmación con envío y pago seleccionados.]
#campo[Datos:][iPod Nano (36) × 2. Referencias del 24-09-2026: Sub-Total `$200.00`, Eco Tax (-2.00) `$4.00`, VAT (20 %) `$40.00`, Total `$244.00`; línea `$242.00`; resumen `2x iPod Nano $242.00`.]

*Pasos:*

+ Capturar el resumen final: descripción, cantidad, importe de línea y los cuatro totales.
+ Comprobar que Sub-Total + Eco Tax + VAT es igual al Total.
+ Comprobar que el importe de línea de `2x iPod Nano` es igual al Sub-Total.
+ Pulsar #lit[Confirm Order] una sola vez.
+ Registrar la URL de destino y el identificador de orden.
+ Comparar campo por campo el resumen confirmado contra el del paso 1.

#campo[Resultado esperado:][Aparece una confirmación con identificador único y no vacío, cuyo resumen repite sin diferencias productos, cantidades, impuestos y Total. Se cumple \$200.00 + \$4.00 + \$40.00 = \$244.00 y el importe de línea iguala al Sub-Total \$200.00; otro valor, como \$242.00, incumple.]
#campo[Criterio de aceptación:][Hay identificador, el Total antes y después de confirmar es idéntico y ningún importe difiere del carrito.]

== CP-CON-02 · Prevención de pedido duplicado

#campo[Condición:][CT-CON-05]
#campo[Requisito(s):][RF CON 03]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Transición de estados*: el proceso tiene estados definidos —#emph[carrito con contenido] → #emph[pedido creado] → #emph[reintento]— y el defecto buscado es una transición inválida: que un evento repetido desde «pedido creado» genere un segundo pedido. Solo el modelo de estados lo hace explícito.]
#campo[Precondiciones:][CP-CON-01 completado, con identificador de orden registrado.]
#campo[Datos:][El pedido de CP-CON-01 (iPod Nano × 2, Total `$244.00`) y su identificador; invitado `qa.cs5383.test@example.com`.]

*Pasos:*

+ Repetir el flujo de CP-CHK-01 hasta la etapa final con los mismos datos.
+ Pulsar #lit[Confirm Order] dos veces, con menos de un segundo entre pulsaciones.
+ Registrar el identificador de orden mostrado.
+ Recargar la confirmación (F5); aceptar el reenvío si se solicita.
+ Registrar si aparece un identificador distinto del paso 3.
+ Pulsar Atrás hasta la confirmación; intentar confirmar de nuevo.
+ Consultar el estado del carrito tras cada intento.

#campo[Resultado esperado:][Los eventos de los pasos 2, 4 y 6 no crean un segundo pedido: se repite el identificador del paso 3 o se redirige a una página neutra (carrito vacío o error controlado). El carrito queda vacío tras confirmar.]
#campo[Criterio de aceptación:][Un solo identificador por recorrido del checkout en los tres reintentos; dos para una misma intención de compra es incumplimiento.]

== CP-ADM-01 · Producto con stock cero reflejado públicamente

#campo[Condición:][CT-ADM-02, 03, 04, 05]
#campo[Requisito(s):][RF ADM 02, 03]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Tabla de decisión*: el comportamiento depende de tres variables combinadas —cantidad, estado publicado y política de venta sin inventario (`Stock Checkout`)—, y es la única técnica que obliga a enunciar la acción esperada de cada combinación.]
#campo[Precondiciones:][Sesión autenticada con escritura en Catalog \> Products y lectura de System \> Settings \> Option \> `Stock Checkout`.]

#figure(
  table(
    columns: (1.6cm, 3.0cm, 3.4cm, 3.0cm, 1fr),
    table.header([Regla], [Cantidad], [Estado publicado], [`Stock Checkout`], [Acción esperada]),
    [R1], [0], [Out Of Stock], [No], [Ficha no disponible; carrito marca `***`; checkout no avanza],
    [R2], [0], [Out Of Stock], [Sí], [Compra sin inventario admitida; el checkout avanza pese al aviso],
    [R3], [Mayor que la pedida], [In Stock], [Indiferente], [Compra permitida, sin `***` ni aviso],
    [R4], [Menor que la pedida], [In Stock], [No], [Carrito marca `***`; checkout no avanza],
  ),
  caption: [Tabla de decisión de CP-ADM-01 (cantidad × estado publicado × política de venta sin inventario).],
)

#campo[Datos:][R1/R2 — *MacBook (43)*, #emph[Out Of Stock], conserva activo #lit[Add to Cart]. R3 — *iPod Nano (36)* × 2. R4 — *HTC Touch HD (28)* e *iPod Touch (32)*, publicados disponibles pero marcados `***`. Aviso: #lit[Products marked with \*\*\* are not available in the desired quantity or not in stock!].]

*Pasos:*

+ Autenticarse en el panel; anotar el valor vigente de `Stock Checkout`.
+ Abrir Catalog \> Products \> MacBook (43); verificar cantidad `0` y #emph[Out Of Stock].
+ Abrir su ficha pública; registrar disponibilidad y estado de #lit[Add to Cart].
+ Pulsar #lit[Add to Cart] y abrir el carrito; registrar si hay `***` y el aviso.
+ Pulsar #lit[Checkout]; registrar si el flujo avanza.
+ Repetir los pasos 3 a 5 con HTC Touch HD (28) e iPod Touch (32) — R4.
+ Repetir los pasos 3 a 5 con iPod Nano (36) × 2 — R3.
+ Contrastar cada resultado con su fila de la tabla de decisión.

#campo[Resultado esperado:][Cada combinación produce la acción de su regla: con `Stock Checkout = No`, R1 y R4 impiden avanzar al checkout y muestran el aviso literal, y R3 avanza sin aviso.]
#campo[Criterio de aceptación:][Las cuatro reglas se cumplen. Que un agotado conserve #lit[Add to Cart] activo solo vale si el bloqueo llega en carrito o checkout; avanzar hasta la confirmación con `Stock Checkout = No` es incumplimiento.]

== CP-PED-01 · Pedido público visible en administración

#campo[Condición:][CT-PED-01, 02]
#campo[Requisito(s):][RF PED 01, 02]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Pruebas basadas en casos de uso*: «preparar un pedido recibido» atraviesa dos interfaces y solo tiene sentido de extremo a extremo: que el mismo pedido sea legible, con igual identificador y detalle, por quien debe despacharlo.]
#campo[Precondiciones:][Existe el pedido de CP-CON-01 con identificador registrado; sesión autenticada con lectura de Sales \> Orders.]
#campo[Datos:][Identificador del pedido de CP-CON-01; correo `qa.cs5383.test@example.com`; detalle esperado iPod Nano (36) × 2 y Total `$244.00`.]

*Pasos:*

+ Anotar la hora de confirmación pública y el identificador del pedido.
+ Autenticarse en `https://demo.opencart.com/TlbeVW/` y abrir Sales \> Orders.
+ Localizar el pedido por su identificador y abrir su detalle.
+ Comparar producto, cantidad, los cuatro totales y los datos del cliente contra el resumen público de
  CP-CON-01.

#campo[Resultado esperado:][El pedido aparece en Sales \> Orders con *el mismo identificador* mostrado al cliente y su detalle reproduce el resumen público sin diferencias: iPod Nano × 2, Total \$244.00.]
#campo[Criterio de aceptación:][Identificador idéntico en ambas vistas; cero diferencias en producto, cantidad e importes.]

== CP-RNF-01 · Sincronización entre sitio y panel

#campo[Condición:][CT-ADM-10; CT-RNF-01, 02]
#campo[Requisito(s):][RNF 01; RF ADM 07]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Transición de estados*: el dato recorre estados observables —#emph[publicado anterior] → #emph[guardado] → #emph[propagado]— y el requisito prohíbe quedarse en «guardado pero no propagado»; modelar los estados hace medible el instante de la transición.]
#campo[Precondiciones:][Sesión autenticada con escritura en Catalog \> Products. *Umbral de sincronización acordado por el equipo antes del diseño: 60 segundos* (CT-RNF-02); es un parámetro acordado, no una medición.]
#campo[Datos:][iPod Nano (36). Cambio: cantidad a `0`, estado a #emph[Out Of Stock]. Reversión: el valor vigente anotado antes del cambio.]

*Pasos:*

+ Abrir la ficha pública de iPod Nano (36); registrar disponibilidad y hora.
+ Abrir Catalog \> Products \> iPod Nano (36); anotar la cantidad vigente.
+ Cambiar la cantidad a `0` y el estado a #emph[Out Of Stock]; guardar y registrar la hora.
+ Sin reiniciar servicios ni limpiar caché, recargar la ficha pública en ventana privada.
+ Repetir la recarga cada 15 segundos hasta ver el valor nuevo o cumplir 60 s.
+ Registrar el tiempo entre el paso 3 y la primera recarga con el valor nuevo.
+ Revertir al valor del paso 2 y verificar su propagación igual.

#campo[Resultado esperado:][El valor nuevo aparece en el sitio público en 60 s o menos desde el guardado, sin reinicio ni intervención técnica; la reversión se propaga igual.]
#campo[Criterio de aceptación:][Propagación ≤ 60 s en cambio y reversión, sin reinicio. Si el guardado se rechaza por permisos (#lit[Warning: You do not have permission to modify…]): *Bloqueado*.]

== CP-RNF-02 · Flujo crítico en navegadores seleccionados

#campo[Condición:][CT-RNF-03]
#campo[Requisito(s):][RNF 02]
#campo[Prioridad:][Media]
#campo[Técnica y justificación:][*Partición de equivalencia*: el universo de navegadores es inabarcable, así que se particiona por motor de renderizado —Chromium (Chrome, Edge) y Gecko (Firefox)—, la variable que produce diferencias reales; Edge se conserva por ser el navegador preinstalado del parque corporativo típico.]
#campo[Precondiciones:][Chrome, Edge y Firefox de escritorio, en ventana privada, con sus versiones anotadas.]
#campo[Datos:][Un único juego para los tres: categoría `Laptops & Notebooks` (`path=18`), iPod Nano (36) × 2 y la identidad y dirección de invitado de CP-CHK-01.]

*Pasos:*

+ Anotar la versión exacta del navegador en uso.
+ Entrar en la categoría; comprobar que los productos se listan con imagen y precio.
+ Abrir la ficha de iPod Nano (36); comprobar precio, disponibilidad y botón #lit[Add to Cart].
+ Añadir cantidad `2` y abrir el carrito; comprobar que línea y totales se renderizan completos.
+ Pulsar #lit[Checkout], elegir Guest Checkout e introducir los datos de prueba.
+ Registrar la etapa alcanzada y todo error bloqueante, con su texto literal.
+ Repetir los pasos 1 a 6 en los tres navegadores; comparar las etapas.

#campo[Resultado esperado:][Catálogo, ficha, carrito y checkout se completan en los tres navegadores sin error bloqueante propio del navegador y se detienen en la misma etapa.]
#campo[Criterio de aceptación:][Cero errores bloqueantes propios de un navegador y comportamiento equivalente entre Chromium y Gecko. Una detención idéntica en los tres por configuración del ambiente es impedimento, no defecto de compatibilidad.]

== CP-RNF-03 · Medición del tiempo de respuesta del catálogo

#campo[Condición:][CT-RNF-04, 05]
#campo[Requisito(s):][RNF 03]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Análisis de valores límite*: el riesgo se concentra junto al umbral, no en el centro de las clases «≤ 1999 ms cumple» y «≥ 2000 ms incumple»; los límites examinados son *1999, 2000 y 2001 ms*, y se exige medir la condición más próxima al límite: la primera visita sin caché.]
#campo[Precondiciones:][Navegador con DevTools, red y equipo declarados, ventana privada. Criterio de medición en §6.9.]
#campo[Datos:][Categorías `Cameras` (`path=33`), `Desktops` (`path=20`), `Laptops & Notebooks` (`path=18`). Umbral `2000 ms`. Métrica principal: carga completa (`loadEventEnd` menos inicio de navegación, Navigation Timing API); apoyo: TTFB, respuesta del HTML y DOMContentLoaded.]

*Pasos:*

+ Abrir ventana privada; deshabilitar la caché en DevTools \> Network. Registrar las cuatro métricas en
  cada medición siguiente.
+ Medición 1: cargar `Cameras` (`path=33`) sin caché.
+ Medición 2: cargar `Desktops` (`path=20`) como navegación subsecuente.
+ Medición 3: cargar `Laptops & Notebooks` (`path=18`) como navegación subsecuente.
+ Medición 4: recargar `Cameras` (`path=33`) con caché habilitada.
+ Anotar red, equipo, hora y número de recursos cargados en la medición 1.
+ Clasificar cada medición contra los límites 1999 / 2000 / 2001 ms; calcular su margen.

#campo[Resultado esperado:][Las cuatro mediciones de carga completa son *estrictamente menores que 2000 ms*; exactamente 2000 ms cuenta como incumplimiento, porque el requisito exige #emph[menos de] dos segundos.]
#campo[Criterio de aceptación:][Cuatro mediciones bajo 2000 ms y criterio documentado —caché, red, equipo y número de mediciones— según CT-RNF-05. Un margen inferior al 5 % del umbral se consigna como riesgo, no como defecto.]

== Tabla resumen de los ocho casos

#figure(
  chico[
    #table(
      columns: (1.9cm, 1.5cm, 3.1cm, 3.5cm, 3.0cm, 1fr),
      table.header([ID], [Prioridad], [Técnica], [Condición], [Requisito(s)], [Ejecutabilidad prevista]),
      [CP-CHK-01], [Alta], [Partición de equivalencia], [CT-CHK-01, 02, 04, 06; CT-CON-06], [RF CHK 01, 03, 04; RF CON 04], [Requiere pedido completado],
      [CP-CON-01], [Alta], [Casos de uso], [CT-CON-01, 02, 03, 04], [RF CON 01, 02], [Requiere pedido completado],
      [CP-CON-02], [Alta], [Transición de estados], [CT-CON-05], [RF CON 03], [Requiere pedido completado],
      [CP-ADM-01], [Alta], [Tabla de decisión], [CT-ADM-02, 03, 04, 05], [RF ADM 02, 03], [Requiere permisos administrativos],
      [CP-PED-01], [Alta], [Casos de uso], [CT-PED-01, 02], [RF PED 01, 02], [Requiere pedido completado],
      [CP-RNF-01], [Alta], [Transición de estados], [CT-ADM-10; CT-RNF-01, 02], [RNF 01; RF ADM 07], [Requiere permisos administrativos],
      [CP-RNF-02], [Media], [Partición de equivalencia], [CT-RNF-03], [RNF 02], [Ejecutable],
      [CP-RNF-03], [Alta], [Análisis de valores límite], [CT-RNF-04, 05], [RNF 03], [Ejecutable],
    )
  ],
  caption: [Resumen de los ocho casos diseñados del bloque.],
)

*Ejecutabilidad.* Dos casos son *Ejecutables* al momento del diseño (CP-RNF-02, CP-RNF-03); cuatro
requieren pedido completado y dos, permisos administrativos. Los seis restantes se declaran *Bloqueados*,
nunca *Fallidos*, y la tasa de bloqueo se calcula sobre los casos *planificados*.

== Especificación de datos de prueba

#figure(
  chico[
    #table(
      columns: (3.4cm, 4.4cm, 2.2cm, 1fr),
      table.header([Dato], [Valor concreto], [¿Volátil?], [Verificación antes de ejecutar]),
      [Producto elegible], [iPod Nano `36`], [Sí], [#emph[In Stock]; añadir 2 unidades y comprobar que no lleva `***`],
      [Cantidad de compra], [`2`], [No], [Fijada por el diseño],
      [Disponibles pero rechazados en carrito], [HTC Touch HD `28`, iPod Touch `32`], [Sí], [Añadirlos y comprobar `***` y el aviso #lit[Products marked with \*\*\* are not available…]],
      [Agotados], [MacBook `43` (conserva #lit[Add to Cart] activo); iPhone `40`, iMac `41`, MacBook Air `44`, MacBook Pro `45`], [Sí], [Confirmar #emph[Out Of Stock] antes de usarlos],
      [Con opción obligatoria, excluidos como dato base], [Product 8 `35` (#lit[Size required!]); Apple Cinema 30" `42` (Radio, Checkbox, Text, Select y Textarea required)], [Bajo], [No usarlos como sustitutos: añaden una variable ajena],
      [Identidad de invitado], [`Test` / `QA CS5383` / `qa.cs5383.test@example.com`], [No], [Ficticia, definida por el equipo],
      [Dirección de invitado], [`Av. Prueba 123`, `London`, `SW1A 1AA`, `United Kingdom`, `Greater London`], [No], [País y región presentes en los desplegables],
      [Totales de referencia (2 × iPod Nano)], [Sub-Total `$200.00`; Eco Tax (-2.00) `$4.00`; VAT (20 %) `$40.00`; Total `$244.00`], [Sí], [Recapturar el carrito ese día y comparar],
      [Credenciales administrativas], [`demo` / `demo` en `https://demo.opencart.com/TlbeVW/`], [Permisos volátiles], [Probar un guardado inocuo; ante #lit[Warning: You do not have permission to modify…] los casos de escritura nacen Bloqueados],
      [`Stock Checkout`], [System \> Settings \> Option], [Sí], [Anotar el valor al inicio y al final; sin él la tabla de decisión de CP-ADM-01 no es interpretable],
      [Identificador del pedido de referencia], [Generado en CP-CON-01], [Sí], [Anotarlo con su hora; es clave de CP-CON-02 y CP-PED-01],
      [Categorías de medición], [`Cameras 33`, `Desktops 20`, `Laptops & Notebooks 18`], [Bajo], [La categoría lista productos],
      [Umbrales], [`2000 ms` de carga completa; `60 s` de sincronización], [No], [RNF 03 y acuerdo previo del equipo (CT-RNF-02)],
      [Origen de red], [Navegador local del responsable], [Sí], [La portada carga; desde IP de datacenter responde HTTP 403],
    )
  ],
  caption: [Especificación de datos de prueba del bloque.],
)

*Regla común a todo dato volátil:* se registra el valor observado y su hora en la bitácora de ambiente
(Anexo A, §11.1) antes de ejecutar; sin esa entrada del día la ejecución no es válida.

== Técnicas de diseño aplicadas

#figure(
  table(
    columns: (4.4cm, 3.6cm, 1fr),
    table.header([Técnica de caja negra], [Casos donde se aplica], [Qué particiona o modela]),
    [Partición de equivalencia], [CP-CHK-01, CP-RNF-02], [Clases de valor por campo (válida completa / inválida vacía) y clases de motor de renderizado (Chromium / Gecko)],
    [Análisis de valores límite], [CP-RNF-03], [Umbral de 2 s: límites 1999, 2000 y 2001 ms],
    [Tabla de decisión], [CP-ADM-01], [Combinación de cantidad, estado publicado y política de venta sin inventario (`Stock Checkout`), reglas R1 a R4],
    [Transición de estados], [CP-CON-02, CP-RNF-01], [Carrito → pedido creado → reintento; publicado anterior → guardado → propagado],
    [Pruebas basadas en casos de uso], [CP-CON-01, CP-PED-01], [Recorrido de extremo a extremo de «confirmar una compra» y de «preparar un pedido recibido»],
  ),
  caption: [Técnicas de diseño aplicadas y su ámbito en el bloque.],
)

#pagebreak()

// =====================================================================
= Ejecución manual
// =====================================================================

Fecha de ejecución: 24-09-2026 · Sistema: OpenCart Demo 4.0.2.3 (`demo.opencart.com`) · Ambiente: Anexo A
(§11.1). Origen de acceso: navegador local del responsable (el entorno automatizado estaba bloqueado por
Cloudflare).

== Datos de prueba utilizados

#figure(
  table(
    columns: (5.0cm, 1fr),
    table.header([Dato], [Valor]),
    [Producto elegible], [iPod Nano (`product_id 36`) — único sin advertencia de stock entre los evaluados],
    [Cantidad], [2],
    [Identidad de invitado], [`Test` / `QA CS5383` / `qa.cs5383.test@example.com` (ficticios)],
    [Dirección], [`Av. Prueba 123`, `London`, `SW1A 1AA`, `United Kingdom`, `Greater London`],
  ),
  caption: [Datos de prueba efectivamente utilizados en la ejecución del 24-09-2026.],
)

== Estado del catálogo observado (24-09-2026)

#figure(
  table(
    columns: (6.0cm, 3.2cm, 1fr),
    table.header([Producto], [Disponibilidad publicada], [Observación]),
    [HTC Touch HD (28)], [In Stock], [Rechazado por control de stock en el carrito (`***`)],
    [iPod Nano (36)], [In Stock], [Aceptado, sin advertencia],
    [Product 8 (35)], [In Stock], [Exige opción: #lit[Size required!]],
    [Apple Cinema 30" (42)], [In Stock], [Exige Radio, Checkbox, Text, Select y Textarea required],
    [iPhone (40), iMac (41), MacBook (43), MacBook Air (44), MacBook Pro (45)], [Out Of Stock], [MacBook conserva botón #lit[Add to Cart] activo],
    [Canon EOS 5D (30), Nikon D300 (31), iPod Touch (32), Palm Treo Pro (29)], [2-3 Days], [iPod Touch rechazado por stock en carrito (`***`)],
  ),
  caption: [Estado del catálogo observado el 24-09-2026 (ambiente compartido y volátil).],
)

#page(flipped: true)[
  == Resultados por caso: esperado, obtenido y veredicto

  #figure(
    chico[
      #table(
        columns: (3.4cm, 5.2cm, 1fr, 2.9cm, 3.6cm),
        table.header([Caso], [Resultado esperado], [Resultado obtenido], [Veredicto], [Causa]),
        [CP-CHK-01 Checkout como invitado], [El flujo continúa sin exigir creación de cuenta y permite completar la compra], [Guest Checkout disponible; datos guardados con #lit[Success: Your guest account information has been saved!]; el flujo se detiene antes del pago: #lit[No Payment options are available. Please contact us for assistance!] y no existe sección #lit[Shipping Method]], [#veredicto("Bloqueado", detalle: [(parcialmente verificado)])], [Ambiente sin métodos de pago ni envío configurados],
        [CP-CON-01 Generación de número y resumen del pedido], [Se crea un único número de orden y se muestra confirmación], [#lit[Confirm Order] no genera pedido, no navega y no emite mensaje alguno], [#veredicto("Bloqueado")], [Dependencia de CP-CHK-01],
        [CP-CON-02 Prevención de pedido duplicado], [Doble clic o recarga no generan dos órdenes], [No ejecutable: no es posible generar una primera orden], [#veredicto("Bloqueado")], [Dependencia de CP-CON-01],
        [CP-ADM-01 Stock cero reflejado públicamente], [El sitio público impide comprar el producto agotado], [Pendiente: requiere sesión administrativa autenticada por el responsable], [#veredicto("Pendiente")], [Login manual no realizado aún],
        [CP-PED-01 Pedido público visible en administración], [El pedido aparece en Sales \> Orders con el mismo identificador], [No ejecutable: no existe pedido que consultar], [#veredicto("Bloqueado")], [Dependencia de CP-CON-01],
        [CP-RNF-01 Sincronización sitio–panel], [El cambio administrativo se refleja en el sitio público sin reinicio], [Pendiente: requiere permisos de escritura en el panel], [#veredicto("Pendiente")], [Login manual + permisos],
        [CP-RNF-02 Flujo crítico en navegadores], [El flujo se completa en los navegadores seleccionados], [Pendiente], [#veredicto("Pendiente")], [Falta ejecución multi-navegador],
        [CP-RNF-03 Tiempo de respuesta del catálogo], [Respuesta menor a 2 segundos], [Pendiente], [#veredicto("Pendiente")], [Falta medición instrumentada],
      )
    ],
    caption: [Registro de ejecución del 24-09-2026: resultado esperado, obtenido y veredicto por caso.],
  )
]

#figure(image("evidencias/gestion-20260924/OC-05_checkout-sin-pago.jpg", width: 100%, height: 13cm, fit: "contain"), caption: [E-03: selector sin métodos de pago, datos ficticios y botón Confirm Order deshabilitado. Verificación complementaria; no constituye una ejecución completa adicional.])

== Observación metodológica de la ejecución

Los veredictos *Bloqueado* se sustentan en impedimentos del ambiente registrados en bitácora con texto
literal del sistema, no en supuestos. Ninguno se contabiliza como aprobado ni como fallido.

*Denominadores.* La *tasa de bloqueo* se calcula sobre los casos *planificados*; la *tasa de aprobación*,
sobre los casos *ejecutados*; y el *% de alta prioridad ejecutada*, sobre los casos de prioridad Alta
planificados. Los tres denominadores se fijan en §8.1.1 y no se mezclan entre sí. Las cifras del primer
corte de la jornada —antes del acceso al panel administrativo— quedan registradas en §8.4 a título de
trazabilidad del análisis; *las cifras válidas del bloque son las del cierre*, consolidadas en §8.6:
tasa de ejecución 25.0 %, tasa de aprobación 50.0 % y tasa de bloqueo 62.5 %.

*Trazabilidad.* Este registro es el eslabón *ejecución* de la cadena
*Requisito ↔ caso ↔ ejecución ↔ defecto*. La condición de prueba (CT) queda como paso intermedio del
análisis en §4; los defectos derivados de esta ejecución están en §7.

*Estado frente a los criterios de salida.* El cierre no se expresa con una etiqueta, sino como estado
frente a los criterios declarados en §8.1. Al cierre del 24-09-2026 *no se cumplen CS1, CS2 ni CS3* —2 de
7 casos de prioridad Alta ejecutados, 50.0 % de aprobación frente al umbral de 90 % y un defecto crítico
abierto (DEF-04)—, de modo que *el release no está listo*. CS4 se cumple, en el límite de dos defectos
altos abiertos.

*Prueba de confirmación y regresión.* Cuando un defecto pase al estado *Listo para reprueba*, se repetirá
el caso que falló mediante *prueba de confirmación*, y se evaluarán *pruebas de regresión* sobre los casos
que comparten precondiciones.

== Actualización de veredictos tras el acceso al panel administrativo (24-09-2026)

La verificación administrativa (Extensions \> Payments y Extensions \> Shipping) demostró que los métodos
de pago y envío están habilitados y sin restricción de zona. Por lo tanto, la imposibilidad de pagar *no es
una limitación del ambiente sino el defecto DEF-04*. Esto cambia los veredictos previos:

#figure(
  chico[
    #table(
      columns: (3.0cm, 3.0cm, 3.9cm, 1fr),
      table.header([Caso], [Veredicto anterior], [Veredicto actualizado], [Sustento]),
      [CP-CHK-01], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Falló")], [RF CHK 01 exige completar la compra sin crear cuenta; el sistema lo impide por DEF-04. Además arrastra DEF-01 en los importes],
      [CP-CON-01], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Bloqueado", detalle: [por defecto DEF-04])], [No es posible confirmar un pedido mientras el sitio no ofrezca método de pago],
      [CP-CON-02], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Bloqueado", detalle: [por defecto DEF-04])], [Requiere una primera orden existente],
      [CP-PED-01], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Bloqueado", detalle: [por defecto DEF-04])], [Requiere una orden propia rastreable],
      [CP-RNF-03], [#veredicto("Pendiente")], [#veredicto("Pasó")], [Cuatro mediciones bajo el umbral; ver §6.9],
      [CP-RNF-02], [#veredicto("Pendiente")], [#veredicto("Parcialmente ejecutado")], [Flujo crítico verificado en Chrome; faltan Edge y Firefox],
      [CP-ADM-01], [#veredicto("Pendiente")], [#veredicto("Pendiente")], [Requiere escritura en el panel (cambio de stock a cero)],
      [CP-RNF-01], [#veredicto("Pendiente")], [#veredicto("Pendiente")], [Requiere escritura en el panel para medir la propagación],
    )
  ],
  caption: [Actualización de veredictos del 24-09-2026 tras la verificación administrativa.],
)

== Datos administrativos verificados (lectura, 24-09-2026)

#figure(
  table(
    columns: (5.4cm, 3.4cm, 1fr),
    table.header([Producto], [Cantidad en panel], [Disponibilidad publicada en el sitio]),
    [HTC Touch HD], [0], [#lit[In Stock] — contradice el inventario real],
    [Canon EOS 5D], [0], [#lit[2-3 Days]],
    [iPod Touch], [0], [#lit[2-3 Days]],
    [iPhone, iMac, iPod Classic, iPod Shuffle], [0], [#lit[Out Of Stock]],
    [iPod Nano], [147], [#lit[In Stock] (coherente)],
    [Apple Cinema 30"], [447], [#lit[In Stock] (coherente)],
    [HP LP3065], [1000], [—],
  ),
  caption: [Contraste inventario del panel frente a disponibilidad publicada (lectura del 24-09-2026).],
)

Este contraste es la evidencia directa de *DEF-02*: el sitio publica etiquetas de disponibilidad que no
corresponden al inventario registrado en el panel, y la validación real recién ocurre en el carrito.

#figure(image("evidencias/gestion-20260924/OC-03_stock-configurado.jpg", width: 100%, height: 13cm, fit: "contain"), caption: [E-05 parcial: formulario de product_id 28 con Quantity = 0 y Out Of Stock Status = In Stock. La captura documenta el formulario abierto; no prueba una escritura ni sustituye la lista completa de inventario.])

== Métricas parciales al 24-09-2026

#block(width:100%, inset:8pt, radius:3pt, fill: rgb("#fff8e1"), stroke: 0.5pt + rgb("#c8a12a"))[
  *Cifras parciales.* Corresponden al corte previo al cierre de la jornada (§6.8), cuando CP-ADM-01 y
  CP-RNF-01 aún figuraban como Pendiente. Las cifras definitivas del bloque están en §8.6: tasa de
  ejecución 25.0 %, tasa de aprobación 50.0 % y tasa de bloqueo 62.5 %.
]

- Casos *planificados*: 8
- Casos *ejecutados*: 2 (CP-CHK-01, CP-RNF-03) + 1 parcial (CP-RNF-02)
- *Tasa de bloqueo* = 3 / 8 = *37.5 %* (sobre planificados)
- *Tasa de aprobación* = 1 / 2 = *50.0 %* (sobre ejecutados)
- Defectos abiertos: 1 crítico (DEF-04), 2 altos (DEF-01, DEF-02), 1 medio (DEF-03)

Estado frente a los criterios de salida en ese corte: *CS1 no se cumple* (no todos los casos de alta
prioridad se ejecutaron), *CS2 no se cumple* (50 % contra el umbral de 90 % de los ejecutados), *CS3 no se
cumple* (existe un defecto crítico abierto), *CS4 se cumple* (2 defectos altos abiertos, el máximo
admitido). Con tres de los cuatro criterios incumplidos y el flujo de compra inutilizable, *el release no
está listo*.

== Cierre de ejecución — 24-09-2026, 02:45

Intento de ejecución de CP-ADM-01 sobre el producto HP LP3065 (`product_id 47`), estado previo verificado
`Quantity = 1000`, `Out Of Stock Status = Out Of Stock`, `Subtract Stock` activo.

#figure(
  chico[
    #table(
      columns: (2.4cm, 4.4cm, 1fr, 3.6cm),
      table.header([Caso], [Resultado esperado], [Resultado obtenido], [Veredicto]),
      [CP-ADM-01], [Al fijar la cantidad en cero y guardar, el sitio público refleja la falta de disponibilidad], [El panel rechaza la operación: *#lit[Warning: You do not have permission to modify products!]*. El valor no se persiste], [#veredicto("Bloqueado", detalle: [(permisos del ambiente)])],
      [CP-RNF-01], [El cambio administrativo se refleja en el sitio público dentro del umbral acordado], [No ejecutable: no es posible provocar un cambio administrativo que medir], [#veredicto("Bloqueado", detalle: [(dependencia de CP-ADM-01)])],
    )
  ],
  caption: [Cierre de ejecución del 24-09-2026 a las 02:45: CP-ADM-01 y CP-RNF-01.],
)

El ambiente no fue modificado; no se requirió restaurar datos.

#figure(
  image("evidencias/CP-ADM-01/CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png", width: 100%),
  caption: [CP-ADM-01, paso 03 — el panel administrativo rechaza el guardado con el mensaje literal
  #lit[Warning: You do not have permission to modify products!]. El formulario conserva `Quantity = 1000`
  y `Out Of Stock Status = Out Of Stock`: el cambio no se persistió. Evidencia
  `evidencias/CP-ADM-01/CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png` (24-09-2026).],
)

== Mediciones de CP-RNF-03 (RNF 03)

Requisito *RNF 03*: el catálogo debe responder en menos de dos segundos. Fecha: 24-09-2026. Origen:
navegador local del responsable. Sistema: `demo.opencart.com`.

=== Criterio de medición declarado

Se mide *carga completa de la página de categoría* (`loadEventEnd` menos inicio de navegación, Navigation
Timing API del navegador), por ser el instante en que el cliente dispone del catálogo completo. Se
registran también TTFB (`responseStart - requestStart`), respuesta del HTML
(`responseEnd - requestStart`) y DOMContentLoaded, para separar tiempo de servidor de tiempo de render. Se
realizan cuatro mediciones, incluyendo una primera visita sin caché.

=== Resultados

#figure(
  chico[
    #table(
      columns: (0.8cm, 2.7cm, 2.5cm, 1.3cm, 1.3cm, 2.5cm, 2.1cm, 1fr),
      align: (center, left, left, right, right, right, right, left),
      table.header([N.º], [Categoría], [Condición], [TTFB], [HTML], [DOMContentLoaded], [Carga completa], [¿\< 2000 ms?]),
      [1], [Cameras (`path=33`)], [Primera visita, sin caché], [862 ms], [863 ms], [1339 ms], [*1932 ms*], [Sí (margen 68 ms)],
      [2], [Desktops (`path=20`)], [Navegación subsecuente], [434 ms], [437 ms], [595 ms], [*1757 ms*], [Sí],
      [3], [Laptops & Notebooks (`path=18`)], [Navegación subsecuente], [420 ms], [422 ms], [523 ms], [*898 ms*], [Sí],
      [4], [Cameras (`path=33`)], [Repetición con caché], [401 ms], [403 ms], [494 ms], [*645 ms*], [Sí],
    )
  ],
  caption: [Mediciones de tiempo de respuesta del catálogo (CP-RNF-03, 24-09-2026).],
)

Recursos cargados en la medición 1: *17*.

=== Veredicto

#veredicto("Pasó") Las cuatro mediciones cumplen el umbral de dos segundos.

=== Hallazgo de confirmación (no es defecto)

La primera visita sin caché queda *a 68 ms del umbral* (1932 ms contra 2000 ms), mientras que la misma
página con caché responde en 645 ms. El requisito se cumple, pero el margen en la peor condición observada
es de apenas *3.4 %*: cualquier degradación de red o de servidor lo incumple. Se recomienda fijar con el
negocio si el umbral aplica a la primera visita o a la navegación con caché, ya que el resultado depende
por completo de esa definición.

=== Limitación de la medición

Mediciones tomadas desde una única red y un único equipo, sin control sobre la carga concurrente del demo
público. No sustituyen una prueba de rendimiento formal; sirven como verificación puntual del requisito no
funcional.

#pagebreak()

// =====================================================================
= Reporte de hallazgos y defectos
// =====================================================================

== Convenciones del reporte

Nomenclatura aplicada: *`[Módulo / Funcionalidad] + [Qué falla] + [Bajo qué condición]`*.

*Severidad* = impacto técnico/funcional evaluado por QA. *Prioridad* = urgencia de atención definida por
negocio (Product Owner). Son *dos ejes independientes* y por eso van en campos separados.

Escala declarada por el equipo: *Crítica · Alta · Media · Baja*. El CTFL no impone una escala: cada
organización define la suya, y lo esencial es usar la misma escala con el mismo significado en todos los
defectos.

*Responsabilidad de clasificación.* Las prioridades de los cuatro defectos son propuestas de QA pendientes de ratificación del Product Owner; no consta triage ni aprobación del negocio. La escala de severidad usa Crítica (interrumpe el flujo transaccional probado), Alta (inconsistencia funcional importante), Media (degrada la interacción) y Baja (cosmética). La prioridad Alta solicita atención inmediata, Media el siguiente ciclo y Baja atención diferible.

Trazabilidad: *Requisito ↔ caso ↔ ejecución ↔ defecto*; la condición de prueba (CT) se conserva como paso
intermedio del análisis.

=== Ciclo de vida del defecto aplicado

*Cadena principal:* Nuevo → En análisis → Asignado → En corrección → *Listo para reprueba* → Cerrado.

*Ramas:* desde «En análisis»: *Rechazado · Duplicado · Diferido*. Desde «Listo para reprueba»:
*Reabierto → En corrección*.

#figure(
  block(width: 100%, breakable: false)[
    #let s = 0.52cm
    // --- Cadena principal ---
    #grid(
      columns: (1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr),
      align: center + horizon,
      caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"), tam: 7.2pt)[*Nuevo*], flecha-h,
      caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"), tam: 7.2pt)[*En análisis*], flecha-h,
      caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"), tam: 7.2pt)[*Asignado*], flecha-h,
      caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"), tam: 7.2pt)[*En corrección*], flecha-h,
      caja(fondo: C-BLOQ.fondo, borde: C-BLOQ.borde, tam: 7.2pt)[*Listo para reprueba*], flecha-h,
      caja(fondo: C-PASO.fondo, borde: C-PASO.borde, tam: 7.2pt)[*Cerrado*],
    )
    #v(3pt)
    // --- Flechas de bajada hacia las ramas ---
    #grid(
      columns: (1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr),
      align: center,
      [], [], flecha-v, [], [], [], [], [], flecha-v, [], [],
    )
    #v(2pt)
    // --- Ramas ---
    #grid(
      columns: (1fr, 0.8cm, 1fr),
      align: horizon,
      block(width: 100%, inset: 6pt, radius: 3pt, stroke: (paint: luma(170), dash: "dashed"))[
        #set align(center)
        #text(size: 7.4pt, fill: luma(80))[Ramas desde «En análisis» — el defecto no llega a corrección]
        #v(4pt)
        #grid(
          columns: (1fr, 4pt, 1fr, 4pt, 1fr),
          caja(fondo: C-PARC.fondo, borde: C-PARC.borde, tam: 7.2pt)[*Rechazado*], [],
          caja(fondo: C-PARC.fondo, borde: C-PARC.borde, tam: 7.2pt)[*Duplicado*], [],
          caja(fondo: C-PARC.fondo, borde: C-PARC.borde, tam: 7.2pt)[*Diferido*],
        )
      ],
      [],
      block(width: 100%, inset: 6pt, radius: 3pt, stroke: (paint: luma(170), dash: "dashed"))[
        #set align(center)
        #text(size: 7.4pt, fill: luma(80))[Rama desde «Listo para reprueba» — la prueba de confirmación falla]
        #v(4pt)
        #grid(
          columns: (1fr, 0.52cm, 1fr),
          align: center + horizon,
          caja(fondo: C-FALLO.fondo, borde: C-FALLO.borde, tam: 7.2pt)[*Reabierto*], flecha-h,
          caja(fondo: rgb("#e9f1f8"), borde: rgb("#1c4f74"), tam: 7.2pt)[*En corrección*],
        )
      ],
    )
  ],
  kind: image,
  supplement: [Figura],
  caption: [Ciclo de vida del defecto aplicado en este bloque: cadena principal y ramas. El paso a «Listo para reprueba» dispara la #emph[prueba de confirmación]; su resultado decide entre «Cerrado» y «Reabierto».],
)

Los cuatro defectos de este informe están en estado *Nuevo*: ninguno ha pasado por triage, corrección ni
*prueba de confirmación*.

#nota[
  *Listo para reprueba → prueba de confirmación:* se repite el caso que falló. Las *pruebas de regresión*
  son distintas: evitan que la corrección rompa otra cosa. (El término «re-testing» no se usa en este
  proyecto.)

  *Rechazado* aparece más de lo que parece: malentendido del requisito, problema de entorno o de datos, o
  comportamiento esperado.

  *Severidad* (grado de impacto; la propone el tester) y *prioridad* (urgencia de corregir; la define el
  Product Owner o el negocio) son dos ejes independientes y no se fusionan en un solo campo.
]

== DEF-01 · `[Carrito y resumen de checkout]` El total de línea difiere de precio unitario × cantidad, mostrando \$242.00 en lugar de \$244.00 para 2 unidades

#campo[Trazabilidad:][RF CAR 03 / RF CHK 05 / RF CON 02 ↔ CP-CHK-01 ↔ ejecución del 24-09-2026 (§6) ↔ DEF-01 · condición de prueba intermedia: CT-CHK-05]

#campo[Identidad y entorno:][Reportante del registro: Granit, Analista QA. Fecha: 24-09-2026. OpenCart Demo 4.0.2.3; sitio público y panel, Chrome en macOS. Versión exacta de Chrome del registro original no consignada; no se inventa. Caso y requisito en la trazabilidad superior.]

*Pasos para reproducir:*

+ Agregar iPod Nano al carrito.
+ Fijar cantidad 2.
+ Abrir Shopping Cart.
+ Continuar a Checkout y observar el resumen.

#campo[Resultado esperado:][El total de línea es coherente con precio unitario × cantidad y con el total general.]
#campo[Resultado obtenido:][Mini-carrito #lit[iPod Nano x 2 — \$244.00]; tabla del carrito #lit[Unit Price \$122.00 / Total \$242.00]; resumen de checkout #lit[2x iPod Nano \$242.00]; Total general #lit[\$244.00]. Desglose: Sub-Total \$200.00 + Eco Tax (-2.00) \$4.00 + VAT (20 %) \$40.00 = \$244.00. La diferencia es compatible con aplicar el Eco Tax una sola vez (200 + 40 + 2 = 242); es una hipótesis, no una causa raíz confirmada.]
#campo[Severidad:][*Alta* (dos importes contradictorios para la misma compra, en la misma pantalla, arrastrados hasta el resumen del pedido)]
#campo[Prioridad:][*Alta* (afecta la confianza en el monto a pagar y el margen del negocio)]
#campo[Evidencia:][`evidencias/CP-CHK-01/` — captura del resumen de checkout con ambas cifras visibles]
#campo[Estado:][Nuevo]
#campo[Fecha:][24-09-2026]

#figure(image("evidencias/gestion-20260924/OC-04_carrito-importes.jpg", width: 100%, height: 13cm, fit: "contain"), caption: [E-01: carrito reproducido con 2 iPod Nano; precio unitario USD 122, línea USD 242 y total USD 244. Captura complementaria del 24-09-2026.])

== DEF-02 · `[Ficha de producto y carrito]` Un producto publicado como #lit[In Stock] es rechazado por el control de inventario al llegar al carrito y bloquea el checkout

#campo[Trazabilidad:][RF PRO 01 / RF PRO 05 / RF ADM 03 / RF CHK 01 ↔ CP-CHK-01 ↔ ejecución del 24-09-2026 (§6) ↔ DEF-02 · condición de prueba intermedia: CT-ADM-03]

#campo[Identidad y entorno:][Reportante del registro: Granit, Analista QA. Fecha: 24-09-2026. OpenCart Demo 4.0.2.3; sitio público y panel, Chrome en macOS. Versión exacta de Chrome del registro original no consignada; no se inventa. Caso y requisito en la trazabilidad superior.]

*Pasos para reproducir:*

+ Abrir HTC Touch HD (`product_id 28`); la ficha indica #lit[Availability: In Stock].
+ Agregar al carrito.
+ Abrir Shopping Cart.
+ Pulsar Checkout.

#campo[Resultado esperado:][Un producto publicado como disponible puede comprarse, o bien la ficha informa la indisponibilidad antes de agregarlo.]
#campo[Resultado obtenido:][El carrito marca el producto con `***` y muestra #lit[Products marked with \*\*\* are not available in the desired quantity or not in stock!]. El intento de checkout devuelve al carrito. El mismo comportamiento se reprodujo con iPod Touch (32).]
#campo[Severidad:][*Alta* (inconsistencia entre disponibilidad publicada e inventario real; la validación se ejecuta tarde y bloquea la venta)]
#campo[Prioridad:][*Alta* (es exactamente la queja de negocio que originó el caso: clientes que compran productos sin stock real)]
#campo[Evidencia:][`evidencias/CP-CHK-01/`]
#campo[Estado:][Nuevo]
#campo[Fecha:][24-09-2026]

#evidencia-pendiente("E-02")[Carrito mostrando el producto marcado con `***` y el mensaje de stock #lit[Products marked with \*\*\* are not available in the desired quantity or not in stock!] (sustento de DEF-02).]

== DEF-03 · `[Checkout]` El botón #lit[Confirm Order] no entrega retroalimentación al usuario cuando no existe método de pago disponible

#campo[Trazabilidad:][RF CHK 04 / RF CON 01 ↔ CP-CON-01 ↔ ejecución del 24-09-2026 (§6) ↔ DEF-03 · condición de prueba intermedia: CT-CON-01]

#campo[Identidad y entorno:][Reportante del registro: Granit, Analista QA. Fecha: 24-09-2026. OpenCart Demo 4.0.2.3; sitio público y panel, Chrome en macOS. Versión exacta de Chrome del registro original no consignada; no se inventa. Caso y requisito en la trazabilidad superior.]

*Pasos para reproducir:*

+ Completar Guest Checkout con datos válidos.
+ Sin método de pago seleccionable, pulsar #lit[Confirm Order].

#campo[Resultado esperado:][El sistema impide la confirmación e informa explícitamente qué falta.]
#campo[Resultado obtenido:][La acción no produce navegación, ni pedido, ni mensaje. Solo persiste el aviso previo del módulo de pago.]
#campo[Severidad:][*Media* (falta de retroalimentación ante acción bloqueada)]
#campo[Prioridad:][*Media* (impacta la experiencia, no el dinero)]
#campo[Nota de alcance:][tal como se registró originalmente, la ausencia de métodos de pago se consideró una *limitación del ambiente*, no un defecto del producto; el defecto reportado en DEF-03 es la falta de retroalimentación. La clasificación de la ausencia de métodos de pago fue posteriormente revisada y reclasificada como DEF-04 (§7.6).]
#campo[Estado:][Nuevo]
#campo[Fecha:][24-09-2026]

== DEF-04 · `[Checkout / Sincronización sitio–panel]` El sitio público no ofrece ningún método de pago pese a que el panel administrativo tiene Cash On Delivery habilitado para todas las zonas geográficas

#campo[Trazabilidad:][RF CHK 04 / RF CON 01 / RF ADM 07 / RNF 01 → CT-CHK-04, CT-RNF-01 → CP-CHK-01, CP-CON-01, CP-RNF-01 → ejecución del 24-09-2026 → DEF-04]

#campo[Identidad y entorno:][Reportante del registro: Granit, Analista QA. Fecha: 24-09-2026. OpenCart Demo 4.0.2.3; sitio público y panel, Chrome en macOS. Versión exacta de Chrome del registro original no consignada; no se inventa. Caso y requisito en la trazabilidad superior.]

*Pasos para reproducir:*

+ Agregar iPod Nano (`product_id 36`) al carrito, cantidad 2.
+ Ir a Checkout y seleccionar Guest Checkout.
+ Completar los datos obligatorios (probado con dirección de Reino Unido y de Estados Unidos).
+ Pulsar Continue; el sistema responde #lit[Success: Your guest account information has been saved!].
+ Pulsar #lit[Choose] en Payment Method.

#campo[Resultado esperado:][Se ofrece al menos el método habilitado en el panel (Cash On Delivery), permitiendo continuar hasta la confirmación del pedido.]
#campo[Resultado obtenido:][#lit[No Payment options are available. Please contact us for assistance!]. No se renderiza sección #lit[Shipping Method]. La consulta directa al recurso `index.php?route=checkout/payment_method` responde *HTTP 200 con cuerpo vacío*. El comportamiento se reproduce con dos países distintos, lo que reduce la hipótesis de una restricción específica de esos países, sin demostrar una causa raíz.]

*Evidencia contrastada en el panel administrativo (24-09-2026):*

- Extensions \> Payments: *Cash On Delivery = Enabled* (Sort Order 5), Free Checkout = Enabled, Bank
  Transfer = Disabled, Cheque / Money Order = Disabled.
- Configuración de Cash On Delivery: *Geo Zone = All Zones*, Order Status = Pending.
- Extensions \> Shipping: *Flat Rate = Enabled*, Cost 5.00, *Geo Zone = All Zones*.
- Sales \> Orders contiene pedidos recientes (el más nuevo, 3639 del 23/09/2026 por \$740.00), lo que
  demuestra que el flujo sí operó antes.

#campo[Severidad:][*Crítica* propuesta por QA (bloquea el recorrido transaccional probado; alcance global y causa raíz pendientes de triage)]
#campo[Prioridad:][*Alta* (riesgo de pérdida de ventas en el recorrido afectado; pendiente de ratificación por negocio)]
#campo[Estado:][Nuevo]
#campo[Impacto sobre el alcance de pruebas:][bloquea CP-CON-01, CP-CON-02 y CP-PED-01. Estos casos se registran como *bloqueados por defecto*, no como bloqueados por ambiente.]
#campo[Fecha:][24-09-2026]

#figure(image("evidencias/gestion-20260924/OC-02_cod-todas-zonas.jpg", width: 100%, height: 13cm, fit: "contain"), caption: [E-04: Cash On Delivery habilitado con Geo Zone = All Zones. Consulta de configuración sin guardar cambios.])

== OBS-01 · Limitación de ambiente (no es defecto de producto) y su corrección registrada

*OBS-01 (registro original).* El demo público no tiene métodos de pago ni de envío configurados:
#lit[No Payment options are available. Please contact us for assistance!] y no se renderiza la sección
#lit[Shipping Method]. Esto bloquea CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01. Registrado en la bitácora
de ambiente (Anexo A, §11.1).

#nota[
  *Corrección a OBS-01 (registrada el 24-09-2026, posterior a la verificación administrativa).* OBS-01
  clasificaba la ausencia de métodos de pago como *limitación del ambiente*. La verificación en el panel
  administrativo descartó esa hipótesis: los métodos están habilitados y sin restricción de zona. La
  observación se reclasifica como el defecto *DEF-04*. Se conserva el registro original para dejar
  trazable la evolución del análisis: una hipótesis inicial razonable, refutada con evidencia posterior,
  es parte del proceso de análisis y no se oculta.
]

== OBS-02 · Referencia cruzada al bloque del Integrante 1

Productos marcados #lit[Out Of Stock] (MacBook, iPhone, iMac) conservan el botón #lit[Add to Cart] activo.
Pertenece a FUN-02, bloque de Franco; se documenta aquí solo por su efecto sobre el flujo de checkout.

== OBS-03 · Señal a investigar sobre duplicación de pedidos (no confirmada)

En Sales \> Orders se observan las órdenes *3633, 3634 y 3635*, todas del cliente #lit[John smith], todas
por *\$105.00* y todas con fecha *21/09/2026*. Es un patrón compatible con el riesgo de duplicación que
evalúa CP-CON-02, pero el demo es un ambiente compartido y esas órdenes pueden provenir de pruebas
legítimas repetidas por terceros. *No se declara defecto*: se registra como señal a verificar cuando
DEF-04 permita generar pedidos propios.

== OBS-04 · Dato pendiente de verificación controlada

El intento de agregar al carrito un producto agotado (iPhone, `product_id 40`,
#lit[Availability: Out Of Stock]) no modificó el contenido del carrito en la sesión del 24-09-2026, a
diferencia de lo observado por el equipo el 18-09-2026. La discrepancia puede deberse a la interacción o
al estado del demo. *Pendiente de reejecución controlada* antes de afirmar cualquier comportamiento.
Pertenece al bloque del Integrante 1.

== Bloqueo de CP-ADM-01 por permisos del ambiente (no es defecto del producto)

El 24-09-2026 a las 02:45, en el panel administrativo autenticado con el usuario `demo`, el intento de
fijar `Quantity = 0` en el producto HP LP3065 y guardar produjo el mensaje literal
*#lit[Warning: You do not have permission to modify products!]*. El cambio *no se persistió*: el
formulario conserva `Quantity = 1000` y `Out Of Stock Status = Out Of Stock`. Esto *bloquea CP-ADM-01 y
CP-RNF-01*.

El ambiente no fue alterado por el equipo; no se requirió restauración de datos. La restricción es del
ambiente público de prueba y *no constituye un defecto del producto*, a diferencia de DEF-04.

#figure(
  image("evidencias/CP-ADM-01/CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png", width: 100%),
  caption: [Bloqueo de CP-ADM-01: el panel administrativo responde
  #lit[Warning: You do not have permission to modify products!] al intentar guardar `Quantity = 0` en
  HP LP3065. Impedimento del ambiente, registrado como *Bloqueado* y nunca como *Fallido*.],
)

== Resumen de los defectos registrados

#figure(
  chico[
    #table(
      columns: (1.7cm, 1fr, 2.0cm, 2.0cm, 1.8cm, 2.6cm),
      table.header([ID], [Título abreviado], [Severidad], [Prioridad], [Estado], [Casos afectados]),
      [DEF-01], [Total de línea omite el Eco Tax por unidad (\$242.00 frente a \$244.00)], [Alta], [Alta], [Nuevo], [CP-CHK-01],
      [DEF-02], [Producto publicado #lit[In Stock] rechazado por control de inventario en el carrito], [Alta], [Alta], [Nuevo], [CP-CHK-01],
      [DEF-03], [#lit[Confirm Order] sin retroalimentación cuando no hay método de pago], [Media], [Media], [Nuevo], [CP-CON-01],
      [DEF-04], [El sitio público no ofrece método de pago pese a Cash On Delivery habilitado], [Crítica], [Alta], [Nuevo], [CP-CHK-01, CP-CON-01, CP-CON-02, CP-PED-01, CP-RNF-01],
    )
  ],
  caption: [Resumen de los cuatro defectos registrados en el bloque del Integrante 2.],
)

#pagebreak()

// =====================================================================
= Consolidación, métricas y criterios de salida
// =====================================================================

#nota[
  *Nota metodológica (orden obligatorio).* Los criterios de salida *se declaran ANTES de presentar
  métricas o gráficos*. El tablero muestra; la decisión se toma contra estos umbrales. Un porcentaje de
  aprobados alto no es, por sí solo, una autorización de release: hay que mirar qué casos se ejecutaron,
  los criterios de salida, los defectos abiertos y lo bloqueado o no ejecutado.

  La conclusión de cierre se redacta siempre como *estado frente a los criterios de salida* —«no se
  cumplen los criterios de salida CSx y CSy → el release no está listo»—, nunca como una etiqueta de
  dictamen.
]

== Criterios de salida declarados (antes de cualquier métrica)

#figure(
  table(
    columns: (2.0cm, 1fr, 3.2cm),
    table.header([ID], [Enunciado del curso (Clase 7 — Gestión de pruebas)], [Umbral]),
    [*CS1*], [Casos de prueba de alta prioridad ejecutados], [100 %],
    [*CS2*], [Tasa de aprobación sobre los casos ejecutados], [≥ 90 %],
    [*CS3*], [Defectos críticos abiertos], [0],
    [*CS4*], [Defectos de severidad alta abiertos], [máximo 2],
  ),
  caption: [Criterios de salida CS1–CS4 declarados antes de la presentación de métricas.],
)

Regla maestra del curso: *los criterios de salida del plan son las métricas con las que se decide*.

=== Denominadores fijados (no se mezclan)

#figure(
  table(
    columns: (5.4cm, 1fr, 4.6cm),
    table.header([Métrica], [Fórmula], [Denominador]),
    [% ejecutado / tasa de ejecución], [ejecutados / planificados], [*Planificados*],
    [*Tasa de bloqueo*], [bloqueados / planificados], [*Planificados*],
    [*Tasa de aprobación*], [aprobados / ejecutados], [*Ejecutados*],
    [% de alta prioridad ejecutada], [casos Alta ejecutados / casos Alta planificados], [Casos Alta planificados],
    [Pendientes], [bloqueados + no ejecutados], [—],
  ),
  caption: [Denominadores fijados para todas las métricas del informe.],
)

Un caso bloqueado no entra en el denominador de aprobación: no llegó a ejecutarse. Medir el bloqueo contra
lo ejecutado ocultaría la porción del alcance que nunca pudo entrar a ejecución.

No se emplean fórmulas que el curso no presenta —en particular, *no se usa «densidad de defectos»*— ni se
habla de «métricas de vanidad»: el término del curso es *métricas engañosas* («sin contexto engañan», «lo
que se mide, se distorsiona», «aprobados no es calidad»).

== Qué significa cada criterio con los 8 casos del bloque

Casos planificados del bloque: *CP-CHK-01, CP-CON-01, CP-CON-02, CP-ADM-01, CP-PED-01, CP-RNF-01,
CP-RNF-02, CP-RNF-03* (total: *8 planificados*). Prioridad de cada caso, *derivada de la prioridad de sus
condiciones* (§4):

#figure(
  table(
    columns: (3.2cm, 1fr, 3.4cm),
    table.header([Caso], [Condiciones que cubre], [Prioridad derivada]),
    [CP-CHK-01], [CT-CHK-01, 02, 04, 05, 06 · CT-CON-06], [*Alta*],
    [CP-CON-01], [CT-CON-01, 02, 03, 04], [*Alta*],
    [CP-CON-02], [CT-CON-05], [*Alta*],
    [CP-ADM-01], [CT-ADM-02, 03, 04, 05], [*Alta*],
    [CP-PED-01], [CT-PED-01, 02], [*Alta*],
    [CP-RNF-01], [CT-RNF-01, 02 · CT-ADM-10], [*Alta*],
    [CP-RNF-02], [CT-RNF-03], [Media],
    [CP-RNF-03], [CT-RNF-04, 05], [*Alta*],
  ),
  caption: [Prioridad de cada caso derivada de la prioridad de sus condiciones: 7 Alta y 1 Media.],
)

→ *7 casos de alta prioridad* y *1 de prioridad media*.

- *CS1 — 100 % de casos de alta prioridad ejecutados.* Los *7 casos Alta* deben tener veredicto *Aprobado
  o Fallido*. Un caso *Bloqueado* o *Pendiente* *no cuenta como ejecutado*: un impedimento de ambiente se
  registra como Bloqueado, nunca como Fallido, y tampoco como ejecutado. CP-RNF-02 (Media) no entra en el
  cómputo de CS1, pero sí en el % ejecutado general y en los pendientes.
- *CS2 — aprobación ≥ 90 % de los ejecutados.* El denominador son los casos con veredicto Aprobado o
  Fallido, *no los 8 planificados*. Con este tamaño, sobre 7 ejecutados el umbral obliga a 7 aprobados
  (6/7 = 85.7 % ya no cumple); sobre 8 ejecutados, a 8 aprobados. Con *0 ejecutados el criterio no es
  calculable*, y no calculable no equivale a cumplido.
- *CS3 — 0 defectos críticos abiertos.* Ningún defecto de severidad *Crítica* puede quedar en un estado
  distinto de *Cerrado* (ni Nuevo, ni En análisis, ni Asignado, ni En corrección, ni Listo para reprueba,
  ni Reabierto). Escala declarada por el equipo: Crítica · Alta · Media · Baja; el CTFL no impone una
  escala, así que rige la nuestra, con el mismo significado en todo el bloque.
- *CS4 — máximo 2 defectos de severidad alta abiertos.* Como máximo *2* defectos de severidad *Alta* sin
  Cerrar al momento del corte. El bloque registra exactamente 2 (DEF-01 y DEF-02): el criterio está *en el
  límite*, y cualquier defecto Alto adicional lo incumple.

Los cuatro criterios se evalúan sobre el bloque del Integrante 2. El consolidado global del equipo los
evalúa de nuevo sobre el total de casos de ambos integrantes.

== Tablero visual de resultados

El tablero se presenta *después* de los criterios de salida, nunca antes: muestra la distribución, no
autoriza el release. Las cifras son las mismas de §8.4, §8.5 y §8.6; ningún dato es exclusivo del
gráfico.

#figure(
  block(width: 100%, breakable: false)[
    #grid(
      columns: (1fr, 0.9cm, 1fr),
      align: top,
      block(width: 100%)[
        #align(center)[#text(size: 9pt, weight: "bold")[Veredictos de los 8 casos planificados]]
        #v(6pt)
        #grafico-barras((
          (etiqueta: [Pasó], valor: 1, color: C-PASO),
          (etiqueta: [Falló], valor: 1, color: C-FALLO),
          (etiqueta: [Bloqueado], valor: 5, color: C-BLOQ),
          (etiqueta: [Parcial], valor: 1, color: C-PARC),
        ))
        #v(4pt)
        #align(center)[#text(size: 7.6pt, fill: luma(80))[Total: 8 casos · Pasó CP-RNF-03 · Falló CP-CHK-01 · Parcial CP-RNF-02]]
      ],
      [],
      block(width: 100%)[
        #align(center)[#text(size: 9pt, weight: "bold")[Defectos registrados por severidad]]
        #v(6pt)
        #grafico-barras((
          (etiqueta: [Crítica], valor: 1, color: C-FALLO),
          (etiqueta: [Alta], valor: 2, color: C-BLOQ),
          (etiqueta: [Media], valor: 1, color: C-PARC),
        ))
        #v(4pt)
        #align(center)[#text(size: 7.6pt, fill: luma(80))[Total: 4 defectos, todos en estado Nuevo · Crítica: DEF-04 · Alta: DEF-01, DEF-02 · Media: DEF-03]]
      ],
    )
  ],
  kind: image,
  supplement: [Figura],
  caption: [Tablero visual del cierre: distribución de veredictos sobre los 8 casos planificados y de los 4 defectos registrados por severidad. Gráficos dibujados con primitivas nativas del documento.],
)

*Lectura del tablero.* La barra dominante es *Bloqueado* (5 de 8): el resultado del bloque no se explica
por pruebas que salieran mal, sino por alcance que nunca llegó a ejecutarse. De esos 5 bloqueos, 3 son
por defecto del producto (DEF-04) y 2 por restricción de permisos del ambiente. En el gráfico de
severidad, la única barra *Crítica* corresponde a DEF-04, que es a la vez la causa de tres de los cinco
bloqueos: una sola corrección libera la mayor parte del alcance detenido.

*Codificación de color usada en todo el informe* —el color acompaña siempre al texto del veredicto, nunca
lo sustituye:

#leyenda-veredictos

== Evolución del análisis: de limitación de ambiente a defecto crítico

En el primer corte del 24-09-2026, la ausencia de métodos de pago en el checkout se registró como una *limitación del
ambiente*: el demo parecía no tener configurada ninguna pasarela. Bajo esa lectura, CS3 figuraba como cumplido, porque
no existía ningún defecto de severidad Crítica.

La verificación posterior en el panel administrativo refutó esa hipótesis. Extensions > Payments muestra *Cash On
Delivery* habilitado con Geo Zone = All Zones, Extensions > Shipping muestra *Flat Rate* habilitado con la misma
cobertura, y Sales > Orders contiene pedidos recientes, el más nuevo del 23-09-2026. Es decir: los métodos existen,
están habilitados y sin restricción geográfica, y el flujo operó antes. Lo que el cliente ve contradice lo que el panel
administra, y eso es un defecto del producto, no una carencia del ambiente.

Esa reclasificación convirtió la observación OBS-01 en el defecto *DEF-04*, de severidad Crítica, y cambió la
evaluación de CS3 de cumplido a incumplido. También reasignó la causa de tres bloqueos —CP-CON-01, CP-CON-02 y
CP-PED-01—, que dejaron de atribuirse al ambiente para atribuirse al defecto.

Se deja constancia de este cambio porque afecta la conclusión del informe: la evaluación válida es la del cierre
(§8.8), no la del primer corte. Revisar una clasificación cuando aparece evidencia nueva forma parte del análisis; lo
que no sería admisible es sostener la primera lectura habiendo visto el panel.

== Tabla global de resultados

#figure(
  table(
    columns: (6.2cm, 1.9cm, 3.5cm, 1fr),
    table.header([Caso], [Prioridad], [Veredicto], [Causa / defecto asociado]),
    [CP-CHK-01 Checkout como invitado], [Alta], [#veredicto("Falló")], [DEF-04 (impide completar), DEF-01 (importes inconsistentes)],
    [CP-CON-01 Número y resumen del pedido], [Alta], [#veredicto("Bloqueado")], [Por defecto DEF-04],
    [CP-CON-02 Prevención de pedido duplicado], [Alta], [#veredicto("Bloqueado")], [Por defecto DEF-04],
    [CP-ADM-01 Stock cero reflejado públicamente], [Alta], [#veredicto("Bloqueado")], [Ambiente: sin permisos de escritura],
    [CP-PED-01 Pedido visible en administración], [Alta], [#veredicto("Bloqueado")], [Por defecto DEF-04],
    [CP-RNF-01 Sincronización sitio–panel], [Alta], [#veredicto("Bloqueado")], [Ambiente: sin permisos de escritura],
    [CP-RNF-02 Flujo crítico en navegadores], [Media], [#veredicto("Ejecución parcial")], [Verificado en Chrome; faltan Edge y Firefox],
    [CP-RNF-03 Tiempo de respuesta del catálogo], [Alta], [#veredicto("Pasó")], [4 mediciones bajo el umbral],
  ),
  caption: [Tabla global de resultados del bloque al cierre del 24-09-2026.],
)

== Métricas

#figure(
  table(
    columns: (6.4cm, 1fr, 3.2cm),
    align: (left, left, center),
    table.header([Métrica], [Cálculo], [Valor]),
    [Casos diseñados], [—], [8],
    [Casos planificados para ejecución], [Todos los de prioridad alta (7) más CP-RNF-02], [8],
    [Casos ejecutados por completo], [CP-CHK-01, CP-RNF-03], [2],
    [Casos con ejecución parcial], [CP-RNF-02], [1],
    [Casos pasados], [CP-RNF-03], [1],
    [Casos fallidos], [CP-CHK-01], [1],
    [Casos bloqueados], [CP-CON-01, CP-CON-02, CP-ADM-01, CP-PED-01, CP-RNF-01], [5],
    [*Tasa de ejecución*], [2 / 8], [*25.0 %*],
    [*Tasa de aprobación*], [1 / 2], [*50.0 %*],
    [*Tasa de bloqueo*], [5 / 8], [*62.5 %*],
    [Alta prioridad ejecutada], [2 / 7], [28.6 %],
    [Pendientes de completar], [5 bloqueados + 1 parcial], [6: 5 Alta y 1 Media],
  ),
  caption: [Métricas consolidadas del bloque, con los denominadores declarados en §8.1.],
)

*Desglose de la causa del bloqueo:* *3 casos bloqueados por defecto del producto* (DEF-04) y *2 por
restricción del ambiente* (permisos del usuario `demo`). La distinción importa: la primera causa es
responsabilidad del equipo de desarrollo; la segunda, de la disponibilidad del ambiente de prueba.

== Defectos por severidad y prioridad

#figure(
  table(
    columns: (4.6cm, 3.4cm, 3.0cm, 2.4cm, 1fr),
    align: (left, center, center, center, center),
    table.header([Severidad \\ Prioridad], [Alta], [Media], [Baja], [Total]),
    [Crítica], [1 (DEF-04)], [—], [—], [*1*],
    [Alta], [2 (DEF-01, DEF-02)], [—], [—], [*2*],
    [Media], [—], [1 (DEF-03)], [—], [*1*],
    [Baja], [—], [—], [—], [0],
    [*Total*], [*3*], [*1*], [*0*], [*4*],
  ),
  caption: [Distribución de defectos por severidad y prioridad (dos ejes independientes).],
)

Todos en estado *Nuevo*. Escala de severidad propia del equipo, declarada en §7.1; el temario CTFL no
impone una escala única. Ninguno ha pasado por triage ni por *prueba de confirmación*.

== Cumplimiento de los criterios de salida al cierre

#figure(
  table(
    columns: (1.8cm, 5.2cm, 3.6cm, 3.2cm, 1fr),
    table.header([Criterio], [Umbral], [Resultado], [Estado], [Evidencia]),
    [CS1], [100 % de alta prioridad ejecutados], [2 de 7 ejecutados], [*No se cumple*], [Tabla global, §8.5],
    [CS2], [Aprobación ≥ 90 % de los ejecutados], [50.0 %], [*No se cumple*], [Métricas, §8.5],
    [CS3], [Cero defectos críticos abiertos], [1 abierto (DEF-04)], [*No se cumple*], [Reporte de hallazgos, §7],
    [CS4], [Máximo 2 defectos altos abiertos], [2 abiertos (DEF-01, DEF-02)], [*Se cumple*], [Reporte de hallazgos, §7],
  ),
  caption: [Evaluación de los criterios de salida CS1–CS4 al cierre del 24-09-2026.],
)

=== Estado frente a los criterios de salida

Tres de los cuatro criterios de salida no se cumplen. El defecto *DEF-04* bloquea el recorrido de compra probado: el sitio público no ofrece ningún método de pago aunque el panel administrativo tiene Cash On
Delivery habilitado para todas las zonas geográficas. No se completó la compra con los datos ensayados; no se extrapola este resultado a todos los clientes.
*No se cumplen los criterios de salida CS1, CS2 y CS3 → el release no está listo*, y la tasa de ejecución
del 25 % no es un dato menor: no se trata de que las pruebas hayan salido mayoritariamente bien, sino de
que la mayor parte del alcance nunca pudo entrar a ejecución.

#nota[
  Un informe que presentara «1 de 2 casos ejecutados aprobados» como resultado positivo sería una *métrica
  engañosa*. El dato que gobierna la decisión es que el *62.5 % del alcance planificado quedó bloqueado* y
  que existe un *defecto crítico abierto* en el flujo transaccional.
]

== Riesgos residuales del cierre

+ *Cobertura no alcanzada:* confirmación de pedidos, prevención de duplicados y consistencia sitio–panel
  quedan sin verificar. Son los riesgos de producto de mayor impacto del caso y hoy están sin evidencia.
+ *Señal no confirmada de duplicación:* las órdenes 3633, 3634 y 3635 (mismo cliente, mismo monto, mismo
  día) son compatibles con el riesgo que evalúa CP-CON-02, pero no se puede atribuir al sistema sin
  generar pedidos propios (OBS-03).
+ *Volatilidad del ambiente:* el inventario y los cupones cambian por acción de terceros; cualquier
  reejecución puede arrojar un estado distinto.
+ *Compatibilidad sin verificar:* RNF-02 solo se comprobó en Chrome.
+ *Margen estrecho de rendimiento:* RNF-03 cumple, pero la primera carga sin caché quedó a 68 ms del
  umbral de 2 s.

A estos se suman los riesgos residuales declarados en el análisis de riesgos (§3.4): concurrencia,
integración real de pago, persistencia a largo plazo de los pedidos, navegadores móviles y toda
verificación que exija escritura administrativa mientras persista RPR-01.

#pagebreak()

// =====================================================================
= Reflexión sobre automatización para el Proyecto 2
// =====================================================================

Sustentada en lo observado durante esta ejecución, no en criterios generales.

== Sí automatizar

- *CP-RNF-03 (tiempo de respuesta del catálogo).* Es la candidata más clara: criterio numérico, ejecución
  idéntica en cada corrida y resultado sensible a cualquier degradación. Ya se midió con la Navigation
  Timing API, o sea que el mecanismo está probado. Además el margen observado fue de solo 68 ms, así que
  la repetición frecuente tiene valor real.
- *Verificación de consistencia entre inventario del panel y disponibilidad publicada.* El contraste que
  expuso DEF-02 (HTC Touch HD con cantidad 0 publicado como #lit[In Stock]) es una comparación de datos
  entre dos fuentes, sin interacción compleja: es exactamente lo que una automatización hace mejor y más
  rápido que una persona, sobre todo repetida en todo el catálogo.
- *Los pasos previos del checkout de invitado* (carga del formulario, validación de campos obligatorios,
  guardado de datos de invitado). Ese tramo se comportó de forma estable y determinista en las dos
  ejecuciones, con países distintos, y es el prerrequisito de toda prueba de compra: conviene tenerlo
  automatizado como base.

== No automatizar todavía

- *CP-CON-01, CP-CON-02 y CP-PED-01.* No se pueden completar ni una sola vez de forma manual: automatizar
  un flujo que aún no se logra ejecutar implica escribir código contra un comportamiento que nadie ha
  observado. Primero debe corregirse DEF-04 y validarse manualmente el flujo completo.
- *CP-ADM-01 y CP-RNF-01.* Dependen de permisos que el ambiente público no otorga. La automatización no
  resuelve una restricción de permisos; solo trasladaría el bloqueo a un script.
- *CP-RNF-02 (compatibilidad multinavegador).* Exige infraestructura de varios navegadores y versiones,
  con alto costo de mantenimiento frente a un flujo crítico que hoy ni siquiera se completa. Tiene sentido
  después de estabilizar el flujo, no antes.

== Criterio transversal

La automatización rinde sobre flujos estables, repetitivos y de validación objetiva. Hoy el flujo de
compra de este sistema no es estable, y automatizarlo ahora produciría pruebas frágiles que fallarían por
el defecto conocido en lugar de detectar defectos nuevos.

// =====================================================================
= Lecciones aprendidas
// =====================================================================

+ *El ambiente es parte del alcance de pruebas, no un supuesto.* Se perdió tiempo diseñando ejecución
  sobre un demo que primero fue inaccesible por bloqueo de red y luego resultó tener permisos de escritura
  restringidos. Verificar el ambiente debe ser la primera actividad, no una consecuencia.
+ *Distinguir bloqueo por ambiente de bloqueo por defecto cambia la conclusión.* La ausencia de métodos de
  pago se clasificó inicialmente como limitación del ambiente (OBS-01). Contrastarla contra el panel
  administrativo la convirtió en DEF-04, un defecto crítico. La hipótesis inicial y su refutación quedaron
  registradas: revisar una clasificación con evidencia nueva es parte del análisis, no un error que
  ocultar.
+ *Contrastar el sitio público contra el panel administrativo reveló causas raíz que la exploración del
  front no explicaba.* La cantidad real en inventario frente a la etiqueta de disponibilidad publicada es
  lo que convirtió una observación superficial en un defecto con causa identificada.
+ *En un ambiente compartido, la evidencia sin fecha y hora no es evidencia.* El inventario, los cupones y
  los pedidos cambian por acción de terceros.
+ *Un bloqueo bien documentado vale más que un caso aprobado sin trazabilidad.* El 62.5 % de bloqueo es un
  resultado legítimo del proceso, sustentado en mensajes literales del sistema y registrado en bitácora.

// =====================================================================
#page(flipped: true)[
  = Anexos

  Tres anexos sostienen la trazabilidad del bloque: el *Anexo A* registra el estado fechado del ambiente
  que justifica cada veredicto Bloqueado; el *Anexo B* documenta la estrategia de resiliencia adoptada; el
  *Anexo C* lista el testware entregado bajo Gestión de la Configuración.

  == Anexo A — Bitácora de ambiente

  Registro fechado del estado del sistema bajo prueba. Toda ejecución debe citar la entrada de bitácora
  vigente. Responsable: Granit (Integrante 2).

  #figure(
    mini[
      #table(
        columns: (2.0cm, 1.9cm, 3.6cm, 4.6cm, 1fr, 5.4cm),
        table.header([Fecha], [Hora aprox.], [Origen de acceso], [Evento observado], [Evidencia literal], [Efecto sobre las pruebas]),
        [18-09-2026], [—], [Navegador del equipo], [Usuario admin `demo` sin permisos de escritura], [#lit[Warning: You do not have permission to modify coupons]], [Bloquea condiciones que requieren configuración administrativa],
        [18-09-2026], [—], [Navegador del equipo], [Checkout bloqueado por advertencia de stock], [#lit[Products marked with \*\*\* are not available in the desired quantity or not in stock!]], [Impide generar orden],
        [24-09-2026], [—], [Entorno de automatización (IP de datacenter)], [Dominio del demo responde HTTP 403 tras desafío de Cloudflare], [#lit[Sorry, you have been blocked] · Ray ID `a3ffd6a6fe936f20` y `a3ffdaf1d8966f2f`], [Indisponibilidad total desde ese origen],
        [24-09-2026], [—], [Navegador local del estudiante (IP residencial)], [Acceso restablecido; el bloqueo es por origen de red, no del sitio], [Portada #lit[Your Store] con catálogo completo; footer #lit[Your Store © 2026]], [Ejecución posible solo desde el origen autorizado],
        [24-09-2026], [—], [Navegador local], [Ruta real del panel administrativo], [`https://demo.opencart.com/TlbeVW/` (no `/admin/`); credenciales publicadas por opencart.com: `demo`/`demo`], [Requiere autenticación manual del responsable],
        [24-09-2026], [—], [Navegador local], [Checkout sin métodos de pago ni de envío configurados], [#lit[No Payment options are available. Please contact us for assistance!] · no existe sección #lit[Shipping Method]], [*Bloquea CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01*],
        [24-09-2026], [02:45], [Panel administrativo autenticado (usuario `demo`)], [Intento de fijar `Quantity = 0` en el producto HP LP3065 y guardar], [*#lit[Warning: You do not have permission to modify products!]*], [El cambio *no se persistió*: el formulario conserva `Quantity = 1000` y `Out Of Stock Status = Out Of Stock`. *Bloquea CP-ADM-01 y CP-RNF-01*],
      )
    ],
    caption: [Bitácora de ambiente del Caso 3 OpenCart, con texto literal del sistema y efecto sobre las pruebas.],
  )
]

*Regla de registro*

+ Ninguna ejecución se considera válida sin entrada de bitácora del día.
+ El estado del inventario y de los cupones del demo es volátil y compartido: se documenta el valor
  observado y su hora.
+ Un impedimento del ambiente se registra como *Bloqueado*, nunca como *Fallido*. La distinción se
  sostiene en esta bitácora.

*Consecuencia de la entrada del 24-09-2026, 02:45:* el ambiente no fue alterado por el equipo; no se
requirió restauración de datos. La restricción es del ambiente público de prueba y *no constituye un
defecto del producto*, a diferencia de DEF-04. Evidencia:
`evidencias/CP-ADM-01/CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png` (figura del
§6.8).

== Anexo B — Estrategia de resiliencia del ambiente de pruebas

*Tropicalización: prácticas reales de la industria aplicadas a este proyecto.* El sistema bajo prueba es
un demo público, compartido, volátil y fuera de nuestro control. La industria ya resolvió problemas de
esta familia; adoptamos sus decisiones de diseño en lugar de improvisar.

#figure(
  chico[
    #table(
      columns: (4.6cm, 4.6cm, 1fr),
      table.header([Práctica real de la industria], [Qué problema resuelve allá], [Cómo la aplicamos aquí]),
      [*Instalación parcial + descarga de caché por región* (videojuegos: se instala el núcleo y los assets llegan después desde un CDN cercano)], [El origen puede estar lejos, saturado o caído; el usuario no puede quedar bloqueado], [*Snapshot local de cada página evaluada* en `snapshots/`. La evidencia deja de depender de que el demo siga vivo o con los mismos datos],
      [*Mirror / réplica de origen* (paquetes npm, apt, Steam)], [Si el origen falla, el trabajo continúa desde la réplica], [*Instancia local de OpenCart* como ambiente espejo declarado, solo para las condiciones que el demo bloquea por permisos],
      [*Feature flag y degradación controlada* (Netflix, Amazon)], [Cuando un servicio cae, la app sigue funcionando con menos capacidad, no se cae entera], [*Plan de ejecución por capas:* primero todo lo ejecutable sin permisos ni pedido; lo demás se marca Bloqueado con causa, sin detener el avance],
      [*Datos sintéticos propios, no datos de producción* (banca, salud)], [No depender de datos ajenos ni exponer información real], [*Datos de prueba fijos y ficticios* definidos por nosotros (`Test / QA CS5383 / qa.cs5383.test@example.com`), nunca datos personales reales],
      [*Canary / smoke test previo al despliegue*], [Detectar temprano que el ambiente no sirve antes de gastar el esfuerzo grande], [*Verificación de ambiente obligatoria* al inicio de cada sesión: portada carga, producto en stock existe, admin responde. Si falla, se registra en bitácora y no se ejecuta],
      [*Idempotencia y control de reintentos* (APIs de pago)], [Evitar cobros o pedidos duplicados por reintento], [Es justamente lo que evalúa *CP-CON-02*: el sistema debe resistir doble clic y recarga sin duplicar el pedido],
      [*Observabilidad y trazas fechadas* (SRE)], [Poder explicar después qué pasó y cuándo], [*Bitácora de ambiente* con hora, origen de acceso, texto literal del sistema e identificadores (Ray ID)],
      [*Congelar versión del entorno* (contenedores, lockfiles)], [Que el resultado sea reproducible mañana], [*Gestión de la Configuración* del testware: versión del documento, fecha de ejecución y estado del demo declarados en cada caso],
    )
  ],
  caption: [Estrategia de resiliencia: prácticas de industria adoptadas y su aplicación al proyecto.],
)

*Consecuencia metodológica.* La indisponibilidad y la falta de permisos *no son excusas, son resultados de
prueba*: alimentan el registro de riesgos, la tasa de bloqueo y, al final, el estado frente a los criterios
de salida. Un bloqueo bien documentado y trazable vale más que un caso aprobado sin evidencia.

== Anexo C — Testware entregado (Gestión de la Configuración)

#figure(
  table(
    columns: (7.2cm, 1fr),
    table.header([Artefacto], [Ruta]),
    [Bitácora de ambiente], [`00_gestion/BITACORA_AMBIENTE.md`],
    [Estrategia de resiliencia], [`00_gestion/ESTRATEGIA_RESILIENCIA.md`],
    [Criterios de salida], [`00_gestion/CRITERIOS_SALIDA.md`],
    [Planificación], [`entregables/A_planificacion_granit.md`],
    [Riesgos], [`entregables/B_riesgos_granit.md`],
    [Análisis y condiciones], [`entregables/C_analisis_condiciones_granit.md`],
    [Diseño de casos], [`03_diseno/D_casos_de_prueba_granit.md`],
    [Ejecución], [`04_ejecucion/EJECUCION_GRANIT_20260924.md`],
    [Mediciones de rendimiento], [`04_ejecucion/MEDICIONES_RNF03_20260924.md`],
    [Consolidación y cierre], [`04_ejecucion/F_CONSOLIDACION_Y_CIERRE.md`],
    [Defectos y hallazgos], [`05_defectos/HALLAZGOS.md`],
    [Evidencias], [`evidencias/CP-XXX-NN/`],
    [Este informe], [`informe/informe.typ` #sym.arrow `informe/Proyecto1_Caso3_Grupo.pdf`],
  ),
  caption: [Testware entregado del bloque del Integrante 2, bajo Gestión de la Configuración.],
)

=== Herramienta de gestión de pruebas

Opción principal: *Qase* (`app.qase.io`), la herramienta de gestión de pruebas usada en clase.
Alternativas conservadas en el plan: Jira/Zephyr, TestLink, o las tablas del propio informe (§2.4).
Cualquiera que se elija debe sostener la trazabilidad *Requisito ↔ caso ↔ ejecución ↔ defecto*; la
condición de prueba (CT) se conserva como paso intermedio del análisis.

=== Estado verificable de las evidencias gráficas

E-01, E-03 y E-04 están incorporadas. E-05 es parcial y E-02 sigue pendiente. Los archivos originales y sus huellas SHA-256 constan en `informe/evidencias/gestion-20260924/manifest.json`. La nueva captura no convierte retrospectivamente una observación antigua en evidencia capturada entonces.

#figure(
  table(
    columns: (1.6cm, 1fr, 3.0cm),
    table.header([ID], [Contenido requerido], [Sustenta]),
    [E-01], [Capturada: carrito con línea \$242.00 y Total \$244.00], [DEF-01],
    [E-02], [Pendiente: carrito con producto marcado `***` y mensaje de stock], [DEF-02],
    [E-03], [Capturada: checkout sin opciones de pago], [DEF-04],
    [E-04], [Capturada: configuración de Cash On Delivery habilitada para All Zones], [DEF-04],
    [E-05], [Parcial: formulario de stock del producto 28; lista completa pendiente], [DEF-02],
  ),
  caption: [Estado de capturas y defecto relacionado.],
)

Evidencia ya capturada e incorporada: `CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png`
(§6.8 y §7.10).

#pagebreak()

#include "gestion_clase7.typ"

// =====================================================================
= Glosario
// =====================================================================

Términos técnicos empleados en este informe, con el significado exacto con que se usan aquí. No
sustituyen al temario: fijan el vocabulario para que cada veredicto y cada métrica se lean sin
ambigüedad.

#figure(
  table(
    columns: (4.4cm, 1fr),
    table.header([Término], [Significado con que se usa en este informe]),
    [*Condición de prueba*],
    [Aspecto de la base de pruebas verificable por uno o más casos. Describe *qué* comprobar, nunca *cómo* ni con qué datos. En este informe son las CT-XXX-NN del §4 y son el *paso intermedio del análisis* entre el requisito y el caso; ninguna contiene pasos, valores ni resultados.],

    [*Caso de prueba*],
    [Conjunto de precondiciones, datos concretos, pasos, resultado esperado y criterio de aceptación que hace verificable una o varias condiciones. Son los CP-XXX-NN del §5: aquí sí aparecen el *cómo* y los datos.],

    [*Prueba de confirmación*],
    [Reejecución del caso que falló, una vez que el defecto pasa al estado *Listo para reprueba*, para comprobar que la corrección resuelve lo reportado. Es el término usado en este proyecto; no se emplea «re-testing».],

    [*Pruebas de regresión*],
    [Pruebas sobre funcionalidad que ya operaba, para detectar que la corrección de un defecto no haya roto otra cosa. Son distintas de la prueba de confirmación: aquí se aplicarían sobre los casos que comparten precondiciones con el caso corregido.],

    [*Gestión de la Configuración*],
    [Control de versiones e integridad del testware: identificador `vMAJOR.MINOR` con autor, fecha y motivo del cambio; no se edita sobre una versión ya publicada; toda modificación posterior a la línea base se registra con caso afectado, motivo, responsable y fecha. Declarada en §2.10 e inventariada en el Anexo C.],

    [*Testware*],
    [Todo el material producido por la actividad de prueba y sujeto a Gestión de la Configuración: plan, riesgos, condiciones, casos, datos, registros de ejecución, evidencias, reporte de defectos y este informe. Su inventario está en el Anexo C (§11.3).],

    [*Severidad*],
    [Grado de impacto técnico o funcional del defecto sobre el sistema. La propone QA. Escala declarada por el equipo: *Crítica · Alta · Media · Baja* (§7.1). El CTFL no impone una escala: lo esencial es usar la misma con el mismo significado en todos los defectos.],

    [*Prioridad*],
    [Urgencia con que el negocio quiere que el defecto se atienda. La define el Product Owner. Es un eje *independiente* de la severidad y por eso viaja en un campo separado: un defecto puede ser de severidad Media y prioridad Alta, o al revés.],

    [*Riesgo de producto*],
    [Posibilidad de que el sistema falle frente a un requisito y dañe al negocio: venta sin inventario, pedido duplicado, datos inconsistentes. Se registra como RPD-NN (§3.3) y es lo que determina la prioridad de los casos.],

    [*Riesgo de proyecto*],
    [Posibilidad de que el equipo no pueda ejecutar la prueba prevista por ambiente, permisos, datos o tiempo. Se registra como RPR-NN (§3.2). No dice nada sobre la calidad del sistema, pero determina cuánta evidencia se puede obtener y qué casos terminan Bloqueados.],

    [*Criterio de salida*],
    [Umbral declarado *antes* de medir, contra el que se decide si el trabajo de prueba puede darse por concluido. Son CS1–CS4 (§8.1). La conclusión se redacta siempre como *estado frente a los criterios de salida*, nunca como una etiqueta de dictamen.],

    [*Veredicto Bloqueado*],
    [Resultado de un caso que *no pudo ejecutarse* por un impedimento externo al propio caso —falta de ambiente, de permisos, de datos o dependencia de otro caso—, registrado con el texto literal del sistema y su fecha. No es Fallido: un caso bloqueado nunca llegó a producir evidencia sobre el requisito, por eso no entra en el denominador de la *tasa de aprobación* y sí en el de la *tasa de bloqueo*, que se calcula sobre los casos *planificados*.],
  ),
  caption: [Glosario de términos técnicos empleados en el informe.],
)

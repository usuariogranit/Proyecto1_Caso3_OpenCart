// =====================================================================
//  VARIABLES EDITABLES
// =====================================================================
#let GRUPO   = "X"
#let FECHA   = "24 de septiembre de 2026"
#let CURSO   = "CS5383 — Verificación y Pruebas de Software"
#let CASO    = "Caso 3 — E-commerce con panel administrativo (OpenCart)"
#let SISTEMA = "OpenCart Demo 4.0.2.3"
#let AUTORES = ("Granit Espinoza Salazar", "Franco Roque Castillo")

// =====================================================================
//  PALETA INSTITUCIONAL UTEC
// =====================================================================
#let UTEC-CYAN   = rgb("#00B5E2")
#let UTEC-DARK   = rgb("#1E1E1E")
#let UTEC-ORANGE = rgb("#F58220")
#let UTEC-GRAY   = rgb("#555555")

// Derivados suaves para fondos de tabla y cajas
#let UTEC-CYAN-SUAVE   = rgb("#E6F7FC")
#let UTEC-ORANGE-SUAVE = rgb("#FDEFE1")
#let UTEC-GRAY-SUAVE   = rgb("#F2F4F5")
#let UTEC-OK-BG        = rgb("#E3F5E9")
#let UTEC-OK-BD        = rgb("#2E7D32")
#let UTEC-ERR-BG       = rgb("#FCE9E9")
#let UTEC-ERR-BD       = rgb("#C0392B")

// =====================================================================
//  DOCUMENTO
// =====================================================================
#set document(
  title: "Proyecto 1 — Informe de pruebas del Caso 3: OpenCart",
  author: AUTORES,
  keywords: ("testing", "OpenCart", "QA", "CS5383", "UTEC", "caso de prueba"),
)

// =====================================================================
//  TIPOGRAFÍA
// =====================================================================
#set text(
  font: ("Times New Roman", "New Computer Modern"),
  size: 10.5pt,
  lang: "es",
  hyphenate: true,
)
#set par(justify: true, leading: 0.68em, spacing: 1.0em)

// =====================================================================
//  PÁGINA
// =====================================================================
#set page(
  paper: "a4",
  margin: (top: 2.4cm, bottom: 2.2cm, x: 2.3cm),
  header: context {
    set text(size: 8.2pt, fill: UTEC-GRAY)
    grid(
      columns: (1fr, auto),
      align: (left, right),
      [Proyecto 1 · Pruebas del Caso 3 — OpenCart],
      [CS5383 · Bloque del Integrante 2],
    )
    v(-0.3em)
    line(length: 100%, stroke: 0.5pt + UTEC-CYAN)
  },
  footer: context {
    set text(size: 8.2pt, fill: UTEC-GRAY)
    line(length: 100%, stroke: 0.4pt + luma(190))
    v(-0.3em)
    grid(
      columns: (1fr, auto, 1fr),
      align: (left, center, right),
      [Grupo #GRUPO],
      [Página #counter(page).display("1") de #counter(page).final().first()],
      [#FECHA],
    )
  },
)

// =====================================================================
//  ENCABEZADOS — numeración limpia + regla cyan (estilo UTEC)
// =====================================================================
#set heading(numbering: (..n) => {
  let nums = n.pos()
  if nums.len() == 1      { numbering("1",    nums.at(0)) }
  else if nums.len() == 2 { numbering("1.1",  ..nums) }
  else                    { numbering("1.1.1", ..nums) }
})

#show heading.where(level: 1): it => block(
  above: 1.6em, below: 1.0em, breakable: false,
)[
  #set text(size: 16pt, weight: "bold", fill: UTEC-DARK)
  #it
  #v(-0.35em)
  #line(length: 100%, stroke: 1.4pt + UTEC-CYAN)
]

#show heading.where(level: 2): it => block(
  above: 1.15em, below: 0.55em,
)[
  #set text(size: 12.5pt, weight: "bold", fill: UTEC-DARK)
  #it
]

#show heading.where(level: 3): it => block(
  above: 0.9em, below: 0.45em,
)[
  #set text(size: 11pt, weight: "semibold", fill: UTEC-CYAN.darken(30%))
  #it
]

// =====================================================================
//  TABLAS — estilo único, encabezado oscuro, filas alternas
// =====================================================================
#set table(
  stroke: 0.4pt + luma(190),
  align: left,
  inset: (x: 6pt, y: 5pt),
  fill: (x, y) => if y == 0 { UTEC-DARK }
                  else if calc.odd(y) { UTEC-CYAN-SUAVE },
)
#show table.cell.where(y: 0): set text(
  fill: white, weight: "bold", size: 9pt, hyphenate: false,
)
#show table: set par(justify: false, leading: 0.55em)

// =====================================================================
//  FIGURAS
// =====================================================================
#set figure(gap: 0.8em)
#show figure.caption: set text(size: 8.6pt, fill: UTEC-GRAY)

// =====================================================================
//  CAJAS SEMÁNTICAS
// =====================================================================
#let caja-base(fill, accent, body) = block(
  width: 100%, inset: (x: 12pt, y: 9pt), radius: 3pt,
  fill: fill, stroke: (left: 3pt + accent),
)[#body]

#let nota(body)    = caja-base(UTEC-CYAN-SUAVE,   UTEC-CYAN,   body)
#let alerta(body)  = caja-base(UTEC-ORANGE-SUAVE, UTEC-ORANGE, body)
#let exito(body)   = caja-base(UTEC-OK-BG,        UTEC-OK-BD,  body)
#let peligro(body) = caja-base(UTEC-ERR-BG,       UTEC-ERR-BD, body)

// =====================================================================
//  AUXILIARES
// =====================================================================
#let pendiente(txt) = box(
  fill: rgb("#FFE08A"), stroke: 0.5pt + rgb("#B07000"),
  radius: 2pt, outset: (y: 2.5pt), inset: (x: 3pt),
)[#text(fill: rgb("#7A3E00"), weight: "bold")[\[PENDIENTE: #txt\]]]

#let evidencia-pendiente(id, desc) = block(
  width: 100%, inset: 10pt, radius: 4pt,
  stroke: (dash: "dashed"), fill: UTEC-GRAY-SUAVE,
)[*EVIDENCIA PENDIENTE #id* — #desc]

#let lit(m) = [“#m”]
#let chico(body) = text(size: 7.8pt)[#body]
#let mini(body)  = text(size: 7.0pt)[#body]

#let campo(etiqueta, contenido) = grid(
  columns: (4.0cm, 1fr), gutter: 6pt,
  [#text(weight: "bold")[#etiqueta]], [#contenido],
)

// =====================================================================
//  BADGES DE VEREDICTO
// =====================================================================
#let C-PASO  = (fondo: rgb("#DFF0DD"), borde: rgb("#1F6B32"), texto: rgb("#145225"))
#let C-FALLO = (fondo: rgb("#FADFDF"), borde: rgb("#9E2020"), texto: rgb("#7D1717"))
#let C-BLOQ  = (fondo: rgb("#FDE8D2"), borde: UTEC-ORANGE,  texto: rgb("#8A4310"))
#let C-PARC  = (fondo: rgb("#E6E6E6"), borde: rgb("#5A5E62"), texto: rgb("#3C4043"))

#let clase-veredicto(etiqueta) = {
  let e = lower(etiqueta)
  if e.starts-with("pasó") or e.starts-with("paso") or e.starts-with("aprob") { C-PASO }
  else if e.starts-with("falló") or e.starts-with("fallo") { C-FALLO }
  else if e.starts-with("bloqueado") { C-BLOQ }
  else { C-PARC }
}

#let veredicto(etiqueta, detalle: none) = {
  let c = clase-veredicto(etiqueta)
  box(
    fill: c.fondo, stroke: 0.6pt + c.borde, radius: 2.5pt,
    outset: (y: 2.2pt), inset: (x: 3.5pt),
  )[#text(fill: c.texto, weight: "bold", size: 0.95em, hyphenate: false)[#etiqueta]]
  if detalle != none [ #text(size: 0.9em)[#detalle]]
}

#let leyenda-veredictos = block(width: 100%)[
  #set text(size: 8.5pt)
  #grid(
    columns: (auto, auto, auto, auto), column-gutter: 10pt,
    veredicto("Pasó"), veredicto("Falló"),
    veredicto("Bloqueado"), veredicto("Parcial"),
  )
]

// =====================================================================
//  GRÁFICOS NATIVOS
// =====================================================================
#let grafico-barras(datos, alto: 3.1cm, ancho-barra: 1.35cm, unidad: "") = {
  let maxv = calc.max(..datos.map(d => d.valor))
  let n = datos.len()
  block(width: 100%, breakable: false)[
    #grid(
      columns: (1fr,) * n, align: center + bottom, row-gutter: 3pt,
      ..datos.map(d => text(size: 9.5pt, weight: "bold", fill: d.color.texto)[#d.valor#unidad]),
      ..datos.map(d => box(
        width: ancho-barra, height: alto * d.valor / maxv,
        fill: d.color.fondo, stroke: 0.7pt + d.color.borde, radius: (top: 2.5pt),
      )),
    )
    #v(-0.35em)
    #line(length: 100%, stroke: 0.8pt + luma(110))
    #v(-0.2em)
    #grid(
      columns: (1fr,) * n, align: center + top,
      ..datos.map(d => text(size: 8.2pt, hyphenate: false)[#d.etiqueta]),
    )
  ]
}

// =====================================================================
//  DIAGRAMAS: cajas y flechas
// =====================================================================
#let caja(cuerpo, fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN, tam: 7.8pt) = block(
  width: 100%, inset: (x: 4pt, y: 5pt), radius: 3pt,
  fill: fondo, stroke: 0.7pt + borde,
)[#align(center)[#text(size: tam, hyphenate: false)[#cuerpo]]]

#let flecha-h = align(horizon + center)[#text(size: 11pt, fill: UTEC-CYAN)[#sym.arrow.r]]
#let flecha-v = align(center)[#text(size: 11pt, fill: UTEC-CYAN)[#sym.arrow.b]]

// =====================================================================
//  IDENTIFICACIÓN TEXTUAL DE LA UNIVERSIDAD EN PORTADA
// =====================================================================
#let utec-logo(alto: 1.1cm) = context {
  block(height: alto)[
    #text(size: 0.8em, fill: UTEC-GRAY)[*UTEC* — Universidad de Ingeniería y Tecnología]
  ]
}

// =====================================================================
//  PORTADA
// =====================================================================
#page(header: none, footer: none, numbering: none)[
  #place(top + left)[#utec-logo()]
  #place(top + right)[
    #text(size: 9pt, fill: UTEC-GRAY, weight: "bold")[
      #upper("Reinventa el mundo")
    ]
  ]

  #align(center)[
    #v(2.4cm)
    #text(size: 10.5pt, fill: UTEC-GRAY, tracking: 0.08em)[#upper(CURSO)]
    #v(0.25cm)
    #line(length: 55%, stroke: 1.4pt + UTEC-CYAN)
    #v(1.0cm)
    #text(size: 22pt, weight: "bold", fill: UTEC-DARK)[
      Proyecto 1 — Informe de pruebas
    ]
    #v(0.7cm)
    #text(size: 13pt, style: "italic", fill: UTEC-DARK)[#CASO]
    #v(0.25cm)
    #text(size: 9pt, fill: UTEC-GRAY)[Planificación · análisis · diseño · ejecución · cierre]
    #v(0.3cm)
    #line(length: 55%, stroke: 1.4pt + UTEC-CYAN)
    #v(1.4cm)

    #block(width: 86%)[
      #set align(left)
      #table(
        columns: (4.6cm, 1fr),
        stroke: none,
        fill: none,
        inset: (x: 4pt, y: 6pt),
        [*Curso*], [#CURSO],
        [*Caso asignado*], [#CASO],
        [*Sistema bajo prueba*], [#SISTEMA — #link("https://demo.opencart.com/")[demo.opencart.com]],
        [*Integrantes*], [#AUTORES.join(" · ")],
        [*Grupo*], [Grupo #GRUPO],
        [*Fecha*], [#FECHA],
      )
    ]

    #v(1.1cm)
    #block(width: 88%, inset: 12pt, radius: 4pt, fill: UTEC-CYAN-SUAVE,
           stroke: (left: 3pt + UTEC-CYAN))[
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
    #text(size: 9pt, fill: UTEC-GRAY)[Corte de la información: 24-09-2026]
  ]
]

// =====================================================================
//  CONTROL DOCUMENTAL
// =====================================================================
#heading(level: 1, numbering: none)[Control documental] <sec:control>

#figure(
  table(
    columns: (1.5cm, 2.1cm, 5.0cm, 1fr),
    table.header([Versión], [Fecha], [Autor], [Estado]),
    [v1.0], [24-09-2026],
      [Granit Espinoza Salazar — Integrante 2, Analista de QA del bloque transaccional y administrativo],
      [Emitido — línea base de entrega con corte de información al 24-09-2026],
    [v1.1], [24-09-2026],
      [Revisión asistida; validación final a cargo del responsable],
      [Borrador revisado con Clase 7, capturas reales y corrección de métricas; pendiente de aprobación humana],
    [v1.2], [24-09-2026],
      [Revisión de presentación; validación final a cargo del responsable],
      [Fuente editable: portada y tablas afinadas, ficha de rendimiento íntegra y mínimo del grupo visible],
  ),
  caption: [Control de versiones del documento.],
) <tbl:control-versiones>

Este informe se rige por la *Gestión de la Configuración del Testware* declarada en
@sec:plan-config: identificador `vMAJOR.MINOR` con autor, fecha y motivo del cambio; no se edita
sobre una versión ya publicada; toda modificación posterior a la línea base se registra con caso
afectado, motivo, responsable y fecha, e incrementa la versión.

#alerta[
  *Estado del entregable del grupo.* El enunciado exige *al menos 15 casos de prueba en total* y
  cuatro funcionalidades distintas. Este documento contiene *8 casos del Integrante 2*; faltan
  los casos del Integrante 1 para verificar el mínimo conjunto. Antes de entregar, completar el
  número de grupo (hoy figura "X"), incorporar ambos bloques y comprobar que todos los casos de
  prioridad Alta tienen registro de ejecución o bloqueo sustentado. La fecha definitiva y la
  plantilla oficial del plan siguen pendientes de confirmación.
]

#pagebreak()

// =====================================================================
//  RESUMEN EJECUTIVO
// =====================================================================
#heading(level: 1, numbering: none)[Resumen ejecutivo] <sec:resumen>

*Contexto.* El Caso 3 es un e-commerce con panel administrativo sobre *OpenCart Demo 4.0.2.3*
(`demo.opencart.com`, panel en `/TlbeVW/`). Este informe cubre el bloque del *Integrante 2*:
checkout (FUN-05), confirmación del pedido (FUN-06), productos y stock desde el panel (FUN-07),
gestión administrativa de pedidos (FUN-08) y los requisitos no funcionales RNF-01 a RNF-03.
Corte de la información: 24-09-2026.

*Alcance del bloque.* De 24 requisitos verificables se derivaron *33 condiciones de prueba* y se
diseñaron *8 casos*, los 8 planificados para ejecución. La cobertura de condiciones por caso
diseñado es de *23 de 33 (70 %)*; los huecos son conscientes y se concentran en lo que exige
escritura en el panel.

#peligro[
  *Hallazgo crítico.* *DEF-04* — el sitio público no ofrece *ningún* método de pago pese a que el
  panel administrativo tiene *Cash On Delivery habilitado para todas las zonas geográficas*
  (Geo Zone = All Zones). El checkout se detiene con #lit[No Payment options are available. Please
  contact us for assistance!] y no se renderiza la sección #lit[Shipping Method]. *Impacto de
  negocio:* el recorrido de compra probado no puede completarse. No se han probado todas las
  combinaciones de cliente, producto y país; la causa raíz permanece en investigación. Severidad
  *Crítica*, prioridad *Alta*, estado *Nuevo*. DEF-04 bloquea por sí solo tres casos de alta
  prioridad (CP-CON-01, CP-CON-02, CP-PED-01) y hace fallar a CP-CHK-01. Se documentan además
  DEF-01 y DEF-02 (severidad Alta) y DEF-03 (Media).
]

*Criterios previos a la decisión* (Clase 7, diapositiva 10; @sec:consolidacion-criterios). CS1:
100 % de casos Alta ejecutados; CS2: aprobación ≥ 90 % de ejecutados; CS3: 0 críticos abiertos;
CS4: máximo 2 altos abiertos. Se adoptan para este bloque los umbrales del ejercicio de clase.

*Métricas del cierre* (denominadores declarados en @sec:consolidacion-denominadores, sin mezclar):

#block(inset: (left: 0.6em))[
  #grid(
    columns: (auto, auto, 1fr), column-gutter: 8pt, row-gutter: 3pt,
    [*Tasa de ejecución*], [*25 %*], [2 de 8 casos planificados ejecutados por completo],
    [*Tasa de aprobación*], [*50 %*], [1 aprobado sobre 2 ejecutados],
    [*Tasa de bloqueo*], [*62.5 %*], [5 de 8 casos planificados: 3 por defecto del producto (DEF-04) y 2 por restricción de permisos del ambiente],
  )
]

#peligro[
  *Estado frente a los criterios de salida.* *CS1 no se cumple* (2 de 7 casos de alta prioridad
  ejecutados, frente al 100 % exigido). *CS2 no se cumple* (50 % de aprobación frente al umbral
  de 90 %). *CS3 no se cumple* (1 defecto crítico abierto, DEF-04, frente a un umbral de cero).
  *CS4 se cumple en el límite* (2 defectos Alta abiertos sobre un máximo de 2). Tres de los cuatro
  criterios de salida no se cumplen, por lo que *el release no está listo*.
]

*Lectura correcta de las cifras.* Presentar «1 de 2 casos ejecutados aprobados» como resultado
positivo sería una métrica engañosa. El dato que gobierna la decisión es que el *62.5 % del
alcance planificado quedó bloqueado* —concentrado en la cadena transaccional pago → confirmación →
visibilidad operativa, el área de mayor riesgo económico— y que existe un *defecto crítico
abierto* en ese mismo flujo.

*Recomendación.*

+ *Corregir DEF-04 con máxima prioridad* y reejecutar CP-CHK-01 mediante *prueba de confirmación*;
  al desbloquearse, ejecutar CP-CON-01, CP-CON-02 y CP-PED-01, y aplicar *pruebas de regresión*
  sobre los casos que comparten precondiciones.
+ *Habilitar un ambiente con permisos de escritura* (instancia propia del demo oficial, Escenario
  B del @sec:plan-ambiente) para levantar el bloqueo de CP-ADM-01 y CP-RNF-01, hoy imputable al
  ambiente y no al producto.
+ *Cerrar los umbrales pendientes* —fecha de entrega como ancla del cronograma y umbral numérico
  de RNF-01— antes del siguiente ciclo.
+ *Completar CP-RNF-02 en Edge y Firefox* y la evidencia E-02 pendiente.
+ *No abrir automatización todavía* sobre el flujo de compra: hoy no es estable (@sec:automatizacion).

#pagebreak()

#heading(level: 1, numbering: none)[Índice] <sec:indice>

#outline(title: none, depth: 3, indent: 1.2em)

#heading(level: 1, numbering: none)[Índice de figuras] <sec:indice-figuras>
#outline(title: none, target: figure.where(kind: image))

#heading(level: 1, numbering: none)[Índice de tablas] <sec:indice-tablas>
#outline(title: none, target: figure.where(kind: table))

#pagebreak()

// =====================================================================
= Contexto del caso y base de pruebas <sec:contexto>

== El caso y el sistema bajo prueba <sec:contexto-caso>

El Caso 3 corresponde a un *e-commerce con panel administrativo* implementado sobre OpenCart. El
sistema bajo prueba es la instalación pública de demostración *OpenCart Demo 4.0.2.3*
(#link("https://demo.opencart.com/")[https://demo.opencart.com/]), cuyo panel administrativo se
encuentra en la ruta real `https://demo.opencart.com/TlbeVW/` —no en `/admin/`— con las
credenciales `demo` / `demo` publicadas por opencart.com.

El bloque documentado aquí abarca *FUN-05* (checkout como invitado o registrado), *FUN-06*
(confirmación y resumen del pedido), *FUN-07* (productos, categorías y stock desde el panel),
*FUN-08* (gestión administrativa de pedidos) y los requisitos no funcionales *RNF-01*
(sincronización sitio–panel sin reinicios), *RNF-02* (compatibilidad entre navegadores) y *RNF-03*
(tiempo de respuesta del catálogo).

== Base de pruebas y criterio de derivación <sec:contexto-base>

La base de pruebas son los requisitos verificables del Avance 1 —*RF CHK 01–05*, *RF CON 01–04*,
*RF ADM 01–07*, *RF PED 01–05* y *RNF 01–03*—, derivados del enunciado del Caso 3 y de la
exploración inicial. Cada condición surge de descomponer el requisito en sus aspectos verificables
independientes: flujo feliz, campos obligatorios, formatos inválidos, reglas de negocio y
consistencia sitio–panel.

#nota[
  Según ISTQB, una *condición de prueba* es un aspecto de la base de pruebas verificable por uno o
  más casos: describe *qué* comprobar, nunca *cómo* ni con qué datos. Ninguna fila del análisis
  (@sec:analisis) contiene pasos, valores ni resultados de ejecución.
]

La cadena de trazabilidad tiene *cuatro eslabones: Requisito ↔ caso ↔ ejecución ↔ defecto*. La
condición de prueba (CT) se conserva como *paso intermedio del análisis* entre el requisito y el
caso.

== Nota de ambiente vigente (24-09-2026) <sec:contexto-ambiente>

`demo.opencart.com` respondió *HTTP 403* por bloqueo de Cloudflare —storefront y panel— desde el
entorno de automatización; en la exploración del 18-09-2026 el usuario `demo` no podía modificar
configuración y no se logró generar una orden. Esto *no altera el análisis* —las condiciones
derivan de la base de pruebas, no de la disponibilidad—, pero se registra en la columna
*Ejecutabilidad prevista* de cada condición, con tres valores: *Ejecutable* (observable desde el
sitio público), *Requiere permisos admin* (exige escritura en el panel) y *Requiere pedido
completado* (exige una orden real confirmada). El registro fechado completo está en el
@sec:anexo-a.

#pagebreak()

// =====================================================================
= Planificación de pruebas <sec:planificacion>

Alcance de la planificación: FUN-05 checkout, FUN-06 confirmación, FUN-07 catálogo y stock
administrativo, FUN-08 pedidos, RNF-01, RNF-02 y RNF-03.

== Elementos de prueba <sec:plan-elementos>

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
) <tbl:elementos>

Lo no listado en @tbl:elementos queda fuera del bloque.

== Ambiente de prueba <sec:plan-ambiente>

*Escenario A — demo público compartido (`demo.opencart.com`).* Ambiente multiusuario, sin
aislamiento de sesión ni control del dato: terceros modifican catálogo y pedidos de forma
concurrente y el sitio se restablece periódicamente, lo que invalida precondiciones entre
ejecuciones. El usuario `demo` opera con permisos administrativos restringidos, por lo que guardar
en Catalog \> Products puede ser rechazado.

Restricción verificada el 24-09-2026: el host responde HTTP 403 con bloqueo de Cloudflare
(#lit[Sorry, you have been blocked]), tanto en el storefront como en el panel administrativo, cuya
ruta real es `https://demo.opencart.com/TlbeVW/` con credenciales publicadas por opencart.com
(`demo` / `demo`). Ray IDs observados: `a3ffd6a6fe936f20` y `a3ffdaf1d8966f2f`. El sitio
`opencart.com` sí carga, de modo que el bloqueo es del host del demo y no de la red del equipo.
Mientras persista, el bloque queda Bloqueado por impedimento externo: la *tasa de bloqueo* se
calcula sobre los casos *planificados*, no sobre los ejecutados, y la *tasa de aprobación* sobre
los casos *ejecutados*.

#alerta[
  *Validez de la evidencia en A:* una captura prueba el estado del sistema solo en ese instante y
  no es reproducible. Toda evidencia se fecha en el nombre del archivo y cita el identificador del
  pedido o producto observado.
]

*Escenario B — instancia controlada desplegada localmente (contingencia).* Base de datos y datos
semilla bajo control del equipo. Habilita permisos administrativos plenos, creación de pedidos
reales y configuración explícita de `Stock Checkout`, precondición de CP-CON-01, CP-CON-02,
CP-PED-01, CP-RNF-01 y CP-ADM-01.

*Validez de la evidencia en B:* es reproducible, y las pruebas de confirmación y de regresión
pueden repetirse sobre el mismo estado inicial. A cambio, los hallazgos se atribuyen a esa
instancia y no al demo oficial. Cada caso declara su escenario de ejecución.

- *Versión de OpenCart (demo e instancia local):* *4.0.2.3* (confirmada).
- *Escenario definitivo:* se ejecutó sobre el *escenario A, demo público* `demo.opencart.com`,
  accesible desde la red del responsable el 24-09-2026. No fue necesario desplegar la instancia
  local del escenario B, dado que el impedimento encontrado fue de permisos y de configuración
  publicada, no de disponibilidad.

== Navegadores seleccionados <sec:plan-navegadores>

Se adopta el conjunto propuesto por el caso, sin ampliarlo: *Chrome*, *Edge* y *Firefox* de
escritorio. Chrome y Edge comparten motor Chromium, por lo que Firefox aporta la única variación
real de renderizado; Edge se conserva por ser el navegador preinstalado del parque corporativo
típico.

RNF-02 se verifica con CP-RNF-02, ejecutando el flujo crítico completo —catálogo, ficha, carrito y
checkout— en cada navegador con un único juego de datos, de modo que las diferencias sean
atribuibles al navegador, y registrando veredicto y errores bloqueantes por navegador.

Versiones: la ejecución del 24-09-2026 se realizó en *Google Chrome 153* sobre macOS. Las versiones
de Edge y Firefox se registrarán cuando se complete CP-RNF-02, hoy en ejecución parcial.

== Herramientas <sec:plan-herramientas>

#figure(
  table(
    columns: (5.2cm, 1fr),
    table.header([Propósito], [Herramienta]),
    [Ejecución manual], [Chrome, Edge y Firefox, ventana privada por sesión],
    [Captura de evidencia], [Utilidad de captura del sistema operativo, nombre trazable (@sec:plan-config)],
    [Registro del testware], [Hoja de cálculo: casos, ejecución, defectos, trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto],
    [Medición RNF-03], [DevTools \> Network, caché deshabilitada, varias mediciones; cronómetro como control cruzado],
    [Medición RNF-01], [Marca de tiempo de confirmación frente a aparición en Sales \> Orders],
    [Gestión de pruebas], [*Qase* (`app.qase.io`), la herramienta de gestión de pruebas presentada en clase. Los ocho casos de este bloque se entregan además en formato CSV importable (`informe/qase_casos_granit.csv`), con su guía de importación y de registro del Test Run. Las tablas del presente informe se mantienen como respaldo autónomo del testware.],
  ),
  caption: [Herramientas de apoyo al bloque.],
) <tbl:herramientas>

Cualquier herramienta que se elija debe sostener la trazabilidad *Requisito ↔ caso ↔ ejecución ↔
defecto*; la condición de prueba (CT) se conserva como paso intermedio del análisis.

== Datos de prueba <sec:plan-datos>

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
) <tbl:datos-plan>

Los datos volátiles se re-verifican antes de cada ejecución. Si la precondición no se cumple, el
caso se marca *Bloqueado* con su causa, no *Fallido*.

== Recursos y responsabilidades <sec:plan-recursos>

#figure(
  table(
    columns: (5.4cm, 2.2cm, 1fr),
    table.header([Rol], [Persona], [Responsabilidad]),
    [Analista de QA — bloque transaccional y administrativo], [Granit],
      [Checkout, confirmación de pedidos, administración de catálogo y pedidos, requisitos no
       funcionales, consolidación, Gestión de la Configuración del testware y lecciones aprendidas],
    [Analista de QA — bloque de navegación y carrito], [Franco],
      [Catálogo, ficha de producto, carrito y cupones],
  ),
  caption: [Recursos y responsabilidades.],
) <tbl:recursos>

== Estimación de esfuerzo <sec:plan-esfuerzo>

Criterio declarado: *juicio experto por analogía* con bloques de pruebas funcionales manuales de
tamaño comparable. Horas de esfuerzo neto, sin holgura por reintentos del demo.

#figure(
  table(
    columns: (1fr, 2.2cm), align: (left, center),
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
) <tbl:esfuerzo>

== Cronograma <sec:plan-cronograma>

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
) <tbl:cronograma>

== Entregables del bloque <sec:plan-entregables>

- Esta sección de planificación.
- Registro de riesgos de proceso y de producto del bloque.
- Análisis de FUN-05 a FUN-08 y RNF-01 a RNF-03, con matriz de trazabilidad
  Requisito ↔ caso ↔ ejecución ↔ defecto, conservando la condición de prueba (CT) como paso
  intermedio del análisis.
- Ocho casos diseñados: CP-CHK-01, CP-CON-01, CP-CON-02, CP-ADM-01, CP-PED-01, CP-RNF-01,
  CP-RNF-02, CP-RNF-03.
- Registro de ejecución con veredicto por caso y causa explícita de cada Bloqueado.
- Evidencia gráfica nombrada según convención.
- Reporte de defectos con título `[Módulo/Funcionalidad] + [qué falla] + [bajo qué condición]`.
- Consolidado global, *estado frente a los criterios de salida CS1–CS4* y lecciones aprendidas.

== Gestión de la Configuración del testware <sec:plan-config>

- *Control de versiones del documento:* identificador `vMAJOR.MINOR` con autor, fecha y motivo del
  cambio en el encabezado de control. No se edita sobre una versión ya publicada.
- *Convención de nombres de evidencia:* `CP-XXX-NN_pasoNN_descripcion_AAAAMMDD.png`.
- *Repositorio:* carpeta `entregables/` con subcarpetas `evidencia/` por caso y `defectos/`.
  Repositorio remoto: `https://github.com/usuariogranit/Proyecto1_Caso3_OpenCart` (público, rama
  `main`).
- *Línea base:* se establece al cierre de H3 sobre casos diseñados y datos acordados; desde ese
  punto ningún caso se modifica sin control de cambios.
- *Control de cambios:* toda modificación posterior a la línea base se registra con caso afectado,
  motivo, responsable y fecha, e incrementa la versión.

== Supuestos y restricciones del demo <sec:plan-supuestos>

*Supuestos*

- La funcionalidad del demo es representativa de una instalación estándar de OpenCart.
- Las credenciales `demo` / `demo` siguen siendo las publicadas por el proveedor.
- De persistir el bloqueo, la ejecución se traslada al Escenario B y los resultados se atribuyen
  explícitamente a esa instancia.

*Restricciones*

- Al 24-09-2026 `demo.opencart.com` devuelve HTTP 403 por bloqueo de Cloudflare en storefront y
  panel; el bloqueo es del host del demo, no de la red del equipo.
- El usuario `demo` tiene permisos administrativos restringidos y puede no guardar cambios en
  Catalog \> Products.
- Los datos del demo son compartidos y volátiles y pueden ser alterados por terceros durante la
  ejecución.
- No hay control sobre servidor, caché ni red, lo que condiciona la medición de RNF-03.
- Sin acceso a logs ni a base de datos en el Escenario A, los defectos se documentan solo por
  comportamiento observable de caja negra.
- El caso no define el umbral numérico de RNF-01. #pendiente[umbral acordado con la docente]

#pagebreak()

// =====================================================================
= Gestión de riesgos <sec:riesgos>

== Método de evaluación <sec:riesgos-metodo>

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
    columns: (4.2cm, 3.0cm, 3.0cm, 3.0cm), align: center,
    table.header([Probabilidad \\ Impacto], [Alto], [Medio], [Bajo]),
    [*Alta*], [Alto], [Alto], [Medio],
    [*Media*], [Alto], [Medio], [Bajo],
    [*Baja*], [Medio], [Bajo], [Bajo],
  ),
  caption: [Matriz Probabilidad × Impacto → Nivel de riesgo.],
) <tbl:matriz-riesgo>

#nota[
  *Producto frente a proceso.* El riesgo de *producto* es que el sistema falle frente a un
  requisito y dañe al negocio (venta sin inventario, pedido duplicado, datos inconsistentes). El
  riesgo de *proyecto/proceso* es que el equipo no pueda ejecutar la prueba prevista (ambiente,
  permisos, datos, tiempo): no dice nada sobre la calidad del sistema, pero determina cuánta
  evidencia podremos obtener.
]

Las dos tablas de registro se presentan en orientación horizontal por su ancho (@sec:riesgos-proceso
y @sec:riesgos-producto).

#page(flipped: true)[
  == Riesgos de proceso <sec:riesgos-proceso>

  #figure(
    mini[
      #table(
        columns: (1.15cm, 2.7cm, 2.2cm, 2.9cm, 1.3cm, 1.3cm, 1.3cm, 2.4cm, 2.4cm, 1fr),
        table.header(
          [ID], [Riesgo], [Causa], [Efecto sobre las pruebas], [Prob], [Imp], [Nivel],
          [Mitigación], [Contingencia], [Estado],
        ),
        [RPR-01], [Sin permisos de escritura en el panel], [Usuario `demo` restringido por el proveedor],
          [CP-ADM-01 y precondiciones administrativas no ejecutables], [Alta], [Alto], [*Alto*],
          [Rediseñar lo administrativo como solo-lectura], [Instancia propia desde el acceso oficial],
          [*MATERIALIZADO* 18-09-2026: al guardar, el panel responde #lit[Warning: You do not have permission to modify coupons]],
        [RPR-02], [Datos alterados por otros usuarios], [Ambiente público multiusuario],
          [Precondiciones caducan; resultados no reproducibles], [Alta], [Medio], [*Alto*],
          [Verificar precondición justo antes de cada caso], [Re-ejecutar con producto alterno], [Vigente],
        [RPR-03], [Indisponibilidad del ambiente], [Bloqueo perimetral del host del demo],
          [Ejecución detenida; bloque completo Bloqueado], [Alta], [Alto], [*Alto*],
          [Verificar disponibilidad antes de cada sesión], [Instancia propia y replanificar cronograma],
          [*MATERIALIZADO* 24-09-2026: `demo.opencart.com` devuelve HTTP 403 con Cloudflare],
        [RPR-04], [Sesiones contaminadas entre casos], [Carrito, cookies y sesión persistentes],
          [Veredictos falsos por estado heredado], [Media], [Medio], [*Medio*],
          [Ventana limpia por caso; cerrar sesión], [Repetir en perfil nuevo], [Vigente],
        [RPR-05], [Imposibilidad de generar un pedido real], [Checkout interrumpido por control de inventario],
          [CP-CON-01/02, CP-PED-01 y CP-RNF-01 sin precondición], [Alta], [Alto], [*Alto*],
          [Verificar stock antes de iniciar], [Instancia propia con `Stock Checkout` controlado],
          [*MATERIALIZADO* 18-09-2026: no fue posible completar el checkout],
        [RPR-06], [Productos sin datos válidos], [Catálogo degradado por uso público],
          [Datos insuficientes para RF CHK 05 y RF ADM 06], [Media], [Medio], [*Medio*],
          [Inventariar productos aptos al abrir sesión], [Sustituir por equivalente y documentarlo], [Vigente],
        [RPR-07], [Flujos bloqueados por configuración], [Guest Checkout, pago o envío deshabilitados],
          [Requisitos no verificables aun con ambiente arriba], [Alta], [Alto], [*Alto*],
          [Revisar configuración antes de diseñar pasos], [Declarar Bloqueado con su causa], [Vigente],
        [RPR-08], [Ambiente único sin alterno aprobado], [Instancia propia aún como decisión pendiente],
          [Un solo punto de falla para todo el bloque], [Media], [Alto], [*Alto*],
          [Escalar la decisión antes de ejecutar], [Preparar instancia propia en paralelo], [Vigente],
        [RPR-09], [Evidencia no reproducible por deriva del ambiente], [El dato cambia entre captura y revisión],
          [Hallazgos cuestionables en revisión], [Media], [Medio], [*Medio*],
          [Captura fechada; registrar URL y hora], [Re-capturar y anotar la discrepancia], [Vigente],
        [RPR-10], [Umbrales de RNF 01 y RNF 03 sin acordar], [El avance los deja «por acordar»],
          [Sin criterio de aceptación no hay veredicto], [Alta], [Medio], [*Alto*],
          [Acordar umbral y método antes del diseño], [Reportar la medición como observación], [Vigente],
        [RPR-11], [Pérdida o descontrol del testware], [Gestión de la Configuración informal],
          [Versiones divergentes de casos y evidencia], [Baja], [Medio], [*Bajo*],
          [Repositorio único versionado], [Reconstruir desde la última línea base], [Vigente],
      )
    ],
    caption: [Registro de riesgos de proceso del bloque del Integrante 2.],
  ) <tbl:riesgos-proceso>
]

#page(flipped: true)[
  == Riesgos de producto <sec:riesgos-producto>

  #figure(
    mini[
      #table(
        columns: (1.15cm, 3.0cm, 2.3cm, 2.5cm, 1fr, 1.3cm, 1.3cm, 1.3cm, 2.6cm, 2.6cm, 1.9cm),
        table.header(
          [ID], [Riesgo], [Requisito(s) afectado(s)], [Causa], [Efecto sobre las pruebas],
          [Prob], [Imp], [Nivel], [Mitigación], [Contingencia], [Estado],
        ),
        [RPD-01], [El checkout no completa la compra con datos válidos], [RF CHK 01–04],
          [Validaciones o métodos de envío/pago mal aplicados], [Invalida el flujo transaccional principal],
          [Media], [Alto], [*Alto*], [CP-CHK-01 Alta; equivalencia y valores límite],
          [Aislar la etapa y trazar el defecto a su RF], [Potencial],
        [RPD-02], [El checkout no conserva productos, cantidades u opciones], [RF CHK 05],
          [Recálculo entre etapas], [Cobro distinto al aceptado], [Baja], [Alto], [*Medio*],
          [Comparar campo a campo carrito frente a resumen], [Reproducir con carrito multiproducto], [Potencial],
        [RPD-03], [Sin identificador de orden o resumen no coincidente], [RF CON 01, 02, 04],
          [Falla en la creación de la orden], [Cliente sin evidencia de la operación], [Baja], [Alto], [*Medio*],
          [CP-CON-01: total antes y después de confirmar], [Contrastar con el detalle administrativo], [Potencial],
        [RPD-04], [Pedidos duplicados por doble clic, recarga o retorno], [RF CON 03],
          [Confirmación sin idempotencia], [Doble cargo y reclamo], [Media], [Alto], [*Alto*],
          [CP-CON-02 con las tres variantes de reenvío], [Verificar conteo de órdenes en el panel], [Potencial],
        [RPD-05], [Inconsistencia entre sitio público y panel], [RF ADM 02, 04, 07 · RNF 01],
          [Caché o propagación diferida], [Operación decide sobre datos falsos], [Media], [Alto], [*Alto*],
          [CP-ADM-01 y CP-RNF-01 con marca de tiempo], [Medir el desfase contra el umbral], [Potencial],
        [RPD-06], [Pedido confirmado ausente en la lista administrativa], [RF PED 01, 02],
          [Falla de persistencia o sincronización], [Pedido invisible para operaciones], [Baja], [Alto], [*Medio*],
          [CP-PED-01: comparar identificador y detalle], [Buscar por filtros alternos antes de reportar], [Potencial],
        [RPD-07], [Pérdida de sesión administrativa], [RF ADM 01–07 · RF PED 01–05],
          [Expiración del token de sesión], [Simula bloqueos falsos], [Media], [Medio], [*Medio*],
          [Reautenticar al inicio de cada caso], [Repetir con sesión recién abierta], [Potencial],
        [RPD-08], [Desfase de sincronización sobre el umbral], [RNF 01 · RF ADM 07],
          [Latencia de propagación], [Sobreventa durante la ventana de desfase], [Media], [Medio], [*Medio*],
          [Medición repetida en CP-RNF-01], [Observación si falta umbral (RPR-10)], [Potencial],
        [RPD-09], [Flujo crítico fallido en algún navegador seleccionado], [RNF 02 · RF CHK 01–05],
          [Diferencias de motor de render o scripting], [Segmento de clientes sin poder comprar],
          [Media], [Medio], [*Medio*], [CP-RNF-02 en Chrome, Edge y Firefox],
          [Documentar navegador y versión exactos], [Potencial],
        [RPD-10], [La gestión del pedido altera importes o productos], [RF PED 04, 05],
          [Efecto lateral del cambio de estado], [Descuadre contable], [Baja], [Alto], [*Medio*],
          [Comparar totales antes y después del cambio], [Contrastar con el historial del pedido], [Potencial],
        [RPD-11], [Compra permitida por encima del stock disponible], [RF ADM 03],
          [Política de `Stock Checkout` mal aplicada], [Venta sin inventario real], [Media], [Alto], [*Alto*],
          [CP-ADM-01 con cantidad cero y sobre stock], [Verificar configuración antes de calificar], [Potencial],
        [RPD-12], [Catálogo responde por encima de dos segundos], [RNF 03],
          [Carga del demo compartido], [Abandono de navegación], [Media], [Bajo], [*Bajo*],
          [CP-RNF-03: varias mediciones, caché y red documentadas], [Medición sin veredicto si falta umbral], [Potencial],
      )
    ],
    caption: [Registro de riesgos de producto del bloque del Integrante 2.],
  ) <tbl:riesgos-producto>
]

Los riesgos marcados *Potencial* no han sido observados: son hipótesis de falla que orientan el
diseño. Solo los tres *MATERIALIZADO* cuentan con evidencia fechada.

== Riesgos residuales del análisis de riesgos <sec:riesgos-residuales>

Aun ejecutando todo el bloque queda sin cubrir:

+ la *concurrencia* —dos clientes comprando la última unidad—, que el demo no permite controlar;
+ la *integración real de pago*, al operar con métodos de prueba;
+ la *persistencia a largo plazo* de los pedidos, porque el ambiente compartido se restablece;
+ los *navegadores móviles*, fuera del conjunto de RNF 02;
+ toda verificación que exija *escritura administrativa* mientras persista RPR-01.

Se trasladan al cierre como *riesgo residual documentado, pendiente de aceptación por el
responsable de negocio*, dentro del estado frente a los criterios de salida, no como cobertura
lograda.

== Vínculo riesgo → prioridad de prueba <sec:riesgos-prioridad>

La prioridad de cada condición y caso se deriva del *nivel de riesgo*, no del orden del enunciado:
los casos que atacan riesgos Altos se ejecutan primero y son los que condicionan el *estado frente
a los criterios de salida* (CS1–CS4, @sec:consolidacion). El criterio es el impacto de negocio.

- Una *venta sin inventario real* (RPD-11) genera incumplimiento con el cliente y costo operativo
  de reposición o cancelación: por eso CP-ADM-01 es Alta.
- Un *pedido duplicado* (RPD-04) implica doble cargo y reclamo, lo que sostiene la prioridad Alta de
  CP-CON-02.
- Una *inconsistencia sitio–panel* (RPD-05, RPD-06) hace que operaciones decida sobre datos falsos
  —despachar lo que no existe o ignorar un pedido real—, de ahí la prioridad Alta de CP-PED-01 y
  CP-RNF-01.
- Los riesgos Medio y Bajo sustentan casos de prioridad menor, ejecutables solo si el ambiente lo
  permite.

En sentido inverso, los riesgos de proceso Altos determinan qué casos se declaran *Bloqueados*: la
*tasa de bloqueo* se calcula sobre los casos *planificados*, no sobre los ejecutados, mientras que
la *tasa de aprobación* se calcula sobre los casos *ejecutados*.

#pagebreak()

// =====================================================================
= Análisis de pruebas <sec:analisis>

Fecha de análisis: 24-09-2026. Bloque: FUN 05 Checkout · FUN 06 Confirmación · FUN 07 Productos,
categorías y stock · FUN 08 Gestión de pedidos · RNF 01–03.

== Condiciones de prueba <sec:analisis-condiciones>

=== FUN 05 — Checkout como invitado o registrado <sec:analisis-chk>

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
) <tbl:cond-chk>

=== FUN 06 — Confirmación y resumen del pedido <sec:analisis-con>

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
) <tbl:cond-con>

=== FUN 07 — Productos, categorías y stock (panel) <sec:analisis-adm>

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
) <tbl:cond-adm>

=== FUN 08 — Gestión de pedidos (panel) <sec:analisis-ped>

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
) <tbl:cond-ped>

=== RNF 01–03 <sec:analisis-rnf>

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
) <tbl:cond-rnf>

*Total: 33 condiciones derivadas.*

== Justificación de las condiciones de prioridad Alta <sec:analisis-justificacion>

- *CT-CHK-01* — Forzar el registro pierde la venta en el punto de mayor intención de compra:
  abandono directo del carrito.
- *CT-CHK-02* — Un checkout de invitado que no cierra anula el canal de venta completo.
- *CT-CHK-04* — Datos obligatorios vacíos generan envíos fallidos y costo operativo de reproceso.
- *CT-CHK-05* — Correo o teléfono inválidos impiden notificar y coordinar la entrega.
- *CT-CHK-06* — Confirmar sin envío o pago válido produce órdenes impagas o no despachables.
- *CT-CHK-07* — Diferencia entre carrito y checkout es cobro indebido o descuento perdido.
- *CT-CON-01* — Sin número de orden único no hay soporte, seguimiento ni conciliación contable.
- *CT-CON-02* — Sin confirmación visible el cliente repite la compra o reclama un cobro.
- *CT-CON-03* — El resumen es la evidencia del contrato de venta.
- *CT-CON-04* — Que el total cambie al confirmar es cobro no consentido.
- *CT-CON-05* — El pedido duplicado cobra y despacha dos veces.
- *CT-CON-06* — Exigir registro después de pagar niega al invitado su evidencia de compra.
- *CT-ADM-01* — Datos que no persisten obligan a reeditar el catálogo.
- *CT-ADM-02 / CT-ADM-03* — Vender lo inexistente causa incumplimiento de entrega.
- *CT-ADM-04* — Sin control de stock al confirmar se comprometen unidades inexistentes.
- *CT-ADM-06* — Si la reposición no se refleja, se pierden ventas de producto disponible.
- *CT-ADM-08* — Opciones u obligatoriedad perdidas producen pedidos incompletos.
- *CT-ADM-10* — Sin propagación, cada cambio comercial exige intervención técnica.
- *CT-PED-01* — Un pedido cobrado que no llega al panel no se despacha.
- *CT-PED-02* — Detalle divergente provoca envíos equivocados y reprocesos.
- *CT-PED-05* — Importes que cambian sin acción destruyen la integridad contable.
- *CT-RNF-01* — La demora de sincronización degrada el compromiso de entrega.
- *CT-RNF-04* — Un catálogo por encima de dos segundos reduce la conversión.

== Matriz de trazabilidad Requisito ↔ caso ↔ ejecución ↔ defecto <sec:analisis-trazabilidad>

Esta matriz documenta los eslabones *requisito ↔ caso*; el eslabón *ejecución* se registra en
@sec:ejecucion y el eslabón *defecto* en @sec:defectos.

#figure(
  block(width: 100%, breakable: false)[
    #let sep = 0.60cm
    #let cols = (1fr, sep, 1fr, sep, 1fr, sep, 1fr, sep, 1fr)
    #grid(
      columns: cols, align: center + horizon, row-gutter: 4pt,
      text(size: 7pt, fill: UTEC-GRAY)[ESLABÓN 1 · Requisito], [],
      text(size: 7pt, fill: UTEC-GRAY)[paso intermedio · Condición], [],
      text(size: 7pt, fill: UTEC-GRAY)[ESLABÓN 2 · Caso], [],
      text(size: 7pt, fill: UTEC-GRAY)[ESLABÓN 3 · Ejecución], [],
      text(size: 7pt, fill: UTEC-GRAY)[ESLABÓN 4 · Defecto],
      caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN)[*RF CHK 04*], flecha-h,
      caja(fondo: UTEC-GRAY-SUAVE, borde: UTEC-GRAY)[*CT-CHK-04*], flecha-h,
      caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN)[*CP-CHK-01*], flecha-h,
      caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN)[*Ejecución\ 24-09-2026*], flecha-h,
      caja(fondo: C-FALLO.fondo, borde: C-FALLO.borde)[*DEF-04*],
      text(size: 7pt)[Qué debe cumplir el sistema], [],
      text(size: 7pt)[Qué comprobar, sin cómo], [],
      text(size: 7pt)[Cómo comprobarlo, con datos], [],
      text(size: 7pt)[Qué se observó y cuándo], [],
      text(size: 7pt)[Qué falló y con qué impacto],
    )
    #v(4pt)
    #align(center)[#text(size: 7.6pt, fill: UTEC-GRAY)[Cadena real registrada en @sec:defectos-def-04: se muestra el primer elemento de cada conjunto declarado.]]
  ],
  kind: image,
  supplement: [Figura],
  caption: [Cadena de trazabilidad de cuatro eslabones, con la condición de prueba como paso intermedio del análisis.],
) <fig:cadena-trazabilidad>

La cadena completa que DEF-04 declara en @sec:defectos-def-04 es
*RF CHK 04 / RF CON 01 / RF ADM 07 / RNF 01 → CT-CHK-04, CT-RNF-01 → CP-CHK-01, CP-CON-01, CP-RNF-01
→ ejecución del 24-09-2026 → DEF-04*.

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
) <tbl:trazabilidad>

Sin elementos huérfanos: los 24 requisitos tienen al menos una condición y las 33 condiciones
tienen destino (caso asignado o justificación explícita de no cobertura).

== Análisis de cobertura <sec:analisis-cobertura>

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
) <tbl:cobertura>

Cobertura de condiciones por caso diseñado: *23 de 33 (70 %)*; *10 condiciones* quedan fuera de
esta iteración y *9 requisitos* (RF CHK 02, RF CHK 05, RF ADM 01, RF ADM 04, RF ADM 05, RF ADM 06,
RF PED 03, RF PED 04, RF PED 05) no tienen caso asignado.

*Huecos conscientes.* No son aleatorios: se concentran en las condiciones que exigen *escritura en
el panel* (CT-ADM-01, 06, 07, 08; CT-PED-04, 05) y en las de prioridad Media con baja relación
riesgo/esfuerzo (CT-CHK-03, CT-PED-03).

#pagebreak()

// =====================================================================
= Diseño de pruebas <sec:diseno>

== Introducción al diseño <sec:diseno-intro>

Los ocho casos derivan de las condiciones *CT-XX* de @sec:analisis, que descomponen los requisitos
RF CHK, RF CON, RF ADM, RF PED y RNF 01–03. La condición dice *qué* comprobar; el caso añade
*cómo*, con qué datos y contra qué resultado verificable.

== CP-CHK-01 · Checkout como invitado <sec:diseno-cp-chk-01>

#campo[Condición:][CT-CHK-01, 02, 04, 06; CT-CON-06]
#campo[Requisito(s):][RF CHK 01, 03, 04; RF CON 04]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Partición de equivalencia*: los campos admiten infinitos valores, así que se agrupan en clases que el sistema debe tratar igual —válida (completa) e inválida (vacía)— y se prueba un representante de cada una.]
#campo[Precondiciones:][Ventana privada, sin sesión ni carrito previo, desde origen de red autorizado.]
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
#campo[Criterio de aceptación:][Confirmación alcanzada sin registro, bloqueo específico del campo vacío y envío y pago seleccionables. Si el caso alcanza el selector y no ofrece el pago habilitado, *Falló* (DEF-04).]

== CP-CON-01 · Generación de número y resumen del pedido <sec:diseno-cp-con-01>

#campo[Condición:][CT-CON-01, 02, 03, 04]
#campo[Requisito(s):][RF CON 01, 02]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Pruebas basadas en casos de uso*: se verifica el recorrido completo de «confirmar una compra» hasta su salida observable.]
#campo[Precondiciones:][CP-CHK-01 alcanzó la confirmación con envío y pago seleccionados.]
#campo[Datos:][iPod Nano (36) × 2. Referencias del 24-09-2026: Sub-Total `$200.00`, Eco Tax (-2.00) `$4.00`, VAT (20 %) `$40.00`, Total `$244.00`; línea `$242.00`; resumen `2x iPod Nano $242.00`.]

*Pasos:*

+ Capturar el resumen final: descripción, cantidad, importe de línea y los cuatro totales.
+ Comprobar que Sub-Total + Eco Tax + VAT es igual al Total.
+ Comprobar que el importe de línea de `2x iPod Nano` es igual al Sub-Total.
+ Pulsar #lit[Confirm Order] una sola vez.
+ Registrar la URL de destino y el identificador de orden.
+ Comparar campo por campo el resumen confirmado contra el del paso 1.

#campo[Resultado esperado:][Aparece una confirmación con identificador único y no vacío, cuyo resumen repite sin diferencias productos, cantidades, impuestos y Total.]
#campo[Criterio de aceptación:][Hay identificador, el Total antes y después de confirmar es idéntico y ningún importe difiere del carrito.]

== CP-CON-02 · Prevención de pedido duplicado <sec:diseno-cp-con-02>

#campo[Condición:][CT-CON-05]
#campo[Requisito(s):][RF CON 03]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Transición de estados*: el proceso tiene estados definidos —#emph[carrito con contenido] → #emph[pedido creado] → #emph[reintento]— y el defecto buscado es una transición inválida.]
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

#campo[Resultado esperado:][Los eventos de los pasos 2, 4 y 6 no crean un segundo pedido.]
#campo[Criterio de aceptación:][Un solo identificador por recorrido del checkout en los tres reintentos.]

== CP-ADM-01 · Producto con stock cero reflejado públicamente <sec:diseno-cp-adm-01>

#campo[Condición:][CT-ADM-02, 03, 04, 05]
#campo[Requisito(s):][RF ADM 02, 03]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Tabla de decisión*: el comportamiento depende de tres variables combinadas —cantidad, estado publicado y política de venta sin inventario (`Stock Checkout`)—.]
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
  caption: [Tabla de decisión de CP-ADM-01.],
) <tbl:cp-adm-decision>

#campo[Datos:][R1/R2 — *MacBook (43)*, #emph[Out Of Stock], conserva activo #lit[Add to Cart]. R3 — *iPod Nano (36)* × 2. R4 — *HTC Touch HD (28)* e *iPod Touch (32)*. Aviso: #lit[Products marked with \*\*\* are not available in the desired quantity or not in stock!].]

*Pasos:*

+ Autenticarse en el panel; anotar el valor vigente de `Stock Checkout`.
+ Abrir Catalog \> Products \> MacBook (43); verificar cantidad `0` y #emph[Out Of Stock].
+ Abrir su ficha pública; registrar disponibilidad y estado de #lit[Add to Cart].
+ Pulsar #lit[Add to Cart] y abrir el carrito; registrar si hay `***` y el aviso.
+ Pulsar #lit[Checkout]; registrar si el flujo avanza.
+ Repetir los pasos 3 a 5 con HTC Touch HD (28) e iPod Touch (32) — R4.
+ Repetir los pasos 3 a 5 con iPod Nano (36) × 2 — R3.
+ Contrastar cada resultado con su fila de @tbl:cp-adm-decision.

#campo[Resultado esperado:][Cada combinación produce la acción de su regla.]
#campo[Criterio de aceptación:][Las cuatro reglas se cumplen.]

== CP-PED-01 · Pedido público visible en administración <sec:diseno-cp-ped-01>

#campo[Condición:][CT-PED-01, 02]
#campo[Requisito(s):][RF PED 01, 02]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Pruebas basadas en casos de uso*: «preparar un pedido recibido» atraviesa dos interfaces.]
#campo[Precondiciones:][Existe el pedido de CP-CON-01 con identificador registrado; sesión autenticada con lectura de Sales \> Orders.]
#campo[Datos:][Identificador del pedido de CP-CON-01; correo `qa.cs5383.test@example.com`; detalle esperado iPod Nano (36) × 2 y Total `$244.00`.]

*Pasos:*

+ Anotar la hora de confirmación pública y el identificador del pedido.
+ Autenticarse en `https://demo.opencart.com/TlbeVW/` y abrir Sales \> Orders.
+ Localizar el pedido por su identificador y abrir su detalle.
+ Comparar producto, cantidad, los cuatro totales y los datos del cliente contra el resumen público de CP-CON-01.

#campo[Resultado esperado:][El pedido aparece en Sales \> Orders con *el mismo identificador* mostrado al cliente.]
#campo[Criterio de aceptación:][Identificador idéntico en ambas vistas; cero diferencias en producto, cantidad e importes.]

== CP-RNF-01 · Sincronización entre sitio y panel <sec:diseno-cp-rnf-01>

#campo[Condición:][CT-ADM-10; CT-RNF-01, 02]
#campo[Requisito(s):][RNF 01; RF ADM 07]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Transición de estados*: el dato recorre estados observables —#emph[publicado anterior] → #emph[guardado] → #emph[propagado]—.]
#campo[Precondiciones:][Sesión autenticada con escritura en Catalog \> Products. *Umbral de sincronización acordado por el equipo antes del diseño: 60 segundos* (CT-RNF-02).]
#campo[Datos:][iPod Nano (36). Cambio: cantidad a `0`, estado a #emph[Out Of Stock].]

*Pasos:*

+ Abrir la ficha pública de iPod Nano (36); registrar disponibilidad y hora.
+ Abrir Catalog \> Products \> iPod Nano (36); anotar la cantidad vigente.
+ Cambiar la cantidad a `0` y el estado a #emph[Out Of Stock]; guardar y registrar la hora.
+ Sin reiniciar servicios ni limpiar caché, recargar la ficha pública en ventana privada.
+ Repetir la recarga cada 15 segundos hasta ver el valor nuevo o cumplir 60 s.
+ Registrar el tiempo entre el paso 3 y la primera recarga con el valor nuevo.
+ Revertir al valor del paso 2 y verificar su propagación igual.

#campo[Resultado esperado:][El valor nuevo aparece en el sitio público en 60 s o menos desde el guardado.]
#campo[Criterio de aceptación:][Propagación ≤ 60 s en cambio y reversión. Si el guardado se rechaza por permisos: *Bloqueado*.]

== CP-RNF-02 · Flujo crítico en navegadores seleccionados <sec:diseno-cp-rnf-02>

#campo[Condición:][CT-RNF-03]
#campo[Requisito(s):][RNF 02]
#campo[Prioridad:][Media]
#campo[Técnica y justificación:][*Partición de equivalencia*: el universo de navegadores es inabarcable, así que se particiona por motor de renderizado —Chromium (Chrome, Edge) y Gecko (Firefox)—.]
#campo[Precondiciones:][Chrome, Edge y Firefox de escritorio, en ventana privada, con sus versiones anotadas.]
#campo[Datos:][Un único juego para los tres: categoría `Laptops & Notebooks` (`path=18`), iPod Nano (36) × 2 y la identidad y dirección de invitado de CP-CHK-01.]

*Pasos:*

+ Anotar la versión exacta del navegador en uso.
+ Entrar en la categoría; comprobar que los productos se listan con imagen y precio.
+ Abrir la ficha de iPod Nano (36); comprobar precio, disponibilidad y botón #lit[Add to Cart].
+ Añadir cantidad `2` y abrir el carrito.
+ Pulsar #lit[Checkout], elegir Guest Checkout e introducir los datos de prueba.
+ Registrar la etapa alcanzada y todo error bloqueante, con su texto literal.
+ Repetir los pasos 1 a 6 en los tres navegadores; comparar las etapas.

#campo[Resultado esperado:][Catálogo, ficha, carrito y checkout se completan en los tres navegadores sin error bloqueante propio del navegador.]
#campo[Criterio de aceptación:][Cero errores bloqueantes propios de un navegador y comportamiento equivalente entre Chromium y Gecko.]

#pagebreak()
== CP-RNF-03 · Medición del tiempo de respuesta del catálogo <sec:diseno-cp-rnf-03>

#campo[Condición:][CT-RNF-04, 05]
#campo[Requisito(s):][RNF 03]
#campo[Prioridad:][*Alta*]
#campo[Técnica y justificación:][*Análisis de valores límite*: el riesgo se concentra junto al umbral; los límites examinados son *1999, 2000 y 2001 ms*.]
#campo[Precondiciones:][Navegador con DevTools, red y equipo declarados, ventana privada. Criterio de medición en @sec:ejecucion-rnf03.]
#campo[Datos:][Categorías `Cameras` (`path=33`), `Desktops` (`path=20`), `Laptops & Notebooks` (`path=18`). Umbral `2000 ms`.]

*Pasos:*

+ Abrir ventana privada; deshabilitar la caché en DevTools \> Network.
+ Medición 1: cargar `Cameras` (`path=33`) sin caché.
+ Medición 2: cargar `Desktops` (`path=20`) como navegación subsecuente.
+ Medición 3: cargar `Laptops & Notebooks` (`path=18`) como navegación subsecuente.
+ Medición 4: recargar `Cameras` (`path=33`) con caché habilitada.
+ Anotar red, equipo, hora y número de recursos cargados en la medición 1.
+ Clasificar cada medición contra los límites 1999 / 2000 / 2001 ms.

#campo[Resultado esperado:][Las cuatro mediciones de carga completa son *estrictamente menores que 2000 ms*.]
#campo[Criterio de aceptación:][Cuatro mediciones bajo 2000 ms y criterio documentado según CT-RNF-05.]

== Tabla resumen de los ocho casos <sec:diseno-resumen>

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
) <tbl:resumen-casos>

*Ejecutabilidad.* Dos casos son *Ejecutables* al momento del diseño (CP-RNF-02, CP-RNF-03); cuatro
requieren pedido completado y dos, permisos administrativos.

== Especificación de datos de prueba <sec:diseno-datos>

#figure(
  chico[
    #table(
      columns: (3.4cm, 4.4cm, 2.2cm, 1fr),
      table.header([Dato], [Valor concreto], [¿Volátil?], [Verificación antes de ejecutar]),
      [Producto elegible], [iPod Nano `36`], [Sí], [#emph[In Stock]; añadir 2 unidades y comprobar que no lleva `***`],
      [Cantidad de compra], [`2`], [No], [Fijada por el diseño],
      [Disponibles pero rechazados en carrito], [HTC Touch HD `28`, iPod Touch `32`], [Sí], [Añadirlos y comprobar `***`],
      [Agotados], [MacBook `43`; iPhone `40`, iMac `41`, MacBook Air `44`, MacBook Pro `45`], [Sí], [Confirmar #emph[Out Of Stock] antes de usarlos],
      [Con opción obligatoria, excluidos como dato base], [Product 8 `35`; Apple Cinema 30" `42`], [Bajo], [No usarlos como sustitutos: añaden una variable ajena],
      [Identidad de invitado], [`Test` / `QA CS5383` / `qa.cs5383.test@example.com`], [No], [Ficticia, definida por el equipo],
      [Dirección de invitado], [`Av. Prueba 123`, `London`, `SW1A 1AA`, `United Kingdom`, `Greater London`], [No], [País y región presentes en los desplegables],
      [Totales de referencia (2 × iPod Nano)], [Sub-Total `$200.00`; Eco Tax `$4.00`; VAT `$40.00`; Total `$244.00`], [Sí], [Recapturar el carrito ese día y comparar],
      [Credenciales administrativas], [`demo` / `demo` en `https://demo.opencart.com/TlbeVW/`], [Permisos volátiles], [Probar un guardado inocuo],
      [`Stock Checkout`], [System \> Settings \> Option], [Sí], [Anotar el valor al inicio y al final],
      [Identificador del pedido de referencia], [Generado en CP-CON-01], [Sí], [Anotarlo con su hora],
      [Categorías de medición], [`Cameras 33`, `Desktops 20`, `Laptops & Notebooks 18`], [Bajo], [La categoría lista productos],
      [Umbrales], [`2000 ms` de carga completa; `60 s` de sincronización], [No], [RNF 03 y acuerdo previo del equipo (CT-RNF-02)],
      [Origen de red], [Navegador local del responsable], [Sí], [La portada carga; desde IP de datacenter responde HTTP 403],
    )
  ],
  caption: [Especificación de datos de prueba del bloque.],
) <tbl:especificacion-datos>

*Regla común a todo dato volátil:* se registra el valor observado y su hora en la bitácora de
ambiente (@sec:anexo-a) antes de ejecutar; sin esa entrada del día la ejecución no es válida.

== Técnicas de diseño aplicadas <sec:diseno-tecnicas>

#figure(
  table(
    columns: (4.4cm, 3.6cm, 1fr),
    table.header([Técnica de caja negra], [Casos donde se aplica], [Qué particiona o modela]),
    [Partición de equivalencia], [CP-CHK-01, CP-RNF-02], [Clases de valor por campo y clases de motor de renderizado],
    [Análisis de valores límite], [CP-RNF-03], [Umbral de 2 s: límites 1999, 2000 y 2001 ms],
    [Tabla de decisión], [CP-ADM-01], [Combinación de cantidad, estado publicado y política de venta sin inventario],
    [Transición de estados], [CP-CON-02, CP-RNF-01], [Carrito → pedido creado → reintento; publicado → guardado → propagado],
    [Pruebas basadas en casos de uso], [CP-CON-01, CP-PED-01], [Recorrido de extremo a extremo de «confirmar una compra» y de «preparar un pedido recibido»],
  ),
  caption: [Técnicas de diseño aplicadas y su ámbito en el bloque.],
) <tbl:tecnicas>

#pagebreak()

// =====================================================================
= Ejecución manual <sec:ejecucion>

Fecha de ejecución: 24-09-2026 · Sistema: OpenCart Demo 4.0.2.3 (`demo.opencart.com`) · Ambiente:
@sec:anexo-a. Origen de acceso: navegador local del responsable.

== Datos de prueba utilizados <sec:ejecucion-datos>

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
) <tbl:ejecucion-datos>

== Estado del catálogo observado (24-09-2026) <sec:ejecucion-catalogo>

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
) <tbl:catalogo>

#page(flipped: true)[
  == Resultados por caso: esperado, obtenido y veredicto <sec:ejecucion-resultados>

  #figure(
    chico[
      #table(
        columns: (3.4cm, 5.2cm, 1fr, 2.9cm, 3.6cm),
        table.header([Caso], [Resultado esperado], [Resultado obtenido], [Veredicto], [Causa]),
        [CP-CHK-01 Checkout como invitado],
          [El flujo continúa sin exigir creación de cuenta y permite completar la compra],
          [Guest Checkout disponible; datos guardados con #lit[Success: Your guest account information has been saved!]; el flujo se detiene antes del pago: #lit[No Payment options are available. Please contact us for assistance!] y no existe sección #lit[Shipping Method]],
          [#veredicto("Bloqueado", detalle: [(parcialmente verificado)])],
          [Ambiente sin métodos de pago ni envío configurados],
        [CP-CON-01 Generación de número y resumen del pedido],
          [Se crea un único número de orden y se muestra confirmación],
          [#lit[Confirm Order] no genera pedido, no navega y no emite mensaje alguno],
          [#veredicto("Bloqueado")], [Dependencia de CP-CHK-01],
        [CP-CON-02 Prevención de pedido duplicado],
          [Doble clic o recarga no generan dos órdenes],
          [No ejecutable: no es posible generar una primera orden],
          [#veredicto("Bloqueado")], [Dependencia de CP-CON-01],
        [CP-ADM-01 Stock cero reflejado públicamente],
          [El sitio público impide comprar el producto agotado],
          [Pendiente: requiere sesión administrativa autenticada por el responsable],
          [#veredicto("Pendiente")], [Login manual no realizado aún],
        [CP-PED-01 Pedido público visible en administración],
          [El pedido aparece en Sales \> Orders con el mismo identificador],
          [No ejecutable: no existe pedido que consultar],
          [#veredicto("Bloqueado")], [Dependencia de CP-CON-01],
        [CP-RNF-01 Sincronización sitio–panel],
          [El cambio administrativo se refleja en el sitio público sin reinicio],
          [Pendiente: requiere permisos de escritura en el panel],
          [#veredicto("Pendiente")], [Login manual + permisos],
        [CP-RNF-02 Flujo crítico en navegadores],
          [El flujo se completa en los navegadores seleccionados],
          [Pendiente], [#veredicto("Pendiente")], [Falta ejecución multi-navegador],
        [CP-RNF-03 Tiempo de respuesta del catálogo],
          [Respuesta menor a 2 segundos],
          [Pendiente], [#veredicto("Pendiente")], [Falta medición instrumentada],
      )
    ],
    caption: [Registro de ejecución del 24-09-2026: resultado esperado, obtenido y veredicto por caso.],
  ) <tbl:resultados-ejecucion>
]

#figure(
  image("evidencias/gestion-20260924/OC-05_checkout-sin-pago.jpg", width: 100%, height: 13cm, fit: "contain"),
  caption: [E-03: selector sin métodos de pago, datos ficticios y botón Confirm Order deshabilitado. Verificación complementaria.],
) <fig:e-03-checkout>

== Observación metodológica de la ejecución <sec:ejecucion-observacion>

Los veredictos *Bloqueado* se sustentan en impedimentos del ambiente registrados en bitácora con
texto literal del sistema, no en supuestos. Ninguno se contabiliza como aprobado ni como fallido.

*Denominadores.* La *tasa de bloqueo* se calcula sobre los casos *planificados*; la *tasa de
aprobación*, sobre los casos *ejecutados*. Los tres denominadores se fijan en
@sec:consolidacion-denominadores. Las cifras del primer corte —antes del acceso al panel— quedan
registradas en @sec:ejecucion-metricas-parciales a título de trazabilidad; *las cifras válidas son
las del cierre* (@sec:consolidacion-metricas).

== Actualización de veredictos tras el acceso al panel administrativo (24-09-2026) <sec:ejecucion-actualizacion>

La verificación administrativa (Extensions \> Payments y Extensions \> Shipping) demostró que los
métodos de pago y envío están habilitados y sin restricción de zona. Por lo tanto, la imposibilidad
de pagar *no es una limitación del ambiente sino el defecto DEF-04*.

#figure(
  chico[
    #table(
      columns: (3.0cm, 3.0cm, 3.9cm, 1fr),
      table.header([Caso], [Veredicto anterior], [Veredicto actualizado], [Sustento]),
      [CP-CHK-01], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Falló")], [RF CHK 01 exige completar la compra sin crear cuenta; el sistema lo impide por DEF-04. Además arrastra DEF-01 en los importes],
      [CP-CON-01], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Bloqueado", detalle: [por defecto DEF-04])], [No es posible confirmar un pedido mientras el sitio no ofrezca método de pago],
      [CP-CON-02], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Bloqueado", detalle: [por defecto DEF-04])], [Requiere una primera orden existente],
      [CP-PED-01], [#veredicto("Bloqueado", detalle: [(ambiente)])], [#veredicto("Bloqueado", detalle: [por defecto DEF-04])], [Requiere una orden propia rastreable],
      [CP-RNF-03], [#veredicto("Pendiente")], [#veredicto("Pasó")], [Cuatro mediciones bajo el umbral; ver @sec:ejecucion-rnf03],
      [CP-RNF-02], [#veredicto("Pendiente")], [#veredicto("Parcialmente ejecutado")], [Flujo crítico verificado en Chrome; faltan Edge y Firefox],
      [CP-ADM-01], [#veredicto("Pendiente")], [#veredicto("Pendiente")], [Requiere escritura en el panel (cambio de stock a cero)],
      [CP-RNF-01], [#veredicto("Pendiente")], [#veredicto("Pendiente")], [Requiere escritura en el panel para medir la propagación],
    )
  ],
  caption: [Actualización de veredictos del 24-09-2026 tras la verificación administrativa.],
) <tbl:actualizacion-veredictos>

== Datos administrativos verificados (lectura, 24-09-2026) <sec:ejecucion-admin>

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
) <tbl:admin-verificado>

Este contraste es la evidencia directa de *DEF-02*.

#figure(
  image("evidencias/gestion-20260924/OC-03_stock-configurado.jpg", width: 100%, height: 13cm, fit: "contain"),
  caption: [E-05 parcial: formulario de product_id 28 con Quantity = 0 y Out Of Stock Status = In Stock. La captura documenta el formulario abierto; no prueba una escritura ni sustituye la lista completa de inventario.],
) <fig:e-05-stock>

== Métricas parciales al 24-09-2026 <sec:ejecucion-metricas-parciales>

#alerta[
  *Cifras parciales.* Corresponden al corte previo al cierre de la jornada
  (@sec:ejecucion-cierre), cuando CP-ADM-01 y CP-RNF-01 aún figuraban como Pendiente. Las cifras
  definitivas del bloque están en @sec:consolidacion-metricas: tasa de ejecución 25.0 %, tasa de
  aprobación 50.0 % y tasa de bloqueo 62.5 %.
]

- Casos *planificados*: 8
- Casos *ejecutados*: 2 (CP-CHK-01, CP-RNF-03) + 1 parcial (CP-RNF-02)
- *Tasa de bloqueo* = 3 / 8 = *37.5 %* (sobre planificados)
- *Tasa de aprobación* = 1 / 2 = *50.0 %* (sobre ejecutados)
- Defectos abiertos: 1 crítico (DEF-04), 2 altos (DEF-01, DEF-02), 1 medio (DEF-03)

== Cierre de ejecución — 24-09-2026, 02:45 <sec:ejecucion-cierre>

Intento de ejecución de CP-ADM-01 sobre el producto HP LP3065 (`product_id 47`), estado previo
verificado `Quantity = 1000`, `Out Of Stock Status = Out Of Stock`, `Subtract Stock` activo.

#figure(
  chico[
    #table(
      columns: (2.4cm, 4.4cm, 1fr, 3.6cm),
      table.header([Caso], [Resultado esperado], [Resultado obtenido], [Veredicto]),
      [CP-ADM-01], [Al fijar la cantidad en cero y guardar, el sitio público refleja la falta de disponibilidad],
        [El panel rechaza la operación: *#lit[Warning: You do not have permission to modify products!]*. El valor no se persiste],
        [#veredicto("Bloqueado", detalle: [(permisos del ambiente)])],
      [CP-RNF-01], [El cambio administrativo se refleja en el sitio público dentro del umbral acordado],
        [No ejecutable: no es posible provocar un cambio administrativo que medir],
        [#veredicto("Bloqueado", detalle: [(dependencia de CP-ADM-01)])],
    )
  ],
  caption: [Cierre de ejecución del 24-09-2026 a las 02:45: CP-ADM-01 y CP-RNF-01.],
) <tbl:cierre-ejecucion>

El ambiente no fue modificado; no se requirió restaurar datos.

#figure(
  image("evidencias/CP-ADM-01/CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png", width: 100%),
  caption: [CP-ADM-01, paso 03 — el panel administrativo rechaza el guardado con el mensaje literal #lit[Warning: You do not have permission to modify products!]. El formulario conserva `Quantity = 1000` y `Out Of Stock Status = Out Of Stock`: el cambio no se persistió.],
) <fig:bloqueo-cp-adm>

== Mediciones de CP-RNF-03 (RNF 03) <sec:ejecucion-rnf03>

Requisito *RNF 03*: el catálogo debe responder en menos de dos segundos. Fecha: 24-09-2026. Origen:
navegador local del responsable. Sistema: `demo.opencart.com`.

=== Criterio de medición declarado

Se mide *carga completa de la página de categoría* (`loadEventEnd` menos inicio de navegación,
Navigation Timing API del navegador), por ser el instante en que el cliente dispone del catálogo
completo. Se registran también TTFB (`responseStart - requestStart`), respuesta del HTML
(`responseEnd - requestStart`) y DOMContentLoaded, para separar tiempo de servidor de tiempo de
render. Se realizan cuatro mediciones, incluyendo una primera visita sin caché.

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
) <tbl:mediciones-rnf03>

Recursos cargados en la medición 1: *17*.

=== Veredicto

#exito[
  #veredicto("Pasó") Las cuatro mediciones cumplen el umbral de dos segundos.
]

=== Hallazgo de confirmación (no es defecto)

La primera visita sin caché queda *a 68 ms del umbral* (1932 ms contra 2000 ms), mientras que la
misma página con caché responde en 645 ms. El requisito se cumple, pero el margen en la peor
condición observada es de apenas *3.4 %*.

#pagebreak()

// =====================================================================
= Reporte de hallazgos y defectos <sec:defectos>

== Convenciones del reporte <sec:defectos-convenciones>

Nomenclatura aplicada: *`[Módulo / Funcionalidad] + [Qué falla] + [Bajo qué condición]`*.

*Severidad* = impacto técnico/funcional evaluado por QA. *Prioridad* = urgencia de atención
definida por negocio (Product Owner). Son *dos ejes independientes*.

Escala declarada por el equipo: *Crítica · Alta · Media · Baja*. El CTFL no impone una escala: cada
organización define la suya.

Trazabilidad: *Requisito ↔ caso ↔ ejecución ↔ defecto*; la condición de prueba (CT) se conserva
como paso intermedio del análisis.

=== Ciclo de vida del defecto aplicado <sec:defectos-ciclo>

*Cadena principal:* Nuevo → En análisis → Asignado → En corrección → *Listo para reprueba* →
Cerrado.

*Ramas:* desde «En análisis»: *Rechazado · Duplicado · Diferido*. Desde «Listo para reprueba»:
*Reabierto → En corrección*.

#figure(
  block(width: 100%, breakable: false)[
    #let s = 0.52cm
    #grid(
      columns: (1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr),
      align: center + horizon,
      caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN, tam: 7.2pt)[*Nuevo*], flecha-h,
      caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN, tam: 7.2pt)[*En análisis*], flecha-h,
      caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN, tam: 7.2pt)[*Asignado*], flecha-h,
      caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN, tam: 7.2pt)[*En corrección*], flecha-h,
      caja(fondo: C-BLOQ.fondo, borde: C-BLOQ.borde, tam: 7.2pt)[*Listo para reprueba*], flecha-h,
      caja(fondo: C-PASO.fondo, borde: C-PASO.borde, tam: 7.2pt)[*Cerrado*],
    )
    #v(3pt)
    #grid(
      columns: (1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr, s, 1fr),
      align: center,
      [], [], flecha-v, [], [], [], [], [], flecha-v, [], [],
    )
    #v(2pt)
    #grid(
      columns: (1fr, 0.8cm, 1fr),
      align: horizon,
      block(width: 100%, inset: 6pt, radius: 3pt, stroke: (paint: luma(170), dash: "dashed"))[
        #set align(center)
        #text(size: 7.4pt, fill: UTEC-GRAY)[Ramas desde «En análisis» — el defecto no llega a corrección]
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
        #text(size: 7.4pt, fill: UTEC-GRAY)[Rama desde «Listo para reprueba»]
        #v(4pt)
        #grid(
          columns: (1fr, 0.52cm, 1fr),
          align: center + horizon,
          caja(fondo: C-FALLO.fondo, borde: C-FALLO.borde, tam: 7.2pt)[*Reabierto*], flecha-h,
          caja(fondo: UTEC-CYAN-SUAVE, borde: UTEC-CYAN, tam: 7.2pt)[*En corrección*],
        )
      ],
    )
  ],
  kind: image, supplement: [Figura],
  caption: [Ciclo de vida del defecto aplicado en este bloque: cadena principal y ramas.],
) <fig:ciclo-vida-defecto>

Los cuatro defectos de este informe están en estado *Nuevo*: ninguno ha pasado por triage,
corrección ni *prueba de confirmación*.

#nota[
  *Listo para reprueba → prueba de confirmación:* se repite el caso que falló. Las *pruebas de
  regresión* son distintas: evitan que la corrección rompa otra cosa. (El término «re-testing» no
  se usa en este proyecto.)
]

== DEF-01 · `[Carrito y resumen de checkout]` El total de línea difiere de precio unitario × cantidad <sec:defectos-def-01>

#campo[Trazabilidad:][RF CAR 03 / RF CHK 05 / RF CON 02 ↔ CP-CHK-01 ↔ ejecución del 24-09-2026 (@sec:ejecucion) ↔ DEF-01 · condición de prueba intermedia: CT-CHK-05]

#campo[Identidad y entorno:][Reportante: Granit, Analista QA. Fecha: 24-09-2026. OpenCart Demo 4.0.2.3; sitio público y panel, Chrome en macOS.]

*Pasos para reproducir:*

+ Agregar iPod Nano al carrito.
+ Fijar cantidad 2.
+ Abrir Shopping Cart.
+ Continuar a Checkout y observar el resumen.

#campo[Resultado esperado:][El total de línea es coherente con precio unitario × cantidad y con el total general.]
#campo[Resultado obtenido:][Mini-carrito #lit[iPod Nano x 2 — \$244.00]; tabla del carrito #lit[Unit Price \$122.00 / Total \$242.00]; resumen de checkout #lit[2x iPod Nano \$242.00]; Total general #lit[\$244.00].]
#campo[Severidad:][*Alta*]
#campo[Prioridad:][*Alta*]
#campo[Evidencia:][`evidencias/CP-CHK-01/` — captura del resumen de checkout con ambas cifras visibles]
#campo[Estado:][Nuevo]

#figure(
  image("evidencias/gestion-20260924/OC-04_carrito-importes.jpg", width: 100%, height: 13cm, fit: "contain"),
  caption: [E-01: carrito reproducido con 2 iPod Nano; precio unitario USD 122, línea USD 242 y total USD 244.],
) <fig:e-01-carrito>

== DEF-02 · `[Ficha de producto y carrito]` Un producto publicado como #lit[In Stock] es rechazado por el control de inventario <sec:defectos-def-02>

#campo[Trazabilidad:][RF PRO 01 / RF PRO 05 / RF ADM 03 / RF CHK 01 ↔ CP-CHK-01 ↔ ejecución del 24-09-2026 (@sec:ejecucion) ↔ DEF-02 · condición de prueba intermedia: CT-ADM-03]

#campo[Identidad y entorno:][Reportante: Granit, Analista QA. Fecha: 24-09-2026. OpenCart Demo 4.0.2.3; Chrome en macOS.]

*Pasos para reproducir:*

+ Abrir HTC Touch HD (`product_id 28`); la ficha indica #lit[Availability: In Stock].
+ Agregar al carrito.
+ Abrir Shopping Cart.
+ Pulsar Checkout.

#campo[Resultado esperado:][Un producto publicado como disponible puede comprarse, o bien la ficha informa la indisponibilidad antes de agregarlo.]
#campo[Resultado obtenido:][El carrito marca el producto con `***` y muestra #lit[Products marked with \*\*\* are not available in the desired quantity or not in stock!].]
#campo[Severidad:][*Alta*]
#campo[Prioridad:][*Alta*]
#campo[Estado:][Nuevo]

#evidencia-pendiente("E-02")[Carrito mostrando el producto marcado con `***` y el mensaje de stock (sustento de DEF-02).]

== DEF-03 · `[Checkout]` El botón #lit[Confirm Order] no entrega retroalimentación <sec:defectos-def-03>

#campo[Trazabilidad:][RF CHK 04 / RF CON 01 ↔ CP-CON-01 ↔ ejecución del 24-09-2026 (@sec:ejecucion) ↔ DEF-03 · condición de prueba intermedia: CT-CON-01]

#campo[Identidad y entorno:][Reportante: Granit, Analista QA. Fecha: 24-09-2026. Chrome en macOS.]

*Pasos para reproducir:*

+ Completar Guest Checkout con datos válidos.
+ Sin método de pago seleccionable, pulsar #lit[Confirm Order].

#campo[Resultado esperado:][El sistema impide la confirmación e informa explícitamente qué falta.]
#campo[Resultado obtenido:][La acción no produce navegación, ni pedido, ni mensaje.]
#campo[Severidad:][*Media*]
#campo[Prioridad:][*Media*]
#campo[Estado:][Nuevo]

== DEF-04 · `[Checkout / Sincronización sitio–panel]` El sitio público no ofrece ningún método de pago <sec:defectos-def-04>

#campo[Trazabilidad:][RF CHK 04 / RF CON 01 / RF ADM 07 / RNF 01 → CT-CHK-04, CT-RNF-01 → CP-CHK-01, CP-CON-01, CP-RNF-01 → ejecución del 24-09-2026 (@sec:ejecucion) → DEF-04]

#campo[Identidad y entorno:][Reportante: Granit, Analista QA. Fecha: 24-09-2026. Chrome en macOS.]

*Pasos para reproducir:*

+ Agregar iPod Nano (`product_id 36`) al carrito, cantidad 2.
+ Ir a Checkout y seleccionar Guest Checkout.
+ Completar los datos obligatorios.
+ Pulsar Continue; el sistema responde #lit[Success: Your guest account information has been saved!].
+ Pulsar #lit[Choose] en Payment Method.

#campo[Resultado esperado:][Se ofrece al menos el método habilitado en el panel (Cash On Delivery), permitiendo continuar hasta la confirmación del pedido.]
#campo[Resultado obtenido:][#lit[No Payment options are available. Please contact us for assistance!]. No se renderiza sección #lit[Shipping Method].]
#campo[Severidad:][*Crítica* propuesta por QA]
#campo[Prioridad:][*Alta*]
#campo[Estado:][Nuevo]
#campo[Impacto sobre el alcance de pruebas:][bloquea CP-CON-01, CP-CON-02 y CP-PED-01.]

#figure(
  image("evidencias/gestion-20260924/OC-02_cod-todas-zonas.jpg", width: 100%, height: 13cm, fit: "contain"),
  caption: [E-04: Cash On Delivery habilitado con Geo Zone = All Zones. Consulta de configuración sin guardar cambios.],
) <fig:e-04-cod>

== OBS-01 · Limitación de ambiente (no es defecto de producto) y su corrección registrada <sec:defectos-obs-01>

*OBS-01 (registro original).* El demo público no tiene métodos de pago ni de envío configurados.
Esto bloquea CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01.

#nota[
  *Corrección a OBS-01 (registrada el 24-09-2026).* La verificación en el panel administrativo
  descartó la hipótesis de limitación de ambiente: los métodos están habilitados y sin restricción
  de zona. La observación se reclasifica como el defecto *DEF-04* (@sec:defectos-def-04). Se
  conserva el registro original para dejar trazable la evolución del análisis.
]

== OBS-02 · Referencia cruzada al bloque del Integrante 1 <sec:defectos-obs-02>

Productos marcados #lit[Out Of Stock] (MacBook, iPhone, iMac) conservan el botón #lit[Add to Cart]
activo. Pertenece a FUN-02, bloque de Franco; se documenta aquí solo por su efecto sobre el flujo
de checkout.

== OBS-03 · Señal a investigar sobre duplicación de pedidos (no confirmada) <sec:defectos-obs-03>

En Sales \> Orders se observan las órdenes *3633, 3634 y 3635*, todas del cliente #lit[John smith],
todas por *\$105.00* y todas con fecha *21/09/2026*. Es un patrón compatible con el riesgo de
duplicación que evalúa CP-CON-02, pero el demo es un ambiente compartido. *No se declara defecto*.

== OBS-04 · Dato pendiente de verificación controlada <sec:defectos-obs-04>

El intento de agregar al carrito un producto agotado (iPhone, `product_id 40`) no modificó el
contenido del carrito en la sesión del 24-09-2026, a diferencia de lo observado el 18-09-2026.
*Pendiente de reejecución controlada*. Pertenece al bloque del Integrante 1.

== Bloqueo de CP-ADM-01 por permisos del ambiente (no es defecto del producto) <sec:defectos-bloqueo>

El 24-09-2026 a las 02:45, en el panel administrativo autenticado con el usuario `demo`, el intento
de fijar `Quantity = 0` en HP LP3065 y guardar produjo el mensaje literal
*#lit[Warning: You do not have permission to modify products!]*. Esto *bloquea CP-ADM-01 y
CP-RNF-01*.

== Resumen de los defectos registrados <sec:defectos-resumen>

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
) <tbl:resumen-defectos>

#pagebreak()

// =====================================================================
= Consolidación, métricas y criterios de salida <sec:consolidacion>

#nota[
  *Nota metodológica (orden obligatorio).* Los criterios de salida *se declaran ANTES de presentar
  métricas o gráficos*. El tablero muestra; la decisión se toma contra estos umbrales.

  La conclusión de cierre se redacta siempre como *estado frente a los criterios de salida* —«no se
  cumplen los criterios de salida CSx y CSy → el release no está listo»—, nunca como una etiqueta
  de dictamen.
]

== Criterios de salida declarados (antes de cualquier métrica) <sec:consolidacion-criterios>

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
) <tbl:criterios-salida>

Regla maestra del curso: *los criterios de salida del plan son las métricas con las que se decide*.

=== Denominadores fijados (no se mezclan) <sec:consolidacion-denominadores>

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
) <tbl:denominadores>

Un caso bloqueado no entra en el denominador de aprobación: no llegó a ejecutarse. Medir el bloqueo
contra lo ejecutado ocultaría la porción del alcance que nunca pudo entrar a ejecución.

== Qué significa cada criterio con los 8 casos del bloque <sec:consolidacion-significado>

Casos planificados del bloque: *CP-CHK-01, CP-CON-01, CP-CON-02, CP-ADM-01, CP-PED-01, CP-RNF-01,
CP-RNF-02, CP-RNF-03* (total: *8 planificados*). Prioridad de cada caso, *derivada de la prioridad
de sus condiciones* (@sec:analisis):

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
) <tbl:prioridad-casos>

→ *7 casos de alta prioridad* y *1 de prioridad media*.

- *CS1 — 100 % de casos de alta prioridad ejecutados.* Los *7 casos Alta* deben tener veredicto
  *Aprobado o Fallido*. Un caso *Bloqueado* o *Pendiente* *no cuenta como ejecutado*.
- *CS2 — aprobación ≥ 90 % de los ejecutados.* El denominador son los casos con veredicto Aprobado
  o Fallido, *no los 8 planificados*.
- *CS3 — 0 defectos críticos abiertos.* Ningún defecto de severidad *Crítica* puede quedar en un
  estado distinto de *Cerrado*.
- *CS4 — máximo 2 defectos de severidad alta abiertos.*

== Tablero visual de resultados <sec:consolidacion-tablero>

#figure(
  block(width: 100%, breakable: false)[
    #grid(
      columns: (1fr, 0.9cm, 1fr), align: top,
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
        #align(center)[#text(size: 7.6pt, fill: UTEC-GRAY)[Total: 8 casos · Pasó CP-RNF-03 · Falló CP-CHK-01 · Parcial CP-RNF-02]]
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
        #align(center)[#text(size: 7.6pt, fill: UTEC-GRAY)[Total: 4 defectos, todos en estado Nuevo]]
      ],
    )
  ],
  kind: image, supplement: [Figura],
  caption: [Tablero visual del cierre: distribución de veredictos sobre los 8 casos planificados y de los 4 defectos registrados por severidad.],
) <fig:tablero>

*Lectura del tablero.* La barra dominante es *Bloqueado* (5 de 8): el resultado del bloque no se
explica por pruebas que salieran mal, sino por alcance que nunca llegó a ejecutarse.

*Codificación de color usada en todo el informe* —el color acompaña siempre al texto del veredicto:

#leyenda-veredictos

== Evolución del análisis: de limitación de ambiente a defecto crítico <sec:consolidacion-evolucion>

En el primer corte del 24-09-2026, la ausencia de métodos de pago en el checkout se registró como
una *limitación del ambiente*. Bajo esa lectura, CS3 figuraba como cumplido.

La verificación posterior en el panel administrativo refutó esa hipótesis. Extensions > Payments
muestra *Cash On Delivery* habilitado con Geo Zone = All Zones, Extensions > Shipping muestra
*Flat Rate* habilitado con la misma cobertura, y Sales > Orders contiene pedidos recientes, el más
nuevo del 23-09-2026.

Esa reclasificación convirtió la observación OBS-01 en el defecto *DEF-04*, de severidad Crítica, y
cambió la evaluación de CS3 de cumplido a incumplido.

== Tabla global de resultados <sec:consolidacion-global>

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
) <tbl:global-resultados>

== Métricas <sec:consolidacion-metricas>

#figure(
  table(
    columns: (6.4cm, 1fr, 3.2cm), align: (left, left, center),
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
  caption: [Métricas consolidadas del bloque, con los denominadores declarados en @sec:consolidacion-denominadores.],
) <tbl:metricas>

*Desglose de la causa del bloqueo:* *3 casos bloqueados por defecto del producto* (DEF-04) y *2 por
restricción del ambiente* (permisos del usuario `demo`).

== Defectos por severidad y prioridad <sec:consolidacion-defectos>

#figure(
  table(
    columns: (4.6cm, 3.4cm, 3.0cm, 2.4cm, 1fr), align: (left, center, center, center, center),
    table.header([Severidad \\ Prioridad], [Alta], [Media], [Baja], [Total]),
    [Crítica], [1 (DEF-04)], [—], [—], [*1*],
    [Alta], [2 (DEF-01, DEF-02)], [—], [—], [*2*],
    [Media], [—], [1 (DEF-03)], [—], [*1*],
    [Baja], [—], [—], [—], [0],
    [*Total*], [*3*], [*1*], [*0*], [*4*],
  ),
  caption: [Distribución de defectos por severidad y prioridad (dos ejes independientes).],
) <tbl:defectos-severidad>

== Cumplimiento de los criterios de salida al cierre <sec:consolidacion-cumplimiento>

#figure(
  table(
    columns: (1.8cm, 5.2cm, 3.6cm, 3.2cm, 1fr),
    table.header([Criterio], [Umbral], [Resultado], [Estado], [Evidencia]),
    [CS1], [100 % de alta prioridad ejecutados], [2 de 7 ejecutados], [*No se cumple*], [@tbl:global-resultados],
    [CS2], [Aprobación ≥ 90 % de los ejecutados], [50.0 %], [*No se cumple*], [@tbl:metricas],
    [CS3], [Cero defectos críticos abiertos], [1 abierto (DEF-04)], [*No se cumple*], [@sec:defectos],
    [CS4], [Máximo 2 defectos altos abiertos], [2 abiertos (DEF-01, DEF-02)], [*Se cumple*], [@sec:defectos],
  ),
  caption: [Evaluación de los criterios de salida CS1–CS4 al cierre del 24-09-2026.],
) <tbl:cumplimiento>

=== Estado frente a los criterios de salida

#peligro[
  Tres de los cuatro criterios de salida no se cumplen. El defecto *DEF-04* bloquea el recorrido de
  compra probado. *No se cumplen los criterios de salida CS1, CS2 y CS3 → el release no está
  listo*, y la tasa de ejecución del 25 % no es un dato menor: no se trata de que las pruebas hayan
  salido mayoritariamente bien, sino de que la mayor parte del alcance nunca pudo entrar a
  ejecución.
]

#nota[
  Un informe que presentara «1 de 2 casos ejecutados aprobados» como resultado positivo sería una
  *métrica engañosa*. El dato que gobierna la decisión es que el *62.5 % del alcance planificado
  quedó bloqueado* y que existe un *defecto crítico abierto* en el flujo transaccional.
]

== Riesgos residuales del cierre <sec:consolidacion-residuales>

+ *Cobertura no alcanzada:* confirmación de pedidos, prevención de duplicados y consistencia
  sitio–panel quedan sin verificar.
+ *Señal no confirmada de duplicación:* las órdenes 3633, 3634 y 3635 son compatibles con el riesgo
  que evalúa CP-CON-02, pero no se puede atribuir al sistema sin generar pedidos propios.
+ *Volatilidad del ambiente:* el inventario y los cupones cambian por acción de terceros.
+ *Compatibilidad sin verificar:* RNF-02 solo se comprobó en Chrome.
+ *Margen estrecho de rendimiento:* RNF-03 cumple, pero la primera carga sin caché quedó a 68 ms
  del umbral de 2 s.

A estos se suman los riesgos residuales declarados en @sec:riesgos-residuales.

#pagebreak()

// =====================================================================
= Reflexión sobre automatización para el Proyecto 2 <sec:automatizacion>

Sustentada en lo observado durante esta ejecución, no en criterios generales.

== Sí automatizar

- *CP-RNF-03 (tiempo de respuesta del catálogo).* Es la candidata más clara: criterio numérico,
  ejecución idéntica en cada corrida y resultado sensible a cualquier degradación.
- *Verificación de consistencia entre inventario del panel y disponibilidad publicada.* El
  contraste que expuso DEF-02 es una comparación de datos entre dos fuentes.
- *Los pasos previos del checkout de invitado* (carga del formulario, validación de campos
  obligatorios, guardado de datos de invitado).

== No automatizar todavía

- *CP-CON-01, CP-CON-02 y CP-PED-01.* No se pueden completar ni una sola vez de forma manual.
- *CP-ADM-01 y CP-RNF-01.* Dependen de permisos que el ambiente público no otorga.
- *CP-RNF-02 (compatibilidad multinavegador).* Exige infraestructura de varios navegadores y
  versiones, con alto costo de mantenimiento.

== Criterio transversal

La automatización rinde sobre flujos estables, repetitivos y de validación objetiva. Hoy el flujo
de compra de este sistema no es estable.

// =====================================================================
= Lecciones aprendidas <sec:lecciones>

+ *El ambiente es parte del alcance de pruebas, no un supuesto.*
+ *Distinguir bloqueo por ambiente de bloqueo por defecto cambia la conclusión.*
+ *Contrastar el sitio público contra el panel administrativo reveló discrepancias que la
  exploración del sitio público no explicaba; la causa raíz aún requiere investigación.*
+ *En un ambiente compartido, la evidencia sin fecha y hora no es evidencia.*
+ *Un bloqueo bien documentado vale más que un caso aprobado sin trazabilidad.*

// =====================================================================
#page(flipped: true)[
  = Anexos <sec:anexos>

  == Anexo A — Bitácora de ambiente <sec:anexo-a>

  Registro fechado del estado del sistema bajo prueba.

  #figure(
    mini[
      #table(
        columns: (2.0cm, 1.9cm, 3.6cm, 4.6cm, 1fr, 5.4cm),
        table.header([Fecha], [Hora aprox.], [Origen de acceso], [Evento observado], [Evidencia literal], [Efecto sobre las pruebas]),
        [18-09-2026], [—], [Navegador del equipo], [Usuario admin `demo` sin permisos de escritura],
          [#lit[Warning: You do not have permission to modify coupons]],
          [Bloquea condiciones que requieren configuración administrativa],
        [18-09-2026], [—], [Navegador del equipo], [Checkout bloqueado por advertencia de stock],
          [#lit[Products marked with \*\*\* are not available in the desired quantity or not in stock!]],
          [Impide generar orden],
        [24-09-2026], [—], [Entorno de automatización (IP de datacenter)], [Dominio del demo responde HTTP 403 tras desafío de Cloudflare],
          [#lit[Sorry, you have been blocked] · Ray ID `a3ffd6a6fe936f20` y `a3ffdaf1d8966f2f`],
          [Indisponibilidad total desde ese origen],
        [24-09-2026], [—], [Navegador local del estudiante (IP residencial)], [Acceso restablecido],
          [Portada #lit[Your Store] con catálogo completo],
          [Ejecución posible solo desde el origen autorizado],
        [24-09-2026], [—], [Navegador local], [Ruta real del panel administrativo],
          [`https://demo.opencart.com/TlbeVW/`; credenciales `demo`/`demo`],
          [Requiere autenticación manual del responsable],
        [24-09-2026], [—], [Navegador local], [Checkout sin métodos de pago ni de envío configurados],
          [#lit[No Payment options are available. Please contact us for assistance!]],
          [*Bloquea CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01*],
        [24-09-2026], [02:45], [Panel administrativo autenticado (usuario `demo`)], [Intento de fijar `Quantity = 0` en HP LP3065 y guardar],
          [*#lit[Warning: You do not have permission to modify products!]*],
          [El cambio *no se persistió*. *Bloquea CP-ADM-01 y CP-RNF-01*],
      )
    ],
    caption: [Bitácora de ambiente del Caso 3 OpenCart.],
  ) <tbl:bitacora>

  *Regla de registro*

  + Ninguna ejecución se considera válida sin entrada de bitácora del día.
  + El estado del inventario y de los cupones del demo es volátil y compartido.
  + Un impedimento del ambiente se registra como *Bloqueado*, nunca como *Fallido*.

  == Anexo B — Estrategia de resiliencia del ambiente de pruebas <sec:anexo-b>

  #figure(
    chico[
      #table(
        columns: (4.6cm, 4.6cm, 1fr),
        table.header([Práctica real de la industria], [Qué problema resuelve allá], [Cómo la aplicamos aquí]),
        [*Instalación parcial + descarga de caché por región*],
          [El origen puede estar lejos, saturado o caído; el usuario no puede quedar bloqueado],
          [*Snapshot local de cada página evaluada* en `snapshots/`],
        [*Mirror / réplica de origen*],
          [Si el origen falla, el trabajo continúa desde la réplica],
          [*Instancia local de OpenCart* como ambiente espejo],
        [*Feature flag y degradación controlada*],
          [Cuando un servicio cae, la app sigue funcionando con menos capacidad],
          [*Plan de ejecución por capas:* primero todo lo ejecutable sin permisos ni pedido],
        [*Datos sintéticos propios, no datos de producción*],
          [No depender de datos ajenos ni exponer información real],
          [*Datos de prueba fijos y ficticios* definidos por nosotros],
        [*Canary / smoke test previo al despliegue*],
          [Detectar temprano que el ambiente no sirve antes de gastar el esfuerzo grande],
          [*Verificación de ambiente obligatoria* al inicio de cada sesión],
        [*Idempotencia y control de reintentos*],
          [Evitar cobros o pedidos duplicados por reintento],
          [Es justamente lo que evalúa *CP-CON-02*],
        [*Observabilidad y trazas fechadas*],
          [Poder explicar después qué pasó y cuándo],
          [*Bitácora de ambiente* con hora, origen de acceso, texto literal],
        [*Congelar versión del entorno*],
          [Que el resultado sea reproducible mañana],
          [*Gestión de la Configuración* del testware],
      )
    ],
    caption: [Estrategia de resiliencia: prácticas de industria adoptadas y su aplicación al proyecto.],
  ) <tbl:resiliencia>

  == Anexo C — Testware entregado (Gestión de la Configuración) <sec:anexo-c>

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
  ) <tbl:testware>

  === Herramienta de gestión de pruebas

  Opción principal: *Qase* (`app.qase.io`). Alternativas: Jira/Zephyr, TestLink, o las tablas del
  propio informe (@sec:plan-herramientas). Cualquiera que se elija debe sostener la trazabilidad
  *Requisito ↔ caso ↔ ejecución ↔ defecto*.

  === Estado verificable de las evidencias gráficas

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
  ) <tbl:evidencias>
]

#pagebreak()

#include "gestion_clase7.typ"

// =====================================================================
= Glosario <sec:glosario>

Términos técnicos empleados en este informe, con el significado exacto con que se usan aquí.

#figure(
  table(
    columns: (4.4cm, 1fr),
    table.header([Término], [Significado con que se usa en este informe]),
    [*Condición de prueba*],
    [Aspecto de la base de pruebas verificable por uno o más casos. Describe *qué* comprobar, nunca
     *cómo* ni con qué datos. Son las CT-XXX-NN de @sec:analisis y son el *paso intermedio del
     análisis* entre el requisito y el caso.],
    [*Caso de prueba*],
    [Conjunto de precondiciones, datos concretos, pasos, resultado esperado y criterio de aceptación
     que hace verificable una o varias condiciones. Son los CP-XXX-NN de @sec:diseno.],
    [*Prueba de confirmación*],
    [Reejecución del caso que falló, una vez que el defecto pasa al estado *Listo para reprueba*,
     para comprobar que la corrección resuelve lo reportado.],
    [*Pruebas de regresión*],
    [Pruebas sobre funcionalidad que ya operaba, para detectar que la corrección de un defecto no
     haya roto otra cosa.],
    [*Gestión de la Configuración*],
    [Control de versiones e integridad del testware. Declarada en @sec:plan-config e inventariada
     en @sec:anexo-c.],
    [*Testware*],
    [Todo el material producido por la actividad de prueba. Su inventario está en @sec:anexo-c.],
    [*Severidad*],
    [Grado de impacto técnico o funcional del defecto sobre el sistema. La propone QA. Escala
     declarada por el equipo: *Crítica · Alta · Media · Baja* (@sec:defectos-convenciones).],
    [*Prioridad*],
    [Urgencia con que el negocio quiere que el defecto se atienda. La define el Product Owner.],
    [*Riesgo de producto*],
    [Posibilidad de que el sistema falle frente a un requisito y dañe al negocio. Se registra como
     RPD-NN (@sec:riesgos-producto).],
    [*Riesgo de proyecto*],
    [Posibilidad de que el equipo no pueda ejecutar la prueba prevista por ambiente, permisos,
     datos o tiempo. Se registra como RPR-NN (@sec:riesgos-proceso).],
    [*Criterio de salida*],
    [Umbral declarado *antes* de medir, contra el que se decide si el trabajo de prueba puede darse
     por concluido. Son CS1–CS4 (@sec:consolidacion-criterios).],
    [*Veredicto Bloqueado*],
    [Resultado de un caso que *no pudo ejecutarse* por un impedimento externo al propio caso,
     registrado con el texto literal del sistema y su fecha. No es Fallido: no entra en el
     denominador de la *tasa de aprobación* y sí en el de la *tasa de bloqueo*.],
  ),
  caption: [Glosario de términos técnicos empleados en el informe.],
) <tbl:glosario>

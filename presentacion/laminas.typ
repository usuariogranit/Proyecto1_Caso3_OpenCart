// =====================================================================
//  Grupo 5 · CS5383 Pruebas y Verificación de Software · Caso 3 OpenCart
//  17 láminas 16:9 (960 x 540 pt) — documento de acompañamiento
//  Enlaces: esquema ref://N, donde N es la página del informe integrado.
// =====================================================================

#set page(width: 960pt, height: 540pt, margin: 0pt)
#set text(font: "Helvetica", size: 17pt, fill: rgb("#142D3D"), lang: "es", hyphenate: false)
#set par(leading: 0.68em, spacing: 0pt, justify: false)

// ---------- Paleta ----------
#let tinta = rgb("#142D3D")
#let apoyo = rgb("#516673")
#let acento = rgb("#007C9F")
#let claro = rgb("#F2F6F8")
#let verde = rgb("#18744D")
#let rojo = rgb("#BA3C3C")
#let ambar = rgb("#A46810")
#let linea = rgb("#C9D4DB")

#let W = 960pt
#let H = 540pt

// ---------- Mapa de identificadores → página del informe ----------
#let idmap = (
  "CP-CAT-01": 11, "CP-CAT-02": 12, "CP-PRO-01": 13, "CP-PRO-02": 14,
  "CP-CAR-01": 15, "CP-CAR-02": 16, "CP-CUP-01": 17, "CP-CUP-02": 18,
  "CP-CHK-01": 19, "CP-CON-01": 20, "CP-CON-02": 21, "CP-ADM-01": 22,
  "CP-PED-01": 23, "CP-RNF-01": 24, "CP-RNF-02": 25, "CP-RNF-03": 26,
  "CP-CAT-03": 27, "CP-VAL-01": 28,
  "DEF-01": 32, "DEF-04": 32, "OBS-02": 32, "OBS-03": 32,
  "OBS-F01": 32, "OBS-F02": 32, "OBS-F03": 32, "CONF-F01": 32, "CONF-F02": 32,
)

// Identificador clicable: color acento + subrayado
#let id(nombre, size: 17pt, weight: "bold") = link(
  "ref://" + str(idmap.at(nombre)),
  underline(offset: 2pt, text(fill: acento, size: size, weight: weight, nombre)),
)

// ---------- Utilidades de posición ----------
#let at(x, y, body) = place(top + left, dx: x, dy: y, body)

#let banda(x, y, w, h, fill) = at(x, y, rect(width: w, height: h, fill: fill, radius: 3pt))

// Rótulo de sección
#let rotulo(t, c: apoyo) = text(size: 14pt, weight: "bold", fill: c, tracking: 1.2pt, upper(t))

// Tarjeta clara
#let card(w, h, cuerpo, bordecolor: linea, relleno: white, pad: 16pt) = box(
  width: w, height: h, fill: relleno, radius: 4pt,
  stroke: (paint: bordecolor, thickness: 1pt),
  inset: (x: pad, y: pad - 2pt),
  cuerpo,
)

// Tarjeta con barra superior de color (veredictos y bloques)
#let cardtop(w, h, c, cuerpo, relleno: white, pad: 16pt) = box(
  width: w, height: h, fill: relleno, radius: 4pt,
  stroke: (paint: linea, thickness: 1pt),
  clip: true, inset: 0pt,
  stack(
    rect(width: 100%, height: 6pt, fill: c),
    box(width: 100%, height: h - 6pt, inset: (x: pad, y: pad - 2pt), cuerpo),
  ),
)

// Pastilla de veredicto: el color SIEMPRE va con la palabra
#let veredicto(palabra, c) = box(
  fill: c, radius: 3pt, inset: (x: 11pt, y: 6pt),
  text(size: 14pt, fill: white, weight: "bold", tracking: 1.1pt, upper(palabra)),
)

// Distintivo de texto
#let chip(t, c) = box(
  fill: c.lighten(90%), radius: 18pt,
  stroke: (paint: c.lighten(45%), thickness: 1pt),
  inset: (x: 15pt, y: 7pt),
  text(size: 15pt, fill: c, weight: "bold", t),
)

// Viñeta con guion largo
#let vi(t, c: acento, size: 16pt) = block(
  below: 8pt,
  grid(columns: (16pt, 1fr), gutter: 0pt,
    text(size: size, fill: c, weight: "bold", [—]),
    text(size: size, t),
  ),
)

// Cifra grande + leyenda
#let cifra(n, leyenda, c: tinta, size: 44pt, lc: apoyo) = {
  text(size: size, weight: "bold", fill: c, n)
  v(9pt)
  text(size: 15pt, fill: lc, leyenda)
}

// ---------- Marco común de lámina ----------
#let frame(num, titulo, quien, fpage, ftexto, cuerpo, dark: false) = {
  // fondo
  at(0pt, 0pt, rect(width: W, height: H, fill: if dark { tinta } else { claro }))
  // banda de cabecera con número y título
  at(0pt, 0pt, rect(width: W, height: 68pt, fill: tinta))
  at(0pt, 68pt, rect(width: W, height: 2.5pt, fill: acento))
  at(48pt, 16pt, box(width: 38pt, height: 37pt, fill: acento, radius: 3pt,
    align(center + horizon, text(size: 19pt, weight: "bold", fill: white, str(num)))))
  at(100pt, 16pt, box(width: 810pt, height: 37pt,
    align(left + horizon, text(size: 25pt, weight: "bold", fill: white, titulo))))
  // cuerpo
  cuerpo
  // pie: expositor y tiempo a la izquierda, enlace al informe a la derecha
  at(0pt, 494pt, rect(width: W, height: 46pt, fill: white))
  at(0pt, 494pt, rect(width: W, height: 1pt, fill: linea))
  at(48pt, 494pt, box(width: 400pt, height: 46pt,
    align(left + horizon, text(size: 14pt, fill: apoyo, weight: "bold", quien))))
  at(512pt, 494pt, box(width: 400pt, height: 46pt,
    align(right + horizon,
      link("ref://" + str(fpage), text(size: 14pt, fill: apoyo, [▸ ] + ftexto)))))
}

// =====================================================================
// LÁMINA 1 · Portada
// =====================================================================
#frame(1, "Portada · Pruebas de software en OpenCart",
  "Franco · 0:00–0:25", 1, "Informe integrado · Grupo 5", dark: true)[
  #at(48pt, 104pt, box(fill: acento, radius: 3pt, inset: (x: 14pt, y: 7pt),
    text(size: 15pt, fill: white, weight: "bold", tracking: 2pt, [GRUPO 5])))
  #at(178pt, 104pt, box(height: 32pt, align(left + horizon,
    text(size: 16pt, fill: rgb("#9FB3BF"), tracking: 1pt,
      [CS5383 · PRUEBAS Y VERIFICACIÓN DE SOFTWARE]))))
  #at(48pt, 158pt, box(width: 880pt,
    text(size: 44pt, weight: "bold", fill: white, [Pruebas de software en OpenCart])))
  #at(48pt, 226pt, rect(width: 96pt, height: 4pt, fill: acento))
  #at(48pt, 254pt, box(width: 864pt,
    text(size: 20pt, fill: rgb("#B9C9D3"),
      [Proyecto 1 · Caso 3 · Sistema bajo prueba: OpenCart Demo 4.0.2.3])))
  #at(48pt, 326pt, box(width: 560pt, height: 118pt,
    fill: rgb("#1D3B4E"), radius: 4pt, inset: (x: 20pt, y: 16pt))[
    #rotulo("Equipo", c: rgb("#7FA6B8"))
    #v(14pt)
    #text(size: 22pt, weight: "bold", fill: white, [Franco Roque Castillo · Granit Espinoza Salazar])
  ])
  #at(632pt, 326pt, box(width: 280pt, height: 118pt,
    fill: rgb("#1D3B4E"), radius: 4pt, inset: (x: 20pt, y: 16pt))[
    #rotulo("Fecha de ejecución", c: rgb("#7FA6B8"))
    #v(14pt)
    #text(size: 22pt, weight: "bold", fill: white, [25/09/2026])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 2 · Alcance y planificación
// =====================================================================
#frame(2, "Alcance y planificación",
  "Franco · 0:25–1:10", 2, "Informe §1.2 Alcance · p. 2")[
  #at(48pt, 92pt, cardtop(272pt, 182pt, acento)[
    #rotulo("Dentro del alcance", c: acento)
    #v(12pt)
    #vi([8 funcionalidades])
    #vi([3 requisitos no funcionales])
    #vi([Nivel de sistema])
  ])
  #at(344pt, 92pt, cardtop(272pt, 182pt, tinta)[
    #rotulo("Diseño de pruebas", c: tinta)
    #v(12pt)
    #vi([*18 casos* diseñados], c: tinta)
    #vi([11 requisitos], c: tinta)
    #vi([26 condiciones], c: tinta)
    #v(4pt)
    #text(size: 15pt, fill: apoyo, [14 de prioridad Alta · 4 Media])
  ])
  #at(640pt, 92pt, cardtop(272pt, 182pt, apoyo)[
    #rotulo("Fuera del alcance", c: apoyo)
    #v(12pt)
    #vi([Pagos reales], c: apoyo)
    #vi([Pruebas de carga], c: apoyo)
    #vi([Modificación de código], c: apoyo)
  ])
  #at(48pt, 294pt, box(width: 864pt, height: 166pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 20pt))[
    #rotulo("Regla de ejecución", c: rgb("#7FA6B8"))
    #v(16pt)
    #text(size: 21pt, weight: "bold", fill: white,
      [Falta una precondición → el caso se suspende y se sigue con los independientes.])
    #v(16pt)
    #text(size: 17pt, fill: rgb("#B9C9D3"), [Estimación: 24 horas entre ambos, con reserva por bloqueos.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 3 · Priorización y riesgo
// =====================================================================
#let celda(v, destacada: false, alta: false) = box(
  width: 100%, height: 100%,
  fill: if destacada { acento } else if alta { acento.lighten(86%) } else { white },
  stroke: (paint: linea, thickness: 1pt),
  align(center + horizon, text(
    size: if destacada { 24pt } else { 18pt },
    weight: "bold",
    fill: if destacada { white } else if alta { acento } else { apoyo },
    str(v))),
)
#let encab(v) = box(width: 100%, height: 100%,
  align(center + horizon, text(size: 15pt, weight: "bold", fill: apoyo, v)))

#frame(3, "Priorización y riesgo",
  "Franco · 1:10–1:40", 4, "Informe §1.6 Riesgos de producto · p. 4")[
  #at(48pt, 92pt, card(414pt, 290pt)[
    #rotulo("Matriz probabilidad × impacto")
    #v(14pt)
    #grid(
      columns: (74pt, 78pt, 78pt, 78pt),
      rows: (30pt, 48pt, 48pt, 48pt),
      encab([Impacto ↓]), encab([1]), encab([2]), encab([3]),
      encab([3]), celda(3), celda(6, alta: true), celda(9, destacada: true),
      encab([2]), celda(2), celda(4), celda(6, alta: true),
      encab([1]), celda(1), celda(2), celda(3),
    )
    #v(8pt)
    #align(right, text(size: 15pt, weight: "bold", fill: apoyo, [Probabilidad →]))
  ])
  #at(486pt, 92pt, cardtop(426pt, 148pt, acento)[
    #rotulo("Riesgo de mayor puntaje", c: acento)
    #v(10pt)
    #text(size: 23pt, weight: "bold", [R03 · Riesgo monetario])
    #v(13pt)
    #text(size: 19pt, fill: acento, weight: "bold", [3 × 3 = 9 → prioridad Alta])
  ])
  #at(486pt, 254pt, card(426pt, 128pt)[
    #rotulo("Dónde sangra el negocio")
    #v(14pt)
    #chip([Dinero], acento) #h(8pt) #chip([Inventario], acento) #h(8pt)
    #chip([Descuentos], acento) #h(8pt) #chip([Compra], acento)
  ])
  #at(48pt, 400pt, box(width: 864pt, height: 66pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 14pt), align(horizon,
      grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
        text(size: 18pt, fill: white, [Escala 1–3. De 6 a 9, prioridad Alta.]),
        text(size: 18pt, weight: "bold", fill: rgb("#8FC9DC"),
          [14 casos de prioridad Alta · 4 de prioridad Media])))))
]
#pagebreak()

// =====================================================================
// LÁMINA 4 · Trazabilidad de cuatro eslabones  (DIAGRAMA 1)
// =====================================================================
#let esl(x, y, w, h, etiqueta, c, cuerpo) = {
  at(x, y, box(width: w, height: h, fill: white, radius: 4pt,
    stroke: (paint: linea, thickness: 1pt), clip: true, inset: 0pt,
    stack(
      rect(width: 100%, height: 30pt, fill: c,
        align(center + horizon, text(size: 14pt, weight: "bold", fill: white,
          tracking: 1.2pt, upper(etiqueta)))),
      box(width: 100%, height: h - 30pt, inset: (x: 14pt, y: 14pt),
        align(center + horizon, cuerpo)),
    )))
}
// flecha bidireccional horizontal dibujada con líneas
#let flecha2(x, y, largo) = {
  at(x, y, line(end: (largo, 0pt), stroke: (paint: acento, thickness: 1.8pt)))
  at(x, y, line(end: (9pt, -6pt), stroke: (paint: acento, thickness: 1.8pt)))
  at(x, y, line(end: (9pt, 6pt), stroke: (paint: acento, thickness: 1.8pt)))
  at(x + largo, y, line(end: (-9pt, -6pt), stroke: (paint: acento, thickness: 1.8pt)))
  at(x + largo, y, line(end: (-9pt, 6pt), stroke: (paint: acento, thickness: 1.8pt)))
}

#frame(4, "Trazabilidad de cuatro eslabones",
  "Franco · 1:40–2:05", 7, "Informe §2.1 Cobertura y trazabilidad · p. 7")[
  #at(48pt, 90pt, rotulo("Requisito ↔ caso ↔ ejecución ↔ defecto"))

  #esl(48pt, 126pt, 184pt, 152pt, "Requisito", tinta)[
    #text(size: 16pt, [Recalcular el total al cambiar la cantidad])
  ]
  #esl(272pt, 126pt, 184pt, 152pt, "Caso", acento)[
    #id("CP-CAR-01")
    #v(9pt)
    #text(size: 15pt, fill: apoyo, [iPod Nano \ 1 → 2 unidades])
  ]
  #esl(496pt, 126pt, 184pt, 152pt, "Ejecución", rojo)[
    #text(size: 16pt, [25/09/2026])
    #v(11pt)
    #veredicto("Falló", rojo)
  ]
  #esl(720pt, 126pt, 184pt, 152pt, "Defecto", rojo)[
    #id("DEF-01")
    #v(9pt)
    #text(size: 15pt, fill: apoyo, [Abierto \ reproducido 25/09])
  ]
  #flecha2(236pt, 202pt, 32pt)
  #flecha2(460pt, 202pt, 32pt)
  #flecha2(684pt, 202pt, 32pt)

  #at(48pt, 292pt, box(width: 864pt, align(center,
    text(size: 17pt, fill: apoyo,
      [La cadena justifica la prioridad y devuelve siempre a la evidencia.]))))

  #at(48pt, 336pt, box(width: 864pt, height: 80pt, fill: ambar.lighten(88%),
    radius: 4pt, stroke: (paint: ambar.lighten(40%), thickness: 1pt),
    inset: (x: 24pt, y: 15pt))[
    #rotulo("Advertencia", c: ambar)
    #v(8pt)
    #text(size: 21pt, weight: "bold", fill: ambar,
      [Cubrir un requisito en el diseño no significa que haya pasado.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 5 · Técnicas de caja negra
// =====================================================================
#frame(5, "Técnicas de caja negra",
  "Franco · 2:05–3:00", 9, "Informe §3.1 Técnicas y oráculos · p. 9")[
  #at(48pt, 92pt, box(width: 864pt, fill: white, radius: 4pt,
    stroke: (paint: linea, thickness: 1pt), clip: true, inset: 0pt,
    grid(
      columns: (330pt, 1fr),
      rows: (40pt, 44pt, 44pt, 44pt, 44pt, 44pt),
      stroke: (paint: linea, thickness: 1pt),
      inset: (x: 18pt, y: 10pt),
      align: horizon,
      grid.cell(fill: tinta, rotulo("Técnica", c: white)),
      grid.cell(fill: tinta, rotulo("Dónde se aplicó", c: white)),
      text(size: 16pt, weight: "bold", [Partición de equivalencia]),
      text(size: 16pt, fill: apoyo, [Opciones presentes y ausentes]),
      text(size: 16pt, weight: "bold", [Valores límite]),
      text(size: 16pt, fill: apoyo, [0 y 1 · stock 147 y 148]),
      text(size: 16pt, weight: "bold", [Tabla de decisión]),
      text(size: 16pt, fill: apoyo, [Vigencia, elegibilidad y repetición del cupón]),
      text(size: 16pt, weight: "bold", [Transición de estados]),
      text(size: 16pt, fill: apoyo, [Doble clic en «Comprar»]),
      text(size: 16pt, weight: "bold", [Casos de uso]),
      text(size: 16pt, fill: apoyo, [Compra y consulta administrativa]),
    )))
  #at(48pt, 362pt, box(width: 864pt, height: 118pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 17pt))[
    #rotulo("Alcance", c: rgb("#7FA6B8"))
    #v(14pt)
    #text(size: 20pt, weight: "bold", fill: white,
      [Las técnicas justifican el diseño, no la verificación.])
    #v(12pt)
    #text(size: 16pt, fill: rgb("#B9C9D3"),
      [Como varias pruebas quedaron bloqueadas, no afirmamos que todas estas reglas se hayan verificado.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 6 · Catálogo y opciones de producto
// =====================================================================
#frame(6, "Catálogo y opciones de producto",
  "Franco · 3:00–3:55", 12, "Informe §3.2 Fichas de diseño · p. 12")[
  #at(48pt, 92pt, cardtop(204pt, 230pt, verde)[
    #veredicto("Pasó", verde)
    #v(14pt)
    #id("CP-CAT-02")
    #v(13pt)
    #text(size: 15pt, fill: apoyo, [12 precios: 98 → 1202 y a la inversa, sin perder ni duplicar.])
  ])
  #at(268pt, 92pt, cardtop(204pt, 230pt, verde)[
    #veredicto("Pasó", verde)
    #v(14pt)
    #id("CP-PRO-01")
    #v(13pt)
    #text(size: 15pt, fill: apoyo, [Canon · «Select required!» · el carrito queda vacío.])
  ])
  #at(488pt, 92pt, cardtop(204pt, 230pt, ambar)[
    #veredicto("Bloqueado", ambar)
    #v(14pt)
    #id("CP-PRO-02")
    #v(13pt)
    #text(size: 15pt, fill: apoyo, [Opciones requeridas sin valores seleccionables.])
  ])
  #at(708pt, 92pt, cardtop(204pt, 230pt, ambar)[
    #veredicto("Bloqueado", ambar)
    #v(14pt)
    #id("CP-CUP-01", size: 16pt) #text(size: 16pt, fill: apoyo, [ \/ ]) #id("CP-CUP-02", size: 16pt)
    #v(13pt)
    #text(size: 15pt, fill: apoyo, [Tres cupones: deshabilitados y vencidos.])
  ])
  #at(48pt, 338pt, box(width: 864pt, height: 130pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 18pt))[
    #rotulo("Regla de agregación", c: rgb("#7FA6B8"))
    #v(14pt)
    #text(size: 21pt, weight: "bold", fill: white,
      [Sin su variante positiva obligatoria, un caso no se aprueba.])
    #v(12pt)
    #text(size: 16pt, fill: rgb("#B9C9D3"),
      [Dos variantes negativas correctas no bastan para aprobar el caso de cupones.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 7 · DEF-01 · defecto abierto
// =====================================================================
#let meta(x, y, w, etiqueta, valor, c: tinta) = at(x, y,
  card(w, 78pt)[
    #rotulo(etiqueta)
    #v(8pt)
    #text(size: 19pt, weight: "bold", fill: c, valor)
  ])

#frame(7, "DEF-01 · defecto abierto",
  "Franco · 3:55–5:10", 32, "Informe §4.5 Hallazgos · p. 32")[
  #at(48pt, 90pt, box(width: 864pt, height: 66pt, fill: rojo.lighten(92%),
    radius: 4pt, stroke: (paint: rojo.lighten(45%), thickness: 1pt),
    inset: (x: 20pt, y: 12pt), align(horizon, {
      id("DEF-01", size: 16pt)
      text(size: 17pt, weight: "bold", fill: rojo,
        [ · «[Carrito] El total de línea no coincide con el total a pagar al aumentar la cantidad de una a dos unidades»])
    })))
  #at(48pt, 172pt, card(280pt, 142pt)[
    #cifra([122], [Precio unitario])
  ])
  #at(340pt, 172pt, card(280pt, 142pt, bordecolor: rojo.lighten(40%))[
    #cifra([242], [Total de línea mostrado], c: rojo)
    #v(6pt)
    #text(size: 15pt, weight: "bold", fill: rojo, [esperado 244])
  ])
  #at(632pt, 172pt, card(280pt, 142pt)[
    #cifra([244], [Total a pagar mostrado])
  ])
  #meta(48pt, 328pt, 280pt, "Severidad", [Alta], c: rojo)
  #meta(340pt, 328pt, 280pt, "Prioridad propuesta", [Alta], c: rojo)
  #meta(632pt, 328pt, 280pt, "Estado", [Abierto · reproducido 25/09])
  #at(48pt, 420pt, box(width: 864pt, height: 56pt, fill: white, radius: 4pt,
    stroke: (paint: linea, thickness: 1pt), inset: (x: 20pt, y: 12pt), align(horizon,
      grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
        text(size: 16pt, fill: apoyo,
          [Eco Tax: hipótesis, no causa confirmada. No inspeccionamos código.]),
        { text(size: 16pt, fill: apoyo, [Caso de origen: ]); id("CP-CAR-01", size: 16pt) }))))
]
#pagebreak()

// =====================================================================
// LÁMINA 8 · Frontera de stock y alcance del veredicto
// =====================================================================
#frame(8, "Frontera de stock y alcance del veredicto",
  "Franco · 5:10–6:00", 16, "Informe §3.2 CP-CAR-02 · p. 16")[
  #at(48pt, 92pt, card(280pt, 136pt)[
    #cifra([147 unidades], [Sin señal de insuficiencia], size: 30pt)
  ])
  #at(340pt, 92pt, card(280pt, 136pt, bordecolor: ambar.lighten(40%))[
    #cifra([148 unidades], [Marca de falta de stock · el checkout devuelve al carrito],
      c: ambar, size: 30pt)
  ])
  #at(632pt, 92pt, card(280pt, 136pt)[
    #rotulo("Cantidades no válidas")
    #v(13pt)
    #text(size: 16pt, [*0 · −1 · abc* retiran la línea.])
    #v(8pt)
    #text(size: 16pt, [*1.5 · vacío* se normalizan a 1 (observación).])
  ])
  #at(48pt, 248pt, box(width: 864pt, height: 122pt, fill: white, radius: 4pt,
    stroke: (paint: verde.lighten(45%), thickness: 1pt), inset: (x: 22pt, y: 16pt))[
    #{
      box(baseline: 4pt, veredicto("Pasó", verde))
      h(12pt)
      id("CP-CAR-02")
      text(size: 17pt, [ · integridad de cantidades y frontera de stock])
    }
    #v(14pt)
    #{
      text(size: 17pt, fill: apoyo, [No cubre el cálculo monetario —eso lo cubre ])
      id("CP-CAR-01", size: 17pt)
      text(size: 17pt, fill: apoyo, [, que falló— ni demuestra una compra completada.])
    }
  ])
  #at(48pt, 388pt, box(width: 864pt, height: 84pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 17pt))[
    #rotulo("Cierre del bloque de Franco", c: rgb("#7FA6B8"))
    #v(12pt)
    #text(size: 21pt, weight: "bold", fill: white,
      [7 casos Alta: 3 Pasó · 1 Falló · 3 Bloqueado])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 9 · DEF-04 · defecto abierto
// =====================================================================
#frame(9, "DEF-04 · defecto abierto",
  "Granit · 6:00–7:05", 32, "Informe §4.5 Hallazgos · p. 32")[
  #at(48pt, 90pt, box(width: 864pt, height: 66pt, fill: rojo.lighten(92%),
    radius: 4pt, stroke: (paint: rojo.lighten(45%), thickness: 1pt),
    inset: (x: 20pt, y: 12pt), align(horizon, {
      id("DEF-04", size: 16pt)
      text(size: 17pt, weight: "bold", fill: rojo,
        [ · «[Checkout] No se ofrece método de pago aplicable en el recorrido de invitado ensayado»])
    })))
  #at(48pt, 168pt, cardtop(512pt, 132pt, rojo)[
    #rotulo("Mensaje literal del sistema", c: rojo)
    #v(13pt)
    #text(size: 21pt, weight: "bold", [«No Payment options are available»])
    #v(10pt)
    #text(size: 16pt, fill: apoyo, [Confirm Order queda deshabilitado.])
  ])
  #at(584pt, 168pt, cardtop(328pt, 132pt, verde)[
    #rotulo("Lo que sí funcionó", c: verde)
    #v(13pt)
    #text(size: 16pt, [Apellido vacío validado · datos del invitado guardados correctamente.])
  ])
  #meta(48pt, 314pt, 280pt, "Severidad", [Crítica para este recorrido], c: rojo)
  #meta(340pt, 314pt, 280pt, "Prioridad propuesta", [Alta], c: rojo)
  #meta(632pt, 314pt, 280pt, "Estado", [Abierto · causa en análisis])
  #at(48pt, 404pt, box(width: 864pt, height: 80pt, fill: tinta, radius: 4pt,
    inset: (x: 22pt, y: 14pt))[
    #{
      box(baseline: 4pt, link("ref://19", underline(offset: 2pt,
        text(fill: rgb("#57BEDC"), size: 17pt, weight: "bold", [CP-CHK-01]))))
      text(size: 17pt, weight: "bold", fill: white,
        [ falló · En el recorrido probado, el cliente no puede pagar.])
    }
    #v(8pt)
    #text(size: 15pt, fill: rgb("#B9C9D3"),
      [Cash on Delivery figura habilitado en el panel: es una pista, no una causa confirmada.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 10 · Los nueve bloqueos tienen causas distintas
// =====================================================================
#let causa(x, n, titulo, cuerpo) = at(x, 186pt, card(204pt, 190pt, pad: 14pt)[
  #text(size: 30pt, weight: "bold", fill: ambar, n)
  #v(6pt)
  #text(size: 16pt, weight: "bold", titulo)
  #v(10pt)
  #cuerpo
])

#frame(10, "Los nueve bloqueos tienen causas distintas",
  "Granit · 7:05–8:00", 29, "Informe §4.2 Registro de casos Alta · p. 29")[
  #at(48pt, 88pt, card(596pt, 84pt)[
    #box(fill: ambar, radius: 3pt, inset: (x: 11pt, y: 5pt),
      text(size: 14pt, fill: white, weight: "bold", tracking: 1.1pt, [BLOQUEADO ≠ FALLÓ]))
    #v(13pt)
    #text(size: 16pt, fill: apoyo,
      [*Falló:* el sistema se comportó distinto de lo esperado. *Bloqueado:* un impedimento impidió ejecutarlo.])
  ])
  #at(660pt, 88pt, box(width: 252pt, height: 84pt, fill: ambar, radius: 4pt,
    inset: (x: 18pt, y: 12pt))[
    #text(size: 30pt, weight: "bold", fill: white, [9 de 14])
    #v(8pt)
    #text(size: 15pt, fill: rgb("#F6E4CC"), [casos Alta Bloqueados])
  ])

  #causa(48pt, [4], [Sin orden propia])[
    #text(size: 14pt, fill: apoyo, [Confirmación · duplicados · pedidos · sincronización])
    #v(9pt)
    #id("CP-CON-01", size: 14pt) #text(size: 14pt, fill: apoyo, [·]) #id("CP-CON-02", size: 14pt)
    #text(size: 14pt, fill: apoyo, [·]) #id("CP-PED-01", size: 14pt)
    #text(size: 14pt, fill: apoyo, [·]) #id("CP-RNF-01", size: 14pt)
  ]
  #causa(268pt, [3], [Datos del ambiente])[
    #text(size: 14pt, fill: apoyo, [Opciones sin valores · cupones no vigentes])
    #v(9pt)
    #id("CP-PRO-02", size: 14pt) #text(size: 14pt, fill: apoyo, [·]) #id("CP-CUP-01", size: 14pt)
    #text(size: 14pt, fill: apoyo, [·]) #id("CP-CUP-02", size: 14pt)
  ]
  #causa(488pt, [1], [Permisos])[
    #text(size: 14pt, fill: apoyo, [El panel negó guardar el cambio de stock])
    #v(9pt)
    #id("CP-ADM-01", size: 14pt)
  ]
  #causa(708pt, [1], [Sin instrumentación])[
    #text(size: 14pt, fill: apoyo, [Rendimiento: el protocolo exige 18 muestras, fría y cálida])
    #v(9pt)
    #id("CP-RNF-03", size: 14pt)
  ]

  #at(48pt, 392pt, box(width: 864pt, height: 42pt, fill: ambar.lighten(88%), radius: 4pt,
    stroke: (paint: ambar.lighten(40%), thickness: 1pt),
    inset: (x: 20pt, y: 8pt), align(horizon,
      text(size: 16pt, weight: "bold", fill: ambar,
        [1932 ms medidos y no presentados: un dato sin trazabilidad no es evidencia.]))))
  #at(48pt, 444pt, box(width: 864pt, height: 40pt, fill: tinta, radius: 4pt,
    inset: (x: 22pt, y: 7pt), align(horizon,
      text(size: 16pt, weight: "bold", fill: white,
        [Bloque de Granit · 7 casos Alta: 1 Falló · 6 Bloqueado]))))
]
#pagebreak()

// =====================================================================
// LÁMINA 11 · Cómo se leen estos números (criterios y denominadores)
//            — va ANTES de la lámina de resultados
// =====================================================================
#let denom(etiqueta, sobre, valor) = grid(
  columns: (1fr, 116pt),
  align: (left + horizon, right + horizon),
  inset: (y: 9pt),
  [#text(size: 17pt, weight: "bold", etiqueta) #linebreak()
   #text(size: 14pt, fill: apoyo, sobre)],
  text(size: 24pt, weight: "bold", fill: acento, valor),
)

#frame(11, "Cómo se leen estos números",
  "Granit · 8:00–8:25", 3, "Informe §1.4 Criterios de salida · p. 3")[
  #at(48pt, 92pt, cardtop(420pt, 254pt, tinta)[
    #rotulo("Criterios de salida: qué decide", c: tinta)
    #v(12pt)
    #text(size: 16pt, fill: apoyo, [Los criterios de salida del plan, no el tablero.])
    #v(18pt)
    #vi([Qué casos se ejecutaron])
    #vi([Los criterios de salida])
    #vi([Los defectos abiertos])
    #vi([Lo bloqueado o no ejecutado])
  ])
  #at(492pt, 92pt, cardtop(420pt, 254pt, acento)[
    #rotulo("Denominadores declarados", c: acento)
    #v(6pt)
    #denom([Ejecución concluyente], [sobre planificados Alta], [5 / 14])
    #line(length: 100%, stroke: (paint: linea, thickness: 1pt))
    #denom([Aprobación], [sobre concluyentes], [3 / 5])
    #line(length: 100%, stroke: (paint: linea, thickness: 1pt))
    #denom([Bloqueo], [sobre planificados Alta], [9 / 14])
  ])
  #at(48pt, 370pt, box(width: 864pt, height: 98pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 16pt), align(horizon,
      text(size: 26pt, weight: "bold", fill: white,
        [Registro ≠ ejecución.#h(40pt)Ejecución ≠ aprobación.]))))
]
#pagebreak()

// =====================================================================
// LÁMINA 12 · Resultados de los 14 casos de prioridad Alta
// =====================================================================
#let tile(x, n, palabra, c) = at(x, 92pt, box(width: 280pt, height: 132pt,
  fill: white, radius: 4pt, stroke: (paint: c.lighten(40%), thickness: 1.5pt),
  inset: (x: 20pt, y: 16pt))[
  #text(size: 52pt, weight: "bold", fill: c, n)
  #v(12pt)
  #veredicto(palabra, c)
])

#let tasa(x, pct, nombre, deno) = at(x, 244pt, card(280pt, 128pt)[
  #text(size: 40pt, weight: "bold", fill: acento, pct)
  #v(9pt)
  #text(size: 17pt, weight: "bold", nombre)
  #v(6pt)
  #text(size: 15pt, fill: apoyo, deno)
])

#frame(12, "Resultados de los 14 casos de prioridad Alta",
  "Granit · 8:25–9:00", 31, "Informe §4.4 Métricas y límites · p. 31")[
  #tile(48pt, [3], "Pasó", verde)
  #tile(340pt, [2], "Falló", rojo)
  #tile(632pt, [9], "Bloqueado", ambar)
  #tasa(48pt, [35.7 %], [Ejecución concluyente], [5 de 14 planificados Alta])
  #tasa(340pt, [60 %], [Aprobación], [3 de 5 concluyentes])
  #tasa(632pt, [64.3 %], [Bloqueo], [9 de 14 planificados Alta])
  #at(48pt, 386pt, box(width: 864pt, height: 86pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 15pt))[
    #text(size: 20pt, weight: "bold", fill: white,
      [18 casos diseñados · 14 Alta · 4 Media])
    #v(12pt)
    #box(baseline: 4pt, link("ref://27", underline(offset: 2pt,
      text(fill: rgb("#57BEDC"), size: 16pt, weight: "bold", [CP-CAT-03]))))
    #text(size: 16pt, fill: rgb("#B9C9D3"), [ y ])
    #box(baseline: 4pt, link("ref://28", underline(offset: 2pt,
      text(fill: rgb("#57BEDC"), size: 16pt, weight: "bold", [CP-VAL-01]))))
    #text(size: 16pt, fill: rgb("#B9C9D3"),
      [ entre las de prioridad Media: diseñadas, no ejecutadas en esta selección.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 13 · Defectos, observaciones y ciclo de vida  (DIAGRAMA 2)
// =====================================================================
#let etapa(x, y, w, h, t, c: tinta, relleno: white, tc: tinta) = at(x, y,
  box(width: w, height: h, fill: relleno, radius: 4pt,
    stroke: (paint: c, thickness: 1.2pt), inset: (x: 8pt, y: 6pt),
    align(center + horizon, text(size: 14pt, weight: "bold", fill: tc, t))))

// flecha simple con dirección
#let fl(x, y, dx, dy, c: acento) = {
  at(x, y, line(end: (dx, dy), stroke: (paint: c, thickness: 1.6pt)))
}
#let punta(x, y, dir, c: acento) = {
  let s = (paint: c, thickness: 1.6pt)
  if dir == "r" {
    at(x, y, line(end: (-8pt, -5pt), stroke: s))
    at(x, y, line(end: (-8pt, 5pt), stroke: s))
  } else if dir == "d" {
    at(x, y, line(end: (-5pt, -8pt), stroke: s))
    at(x, y, line(end: (5pt, -8pt), stroke: s))
  } else if dir == "u" {
    at(x, y, line(end: (-5pt, 8pt), stroke: s))
    at(x, y, line(end: (5pt, 8pt), stroke: s))
  }
}

#frame(13, "Defectos, observaciones y ciclo de vida",
  "Granit · 9:00–9:45", 32, "Informe §4.5 Hallazgos · p. 32")[
  // --- tabla ---
  #at(48pt, 86pt, box(width: 864pt, fill: white, radius: 4pt,
    stroke: (paint: linea, thickness: 1pt), clip: true, inset: 0pt,
    grid(
      columns: (384pt, 108pt, 168pt, 204pt),
      rows: (42pt, 36pt, 36pt, 36pt),
      stroke: (paint: linea, thickness: 1pt),
      inset: (x: 13pt, y: 6pt),
      align: horizon,
      grid.cell(fill: tinta, rotulo("Ítem", c: white)),
      grid.cell(fill: tinta, rotulo("Severidad", c: white)),
      grid.cell(fill: tinta, rotulo("Prioridad propuesta", c: white)),
      grid.cell(fill: tinta, rotulo("Estado", c: white)),
      { id("DEF-01", size: 14pt); text(size: 14pt, fill: apoyo,
        [ · [Carrito] total de línea ≠ total a pagar]) },
      text(size: 14pt, weight: "bold", fill: rojo, [Alta]),
      text(size: 14pt, weight: "bold", fill: rojo, [Alta]),
      text(size: 14pt, [Abierto · reproducido]),
      { id("DEF-04", size: 14pt); text(size: 14pt, fill: apoyo,
        [ · [Checkout] sin método de pago aplicable]) },
      text(size: 14pt, weight: "bold", fill: rojo, [Crítica]),
      text(size: 14pt, weight: "bold", fill: rojo, [Alta]),
      text(size: 14pt, [Abierto · causa en análisis]),
      text(size: 14pt, fill: apoyo, [3 observaciones · opciones, cupones, normalización]),
      text(size: 14pt, fill: apoyo, [—]),
      text(size: 14pt, fill: apoyo, [—]),
      text(size: 14pt, [Registradas con ficha]),
    )))

  // --- diagrama de ciclo de vida ---
  #at(48pt, 244pt, rotulo("Ciclo de vida del defecto"))
  #etapa(48pt, 272pt, 124pt, 46pt, [Nuevo], c: acento)
  #etapa(196pt, 272pt, 124pt, 46pt, [En análisis], c: acento)
  #etapa(344pt, 272pt, 124pt, 46pt, [Asignado], c: acento)
  #etapa(492pt, 272pt, 124pt, 46pt, [En corrección], c: acento)
  #etapa(640pt, 272pt, 124pt, 46pt, [Listo para reprueba], c: acento)
  #etapa(788pt, 272pt, 124pt, 46pt, [Cerrado], c: verde, relleno: verde.lighten(90%), tc: verde)

  #fl(174pt, 295pt, 20pt, 0pt)  #punta(194pt, 295pt, "r")
  #fl(322pt, 295pt, 20pt, 0pt)  #punta(342pt, 295pt, "r")
  #fl(470pt, 295pt, 20pt, 0pt)  #punta(490pt, 295pt, "r")
  #fl(618pt, 295pt, 20pt, 0pt)  #punta(638pt, 295pt, "r")
  #fl(766pt, 295pt, 20pt, 0pt)  #punta(786pt, 295pt, "r")

  // rama: desde «En análisis» hacia abajo
  #fl(258pt, 318pt, 0pt, 28pt, c: ambar)
  #punta(258pt, 346pt, "d", c: ambar)
  #etapa(168pt, 346pt, 280pt, 38pt, [Rechazado · Duplicado · Diferido],
    c: ambar, relleno: ambar.lighten(90%), tc: ambar)

  // rama: reapertura desde «Cerrado» de vuelta a «En corrección»
  #fl(850pt, 318pt, 0pt, 86pt, c: rojo)
  #fl(554pt, 404pt, 296pt, 0pt, c: rojo)
  #fl(554pt, 322pt, 0pt, 82pt, c: rojo)
  #punta(554pt, 322pt, "u", c: rojo)
  #at(596pt, 408pt, box(fill: claro, inset: (x: 6pt, y: 2pt),
    text(size: 14pt, weight: "bold", fill: rojo, [Reabierto → vuelve a En corrección])))

  // --- pie de contenido ---
  #at(48pt, 440pt, box(width: 864pt, height: 44pt, fill: tinta, radius: 4pt,
    inset: (x: 20pt, y: 8pt), align(horizon,
      grid(columns: (1fr, 1fr), align: (left + horizon, left + horizon),
        text(size: 14pt, fill: white,
          [*Prueba de confirmación:* repite el caso que falló.]),
        text(size: 14pt, fill: white,
          [*Pruebas de regresión:* que la corrección no rompa lo relacionado.])))))
]
#pagebreak()

// =====================================================================
// LÁMINA 14 · Automatización para el Proyecto 2
// =====================================================================
#let prio(x, n, nombre, texto) = at(x, 88pt, cardtop(280pt, 154pt, acento, pad: 15pt)[
  #box(width: 30pt, height: 30pt, fill: acento, radius: 15pt,
    align(center + horizon, text(size: 16pt, weight: "bold", fill: white, n)))
  #v(10pt)
  #id(nombre)
  #v(11pt)
  #text(size: 15pt, fill: apoyo, texto)
])

#frame(14, "Automatización para el Proyecto 2",
  "Granit · 9:45–10:40", 35, "Informe §5.2 Automatización · p. 35")[
  #prio(48pt, [1], "CP-CAR-01", [Riesgo monetario · cálculo decimal y misma base fiscal])
  #prio(340pt, [2], "CP-CAT-02", [12 precios · comparación repetible y determinista])
  #prio(632pt, [3], "CP-PRO-01", [Validación observable y estable · prever variación de idioma])

  #at(48pt, 252pt, cardtop(572pt, 118pt, ambar, pad: 15pt)[
    #rotulo("Sólo con ambiente preparado", c: ambar)
    #v(12pt)
    #{
      id("CP-CAR-02", size: 15pt)
      text(size: 15pt, fill: apoyo,
        [: fijar y restaurar el stock (147 no es estable en un demo compartido) · cupones vigentes y restaurables · pedidos: pago de prueba y permisos.])
    }
  ])
  #at(640pt, 252pt, cardtop(272pt, 118pt, apoyo, pad: 15pt)[
    #rotulo("Se queda manual", c: apoyo)
    #v(12pt)
    #text(size: 15pt, fill: apoyo,
      [Configuraciones ambiguas y claridad de mensajes: exigen interpretar intención.])
  ])
  #at(48pt, 382pt, box(width: 864pt, height: 102pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 15pt))[
    #text(size: 19pt, weight: "bold", fill: white,
      [Es una recomendación de automatización futura, no una suite implementada.])
    #v(12pt)
    #text(size: 15pt, fill: rgb("#B9C9D3"),
      [Automatizar un flujo nunca completado a mano produce pruebas que fallan por el bloqueo conocido en lugar de detectar defectos nuevos.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 15 · Condiciones para continuar
// =====================================================================
#let paso(x, n, titulo, texto) = at(x, 90pt, card(280pt, 204pt)[
  #text(size: 38pt, weight: "bold", fill: acento.lighten(35%), n)
  #v(10pt)
  #text(size: 19pt, weight: "bold", titulo)
  #v(13pt)
  #text(size: 15pt, fill: apoyo, texto)
])

#frame(15, "Condiciones para continuar",
  "Granit · 10:40–11:25", 35, "Informe §5.1 Conclusión · p. 35")[
  #paso(48pt, [01], [Habilitar un ambiente controlado],
    [Productos con opciones completas · un cupón vigente · un método de pago de prueba · permisos de escritura · medición exportable.])
  #paso(340pt, [02], [Reejecutar y repetir],
    [Los 9 casos bloqueados y los casos fallidos cuando exista corrección. Se conserva la evidencia anterior y se registra cada corrida.])
  #paso(632pt, [03], [Regresión y recálculo],
    [Regresión en carrito, checkout y pedidos; después se recalculan los indicadores con sus denominadores.])
  #at(48pt, 314pt, box(width: 864pt, height: 154pt, fill: tinta, radius: 4pt,
    inset: (x: 24pt, y: 22pt))[
    #rotulo("Gestión de la Configuración", c: rgb("#7FA6B8"))
    #v(16pt)
    #text(size: 20pt, weight: "bold", fill: white,
      [Se conserva la evidencia anterior y se registra cada corrida del testware.])
    #v(16pt)
    #text(size: 17pt, fill: rgb("#B9C9D3"),
      [Así un cambio en los datos del demo no se confunde con una corrección del sistema.])
  ])
]
#pagebreak()

// =====================================================================
// LÁMINA 16 · Conclusión
// =====================================================================
#frame(16, "Conclusión",
  "Granit · 11:25–12:00", 35, "Informe §5.1 Conclusión · p. 35", dark: true)[
  #at(48pt, 90pt, card(280pt, 164pt)[
    #cifra([18], [casos diseñados, todos trazables], size: 40pt)
  ])
  #at(340pt, 90pt, card(280pt, 164pt)[
    #cifra([9 de 14], [casos Alta Bloqueados, con causa registrada], c: ambar, size: 40pt)
  ])
  #at(632pt, 90pt, card(280pt, 164pt)[
    #cifra([2], [defectos abiertos], c: rojo, size: 40pt)
    #v(10pt)
    #{ id("DEF-01", size: 16pt); text(size: 16pt, fill: apoyo, [ y ]); id("DEF-04", size: 16pt) }
  ])
  #at(48pt, 276pt, box(fill: acento, radius: 3pt, inset: (x: 13pt, y: 7pt),
    text(size: 14pt, fill: white, weight: "bold", tracking: 1.6pt,
      [ESTADO FRENTE A LOS CRITERIOS DE SALIDA])))
  #at(48pt, 320pt, box(width: 864pt,
    text(size: 29pt, weight: "bold", fill: white,
      [Los resultados no son suficientes para recomendar el sistema para producción.])))
  #at(48pt, 398pt, box(width: 420pt, height: 74pt, fill: rgb("#1D3B4E"), radius: 4pt,
    inset: (x: 18pt, y: 13pt), align(horizon,
      text(size: 16pt, fill: rgb("#B9C9D3"),
        [El informe deja registrado qué volver a probar y bajo qué condiciones.]))))
  #at(492pt, 398pt, box(width: 420pt, height: 74pt, fill: rgb("#1D3B4E"), radius: 4pt,
    inset: (x: 18pt, y: 13pt), align(horizon,
      text(size: 16pt, fill: rgb("#B9C9D3"),
        [El ambiente donde se prueba es parte del trabajo, no un supuesto.]))))
]
#pagebreak()

// =====================================================================
// LÁMINA 17 · Preguntas
// =====================================================================
#frame(17, "Preguntas",
  "Franco y Granit · fuera de los 12 minutos", 1, "Informe integrado · Grupo 5", dark: true)[
  #at(48pt, 108pt, box(fill: acento, radius: 3pt, inset: (x: 14pt, y: 7pt),
    text(size: 15pt, fill: white, weight: "bold", tracking: 2pt, [GRUPO 5])))
  #at(48pt, 158pt, box(width: 864pt,
    text(size: 64pt, weight: "bold", fill: white, [Preguntas])))
  #at(48pt, 246pt, rect(width: 96pt, height: 4pt, fill: acento))
  #at(48pt, 272pt, box(width: 864pt,
    text(size: 22pt, fill: rgb("#B9C9D3"),
      [Franco Roque Castillo · Granit Espinoza Salazar])))
  #at(48pt, 336pt, box(width: 280pt, height: 84pt, fill: rgb("#1D3B4E"), radius: 4pt,
    inset: (x: 18pt, y: 14pt))[
    #rotulo("01", c: rgb("#7FA6B8"))
    #v(10pt)
    #text(size: 20pt, weight: "bold", fill: white, [Contra qué medimos])
  ])
  #at(340pt, 336pt, box(width: 280pt, height: 84pt, fill: rgb("#1D3B4E"), radius: 4pt,
    inset: (x: 18pt, y: 14pt))[
    #rotulo("02", c: rgb("#7FA6B8"))
    #v(10pt)
    #text(size: 20pt, weight: "bold", fill: white, [Qué encontramos])
  ])
  #at(632pt, 336pt, box(width: 280pt, height: 84pt, fill: rgb("#1D3B4E"), radius: 4pt,
    inset: (x: 18pt, y: 14pt))[
    #rotulo("03", c: rgb("#7FA6B8"))
    #v(10pt)
    #text(size: 20pt, weight: "bold", fill: white, [Qué decidimos])
  ])
  #at(48pt, 444pt, box(width: 864pt,
    text(size: 16pt, fill: rgb("#8296A3"),
      [Proyecto 1 · Caso 3 · OpenCart Demo 4.0.2.3 · 25/09/2026])))
]

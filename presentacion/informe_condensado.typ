#import "_tablas.typ": *
#import "_anexo.typ": *

// --- enlaces automáticos: todo identificador lleva a su tabla, si existe
#let _lk(destino, txt) = context {
  if query(destino).len() > 0 {
    link(destino)[#underline(offset: 1.6pt, text(fill: rgb("#0A5C8A"), txt))]
  } else { txt }
}
#let _cuplink(s) = {
  let pre = if s.starts-with("CUP-") { "" } else { s.slice(0, 1) }
  let id = if pre == "" { s } else { s.slice(1) }
  text(pre) + _lk(label("caso-" + id), id)
}
#show regex("\\bCP-[A-Z]{3}-\\d{2}\\b"): it => _lk(label("caso-" + it.text), it.text)
#show regex("\\b(?:E-RF|RNF-)\\d{2}\\b"): it => _lk(label("req-" + it.text), it.text)
#show regex("\\bE-RNF\\d{2}\\b"): it => _lk(label("req-RNF-" + it.text.slice(5)), it.text)
#show regex("\\b(?:DEF|OBS|CONF)-F?\\d{2}\\b"): it => _lk(label("hall-" + it.text), it.text)
#show regex("\\bH-CUP-\\d{2}\\b"): it => _lk(label("hall-" + it.text), it.text)
#show regex("\\bC-CUP-\\d{2}\\b"): it => _lk(label("hall-" + it.text), it.text)
#show regex("(?:^|[^-])CUP-\\d{2}\\b"): it => _cuplink(it.text)
#show regex("\\bE-\\d{2}\\b"): it => _lk(label("ev-" + it.text.slice(2)), it.text)

// Informe de pruebas — Grupo 5 — CS5383
#set page(
  paper: "a4", margin: 2cm,
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 8pt, fill: rgb("#5A6B76"))
      grid(columns: (1fr, auto),
        [Grupo 5 · Informe de pruebas · OpenCart Demo 4.0.2.3],
        [PP-G5-C3-v1.0])
      v(-6pt); line(length: 100%, stroke: 0.4pt + rgb("#D6DEE3"))
    }
  },
  footer: context {
    set text(size: 8pt, fill: rgb("#5A6B76"))
    line(length: 100%, stroke: 0.4pt + rgb("#D6DEE3"))
    v(-3pt)
    grid(columns: (1fr, auto), [Grupo 5 — Franco Roque Castillo · Granit Espinoza Salazar],
      [#counter(page).display("1 / 1", both: true)])
  },
)
#set text(font: ("Times New Roman", "Times"), size: 9pt, lang: "es", hyphenate: false)
#set par(justify: false, leading: 0.55em)

#let TINTA = rgb("#142D3D")
#let GRIS  = rgb("#5A6B76")
#let CYAN  = rgb("#007C9F")
#let AZUL  = rgb("#1F4E79")
#let VERDE = rgb("#18744D")
#let ROJO  = rgb("#BA3C3C")
#let AMBAR = rgb("#A46810")
#let PALE  = rgb("#F2F6F8")
#let LINEA = rgb("#D6DEE3")

#set heading(numbering: none)
#show heading.where(level: 1): it => block(below: 7pt, above: 12pt)[
  #block(width: 100%, inset: (x: 7pt, y: 5pt), radius: 2pt, fill: TINTA,
    text(size: 12pt, weight: "bold", fill: white)[#it.body])
]
#show heading.where(level: 2): it => block(below: 5pt, above: 9pt,
  text(size: 10pt, weight: "bold", fill: CYAN)[#it.body])

#let nota(c) = text(size: 8.2pt, style: "italic", fill: GRIS)[#c]
#let lit(x) = text(size: 7.6pt, font: ("Courier New", "Courier"))[#x]
#let chip(t, c) = box(inset: (x: 4pt, y: 1.5pt), radius: 2.5pt, fill: c.lighten(86%),
  stroke: 0.5pt + c, text(size: 8pt, weight: "bold", fill: c)[#t])
#let ALTA = chip("Alta", ROJO)
#let MEDIA = chip("Media", AMBAR)
#let BAJA = chip("Baja", GRIS)
#let PASO = chip("Pasó", VERDE)
#let FALLO = chip("Falló", ROJO)
#let BLOQ = chip("Bloqueado", AMBAR)

#let hd(..c) = c.pos().map(x => text(size: 8.2pt, weight: "bold", fill: white)[#x])
#let T(cols, ..cuerpo) = table(
  columns: cols, stroke: 0.4pt + LINEA, inset: (x: 4pt, y: 3pt), align: left + top,
  fill: (_, y) => if y == 0 { AZUL } else if calc.odd(y) { PALE } else { white },
  ..cuerpo.pos().map(x => if type(x) == content or type(x) == str {
    text(size: 8.2pt)[#x] } else { x })
)

// ---------- etapa (estilo reutilizado de ruta_caso.typ) ----------
#let etapa(n, titulo, cuerpo, color: CYAN, ultimo: false) = block(
  below: if ultimo {0pt} else {3.5pt}, width: 100%,
  grid(columns: (18pt, 1fr), column-gutter: 7pt, align: (top, top),
    circle(radius: 7.5pt, fill: color, stroke: none,
      align(center + horizon, text(size: 7pt, weight: "bold", fill: white)[#n])),
    [
      #text(size: 8.6pt, weight: "bold", fill: TINTA)[#titulo]
      #linebreak()
      #text(size: 8.4pt, fill: rgb("#2B3A44"))[#cuerpo]
    ]
  )
)

// ---------- fila de la ruta del caso ----------
#let et(col, n, titulo, cuerpo) = (
  text(size: 8pt, weight: "bold", fill: col)[#n],
  text(size: 8pt, weight: "bold")[#titulo],
  text(size: 8pt)[#cuerpo],
)
#let TRUTA(..filas) = table(
  columns: (0.8cm, 3.5cm, 1fr), stroke: 0.4pt + LINEA, inset: 4pt, align: left + top,
  fill: (_, y) => if y == 0 { AZUL } else if calc.odd(y) { PALE } else { white },
  table.header(
    text(size: 8pt, weight: "bold", fill: white)[\#],
    text(size: 8pt, weight: "bold", fill: white)[Etapa],
    text(size: 8pt, weight: "bold", fill: white)[Detalle]),
  ..filas.pos()
)

// ---------- ficha de hallazgo ----------
#let ficha(color, titulo, cuerpo) = block(width: 100%, breakable: false, inset: 8pt, radius: 2pt,
  stroke: (left: 3pt + color), fill: PALE)[
  #text(size: 9.6pt, weight: "bold", fill: TINTA)[#titulo]
  #v(3pt)
  #cuerpo
]

// ===================== 1. PORTADA =====================
#image("banner_utec.png", width: 100%, height: 2.4cm, fit: "cover")
#v(8pt)
#text(size: 20pt, weight: "bold", fill: black)[Informe de pruebas] <sec-portada>
#v(1pt)
#text(size: 12pt, fill: GRIS)[Caso 3 — OpenCart Demo 4.0.2.3 · Grupo 5]
#v(3pt)
#text(size: 10.5pt, fill: TINTA)[Se planificaron y diseñaron pruebas para los once requisitos del caso; este informe *profundiza en el módulo de cupones de descuento* (E-RF04), desde el requisito hasta sus defectos.]
#v(6pt)
#line(length: 100%, stroke: 0.6pt + LINEA)
#v(8pt)

== Control documental
#T((3.4cm, 1fr, 3cm, 1fr),
  ..hd("Campo", "Valor", "Campo", "Valor"),
  [Identificador], [PP-G5-C3-v1.0], [Versión], [1.0],
  [Fecha], [26/09/2026], [Curso], [CS5383 · Verificación y Pruebas de Software],
  [Autores], [Franco Roque Castillo · Granit Espinoza Salazar], [Grupo], [5],
  [Sistema bajo prueba], [OpenCart Demo 4.0.2.3 (inglés, USD)], [Aprobación], [Docente CS5383; sin aprobación de cliente],
  [Foco del informe], [E-RF04 — aplicación de cupones de descuento en el carrito], [Contexto], [Los otros diez requisitos se conservan como marco del análisis],
  [Marco de referencia], [ISTQB CTFL v4.0.1; estructura del plan según ISO/IEC/IEEE 29119-3], [Gestión de la Configuración], [ID único, versión y registro de cambios por elemento del testware; evidencias con SHA-256 en #raw("el inventario de evidencias")],
)
#v(5pt)
#T((1fr, 1fr, 1fr, 1fr, 1fr),
  ..hd("Casos diseñados", "Casos Alta", "Concluyentes", "Aprobación", "Bloqueo"),
  text(size: 12pt, weight: "bold", fill: TINTA)[18],
  text(size: 12pt, weight: "bold", fill: TINTA)[14],
  text(size: 12pt, weight: "bold", fill: CYAN)[5 / 14 = 35.7 %],
  text(size: 12pt, weight: "bold", fill: VERDE)[3 / 5 = 60 %],
  text(size: 12pt, weight: "bold", fill: AMBAR)[9 / 14 = 64.3 %],
)
#v(4pt)
#nota[Cifras del proyecto completo. Aprobación sobre casos concluyentes; bloqueo sobre planificados. Las cifras propias del módulo de cupones se calculan en la sección 7.]

#v(9pt)
== Contenido del informe
#T((1.1cm, 4.4cm, 1fr),
  ..hd("Sec.", "Contenido", "Qué aporta"),
  [2], [Plan de pruebas], [Las once secciones del plan: alcance, riesgos, estrategia, entorno, responsables y cronograma.],
  [3], [Análisis por riesgo], [Priorización de los once requisitos y técnicas de diseño aplicadas.],
  [4], [Alcance general del diseño], [Trazabilidad resumida de los 18 casos diseñados para todo el sistema, sólo como contexto.],
  [5], [Módulo de cupones], [Parte central: configuración, tabla de decisión, once casos, ejecución, ruta del caso, hallazgos y pendientes.],
  [6], [Otros hallazgos fuera del foco], [Los dos defectos abiertos de otros módulos, enunciados sin desarrollarse.],
  [7], [Criterios de salida y métricas], [Criterios declarados y cifras del módulo de cupones con sus denominadores.],
  [8], [Cierre y automatización], [Conclusión del módulo y qué conviene automatizar en el Proyecto 2.],
  [9], [Anexo de evidencias], [Índice de las capturas registradas y las cinco evidencias del módulo ampliadas.],
)

#pagebreak()

// ===================== 2. PLAN =====================
= 2. Plan de pruebas — ISO/IEC/IEEE 29119-3 <sec-plan>

== 2.1 Identificación · 2.2 Contexto
#T((3.2cm, 1fr),
  ..hd("Sección", "Contenido compactado"),
  [1 Identificación], [PP-G5-C3-v1.0 · v1.0 · Franco y Granit · aprobación docente · testware bajo Gestión de la Configuración con SHA-256.],
)

== 2.3 Ítems de prueba y alcance <sec-alcance>
#T((3.6cm, 1fr, 1fr),
  ..hd("Ítem", "En alcance", "Fuera de alcance"),
  [E-RF01 Catálogo], [Orden por nombre y precio, filtros], [CRUD de categorías],
  [E-RF02 Opciones de producto], [Opción requerida, ajuste de precio], [Combinatoria total],
  [E-RF03 Carrito y recálculo], [Cantidades válidas e inválidas, totales], [—],
  [E-RF04 Cupones], [Vigencia, elegibilidad, no acumulación], [Alta de cupones],
  [E-RF05 Checkout invitado], [Campos, método de pago], [Registro / login],
  [E-RF06 Confirmación], [ID de orden, idempotencia], [Pagos reales],
  [E-RF07 Pedidos en panel], [Orden propia visible], [Devoluciones],
  [E-RF08 Stock administrativo], [Guardado de agotado y propagación], [—],
  [RNF-01 Propagación público → panel], [Latencia < 60 s], [—],
  [RNF-02 Compatibilidad], [Chrome, Edge, Firefox], [Móviles],
  [RNF-03 Respuesta de catálogo], [Carga < 2000 ms], [Carga y estrés],
)
#v(2pt)
#nota[Build 4.0.2.3, inglés, USD. Excluidos además: modificar código, seguridad, carga y pruebas de componente.]

== 2.4 Supuestos y restricciones
#T((1fr, 1fr),
  ..hd("Supuesto", "Restricción observada"),
  [Demo accesible con datos ficticios], [Demo compartido: los datos cambian],
  [Cupones y opciones disponibles], [Los cupones leídos estaban vencidos y deshabilitados],
  [Permisos de escritura en el panel], [El panel denegó el guardado],
  [Instrumentación exportable], [No disponible; RNF-03 no medible],
  [24 h estimadas], [Dos ejecutores, sin código fuente],
)

== 2.5 Riesgos <sec-riesgos>
#T((5.6cm, 1.5cm, 1.9cm, 1.7cm, 1fr),
  ..hd("Riesgo", "Tipo", "Probab.", "Impacto", "Tratamiento / casos"),
  [R01 Inventario divergente ficha/carrito/panel], [Producto], [Alta], [Crítico], [CP-CAR-02, CP-ADM-01],
  [R02 Cupón válido rechazado o descuento incorrecto], [Producto], [Alta], [Crítico], [CP-CUP-01/02; verificar vigencia antes],
  [R03 Importes o impuestos inconsistentes], [Producto], [Alta], [Crítico], [CP-CAR-01, CP-PRO-02, CP-CON-01],
  [R04 Opción obligatoria ausente o distinta], [Producto], [Media], [Crítico], [CP-PRO-01/02],
  [R05 Venta sobre el stock real], [Producto], [Alta], [Crítico], [CP-CAR-02 (S, S+1)],
  [R06 Acumulación indebida de descuentos], [Producto], [Media], [Crítico], [CP-CUP-02],
  [R07 Checkout invitado no completado], [Producto], [Alta], [Crítico], [CP-CHK-01, CP-CON-01],
  [R08 Pedido perdido o duplicado], [Producto], [Media], [Crítico], [CP-CON-02, CP-PED-01, CP-RNF-01],
  [R09 Catálogo lento u orden de precio incorrecto], [Producto], [Media], [Operacional], [CP-CAT-02, CP-RNF-03],
  [R10 Incompatibilidad de navegador], [Producto], [Media], [Operacional], [CP-RNF-02],
  [R11 Orden por nombre o filtros confusos], [Producto], [Media], [Operacional], [CP-CAT-01/03],
  [R12 Certificado aceptado indebidamente], [Producto], [Baja], [Crítico], [CP-VAL-01],
  [P01 Permisos limitados en el panel], [Proceso], [Alta], [Operacional], [Registrar Bloqueado, no Falló],
  [P02 Datos del demo cambian], [Proceso], [Alta], [Operacional], [Revalidar precondiciones por corrida],
  [P03 Sin instrumentación], [Proceso], [Alta], [Operacional], [Declarar RNF-03 no medible],
  [P04 Fecha de entrega fija], [Proceso], [Media], [Operacional], [Reserva de 2 h],
)

== 2.6 Estrategia de pruebas
#T((5.4cm, 2.8cm, 1fr),
  ..hd("Estrategia del curso", "Uso", "Razón"),
  [Analítica basada en riesgos], text(size: 8.2pt, weight: "bold")[Principal], [El daño se concentra en dinero, inventario y descuentos; el riesgo fija la profundidad],
  [Basada en requisitos], [Complementaria], [Asegura diseño y trazabilidad de los 11 requisitos],
  [Exploración acotada (reactiva)], [Sólo reconocimiento], [Identificar datos, cupones y bloqueos; no genera veredictos],
  [Basada en modelos], [No usada], [No hay modelo formal ni especificación interna],
  [Consultiva / dirigida por interesados], [No usada], [No hay interesado del negocio en un demo público],
  [Preventiva de regresión], [Diseñada, no ejecutada], [Sin corrección aplicada no hay base para prueba de confirmación ni pruebas de regresión],
  [Conforme a estándar / proceso], text(size: 8.2pt, weight: "bold")[No se reclama], [El marco es el temario ISTQB; afirmar cumplimiento de ISO/IEC/IEEE 29119 exigiría auditoría],
)
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 8pt,
  T((2.4cm, 1fr),
    ..hd("Nivel", "Profundidad real"),
    [Componente], [No ejecutado: sin código],
    [Integración], [Observada por interfaz: carrito↔checkout, sitio↔panel. Sin cobertura de APIs],
    [Sistema], [Nivel principal: comportamiento externo del sistema desplegado],
    [Aceptación], [Limitada a los criterios del caso; sin firma del cliente],
  ),
  T((3.4cm, 1.4cm, 1fr),
    ..hd("Ítem", "Riesgo", "Profundidad asignada"),
    [E-RF03/04/05/06], [Alta], [Positivos, negativos, fronteras y variantes; ejecución obligatoria],
    [E-RF02/07/08, RNF-01], [Alta], [Un positivo y un negativo; ejecución obligatoria],
    [E-RF01, RNF-03], [Media], [Un caso ejecutado; complementarios sólo diseñados],
    [RNF-02], [Baja], [Diseñado, no ejecutado],
  ),
)

== 2.7 Entregables · 2.8 Tareas
#grid(columns: (1fr, 1.25fr), column-gutter: 8pt,
  T((1fr,),
    ..hd("Entregables de prueba"),
    [Plan de pruebas · registro de riesgos · 26 condiciones · 18 casos · registro de ejecución de los 14 Alta · desarrollo completo del módulo de cupones · hallazgos con evidencia · informe de finalización · manifiesto SHA-256.],
  ),
  T((2.6cm, 1fr),
    ..hd("Sub-proceso", "Tareas"),
    [Planificación], [Analizar el caso; valorar riesgos; priorizar requisitos; estimar 24 h; definir criterios],
    [Diseño e impl.], [Derivar 26 condiciones; escribir 18 casos con técnica declarada; preparar fixtures],
    [Ejecución], [Verificar precondiciones; ejecutar los 14 Alta; profundizar en cupones; registrar veredicto y evidencia],
    [Cierre], [Consolidar métricas con contexto; declarar riesgo residual; archivar el testware bajo Gestión de la Configuración],
  ),
)

== 2.9 Entorno y datos · 2.10 Responsabilidades · 2.11 Cronograma
#grid(columns: (1fr, 1fr), column-gutter: 8pt,
  T((2.5cm, 1fr),
    ..hd("Necesidad", "Detalle"),
    [Software], [OpenCart Demo 4.0.2.3, sitio público y panel],
    [Hardware / red], [PC Windows, navegador de escritorio, red sin instrumentación],
    [Herramientas], [Capturas de pantalla, registro estructurado de ejecución, manifiesto SHA-256],
    [Datos], [Ficticios: invitado, direcciones, cantidades 0/-1/1.5/abc/vacío, S=147, S+1=148],
    [Datos del demo], [Cupones vigentes y productos con opciones completas: no disponibles],
  ),
  [
    #T((2.2cm, 1fr),
      ..hd("Responsable", "Alcance"),
      [Franco], [E-RF01 a E-RF04; apoyo RNF-03],
      [Granit], [E-RF05 a E-RF08; RNF-01 y RNF-02],
      [Ambos], [Revisión cruzada, Gestión de la Configuración, entrega],
    )
    #v(4pt)
    #T((2.6cm, 1fr),
      ..hd("Fecha", "Hito y resultado"),
      [18/09/2026], [Exploración acotada: funcionalidades y datos identificados],
      [24/09/2026], [Planificación, análisis y diseño: 26 condiciones, 16 riesgos, 18 casos],
      [24–25/09/2026], [Ejecución: 14 casos Alta con evidencia],
      [26/09/2026], [Profundización en cupones: 11 casos y 8 ejecuciones registradas],
      [Tras habilitar el ambiente], [Reejecución de bloqueados, prueba de confirmación y pruebas de regresión],
    )
  ],
)
#v(3pt)
#nota[Comunicación: coordinación diaria y repositorio compartido del testware. Todo bloqueo de permisos o datos se documenta en el registro y se eleva a la docente.]

#pagebreak()

// ===================== 3. ANÁLISIS =====================
= 3. Análisis: priorización de requisitos por riesgo <sec-analisis>
#nota[Prioridad derivada del nivel de riesgo, no del esfuerzo de prueba.]
#v(4pt)
#T((3.8cm, 2cm, 1fr),
  ..hd("Requisito", "Nivel", "Justificación"),
  [E-RF03 Carrito y recálculo <req-E-RF03>], ALTA, [Un error aritmético cobra importes incorrectos al cliente.],
  [E-RF04 Cupones <req-E-RF04>], ALTA, [Un descuento indebido reduce el ingreso sin autorización.],
  [E-RF05 Checkout invitado <req-E-RF05>], ALTA, [Si el recorrido no se completa, simplemente no hay venta.],
  [E-RF06 Confirmación <req-E-RF06>], ALTA, [Sin ID no hay seguimiento; un duplicado cobra dos veces.],
  [E-RF08 Stock administrativo <req-E-RF08>], ALTA, [Sobreventa: es la queja de negocio que originó el Caso 3.],
  [E-RF02 Opciones de producto <req-E-RF02>], ALTA, [La variante seleccionada define qué producto se entrega.],
  [E-RF07 Pedidos en panel <req-E-RF07>], ALTA, [Una orden invisible impide su atención operativa.],
  [RNF-01 Propagación público → panel <req-RNF-01>], ALTA, [La demora provoca reintentos y pedidos duplicados.],
  [E-RF01 Catálogo <req-E-RF01>], MEDIA, [Afecta la navegación y la comparación, no el importe cobrado.],
  [RNF-03 Respuesta de catálogo <req-RNF-03>], MEDIA, [Degrada la experiencia sin impedir completar la compra.],
  [RNF-02 Compatibilidad <req-RNF-02>], BAJA, [Alcance limitado a tres navegadores de escritorio equivalentes.],
)
#v(6pt)
#block(width: 100%, breakable: false, inset: 8pt, radius: 3pt, fill: PALE, stroke: (left: 3pt + CYAN))[
  #text(size: 9.4pt, weight: "bold", fill: TINTA)[Por qué este informe se concentra en un solo requisito]
  #v(3pt)
  #text(size: 8.8pt)[Se analizaron y priorizaron los once requisitos del caso y se diseñaron casos de prueba para todos ellos; la ejecución dejó hallazgos en varios módulos —carrito, checkout, opciones de producto y cupones—. A partir de aquí *este informe profundiza en E-RF04, el módulo de cupones*. Es el requisito que concentra el riesgo económico más directo: un cupón mal aplicado descuenta dinero real sin autorización, y un cupón válido rechazado hace perder la venta. Además es el único módulo donde pudimos recorrer el camino completo —requisito, riesgo, condiciones, técnica, casos, ejecución, defectos y lo que queda pendiente— con evidencia en cada etapa. Los demás requisitos quedan como contexto: su diseño y su trazabilidad se conservan en las secciones 3 y 4, y sus defectos se enuncian en la sección 6 sin desarrollarse.]
]

== 3.1 Técnicas de diseño aplicadas <sec-tecnicas>
#T((4.6cm, 1fr),
  ..hd("Técnica", "Casos y por qué esa y no otra"),
  [Partición de equivalencia], [CP-CAT-01/02/03, CP-PRO-01/02, CP-CAR-01/02, CP-CUP-01, CP-CHK-01, CP-RNF-02. Cantidad y código agrupan clases válidas e inválidas; enumerar valores sería redundante.],
  [Análisis de valores límite], [CP-CAR-02 (S = 147 y S+1 = 148). La sobreventa ocurre en el borde del stock, no dentro de la clase.],
  [Tabla de decisión y causa-efecto], [CP-ADM-01, CP-CUP-02, CP-VAL-01. El descuento y el agotado combinan varias variables: son reglas, no rangos.],
  [Transición de estados], [CP-CON-02, CP-CUP-02, CP-RNF-01. Idempotencia y propagación dependen del estado previo.],
  [Prueba basada en casos de uso], [CP-CON-01, CP-PED-01, CP-CHK-01. El recorrido invitado sólo falla como secuencia extremo a extremo.],
  text(size: 8.2pt, fill: GRIS)[Caja blanca], text(size: 8.2pt, fill: GRIS)[No aplicada: no tuvimos acceso al código del producto.],
)

// ===================== 4. ALCANCE DEL DISEÑO =====================
= 4. Alcance general del diseño <sec-diseno>

Resumen de los 18 casos diseñados para los once requisitos, con su técnica, su prioridad y el resultado que obtuvieron. Se incluye sólo como contexto: *el detalle de ejecución se desarrolla sobre el módulo de cupones* en la sección 5.

#TBL_TRAZA
#v(3pt)
#nota[Los casos CP-CUP-01 y CP-CUP-02 de esta tabla son los dos casos del módulo de cupones inscritos en el plan general. Al profundizar en el módulo se descompusieron en las once condiciones que se detallan a continuación.]

// ===================== 5. MÓDULO DE CUPONES =====================
= 5. Módulo de cupones de descuento <sec-cupones>

Requisito E-RF04: el campo «Use Coupon Code» del carrito y su efecto sobre los importes. Esta sección recorre el módulo completo: qué hay configurado en el sistema, qué reglas gobiernan la decisión, qué casos se derivan de ellas, qué devolvió el sistema al ejecutarlos, cómo se llega desde el requisito hasta un defecto, qué defectos quedaron abiertos y qué falta para cerrar el módulo.

== 5.1 Configuración encontrada en el sistema <sec-cup-config>
El catálogo tiene *dos cupones*, ambos inutilizables hoy. Esto condiciona todo lo que se puede probar.
#v(3pt)
#T((2.0cm, 3.0cm, 2.2cm, 2.9cm, 2.0cm, 1fr),
  ..hd("Código", "Nombre", "Tipo", "Vigencia", "Estado", "Consecuencia"),
  [*2222*], [-10% Discount], [Porcentaje, 10 %], [01/01/2014 – 01/01/2020], [Disabled],
  [Vencido hace más de 6 años y además deshabilitado],
  [*1111*], [-10.00 Discount], [Monto fijo, 10.00], [01/01/2014 – 01/01/2020], [Disabled],
  [Mismo caso],
)
#v(4pt)
#block(width: 100%, breakable: false, inset: 7pt, radius: 2pt, fill: rgb("#FFF4E5"), stroke: (left: 2.5pt + AMBAR))[
  #text(size: 8.5pt)[*No existe ningún cupón válido en el ambiente.* Por eso el camino positivo —aplicar un descuento real— no se puede ejecutar. Los dos cupones fallan por *dos causas a la vez* (deshabilitado y vencido), así que tampoco se puede aislar cuál de las dos rechaza el sistema.]
]

== 5.2 Tabla de decisión del módulo <sec-cup-decision>
Siete condiciones gobiernan si un cupón se aplica. La tabla enumera cada combinación relevante y la acción que el sistema debe tomar.
#v(3pt)
#T((1.0cm, 1fr, 0.75cm, 0.75cm, 0.75cm, 0.75cm, 0.75cm, 0.75cm, 0.75cm, 4.0cm),
  ..hd("Regla", "Situación", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "Acción esperada"),
  [*R1*], [Cupón válido en carrito elegible], [Sí], [Sí], [Sí], [Sí], [Sí], [Sí], [Sí],
  [Aplica el descuento, agrega la línea «Coupon» y recalcula el total],
  [*R2*], [El código no existe], [No], [–], [–], [–], [–], [–], [–],
  [Rechaza e indica que el código no existe. El total no cambia],
  [*R3*], [Existe pero está deshabilitado], [Sí], [No], [–], [–], [–], [–], [–],
  [Rechaza e indica que el cupón no está activo],
  [*R4*], [Existe pero está fuera de vigencia], [Sí], [Sí], [No], [–], [–], [–], [–],
  [Rechaza e indica que el cupón venció],
  [*R5*], [Alcanzó su límite de usos], [Sí], [Sí], [Sí], [No], [–], [–], [–],
  [Rechaza e indica que se agotaron los usos],
  [*R6*], [El carrito no llega al monto mínimo], [Sí], [Sí], [Sí], [Sí], [No], [–], [–],
  [Rechaza e indica el monto mínimo exigido],
  [*R7*], [Ningún producto del carrito es elegible], [Sí], [Sí], [Sí], [Sí], [Sí], [No], [–],
  [Rechaza, o aplica 0 de descuento sin afectar los productos no elegibles],
  [*R8*], [Se aplica dos veces el mismo cupón], [Sí], [Sí], [Sí], [Sí], [Sí], [Sí], [No],
  [No acumula: el descuento sigue siendo uno solo],
  [*R9*], [El campo se envía vacío o con espacios], [–], [–], [–], [–], [–], [–], [–],
  [Pide un código. No debe informar una eliminación que no ocurrió],
)
#v(3pt)
#nota[C1 el código existe · C2 está habilitado · C3 está dentro de vigencia · C4 le quedan usos · C5 el carrito alcanza el monto mínimo · C6 hay un producto elegible · C7 es la primera aplicación. El guion «–» significa que esa condición ya no influye porque una anterior decidió el resultado.]

#pagebreak(weak: true)
== 5.3 Casos derivados: CUP-01 a CUP-11 <sec-cup-casos>
Un caso por regla; la regla R2 origina tres, porque el rechazo de un código inexistente se prueba también con entradas extremas y con el carrito vacío. Datos fijos para todos: producto *iPod Nano*, una unidad, carrito con Sub-Total 100.00, Eco Tax 2.00, VAT 20.00 y *Total 122.00*.
#v(3pt)
#T((1.7cm, 1.0cm, 1fr, 3.6cm, 2.2cm),
  ..hd("Caso", "Regla", "Entrada", "Resultado esperado", "Técnica"),
  [*CUP-01* <caso-CUP-01>], [R1], [Código de un cupón vigente y aplicable], [El total baja según el tipo de descuento y aparece la línea «Coupon»], [Partición de equivalencia],
  [*CUP-02* <caso-CUP-02>], [R2], [#lit[QA-NO-EXISTE-20260926]], [Rechazo con mensaje propio de «código inexistente»], [Partición de equivalencia],
  [*CUP-03* <caso-CUP-03>], [R3], [#lit[2222] — deshabilitado], [Rechazo con mensaje propio de «cupón inactivo»], [Tabla de decisión],
  [*CUP-04* <caso-CUP-04>], [R4], [#lit[1111] — vencido], [Rechazo con mensaje propio de «cupón vencido»], [Tabla de decisión],
  [*CUP-05* <caso-CUP-05>], [R5], [Cupón con usos agotados], [Rechazo indicando el límite de usos], [Tabla de decisión],
  [*CUP-06* <caso-CUP-06>], [R6], [Cupón con monto mínimo mayor al carrito], [Rechazo indicando el mínimo exigido], [Valores límite],
  [*CUP-07* <caso-CUP-07>], [R7], [Cupón de otra categoría], [Rechazo o descuento 0 sin afectar el total], [Tabla de decisión],
  [*CUP-08* <caso-CUP-08>], [R8], [Mismo cupón válido aplicado dos veces], [Un solo descuento; no se duplica], [Transición de estados],
  [*CUP-09* <caso-CUP-09>], [R9], [Campo vacío y campo con tres espacios], [Pedir un código; no informar eliminación], [Partición de equivalencia],
  [*CUP-10* <caso-CUP-10>], [R2], [Cadena de 300 caracteres y cadena con #lit[\<\>'\"%&=]], [Rechazo controlado, sin error de servidor], [Valores límite],
  [*CUP-11* <caso-CUP-11>], [R2], [Cupón sobre un carrito vacío], [Rechazo controlado], [Partición de equivalencia],
)

== 5.4 Resultados de la ejecución del 26/09/2026 <sec-cup-resultados>
Ejecución manual sobre el sitio público. La columna «Respuesta literal» reproduce el texto exacto que devuelve el sistema.
#v(3pt)
#T((1.6cm, 1fr, 6.5cm, 1.8cm, 1.9cm),
  ..hd("Caso", "Entrada probada", "Respuesta literal del sistema", "Total", "Veredicto"),
  [*CUP-02*], [#lit[QA-NO-EXISTE-20260926]], [#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], [122.00 sin cambio], FALLO,
  [*CUP-03*], [#lit[2222]], [#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], [122.00 sin cambio], FALLO,
  [*CUP-04*], [#lit[1111]], [#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], [122.00 sin cambio], FALLO,
  [*CUP-09*], [Campo vacío], [#lit[Success: Your coupon discount has been removed!]], [122.00 sin cambio], FALLO,
  [*CUP-09*], [Tres espacios], [#lit[Success: Your coupon discount has been removed!]], [122.00 sin cambio], FALLO,
  [*CUP-10*], [300 caracteres], [#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], [122.00 sin cambio], PASO,
  [*CUP-10*], [#lit[\<\>'\"%&=]], [#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], [122.00 sin cambio], PASO,
  [*CUP-11*], [#lit[2222] con carrito vacío], [#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], [Carrito vacío], PASO,
  [*CUP-01*], [Cupón vigente], [No ejecutable: no existe ningún cupón vigente], [—], BLOQ,
  [*CUP-05*], [Usos agotados], [No ejecutable: requiere un cupón vigente con límite], [—], BLOQ,
  [*CUP-06*], [Monto mínimo], [No ejecutable: requiere un cupón vigente con mínimo], [—], BLOQ,
  [*CUP-07*], [Categoría no elegible], [No ejecutable: requiere un cupón vigente por categoría], [—], BLOQ,
  [*CUP-08*], [Aplicación repetida], [No ejecutable: requiere una primera aplicación válida], [—], BLOQ,
)
#v(4pt)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 8pt,
  block(inset: 6pt, radius: 2pt, fill: PALE)[#text(size: 8.5pt)[*3 pasaron* — robustez de entrada]],
  block(inset: 6pt, radius: 2pt, fill: PALE)[#text(size: 8.5pt)[*5 fallaron* — mensajes incorrectos]],
  block(inset: 6pt, radius: 2pt, fill: PALE)[#text(size: 8.5pt)[*5 bloqueados* — falta un cupón vigente]],
)
#v(3pt)
#nota[Ninguna entrada inválida alteró el total ni creó una línea de descuento: el control monetario del camino negativo es correcto. Lo que falla son los mensajes.]

#pagebreak(weak: true)
== 5.5 Ruta del caso: del requisito al veredicto <sec-cup-ruta>
#nota[Dos recorridos de diez etapas sobre el mismo requisito: uno que falló y derivó en defecto, y uno que quedó bloqueado por falta de datos.]
#v(5pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  box(inset: 6pt, radius: 3pt, fill: PALE)[
    #text(size: 9pt, weight: "bold", fill: TINTA)[Recorrido A · CUP-03] #h(4pt) #FALLO
    #linebreak() #nota[Cupón existente pero deshabilitado. Derivó en el hallazgo H-CUP-01.]
  ],
  box(inset: 6pt, radius: 3pt, fill: PALE)[
    #text(size: 9pt, weight: "bold", fill: TINTA)[Recorrido B · CUP-01] #h(4pt) #BLOQ
    #linebreak() #nota[Aplicación de un cupón vigente. No hay ninguno en el ambiente.]
  ]
)
#v(7pt)

=== Recorrido A · CUP-03 — de un requisito a un defecto abierto
#TRUTA(
  ..et(CYAN, 1, [Requisito de origen], [*E-RF04* — el carrito debe aceptar únicamente los cupones aplicables y rechazar los demás indicando la causa del rechazo.]),
  ..et(CYAN, 2, [Riesgo asociado], [*R02 · cupón válido rechazado o descuento incorrecto*, probabilidad Alta e impacto Crítico → prioridad *Alta*. El riesgo es económico directo: un rechazo mal explicado hace que el cliente abandone la compra.]),
  ..et(CYAN, 3, [Condición de prueba], [Regla *R3* de la tabla de decisión: un código que existe pero está deshabilitado debe rechazarse con un mensaje que identifique esa causa concreta, y el total no debe cambiar.]),
  ..et(CYAN, 4, [Técnica elegida y por qué], [*Tabla de decisión*. El resultado depende de siete condiciones combinadas (existencia, habilitación, vigencia, usos, monto mínimo, elegibilidad y primera aplicación), no de un rango de valores. No se eligió partición de equivalencia porque las causas de rechazo no son clases de un mismo campo sino condiciones independientes; no se eligió valores límite porque en esta regla no hay frontera numérica.]),
  ..et(CYAN, 5, [Diseño del caso], [*CUP-03*, regla R3, prioridad Alta, responsable Franco. Resultado esperado: rechazo con mensaje propio de «cupón inactivo», sin línea «Coupon» y sin variación del total.]),
  ..et(CYAN, 6, [Datos y precondiciones], [Producto *iPod Nano*, una unidad. Carrito con Sub-Total 100.00, Eco Tax 2.00, VAT 20.00 y Total 122.00. Código #lit[2222] («-10% Discount», porcentaje 10 %, vigencia 01/01/2014 – 01/01/2020, estado Disabled). Importes de referencia registrados antes de aplicar el cupón.]),
  ..et(CYAN, 7, [Ejecución y veredicto], [26/09/2026. El sistema responde #lit[Warning: Coupon is either invalid, expired or reached its usage limit!] y el total se mantiene en 122.00. El rechazo es correcto, pero el mensaje no identifica la causa esperada por la regla R3. → *Falló*.]),
  ..et(CYAN, 8, [Evidencia], [E-21 (el mensaje tal como lo ve el cliente) y E-20 (el panel con los dos cupones deshabilitados y vencidos, que justifica el dato de entrada). Capturas con fecha e integridad verificada por SHA-256.]),
  ..et(CYAN, 9, [Hallazgo derivado], [*H-CUP-01* — «\[Cupones\] Un solo mensaje para cuatro causas distintas de rechazo». Severidad Media / Prioridad propuesta Alta. La causa raíz no se afirma: no se inspeccionó el código, sólo el comportamiento observable.]),
  ..et(CYAN, 10, [Estado actual], [*Nuevo · reproducido el 26/09/2026.* El caso no puede afinarse más en este ambiente: los dos cupones existentes están a la vez deshabilitados y vencidos, así que R3 y R4 no se pueden separar. Cuando los mensajes se diferencien, CUP-03 se repetirá como prueba de confirmación junto con CUP-02 y CUP-04.]),
)

#v(9pt)
=== Recorrido B · CUP-01 — de un requisito a un bloqueo justificado
#TRUTA(
  ..et(AMBAR, 1, [Requisito de origen], [*E-RF04* — un cupón vigente y aplicable debe descontar el importe correcto, agregar la línea «Coupon» y recalcular el total.]),
  ..et(AMBAR, 2, [Riesgo asociado], [*R02* con el mismo nivel Alto, y *R06 · acumulación indebida de descuentos*. Es el camino positivo: el único que demuestra que el descuento se calcula bien, y por eso el de mayor valor del módulo.]),
  ..et(AMBAR, 3, [Condición de prueba], [Regla *R1* de la tabla de decisión: con las siete condiciones en «Sí», el sistema aplica el descuento y el total baja según el tipo de cupón.]),
  ..et(AMBAR, 4, [Técnica elegida y por qué], [*Partición de equivalencia*. El campo de código admite infinitos valores; se agrupan en una clase válida y varias inválidas, y aquí se prueba un representante de la clase válida. No se eligió tabla de decisión porque en R1 todas las condiciones valen «Sí» y no hay combinación que analizar.]),
  ..et(AMBAR, 5, [Diseño del caso], [*CUP-01*, regla R1, prioridad Alta, responsable Franco. Resultado esperado: aparece la línea «Coupon» con el importe descontado y el total general se recalcula en consecuencia.]),
  ..et(AMBAR, 6, [Datos y precondiciones], [Mismos importes de partida: iPod Nano, una unidad, Total 122.00. Precondición explícita: *un cupón habilitado y dentro de vigencia*. El catálogo sólo ofrece #lit[2222] y #lit[1111], ambos con estado Disabled y vigencia terminada el 01/01/2020.]),
  ..et(AMBAR, 7, [Ejecución y veredicto], [26/09/2026. La precondición no se cumple, de modo que no hay nada que aplicar. → *Bloqueado*, nunca *Falló*: el sistema no llegó a comportarse frente a la regla R1 y no existe comportamiento que juzgar.]),
  ..et(AMBAR, 8, [Evidencia], [E-20 — el listado de cupones del panel, donde se lee el estado Disabled y la vigencia vencida de los dos registros. El ambiente no fue alterado; no se requirió restaurar datos.]),
  ..et(AMBAR, 9, [Hallazgo derivado], [*Ninguno.* La carencia es del ambiente de prueba, no del producto, y convertirla en defecto inflaría el conteo. Se registra como impedimento de datos y se traslada al responsable del ambiente, no al equipo de desarrollo.]),
  ..et(AMBAR, 10, [Estado actual], [*Bloqueado por falta de datos.* Cuenta en la tasa de bloqueo del módulo, calculada sobre los casos diseñados, y nunca en la tasa de aprobación. Con un solo cupón habilitado y vigente se desbloquean CUP-01 y CUP-08.]),
)

#v(8pt)
#block(width: 100%, breakable: false, inset: 7pt, radius: 3pt, fill: PALE, stroke: (left: 2.5pt + CYAN))[
  #text(size: 9pt, weight: "bold", fill: TINTA)[Qué demuestra la comparación de ambos recorridos]
  #v(3pt)
  #text(size: 8.5pt)[Los dos casos nacen del mismo requisito, reciben una prioridad derivada del riesgo, se les asigna una técnica justificada por la naturaleza del problema y se ejecutan con datos y precondiciones declarados. La diferencia aparece en la etapa 7: CUP-03 obtuvo un comportamiento distinto al esperado y por eso *falló* y generó un defecto; CUP-01 no obtuvo comportamiento alguno y por eso quedó *bloqueado* y no generó ninguno. Distinguirlos es lo que permite saber qué le corresponde corregir al equipo de desarrollo y qué le corresponde habilitar al responsable del ambiente.]
]

#v(9pt)
== 5.6 Hallazgos del módulo <sec-cup-hallazgos>

#ficha(ROJO, [H-CUP-01 · \[Cupones\] Un solo mensaje para cuatro causas distintas de rechazo])[
  #text(size: 8.8pt)[*Qué pasa.* El sistema responde siempre #lit[Warning: Coupon is either invalid, expired or reached its usage limit!], sin importar si el código no existe, está deshabilitado, venció o agotó sus usos.]
  #v(2pt)
  #text(size: 8.8pt)[*Cómo reproducir.* Agregar iPod Nano al carrito. Aplicar #lit[QA-NO-EXISTE-20260926] (no existe), luego #lit[2222] (deshabilitado) y luego #lit[1111] (vencido). Los tres devuelven el mismo texto.]
  #v(2pt)
  #text(size: 8.8pt)[*Por qué importa.* El cliente no sabe si se equivocó al escribir o si la promoción ya terminó, y tiende a abandonar la compra. Soporte tampoco puede diagnosticar sin entrar al panel. Es la diferencia entre «revisa el código» y «esta promoción venció el 1 de enero».]
  #v(2pt)
  #text(size: 8.8pt)[*Sugerencia.* Mensajes distintos por causa; el código de error puede ser interno y el texto al cliente, específico.]
  #v(3pt)
  #grid(columns: (auto, auto, auto, auto, 1fr), column-gutter: 12pt,
    text(size: 8.3pt)[*Severidad:* Media], text(size: 8.3pt)[*Prioridad propuesta:* Alta],
    text(size: 8.3pt)[*Estado:* Nuevo], text(size: 8.3pt)[*Reglas:* R2, R3, R4, R5],
    text(size: 8.3pt)[*Casos:* CUP-02, CUP-03, CUP-04 · *Evidencia:* E-21, E-23])
] <hall-H-CUP-01>
#v(7pt)
#ficha(ROJO, [H-CUP-02 · \[Cupones\] El campo vacío responde «Success» aunque no había ningún cupón aplicado])[
  #text(size: 8.8pt)[*Qué pasa.* Enviar el campo vacío, o con solo espacios, devuelve #lit[Success: Your coupon discount has been removed!] pese a que no existía ningún descuento que eliminar.]
  #v(2pt)
  #text(size: 8.8pt)[*Cómo reproducir.* Con un carrito sin cupón aplicado, pulsar «Apply Coupon» dejando el campo vacío. Repetir escribiendo tres espacios.]
  #v(2pt)
  #text(size: 8.8pt)[*Por qué importa.* Un mensaje de éxito ante una acción que no ocurrió enseña al usuario a desconfiar de los mensajes. Además revela que la entrada no se valida ni se recorta: los espacios no se eliminan antes de procesar.]
  #v(2pt)
  #text(size: 8.8pt)[*Sugerencia.* Validar que el campo no esté vacío tras recortar espacios, y reservar el mensaje de eliminación para cuando realmente había un cupón aplicado.]
  #v(3pt)
  #grid(columns: (auto, auto, auto, auto, 1fr), column-gutter: 12pt,
    text(size: 8.3pt)[*Severidad:* Baja], text(size: 8.3pt)[*Prioridad propuesta:* Media],
    text(size: 8.3pt)[*Estado:* Nuevo], text(size: 8.3pt)[*Regla:* R9],
    text(size: 8.3pt)[*Caso:* CUP-09 · *Evidencia:* E-22])
] <hall-H-CUP-02>
#v(7pt)
#ficha(VERDE, [C-CUP-01 · Confirmación: ninguna entrada inválida altera los importes])[
  #text(size: 8.8pt)[Con ocho entradas distintas —inexistente, deshabilitado, vencido, vacío, espacios, 300 caracteres, caracteres especiales y carrito vacío— el total se mantuvo en 122.00 y nunca apareció una línea de descuento. El módulo no crea descuentos fantasma, que es el riesgo económico principal. Tampoco se produjo ningún error de servidor.]
  #v(3pt)
  #grid(columns: (auto, auto, 1fr), column-gutter: 12pt,
    text(size: 8.3pt)[*Severidad:* Informativa], text(size: 8.3pt)[*Prioridad propuesta:* Baja],
    text(size: 8.3pt)[*Casos:* CUP-02, CUP-03, CUP-04, CUP-09, CUP-10, CUP-11 · *Evidencia:* E-20, E-24])
] <hall-C-CUP-01>

== 5.7 Qué falta para cerrar el módulo <sec-cup-pendiente>
Cinco reglas de la tabla de decisión no se pueden verificar hoy. No es una omisión del equipo de pruebas: el ambiente no tiene con qué probarlas.
#v(3pt)
#T((1.0cm, 2.4cm, 1fr, 1fr),
  ..hd("Regla", "Caso", "Qué falta verificar", "Qué se necesita en el ambiente"),
  [R1], [CUP-01], [Que un cupón válido aplique el descuento correcto], [Un cupón habilitado y vigente, de tipo porcentaje y otro de monto fijo],
  [R5], [CUP-05], [Que el límite de usos bloquee la aplicación], [Un cupón con límite bajo, por ejemplo un uso],
  [R6], [CUP-06], [Que el monto mínimo se respete], [Un cupón con monto mínimo declarado],
  [R7], [CUP-07], [Que la restricción por categoría funcione], [Un cupón restringido a una categoría concreta],
  [R8], [CUP-08], [Que el mismo cupón no se acumule], [Cualquier cupón válido, para aplicarlo dos veces],
)
#v(3pt)
#nota[Con un solo cupón de prueba habilitado se desbloquean R1 y R8. Con tres cupones configurados —uno con límite de usos, uno con monto mínimo y uno por categoría— se cierra el módulo completo.]

// ===================== 6. OTROS HALLAZGOS =====================
= 6. Otros hallazgos fuera del foco <sec-otros>

Fuera del módulo de cupones quedaron dos defectos abiertos. Se documentan aquí para dejar constancia de que existen y de que tienen evidencia registrada, pero *no se desarrollan en este informe*, que se concentra en E-RF04.

#v(3pt)
#block(width: 100%, breakable: false, inset: 7pt, radius: 2pt, fill: PALE, stroke: (left: 3pt + ROJO))[
  #text(size: 9pt, weight: "bold", fill: TINTA)[DEF-01 · \[Carrito\] El total de línea no corresponde al unitario por cantidad] <hall-DEF-01>
  #v(2pt)
  #text(size: 8.6pt)[Con dos unidades de iPod Nano el unitario es 122.00 y la línea muestra 242.00, mientras el total general queda en 244.00 (Sub-Total 200.00 + Eco Tax 4.00 + VAT 40.00). Severidad Alta / Prioridad propuesta Alta; trazado desde E-RF03 y evidenciado en E-03 y E-04.]
]
#v(5pt)
#block(width: 100%, breakable: false, inset: 7pt, radius: 2pt, fill: PALE, stroke: (left: 3pt + ROJO))[
  #text(size: 9pt, weight: "bold", fill: TINTA)[DEF-04 · \[Checkout\] No se ofrece método de pago seleccionable en el recorrido de invitado] <hall-DEF-04>
  #v(2pt)
  #text(size: 8.6pt)[El checkout responde «No Payment options are available. Please contact us for assistance!» y el botón Confirm Order queda deshabilitado, de modo que la compra no se puede completar. Severidad Crítica para el recorrido ensayado / Prioridad propuesta Alta; trazado desde E-RF05 y evidenciado en E-19.]
]
#v(4pt)
#nota[Ambos defectos bloquean además la cadena de confirmación, pedidos y propagación al panel, tal como se refleja en la tabla de trazabilidad de la sección 4.]

// ===================== 7. CRITERIOS Y MÉTRICAS =====================
= 7. Criterios de salida y métricas del módulo de cupones <sec-metricas>
#nota[Criterios declarados antes que las cifras.]

== 7.1 Criterios de entrada y salida por fase (declarados antes de la ejecución) <sec-criterios>
#T((3.1cm, 1fr, 1fr),
  ..hd("Fase / nivel", "Criterio de entrada", "Criterio de salida"),
  [Análisis y diseño], [Base versionada; 11 requisitos identificados], [26 condiciones trazadas; 18 casos completos],
  [Diseño del módulo], [Configuración de cupones leída en el panel], [Las 9 reglas de la tabla de decisión con al menos un caso asignado],
  [Sistema], [Demo accesible; carrito con importes de referencia registrados], [Cada caso con veredicto o bloqueo documentado y respuesta literal registrada],
  [Aceptación], [Resultados del nivel sistema], [No se afirma calidad del módulo mientras el camino positivo no se haya verificado],
  [Suspensión], [—], [Pérdida de sesión, cambio de fixture o precondición ausente: suspender el caso y continuar los independientes],
  [Reanudación], [Acceso normal, cupón de prueba disponible, fixture revalidado], [Nueva corrida registrada sin sobrescribir la evidencia previa],
)

== 7.2 Estado frente a los criterios de salida
#T((4.8cm, 2.2cm, 1fr),
  ..hd("Criterio", "Estado", "Sustento"),
  [Diseño y registro del módulo], chip("Cumplido", VERDE), [Las 9 reglas están modeladas, los 11 casos están completos y las 8 ejecuciones quedaron registradas con su respuesta literal y su evidencia.],
  [Cobertura del camino positivo], chip("No cumplido", ROJO), [La regla R1 no se verificó: no existe ningún cupón habilitado y vigente en el ambiente. Con ella quedan sin verificar R5, R6, R7 y R8.],
  [Afirmación de calidad del módulo], chip("No cumplido", ROJO), [H-CUP-01 y H-CUP-02 siguen abiertos y 5 de las 9 reglas no tienen verificación, de modo que el módulo no puede declararse correcto.],
)

== 7.3 Métricas del módulo con sus denominadores
#T((4.8cm, 3.2cm, 1fr),
  ..hd("Métrica", "Cálculo", "Lectura"),
  [Casos diseñados], [11 casos para 9 reglas], [Un caso por regla; la regla R2 concentra tres (CUP-02, CUP-10 y CUP-11) por tratarse del rechazo más frecuente.],
  [Casos ejecutados], [6 / 11 = 54.5 %], [CUP-02, CUP-03, CUP-04, CUP-09, CUP-10 y CUP-11. Los otros cinco no tenían precondición disponible.],
  [Ejecuciones registradas], [8 ejecuciones], [CUP-09 y CUP-10 se probaron con dos entradas cada uno, y cada entrada se registró por separado con su respuesta literal.],
  [Ejecuciones que pasaron], [3 / 8 = 37.5 %], [Las tres son de robustez de entrada: 300 caracteres, caracteres especiales y carrito vacío.],
  [Ejecuciones que fallaron], [5 / 8 = 62.5 %], [Todas fallan por el mensaje devuelto, ninguna por el importe cobrado.],
  [Casos bloqueados], [5 / 11 = 45.5 %], [CUP-01, CUP-05, CUP-06, CUP-07 y CUP-08. El bloqueo es de datos del ambiente, no del producto.],
  [Cobertura de reglas], [4 / 9 = 44.4 %], [Verificadas R2, R3, R4 y R9. Sin verificar R1, R5, R6, R7 y R8, que son las que exigen un cupón válido.],
  [Control de importes], [8 / 8 = 100 %], [En las ocho ejecuciones el total se mantuvo en 122.00 y no apareció ninguna línea de descuento indebida.],
  [Hallazgos del módulo], [2 abiertos + 1 confirmación], [H-CUP-01 (Media) y H-CUP-02 (Baja) abiertos; C-CUP-01 confirma el control monetario.],
)
#v(3pt)
#nota[Las tasas de aprobación y de fallo se calculan sobre las 8 ejecuciones registradas, no sobre los 11 casos diseñados: usar el total planificado como denominador daría una cifra engañosa, porque los 5 bloqueados nunca produjeron un veredicto. La tasa de bloqueo sí se calcula sobre los 11 diseñados, que es el universo planificado.]

// ===================== 8. CIERRE =====================
= 8. Cierre y automatización <sec-cierre>

== 8.1 Conclusión
#T((1fr,),
  ..hd("Conclusión del módulo de cupones"),
  [El módulo protege correctamente el dinero: en las ocho ejecuciones registradas ninguna entrada inválida modificó el total ni creó una línea de descuento, y ninguna provocó un error de servidor. Lo que no funciona es la comunicación del rechazo. Cuatro causas distintas —código inexistente, cupón deshabilitado, cupón vencido y límite de usos agotado— comparten un único mensaje, y el envío del campo vacío informa un éxito que no ocurrió. Son H-CUP-01 y H-CUP-02, ambos abiertos. El camino positivo no se pudo evaluar: el ambiente no tiene ningún cupón habilitado y vigente, de modo que cinco de las nueve reglas quedaron sin verificar y el módulo no puede declararse correcto. La primera acción no es corregir código, sino configurar cupones de prueba; con ellos se reejecutan los cinco casos bloqueados y se repiten CUP-02, CUP-03 y CUP-04 como prueba de confirmación en cuanto los mensajes se diferencien, junto con las pruebas de regresión del carrito y el checkout, que comparten precondiciones.],
)

== 8.2 Recomendaciones de automatización para el módulo de cupones
#T((3.4cm, 4.8cm, 1fr),
  ..hd("Casos", "Recomendación para el Proyecto 2", "Sustento observado"),
  [CUP-02, CUP-03, CUP-04], [Automatizar como una suite de rechazo con una aserción por causa.], [Hoy las tres entradas devuelven el mismo texto. En cuanto los mensajes se separen, la suite detecta cualquier regresión que vuelva a unificarlos.],
  [CUP-09], [Automatizar el envío del campo vacío y del campo con espacios.], [Es determinista y barato de ejecutar. La aserción debe exigir un mensaje de validación, no el «Success» que hoy devuelve.],
  [CUP-10, CUP-11], [Automatizar como prueba de robustez del campo de código.], [Los 300 caracteres, los caracteres especiales y el carrito vacío ya se rechazan de forma controlada: sirven como red de seguridad frente a cambios de validación.],
  [CUP-01, CUP-08], [Automatizar el camino positivo con cupones creados y eliminados por el propio guion.], [Requieren un cupón habilitado y vigente. Sobre el ambiente actual la automatización sólo produciría bloqueos repetidos.],
  [CUP-05, CUP-06, CUP-07], [Diseñar ahora e implementar cuando existan los cupones de límite, mínimo y categoría.], [Sin esos datos no hay resultado esperado contra el cual comparar, y el guion no podría emitir un veredicto.],
  [Aserción transversal], [Comprobar en todos los casos que el total no cambia ante un rechazo.], [Las ocho ejecuciones mantuvieron el total en 122.00; es la aserción de mayor valor económico y la más barata de mantener.],
)
#v(3pt)
#nota[Se mantiene manual la revisión de la claridad de los mensajes, porque exige interpretar qué entiende un cliente y no puede reducirse a una comparación de cadenas. El diseño de automatización no se entrega como si ya estuviera implementado. Todo el testware queda archivado bajo Gestión de la Configuración con su manifiesto SHA-256.]

// ===================== 9. ANEXO =====================
= 9. Anexo · Evidencias <sec-anexo>

Índice completo de las capturas registradas durante el proyecto y, a continuación, las cinco evidencias del módulo de cupones ampliadas.
#v(4pt)
#block(width: 100%, breakable: false, inset: 7pt, radius: 2pt, fill: PALE, stroke: (left: 2.5pt + CYAN))[
  #text(size: 8.6pt)[*Método de registro.* Cada ejecución guarda la entrada probada, la respuesta literal del sistema y el total resultante. Las capturas conservan la fecha de toma y su integridad se verifica con una huella SHA-256 incluida en el inventario de evidencias.]
]

#set page(margin: (x: 3.2cm, top: 2cm, bottom: 2cm))
== 9.1 Índice de evidencias

#TBL_INDICE_EV

== 9.2 Capturas del módulo de cupones

#figure(image("ev/CP-CUP-01_cupones-no-vigentes_20260925.png", width: 85%),
  caption: text(size: 8.2pt)[*E-20* · Panel de cupones del sistema. Todos los registros aparecen con estado Disabled y con la vigencia terminada el 01/01/2020, de modo que no hay ningún cupón aplicable. Es la evidencia que justifica el bloqueo de CUP-01, CUP-05, CUP-06, CUP-07 y CUP-08.]) <ev-20>
#v(7pt)
#figure(image("ev/CP-CUP-02_error-visible_20260925.png", width: 85%),
  caption: text(size: 8.2pt)[*E-21* · El aviso de rechazo tal como lo ve el cliente en el carrito. Demuestra que el mensaje es visible, pero también que no dice cuál de las causas provocó el rechazo: es el punto de partida de H-CUP-01.]) <ev-21>
#v(7pt)
#figure(image("ev/CP-CUP-02_inexistente_20260925.png", width: 85%),
  caption: text(size: 8.2pt)[*E-22* · La entrada probada en CUP-02: el código inexistente escrito en el campo «Use Coupon Code» justo antes de pulsar «Apply Coupon». Documenta el dato exacto con el que se ejecutó el caso.]) <ev-22>
#v(7pt)
#figure(image("ev/CP-CUP-02_vencido-error_20260925.png", width: 85%),
  caption: text(size: 8.2pt)[*E-23* · Rechazo de un cupón que sí existe en el sistema, el código #lit[2222]. La causa es distinta a la de E-21 y el texto devuelto es exactamente el mismo: es la evidencia directa de H-CUP-01.]) <ev-23>
#v(7pt)
#figure(image("ev/CP-CUP-02_vencido_20260925.png", width: 85%),
  caption: text(size: 8.2pt)[*E-24* · El código #lit[2222] cargado en el campo inmediatamente antes de aplicarlo. Junto con E-23 documenta la secuencia completa del caso —entrada exacta y respuesta del sistema— y sostiene la confirmación C-CUP-01: tras el rechazo no se añadió ninguna línea de descuento.]) <ev-24>

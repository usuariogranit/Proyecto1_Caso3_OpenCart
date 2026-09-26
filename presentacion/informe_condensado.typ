#import "_tablas.typ": *
#import "_anexo.typ": *
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
#let chip(t, c) = box(inset: (x: 4pt, y: 1.5pt), radius: 2.5pt, fill: c.lighten(86%),
  stroke: 0.5pt + c, text(size: 8pt, weight: "bold", fill: c)[#t])
#let ALTA = chip("Alta", ROJO)
#let MEDIA = chip("Media", AMBAR)
#let BAJA = chip("Baja", GRIS)
#let PASO = chip("Pasó", VERDE)
#let FALLO = chip("Falló", ROJO)
#let BLOQ = chip("Bloqueado", AMBAR)

#let hd(..c) = c.pos().map(x => text(size: 8.2pt, weight: "bold", fill: TINTA)[#x])
#let T(cols, ..cuerpo) = table(
  columns: cols, stroke: 0.4pt + LINEA, inset: (x: 4pt, y: 3pt),
  fill: (_, y) => if y == 0 { PALE },
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

// ===================== 1. PORTADA =====================
#image("banner_utec.png", width: 100%, height: 2.4cm, fit: "cover")
#v(8pt)
#text(size: 20pt, weight: "bold", fill: black)[Informe de pruebas] <sec-portada>
#v(1pt)
#text(size: 12pt, fill: GRIS)[Caso 3 — OpenCart Demo 4.0.2.3 · Grupo 5]
#v(4pt)
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
  [Marco de referencia], [ISTQB CTFL v4.0.1; estructura del plan según ISO/IEC/IEEE 29119-3], [Gestión de la Configuración], [ID único, versión y registro de cambios por elemento del testware; evidencias con SHA-256 en #raw("manifest_integrado.json")],
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
#nota[Aprobación sobre casos concluyentes; bloqueo sobre planificados.]

#pagebreak()

// ===================== 2. PLAN =====================
= 2. Plan de pruebas — ISO/IEC/IEEE 29119-3 <sec-plan>

== 2.1 Identificación · 2.2 Contexto
#T((3.2cm, 1fr),
  ..hd("Sección", "Contenido compactado"),
  [1 Identificación], [PP-G5-C3-v1.0 · v1.0 · Franco y Granit · aprobación docente · testware bajo Gestión de la Configuración con SHA-256.],
  [2 Contexto], [Ronda de pruebas manuales del flujo comercial del demo y su reflejo en el panel. Referencias: enunciado del Caso 3, #raw("Proyecto1_Caso3_Grupo5.pdf"), #raw("EJECUCION_INTEGRADA_20260925.md").],
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
  [Cupones y opciones disponibles], [Los 3 cupones leídos estaban vencidos o deshabilitados],
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
    [Plan de pruebas · registro de riesgos · 26 condiciones · 18 casos · registro de ejecución de los 14 Alta · hallazgos con evidencia · informe de finalización · manifiesto SHA-256.],
  ),
  T((2.6cm, 1fr),
    ..hd("Sub-proceso", "Tareas"),
    [Planificación], [Analizar el caso; valorar riesgos; priorizar requisitos; estimar 24 h; definir criterios],
    [Diseño e impl.], [Derivar 26 condiciones; escribir 18 casos con técnica declarada; preparar fixtures],
    [Ejecución], [Verificar precondiciones; ejecutar los 14 Alta; registrar veredicto y evidencia; reportar hallazgos],
    [Cierre], [Consolidar métricas con contexto; declarar riesgo residual; archivar el testware bajo Gestión de la Configuración],
  ),
)

== 2.9 Entorno y datos · 2.10 Responsabilidades · 2.11 Cronograma
#grid(columns: (1fr, 1fr), column-gutter: 8pt,
  T((2.5cm, 1fr),
    ..hd("Necesidad", "Detalle"),
    [Software], [OpenCart Demo 4.0.2.3, sitio público y panel],
    [Hardware / red], [PC Windows, navegador de escritorio, red sin instrumentación],
    [Herramientas], [Capturas PNG, registro JSON, manifiesto SHA-256],
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
      [25/09/2026], [Cierre: métricas, hallazgos y estado frente a criterios de salida],
      [Tras habilitar el ambiente], [Reejecución de bloqueados, prueba de confirmación de DEF-01 y pruebas de regresión],
    )
  ],
)
#v(3pt)
#nota[Comunicación: coordinación diaria y repositorio compartido del testware. Todo bloqueo de permisos o datos se documenta en el registro y se eleva a la docente.]

#pagebreak()

// ===================== 3. ANÁLISIS =====================
= 3. Análisis: priorización de requisitos por riesgo <sec-analisis>
#nota[Prioridad derivada de la exposición al riesgo, no del esfuerzo de prueba.]
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

== 3.1 Técnicas de diseño y su origen en el curso <sec-tecnicas>
#T((4.4cm, 2.6cm, 1fr),
  ..hd("Técnica", "Material", "Casos y por qué esa y no otra"),
  [Partición de equivalencia], [Clase 5 · guía G5], [CP-CAT-01/02/03, CP-PRO-01/02, CP-CAR-01/02, CP-CUP-01, CP-CHK-01, CP-RNF-02. Cantidad y código agrupan clases válidas e inválidas; enumerar valores sería redundante.],
  [Análisis de valores límite], [Clase 5 · guía G1], [CP-CAR-02 (S = 147 y S+1 = 148). La sobreventa ocurre en el borde del stock, no dentro de la clase.],
  [Tabla de decisión y causa-efecto], [Clase 5 · guía G2], [CP-ADM-01, CP-CUP-02, CP-VAL-01. El descuento y el agotado combinan varias variables: son reglas, no rangos.],
  [Transición de estados], [Clase 5 · guía G3], [CP-CON-02, CP-CUP-02, CP-RNF-01. Idempotencia y propagación dependen del estado previo.],
  [Prueba basada en casos de uso], [Clase 5 · guía G4], [CP-CON-01, CP-PED-01, CP-CHK-01. El recorrido invitado sólo falla como secuencia extremo a extremo.],
  text(size: 8.2pt, fill: GRIS)[Caja blanca], text(size: 8.2pt, fill: GRIS)[Clase 6], text(size: 8.2pt, fill: GRIS)[No aplicada: sin acceso al código del producto.],
)

// ===================== 4. DISEÑO =====================
= 4. Diseño: matriz de los 18 casos <sec-diseno>

Primero los 14 de prioridad Alta.

#page(flipped: true)[
  #TBL_DISENO_ALTA

  == 4.1 Casos de prioridad Media (diseñados, no ejecutados) <sec-diseno-media>

  #TBL_DISENO_MEDIA
]

= 5. Ruta del caso: dos recorridos de extremo a extremo <sec-ruta>
#nota[Dos casos: uno que falló y derivó en defecto, y uno bloqueado.]
#v(5pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  box(inset: 6pt, radius: 3pt, fill: PALE)[
    #text(size: 9pt, weight: "bold", fill: TINTA)[Caso A · CP-CAR-01] #h(4pt) #FALLO
    #linebreak() #nota[Actualización de cantidad válida en el carrito. Derivó en el defecto DEF-01.]
  ],
  box(inset: 6pt, radius: 3pt, fill: PALE)[
    #text(size: 9pt, weight: "bold", fill: TINTA)[Caso B · CP-ADM-01] #h(4pt) #BLOQ
    #linebreak() #nota[Producto agotado en panel reflejado públicamente. No derivó en defecto.]
  ]
)
#v(7pt)

== Caso A · CP-CAR-01 — de un requisito a un defecto abierto
#etapa(1)[Requisito de origen][*E-RF03* — el carrito debe recalcular los importes al cambiar la cantidad. Base de pruebas derivada del enunciado del Caso 3.]
#etapa(2)[Riesgo asociado][*R03 · riesgo monetario.* Probabilidad 3 × Impacto 3 = *9* → prioridad *Alta*. El riesgo fija la profundidad: es el requisito con más casos del proyecto, tres.]
#etapa(3)[Condición de prueba][*CT-CAR-01* — una cantidad válida recalcula línea, subtotal, impuestos y total de forma coherente. Describe *qué* comprobar, no cómo.]
#etapa(4)[Técnica elegida y por qué][*Partición de equivalencia* — Clase 5, guía G5. El campo cantidad admite infinitos valores; se agrupan en clases que el sistema debe tratar igual y se prueba un representante de la clase válida. No se eligió tabla de decisión porque no hay variables combinadas, ni transición de estados porque no hay cambio de estado del pedido.]
#etapa(5)[Diseño del caso][*CP-CAR-01*, prioridad Alta, responsable Franco. Oráculo declarado: el total de línea debe ser igual al precio unitario multiplicado por la cantidad, bajo la misma base fiscal.]
#etapa(6)[Datos y precondiciones][Producto apto sin opciones obligatorias: *iPod Nano* (product_id 36). Carrito limpio. Cantidades *1* y *2*. Precio unitario mostrado 122.00 USD. Importes de referencia registrados antes de actualizar.]
#etapa(7)[Ejecución y veredicto][25/09/2026. Con 1 unidad: precio y línea coinciden en 122.00. Con 2 unidades: unitario 122.00, *línea 242.00*, *total general 244.00*. Desglose: Sub-Total 200.00 + Eco Tax 4.00 + VAT 40.00 = 244.00. → *Falló*.]
#etapa(8)[Evidencia][#raw("CP-CAR-01_qty1_20260925.png") y #raw("CP-CAR-01_qty2_20260925.png"). Hora y URL en #raw("registro.json"); integridad por SHA-256 en #raw("manifest_integrado.json").]
#etapa(9)[Hallazgo derivado][*DEF-01* — «\[Carrito\] El total de línea no coincide con el total a pagar al aumentar la cantidad de una a dos unidades». Severidad Alta / Prioridad propuesta Alta. La causa raíz *no* se afirma: el Eco Tax es hipótesis, no se inspeccionó código.]
#etapa(10, ultimo: true)[Estado actual][*Abierto · reproducido el 25/09/2026.* Al existir corrección pasará a «Listo para reprueba»: se repetirá CP-CAR-01 como *prueba de confirmación* y se aplicarán *pruebas de regresión* sobre carrito y checkout, que comparten precondiciones.]

#v(9pt)
== Caso B · CP-ADM-01 — de un requisito a un bloqueo justificado
#v(5pt)
#etapa(1, color: AMBAR)[Requisito de origen][*E-RF08* — al marcar un producto como agotado en el panel, el sitio público debe reflejar esa condición.]
#etapa(2, color: AMBAR)[Riesgo asociado][*R01 venta sin inventario real* y *R05 inconsistencia sitio–panel*, ambos de nivel *Alto*. Es la queja de negocio que originó el Caso 3.]
#etapa(3, color: AMBAR)[Condición de prueba][*CT-ADM-01* — el stock cero guardado y el estado agotado se reflejan en la interfaz pública.]
#etapa(4, color: AMBAR)[Técnica elegida y por qué][*Tabla de decisión* — Clase 5, guía G2. El comportamiento depende de tres variables combinadas —cantidad, estado publicado y política de venta sin inventario (#raw("Stock Checkout"))—, y sólo una tabla obliga a enunciar la acción esperada de cada combinación. Se definieron cuatro reglas, R1 a R4.]
#etapa(5, color: AMBAR)[Diseño del caso][*CP-ADM-01*, prioridad Alta, responsable Granit. Precondición explícita: sesión autenticada *con permiso de escritura* en Catalog > Products.]
#etapa(6, color: AMBAR)[Datos y precondiciones][*HP LP3065* (product_id 47). Estado previo verificado: #raw("Quantity = 1000"), #raw("Out Of Stock Status = Out Of Stock"), #raw("Subtract Stock") activo. Cambio previsto: cantidad a 0.]
#etapa(7, color: AMBAR)[Ejecución y veredicto][24/09/2026, 02:45. Al guardar, el panel responde: *«Warning: You do not have permission to modify products!»*. El valor no se persiste. → *Bloqueado*, nunca *Fallido*: el sistema no llegó a comportarse frente al requisito.]
#etapa(8, color: AMBAR)[Evidencia][#raw("CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png"), con hora y hash SHA-256. El ambiente no fue alterado; no se requirió restaurar datos.]
#etapa(9, color: AMBAR)[Hallazgo derivado][*Ninguno.* La restricción es del ambiente público de prueba, no del producto, y convertirla en defecto inflaría el conteo. Se registra en la bitácora de ambiente, no en el reporte de defectos.]
#etapa(10, ultimo: true, color: AMBAR)[Estado actual][*Bloqueado por impedimento externo.* Se reejecutará en una instancia controlada con permisos de escritura. Mientras tanto cuenta en la *tasa de bloqueo*, calculada sobre los casos planificados, y nunca en la tasa de aprobación.]

#v(9pt)
#block(width: 100%, inset: 7pt, radius: 3pt, fill: PALE, stroke: (left: 2.5pt + CYAN))[
  #text(size: 9pt, weight: "bold", fill: TINTA)[Qué demuestra la comparación de ambos recorridos]
  #v(3pt)
  #text(size: 8.5pt)[Los dos casos nacen de un requisito, reciben una prioridad derivada del riesgo, se les asigna una técnica del curso justificada por la naturaleza del problema, y se ejecutan con datos y precondiciones declarados. La diferencia aparece en la etapa 7: *CP-CAR-01* obtuvo un comportamiento observable contrario al oráculo y por eso *falló* y generó un defecto; *CP-ADM-01* no obtuvo comportamiento alguno y por eso quedó *bloqueado* y no generó ninguno. Distinguirlos es lo que permite saber qué le corresponde corregir al equipo de desarrollo y qué le corresponde habilitar al responsable del ambiente.]
]

#v(7pt)
#block(width: 100%, inset: 7pt, radius: 3pt, fill: white, stroke: 0.6pt + LINEA)[
  #text(size: 9pt, weight: "bold", fill: TINTA)[Técnicas aplicadas y su origen en el curso]
  #v(4pt)
  #T((4.6cm, 3.2cm, 1fr),
    ..hd("Técnica", "Material del curso", "Casos donde se aplicó"),
    [Partición de equivalencia], [Clase 5 · guía G5], [CP-CAT-01/02/03, CP-PRO-01/02, CP-CAR-01/02, CP-CUP-01, CP-CHK-01, CP-RNF-02],
    [Análisis de valores límite], [Clase 5 · guía G1], [CP-CAR-02 (stock S = 147 y S+1 = 148)],
    [Tabla de decisión y causa-efecto], [Clase 5 · guía G2], [CP-ADM-01, CP-CUP-02, CP-VAL-01],
    [Transición de estados], [Clase 5 · guía G3], [CP-CON-02, CP-CUP-02, CP-RNF-01],
    [Prueba basada en casos de uso], [Clase 5 · guía G4], [CP-CON-01, CP-PED-01],
    text(size: 8.2pt, fill: GRIS)[Caja blanca], text(size: 8.2pt, fill: GRIS)[Clase 6], text(size: 8.2pt, fill: GRIS)[No aplicada: sin acceso al código del producto],
  )
  #v(4pt)
  #nota[Marco de referencia: ISTQB CTFL v4.0.1. Proceso de pruebas según Clase 2; niveles y tipos según Clase 3; revisión estática de requisitos, casos y evidencias según Clase 4; métricas, criterios de salida y ciclo de vida del defecto según Clase 7.]
]

#pagebreak()

// ===================== 6. EJECUCIÓN =====================
= 6. Ejecución de los 14 casos de prioridad Alta <sec-ejecucion>

Orden: fallaron, pasaron, bloqueados.

#TBL_EJECUCION

= 7. Hallazgos <sec-hallazgos>

Orden: Crítica, Alta, Media, Informativa. #page(flipped: true)[
  #TBL_HALLAZGOS
]

= 8. Criterios de salida y métricas <sec-metricas>
#nota[Criterios declarados antes que las cifras.]

== 8.1 Criterios de entrada y salida por fase (declarados antes de la ejecución) <sec-criterios>
#T((3.1cm, 1fr, 1fr),
  ..hd("Fase / nivel", "Criterio de entrada", "Criterio de salida"),
  [Análisis y diseño], [Base versionada; 11 requisitos identificados], [26 condiciones trazadas; 18 casos completos],
  [Integración], [Carrito controlado; acceso al panel], [Discrepancias registradas o declaradas bloqueadas],
  [Sistema], [Demo accesible; datos ficticios; evidencia con fecha y URL], [14 casos Alta con veredicto o bloqueo documentado],
  [Aceptación], [Resultados del nivel sistema], [No se afirma calidad con fallos monetarios o de checkout y riesgos Altos sin verificar],
  [Suspensión], [—], [Pérdida de sesión, cambio de fixture, permiso o precondición ausente: suspender el caso y continuar los independientes],
  [Reanudación], [Acceso normal, fixture revalidado, permisos concedidos], [Nueva corrida registrada sin sobrescribir la evidencia previa],
)

== 8.2 Estado frente a los criterios de salida
#T((4.6cm, 2.2cm, 1fr),
  ..hd("Criterio", "Estado", "Sustento"),
  [Análisis, diseño y registro], chip("Cumplido", VERDE), [26 condiciones, 18 casos completos y registro con evidencia para los 14 casos Alta.],
  [Aceptación / afirmación de calidad], chip("No cumplido", ROJO), [Persisten DEF-01 (fallo monetario) y DEF-04 (ausencia de método de pago), con ocho requisitos de riesgo Alto sin verificación completa.],
)

== 8.3 Métricas con sus denominadores
#T((5.2cm, 3cm, 1fr),
  ..hd("Métrica", "Cálculo", "Lectura"),
  [Casos diseñados], [18 casos únicos], [14 de prioridad Alta y 4 de prioridad Media; 11 de 11 requisitos clave con diseño.],
  [Casos Alta con registro], [14 / 14 = 100 %], [Registro no equivale a ejecución completa: incluye los 9 bloqueados.],
  [Veredictos concluyentes], [(3 Pasó + 2 Falló) / 14 = 5 / 14 = 35.7 %], [Sólo un tercio de los casos obligatorios produjo un veredicto utilizable.],
  [Tasa de aprobación], [3 / 5 = 60.0 %], [Calculada sobre concluyentes, no 3 / 14: usar el total planificado sería una métrica engañosa.],
  [Tasa de bloqueo], [9 / 14 = 64.3 %], [El bloqueo domina el resultado y es el dato accionable del ambiente.],
  [Bloque Franco], [7 Alta: 3 Pasó, 1 Falló, 3 Bloqueados], [Catálogo, producto, carrito y cupones.],
  [Bloque Granit], [7 Alta: 0 Pasó, 1 Falló, 6 Bloqueados], [Checkout, confirmación, pedidos y RNF: cadena dependiente de DEF-04.],
  [Complementarios], [4 casos Media], [CP-CAT-01, CP-CAT-03, CP-RNF-02 y CP-VAL-01 sólo diseñados.],
)
#v(3pt)
#pagebreak()

// ===================== 9. CIERRE =====================
= 9. Cierre y automatización <sec-cierre>

== 9.1 Conclusión
#T((1fr,),
  ..hd("Conclusión de pruebas"),
  [Funcionaron en las condiciones evaluadas el orden por precio, la validación de una opción obligatoria y el control de cantidad superior al stock. El carrito presentó una diferencia entre el total de línea y el total general con dos unidades, y el checkout invitado no pudo continuar por falta de método de pago aplicable. Los casos de opciones válidas, cupones vigentes, confirmación, propagación al panel, cambio de stock y rendimiento permanecen bloqueados por condiciones del ambiente. Los resultados no bastan para recomendar el sistema como listo para producción; los casos bloqueados deben reejecutarse cuando se habiliten sus precondiciones, junto con la prueba de confirmación de DEF-01 y las pruebas de regresión asociadas.],
)

#pagebreak(weak: true)
== 9.2 Recomendaciones de automatización por caso
#T((3.2cm, 4.6cm, 1fr),
  ..hd("Caso ejecutado o intentado", "Recomendación para el Proyecto 2", "Sustento observado"),
  [CP-CAR-01], [Prioridad alta para las pruebas de regresión monetarias.], [Discrepancia 122 × 2 frente a 242 reproducida; usar cálculos decimales y comparar bases fiscales iguales.],
  [CP-CHK-01], [Automatizar validaciones y una prueba de humo del pago tras habilitar el flujo.], [El apellido vacío es estable; la ausencia de pago bloquea la cadena. Reportar el bloqueo, no reintentar indefinidamente.],
  [CP-CAT-02], [Automatizar la regresión ascendente/descendente con fixture estable.], [Ambos selectores funcionan y la comparación de 12 precios es determinista; no fijar un catálogo público mutable.],
  [CP-PRO-01], [Automatizar la omisión aislada de una opción requerida.], [Mensaje «Select required!» y carrito vacío observables. Prever variación de idioma.],
  [CP-CAR-02], [Automatizar clases y frontera en un entorno controlado.], [147 / 148 producen una diferencia observable; el demo compartido vuelve volátil el valor de S. Acordar la normalización antes de exigir un mensaje específico.],
  [CP-PRO-02], [Condicionar la automatización a un fixture con opciones.], [Los 3 candidatos no permiten una selección completa; automatizar ahora sólo produciría bloqueos de datos.],
  [CP-CUP-01/02], [Automatizar con cupones creados y restaurados por fixture.], [Los rechazos de códigos inválidos son observables, pero los tres cupones disponibles estaban vencidos y no permitieron evaluar el caso positivo.],
  [CP-CON-01/02 · CP-PED-01], [No implementar todavía sobre este demo como prueba estable.], [No existe una orden propia. Requiere un ambiente con pago de prueba e identificadores trazables.],
  [CP-ADM-01], [Reservar una prueba controlada con restauración de datos.], [El permiso de modificación fue denegado; no conviene automatizar cambios globales sobre un demo compartido.],
  [CP-RNF-01/03], [Instrumentar después de resolver las precondiciones.], [Sin orden propia ni medidas crudas no hay línea base real para umbrales automatizados.],
)
#v(3pt)
#nota[Se mantiene manual la exploración de opciones mal configuradas y la revisión de claridad de los mensajes, porque requieren interpretar intención y configuración. El diseño de automatización no se entrega como si ya estuviera implementado. Los casos de prioridad Media no se justifican como candidatos a partir de ejecuciones inexistentes. Todo el testware queda archivado bajo Gestión de la Configuración con su manifiesto SHA-256.]

#pagebreak()
= Anexo · Evidencias <sec-anexo>

Capturas citadas en las tablas de ejecución y hallazgos.

#ANEXO_EVIDENCIAS

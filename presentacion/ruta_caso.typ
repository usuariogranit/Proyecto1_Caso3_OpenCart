#set page(paper: "a4", margin: (top: 1.6cm, bottom: 1.6cm, left: 2.2cm, right: 2.2cm))
#set text(font: ("Helvetica", "Arial"), size: 9.5pt, lang: "es")
#set par(justify: false, leading: 0.58em)

#let TINTA = rgb("#142D3D")
#let GRIS  = rgb("#5A6B76")
#let CYAN  = rgb("#007C9F")
#let VERDE = rgb("#18744D")
#let ROJO  = rgb("#BA3C3C")
#let AMBAR = rgb("#A46810")
#let PALE  = rgb("#F2F6F8")

#let nota(cuerpo) = text(size: 9pt, style: "italic", fill: GRIS)[#cuerpo]
#let pag(n) = box(inset: (x: 4pt, y: 1pt), radius: 2pt, fill: PALE,
  text(size: 7.5pt, fill: CYAN)[p. #n])
#let chip(t, c) = box(inset: (x: 5pt, y: 2pt), radius: 3pt, fill: c.lighten(86%),
  stroke: 0.5pt + c, text(size: 8pt, weight: "bold", fill: c)[#t])

// ---- etapa del recorrido: numero, titulo, contenido, pagina
#let etapa(n, titulo, cuerpo, p: none, color: CYAN, ultimo: false) = block(
  below: if ultimo {0pt} else {4pt}, width: 100%,
  grid(columns: (20pt, 1fr), column-gutter: 8pt, align: (top, top),
    circle(radius: 8.5pt, fill: color, stroke: none,
      align(center + horizon, text(size: 7.5pt, weight: "bold", fill: white)[#n])),
    [
      #text(size: 9pt, weight: "bold", fill: TINTA)[#titulo]
      #if p != none [ #h(4pt) #pag(p) ]
      #linebreak()
      #text(size: 9pt, fill: rgb("#2B3A44"))[#cuerpo]
    ]
  )
)

#image("banner_utec.png", width: 100%, height: 2.4cm, fit: "cover")
#v(7pt)
#text(size: 19pt, weight: "bold", fill: black)[Ruta de un caso de prueba]
#v(2pt)
#nota[Trazabilidad de extremo a extremo de dos casos representativos del Caso 3 — OpenCart. Muestra cómo se planteó cada caso, qué técnica del curso se le aplicó y por qué, y por qué etapas atravesó hasta su estado actual. Las referencias #pag[n] apuntan al informe integrado del Grupo 5.]
#v(3pt)
#line(length: 100%, stroke: 0.6pt + rgb("#D6DEE3"))
#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 12pt,
  box(inset: 7pt, radius: 3pt, fill: PALE)[
    #text(size: 9pt, weight: "bold", fill: TINTA)[Caso A · CP-CAR-01] #h(4pt) #chip("FALLÓ", ROJO)
    #linebreak() #nota[Actualización de cantidad válida en el carrito. Derivó en el defecto DEF-01.]
  ],
  box(inset: 7pt, radius: 3pt, fill: PALE)[
    #text(size: 9pt, weight: "bold", fill: TINTA)[Caso B · CP-ADM-01] #h(4pt) #chip("BLOQUEADO", AMBAR)
    #linebreak() #nota[Producto agotado en panel reflejado públicamente. No derivó en defecto.]
  ]
)
#v(7pt)

#text(size: 13pt, weight: "bold", fill: black)[Caso A · CP-CAR-01 — de un requisito a un defecto abierto]
#v(5pt)

#etapa(1, p: 6)[Requisito de origen][*E-RF03* — el carrito debe recalcular los importes al cambiar la cantidad. Base de pruebas derivada del enunciado del Caso 3.]
#etapa(2, p: 4)[Riesgo asociado][*R03 · riesgo monetario.* Probabilidad 3 × Impacto 3 = *9* → prioridad *Alta*. El riesgo fija la profundidad: es el requisito con más casos del proyecto, tres.]
#etapa(3, p: 6)[Condición de prueba][*CT-CAR-01* — una cantidad válida recalcula línea, subtotal, impuestos y total de forma coherente. Describe *qué* comprobar, no cómo.]
#etapa(4, p: 15)[Técnica elegida y por qué][*Partición de equivalencia.* El campo cantidad admite infinitos valores; se agrupan en clases que el sistema debe tratar igual y se prueba un representante de la clase válida. No se eligió tabla de decisión porque no hay variables combinadas, ni transición de estados porque no hay cambio de estado del pedido.]
#etapa(5, p: 15)[Diseño del caso][*CP-CAR-01*, prioridad Alta, responsable Franco. Oráculo declarado: el total de línea debe ser igual al precio unitario multiplicado por la cantidad, bajo la misma base fiscal.]
#etapa(6, p: 15)[Datos y precondiciones][Producto apto sin opciones obligatorias: *iPod Nano* (product_id 36). Carrito limpio. Cantidades *1* y *2*. Precio unitario mostrado 122.00 USD. Importes de referencia registrados antes de actualizar.]
#etapa(7, p: 29)[Ejecución y veredicto][25/09/2026. Con 1 unidad: precio y línea coinciden en 122.00. Con 2 unidades: unitario 122.00, *línea 242.00*, *total general 244.00*. Desglose: Sub-Total 200.00 + Eco Tax 4.00 + VAT 40.00 = 244.00. → *Falló*.]
#etapa(8, p: 30)[Evidencia][`CP-CAR-01_qty1_20260925.png` y `CP-CAR-01_qty2_20260925.png`. Hora y URL en `registro.json`; integridad por SHA-256 en `manifest_integrado.json`.]
#etapa(9, p: 32)[Hallazgo derivado][*DEF-01* — «\[Carrito\] El total de línea no coincide con el total a pagar al aumentar la cantidad de una a dos unidades». Severidad Alta / Prioridad propuesta Alta. La causa raíz *no* se afirma: el Eco Tax es hipótesis, no se inspeccionó código.]
#etapa(10, ultimo: true, p: 32)[Estado actual][*Abierto · reproducido el 25/09/2026.* Al existir corrección pasará a «Listo para reprueba»: se repetirá CP-CAR-01 como *prueba de confirmación* y se aplicarán *pruebas de regresión* sobre carrito y checkout, que comparten precondiciones.]

#pagebreak()

#text(size: 13pt, weight: "bold", fill: black)[Caso B · CP-ADM-01 — de un requisito a un bloqueo justificado]
#v(2pt)
#nota[Se incluye este segundo recorrido porque un caso bloqueado también atraviesa todas las etapas: lo que cambia es dónde se detiene y por qué. Un bloqueo no es un fallo ni una omisión.]
#v(7pt)

#etapa(1, color: AMBAR, p: 6)[Requisito de origen][*E-RF08* — al marcar un producto como agotado en el panel, el sitio público debe reflejar esa condición.]
#etapa(2, color: AMBAR, p: 4)[Riesgo asociado][*R01 venta sin inventario real* y *R05 inconsistencia sitio–panel*, ambos de nivel *Alto*. Es la queja de negocio que originó el Caso 3.]
#etapa(3, color: AMBAR, p: 7)[Condición de prueba][*CT-ADM-01* — el stock cero guardado y el estado agotado se reflejan en la interfaz pública.]
#etapa(4, color: AMBAR, p: 22)[Técnica elegida y por qué][*Tabla de decisión.* El comportamiento depende de tres variables combinadas —cantidad, estado publicado y política de venta sin inventario (`Stock Checkout`)—, y solo una tabla obliga a enunciar la acción esperada de cada combinación. Se definieron cuatro reglas, R1 a R4.]
#etapa(5, color: AMBAR, p: 22)[Diseño del caso][*CP-ADM-01*, prioridad Alta, responsable Granit. Precondición explícita: sesión autenticada *con permiso de escritura* en Catalog > Products.]
#etapa(6, color: AMBAR, p: 22)[Datos y precondiciones][*HP LP3065* (product_id 47). Estado previo verificado: `Quantity = 1000`, `Out Of Stock Status = Out Of Stock`, `Subtract Stock` activo. Cambio previsto: cantidad a 0.]
#etapa(7, color: AMBAR, p: 31)[Ejecución y veredicto][24/09/2026, 02:45. Al guardar, el panel responde: *«Warning: You do not have permission to modify products!»*. El valor no se persiste. → *Bloqueado*, nunca *Fallido*: el sistema no llegó a comportarse frente al requisito.]
#etapa(8, color: AMBAR, p: 31)[Evidencia][`CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png`, con hora y hash SHA-256. El ambiente no fue alterado; no se requirió restaurar datos.]
#etapa(9, color: AMBAR, p: 45)[Hallazgo derivado][*Ninguno.* La restricción es del ambiente público de prueba, no del producto, y convertirla en defecto inflaría el conteo. Se registra en la bitácora de ambiente, no en el reporte de defectos.]
#etapa(10, ultimo: true, color: AMBAR, p: 31)[Estado actual][*Bloqueado por impedimento externo.* Se reejecutará en una instancia controlada con permisos de escritura. Mientras tanto cuenta en la *tasa de bloqueo*, calculada sobre los casos planificados, y nunca en la tasa de aprobación.]

#v(10pt)
#block(width: 100%, inset: 8pt, radius: 3pt, fill: PALE, stroke: (left: 2.5pt + CYAN))[
  #text(size: 9.5pt, weight: "bold", fill: TINTA)[Qué demuestra la comparación de ambos recorridos]
  #v(3pt)
  #text(size: 9pt)[Los dos casos nacen de un requisito, reciben una prioridad derivada del riesgo, se les asigna una técnica del curso justificada por la naturaleza del problema, y se ejecutan con datos y precondiciones declarados. La diferencia aparece en la etapa 7: *CP-CAR-01* obtuvo un comportamiento observable contrario al oráculo y por eso *falló* y generó un defecto; *CP-ADM-01* no obtuvo comportamiento alguno y por eso quedó *bloqueado* y no generó ninguno. Distinguirlos es lo que permite saber qué le corresponde corregir al equipo de desarrollo y qué le corresponde habilitar al responsable del ambiente.]
]

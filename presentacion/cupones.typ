#set page(paper: "a4", margin: (top: 1.5cm, bottom: 1.5cm, left: 1.9cm, right: 1.9cm),
  header: context { if counter(page).get().first() > 1 [
    #set text(size: 7.5pt, fill: rgb("#5A6B76"))
    #grid(columns: (1fr, auto))[Grupo 5 · Módulo de Cupones · OpenCart Demo 4.0.2.3][E-RF04]
    #line(length: 100%, stroke: 0.4pt + rgb("#D6DEE3"))] },
  footer: context [ #set text(size: 7.5pt, fill: rgb("#5A6B76"))
    #grid(columns: (1fr, auto))[Franco Roque Castillo · Granit Espinoza Salazar][#counter(page).display() / #counter(page).final().first()] ])
#set text(font: ("Times New Roman", "Times"), size: 9.5pt, lang: "es", hyphenate: false)
#set par(leading: 0.6em)

#let TINTA = rgb("#142D3D"); #let GRIS = rgb("#5A6B76"); #let AZUL = rgb("#1F4E79")
#let VERDE = rgb("#18744D"); #let ROJO = rgb("#BA3C3C"); #let AMBAR = rgb("#A46810")
#let PALE = rgb("#F4F7F9")
#let nota(c) = text(size: 8.5pt, style: "italic", fill: GRIS)[#c]
#let H(t) = block(width: 100%, fill: AZUL, inset: (x: 8pt, y: 5pt), radius: 2pt,
  text(size: 11.5pt, weight: "bold", fill: white)[#t])
#let h2(t) = { v(6pt); text(size: 10pt, weight: "bold", fill: AZUL)[#t]; v(3pt) }
#let ver(t) = {
  let c = if t == "Pasó" { VERDE } else if t == "Falló" { ROJO } else if t == "Bloqueado" { AMBAR } else { GRIS }
  box(inset: (x: 4pt, y: 1pt), radius: 2pt, fill: c.lighten(85%), stroke: 0.5pt + c,
    text(size: 7.5pt, weight: "bold", fill: c)[#t])
}
#let T(anchos, ..celdas) = table(columns: anchos, stroke: 0.4pt + rgb("#BFCAD1"), inset: 3.6pt,
  align: left + top, fill: (_, y) => if y == 0 { AZUL } else if calc.odd(y) { PALE } else { white }, ..celdas)
#let hd(..t) = t.pos().map(x => text(size: 8pt, weight: "bold", fill: white)[#x])
#let c(x) = text(size: 8pt)[#x]
#let lit(x) = text(size: 7.6pt, font: "Courier New")[#x]

#image("banner_utec.png", width: 100%, height: 2.2cm, fit: "cover")
#v(8pt)
#text(size: 18pt, weight: "bold")[Módulo de Cupones de Descuento]
#v(1pt)
#text(size: 11pt, fill: GRIS)[Informe de pruebas para el equipo de desarrollo · Caso 3 — OpenCart Demo 4.0.2.3]
#v(6pt)
#T((2.6cm, 1fr, 2.4cm, 1fr),
  ..hd("Requisito", "Alcance", "Fecha", "Equipo"),
  c[*E-RF04* — aplicación de cupones de descuento],
  c[Campo «Use Coupon Code» del carrito y su efecto sobre los importes],
  c[26/09/2026], c[Grupo 5 · Franco Roque Castillo y Granit Espinoza Salazar])
#v(4pt)
#nota[Este documento aísla un solo módulo para que el equipo de desarrollo sepa exactamente qué combinaciones se probaron, cuáles funcionan, cuáles no y cuáles quedaron sin verificar.]

#v(8pt)
#H[1. Configuración encontrada en el sistema]
#v(4pt)
El catálogo tiene *dos cupones*, ambos inutilizables hoy. Esto condiciona todo lo que se puede probar.
#v(4pt)
#T((2.2cm, 3.4cm, 2.1cm, 2.4cm, 2.4cm, 1fr),
  ..hd("Código", "Nombre", "Tipo", "Vigencia", "Estado", "Consecuencia"),
  c[*2222*], c[-10% Discount], c[Porcentaje, 10 %], c[01/01/2014 – 01/01/2020], c[Disabled],
  c[Vencido hace más de 6 años y además deshabilitado],
  c[*1111*], c[-10.00 Discount], c[Monto fijo, 10.00], c[01/01/2014 – 01/01/2020], c[Disabled],
  c[Mismo caso],
)
#v(4pt)
#block(width: 100%, inset: 7pt, radius: 2pt, fill: rgb("#FFF4E5"), stroke: (left: 2.5pt + AMBAR))[
  #text(size: 8.5pt)[*No existe ningún cupón válido en el ambiente.* Por eso el camino positivo —aplicar un descuento real— no se puede ejecutar. Los dos cupones fallan por *dos causas a la vez* (deshabilitado y vencido), así que tampoco se puede aislar cuál de las dos rechaza el sistema.]
]

#v(8pt)
#H[2. Tabla de decisión del módulo]
#v(4pt)
Siete condiciones gobiernan si un cupón se aplica. La tabla enumera cada combinación relevante y la acción que el sistema debe tomar.
#v(5pt)
#T((1.1cm, 1fr, 0.9cm, 0.9cm, 0.9cm, 0.9cm, 0.9cm, 0.9cm, 0.9cm, 3.9cm),
  ..hd("Regla", "Situación", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "Acción esperada"),
  c[*R1*], c[Cupón válido en carrito elegible], c[Sí], c[Sí], c[Sí], c[Sí], c[Sí], c[Sí], c[Sí],
  c[Aplica el descuento, agrega la línea «Coupon» y recalcula el total],
  c[*R2*], c[El código no existe], c[No], c[–], c[–], c[–], c[–], c[–], c[–],
  c[Rechaza e indica que el código no existe. El total no cambia],
  c[*R3*], c[Existe pero está deshabilitado], c[Sí], c[No], c[–], c[–], c[–], c[–], c[–],
  c[Rechaza e indica que el cupón no está activo],
  c[*R4*], c[Existe pero está fuera de vigencia], c[Sí], c[Sí], c[No], c[–], c[–], c[–], c[–],
  c[Rechaza e indica que el cupón venció],
  c[*R5*], c[Alcanzó su límite de usos], c[Sí], c[Sí], c[Sí], c[No], c[–], c[–], c[–],
  c[Rechaza e indica que se agotaron los usos],
  c[*R6*], c[El carrito no llega al monto mínimo], c[Sí], c[Sí], c[Sí], c[Sí], c[No], c[–], c[–],
  c[Rechaza e indica el monto mínimo exigido],
  c[*R7*], c[Ningún producto del carrito es elegible], c[Sí], c[Sí], c[Sí], c[Sí], c[Sí], c[No], c[–],
  c[Rechaza, o aplica 0 de descuento sin afectar los productos no elegibles],
  c[*R8*], c[Se aplica dos veces el mismo cupón], c[Sí], c[Sí], c[Sí], c[Sí], c[Sí], c[Sí], c[No],
  c[No acumula: el descuento sigue siendo uno solo],
  c[*R9*], c[El campo se envía vacío o con espacios], c[–], c[–], c[–], c[–], c[–], c[–], c[–],
  c[Pide un código. No debe informar una eliminación que no ocurrió],
)
#v(4pt)
#nota[C1 el código existe · C2 está habilitado · C3 está dentro de vigencia · C4 le quedan usos · C5 el carrito alcanza el monto mínimo · C6 hay un producto elegible · C7 es la primera aplicación. El guion «–» significa que esa condición ya no influye porque una anterior decidió el resultado.]

#v(9pt)
#H[3. Casos de prueba derivados]
#v(4pt)
Un caso por regla. Datos fijos para todos: producto *iPod Nano*, una unidad, carrito con Sub-Total 100.00, Eco Tax 2.00, VAT 20.00 y *Total 122.00*.
#v(5pt)
#T((1.9cm, 1.1cm, 1fr, 3.5cm, 2.1cm),
  ..hd("Caso", "Regla", "Entrada", "Resultado esperado", "Técnica"),
  c[*CUP-01*], c[R1], c[Código de un cupón vigente y aplicable], c[El total baja según el tipo de descuento y aparece la línea «Coupon»], c[Partición de equivalencia],
  c[*CUP-02*], c[R2], c[#lit[QA-NO-EXISTE-20260926]], c[Rechazo con mensaje propio de «código inexistente»], c[Partición de equivalencia],
  c[*CUP-03*], c[R3], c[#lit[2222] — deshabilitado], c[Rechazo con mensaje propio de «cupón inactivo»], c[Tabla de decisión],
  c[*CUP-04*], c[R4], c[#lit[1111] — vencido], c[Rechazo con mensaje propio de «cupón vencido»], c[Tabla de decisión],
  c[*CUP-05*], c[R5], c[Cupón con usos agotados], c[Rechazo indicando el límite de usos], c[Tabla de decisión],
  c[*CUP-06*], c[R6], c[Cupón con monto mínimo mayor al carrito], c[Rechazo indicando el mínimo exigido], c[Valores límite],
  c[*CUP-07*], c[R7], c[Cupón de otra categoría], c[Rechazo o descuento 0 sin afectar el total], c[Tabla de decisión],
  c[*CUP-08*], c[R8], c[Mismo cupón válido aplicado dos veces], c[Un solo descuento; no se duplica], c[Transición de estados],
  c[*CUP-09*], c[R9], c[Campo vacío y campo con tres espacios], c[Pedir un código; no informar eliminación], c[Partición de equivalencia],
  c[*CUP-10*], c[R2], c[Cadena de 300 caracteres y cadena con #lit[\<\>'\"%&=]], c[Rechazo controlado, sin error de servidor], c[Valores límite],
  c[*CUP-11*], c[R2], c[Cupón sobre un carrito vacío], c[Rechazo controlado], c[Partición de equivalencia],
)

#v(8pt)
#H[4. Resultados de la ejecución]
#v(4pt)
Ejecución manual sobre el sitio público el 26/09/2026. La columna «Respuesta literal» reproduce el texto exacto que devuelve el sistema.
#v(5pt)
#T((1.9cm, 1fr, 5.2cm, 1.9cm, 1.9cm),
  ..hd("Caso", "Entrada probada", "Respuesta literal del sistema", "Total", "Veredicto"),
  c[*CUP-02*], c[#lit[QA-NO-EXISTE-20260926]], c[#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], c[122.00 sin cambio], ver("Falló"),
  c[*CUP-03*], c[#lit[2222]], c[#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], c[122.00 sin cambio], ver("Falló"),
  c[*CUP-04*], c[#lit[1111]], c[#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], c[122.00 sin cambio], ver("Falló"),
  c[*CUP-09*], c[Campo vacío], c[#lit[Success: Your coupon discount has been removed!]], c[122.00 sin cambio], ver("Falló"),
  c[*CUP-09*], c[Tres espacios], c[#lit[Success: Your coupon discount has been removed!]], c[122.00 sin cambio], ver("Falló"),
  c[*CUP-10*], c[300 caracteres], c[#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], c[122.00 sin cambio], ver("Pasó"),
  c[*CUP-10*], c[#lit[\<\>'\"%&=]], c[#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], c[122.00 sin cambio], ver("Pasó"),
  c[*CUP-11*], c[#lit[2222] con carrito vacío], c[#lit[Warning: Coupon is either invalid, expired or reached its usage limit!]], c[Carrito vacío], ver("Pasó"),
  c[*CUP-01*], c[Cupón vigente], c[No ejecutable: no existe ningún cupón vigente], c[—], ver("Bloqueado"),
  c[*CUP-05*], c[Usos agotados], c[No ejecutable: requiere un cupón vigente con límite], c[—], ver("Bloqueado"),
  c[*CUP-06*], c[Monto mínimo], c[No ejecutable: requiere un cupón vigente con mínimo], c[—], ver("Bloqueado"),
  c[*CUP-07*], c[Categoría no elegible], c[No ejecutable: requiere un cupón vigente por categoría], c[—], ver("Bloqueado"),
  c[*CUP-08*], c[Aplicación repetida], c[No ejecutable: requiere una primera aplicación válida], c[—], ver("Bloqueado"),
)
#v(5pt)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 8pt,
  block(inset: 6pt, radius: 2pt, fill: PALE)[#text(size: 8.5pt)[*3 pasaron* — robustez de entrada]],
  block(inset: 6pt, radius: 2pt, fill: PALE)[#text(size: 8.5pt)[*5 fallaron* — mensajes incorrectos]],
  block(inset: 6pt, radius: 2pt, fill: PALE)[#text(size: 8.5pt)[*5 bloqueados* — falta un cupón vigente]],
)
#v(3pt)
#nota[Ninguna entrada inválida alteró el total ni creó una línea de descuento: el control monetario del camino negativo es correcto. Lo que falla son los mensajes.]

#v(9pt)
#H[5. Hallazgos para el equipo de desarrollo]
#v(5pt)

#block(width: 100%, inset: 8pt, radius: 2pt, stroke: (left: 3pt + ROJO), fill: white)[
  #text(size: 10pt, weight: "bold")[H-CUP-01 · \[Cupones\] Un solo mensaje para cuatro causas distintas de rechazo]
  #v(3pt)
  #text(size: 9pt)[*Qué pasa.* El sistema responde siempre #lit[Warning: Coupon is either invalid, expired or reached its usage limit!], sin importar si el código no existe, está deshabilitado, venció o agotó sus usos.]
  #v(2pt)
  #text(size: 9pt)[*Cómo reproducir.* Agregar iPod Nano al carrito. Aplicar #lit[QA-NO-EXISTE-20260926] (no existe), luego #lit[2222] (deshabilitado) y luego #lit[1111] (vencido). Los tres devuelven el mismo texto.]
  #v(2pt)
  #text(size: 9pt)[*Por qué importa.* El cliente no sabe si se equivocó al escribir o si la promoción ya terminó, y tiende a abandonar la compra. Soporte tampoco puede diagnosticar sin entrar al panel. Es la diferencia entre «revisa el código» y «esta promoción venció el 1 de enero».]
  #v(2pt)
  #text(size: 9pt)[*Sugerencia.* Mensajes distintos por causa; el código de error puede ser interno y el texto al cliente, específico.]
  #v(3pt)
  #grid(columns: (auto, auto, auto, 1fr), column-gutter: 14pt,
    text(size: 8.5pt)[*Severidad:* Media], text(size: 8.5pt)[*Prioridad propuesta:* Alta],
    text(size: 8.5pt)[*Estado:* Nuevo], text(size: 8.5pt)[*Regla:* R2, R3, R4, R5])
]
#v(7pt)
#block(width: 100%, inset: 8pt, radius: 2pt, stroke: (left: 3pt + ROJO), fill: white)[
  #text(size: 10pt, weight: "bold")[H-CUP-02 · \[Cupones\] El campo vacío responde «Success» aunque no había ningún cupón aplicado]
  #v(3pt)
  #text(size: 9pt)[*Qué pasa.* Enviar el campo vacío, o con solo espacios, devuelve #lit[Success: Your coupon discount has been removed!] pese a que no existía ningún descuento que eliminar.]
  #v(2pt)
  #text(size: 9pt)[*Cómo reproducir.* Con un carrito sin cupón aplicado, pulsar «Apply Coupon» dejando el campo vacío. Repetir escribiendo tres espacios.]
  #v(2pt)
  #text(size: 9pt)[*Por qué importa.* Un mensaje de éxito ante una acción que no ocurrió enseña al usuario a desconfiar de los mensajes. Además revela que la entrada no se valida ni se recorta: los espacios no se eliminan antes de procesar.]
  #v(2pt)
  #text(size: 9pt)[*Sugerencia.* Validar que el campo no esté vacío tras recortar espacios, y reservar el mensaje de eliminación para cuando realmente había un cupón aplicado.]
  #v(3pt)
  #grid(columns: (auto, auto, auto, 1fr), column-gutter: 14pt,
    text(size: 8.5pt)[*Severidad:* Baja], text(size: 8.5pt)[*Prioridad propuesta:* Media],
    text(size: 8.5pt)[*Estado:* Nuevo], text(size: 8.5pt)[*Regla:* R9])
]
#v(7pt)
#block(width: 100%, inset: 8pt, radius: 2pt, stroke: (left: 3pt + VERDE), fill: white)[
  #text(size: 10pt, weight: "bold")[C-CUP-01 · Confirmación: ninguna entrada inválida altera los importes]
  #v(3pt)
  #text(size: 9pt)[Con ocho entradas distintas —inexistente, deshabilitado, vencido, vacío, espacios, 300 caracteres, caracteres especiales y carrito vacío— el total se mantuvo en 122.00 y nunca apareció una línea de descuento. El módulo no crea descuentos fantasma, que es el riesgo económico principal. Tampoco se produjo ningún error de servidor.]
]

#v(8pt)
#H[6. Qué falta para cerrar el módulo]
#v(4pt)
Cinco reglas de la tabla de decisión no se pueden verificar hoy. No es una omisión del equipo de pruebas: el ambiente no tiene con qué probarlas.
#v(5pt)
#T((1.1cm, 1fr, 1fr),
  ..hd("Regla", "Qué falta verificar", "Qué se necesita en el ambiente"),
  c[R1], c[Que un cupón válido aplique el descuento correcto], c[Un cupón habilitado y vigente, de tipo porcentaje y otro de monto fijo],
  c[R5], c[Que el límite de usos bloquee la aplicación], c[Un cupón con límite bajo, por ejemplo un uso],
  c[R6], c[Que el monto mínimo se respete], c[Un cupón con monto mínimo declarado],
  c[R7], c[Que la restricción por categoría funcione], c[Un cupón restringido a una categoría concreta],
  c[R8], c[Que el mismo cupón no se acumule], c[Cualquier cupón válido, para aplicarlo dos veces],
)
#v(4pt)
#nota[Con un solo cupón de prueba habilitado se desbloquean R1 y R8. Con tres cupones configurados —uno con límite de usos, uno con monto mínimo y uno por categoría— se cierra el módulo completo.]

#pagebreak()
#H[7. Evidencias]
#v(5pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt, row-gutter: 10pt,
  [#figure(image("ev/CP-CUP-01_cupones-no-vigentes_20260925.png", width: 100%),
    caption: text(size: 7.5pt)[E-20 · Panel: los dos cupones, deshabilitados y vencidos])],
  [#figure(image("ev/CP-CUP-02_inexistente_20260925.png", width: 100%),
    caption: text(size: 7.5pt)[E-22 · Código inexistente en el carrito])],
  [#figure(image("ev/CP-CUP-02_error-visible_20260925.png", width: 100%),
    caption: text(size: 7.5pt)[E-21 · Mensaje de rechazo visible al cliente])],
  [#figure(image("ev/CP-CUP-02_vencido_20260925.png", width: 100%),
    caption: text(size: 7.5pt)[E-24 · Aplicación de un cupón vencido])],
  [#figure(image("ev/CP-CUP-02_vencido-error_20260925.png", width: 100%),
    caption: text(size: 7.5pt)[E-23 · El mismo mensaje para una causa distinta])],
  [#block(inset: 8pt, radius: 2pt, fill: PALE)[#text(size: 8.5pt)[*Método de registro.* Cada ejecución guarda la entrada probada, la respuesta literal del sistema y el total resultante. Las capturas conservan fecha y se verifican con huella SHA-256.]]],
)

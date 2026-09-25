"""Genera la justificación de cumplimiento y la guía de exposición del Grupo 5."""
from pathlib import Path
from xml.sax.saxutils import escape
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

HERE=Path(__file__).resolve().parent
ROOT=HERE.parent
FONT=Path('C:/Windows/Fonts')
pdfmetrics.registerFont(TTFont('Body',str(FONT/'arial.ttf')))
pdfmetrics.registerFont(TTFont('BodyB',str(FONT/'arialbd.ttf')))
pdfmetrics.registerFontFamily('Body',normal='Body',bold='BodyB',italic='Body',boldItalic='BodyB')
W,H=A4
CW=W-90
ss=getSampleStyleSheet()
ss.add(ParagraphStyle(name='B',fontName='Body',fontSize=10,leading=14,spaceAfter=8,textColor=colors.HexColor('#263A43')))
ss.add(ParagraphStyle(name='T',fontName='BodyB',fontSize=21,leading=26,spaceAfter=14,textColor=colors.HexColor('#005B75')))
ss.add(ParagraphStyle(name='H1',fontName='BodyB',fontSize=16,leading=20,spaceBefore=10,spaceAfter=12,textColor=colors.HexColor('#005B75'),keepWithNext=True))
ss.add(ParagraphStyle(name='H2',fontName='BodyB',fontSize=12,leading=16,spaceBefore=9,spaceAfter=7,textColor=colors.HexColor('#00758F'),keepWithNext=True))
ss.add(ParagraphStyle(name='Cell',fontName='Body',fontSize=8.4,leading=11,wordWrap='CJK'))
ss.add(ParagraphStyle(name='Call',fontName='Body',fontSize=10,leading=14,leftIndent=12,rightIndent=12,spaceBefore=5,spaceAfter=9,backColor=colors.HexColor('#EEF7F9'),borderColor=colors.HexColor('#84BAC6'),borderWidth=.6,borderPadding=8))

def P(text,style='B'):
    return Paragraph(escape(str(text)).replace('\n','<br/>'),ss[style])
def T(headers,rows,widths=None):
    widths=widths or [CW/len(headers)]*len(headers)
    data=[[P(x,'Cell') for x in headers]]+[[P(x,'Cell') for x in row] for row in rows]
    t=Table(data,colWidths=widths,repeatRows=1,hAlign='LEFT')
    t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#D8EEF3')),('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,colors.HexColor('#F5F8F9')]),('GRID',(0,0),(-1,-1),.35,colors.HexColor('#C2D1D6')),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),6),('RIGHTPADDING',(0,0),(-1,-1),6),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
    return t
def footer(canvas,doc,label):
    canvas.saveState();canvas.setFont('Body',8);canvas.setFillColor(colors.HexColor('#526A73'))
    canvas.drawString(45,H-28,label);canvas.line(45,37,W-45,37);canvas.drawString(45,24,'Grupo 5 - 25/09/2026');canvas.drawRightString(W-45,24,str(doc.page));canvas.restoreState()
def build(path,title,story,label):
    doc=SimpleDocTemplate(str(path),pagesize=A4,rightMargin=45,leftMargin=45,topMargin=49,bottomMargin=49,title=title,author='Franco Roque Castillo; Granit Espinoza Salazar')
    doc.build(story,onFirstPage=lambda c,d:footer(c,d,label),onLaterPages=lambda c,d:footer(c,d,label))

def cover(title,subtitle):
    return [Spacer(1,75),P(title,'T'),P(subtitle,'H1'),Spacer(1,18),P('Proyecto 1 - Caso 3: OpenCart'),P('Grupo 5'),P('Franco Roque Castillo y Granit Espinoza Salazar'),P('25 de septiembre de 2026'),PageBreak()]

just=cover('Justificación de cumplimiento del informe','Correspondencia con el enunciado y con el material teórico del curso')
just += [P('Propósito','H1'),P('Este documento verifica que el informe final contiene los productos de trabajo solicitados para planificación, análisis, diseño, ejecución manual y cierre. La comprobación se realiza contra el enunciado del Caso 3 y contra los conceptos desarrollados en los materiales de teoría revisados por el grupo.')]
just += [P('1. Cumplimiento de los entregables','H1')]
rows=[
('Planificación completa','Sección 1','Incluye objetivos, alcance, estrategia, niveles, tipos, criterios de entrada y salida, suspensión, reanudación, recursos, esfuerzo, cronograma y riesgos.'),
('Estrategia justificada','Sección 1.3','Prioriza dinero, inventario, descuentos y continuidad de la compra porque concentran el mayor impacto para el negocio.'),
('Condiciones de prueba','Sección 2','Presenta 26 condiciones derivadas de los 8 requisitos funcionales, 3 no funcionales y detalles del alcance.'),
('Trazabilidad','Secciones 2 y 3','Cada condición se relaciona con su requisito, riesgo, prioridad y caso. Los 11 requisitos clave tienen cobertura de diseño.'),
('Mínimo de 15 casos','Sección 3','Se diseñaron 18 casos únicos que cubren catálogo, producto, carrito, cupones, checkout, confirmación, inventario, pedidos y requisitos no funcionales.'),
('Campos obligatorios de cada caso','Fichas 3.2','Cada caso contiene ID, condición, requisito, prioridad, técnica, justificación, precondiciones, datos, pasos y resultado esperado.'),
('Técnicas de caja negra','Secciones 3 y 3.1','Se aplican partición de equivalencia, valores límite, tablas de decisión, transición de estados y casos de uso.'),
('Ejecución de prioridad Alta','Sección 4','Los 14 casos de prioridad Alta tienen un registro. Cinco alcanzaron resultado concluyente y nueve quedaron bloqueados con causa documentada.'),
('Hallazgos y evidencias','Sección 4.5 y Anexo A','Los hallazgos incluyen resumen, trazabilidad, pasos, esperado, obtenido, severidad, prioridad y evidencia.'),
('Reflexión de automatización','Sección 5.2','Las recomendaciones se apoyan en la estabilidad del flujo, la repetición esperada, la disponibilidad de datos y lo observado durante la ejecución.'),
('Formato de entrega','PDF Proyecto1_Caso3_Grupo5','El informe se presenta en un único PDF y utiliza el nombre de caso y grupo solicitado.')]
just += [T(['Exigencia','Ubicación','Comprobación'],rows,[125,95,270]),Spacer(1,10)]
just += [P('2. Cobertura del Caso 3','H1'),P('El enunciado proporciona ocho requisitos funcionales y tres no funcionales. La cobertura de diseño es 11/11. La cobertura de diseño indica que existe al menos una condición y un caso relacionado; no significa que todos los casos hayan podido completarse en el demo.')]
reqrows=[
('RF1 Ordenamiento','CT-CAT-01/02','CP-CAT-01/02'),('RF2 Opciones','CT-PRO-01/02/03','CP-PRO-01/02'),('RF3 Cantidades','CT-CAR-01/02','CP-CAR-01/02'),('RF4 Cupones','CT-CUP-01/02/03/04/05','CP-CUP-01/02'),('RF5 Invitado','CT-CHK-01/02/03','CP-CHK-01 y CP-CON-01'),('RF6 Número y resumen','CT-CON-01/02/03','CP-CON-01/02'),('RF7 Pedido en panel','CT-PED-01','CP-PED-01'),('RF8 Producto agotado','CT-ADM-01 y CT-CAR-03','CP-ADM-01 y CP-CAR-02'),('RNF1 Sincronización','CT-RNF-01','CP-RNF-01'),('RNF2 Navegadores','CT-RNF-02','CP-RNF-02'),('RNF3 Menos de 2 s','CT-RNF-03','CP-RNF-03')]
just += [T(['Requisito','Condiciones','Casos'],reqrows,[145,170,175]),Spacer(1,10)]
just += [P('3. Alineación con los materiales de teoría','H1')]
theory=[
('Clase 3 - Niveles y tipos de pruebas','El informe identifica componente, integración, sistema y aceptación. El nivel principal es sistema; los niveles sin acceso a código se declaran fuera de ejecución. También distingue pruebas funcionales, rendimiento, compatibilidad, confirmación y regresión.'),
('Clase 4 - Análisis estático','La base de pruebas, los casos y la trazabilidad se revisan antes de ejecutar. Se separan requisitos, condiciones y resultados para evitar contradicciones entre el oráculo y lo observado.'),
('Clase 5 - Técnicas de caja negra','Los casos se derivan con particiones, límites, decisiones, estados y recorridos de uso. Cada ficha explica por qué la técnica corresponde al comportamiento que se desea comprobar.'),
('G1 - Análisis de valores límite','CP-CAR-02 evalúa 0/1 y S/S+1 utilizando el stock real observado. CP-RNF-03 trata 2000 ms como umbral de aceptación, pero exige medición instrumental en lugar de afirmar límites que no fueron controlados.'),
('G2 - Tablas de decisión y causa-efecto','CP-CUP-02 combina vigencia, elegibilidad y aplicación previa. CP-ADM-01 combina cantidad, estado publicado y política de compra sin stock.'),
('Clase 7 - Gestión de pruebas','El plan define prioridades, responsables, esfuerzo, cronograma, riesgos, criterios de entrada/salida y reglas de suspensión y reanudación. Los veredictos Pasó, Falló y Bloqueado se reportan por separado.'),
('TAREA 6 - Cobertura estructural','La cobertura estructural requiere acceso al código y no se utiliza para afirmar cobertura en este proyecto de caja negra. La exclusión está justificada por el alcance y el sistema disponible.')]
just += [T(['Material','Aplicación en el informe'],theory,[170,320]),Spacer(1,10)]
just += [P('4. Coherencia de los resultados','H1'),P('La selección Alta contiene 14 casos: 3 Pasó, 2 Falló y 9 Bloqueados. Un caso bloqueado no se contabiliza como aprobado ni como fallido. La tasa de aprobación entre resultados concluyentes es 3/5 = 60%; la tasa de bloqueo es 9/14 = 64.3%. Esta separación evita que las limitaciones del demo alteren el resultado del producto.')]
just += [T(['Estado','Casos','Interpretación'],[
('Pasó','CP-CAT-02, CP-PRO-01 y CP-CAR-02','Las aserciones definidas se verificaron en las condiciones y variantes indicadas.'),
('Falló','CP-CAR-01 y CP-CHK-01','Se observó una diferencia monetaria y la ausencia de un método de pago aplicable.'),
('Bloqueado','Nueve casos','Faltaron opciones, cupón válido, pago, orden propia, permisos o instrumentación. Requieren reejecución.')],[80,180,230]),Spacer(1,10)]
just += [P('5. Conclusión','H1'),P('El informe satisface la estructura y los productos de trabajo solicitados: plan, riesgos, condiciones, trazabilidad, casos, técnicas, datos, ejecución priorizada, hallazgos, evidencias y reflexión de automatización. También está alineado con los conceptos de niveles, tipos, análisis estático, técnicas de caja negra y gestión de pruebas vistos en clase. La entrega está completa como informe de pruebas; la validación del sistema continúa abierta porque nueve casos de prioridad Alta requieren un ambiente con precondiciones disponibles.')]

expo=cover('Guía para la exposición','Cómo presentar el Proyecto 1 - Caso 3 OpenCart')
expo += [P('Objetivo de la exposición','H1'),P('Explicar el criterio utilizado para planificar, diseñar y ejecutar las pruebas, mostrar los resultados más importantes y reconocer las limitaciones del ambiente sin confundirlas con defectos del producto.')]
expo += [P('Duración sugerida: 10 a 12 minutos','Call')]
expo += [T(['Tiempo','Responsable','Contenido'],[
('0:00-1:00','Franco','Contexto del caso y objetivo.'),('1:00-2:30','Granit','Alcance, estrategia y niveles.'),('2:30-4:00','Franco','Riesgos, condiciones y trazabilidad.'),('4:00-6:30','Franco','Casos de catálogo, producto, carrito y cupones.'),('6:30-8:30','Granit','Checkout, pedidos, administración y requisitos no funcionales.'),('8:30-10:00','Ambos','Resultados, defectos, automatización y conclusión.'),('10:00-12:00','Ambos','Preguntas.')],[75,85,330]),Spacer(1,10)]
expo += [P('1. Apertura','H1'),P('Franco puede iniciar así:','H2'),P('Nuestro proyecto evalúa el Caso 3 de OpenCart, una tienda electrónica con catálogo, carrito, descuentos, checkout y panel administrativo. El riesgo principal es que una inconsistencia de stock, precio o descuento afecte directamente al cliente y a la operación. Por eso utilizamos una estrategia basada en riesgos y priorizamos los flujos monetarios, el inventario y la finalización de la compra.','Call')]
expo += [P('Idea que debe quedar clara','H2'),P('El objetivo no fue probar todas las funciones de OpenCart. El objetivo fue construir un proceso de pruebas trazable: requisito, condición, caso, resultado y hallazgo.')]
expo += [P('2. Planificación','H1'),P('Granit puede explicar:','H2'),P('Definimos qué se incluye y qué queda fuera, los criterios para iniciar y terminar una prueba, los recursos, el esfuerzo, el cronograma y las causas de suspensión. El nivel principal fue sistema, porque trabajamos sobre el demo desplegado. La integración entre el sitio público y el panel se evaluó mediante su comportamiento visible; no tuvimos acceso a código para pruebas de componente.','Call')]
expo += [P('Puntos para mencionar','H2'),T(['Tema','Explicación breve'],[
('Alcance','Ocho funcionalidades, tres requisitos no funcionales y dos casos complementarios de prioridad Media.'),('Entrada','Acceso disponible, caso definido, datos verificados y precondiciones presentes.'),('Salida','Plan, trazabilidad, casos y resultados registrados; los bloqueos se informan por separado.'),('Suspensión','Falta de permiso, datos, pago, instrumento o estabilidad del demo.'),('Reanudación','Restablecer la precondición y repetir el caso sin sobrescribir la evidencia anterior.')],[100,390])]
expo += [PageBreak(),P('3. Riesgos y trazabilidad','H1'),P('Franco puede explicar:','H2'),P('Evaluamos cada riesgo con probabilidad e impacto. Los riesgos con exposición alta recibieron casos de prioridad Alta. Por ejemplo, el riesgo R03 de cálculos monetarios se relaciona con CT-CAR-01 y CP-CAR-01. Así podemos responder por qué se probó primero el carrito y qué evidencia respalda el hallazgo.','Call')]
expo += [T(['Cadena','Ejemplo'],[
('Requisito','E-RF03: cambiar la cantidad recalcula el total.'),('Riesgo','R03: importes de línea, impuestos o total inconsistentes.'),('Condición','CT-CAR-01: una cantidad válida actualiza todos los importes.'),('Caso','CP-CAR-01: cambiar iPod Nano de 1 a 2.'),('Resultado','La línea mostró 242, mientras el total general mostró 244.'),('Hallazgo','DEF-01: total de línea inconsistente al aumentar la cantidad.')],[105,385]),Spacer(1,10)]
expo += [P('4. Técnicas de diseño','H1'),P('No basta con enumerar técnicas; conviene explicar por qué se usó cada una:')]
expo += [T(['Técnica','Ejemplo del proyecto','Cómo explicarla'],[
('Partición de equivalencia','CP-PRO-01 y CP-CUP-01','Se elige un representante de una clase válida o inválida que debería recibir el mismo tratamiento.'),('Valores límite','CP-CAR-02','Se prueba alrededor de la frontera: 0/1 y stock S/S+1.'),('Tabla de decisión','CP-CUP-02 y CP-ADM-01','El resultado depende de varias condiciones combinadas.'),('Transición de estados','CP-CON-02 y reaplicación de cupón','Se comprueba qué ocurre cuando se repite una acción después de cambiar de estado.'),('Caso de uso','CP-CON-01 y CP-PED-01','Se valida el recorrido completo desde la acción del cliente hasta su resultado operativo.')],[110,130,250]),Spacer(1,10)]
expo += [P('5. Bloque de Franco','H1'),P('Franco debe presentar cuatro resultados concretos:','H2')]
expo += [T(['Función','Qué se diseñó','Qué ocurrió'],[
('Catálogo','Orden por nombre y precio.','El precio pasó en ambos sentidos para 12 productos.'),('Producto','Omisión de opción y selección válida con variación de precio.','La omisión pasó; el positivo quedó bloqueado porque las opciones no tenían alternativas completas.'),('Carrito','Cantidad válida, entradas inválidas y frontera de stock.','El recálculo falló por la diferencia 242/244; 147 fue aceptado y 148 bloqueó el checkout.'),('Cupones','Cupón válido, inválido, no aplicable y duplicado.','Los códigos inválidos se rechazaron; el positivo y la duplicación quedaron bloqueados porque no había un cupón vigente.')],[85,190,215]),Spacer(1,10)]
expo += [P('Cómo explicar DEF-01','H2'),P('Con una unidad, el precio y la línea fueron 122. Con dos unidades, el precio unitario siguió siendo 122, la línea mostró 242 y el total general 244. El resultado esperado era una línea de 244 cuando se compara con el precio unitario mostrado bajo la misma base fiscal. Registramos el comportamiento como defecto, pero no afirmamos una causa de código porque no tuvimos acceso a la implementación.','Call')]
expo += [P('6. Bloque de Granit','H1'),P('Granit puede explicar:','H2'),P('El checkout invitado validó correctamente el apellido obligatorio, pero no ofreció un método de pago. Eso hizo fallar CP-CHK-01 y bloqueó la creación de una orden, la prevención de duplicados, la consulta del pedido en administración y la medición de sincronización. La prueba de cambio administrativo también quedó bloqueada porque el usuario demo no tenía permiso de modificación.','Call')]
expo += [P('RNF-03','H2'),P('El requisito exige que el catálogo responda en menos de dos segundos. El caso define 18 muestras, separando navegaciones frías y cálidas y registrando la métrica de carga completa. Como no se contó con datos instrumentales verificables, el veredicto es Bloqueado. No se utilizó el tiempo de una acción del navegador como sustituto de una medición de rendimiento.')]
expo += [P('7. Resultados globales','H1'),T(['Indicador','Valor','Cómo decirlo'],[
('Casos diseñados','18','Supera el mínimo de 15 y cubre más de cuatro funcionalidades.'),('Casos de prioridad Alta','14','Todos tienen registro de resultado.'),('Pasó','3','Orden por precio, omisión de opción y control de cantidades/frontera.'),('Falló','2','Recálculo monetario y checkout invitado.'),('Bloqueado','9','Faltaron datos, permisos, pago, orden propia o instrumentación.'),('Prioridad Media','4','Quedaron diseñados y no se ejecutaron, conforme a la selección por prioridad.')],[145,70,275]),Spacer(1,10)]
expo += [P('Frase de cierre sugerida','H2'),P('El informe cumple el proceso solicitado y deja trazabilidad de cada decisión. Los resultados muestran tres comportamientos conformes, dos fallos y nueve bloqueos que necesitan un ambiente adecuado para reejecutarse. Por eso no recomendamos declarar el sistema listo para producción, pero sí consideramos que el plan y el diseño permiten continuar de manera controlada.','Call')]
expo += [PageBreak(),P('8. Preguntas probables y respuestas','H1')]
qa=[
('¿Por qué hay tantos bloqueados?','Porque el demo no proporcionó algunas precondiciones: opciones válidas, cupón vigente, método de pago, permisos e instrumentación. Un bloqueo se informa cuando no puede evaluarse el comportamiento; no se transforma en aprobado ni en fallo.'),
('¿Por qué CP-CUP-02 está bloqueado si probaron códigos inválidos?','El caso contiene varias reglas. Pasaron las variantes inexistente y vencida, pero no se pudieron ejecutar no aplicable, duplicada y revalidación porque requieren un cupón válido. El caso completo queda Bloqueado.'),
('¿Por qué CP-CAR-02 pasó si normaliza 1.5 y vacío?','El oráculo mínimo exigía que una cantidad inválida no quedara comprable. Las entradas se normalizaron o retiraron la línea. La falta de mensaje se registró como observación de usabilidad, no como fallo contra una regla que no estaba definida.'),
('¿Cuál es la diferencia entre severidad y prioridad?','Severidad estima el impacto del problema en el sistema o negocio. Prioridad indica la urgencia con la que conviene atenderlo. Un problema puede tener impacto alto y una prioridad distinta según el contexto.'),
('¿Por qué no probaron componente?','No se dispone del código ni de aislamiento de unidades. El nivel principal es sistema. Las pruebas de componente se recomiendan para cálculos monetarios en un ambiente del desarrollador.'),
('¿Por qué no aceptan 1932 ms como prueba de RNF-03?','Una cifra aislada no identifica caché, red, navegador ni evento medido. El caso exige datos instrumentales y varias muestras para que el resultado sea reproducible.'),
('¿DEF-01 puede ser Eco Tax?','Puede ser una hipótesis, pero no es una causa confirmada. La evidencia sólo demuestra la diferencia entre el precio unitario, la línea y el total.'),
('¿Un producto agotado con Add to Cart activo siempre es defecto?','No necesariamente. El requisito permite reflejar el agotamiento mediante aviso o bloqueo posterior. Debe considerarse la política Stock Checkout y comprobar si el checkout permite completar la compra.'),
('¿Qué automatizarían primero?','CP-CAR-01 por el riesgo monetario, CP-CAT-02 por ser estable y repetitivo, CP-PRO-01 por su validación determinista y CP-CAR-02 en un ambiente donde el stock pueda fijarse y restaurarse.'),
('¿El informe demuestra que OpenCart es apto para producción?','No. Los fallos monetarios y de checkout, junto con nueve casos bloqueados, impiden recomendarlo. El informe demuestra el estado observado y qué falta reejecutar.')]
expo += [T(['Pregunta','Respuesta recomendada'],qa,[175,315]),Spacer(1,10)]
expo += [P('9. Evidencias que conviene mostrar','H1'),T(['Orden','Evidencia','Mensaje'],[
('1','CP-CAT-02 ascendente y descendente','El conjunto se conserva y el precio sigue el criterio seleccionado.'),('2','CP-PRO-01 resultado','El sistema identifica Select required y no agrega el producto.'),('3','CP-CAR-01 cantidad 1 y cantidad 2','La comparación visual permite ver 122, 242 y 244.'),('4','CP-CAR-02 stock 147 y 148','S es aceptado; S+1 se marca con *** y el checkout regresa al carrito.'),('5','Cupones no vigentes y error visible','El bloqueo del positivo y el rechazo del inválido tienen evidencia distinta.'),('6','Checkout sin pago','El mensaje de ausencia de pago explica los casos dependientes bloqueados.')],[45,170,275]),Spacer(1,10)]
expo += [P('10. Recomendaciones para hablar con claridad','H1')]
expo += [P('Usar “observamos” para resultados y “esperábamos” para oráculos. Decir “bloqueado por falta de precondición” en vez de “falló el sistema” cuando no pudo ejecutarse. No presentar hipótesis como causas confirmadas. Dar cifras sólo cuando pueda explicarse su denominador. Evitar leer tablas completas: mostrar una cadena de trazabilidad y uno o dos hallazgos representativos.')]
expo += [P('Conceptos que deben dominar','H2'),T(['Concepto','Definición breve'],[
('Condición de prueba','Aspecto verificable que se deriva de la base de pruebas.'),('Caso de prueba','Precondiciones, datos, pasos y resultado esperado para verificar una condición.'),('Oráculo','Fuente usada para decidir si el resultado es correcto.'),('Riesgo de producto','Posibilidad de que un fallo afecte la calidad o el negocio.'),('Bloqueado','El caso no puede completarse por una precondición o impedimento externo.'),('Confirmación','Repetir el caso que falló después de una corrección.'),('Regresión','Comprobar que el cambio no dañó funciones relacionadas.')],[120,370])]

def md_just():
    return '''# Justificación de cumplimiento del informe\n\nEl PDF de esta carpeta contiene la correspondencia detallada con el enunciado, la cobertura de los 11 requisitos y la alineación con los siete materiales de teoría revisados.\n\nConclusión: el informe final contiene planificación, estrategia, niveles, condiciones, trazabilidad, 18 casos, técnicas de caja negra, ejecución de los 14 casos Alta, hallazgos, evidencias y reflexión de automatización. Los nueve bloqueos mantienen pendiente la validación completa del producto, pero están registrados conforme a los veredictos solicitados.\n'''
def md_expo():
    return '''# Guía de exposición\n\nDuración sugerida: 10 a 12 minutos.\n\n1. Contexto y objetivo.\n2. Planificación y estrategia por riesgos.\n3. Trazabilidad requisito-condición-caso.\n4. Técnicas de diseño.\n5. Resultados del bloque de Franco.\n6. Resultados del bloque de Granit.\n7. Métricas, automatización y conclusión.\n8. Preguntas.\n\nEl PDF de esta carpeta incluye un guion por responsable, ejemplos, preguntas probables y las evidencias recomendadas.\n'''

HERE.mkdir(parents=True,exist_ok=True)
build(HERE/'Justificacion_Cumplimiento_Proyecto1_Caso3_Grupo5.pdf','Justificación de cumplimiento',just,'Justificación de cumplimiento | Proyecto 1 - Caso 3')
build(HERE/'Guia_Exposicion_Proyecto1_Caso3_Grupo5.pdf','Guía para la exposición',expo,'Guía de exposición | Proyecto 1 - Caso 3')
(HERE/'Justificacion_Cumplimiento_Proyecto1_Caso3_Grupo5.md').write_text(md_just(),encoding='utf-8')
(HERE/'Guia_Exposicion_Proyecto1_Caso3_Grupo5.md').write_text(md_expo(),encoding='utf-8')
print('generados',len(just),len(expo))

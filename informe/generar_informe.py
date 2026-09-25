"""Fuente editorial reproducible del informe integrado. Requiere reportlab, pypdf, Pillow."""
from pathlib import Path
import json, shutil, hashlib, re, csv, io
from xml.sax.saxutils import escape
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Image, KeepTogether
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from pypdf import PdfReader, PdfWriter
from PIL import Image as PILImage

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'informe'
HIST=ROOT/'historial'/'version_20260924'
if not HIST.exists():
    for f in list(ROOT.rglob('*')):
        if f.is_file() and 'historial' not in f.parts and f.suffix in ('.md','.typ','.csv','.pdf') and f.name!='generar_informe.py':
            dst=HIST/f.relative_to(ROOT); dst.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(f,dst)

REQ=[
('E-RF01','FUN-01','Ordenar el listado por nombre y precio correctamente.'),
('E-RF02','FUN-02','Exigir las opciones del producto antes de agregarlo al carrito.'),
('E-RF03','FUN-03','Recalcular correctamente el total al cambiar cantidades.'),
('E-RF04','FUN-04','Validar el cupón, aplicar el descuento correcto y mostrar error para código inválido.'),
('E-RF05','FUN-05','Completar checkout como invitado sin obligar a registrar cuenta.'),
('E-RF06','FUN-06','Generar número de orden y resumen correcto al confirmar.'),
('E-RF07','FUN-08','Reflejar el pedido del sitio público en la lista administrativa.'),
('E-RF08','FUN-07','Reflejar públicamente el producto marcado agotado desde administración; por ejemplo, aviso o impedimento de compra.'),
('E-RNF01','RNF-01','Reflejar cambios del sitio público en administración en tiempo razonable, sin reinicios.'),
('E-RNF02','RNF-02','Funcionar correctamente en los navegadores más usados.'),
('E-RNF03','RNF-03','Tiempo de respuesta del catálogo estrictamente menor que dos segundos.')]
RISK=[
('R01','Inventario divergente entre ficha, carrito y panel',3,3,'Franco / Granit','CP-CAR-02; CP-ADM-01','Verificar S y S+1; contrastar estado guardado con sitio público.'),
('R02','Cupón válido rechazado o descuento incorrecto',3,3,'Franco','CP-CUP-01; CP-CUP-02','Confirmar vigencia, estado, elegibilidad, base y tipo de descuento antes de probar.'),
('R03','Importes de línea, impuestos o total inconsistentes',3,3,'Franco / Granit','CP-CAR-01; CP-PRO-02; CP-CON-01','Comparar magnitudes con igual tratamiento fiscal y recalcular a dos decimales.'),
('R04','Compra con opción obligatoria ausente o distinta',2,3,'Franco','CP-PRO-01; CP-PRO-02','Omitir campo aislado; comparar opción elegida y conservada en carrito.'),
('R05','Venta por encima de stock real',3,3,'Franco / Granit','CP-CAR-02; CP-ADM-01','Leer stock actual y política; no equiparar botón activo a venta completada.'),
('R06','Acumulación indebida o permanencia de descuentos',2,3,'Franco','CP-CUP-02','Reaplicar código y cambiar elegibilidad; exigir una sola aplicación.'),
('R07','Checkout invitado no completado',3,3,'Granit','CP-CHK-01; CP-CON-01','Validar campos, pago disponible y confirmación sin cuenta.'),
('R08','Pedido perdido o duplicado en administración',2,3,'Granit','CP-CON-02; CP-PED-01; CP-RNF-01','Usar orden propia, contar coincidencias y medir público a panel.'),
('R09','Catálogo lento o precio ordenado incorrectamente',2,3,'Franco / Granit','CP-CAT-02; CP-RNF-03','Secuencia de precios de venta y medición instrumentada del catálogo.'),
('R10','Incompatibilidad en navegador seleccionado',2,2,'Granit','CP-RNF-02','Diseño común en Chrome, Edge y Firefox; no generalizar un motor a los demás.'),
('R11','Orden por nombre o filtros confusos',2,2,'Franco','CP-CAT-01; CP-CAT-03','Comparar conjuntos y orden; vacíos y filtros sin resultados.'),
('R12','Certificado de regalo aceptado indebidamente',1,3,'Franco','CP-VAL-01','Verificar saldo y vigencia; no probar certificados ajenos.')]
# Condiciones de la línea base v2. Los ID históricos quedan en el anexo, no se suman a esta matriz.
COND=[
('CT-CAT-01','E-RF01','Directa','Orden correcto por nombre en ambos sentidos.','Media','R11','CP-CAT-01','Afecta localización; impacto monetario indirecto.'),
('CT-CAT-02','E-RF01','Directa','Precios de venta monótonos, mismos productos, ascendente y descendente.','Alta','R09','CP-CAT-02','Un orden incorrecto distorsiona la comparación económica de productos.'),
('CT-CAT-03','Alcance p.4','Derivada','Categoría/filtro limita el conjunto y comunica resultado vacío.','Media','R11','CP-CAT-03','Cobertura complementaria del catálogo.'),
('CT-PRO-01','E-RF02','Directa','Omisión aislada de opción requerida impide añadir y señala el campo.','Alta','R04','CP-PRO-01','Evita pedidos de variantes incompletas o imposibles de preparar.'),
('CT-PRO-02','E-RF02','Derivada','Selección válida se conserva y se añade una sola línea correcta.','Alta','R04','CP-PRO-02','La variante comprada determina qué se entrega.'),
('CT-PRO-03','E-RF02 / E-RF03','Derivada','El ajuste de precio de opción coincide con configuración y política fiscal.','Alta','R03','CP-PRO-02','El error altera el importe cobrado.'),
('CT-CAR-01','E-RF03','Directa','Cantidad válida actualiza línea, subtotal, impuestos y total coherentemente.','Alta','R03','CP-CAR-01','Discrepancias monetarias afectan directamente al cliente.'),
('CT-CAR-02','E-RF03','Derivada','Cero, negativo, decimal, texto y vacío no dejan cantidades inválidas comprables.','Alta','R03','CP-CAR-02','Evita totales o unidades imposibles; normalizaciones se registran aparte.'),
('CT-CAR-03','E-RF08 / riesgo p.5','Derivada','S es admisible y S+1 señala insuficiencia; bloqueo según política de stock.','Alta','R05','CP-CAR-02','La sobreventa es una queja central del caso.'),
('CT-CUP-01','E-RF04','Directa','Código vigente y elegible aplica el descuento correcto una vez.','Alta','R02','CP-CUP-01','Protege el margen comercial y el importe final.'),
('CT-CUP-02','E-RF04','Directa','Código inexistente, vencido o deshabilitado muestra error sin descuento nuevo.','Alta','R02','CP-CUP-02','Una aceptación indebida reduce el ingreso sin autorización comercial.'),
('CT-CUP-03','E-RF04','Derivada','Cupón vigente pero no elegible se rechaza sin descuento.','Alta','R02','CP-CUP-02','Impide extender promociones a productos no cubiertos.'),
('CT-CUP-04','Riesgo p.5','Derivada','Reaplicar el mismo cupón no acumula el descuento.','Alta','R06','CP-CUP-02','La duplicación de descuentos es riesgo expreso del caso.'),
('CT-CUP-05','E-RF04','Derivada','Cambiar cantidad/productos revalida mínimo y elegibilidad.','Alta','R06','CP-CUP-02','Evita conservar beneficios cuando desaparece su precondición.'),
('CT-CUP-06','Alcance p.4','Derivada','Certificado válido respeta saldo y certificado inválido no descuenta.','Media','R12','CP-VAL-01','Complemento de alcance; sin evidencia de exposición alta en esta corrida.'),
('CT-CHK-01','E-RF05','Directa','Invitado avanza sin crear cuenta ni imponer contraseña.','Alta','R07','CP-CHK-01; CP-CON-01','Es el recorrido de compra exigido por el caso.'),
('CT-CHK-02','E-RF05','Derivada','Apellido obligatorio vacío se identifica; datos válidos se guardan.','Alta','R07','CP-CHK-01','Datos incompletos comprometen el procesamiento del pedido.'),
('CT-CHK-03','E-RF05','Derivada','Hay método de pago aplicable antes de confirmar.','Alta','R07','CP-CHK-01','Su ausencia interrumpe el flujo crítico.'),
('CT-CON-01','E-RF06','Directa','Confirmación genera un identificador de orden no vacío.','Alta','R08','CP-CON-01','Sin identificador no hay seguimiento confiable.'),
('CT-CON-02','E-RF06','Directa','Resumen confirmado conserva productos, opciones, cantidades e importes.','Alta','R03','CP-CON-01','Evita divergencias entre intención de compra y pedido.'),
('CT-CON-03','E-RF06','Derivada','Doble clic, recarga y retorno no crean pedidos adicionales.','Alta','R08','CP-CON-02','Evita cobro y preparación duplicados.'),
('CT-PED-01','E-RF07','Directa','Orden propia aparece en panel con igual ID y detalle.','Alta','R08','CP-PED-01','Una orden invisible impide su atención operativa.'),
('CT-ADM-01','E-RF08','Directa','Stock cero guardado y estado agotado se reflejan en interfaz pública.','Alta','R01 / R05','CP-ADM-01','Evita anunciar disponibilidad contradictoria al inventario confirmado.'),
('CT-RNF-01','E-RNF01','Operacionalizada','Orden pública se refleja en panel sin reinicio; medir contra referencia interna de 60 s.','Alta','R08','CP-RNF-01','La demora puede causar pérdida de atención o reintentos.'),
('CT-RNF-02','E-RNF02','Operacionalizada','Mismo recorrido funciona en Chrome, Edge y Firefox seleccionados.','Media','R10','CP-RNF-02','Se prioriza después de los riesgos transaccionales comunes.'),
('CT-RNF-03','E-RNF03','Operacionalizada','Carga completa de catálogo inferior a 2000 ms bajo protocolo declarado.','Alta','R09','CP-RNF-03','La lentitud afecta la operación de entrada al flujo de compra.')]

CASES=[]
def case(id,title,owner,priority,conditions,req,tech,why,pre,data,steps,expected):
    CASES.append(dict(id=id,title=title,owner=owner,priority=priority,conditions=conditions,req=req,tech=tech,why=why,pre=pre,data=data,steps=steps,expected=expected))
case('CP-CAT-01','Ordenamiento por nombre','Franco','Media','CT-CAT-01','E-RF01','Partición de equivalencia','Se comparan las clases A-Z y Z-A, incluyendo empate sin exigir un desempate no especificado.',
'Categoría accesible con al menos dos nombres distintos; idioma inglés; registrar listado completo y número de páginas.',
'Desktops; mostrar25 (12 productos observados como referencia, recapturar en nueva corrida).',
['Abrir categoría y guardar conjunto inicial de nombres.','Seleccionar Name (A - Z); leer todas las páginas o mostrar todos.','Comparar nombres consecutivos; registrar empates.','Seleccionar Name (Z - A) y repetir; comparar conjunto final con inicial.'],
'Orden lexicográfico correcto en ambos sentidos para nombres de la muestra; sin pérdidas ni duplicados. No ejecutado por prioridad Media.')
case('CP-CAT-02','Ordenamiento por precio','Franco','Alta','CT-CAT-02','E-RF01','Partición de equivalencia','Ascendente y descendente son clases del criterio; se incluyen precios iguales y promociones.',
'Catálogo disponible, misma moneda USD y al menos dos precios distintos. Usar precio vigente, no precio tachado.',
'Desktops; Show25; 12 productos. Referencias: Canon98, Apple110, HP122, HTC122, iPodClassic122, Product8 122, iPhone123.20, Samsung242, Palm337.99, MacBook602, MacBookAir1202, Sony1202.',
['Abrir Desktops, seleccionar Show25 y anotar productos/precios.','Seleccionar Price (Low > High); comparar cada precio con el siguiente.','Capturar lista y criterio.','Seleccionar Price (High > Low); repetir y comprobar igualdad del conjunto.'],
'Ascendente no decrece; descendente no crece; los12 productos se conservan. Empates permitidos. Precio especial98 de Canon se ordena por98, no por122.')
case('CP-PRO-01','Omisión de opción obligatoria','Franco','Alta','CT-PRO-01','E-RF02','Partición de equivalencia','Una opción requerida ausente representa la clase inválida; se aísla de otros campos.',
'Carrito vacío; producto con una opción obligatoria identificada; resto de datos válido. Registrar si carece de alternativas válidas, sin confundirlo con la validación de ausencia.',
'Canon EOS5D, Select sin elegir, cantidad1. El25/09 sólo se ofreció el placeholder.',
['Abrir ficha; identificar campo requerido y contador del carrito.','Dejar Select sin seleccionar, cantidad1 y pulsar Add to Cart una vez.','Esperar respuesta, registrar mensaje y verificar que el carrito permanece vacío.'],
'No se añade el producto y el mensaje identifica Select. No demuestra que existan opciones válidas ni valida su precio.')
case('CP-PRO-02','Opciones válidas y variación de precio','Franco','Alta','CT-PRO-02; CT-PRO-03','E-RF02 / E-RF03 derivados','Partición de equivalencia','Comparar opción sin recargo y con recargo manteniendo constantes producto, cantidad e impuestos.',
'Producto con todas las opciones requeridas seleccionables, stock suficiente y ajuste fiscalmente interpretable; carrito limpio. Registrar precio base, ajuste y si incluye impuestos antes de ejecutar.',
'Candidato Apple Cinema30: Select Blue +5.60, Green +3.20 y Checkbox3 +38 mostrados; faltan alternativas Radio. Alternativos Canon y Product8 tampoco tienen opciones seleccionables. Datos válidos completos pendientes de provisión.',
['Verificar todas las alternativas requeridas; si alguna falta, registrar bloqueo sin inventar selección.','En ambiente habilitado, completar opciones válidas y añadir una unidad o el mínimo del producto.','Comparar opciones y precio en carrito contra base más ajustes con igual criterio fiscal.','Vaciar, cambiar sólo una opción de recargo conocido y repetir.'],
'Cada configuración agrega exactamente lo solicitado; diferencia de precio corresponde al ajuste configurado e impuestos aplicables. Sin alternativas o regla fiscal verificable: Bloqueado.')
case('CP-CAR-01','Actualización de cantidad válida','Franco','Alta','CT-CAR-01','E-RF03','Partición de equivalencia','Se verifica una cantidad válida antes y después del cambio; se separa importe neto del gravado.',
'Carrito limpio, iPodNano disponible sin opciones, sin cupón ni envío aplicado; cantidad2 dentro de stock.',
'USD; iPodNano1 y2. Referencia: base100, precio mostrado122, EcoTax2/unidad, VAT20/unidad.',
['Añadir1 iPodNano y guardar unitario, línea, subtotal, impuestos y total.','Cambiar cantidad a2 y pulsar actualizar; esperar respuesta.','Recalcular línea usando unitario mostrado por cantidad cuando ambos representan la misma base fiscal.','Comparar subtotal200, EcoTax4, VAT40 y total244; registrar cualquier discrepancia de línea.'],
'Para los datos observados:1 unidad línea122 total122;2 unidades línea244 total244, neto200 y tributos44. Si la interfaz usa otra base fiscal debe explicitarla; no comparar línea gravada con subtotal neto.')
case('CP-CAR-02','Cantidad inválida o superior al stock','Franco','Alta','CT-CAR-02; CT-CAR-03','E-RF03 / E-RF08 derivados','Partición de equivalencia y valores límite','Clases inválidas y frontera real del inventario:0,1 y S,S+1. Los tiempos1999/2000/2001 no se presentan como datos ejecutados.',
'Stock S leído en panel; producto sin opciones; carrito de prueba; anotar política de venta sin stock si es accesible. Restablecer una unidad entre variantes destructivas; verificar que S no cambió por terceros.',
'iPod Nano: stock S = 147 observado el 25/09; variantes 0, -1, 1.5, abc, vacío, 147 y 148.',
['Con1 unidad, probar por separado0,-1,1.5,abc y vacío; actualizar y registrar cantidad persistida, avisos y total. Reponer1 antes de cada variante.','Fijar147; comprobar ausencia de marca de insuficiencia.','Fijar148; comprobar advertencia y pulsar Checkout.','Registrar si el sistema impide la compra; no generar pedidos con unidades inválidas. Limpiar carrito.'],
'Ninguna cantidad negativa, fraccionaria o no numérica queda comprable. Cero puede retirar línea. Normalización silenciosa se informa como observación. Con política restrictiva S+1 debe bloquear checkout y S no debe marcar insuficiencia. La aritmética monetaria se juzga en CP-CAR-01; no se declara compra de147 completada.')
case('CP-CUP-01','Aplicación de cupón válido','Franco','Alta','CT-CUP-01','E-RF04','Partición de equivalencia','Representante de código vigente, activo y elegible; oráculo calculado antes de aplicar.',
'Cupón activo, fechas vigentes, usos disponibles, condiciones de login/mínimo y productos verificadas; carrito elegible. Registrar tipo, valor y base antes de probar.',
'Candidato 2222, descuento de 10 por ciento según el panel: el 25/09 estaba deshabilitado y vencido desde el 01/01/2020. Para ejecutar el caso se requiere un cupón activo, vigente y con condiciones conocidas.',
['Leer configuración vigente y registrar elegibilidad. Si no hay cupón válido, documentar bloqueo.','Con fixture válido, registrar subtotal e impuestos iniciales.','Aplicar código una vez y registrar línea de descuento y total.','Calcular descuento sobre base elegible; si base100 y10%, descuento neto10; recalcular impuestos según configuración verificada.'],
'Una aplicación, descuento exacto según tipo/valor y base; total nunca negativo y tributos coherentes. No fijar total final usando una política fiscal desconocida.')
case('CP-CUP-02','Cupón inválido, no aplicable o duplicado','Franco','Alta','CT-CUP-02; CT-CUP-03; CT-CUP-04; CT-CUP-05','E-RF04 y riesgo de duplicación','Tabla de decisión y transición de estados','Cruza validez/elegibilidad y modela sin cupón -> aplicado -> reaplicado -> carrito cambiado.',
'Carrito iPodNano1 sin descuento. Para variantesC-D-E, cupón válido de CP-CUP-01, restricciones y mínimo conocidos. Reiniciar estado entre variantes independientes.',
'A:QA-NO-EXISTE-20260924; B:2222 vencido/deshabilitado; C:cupón vigente limitado a otro producto; D:mismo cupón dos veces; E:retirar producto elegible o bajar del mínimo.',
['A:aplicar código inexistente; guardar error y total.','B:aplicar2222 y contrastar con estado leído en panel.','C:con cupón válido, usar carrito no elegible y aplicar.','D:restablecer carrito elegible, aplicar una vez y reaplicar; comparar descuento.','E:cambiar elegibilidad y actualizar; verificar retiro/recalculo del beneficio.'],
'A/B/C:error y ningún descuento nuevo. D:descuento único no acumulado. E:descuento revalidado. Si C-D-E carecen de cupón válido, registrar variantes Bloqueadas y no aprobar todo el caso.')
case('CP-CHK-01','Checkout invitado hasta pago','Granit','Alta','CT-CHK-01; CT-CHK-02; CT-CHK-03','E-RF05','Partición de equivalencia','Campo vacío y completo; identidad invitada válida sin contraseña.',
'Carrito con iPodNano disponible; sin sesión de cliente; dirección ficticia; no suscribirse al boletín.',
'Test / QA CS5383 / qa.cs5383.test@example.com; Av.Prueba123, London, SW1A1AA, UnitedKingdom, GreaterLondon.1 unidad en corrida25/09;2 en historial24/09.',
['Abrir Checkout y seleccionar Guest Checkout.','Completar todo excepto apellido y pulsar Continue; registrar validación.','Completar apellido y continuar; verificar datos guardados sin registro.','Pulsar Choose en Payment Method; registrar opciones o error.','Si hay pago aplicable, dejar preparado para CP-CON-01; no declarar orden confirmada en este caso.'],
'Apellido vacío produce error específico; datos completos se guardan sin cuenta y existe método aplicable para continuar. La confirmación final de E-RF05 se verifica en CP-CON-01. Sin pago aplicable se registra fallo de este recorrido, sin inferir causa raíz ni fallo para todo cliente.')
case('CP-CON-01','Número y resumen del pedido','Granit','Alta','CT-CON-01; CT-CON-02; CT-CHK-01','E-RF06 / E-RF05','Prueba de caso de uso','Verificación de extremo a extremo desde intención de compra hasta orden confirmada.',
'CP-CHK-01 llega a pago y envío aplicables; sin advertencias; entorno de demostración y datos ficticios. Si falta pago, Bloqueado.',
'Pedido propio; capturar producto, opciones, cantidad y desglose actual. No fijar244 si hay envío u otro impuesto. Para2 Nano sin envío, referencia neto200 +eco4 +VAT40 =244.',
['Capturar resumen previo con todas las líneas e importes.','Verificar suma neto+impuestos+envío-descuentos y coherencia de cada línea.','Confirmar una vez; registrar número de orden y mensaje.','Comparar productos, opciones, cantidades y total antes/después; comprobar que siguió siendo invitado.'],
'Identificador no vacío; resumen confirmado idéntico a intención válida; importe de línea se compara con unitario de igual base fiscal, nunca con neto200 de forma automática. E-RF05 completo sólo si la orden final existe.')
case('CP-CON-02','Prevención de pedidos duplicados','Granit','Alta','CT-CON-03','E-RF06 derivado','Transición de estados','Modela carrito preparado -> orden creada -> reintento sin nueva orden.',
'Checkout funcional, permiso de lectura de Orders y datos propios identificables. Preparar una compra independiente para cada variante.',
'Tres carritos de prueba distinguibles con comentarioQA-G5-A/B/C y correo ficticio; capturar número previo de órdenes de cada intención.',
['VarianteA:doble clic en Confirm Order y consultar todas las órdenes de esa intención en panel.','VarianteB:confirmar otra compra una vez, recargar su confirmación y volver a contar órdenes.','VarianteC:confirmar otra compra, volver atrás e intentar confirmar de nuevo; consultar panel.','Comparar IDs, cantidades e importes; no usar pedidos de terceros como prueba.'],
'Exactamente una orden por intención en cada variante. Una pantalla con el mismo ID no basta para descartar duplicados en administración.')
case('CP-ADM-01','Agotado en panel reflejado públicamente','Granit','Alta','CT-ADM-01','E-RF08','Tabla de decisión','Cruza stock0/positivo y política de compra sin stock, distinguiendo aviso de bloqueo.',
'Permiso de escritura sobre producto de prueba dedicado, lectura de política Stock Checkout y posibilidad de restaurar. No alterar configuración global de un demo compartido sin ambiente reservado.',
'Producto dedicado equivalente a HP LP3065; guardar stock, etiqueta y configuración previos. R1:S0/OutOfStock/políticaNo; R2:S0/OutOfStock/políticaSí; R3:S>=cantidad/InStock.',
['Registrar política efectiva y datos previos.','Guardar stock0 y etiquetaOutOfStock; verificar persistencia reabriendo. Si permiso denegado, parar y registrar Bloqueado.','Abrir ficha pública y carrito; comprobar aviso de agotado.','Intentar checkout conforme a fila aplicable; R1 bloquea, R2 puede admitir con aviso.','En entorno controlado, repetir otras filas configurables; restaurar datos y verificar.'],
'El estado agotado guardado se refleja públicamente. El requisito original admite aviso o impedimento; no exige siempre deshabilitar Add to Cart. Sin permisos no se declara fallo de propagación ni ejecución de las tres reglas.')
case('CP-PED-01','Pedido público visible en panel','Granit','Alta','CT-PED-01','E-RF07','Prueba de caso de uso','La comparación atraviesa las dos interfaces con la misma orden propia.',
'CP-CON-01 produjo ID propio; lectura de Sales>Orders.',
'ID y resumen de esa orden; no un ID encontrado al azar en el demo.',
['Abrir Sales>Orders y filtrar por ID propio.','Abrir detalle y cotejar cliente ficticio, productos, opciones, cantidades, impuestos y total.','Guardar captura pública y administrativa y registrar diferencias.'],
'Orden presente con mismoID y detalle; sin orden propia, Bloqueado. Pedidos ajenos no satisfacen la condición.')
case('CP-RNF-01','Tiempo de actualización público a administración','Granit','Alta','CT-RNF-01','E-RNF01','Transición de estados y medición temporal','Orden confirmada públicamente -> visible en panel; dirección correcta del enunciado.',
'Orden propia realizable y reloj común; acceso de lectura al panel; referencia interna60s adoptada por este plan, pendiente de validación docente/negocio.',
'ID de CP-CON-01; t0 confirmación pública; consultas del panel cada5s hasta60s.',
['Registrar t0 al confirmarse la orden en sitio público.','Sin reiniciar servicios, consultar panel cada5s por ID.','Registrar instante de primera aparición y consulta anterior; reportar intervalo de latencia.','Comparar contra60s como referencia interna, conservando el dato bruto.'],
'Orden visible sin reinicios; latencia reportada con resolución5s. <=60s cumple referencia interna, no un umbral literal del enunciado. No sustituir por cambio de stock admin->público, cubierto en CP-ADM-01.')
case('CP-RNF-02','Compatibilidad en navegadores','Granit','Media','CT-RNF-02','E-RNF02','Partición de equivalencia','Muestra por motor y aplicación:Chrome/Edge(Chromium),Firefox(Gecko). No prueba todos los navegadores populares.',
'Instalaciones disponibles, versiones exactas anotadas, mismas condiciones de red/datos y sesiones limpias.',
'Chrome,Edge,Firefox de escritorio; catálogoDesktops, Nano1 y datos invitados del casoCHK.',
['Anotar versión, sistema y tamaño de ventana en cada navegador.','Recorrer catálogo, ficha, carrito y checkout sin cambiar datos entre navegadores.','Comparar renderizado y validaciones; separar fallos comunes del demo de incompatibilidad específica.'],
'Flujo equivalente sin fallos atribuibles al navegador; alcance de muestra explícito. Diseñado, no seleccionado para nueva ejecución por prioridadMedia.')
case('CP-RNF-03','Tiempo de respuesta del catálogo','Granit / Franco','Alta','CT-RNF-03','E-RNF03','Medición de rendimiento con umbral','No se considera análisis de valores límite ejecutado: no se controlaron tiempos1999/2000/2001 como entradas.',
'Instrumentación NavigationTiming/DevTools, registro exportable, red y equipo documentados, caché controlada. Sin instrumento verificable, Bloqueado.',
'Cameras,Desktops,Laptops&Notebooks; para cada una3 navegaciones frías y3 cálidas,18 muestras. Umbral<2000ms; métrica operacional loadEventEnd-startTime enms.',
['Anotar equipo, versión, red, URL, hora y caché.','Ejecutar secuencia de muestras con DevTools y conservar datos brutos de cada navegación.','Registrar loadEventEnd-startTime, TTFB y DOMContentLoaded como apoyo.','Calcular mínimo,mediana,p95,máximo; juzgar cada muestra contra2000ms. Separar desafíos de seguridad de carga del catálogo.'],
'Todas las muestras válidas del protocolo deben estar debajo de 2000 ms; 2000 ms exactos incumple. Se deben conservar los datos de cada medición y limitar la conclusión al ambiente evaluado.')
case('CP-CAT-03','Categoría y filtros del catálogo','Franco','Media','CT-CAT-03','Alcance funcional p.4','Partición de equivalencia','Conjunto con resultados y conjunto vacío.',
'Categorías accesibles; sólo aplicar filtros efectivamente configurados.',
'Desktops y subcategoríaPC; registrar conjunto esperado por membresía administrativa cuando sea accesible.',
['Abrir categoría y verificar pertenencia.','Aplicar subcategoría o filtro configurado; comparar productos con regla.','Elegir una combinación conocida sin resultados y comprobar mensaje.'],
'Resultados pertinentes y mensaje de vacío sin error técnico. Falta de filtros configurados se consigna como limitación de datos, no se inventa ejecución.')
case('CP-VAL-01','Certificados de regalo','Franco','Media','CT-CUP-06','Alcance funcional p.4','Tabla de decisión','Combina código existente/vigente y saldo suficiente/insuficiente.',
'Certificado de prueba dedicado con saldo conocido; sin fondos reales ni certificados de terceros; total y política fiscal documentados.',
'Fixture futuroQA-G5-VALE saldo10 y códigoQA-VALE-INVALIDO; total superior e inferior a10. No creados en este demo.',
['Registrar saldo y reglas del certificado.','Aplicar válido y comparar descuento y total no negativo.','Restablecer y aplicar inválido; comprobar error sin nuevo descuento.','Evaluar compra con total menor al saldo y documentar remanente según regla configurada.'],
'Sólo vale elegible descuenta; no se supera saldo ni aparece total negativo; saldo restante conforme a configuración. Diseñado, no ejecutado por prioridadMedia.')

RESULTS=[
('CP-CAT-02','Pasó','25/09','12 precios ascienden98..1202 y descienden1202..98; mismo conjunto.','CP-CAT-02_asc; CP-CAT-02_desc'),
('CP-PRO-01','Pasó','25/09','Canon muestra Select required! y mantiene carrito vacío.','CP-PRO-01_resultado'),
('CP-PRO-02','Bloqueado','25/09','Apple sin alternativasRadio; Canon y Product8 con selectores vacíos. No hay configuración completa para comparar precio.','PRO-APPLE; CP-PRO-02_bloqueo'),
('CP-CAR-01','Falló','25/09','1unidad:122/122.2unidades:unit122,línea242,total244. Diferencia2 en línea; DEF-01 reproducido.','CP-CAR-01_qty1; CP-CAR-01_qty2'),
('CP-CAR-02','Pasó','25/09','0,-1,abc retiran línea;1.5 y vacío quedan en1.147 sin***;148 con*** y checkout retorna carrito. Observación de normalización silenciosa; no demuestra corrección monetaria ni compra final.','CP-CAR-02_cero; decimal; negativo; texto; vacio; stock147; stockS; stockSmas1; stock-bloquea-checkout'),
('CP-CUP-01','Bloqueado','25/09','Los3 cupones del panel están deshabilitados y vencidos.2222 no es dato válido.','CP-CUP-01_cupones-no-vigentes'),
('CP-CUP-02','Bloqueado','25/09','A(inexistente) yB(vencido) pasan con aviso y total122. C(no elegible),D(duplicado),E(revalidación) bloqueadas por falta de cupón válido.','CP-CUP-02_error-visible; CP-CUP-02_vencido-error; CP-CUP-01_admin.txt'),
('CP-CHK-01','Falló','25/09','Apellido vacío validado; invitado completo guardado; Choose indica No Payment options are available. Confirm Order deshabilitado.','CP-CHK-01_apellido-vacio; CP-CHK-01_sin-pago'),
('CP-CON-01','Bloqueado','25/09','No hay pago seleccionable ni confirmación posible; no se generó ID propio.','CP-CHK-01_sin-pago'),
('CP-CON-02','Bloqueado','25/09','No existe primera orden de prueba; no se ensayaron reintentos de confirmación.','CP-CHK-01_sin-pago'),
('CP-ADM-01','Bloqueado','24/09','El panel denegó el guardado por falta de permisos. La captura demuestra el bloqueo, pero no un cambio persistido.','H-ADM permiso-modificar-productos'),
('CP-PED-01','Bloqueado','25/09','No hay orden propia para comparar con Orders.','CP-CHK-01_sin-pago'),
('CP-RNF-01','Bloqueado','25/09','Sin evento público de orden confirmada no puede medirse latencia público->panel.','CP-CHK-01_sin-pago'),
('CP-RNF-03','Bloqueado','25/09','No se contó con instrumentación de navegación exportable ni con datos brutos verificables para aplicar el protocolo definido.','Sin evidencia instrumental suficiente')]

FINDINGS=[
dict(id='DEF-01',title='Total de línea inconsistente al aumentar cantidad',kind='Defecto observable reproducido; causa raíz no confirmada',trace='E-RF03 -> CT-CAR-01 -> CP-CAR-01',severity='Alta',priority='Alta',steps='Añadir iPodNano1; abrir carrito; cambiar a2 y actualizar.',expected='122 por2 =244 en la línea, misma semántica fiscal; total general244.',actual='Línea242; unitario122; total244; subtotal200, EcoTax4 y VAT40. Reproducido25/09.',evidence='CP-CAR-01_qty1 / qty2; H-OC04',action='Revisar cálculo/presentación de línea, especialmente tasa fija por cantidad como hipótesis. Reprobar1,2 y frontera de stock tras corrección.'),
dict(id='DEF-04',title='Checkout invitado sin método de pago seleccionable',kind='Fallo del recorrido probado; configuración/causa en análisis',trace='E-RF05 -> CT-CHK-03 -> CP-CHK-01',severity='Crítica para el recorrido ensayado',priority='Alta',steps='Carrito Nano1; elegirGuest; completar dirección ficticiaUK/London; continuar; Choose enPaymentMethod.',expected='Método aplicable seleccionable que permita continuar.',actual='No Payment options are available. Please contact us for assistance! Confirm Order deshabilitado. Historial24/09 muestra COD habilitado enAllZones; no demuestra todas las condiciones de aplicabilidad.',evidence='CP-CHK-01_sin-pago; H-OC01,H-OC02,H-OC05',action='Investigar aplicabilidad, producto/envío/configuración y permisos. No afirmar que ningún cliente puede comprar ni que la causa sea sincronización.'),
dict(id='OBS-02',title='Disponibilidad de ficha no garantiza stock utilizable',kind='Observación; reemplaza clasificación automática de DEF-02',trace='E-RF08 -> CT-CAR-03 -> CP-CAR-02 (preparación)',severity='Alta potencial',priority='Alta de investigación',steps='AbrirHTC InStock; añadir1; abrir carrito; contrastar inventario administrativo0.',expected='Comunicación coherente del stock disponible.',actual='FichaInStock, carrito***; panel0. Una etiqueta de agotado configurada comoInStock puede explicar presentación. No hay venta sin stock demostrada.',evidence='CAR-precondicion-HTC; historial de configuración',action='Revisar etiquetaOutOfStockStatus y regla comercial antes de declarar defecto de código.'),
dict(id='OBS-03',title='Confirmación deshabilitada cuando falta pago',kind='Comportamiento observado; no se confirma como defecto',trace='E-RF06 -> CT-CON-01 -> CP-CON-01',severity='Informativa',priority='Baja',steps='Llegar al checkout sin método de pago y observar Confirm Order.',expected='No confirmar sin pago y comunicar el impedimento.',actual='El botón aparece deshabilitado y el aviso de pago es visible.',evidence='CP-CHK-01_sin-pago; H-OC05',action='Mantener esta validación en la regresión del checkout cuando exista un método de pago aplicable.'),
dict(id='OBS-F01',title='Opciones requeridas sin alternativas seleccionables',kind='Impedimento de datos/configuración; defecto de código no confirmado',trace='E-RF02 -> CT-PRO-02/03 -> CP-PRO-02',severity='Alta en productos afectados',priority='Alta',steps='AbrirAppleCinema,Canon yProduct8; inspeccionarRadio/Select/Size.',expected='Para caso positivo, todas las opciones requeridas deben ser seleccionables.',actual='Radio deApple sin valores; Canon yProduct8 sólo placeholder. Se bloquea configuración válida.',evidence='PRO-APPLE; CP-PRO-02_bloqueo; CP-PRO-01_resultado',action='Provisionar producto de prueba con opciones activas y stock por opción; repetirCP-PRO-02.'),
dict(id='OBS-F02',title='No hay cupón vigente para prueba positiva',kind='Impedimento de datos',trace='E-RF04 -> CT-CUP-01/03/04/05 -> CP-CUP-01/02',severity='Alta para cobertura',priority='Alta',steps='AdministraciónMarketing>Coupons; revisar los3 registros.',expected='Cupón de prueba vigente y elegible disponible.',actual='1111,2222,3333 deshabilitados; vencen en2014/2020. No hay representante válido.',evidence='CP-CUP-01_cupones-no-vigentes; CP-CUP-01_admin.txt',action='Proveedor del ambiente debe habilitar fixture controlado; no convertir2222 en válido por su nombre.'),
dict(id='OBS-F03',title='Cantidades inválidas se normalizan sin aviso específico',kind='Observación de usabilidad; no fallo contra oráculo mínimo previo',trace='E-RF03 -> CT-CAR-02 -> CP-CAR-02',severity='Media',priority='Media',steps='En Nano1 probar1.5,-1,abc y vacío, restableciendo línea entre variantes.',expected='No conservar cantidad inválida comprable; sería preferible error explícito.',actual='1.5 y vacío quedan1; -1 yabc retiran línea. No quedan cantidades inválidas comprables, pero cambia intención sin explicación.',evidence='CP-CAR-02_decimal; negativo; texto; vacio',action='Acordar regla de negocio explícita y mejorar validación; no cambiar retroactivamente el oráculo para fabricar fallo.'),
dict(id='CONF-F01',title='Orden por precio y omisión obligatoria funcionan en la muestra',kind='Confirmación relevante',trace='E-RF01/E-RF02 -> CT-CAT-02/CT-PRO-01 -> CP-CAT-02/CP-PRO-01',severity='Informativa',priority='Baja',steps='Ordenar12 productos asc/desc; omitirSelect enCanon y añadir.',expected='Monotonía y rechazo de omisión.',actual='Ambos criterios cumplen en la muestra; no demuestra cobertura de todos los productos.',evidence='CP-CAT-02_asc; desc; CP-PRO-01_resultado',action='Candidatos a regresión automatizada con conjunto estable.'),
dict(id='CONF-F02',title='Cantidad superior al stock bloquea checkout',kind='Confirmación relevante',trace='E-RF08 derivado -> CT-CAR-03 -> CP-CAR-02',severity='Informativa',priority='Baja',steps='Leer147 enpanel; actualizar carrito a147 y luego148; intentarCheckout.',expected='Sin insuficiencia enS; restricción al excederS.',actual='147 sin***;148 con*** y regreso a carrito con advertencia. No se creó orden.',evidence='CP-CAR-02_stock147; stockS; stockSmas1; stock-bloquea-checkout',action='Automatizar frontera en ambiente donde el stock pueda fijarse y restaurarse.')]

# Normalización editorial: insertar espacios en los compuestos compactos del borrador.
# Se conserva información técnica e IDs; sustituciones sólo de frases conocidas.
REPL={
'porprecio':'por precio','porpreciodescendente':'por precio descendente','porprecioascendente':'por precio ascendente',
'delínea':'de línea','depago':'de pago','deorden':'de orden','deagotado':'de agotado','diseñados/existentes':'diseñados / existentes',
'Franco central':'Franco central','Demo;':'Demo;','stockS':'stock S',
}
REPL.update(dict(x.split('=',1) for x in '''deopción=de opción
porstock=por stock
paraimporte=para importe
ydisponibilidad=y disponibilidad
yrestricción=y restricción
malconfiguradas=mal configuradas
demoejemplo=demo ejemplo
deautomatización=de automatización
delgrupo=del grupo
enel=en el
depruebas=de pruebas
dedatos=de datos
delproducto=del producto
datospersonales=datos personales
datosbrutos=datos brutos
datoscrudos=datos crudos
deprecioylínea=de precio y línea
deimportes=de importes
delíneagravada=de línea gravada
delstock=del stock
antesdefrontera=antes de frontera
checkoutretornaalcarritoconadvertencia=checkout retorna al carrito con advertencia
Cuponesdeshabilitadosyvencidos=Cupones deshabilitados y vencidos
TXTpreservalos=TXT preserva los
descuentonuevo=descuento nuevo
no esrepresentanteválido=no es representante válido
NoPaymentoptionsareavailable=No Payment options are available
ConfirmOrderdeshabilitado=Confirm Order deshabilitado
unitarioylínea=unitario y línea
Unidades=Unidades
Unaunidad=Una unidad
Dosunidades=Dos unidades
frenteatotal=frente a total
adicionalde=adicional de
no acredita por sísoloaplicabilidadatodosloscarritos=no acredita por sí solo aplicabilidad a todos los carritos
CODconAllZones=COD con All Zones
hipótesisdecausapendiente=hipótesis de causa pendiente
La captura muestraQuantity=La captura muestra Quantity
enformulario=en formulario
stockpersistido=stock persistido
niestado=ni estado
Identidaddelproducto=Identidad del producto
no visibleenesterecorte=no visible en este recorte
estadoInStock=estado In Stock
sinorden=sin orden
no haybaseline=no hay baseline
elineabase=el línea base
cuponescreados=cupones creados
reintentarindefinidamente=reintentar indefinidamente
declarar14ejecucionescompletas=declarar 14 ejecuciones completas
ejecucionescompletas=ejecuciones completas
conorigen=con origen
conectadas=conectadas
condiciónAlta=condición Alta
casosAlta=casos Alta
casosMedia=casos Media
demostrada=demostrada
del demoOpenCart=del demo OpenCart
consultaDOC=consulta DOC
Nuevo -> Enanálisis -> Asignado -> Encorrección -> Listoparareprueba=Nuevo -> En análisis -> Asignado -> En corrección -> Listo para reprueba
yreabierto=y reabierto
yregresión=y regresión
quedeben=que deben
Campoobligatorio=Campo obligatorio
configuraciónválida=configuración válida
valorSize=valor Size
omisiónSelect=omisión Select
enCanon=en Canon
contador ymensaje=contador y mensaje
carritovacío=carrito vacío
lecturaadministrativa=lectura administrativa
Lecturaadministrativa=Lectura administrativa
separarimportes=separar importes
sinprueba=sin prueba
fuentePython=fuente Python
Checkoutretorna=Checkout retorna
de stockS=de stock S
por fixture=por fixture
lafrontera=la frontera
elstock=el stock
ynavegadores=y navegadores
yconfiguración=y configuración
yhora=y hora
deidioma=de idioma
registroUTC=registro UTC
líneabase=línea base
ycarrito=y carrito
elestado=el estado
ylínea=y línea
ycomparar=y comparar
cálculosdecimales=cálculos decimales
de datos=f de datos
'''.strip().splitlines()))
REPL.pop('de datos',None)
REPL.update({
'Avisoinvalid':'Aviso invalid', 'Identidaddel':'Identidad del',
'Selectrequired':'Select required', 'Noelegible':'No elegible',
'autenticadodemo':'autenticado demo', 'comoexpectativa':'como expectativa',
'eidentificadores':'e identificadores', 'eidiomainglés':'e idioma inglés',
'encheckout':'en checkout', 'interfazdemo':'interfaz demo',
'líneagravada':'línea gravada', 'porfixture':'por fixture',
'prioridadycaso':'prioridad y caso', 'subtotalneto':'subtotal neto',
'técnicaybase':'técnica y base', 'unproducto':'un producto',
'yvalidaciónhumana':'y validación humana', 'yregistro':'y registro',
'Svolátil':'S volátil', 'Sinorden':'Sin orden', 'TXTpara':'TXT para',
'yestado':'y estado', 'compatibleProyecto':'compatible Proyecto',
'stockS':'stock S', 'enGranit':'en Granit', 'conS':'con S',
'datoS':'dato S', 'porS':'por S', 'conPasó':'con Pasó',
'porAlta':'por Alta', 'oMedia':'o Media', 'yURL':'y URL',
'no3/14':'no 3/14', 'parar14':'parar 14', 'y3':'y 3',
'mismaorden':'misma orden', 'deCameras':'de Cameras',
})
def editorial(s):
    for a,b in REPL.items():s=s.replace(a,b)
    # Proteger rutas, nombres de archivo e ID técnicos antes de normalizar prosa.
    protected=[]
    def hold(m):
        protected.append(m.group());return '@@'+str(len(protected)-1)+'@@'
    s=re.sub(r'Proyecto1_Enunciado_v2 \(1\).pdf|\S+\.(?:pdf|md|json|py|csv|png|jpg|txt)\b|(?:informe|historial)/\S+|CP-[A-Z]+-\d+(?:_[\w-]+)?|loadEventEnd|startTime|DOMContentLoaded|NavigationTiming',hold,s)
    s=re.sub(r'(?<=[,;:])(?=[A-Za-zÁÉÍÓÚáéíóú0-9])',' ',s)
    s=re.sub(r'(?<=[.!?])(?=[A-ZÁÉÍÓÚ])',' ',s)
    s=re.sub(r'(?<=[a-záéíóú])(?=[A-ZÁÉÍÓÚ])',' ',s)
    s=re.sub(r'(?<=[0-9])(?=[A-Za-zÁÉÍÓÚáéíóú])',' ',s)
    s=re.sub(r'(?<=[a-záéíóú])(?=[0-9])',' ',s)
    for i,v in enumerate(protected):s=s.replace('@@'+str(i)+'@@',v)
    s=s.replace('Open Cart','OpenCart').replace('i Pod','iPod').replace('Mac Book','MacBook').replace('Fire fox','Firefox')
    return s

DOC=[]
def h(title,level=1): DOC.append(('h',level,title))
def p(text): DOC.append(('p',text))
def table(headers,rows,widths=None): DOC.append(('table',headers,rows,widths))
def page(): DOC.append(('page',))
def pic(file,caption): DOC.append(('image',file,caption))
def mark(): return len(DOC)
def writepart(path,start):
    target=ROOT/path;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(as_md(DOC[start:]),encoding='utf-8')
def as_md(nodes):
    out=[]
    for n in nodes:
        if n[0]=='h':out.append('#'*n[1]+' '+n[2])
        elif n[0]=='p':out.append(n[1])
        elif n[0]=='table':
            out.append('| '+' | '.join(n[1])+' |\n| '+' | '.join(['---']*len(n[1]))+' |\n'+'\n'.join('| '+' | '.join(str(v).replace('|','/') for v in r)+' |' for r in n[2]))
        elif n[0]=='image':out.append('!['+n[2]+']('+n[1]+')\n\n'+n[2])
        elif n[0]=='page':out.append('---')
    return '\n\n'.join(out)+'\n'

h('Proyecto 1: planificación, análisis y diseño de pruebas')
p('CS5383 - Verificación y Pruebas de Software')
p('Caso 3: E-commerce con panel administrativo - OpenCart')
p('Grupo 5')
p('Integrantes: Franco Roque Castillo y Granit Espinoza Salazar')
p('Fecha de entrega: 25 de septiembre de 2026')
page(); start=mark()
h('1. Planificación de pruebas')
h('1.1 Objetivos',2)
p('Objetivo general: evaluar con pruebas trazables y priorizadas por riesgo la consistencia del flujo comercial y su relación con administración en el demoOpenCart, produciendo evidencia reproducible que sustente hallazgos y decisiones de continuación.')
p('Objetivos específicos: (1) separar requisitos de observaciones; (2) cubrir en diseño los11 requisitos clave; (3) diseñar al menos15 casos en4 funcionalidades, con técnicas de caja negra distintas; (4) intentar todos los casosAlta y registrar paso alcanzado, esperado, obtenido y veredicto; (5) detectar inconsistencias de importes, stock y descuentos; (6) identificar bloqueos sin presentarlos como aprobaciones; (7) proponer automatización fundada en lo observado.')
h('1.2 Alcance incluido y excluido',2)
p('Incluido: FUN-01 catálogo y orden; FUN-02 ficha/opciones; FUN-03 cantidades y recálculo; FUN-04 cupones y diseño complementario de certificados; FUN-05 invitado; FUN-06 confirmación; FUN-07 stock administrativo; FUN-08 pedidos; RNF-01 propagación público a panel; RNF-02 compatibilidad seleccionada; RNF-03 respuesta de catálogo. Filtros y certificados tienen casos complementariosMedia para mantener alcance sin ampliar la ejecución obligatoria.')
p('Excluido de esta iteración: desarrollo o modificación del códigoOpenCart; pagos reales; pruebas de carga/estrés contra el demo; auditoría de seguridad; pruebas unitarias sin código; combinatoria completa de navegadores/dispositivos; CRUD general de categorías y productos, registro/login exhaustivo, devoluciones, afiliados y newsletters. La administración se usa para lectura y la prueba específica de agotados si existen permisos. Estas exclusiones no eliminan ninguno de los11 requisitos clave.')
h('1.3 Estrategia y niveles',2)
p('Estrategia principal analítica basada en riesgos: priorizar dinero, inventario, descuentos y finalización de compra. Se complementa con diseño basado en requisitos y exploración acotada para reconocer datos y bloqueos. La frecuencia de cambios del demo exige volver a verificar stock, cupones y opciones antes de cada caso; la incertidumbre del ambiente no reduce artificialmente su prioridad.')
table(['Nivel','Profundidad y justificación'],[['Componente','No ejecutado: no se dispone de código, aislamiento ni instrumentación de unidades. Recomendado para cálculos en ambiente del desarrollador.'],['Integración','Observación a través de UI de carrito-checkout y sitio público-panel. No se atribuye cobertura de APIs internas ni bases de datos.'],['Sistema','Nivel principal: comportamiento externo del sistema desplegado con flujos positivos y negativos.'],['Aceptación','Validación orientada a los criterios del caso; no equivale a aceptación firmada por cliente ni liberación de producción.']],[85,405])
p('Tipos: funcionales positivos/negativos; no funcionales de rendimiento y compatibilidad planificados; revisión estática de requisitos, casos y evidencias; confirmación de defectos cuando exista corrección y regresión futura sobre funciones relacionadas. La revisión del informe sí se realizó; no se afirma haber ejecutado pruebas de componente ni cobertura estructural de código.')
h('1.4 Criterios de entrada, salida, suspensión y reanudación',2)
table(['Criterio','Regla verificable'],[
['Entrada común','Base y casos versionados; acceso al demo; captura de configuración relevante; datos ficticios; carrito controlado; evidencia con fecha/URL.'],
['Entrada específica','Producto/opciones válidos; stock y política para fronteras; cupón vigente para positivo; orden propia para pedidos/sincronización; instrumento para rendimiento. Si falta, registrar Bloqueado.'],
['Salida académica','Plan, riesgos,26 condiciones,18 casos con campos completos, registro para14Alta, hallazgos con evidencia y reflexión de automatización dentro del PDF. Los bloqueos son resultados permitidos por el enunciado; no se cuentan como pruebas superadas.'],
['Salida para afirmar calidad','No se recomienda la aceptación del sistema mientras existan fallos monetarios o de checkout y riesgos de prioridad Alta sin verificar.'],
['Suspensión','Desafío de acceso no resuelto, pérdida de sesión, cambio concurrente de fixture, falta de permiso o precondición, instrumento inválido. Suspender el caso afectado; continuar independientes.'],
['Reanudación','Acceso normal y fixture revalidado; permisos concedidos por proveedor; pago/cupón/opciones disponibles; registrar nueva corrida y repetir dependientes sin sobrescribir evidencia anterior.']],[105,385])
p('La tasa de aprobación se calcula sobre los casos con veredicto Pasó o Falló. Los casos Bloqueados se informan por separado.')
h('1.5 Recursos, responsabilidades y esfuerzo',2)
table(['Responsable/recurso','Asignación'],[['Franco','Catálogo, producto, carrito y cupones; riesgos asociados; condiciones FUN-01 a FUN-04; apoyo en RNF-03.'],['Granit','Checkout, confirmación, administración y pedidos; condiciones FUN-05 a FUN-08; RNF-01 y RNF-02.'],['Ambos','Revisión cruzada, consistencia del documento, control de versiones y decisión de entrega.'],['Herramientas','OpenCart Demo y panel administrativo; navegador de escritorio en Windows; capturas PNG y registros de resultados.'],['Dependencias externas','Permisos del panel, productos con opciones, cupones vigentes, medios de pago e instrumentación para rendimiento.']],[110,380])
table(['Actividad','Franco(h)','Granit(h)','Total estimado'],[['Adecuación y base','1','1','2'],['Plan,riesgos,condiciones','2','2','4'],['Diseño y datos','3','3','6'],['EjecuciónAlta/evidencias','3','3','6'],['Hallazgos,cierre,revisión','2','2','4'],['Reserva por bloqueos','1','1','2'],['Total','12','12','24']],[245,75,75,95])
p('La estimación total es de 24 horas para dos integrantes. La reserva se destina a revalidar precondiciones y reejecutar los casos bloqueados.')
table(['Fecha','Hito','Resultado'],[['18/09','Exploración inicial','Identificación de funcionalidades y datos disponibles.'],['24/09','Planificación, análisis y diseño','Condiciones, riesgos y casos de prueba definidos.'],['25/09','Ejecución y consolidación','Casos de prioridad Alta registrados con evidencias y veredictos.'],['Después de habilitar el ambiente','Reejecución de casos bloqueados','Pendiente de datos, permisos e instrumentación.']],[65,225,200])
writepart('entregables/A_planificacion_integrada.md',start)
h('1.6 Registro de riesgos de producto',2); start=mark()
p('Escala: probabilidadP1baja,P2media,P3alta; impactoI1menor,I2operacional,I3dinero/flujo crítico. Exposición=P×I;6-9Alta,3-4Media,1-2Baja. Estimaciones cualitativas del equipo, no probabilidades estadísticas. La prioridad de condiciones/casos sigue esa exposición; un bloqueo no reduce riesgo. R12quedaMedia, coherente conCP-VAL-01, sin condiciónAlta contradictoria.')
table(['ID / riesgo','P×I / nivel','Responsable','Tratamiento / casos'],[[r[0]+' '+r[1],f'{r[2]}x{r[3]}={r[2]*r[3]} / '+('Alta' if r[2]*r[3]>=6 else 'Media'),r[4],r[6]+' '+r[5]] for r in RISK],[140,70,80,200])
p('Riesgos de proyecto: demo compartido cambia datos, permisos limitados, bloqueo de acceso, ausencia de instrumentos y fecha de entrega. Mitigación: identificar precondiciones por corrida, conservar capturas, ejecutar independientes, reportar bloqueos y preparar fixtures para un ambiente controlado. Responsable de coordinación:ambos integrantes.')
writepart('entregables/B_riesgos_integrados.md',start)
page(); start=mark(); h('2. Análisis de pruebas y trazabilidad')
p('Matriz vigente:26 condiciones, cada una vinculada a requisito o alcance/riesgo explícito y a caso. Alta incluye justificación de impacto. Todos los11 requisitos originales tienen al menos un caso de diseño; esto no significa que los11 hayan sido verificados satisfactoriamente.')
table(['Condición / qué comprobar','Base / origen','Prioridad / riesgo','Caso(s) / razón'],[[r[0]+': '+r[3],r[1]+'; '+r[2],r[4]+'; '+r[5],r[6]+'. '+r[7]] for r in COND],[175,85,65,165])
h('2.1 Cobertura de requisitos clave',2)
table(['Base','Casos','Resultado de cobertura'],[
['E-RF01','CP-CAT-01/02','Diseño completo de nombre/precio; sólo precio ejecutado por prioridad.'],['E-RF02','CP-PRO-01/02','Omisión pasa; positivo/opciones bloqueado.'],['E-RF03','CP-CAR-01/02','Recálculo falla; cantidades/frontera ensayadas.'],['E-RF04','CP-CUP-01/02','Rechazo inválido observado; descuento válido/duplicación bloqueados.'],['E-RF05','CP-CHK-01; CP-CON-01','Preparación de invitado falla en pago; compra final bloqueada.'],['E-RF06','CP-CON-01/02','Confirmación e idempotencia bloqueadas.'],['E-RF07','CP-PED-01','Bloqueado por falta de orden propia.'],['E-RF08','CP-ADM-01; CP-CAR-02','Cambio administrativo bloqueado; frontera de stock sólo cubre detalle derivado.'],['E-RNF01','CP-RNF-01','Dirección corregida; bloqueado sin orden pública.'],['E-RNF02','CP-RNF-02','DiseñadoMedia; no ejecutado en selección actual.'],['E-RNF03','CP-RNF-03','Diseñado; medición verificable bloqueada.']],[65,120,305])
p('La cobertura se calcula sobre los 8 requisitos funcionales y los 3 requisitos no funcionales del Caso 3. Cada requisito tiene al menos una condición y un caso de prueba relacionado. Las variantes de datos se registran dentro de su caso y no se contabilizan como casos adicionales.')
writepart('entregables/C_analisis_integrado.md',start)
page(); start=mark(); h('3. Diseño de pruebas')
p('18 casos únicos:8 centralesFranco,8Granit y2 complementariosMedia. Se cubren las8 funcionalidades y3RNF. Selección:14Alta se intentan/registran;4Media permanecen diseñados. La línea baseFranco se guardó antes de la corrida; las mejoras de redacción y trazabilidad se versionan sin alterar retroactivamente sus oráculos.')
table(['Caso','Responsable','Prioridad','Técnica'],[[c['id']+' '+c['title'],c['owner'],c['priority'],c['tech']] for c in CASES],[205,90,50,145])
h('3.1 Técnicas y oráculos',2)
p('Partición de equivalencia:criterios de orden, campo presente/ausente y cupones válidos/inválidos. Valores límite:CP-CAR-02 usa0/1 y147/148 junto a la frontera real de stock; no se confunde un umbral temporal con generar entradas controladas alrededor de él. Tabla de decisión:CP-CUP-02 cruza validez y elegibilidad;CP-ADM-01 cruza stock y política. Transición de estados:reaplicación de cupón y reintento de orden. Casos de uso complementan la comparación entre interfaces.')
table(['Regla cupón','Vigente/activo','Elegible','Ya aplicado','Acción esperada'],[['A/B','No','Indiferente','No','Error,sin nuevo descuento'],['C','Sí','No','No','Error,sin nuevo descuento'],['D1','Sí','Sí','No','Aplicar una vez'],['D2','Sí','Sí','Sí','No acumular'],['E','Sí','DeSí aNo','Sí','Retirar o recalcular según regla']],[65,90,90,85,160])
p('Datos volátiles:recapturar precios,stock,opciones,cupones,pago yhora antes de cada ejecución. No reutilizar147 o122 como constante permanente. MonedaUSD eidiomainglés en corrida actual. Datos personales usados son ficticios; no se completaron compras ni se enviaron correos. Tokens de sesión no son datos de prueba y se eliminan de registros exportados cuando aparecen.')
writepart('03_diseno/RESUMEN_DISENO.md',start)
for i,c in enumerate(CASES):
    page();h('3.2 '+c['id']+' - '+c['title'])
    p('Responsable: '+c['owner']+'. Prioridad: '+c['priority']+'. Condición: '+c['conditions']+'. Base: '+c['req']+'.')
    h('Técnica y justificación',2);p(c['tech']+'. '+c['why'])
    h('Precondiciones',2);p(c['pre'])
    h('Datos de prueba',2);p(c['data'])
    h('Pasos',2)
    for j,s in enumerate(c['steps'],1):p(str(j)+'. '+s)
    h('Resultado esperado',2);p(c['expected'])
    p('Evidencia a conservar:ID de caso/variante,fecha yhora,URL,datos efectivos,estado previo/posterior y captura legible. Restablecer carrito y,si corresponde,fixture modificado. El resultado obtenido se mantiene en sección4, separado del diseño.')
for who in ['Franco','Granit']:
    parts=[]
    for c in CASES:
        if who in c['owner']:
            parts.append('# '+c['id']+' - '+c['title']+'\n\n'+'\n\n'.join(k+': '+str(c[k]) for k in ['owner','priority','conditions','req','tech','why','pre','data','expected'])+'\n\n'+'\n'.join(f'{i+1}. {s}' for i,s in enumerate(c['steps'])))
    (ROOT/'03_diseno'/('D_casos_de_prueba_'+who.lower()+'.md')).write_text('\n\n'.join(parts),encoding='utf-8')

page();start=mark();h('4. Ejecución y hallazgos')
h('4.1 Ambiente y método de registro',2)
p('Fecha de ejecución: 25/09/2026. Ambiente: sitio público y panel de OpenCart Demo 4.0.2.3, interfaz en inglés, moneda USD y navegador de escritorio en Windows. Las pruebas se ejecutaron caso por caso a través de la interfaz web; no se utilizó una suite automatizada ni se realizaron pruebas de carga.')
p('Cada registro conserva el caso, la fecha, los datos efectivos, el resultado obtenido, el veredicto y la evidencia. Las horas y URL de las capturas se encuentran en informe/evidencias/franco-20260925/registro.json. Los archivos de evidencia están inventariados con SHA-256 en manifest_integrado.json.')
h('4.2 Registro de casosAlta',2)
table(['Caso / fecha','Veredicto','Obtenido / paso alcanzado','Evidencia'],[[r[0]+'; '+r[2],r[1],r[3],r[4]] for r in RESULTS],[85,60,235,110])
p('Regla de agregación:si una variante obligatoria falla, el casoFalla; si no hay fallo demostrado pero falta una variante obligatoria, quedaBloqueado; sóloPasó cuando se verificaron las aserciones previstas. Por elloCP-CUP-02 no se aprueba a partir de sus dos variantes negativas. EnCP-CAR-02Pasó se limita a integridad de cantidades y frontera, no a la aritmética cubierta porCP-CAR-01.')
h('4.3 Detalle de variantes y desviaciones',2)
table(['Caso/variante','Esperado','Obtenido','Dictamen'],[
['CAT02 A/B','Monotonía y conjunto igual','98,110,122,122,122,122,123.20,242,337.99,602,1202,1202; inversa en descendente.','Pasó'],
['PRO01 omisión','Rechazo con campo identificado','Select required!; carrito0.','Pasó'],
['PRO02 positivo','Opciones válidas y precio verificable','Opciones requeridas vacías en3 candidatos.','Bloqueado'],
['CAR01 1->2','Línea122->244; total122->244','Línea122->242; total122->244.','Falló'],
['CAR02 0/-1/abc','No persistir cantidad inválida','Retira línea,total0.','Pasó conOBS'],
['CAR02 1.5/vacío','No persistir cantidad inválida','Normaliza a1,total122.','Pasó conOBS'],
['CAR02 147/148','S sin insuficiencia;S+1 restringido','147 sin***;148 con*** y checkout retorna carrito.','Pasó'],
['CUP01 válido','Descuento correcto','No existe cupón vigente entre3 leídos.','Bloqueado'],
['CUP02 A/B','Error sin descuento','Avisoinvalid/expired/usage;total122.','Pasó variante'],
['CUP02 C/D/E','Noelegible/repetición/revalidación correctas','Sin cupón válido no se alcanzó condición.','Bloqueado'],
['CHK01 campos/pago','Apellido requerido y pago aplicable','Validación apellido correcta;sin método de pago.','Falló caso']],[100,125,205,60])
p('CP-PRO-01 utiliza Canon EOS 5D porque permite aislar la omisión de una sola opción requerida. CP-PRO-02 permanece bloqueado porque los tres productos candidatos no permiten completar todas sus opciones. En CP-CAR-02 se utilizaron el stock observado S = 147 y su límite superior S + 1 = 148. La variante de texto se ejecutó después de la prueba con 148 unidades y sólo demuestra que una entrada no numérica no queda como cantidad comprable.')
p('CP-ADM-01 permanece bloqueado porque el panel rechazó el guardado. La evidencia confirma la restricción de permisos, pero no permite evaluar la propagación de un cambio administrativo. CP-RNF-01 también permanece bloqueado porque no fue posible generar una orden propia en el sitio público.')
h('4.4 Métricas y límites',2)
table(['Métrica','Cálculo / resultado'],[['Diseño','18 casos únicos;14Alta y4Media;26 condiciones;11/11 requisitos clave con diseño.'],['Alta con registro','14/14=100%,incluidos9Bloqueados. Registro no equivale a ejecución completa.'],['Alta con veredicto concluyente','3Pasó+2Falló=5/14=35.7%.'],['Bloqueo','9/14=64.3%.'],['Aprobación entre concluyentes','3/5=60.0%; no3/14 como tasa de aprobación.'],['BloqueFranco central','7Alta:3Pasó,1Falló,3Bloqueados;1Media no seleccionado.'],['BloqueGranit','7Alta:0Pasó,1Falló,6Bloqueados;1Media no seleccionado.'],['Complementarios','CAT03 yVAL01Media sólo diseñados.']],[200,290])
p('CP-RNF-03 permanece bloqueado porque no se dispone de datos instrumentales que identifiquen la red, la caché, la versión del navegador y el evento de navegación medido. El tiempo de respuesta del catálogo deberá evaluarse con el protocolo de 18 muestras definido en el caso.')
writepart('04_ejecucion/EJECUCION_INTEGRADA_20260925.md',start)
page();start=mark();h('4.5 Hallazgos relevantes')
p('Severidad estima impacto; prioridad propone urgencia de atención, sin atribuir decisión a unProductOwner no consultado. Defecto confirmado aquí significa comportamiento observable contrario al oráculo, no causa de código demostrada. Estado deDEF-01:abierto/reproducido. DEF-04:abierto,en análisis de causa/configuración. Los demás son observaciones o confirmaciones, no errores de código inventados.')
for f in FINDINGS:
    h(f['id']+' - '+f['title'],2)
    p('Clasificación: '+f['kind']+'. Severidad: '+f['severity']+'. Prioridad propuesta: '+f['priority']+'.')
    p('Trazabilidad: '+f['trace']+'. Pasos: '+f['steps'])
    p('Esperado: '+f['expected']+' Obtenido: '+f['actual'])
    p('Evidencia (AnexoA): '+f['evidence']+'. Recomendación: '+f['action'])
p('Gestión propuesta: Nuevo -> Enanálisis -> Asignado -> Encorrección -> Listoparareprueba -> Cerrado; rechazo,duplicado,diferido yreabierto se registran con motivo. Nadie corrigió código del demo en este proyecto. Sólo una nueva ejecución satisfactoria después de la corrección permitiría cerrar un defecto; mejorar este informe no cierraDEF-01/04.')
writepart('05_defectos/HALLAZGOS.md',start)
page();start=mark();h('5. Cierre y recomendaciones de automatización')
h('5.1 Conclusión de pruebas',2)
p('El ordenamiento por precio, la validación de una opción obligatoria y el control de cantidad superior al stock funcionaron en las condiciones evaluadas. El carrito presentó una diferencia entre el total de línea y el total general al utilizar dos unidades. El checkout invitado no pudo continuar porque no ofreció un método de pago aplicable.')
p('Los casos relacionados con opciones válidas, cupones vigentes, confirmación de pedidos, sincronización con administración, cambio de stock y rendimiento permanecen bloqueados por las condiciones del ambiente. Por esa razón, los resultados no son suficientes para recomendar el sistema como listo para producción. Los casos bloqueados deben reejecutarse cuando se habiliten sus precondiciones.')
h('5.2 Recomendaciones de automatización basadas en observación',2)
table(['Caso ejecutado/intentado','Recomendación paraProyecto2','Sustento observado'],[
['CP-CAT-02','Automatizar regresión asc/desc con fixture estable.','Ambos selectores funcionan y la comparación de12precios es determinista; no fijar catálogo público mutable.'],
['CP-PRO-01','Automatizar omisión aislada.','MensajeSelectrequired ycarritovacío observables. Prever variación deidioma.'],
['CP-PRO-02','Condicionar automatización a fixture con opciones.','3candidatos no permiten selección completa; automatizar ahora sólo produciría bloqueos de datos.'],
['CP-CAR-01','Prioridad alta para regresión monetaria.','Discrepancia122x2vs242 reproducida; usar cálculosdecimales ycomparar bases fiscales iguales.'],
['CP-CAR-02','Automatizar clases y frontera en entorno controlado.','147/148 producen diferencia observable; demo compartido vuelveSvolátil. Acordar normalización antes de exigir mensaje específico.'],
['CP-CUP-01/02','Automatizar con cupones creados y restaurados por fixture.','Los rechazos inválidos son observables, pero los tres cupones disponibles estaban vencidos y no permitieron evaluar el caso positivo.'],
['CP-CHK-01','Automatizar validaciones y smoke de pago tras habilitar flujo.','Apellido vacío es estable; ausencia depago bloquea cadena. Reportar bloqueo, no reintentar indefinidamente.'],
['CP-CON-01/02;CP-PED-01','No implementar todavía sobre este demo como test estable.','No existe orden propia. Requiere ambiente con pago de prueba eidentificadores trazables.'],
['CP-ADM-01','Reservar una prueba controlada con restauración.','El permiso de modificación fue denegado; no conviene automatizar cambios globales sobre el demo compartido.'],
['CP-RNF-01/03','Instrumentar después de resolver precondiciones.','Sinorden ni medidas crudas no hay baseline real para umbrales automatizados.']],[110,185,195])
p('Mantener manual la exploración de opciones mal configuradas y la revisión de claridad de mensajes, porque requieren interpretar intención y configuración. El diseño de automatización no se entrega como si ya estuviera implementado. Certificados, filtros y navegadores de prioridad Media no se justifican como candidatos a partir de ejecuciones inexistentes.')
writepart('04_ejecucion/F_CONSOLIDACION_Y_CIERRE.md',start)

page();h('Anexo A. Evidencias y alcance de las capturas')
p('Las evidencias de la ejecución se encuentran en informe/evidencias/franco-20260925. Los archivos TXT complementan las capturas cuando el contenido excede el área visible. Las evidencias adicionales del 24/09 se encuentran en gestion-20260924 y CP-ADM-01. No se utilizaron pedidos de terceros para evaluar los casos que requieren una orden propia.')
EVD=[
('CP-CAT-02_asc_detalle','Orden por precio ascendente; la lista completa se conserva en el registro TXT.'),
('CP-CAT-02_desc_detalle','Orden por precio descendente; mismos 12 productos. Captura adicional al registro inicial.'),
('CP-PRO-01_resultado','OmisiónSelect enCanon; validación requerida. RespaldoTXTpara contador ymensaje.'),
('CP-PRO-02_bloqueo_detalle','Product 8 no ofrece valor Size; bloquea configuración válida. Captura adicional del campo.'),
('CP-CAR-01_qty1','Unaunidad deNano:referencia deprecioylínea.'),
('CP-CAR-01_qty2','Dosunidades:línea242frenteatotal244; complementada porH-OC04.'),
('CP-CAR-02_stock147','Lecturaadministrativa delstock147 antesdefrontera.'),
('CP-CAR-02_stock-bloquea-checkout','148unidades:checkoutretornaalcarritoconadvertencia.'),
('CP-CUP-01_cupones-no-vigentes','Cuponesdeshabilitadosyvencidos; TXTpreservalos3registros.'),
('CP-CUP-02_error-visible','Código inexistente rechazado; ningún descuentonuevo.'),
('CP-CUP-02_vencido-error','2222rechazado; no esrepresentanteválido.'),
('CP-CHK-01_sin-pago','NoPaymentoptionsareavailable; ConfirmOrderdeshabilitado.')]
for id,caption in EVD:
    page();h('Evidencia '+id,2);pic('evidencias/franco-20260925/'+id+'_20260925.png',caption)
page();h('H-OC04. Importe de carrito - 24/09',2);pic('evidencias/gestion-20260924/OC-04_carrito-importes.jpg','Evidencia adicional de DEF-01. La línea debe compararse con un importe que utilice el mismo tratamiento fiscal.')
page();h('H-OC01 y H-OC02. Configuración de pago - 24/09',2)
pic('evidencias/gestion-20260924/OC-01_metodos-pago.jpg','24/09:métodos listados; no acredita por sísoloaplicabilidadatodosloscarritos.')
pic('evidencias/gestion-20260924/OC-02_cod-todas-zonas.jpg','24/09:CODconAllZones; hipótesisdecausapendiente.')
page();h('H-ADM. Restricción administrativa',2)
admfile=next((OUT/'evidencias'/'CP-ADM-01').glob('*.png'))
pic(admfile.relative_to(OUT).as_posix(),'24/09:Warning:You do not have permission to modify products! La captura muestraQuantity0 yestadoInStock enformulario. No demuestra guardado exitoso,stockpersistido1000niestadoOutOfStock. Identidaddelproducto no visibleenesterecorte.')

# Sólo párrafos/títulos/celdas se normalizan, nunca nombres de fichero ni IDs.
DOC2=[]
for n in DOC:
    if n[0]=='p':DOC2.append(('p',editorial(n[1])))
    elif n[0]=='h':DOC2.append(('h',n[1],editorial(n[2])))
    elif n[0]=='table':DOC2.append(('table',[editorial(str(x)) for x in n[1]],[[editorial(str(x)) for x in r] for r in n[2]],n[3]))
    elif n[0]=='image':DOC2.append(('image',n[1],editorial(n[2])))
    else:DOC2.append(n)
DOC=DOC2
(OUT/'informe.md').write_text(as_md(DOC),encoding='utf-8')
(OUT/'datos_informe.json').write_text(json.dumps(dict(requisitos=REQ,riesgos=RISK,condiciones=COND,casos=CASES,resultados=RESULTS,hallazgos=FINDINGS),ensure_ascii=False,indent=2),encoding='utf-8')

# Los documentos previos quedan preservados en historial; las rutas de consulta antiguas apuntan a la versión vigente.
redirects={'entregables/A_planificacion_granit.md':'entregables/A_planificacion_integrada.md','entregables/B_riesgos_granit.md':'entregables/B_riesgos_integrados.md','entregables/C_analisis_condiciones_granit.md':'entregables/C_analisis_integrado.md','04_ejecucion/EJECUCION_GRANIT_20260924.md':'04_ejecucion/EJECUCION_INTEGRADA_20260925.md','00_gestion/REVISION_CLASE7_20260924.md':'informe/informe.md','00_gestion/ESTRATEGIA_RESILIENCIA.md':'entregables/A_planificacion_integrada.md','00_gestion/CRITERIOS_SALIDA.md':'entregables/A_planificacion_integrada.md','MAPA_GRANIT.md':'informe/informe.md'}
for old,new in redirects.items():
    (ROOT/old).write_text('# Documento sustituido por la versión integrada 2.0\n\nConsultar `'+new+'` desde la raíz del proyecto.\n\nLa versión anterior se conserva en `historial/version_20260924/'+old+'`. Sus métricas y conclusiones no son vigentes.\n',encoding='utf-8')
(ROOT/'00_gestion'/'BITACORA_AMBIENTE.md').write_text('# Bitácora vigente - 25/09/2026\n\nDemo público compartido, Windows, navegador IAB, versión exacta no disponible. Panel4.0.2.3. Sesión invitada, USD, inglés.\n\nStock Nano147; cantidades147/148 ensayadas. OpcionesApple/Canon/Product8 incompletas. Los3cupones deshabilitados y vencidos. Pago no disponible para invitadoNano1/UK. Carrito limpiado al terminar; sin órdenes nuevas ni modificación administrativa en esta corrida.\n\nRegistro exacto de capturas:informe/evidencias/franco-20260925/registro.json (UTC; LimaUTC-5). Historial24/09 conservado por separado. La denegación de permiso sólo acredita bloqueo; no estado persistido.\n\nResultados vigentes:04_ejecucion/EJECUCION_INTEGRADA_20260925.md.\n',encoding='utf-8')
(ROOT/'04_ejecucion'/'MEDICIONES_RNF03_20260924.md').write_text('# Medición de RNF-03\n\nLos valores disponibles no incluyen el soporte necesario para verificar red, caché, instrumento y evento de cada medición. Por ello no acreditan el protocolo definido de 18 muestras.\n\nVeredicto de CP-RNF-03: Bloqueado hasta realizar una medición instrumentada y conservar el registro bruto.\n',encoding='utf-8')
for name in ['informe.typ','gestion_clase7.typ']:
    (OUT/name).write_text('// Fuente Typst histórica retirada del flujo vigente.\n// Original preservado en historial/version_20260924/informe/'+name+'\n// Editar generar_informe.py; reproduce informe.md y PDF con ReportLab.\n// No compilar este archivo como informe final.\n',encoding='utf-8')
(OUT/'QASE_IMPORTACION.md').write_text('# Qase opcional\n\nNo es requisito del enunciado ni se afirma importación realizada. Los casos vigentes se entregan en PDF y datos_informe.json. CSV deconsulta:casos_integrados.csv; campos no mapeados a un formato de importación específico. Seleccionar sólo14Alta para ejecución.\n',encoding='utf-8')
with (OUT/'casos_integrados.csv').open('w',encoding='utf-8-sig',newline='') as f:
    writer=csv.DictWriter(f,fieldnames=list(CASES[0]));writer.writeheader()
    for c in CASES:writer.writerow({**c,'steps':'\n'.join(c['steps'])})
# Reemplazar CSV anterior por la selecciónGranit actual, no contarlo como diseño adicional.
with (OUT/'qase_casos_granit.csv').open('w',encoding='utf-8-sig',newline='') as f:
    writer=csv.DictWriter(f,fieldnames=list(CASES[0]));writer.writeheader()
    for c in CASES:
        if 'Granit' in c['owner']:writer.writerow({**c,'steps':'\n'.join(c['steps'])})
(ROOT/'README.md').write_text('''# Proyecto 1 - Caso 3 OpenCart - Grupo 5

Entrega:25/09/2026. Versión integrada2.0.

## Informe para entregar

`informe/Proyecto1_Caso3_Grupo5.pdf` cumple el nombre del enunciado.
`informe/Proyecto1_Caso3_Grupo.pdf` es una copia idéntica por compatibilidad con la ruta solicitada.

## Estado

18 casos diseñados, 14 de prioridad Alta: 3 Pasó, 2 Falló y 9 Bloqueados. Los 4 casos de prioridad Media permanecen diseñados.
El documento presenta los resultados, hallazgos y limitaciones observadas durante la ejecución.

## Archivos vigentes

- entregables/A_planificacion_integrada.md
- entregables/B_riesgos_integrados.md
- entregables/C_analisis_integrado.md
- 03_diseno/D_casos_de_prueba_franco.md y D_casos_de_prueba_granit.md
- 04_ejecucion/EJECUCION_INTEGRADA_20260925.md
- 04_ejecucion/F_CONSOLIDACION_Y_CIERRE.md
- 05_defectos/HALLAZGOS.md
- informe/informe.md:contenido completo
- informe/generar_informe.py:fuente editorial y generadorPDF (reportlab,pypdf,Pillow)
- informe/datos_informe.json:datos estructurados
- informe/evidencias/manifest_integrado.json:archivos ySHA256

## Historial y reproducción

Versiones anteriores en historial/version_20260924, incluido el archivo Typst anterior.
Para regenerar: `python informe/generar_informe.py`. No ejecutar losTypst retirados.
No existe código fuente local deOpenCart en esta carpeta; contiene documentación y evidencias.
''',encoding='utf-8')

for f in ROOT.rglob('*.md'):
    if 'historial' not in f.parts and f.name!='LINEA_BASE_FRANCO_20260924.md':
        f.write_text(editorial(f.read_text(encoding='utf-8')),encoding='utf-8')

# Manifiesto de evidencia; nunca incluir tokens de sesión en nuevos TXT/JSON.
manifest=[]
for f in sorted((OUT/'evidencias').rglob('*')):
    if f.is_file() and f.name!='manifest_integrado.json':
        manifest.append(dict(path=f.relative_to(ROOT).as_posix(),bytes=f.stat().st_size,sha256=hashlib.sha256(f.read_bytes()).hexdigest()))
(OUT/'evidencias'/'manifest_integrado.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')

# Composición PDF con tablas partidas por fila y sin celdas cortadas.
fontdir=Path('C:/Windows/Fonts')
pdfmetrics.registerFont(TTFont('Body',str(fontdir/'arial.ttf')))
pdfmetrics.registerFont(TTFont('BodyB',str(fontdir/'arialbd.ttf')))
pdfmetrics.registerFontFamily('Body',normal='Body',bold='BodyB',italic='Body',boldItalic='BodyB')
styles=getSampleStyleSheet()
styles.add(ParagraphStyle(name='BodyX',fontName='Body',fontSize=10,leading=14,spaceAfter=8,textColor=colors.HexColor('#243447')))
styles.add(ParagraphStyle(name='H1X',fontName='BodyB',fontSize=17,leading=22,spaceBefore=10,spaceAfter=14,textColor=colors.HexColor('#005B75'),keepWithNext=True))
styles.add(ParagraphStyle(name='H2X',fontName='BodyB',fontSize=12,leading=16,spaceBefore=10,spaceAfter=8,textColor=colors.HexColor('#005B75'),keepWithNext=True))
styles.add(ParagraphStyle(name='CellX',fontName='Body',fontSize=8.2,leading=11,spaceAfter=0,wordWrap='CJK'))
styles.add(ParagraphStyle(name='CapX',fontName='Body',fontSize=9,leading=12,spaceBefore=7,spaceAfter=10))
W,H=A4; CW=W-90
def para(s,style='BodyX'):return Paragraph(escape(str(s)).replace('\n','<br/>'),styles[style])
story=[]
for n in DOC:
    if n[0]=='h':story.append(para(n[2],'H1X' if n[1]==1 else 'H2X'))
    elif n[0]=='p':story.append(para(n[1]))
    elif n[0]=='page':story.append(PageBreak())
    elif n[0]=='table':
        widths=n[3] or [490/len(n[1])]*len(n[1]); widths=[w*CW/490 for w in widths]
        rows=[[para(x,'CellX') for x in n[1]]]+[[para(x,'CellX') for x in r] for r in n[2]]
        t=Table(rows,colWidths=widths,repeatRows=1,hAlign='LEFT')
        t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#D8EEF3')),('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,colors.HexColor('#F4F7F8')]),('VALIGN',(0,0),(-1,-1),'TOP'),('GRID',(0,0),(-1,-1),.35,colors.HexColor('#C5D4DA')),('LEFTPADDING',(0,0),(-1,-1),6),('RIGHTPADDING',(0,0),(-1,-1),6),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
        story.extend([t,Spacer(1,10)])
    elif n[0]=='image':
        f=OUT/n[1];im=PILImage.open(f);ww,hh=im.size; scale=min(CW/ww,570/hh)
        story.append(Image(str(f),width=ww*scale,height=hh*scale,hAlign='CENTER'));story.append(para(n[2],'CapX'))
def footer(c,doc):
    c.saveState();c.setFont('Body',8);c.setFillColor(colors.HexColor('#536C77'))
    c.drawString(45,H-28,'CS5383 | Proyecto 1 | Caso 3 - OpenCart | Grupo 5')
    c.line(45,37,W-45,37);c.drawString(45,24,'Grupo 5 | 25/09/2026');c.drawRightString(W-45,24,str(doc.page));c.restoreState()
base=OUT/'_cuerpo.pdf'
SimpleDocTemplate(str(base),pagesize=A4,rightMargin=45,leftMargin=45,topMargin=49,bottomMargin=49,title='Proyecto1_Caso3_Grupo5',author='Franco Roque Castillo; Granit Espinoza Salazar').build(story,onFirstPage=footer,onLaterPages=footer)
writer=PdfWriter();writer.append(str(base))
writer.add_metadata({'/Title':'Proyecto1_Caso3_Grupo5 - Informe integrado v2.0','/Author':'Franco Roque Castillo; Granit Espinoza Salazar','/Subject':'Planificación, análisis, diseño y resultados con bloqueos explícitos'})
final=OUT/'Proyecto1_Caso3_Grupo5.pdf'
with final.open('wb') as f:writer.write(f)
shutil.copy2(final,OUT/'Proyecto1_Caso3_Grupo.pdf')
base.unlink()
print(json.dumps({'pdf':str(final),'pages':len(PdfReader(final).pages),'cases':len(CASES),'high':len(RESULTS),'conditions':len(COND),'evidence_files':len(manifest)},ensure_ascii=False))

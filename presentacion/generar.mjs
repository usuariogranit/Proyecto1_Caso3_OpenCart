import fs from 'node:fs/promises';
import path from 'node:path';
import { pathToFileURL } from 'node:url';
import { Presentation, PresentationFile, FileBlob } from '@oai/artifact-tool';

// Requiere @oai/artifact-tool y las herramientas de finalización del runtime.
const { PROJECT_DIR, SKILL_DIR, BUILD_DIR, RUNTIME_PYTHON } = process.env;
for (const value of [PROJECT_DIR, SKILL_DIR, BUILD_DIR, RUNTIME_PYTHON]) {
  if (!path.isAbsolute(value ?? '')) throw new Error('Configura las cuatro rutas absolutas del entorno.');
}
const { resolvePresentationFont, applyPresentationChartFont, finalizePresentation } = await import(pathToFileURL(path.join(SKILL_DIR, 'container_tools/artifact_tool_utils.mjs')));
const font = resolvePresentationFont();
const p = Presentation.create({ slideSize: { width: 1280, height: 720 } });
const C = { ink: '#142D3D', muted: '#516673', cyan: '#007C9F', pale: '#F2F6F8', green: '#18744D', red: '#BA3C3C', amber: '#A46810' };
const guide = [];
const report = 'entrega/Proyecto1_Caso3_Grupo5/Proyecto1_Caso3_Grupo5.pdf';
const evidenceDir = 'informe/evidencias/franco-20260925';
function text(s, str, x, y, w, h, size = 28, color = C.ink, bold = false) {
  const t = s.shapes.add({ geometry: 'textbox', position: { left:x, top:y, width:w, height:h }, fill:'none', line:{fill:'none',width:0} });
  t.text = str;
  t.text.style = { typeface:font, fontSize:size, color, bold, autoFit:'none' };
  return t;
}
function slide(title, who, seconds, script, source, dark = false) {
  const s = p.slides.add(); s.background.fill = dark ? C.ink : '#FFFFFF';
  if (title) text(s,title,64,48,1152,105,44,dark?'#FFFFFF':C.ink,true);
  const n = guide.length+1;
  text(s,`${who}   ${String(n).padStart(2,'0')}`,64,671,1152,25,18,dark?'#B6CBD5':C.muted);
  s.speakerNotes.textFrame.setText(`EXPOSITOR: ${who}\nTIEMPO: ${seconds} segundos\n\nGUION\n${script}\n\nFUENTES\n${report}\n${source}\nCorte de resultados: 25/09/2026. Presentación basada en el informe final integrado, commit e1f8597.`);
  guide.push({n,title,who,seconds,script}); return s;
}
function table(s, values, widths, y=185, height=350, size=26) {
  const t=s.tables.add({rows:values.length,columns:values[0].length,left:64,top:y,width:1152,height,columnWidths:widths,values});
  t.borders.assign({fill:'#DAE3E8',width:0.6,style:'solid'});
  for(let r=0;r<values.length;r++) for(let c=0;c<values[0].length;c++) {
    const cell=t.getCell(r,c);cell.fill=r===0?C.ink:(r%2?'#FFFFFF':C.pale);
    cell.text.style={typeface:font,fontSize:size,color:r===0?'#FFFFFF':C.ink,bold:r===0,autoFit:'none'};
  }
  return t;
}
async function screenshot(s,name,x,y,w,h) {
  s.images.add({blob:new Uint8Array(await fs.readFile(path.join(PROJECT_DIR,evidenceDir,name))),contentType:'image/png',alt:`Captura de ejecución del 25/09/2026: ${name}`,fit:'contain',position:{left:x,top:y,width:w,height:h}});
}

let s=slide('', 'Franco',25,
  'Somos Franco Roque Castillo y Granit Espinoza Salazar, del Grupo 5. Presentamos las pruebas del Caso 3, OpenCart. Evaluamos el flujo comercial y su relación con el panel administrativo. Explicaremos cómo priorizamos, qué evidencias obtuvimos y qué impide recomendar el sistema para producción.', 'Portada y sección 1.',true);
text(s,'Pruebas de software\nen OpenCart',64,165,1130,180,76,'#FFFFFF',true);
text(s,'Proyecto 1 · Caso 3 · Grupo 5',64,380,1100,48,32,'#83D8EA');
text(s,'Franco Roque Castillo\nGranit Espinoza Salazar',64,473,1100,94,28,'#FFFFFF');
guide[0].title='Pruebas de software en OpenCart';

s=slide('Alcance y planificación','Franco',45,
  'El alcance integra ocho funcionalidades y tres requisitos no funcionales. Diseñamos 18 casos para 11 requisitos y 26 condiciones. El nivel principal es sistema, sobre el demo desplegado. La integración se observa desde la interfaz, sin afirmar cobertura de APIs o código. Estimamos 24 horas entre ambos, incluida reserva por bloqueos. Antes de cada caso verificamos acceso, datos y permisos. Si falta una precondición, suspendemos ese caso y continuamos los independientes. Excluimos pagos reales, carga y modificación del código.', 'Secciones 1.2 a 1.5 y 2.');
text(s,'8 funcionalidades',64,185,570,55,40,C.cyan,true);
text(s,'Catálogo, producto, carrito y cupones\nCheckout, confirmación, stock y pedidos',64,256,1125,95,30);
text(s,'3 requisitos no funcionales',64,380,1080,55,40,C.cyan,true);
text(s,'Sincronización, compatibilidad y rendimiento',64,451,1110,52,30);
text(s,'Pruebas de sistema sobre OpenCart Demo 4.0.2.3\n24 horas estimadas entre ambos integrantes',64,560,1120,74,24,C.muted);

s=slide('Priorización y trazabilidad','Franco',55,
  'Priorizamos el dinero, el inventario, los descuentos y la compra. La exposición combina probabilidad e impacto en una escala de uno a tres. Valores de seis a nueve son Alta. Para el riesgo monetario R03 asignamos tres por tres, nueve. La tabla muestra una cadena completa: el requisito pide recalcular el total, la condición exige coherencia monetaria y el caso cambia un iPod Nano de una a dos unidades. El resultado originó DEF-01. Esta relación permite justificar la prioridad y volver a la evidencia. Cubrir el requisito en diseño no significa que haya pasado.', 'Sección 2, riesgo R03 y DEF-01.');
table(s,[['Elemento','Ejemplo del carrito'],['Requisito E-RF03','Recalcular importes al cambiar cantidad'],['Riesgo R03','Inconsistencia monetaria: 3 × 3 = 9, Alta'],['Condición CT-CAR-01','Coherencia entre línea, impuestos y total'],['Caso CP-CAR-01','Cambiar iPod Nano de 1 a 2 unidades'],['Hallazgo DEF-01','Línea 242 USD y total general 244 USD']],[340,812],173,393,26);
text(s,'11/11 requisitos con diseño; la ejecución se informa por separado.',64,601,1135,42,25,C.cyan,true);

s=slide('Técnicas de caja negra','Franco',55,
  'Elegimos la técnica según el comportamiento. Partición de equivalencia permite representar opciones presentes y ausentes. Los límites prueban cero y uno, además del stock disponible y una unidad más. La tabla de decisión combina vigencia, elegibilidad y repetición del cupón. La transición de estados ayuda a comprobar si repetir una confirmación duplica una orden. Los casos de uso recorren la compra y su consulta administrativa. Las técnicas justifican el diseño. Algunas pruebas quedaron bloqueadas, por lo que no afirmamos que todas estas reglas se hayan verificado.', 'Sección 3, CP-PRO-01, CP-CAR-02, CP-CUP-02, CP-CON-02 y CP-PED-01.');
table(s,[['Técnica','Aplicación'],['Partición de equivalencia','Opción obligatoria presente o ausente'],['Valores límite','Cantidad 0/1 y stock S/S+1'],['Tabla de decisión','Vigencia, elegibilidad y repetición del cupón'],['Transición de estados','Reintentos de confirmación de una orden'],['Caso de uso','Compra y consulta del pedido en el panel']],[390,762],185,410,27);

s=slide('Catálogo y opciones de producto','Franco',55,
  'El orden por precio pasó en ambos sentidos para el mismo conjunto de 12 productos. En producto, aislamos la omisión de una opción obligatoria: Canon mostró Select required y no añadió el producto. La captura corresponde a esa validación. En cambio, el caso positivo de opciones y ajuste de precio quedó bloqueado: tres candidatos no permitían completar sus opciones. En cupones, los tres códigos leídos estaban deshabilitados y vencidos. Rechazamos códigos inexistentes y vencidos, pero eso no basta para aprobar un caso que también exige elegibilidad y duplicación con un cupón válido.', `Secciones 4.2 y 4.3. ${evidenceDir}/CP-PRO-01_resultado_20260925.png`);
await screenshot(s,'CP-PRO-01_resultado_20260925.png',64,175,535,465);
text(s,'PASÓ',666,184,500,40,23,C.green,true);
text(s,'Orden por precio\n12 productos, ascendente y descendente',666,229,530,110,30);
text(s,'Omisión de opción\n“Select required!” y carrito vacío',666,350,530,102,30);
text(s,'BLOQUEADO',666,496,500,38,23,C.amber,true);
text(s,'Opciones válidas y cupones:\nfaltaron datos utilizables',666,544,530,92,28);

s=slide('DEF-01: el total de línea es inconsistente','Franco',75,
  'Añadimos un iPod Nano y actualizamos la cantidad a dos. Con una unidad, precio y línea mostraban 122 dólares. Con dos, el precio unitario se mantuvo en 122, la línea mostró 242 y el total general 244. El resultado esperado para la línea era 244 bajo la misma base fiscal. La captura permite ver todos los importes. La severidad y prioridad propuestas son Altas por el impacto monetario. El comportamiento se reprodujo el 25 de septiembre. Una tasa fija como Eco Tax podría intervenir, pero es una hipótesis: no inspeccionamos código ni confirmamos la causa raíz. El defecto permanece abierto.', `Sección 4.5, DEF-01. ${evidenceDir}/CP-CAR-01_qty2_20260925.png`);
await screenshot(s,'CP-CAR-01_qty2_20260925.png',64,175,570,465);
text(s,'122 × 2 = 244 USD',700,194,490,65,38,C.ink,true);
text(s,'242 USD',700,306,490,80,62,C.red,true);
text(s,'Total de línea observado',700,394,490,50,27);
text(s,'244 USD',700,476,490,64,44,C.cyan,true);
text(s,'Total general observado',700,548,490,45,27);
text(s,'Causa raíz pendiente de confirmación',700,606,510,38,22,C.muted);

s=slide('Frontera de stock y alcance del veredicto','Franco',50,
  'CP-CAR-02 pasó para integridad de cantidades y frontera de stock. Con stock observado de 147, esa cantidad no presentó la señal de insuficiencia. Con 148 apareció la marca de falta de stock y el intento de checkout devolvió al carrito. Cero, negativo y texto retiraron la línea; decimal y vacío se normalizaron a uno. Registramos la falta de mensaje específico como observación de usabilidad. Este resultado no demuestra que el cálculo monetario sea correcto ni que se completara una compra. Mis siete casos Alta cierran con tres Pasó, uno Falló y tres Bloqueados. Granit explicará ahora checkout y sus dependencias.', `Secciones 4.2 y 4.3, CP-CAR-02. ${evidenceDir}/CP-CAR-02_stockSmas1_20260925.png`);
await screenshot(s,'CP-CAR-02_stockSmas1_20260925.png',64,175,535,465);
text(s,'S = 147',660,195,525,60,42,C.cyan,true);
text(s,'Sin señal de insuficiencia',660,267,525,48,29);
text(s,'S + 1 = 148',660,363,525,60,42,C.cyan,true);
text(s,'Marca de stock insuficiente\ny retorno al carrito',660,439,535,90,29);
text(s,'CP-CAR-02: Pasó en cantidades y frontera.\nLa aritmética se evalúa en CP-CAR-01.',660,562,535,75,23,C.muted);

s=slide('DEF-04: el checkout no ofrece pago','Granit',65,
  'En checkout, el formulario identificó el apellido vacío y guardó los datos válidos del invitado. Al elegir el método de pago, mostró No Payment options are available. La confirmación quedó deshabilitada y CP-CHK-01 falló. El fallo tiene severidad Crítica para este recorrido y prioridad propuesta Alta. La captura histórica de Cash on Delivery habilitado en All Zones no demuestra que se cumplan todas las reglas de aplicabilidad. Debe investigarse la configuración. Nuestra conclusión se limita al recorrido y datos ensayados. Al no generar una orden propia, varios casos dependientes no pudieron completarse.', `Secciones 4.2 y 4.5, DEF-04. ${evidenceDir}/CP-CHK-01_sin-pago_20260925.png`);
await screenshot(s,'CP-CHK-01_sin-pago_20260925.png',64,175,570,465);
text(s,'CP-CHK-01: Falló',698,199,500,54,34,C.red,true);
text(s,'El invitado guarda sus datos,\npero no puede seleccionar pago.',698,286,510,112,31);
text(s,'Sin confirmación\nni orden propia',698,453,510,100,38,C.ink,true);
text(s,'Crítica para el recorrido ensayado.\nCausa/configuración en análisis.',698,580,520,70,24,C.muted);

s=slide('Los bloqueos tienen causas distintas','Granit',55,
  'Cuatro casos dependen de una orden propia: confirmación y resumen, prevención de duplicados, consulta en pedidos y sincronización desde el sitio público. Todos quedaron bloqueados tras la falta de pago. La modificación administrativa se bloqueó por permisos de guardado. Rendimiento se bloqueó por falta de mediciones instrumentales verificables. Su protocolo exige 18 muestras, separando navegación fría y cálida, y carga completa inferior a dos segundos. No presentamos la antigua cifra de 1932 milisegundos como aprobación. En mi bloque hay un fallo y seis bloqueos entre los siete Alta. Compatibilidad Media quedó diseñada, sin ejecución actual.', 'Secciones 3, CP-RNF-03, 4.2 y 4.4.');
table(s,[['Precondición faltante','Casos Alta bloqueados'],['Orden propia\n4 casos','CP-CON-01, CP-CON-02\nCP-PED-01, CP-RNF-01'],['Permiso de modificación\n1 caso','CP-ADM-01\nEl panel rechazó el guardado'],['Instrumentación verificable\n1 caso','CP-RNF-03\nProtocolo pendiente: 18 muestras, < 2000 ms']],[455,697],185,390,27);
text(s,'Bloqueado: el caso no pudo completar sus verificaciones.',64,602,1150,42,28,C.amber,true);

s=slide('Resultados de los 14 casos Alta','Granit',60,
  'Diseñamos 18 casos: 14 Alta y cuatro Media. Los 14 Alta tienen registro, incluidos los nueve bloqueados. De ellos, tres pasaron y dos fallaron. Por eso la ejecución con veredicto concluyente es cinco sobre catorce, 35,7 por ciento. La tasa de aprobación se calcula sobre los concluyentes: tres sobre cinco, 60 por ciento. Los bloqueados son nueve sobre catorce, 64,3 por ciento. No confundimos el cien por ciento de registros con ejecución completa ni con aprobación. Los cuatro Media se diseñaron y no se ejecutaron en esta selección.', 'Sección 4.4. Conteos: Pasó=3, Falló=2, Bloqueado=9.');
const chart=s.charts.add('bar',{position:{left:64,top:178,width:635,height:425},categories:['Pasó','Falló','Bloqueado'],series:[{name:'Casos Alta',values:[3,2,9],fill:C.cyan,points:[{idx:0,fill:C.green},{idx:1,fill:C.red},{idx:2,fill:C.amber}]}],barOptions:{direction:'bar',grouping:'clustered',gapWidth:95},hasLegend:false,xAxis:{visible:true,textStyle:{fontSize:25,typeface:font},line:{fill:'#FFFFFF',width:0}},yAxis:{visible:true,min:0,max:10,majorUnit:2,textStyle:{fontSize:20,typeface:font},majorGridlines:{fill:'#E1E7EB',width:1}},dataLabels:{showValue:true,position:'outEnd',textStyle:{fontSize:28,typeface:font,bold:true}},chartFill:'#FFFFFF',plotAreaFill:'#FFFFFF'});
applyPresentationChartFont(chart,{fontFamily:font});
text(s,'35,7%',766,182,420,75,58,C.ink,true);
text(s,'5/14 con veredicto concluyente',766,265,435,70,26);
text(s,'60,0%',766,374,420,75,58,C.cyan,true);
text(s,'3/5 aprobados entre concluyentes',766,457,435,75,26);
text(s,'18 diseñados = 14 Alta + 4 Media sin ejecutar',64,616,1152,40,25,C.muted);

s=slide('Defectos y observaciones','Granit',45,
  'El informe distingue defectos observables y limitaciones del ambiente. DEF-01 continúa abierto y reproducido. DEF-04 está abierto con causa o configuración en análisis. Severidad estima impacto y prioridad propone urgencia, sin atribuir la decisión a un responsable de negocio que no participó. Las opciones vacías, los cupones no vigentes y la normalización silenciosa tienen sus propias observaciones. No convertimos cada impedimento en un defecto de código. Para cerrar un defecto necesitaremos una corrección y una nueva ejecución satisfactoria. La confirmación repite el caso fallido; la regresión revisa funciones relacionadas.', 'Sección 4.5, DEF-01, DEF-04, OBS-F01, OBS-F02 y OBS-F03.');
table(s,[['Hallazgo','Severidad','Estado'],['DEF-01\nImporte de línea','Alta','Abierto y reproducido'],['DEF-04\nPago no disponible','Crítica en este recorrido','Abierto, causa en análisis']],[400,365,387],184,263,26);
text(s,'Prioridad propuesta Alta para ambos',64,483,1125,48,31,C.cyan,true);
text(s,'Opciones vacías, cupones no vigentes y normalización silenciosa\nse conservan como observaciones diferenciadas.',64,563,1148,78,27);

s=slide('Automatización para el Proyecto 2','Granit',55,
  'Proponemos automatizar según lo observado. Primero CP-CAR-01 por el riesgo monetario, usando cálculos decimales y la misma base fiscal. CP-CAT-02 tiene una comparación repetible de precios. CP-PRO-01 ofrece una validación observable y determinista. CP-CAR-02 es candidato cuando podamos fijar y restaurar el stock, porque 147 no será estable en un demo compartido. Para cupones necesitamos datos vigentes y restaurables. Para pedidos necesitamos pago de prueba y permisos. Esto es una recomendación de automatización futura, no una suite ya implementada. La exploración de configuraciones ambiguas y la claridad de mensajes permanecen manuales.', 'Sección 5.2.');
table(s,[['Caso candidato','Motivo observado'],['CP-CAR-01','Riesgo monetario y fallo reproducible'],['CP-CAT-02','Orden de precios determinista y repetitivo'],['CP-PRO-01','Validación obligatoria observable'],['CP-CAR-02','Fronteras repetibles con stock controlado']],[360,792],185,352,28);
text(s,'Condición previa: datos estables y restaurables.\nCupones y pedidos requieren habilitar sus precondiciones.',64,579,1148,72,27,C.cyan,true);

s=slide('Condiciones para continuar','Granit',45,
  'El siguiente ciclo empieza por habilitar un ambiente controlado: opciones completas, cupón vigente, pago de prueba, permisos y medición exportable. Luego reejecutaremos los nueve bloqueados y repetiremos los casos fallidos cuando exista corrección. Conservaremos las evidencias anteriores y registraremos cada nueva corrida. Después aplicaremos regresión en carrito, checkout y pedidos, y recalcularemos los indicadores. Esa secuencia evita que un cambio en los datos del demo se confunda con una corrección. No recomendamos afirmar calidad de producción mientras los riesgos Alta permanezcan sin verificar.', 'Secciones 1.4 y 5.');
text(s,'01   Habilitar las precondiciones',64,192,1150,58,36,C.cyan,true);
text(s,'Opciones, cupón vigente, pago, permisos e instrumentación.',143,261,1040,66,28);
text(s,'02   Reejecutar y conservar evidencias',64,371,1150,58,36,C.cyan,true);
text(s,'9 bloqueados y confirmación de los 2 fallos tras corregirlos.',143,440,1040,72,28);
text(s,'03   Aplicar regresión y actualizar el cierre',64,549,1150,60,36,C.cyan,true);

s=slide('Conclusión','Granit',35,
  'Nuestro aporte es un proceso trazable con 18 casos diseñados y resultados documentados para todos los de prioridad Alta. Observamos tres casos que pasaron, dos que fallaron y nueve bloqueados. Los fallos monetarios y de checkout, junto con los riesgos pendientes, impiden recomendar el sistema para producción. El informe deja claro qué probar de nuevo y bajo qué condiciones. Gracias. Estamos listos para sus preguntas. Las preguntas quedan fuera de los doce minutos de exposición acordados.', 'Secciones 4.4 y 5.1.',true);
text(s,'La evidencia aún no permite\nrecomendar producción',64,194,1140,156,56,'#FFFFFF',true);
text(s,'3 Pasó     2 Falló     9 Bloqueados',64,395,1150,64,40,'#83D8EA',true);
text(s,'Siguiente paso: resolver precondiciones y reejecutar.',64,508,1140,62,31,'#FFFFFF');

if(guide.filter(x=>x.who==='Franco').reduce((a,x)=>a+x.seconds,0)!==360 || guide.filter(x=>x.who==='Granit').reduce((a,x)=>a+x.seconds,0)!==360) throw new Error('Revisar reparto de 6 minutos.');
await fs.mkdir(path.join(BUILD_DIR,'output'),{recursive:true});
await fs.mkdir(path.join(BUILD_DIR,'render'),{recursive:true});
const candidatePath=path.join(BUILD_DIR,'candidate.pptx');
await (await PresentationFile.exportPptx(p)).save(candidatePath);
console.log('Draft exported; font:',font);
await finalizePresentation({workspaceDir:BUILD_DIR,candidatePath,finalPath:path.join(BUILD_DIR,'output','Proyecto1_Caso3_Grupo5_Exposicion.pptx'),pythonExecutable:RUNTIME_PYTHON,integrityValidatorPath:path.join(SKILL_DIR,'container_tools/inspect_presentation_package_integrity.py'),layoutValidatorPath:path.join(SKILL_DIR,'container_tools/inspect_presentation_layout_geometry.py'),layoutArgs:['--expected-slide-size-emu','12192000,6858000','--validate-heading-fit',...[3,4,9,11,12].flatMap(n=>['--require-native-table-slide',String(n)])],requiredNativeTableOwnerSlides:[3,4,9,11,12],requiredNativeChartOwnerSlides:[10],materializeLiteralChartWorkbooks:true,fontPolicy:{basis:'design',families:[font]},verifyArtifactToolImport:true,receiptPath:path.join(BUILD_DIR,'validation.json')});
const finalDeck=await PresentationFile.importPptx(await FileBlob.load(path.join(BUILD_DIR,'output','Proyecto1_Caso3_Grupo5_Exposicion.pptx')));
for(let i=0;i<finalDeck.slides.items.length;i++) {
 const preview=await finalDeck.export({slide:finalDeck.slides.items[i],format:'png',scale:1});
 await fs.writeFile(path.join(BUILD_DIR,'render',`slide-${String(i+1).padStart(2,'0')}.png`),new Uint8Array(await preview.arrayBuffer()));
}
let clock=0;
const rows=guide.map(g=>{let start=clock;clock+=g.seconds;const fmt=n=>`${Math.floor(n/60)}:${String(n%60).padStart(2,'0')}`;return `| ${g.n} | ${g.title} | ${g.who} | ${fmt(start)}–${fmt(clock)} |`;});
const md=`# Guion de exposición, Grupo 5\n\nDuración: 12 minutos, 6 por integrante. Las preguntas van después.\n\nFuente: informe final integrado del 25/09/2026, commit e1f8597. No utiliza los resultados históricos sustituidos.\n\n| Diapositiva | Tema | Responsable | Tiempo acumulado |\n| --- | --- | --- | --- |\n${rows.join('\n')}\n\n## Guion por diapositiva\n\n${guide.map(g=>`### ${g.n}. ${g.title}\n\n**${g.who}, ${g.seconds} segundos.**\n\n${g.script}`).join('\n\n')}\n\n## Preguntas probables\n\n- **¿Por qué 60 %?** Tres aprobados entre cinco concluyentes. Los nueve bloqueados se reportan aparte.\n- **¿Por qué cupones está bloqueado?** Pasaron dos variantes negativas, pero faltaron las obligatorias con cupón válido.\n- **¿Por qué rendimiento no está aprobado?** Falta el protocolo instrumentado de 18 muestras y datos verificables.\n- **¿Eco Tax es la causa?** Es una hipótesis, no una causa confirmada.\n- **¿Qué demuestra el stock?** S/S+1 y el bloqueo observado, sin afirmar corrección monetaria ni compra completada.\n\nLas notas del PowerPoint contienen este guion y las fuentes por diapositiva.\n`;
await fs.writeFile(path.join(BUILD_DIR,'output','Guion_Exposicion_12_minutos.md'),md);
console.log('Final presentation and 14 previews ready.');

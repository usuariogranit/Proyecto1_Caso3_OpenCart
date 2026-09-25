# Guion de exposición, Grupo 5

Duración: 12 minutos, 6 por integrante. Las preguntas van después.

Fuente: informe final integrado del 25/09/2026, commit e1f8597. No utiliza los resultados históricos sustituidos.

| Diapositiva | Tema | Responsable | Tiempo acumulado |
| --- | --- | --- | --- |
| 1 | Pruebas de software en OpenCart | Franco | 0:00–0:25 |
| 2 | Alcance y planificación | Franco | 0:25–1:10 |
| 3 | Priorización y trazabilidad | Franco | 1:10–2:05 |
| 4 | Técnicas de caja negra | Franco | 2:05–3:00 |
| 5 | Catálogo y opciones de producto | Franco | 3:00–3:55 |
| 6 | DEF-01: el total de línea es inconsistente | Franco | 3:55–5:10 |
| 7 | Frontera de stock y alcance del veredicto | Franco | 5:10–6:00 |
| 8 | DEF-04: el checkout no ofrece pago | Granit | 6:00–7:05 |
| 9 | Los bloqueos tienen causas distintas | Granit | 7:05–8:00 |
| 10 | Resultados de los 14 casos Alta | Granit | 8:00–9:00 |
| 11 | Defectos y observaciones | Granit | 9:00–9:45 |
| 12 | Automatización para el Proyecto 2 | Granit | 9:45–10:40 |
| 13 | Condiciones para continuar | Granit | 10:40–11:25 |
| 14 | Conclusión | Granit | 11:25–12:00 |

## Guion por diapositiva

### 1. Pruebas de software en OpenCart

**Franco, 25 segundos.**

Somos Franco Roque Castillo y Granit Espinoza Salazar, del Grupo 5. Presentamos las pruebas del Caso 3, OpenCart. Evaluamos el flujo comercial y su relación con el panel administrativo. Explicaremos cómo priorizamos, qué evidencias obtuvimos y qué impide recomendar el sistema para producción.

### 2. Alcance y planificación

**Franco, 45 segundos.**

El alcance integra ocho funcionalidades y tres requisitos no funcionales. Diseñamos 18 casos para 11 requisitos y 26 condiciones. El nivel principal es sistema, sobre el demo desplegado. La integración se observa desde la interfaz, sin afirmar cobertura de APIs o código. Estimamos 24 horas entre ambos, incluida reserva por bloqueos. Antes de cada caso verificamos acceso, datos y permisos. Si falta una precondición, suspendemos ese caso y continuamos los independientes. Excluimos pagos reales, carga y modificación del código.

### 3. Priorización y trazabilidad

**Franco, 55 segundos.**

Priorizamos el dinero, el inventario, los descuentos y la compra. La exposición combina probabilidad e impacto en una escala de uno a tres. Valores de seis a nueve son Alta. Para el riesgo monetario R03 asignamos tres por tres, nueve. La tabla muestra una cadena completa: el requisito pide recalcular el total, la condición exige coherencia monetaria y el caso cambia un iPod Nano de una a dos unidades. El resultado originó DEF-01. Esta relación permite justificar la prioridad y volver a la evidencia. Cubrir el requisito en diseño no significa que haya pasado.

### 4. Técnicas de caja negra

**Franco, 55 segundos.**

Elegimos la técnica según el comportamiento. Partición de equivalencia permite representar opciones presentes y ausentes. Los límites prueban cero y uno, además del stock disponible y una unidad más. La tabla de decisión combina vigencia, elegibilidad y repetición del cupón. La transición de estados ayuda a comprobar si repetir una confirmación duplica una orden. Los casos de uso recorren la compra y su consulta administrativa. Las técnicas justifican el diseño. Algunas pruebas quedaron bloqueadas, por lo que no afirmamos que todas estas reglas se hayan verificado.

### 5. Catálogo y opciones de producto

**Franco, 55 segundos.**

El orden por precio pasó en ambos sentidos para el mismo conjunto de 12 productos. En producto, aislamos la omisión de una opción obligatoria: Canon mostró Select required y no añadió el producto. La captura corresponde a esa validación. En cambio, el caso positivo de opciones y ajuste de precio quedó bloqueado: tres candidatos no permitían completar sus opciones. En cupones, los tres códigos leídos estaban deshabilitados y vencidos. Rechazamos códigos inexistentes y vencidos, pero eso no basta para aprobar un caso que también exige elegibilidad y duplicación con un cupón válido.

### 6. DEF-01: el total de línea es inconsistente

**Franco, 75 segundos.**

Añadimos un iPod Nano y actualizamos la cantidad a dos. Con una unidad, precio y línea mostraban 122 dólares. Con dos, el precio unitario se mantuvo en 122, la línea mostró 242 y el total general 244. El resultado esperado para la línea era 244 bajo la misma base fiscal. La captura permite ver todos los importes. La severidad y prioridad propuestas son Altas por el impacto monetario. El comportamiento se reprodujo el 25 de septiembre. Una tasa fija como Eco Tax podría intervenir, pero es una hipótesis: no inspeccionamos código ni confirmamos la causa raíz. El defecto permanece abierto.

### 7. Frontera de stock y alcance del veredicto

**Franco, 50 segundos.**

CP-CAR-02 pasó para integridad de cantidades y frontera de stock. Con stock observado de 147, esa cantidad no presentó la señal de insuficiencia. Con 148 apareció la marca de falta de stock y el intento de checkout devolvió al carrito. Cero, negativo y texto retiraron la línea; decimal y vacío se normalizaron a uno. Registramos la falta de mensaje específico como observación de usabilidad. Este resultado no demuestra que el cálculo monetario sea correcto ni que se completara una compra. Mis siete casos Alta cierran con tres Pasó, uno Falló y tres Bloqueados. Granit explicará ahora checkout y sus dependencias.

### 8. DEF-04: el checkout no ofrece pago

**Granit, 65 segundos.**

En checkout, el formulario identificó el apellido vacío y guardó los datos válidos del invitado. Al elegir el método de pago, mostró No Payment options are available. La confirmación quedó deshabilitada y CP-CHK-01 falló. El fallo tiene severidad Crítica para este recorrido y prioridad propuesta Alta. La captura histórica de Cash on Delivery habilitado en All Zones no demuestra que se cumplan todas las reglas de aplicabilidad. Debe investigarse la configuración. Nuestra conclusión se limita al recorrido y datos ensayados. Al no generar una orden propia, varios casos dependientes no pudieron completarse.

### 9. Los bloqueos tienen causas distintas

**Granit, 55 segundos.**

Cuatro casos dependen de una orden propia: confirmación y resumen, prevención de duplicados, consulta en pedidos y sincronización desde el sitio público. Todos quedaron bloqueados tras la falta de pago. La modificación administrativa se bloqueó por permisos de guardado. Rendimiento se bloqueó por falta de mediciones instrumentales verificables. Su protocolo exige 18 muestras, separando navegación fría y cálida, y carga completa inferior a dos segundos. No presentamos la antigua cifra de 1932 milisegundos como aprobación. En mi bloque hay un fallo y seis bloqueos entre los siete Alta. Compatibilidad Media quedó diseñada, sin ejecución actual.

### 10. Resultados de los 14 casos Alta

**Granit, 60 segundos.**

Diseñamos 18 casos: 14 Alta y cuatro Media. Los 14 Alta tienen registro, incluidos los nueve bloqueados. De ellos, tres pasaron y dos fallaron. Por eso la ejecución con veredicto concluyente es cinco sobre catorce, 35,7 por ciento. La tasa de aprobación se calcula sobre los concluyentes: tres sobre cinco, 60 por ciento. Los bloqueados son nueve sobre catorce, 64,3 por ciento. No confundimos el cien por ciento de registros con ejecución completa ni con aprobación. Los cuatro Media se diseñaron y no se ejecutaron en esta selección.

### 11. Defectos y observaciones

**Granit, 45 segundos.**

El informe distingue defectos observables y limitaciones del ambiente. DEF-01 continúa abierto y reproducido. DEF-04 está abierto con causa o configuración en análisis. Severidad estima impacto y prioridad propone urgencia, sin atribuir la decisión a un responsable de negocio que no participó. Las opciones vacías, los cupones no vigentes y la normalización silenciosa tienen sus propias observaciones. No convertimos cada impedimento en un defecto de código. Para cerrar un defecto necesitaremos una corrección y una nueva ejecución satisfactoria. La confirmación repite el caso fallido; la regresión revisa funciones relacionadas.

### 12. Automatización para el Proyecto 2

**Granit, 55 segundos.**

Proponemos automatizar según lo observado. Primero CP-CAR-01 por el riesgo monetario, usando cálculos decimales y la misma base fiscal. CP-CAT-02 tiene una comparación repetible de precios. CP-PRO-01 ofrece una validación observable y determinista. CP-CAR-02 es candidato cuando podamos fijar y restaurar el stock, porque 147 no será estable en un demo compartido. Para cupones necesitamos datos vigentes y restaurables. Para pedidos necesitamos pago de prueba y permisos. Esto es una recomendación de automatización futura, no una suite ya implementada. La exploración de configuraciones ambiguas y la claridad de mensajes permanecen manuales.

### 13. Condiciones para continuar

**Granit, 45 segundos.**

El siguiente ciclo empieza por habilitar un ambiente controlado: opciones completas, cupón vigente, pago de prueba, permisos y medición exportable. Luego reejecutaremos los nueve bloqueados y repetiremos los casos fallidos cuando exista corrección. Conservaremos las evidencias anteriores y registraremos cada nueva corrida. Después aplicaremos regresión en carrito, checkout y pedidos, y recalcularemos los indicadores. Esa secuencia evita que un cambio en los datos del demo se confunda con una corrección. No recomendamos afirmar calidad de producción mientras los riesgos Alta permanezcan sin verificar.

### 14. Conclusión

**Granit, 35 segundos.**

Nuestro aporte es un proceso trazable con 18 casos diseñados y resultados documentados para todos los de prioridad Alta. Observamos tres casos que pasaron, dos que fallaron y nueve bloqueados. Los fallos monetarios y de checkout, junto con los riesgos pendientes, impiden recomendar el sistema para producción. El informe deja claro qué probar de nuevo y bajo qué condiciones. Gracias. Estamos listos para sus preguntas. Las preguntas quedan fuera de los doce minutos de exposición acordados.

## Preguntas probables

- **¿Por qué 60 %?** Tres aprobados entre cinco concluyentes. Los nueve bloqueados se reportan aparte.
- **¿Por qué cupones está bloqueado?** Pasaron dos variantes negativas, pero faltaron las obligatorias con cupón válido.
- **¿Por qué rendimiento no está aprobado?** Falta el protocolo instrumentado de 18 muestras y datos verificables.
- **¿Eco Tax es la causa?** Es una hipótesis, no una causa confirmada.
- **¿Qué demuestra el stock?** S/S+1 y el bloqueo observado, sin afirmar corrección monetaria ni compra completada.

Las notas del PowerPoint contienen este guion y las fuentes por diapositiva.

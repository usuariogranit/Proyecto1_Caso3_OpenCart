#heading(level: 1, numbering: none)[Aplicación de la Clase 7 y evidencia verificable]

*Tipo de informe.* Finalización del hito de pruebas del bloque del Integrante 2, con pendientes abiertos. Finalizar el hito no significa aprobar el release. La revisión v1.1 conserva el cierre documentado y agrega una verificación complementaria de interfaz del 24-09-2026. No suma capturas como si fueran casos completos adicionales.

*Base metodológica.* Clase 7 — Gestión de pruebas (CS5383): diapositivas 4–9, 10–15, 19–22 y 29–32. La guía local `psicologia_del_docente_v2.txt`, especialmente su Parte II, orienta el orden, la evidencia y la defensa de decisiones. Sus interpretaciones del perfil docente no son requisitos ni afirmaciones del material de clase.

#heading(level: 2, numbering: none)[Monitoreo, control y finalización]

#table(
  columns: (2.7cm, 1fr),
  table.header([Actividad], [Aplicación al caso y evidencia de decisión]),
  [Monitoreo], [Cierre: 2/8 ejecutados (25 %); 1/2 aprobados (50 %); 5/8 bloqueados (62.5 %); 2/7 Alta ejecutados (28.6 %). Restan 6 casos por completar: 5 Alta bloqueados y 1 Media parcial. Los bloqueos afectan pago, confirmación y operación administrativa.],
  [Control], [Acción A: investigar DEF-04 y repetir CP-CHK-01 antes de ejecutar CP-CON-01, CP-CON-02 y CP-PED-01. Acción B: disponer de una instancia con escritura para CP-ADM-01 y CP-RNF-01. Acción C: completar CP-RNF-02 en Edge y Firefox. Responsables propuestos: desarrollo, responsable de ambiente y QA, respectivamente; asignación y fechas pendientes.],
  [Finalización], [Se conservan casos, resultados, defectos y capturas bajo Git. CS1, CS2 y CS3 incumplen; CS4 cumple en el límite. El responsable humano debe revisar la recomendación y decidir sobre el riesgo residual. No consta aceptación de ese riesgo.],
)

*Capacidad frente a pendientes (diapositiva 13).* La clase utiliza ritmo × días disponibles. En este proyecto no consta un ritmo observado ni una fecha de entrega confirmada; por ello la capacidad es *no calculable*. No se reutilizan los 10.5 casos/día de PagaFácil como si fueran una medición de OpenCart. Al confirmar ambos datos: capacidad = ritmo × días; pendientes estimados = máximo(0, 6 − capacidad), considerando además bloqueos y repruebas. Priorizar primero los cinco Alta pendientes y después el Media; no recortar alcance sin acuerdo explícito.

*Riesgo residual y aceptación.* Los seis pendientes incluyen flujos transaccionales sin verificación completa. Se agregan concurrencia, persistencia, pagos reales y móviles fuera de alcance. Estado de aceptación: *pendiente*. El registro de decisión deberá incluir responsable, fecha, riesgo aceptado y condiciones; este documento no firma esa decisión por otra persona.

*Tres audiencias (diapositiva 8).* Desarrollo recibe pasos, entorno y capturas; negocio recibe CS1–CS4, impacto y acciones que debe priorizar; auditoría recibe identificadores, versiones, trazabilidad y límites de evidencia. Los hechos y denominadores son iguales para las tres.

#heading(level: 2, numbering: none)[Selección de Qase con los siete criterios de la clase]

#table(
  columns: (3.8cm, 1fr),
  table.header([Criterio — diapositiva 31], [Decisión y límite comprobable para este proyecto]),
  [Integración], [Git conserva el testware y Qase es el destino previsto para casos y resultados. Cada registro debe mantener su ID CP/DEF y requisito. No se afirma que exista una integración automática con GitHub o un gestor de incidencias.],
  [Trazabilidad y reportes], [Se exige requisito ↔ caso ↔ ejecución ↔ defecto; una captura del listado de proyectos no prueba esa cadena. Deben verificarse los enlaces concretos al completar la carga.],
  [Escala], [Alcance previsto: 8 casos, 5 suites y 4 registros de defecto. No se realizó una prueba de escala de la herramienta.],
  [Automatización y BDD], [Los ocho casos son manuales. Automatización y BDD no están implementados ni son requisito para registrar esta ejecución.],
  [Costo total], [La pantalla consultada muestra una prueba de Qase Teams con 14 días restantes. Licencia posterior y costo de adopción pendientes de validar; no se asegura que un plan gratuito cubra todo el flujo.],
  [Gobierno y auditoría], [Proyecto privado propuesto, IDs estables, resultados fechados y capturas con huella SHA-256. Versiones en Git; asignación de permisos y auditoría dentro de Qase pendientes de comprobar.],
  [IA integrada], [No se verificaron funciones de IA de Qase. La asistencia usada preparó estructura, consistencia y capturas; la clasificación y la aceptación del riesgo requieren revisión humana.],
)

#heading(level: 2, numbering: none)[Estado observado de Qase]

Al consultar la cuenta solo estaba visible el proyecto de ejemplo *Getting Started* (DEMO), con 51 casos y sin corridas. Ese contenido no pertenece al proyecto OpenCart. Los ocho casos locales en `qase_casos_granit.csv` están preparados para carga; su existencia local no acredita importación, ejecución ni trazabilidad en Qase.

#figure(
  image("evidencias/gestion-20260924/QASE-01_estado-inicial.jpg", width: 100%),
  caption: [QASE-01: estado inicial real de la cuenta, 24-09-2026. Se muestra el proyecto de ejemplo; no se presenta como ejecución del equipo.],
)

#heading(level: 2, numbering: none)[Verificación complementaria y límites de los hallazgos]

*VC-20260924-01.* Se recorrió la tienda pública en Chrome, en el perfil existente y con carrito inicialmente vacío. Se agregaron dos iPod Nano y se verificó el carrito. Se completó Guest Checkout con los datos ficticios documentados y se consultó Choose. No se creó un pedido. Esta sesión no fue una ventana privada y no repitió la partición de apellido vacío ni las mediciones de rendimiento; por ello no se declara una nueva ejecución completa de CP-CHK-01 ni de CP-RNF-03.

- *DEF-01:* la línea muestra USD 242 y el total USD 244; E-01 documenta la diferencia. La explicación tributaria es una hipótesis hasta revisar la regla y su implementación.
- *DEF-04:* E-03 muestra ausencia de pago y E-04 muestra Cash On Delivery habilitado en All Zones. Ambas evidencias sostienen la discrepancia observada; no prueban por sí solas su causa raíz ni el fallo de toda combinación de compra.
- *DEF-02:* E-05 parcial muestra Quantity = 0 y Out Of Stock Status = In Stock en el formulario existente del producto 28. Esa configuración puede explicar la etiqueta pública; requiere triage para distinguir configuración del demo de defecto del producto. E-02, que debe mostrar el rechazo del carrito, permanece pendiente en esta revisión.
- *DEF-03:* en E-03, Confirm Order está deshabilitado y el selector sí muestra un mensaje. No se reprodujo el clic descrito en el registro inicial. Se conserva ese registro histórico y se solicita triage; no se afirma que el defecto esté corregido o confirmado por esta captura.

*Duplicados (diapositiva 25).* DEF-03 y DEF-04 comparten contexto de checkout, pero describen manifestaciones distintas. La revisión local no permite afirmar una causa común; el responsable de triage debe decidir si DEF-03 es independiente, duplicado o comportamiento esperado. Ningún registro se cierra automáticamente por una captura nueva.

*Gestión de la configuración (diapositiva 9).* El manifiesto de capturas conserva nombre, fecha y huella. No contiene URL de sesión administrativa ni credenciales. El fuente v1.1 y las evidencias se versionan juntos; el PDF anterior pertenece a la versión previamente generada y no representa esta revisión del fuente.

#heading(level: 2, numbering: none)[Uso de IA y revisión humana]

Asistencia realizada: contraste entre clase y guía, detección de denominadores inconsistentes, preparación de archivos y captura de interfaces reales. Revisión que corresponde al equipo: confirmar requisitos y técnica de caja negra, validar severidad, ratificar prioridad con negocio, investigar causas, aceptar o rechazar riesgos y autorizar el release. No consta aún una aprobación humana final de esta revisión.

#pagebreak()

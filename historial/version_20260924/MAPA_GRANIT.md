# MAPA DE TRABAJO — GRANIT (Integrante 2)
Proyecto 1 · CS5383 · Caso 3 OpenCart
Bloque: checkout, pedidos, administración, no funcionales y cierre.
(El bloque de Franco —catálogo, producto, carrito, cupones— solo se usa como esqueleto/referencia de formato.)

## 1. Mis entregables
### A. Planificación (mi mitad del plan)
Elementos de prueba · Ambiente de prueba · Navegadores seleccionados · Herramientas · Datos de prueba ·
Recursos y responsabilidades · Estimación de esfuerzo · Cronograma · Entregables ·
Gestión de la Configuración del testware · Supuestos y restricciones del demo.

### B. Riesgos
- **De proceso:** falta de permisos administrativos · datos alterados por otros usuarios · indisponibilidad del demo ·
  sesiones contaminadas · imposibilidad de crear pedidos · productos sin datos válidos · flujos bloqueados por configuración.
- **De producto:** checkout · confirmación de pedidos · duplicación de pedidos · inconsistencia sitio–panel ·
  pedidos que no aparecen en administración.

### C. Análisis (mis funcionalidades)
FUN-05 checkout invitado/registrado · FUN-06 confirmación y resumen · FUN-07 productos, categorías y stock admin ·
FUN-08 gestión administrativa de pedidos · RNF-01 sincronización sin reinicios · RNF-02 compatibilidad de navegadores.
Por cada una: condiciones de prueba → riesgo y prioridad → justificación de las Altas → trazabilidad RF→CT→CP.

### D. Diseño — mis 8 casos
| ID | Caso | RF base (avance 1) |
|---|---|---|
| CP-CHK-01 | Checkout como invitado | RF CHK 01, 03, 04 |
| CP-CON-01 | Generación de número y resumen del pedido | RF CON 01, 02 |
| CP-CON-02 | Prevención de pedido duplicado | RF CON 03 |
| CP-ADM-01 | Producto con stock cero reflejado públicamente | RF ADM 02, 03 |
| CP-PED-01 | Pedido público visible en administración | RF PED 01, 02 |
| CP-RNF-01 | Sincronización entre sitio y panel | RNF 01 / RF ADM 07 |
| CP-RNF-02 | Flujo crítico en navegadores seleccionados | RNF 02 |
| CP-RNF-03 | Medición del tiempo de respuesta del catálogo | RNF 03 |
Cada caso: condición relacionada, precondiciones, datos, pasos, resultado esperado, prioridad, técnica de caja negra, RF relacionado.

### E. Ejecución
Ejecutar TODOS mis casos de prioridad Alta · esperado vs obtenido · veredicto (pasó/falló/bloqueado) ·
documentar explícitamente los bloqueados y su causa · capturas con nombre trazable · defectos confirmados · riesgos residuales.

### F. Consolidación y cierre (yo la hago, con los resultados de ambos)
Tabla global · diseñados / planificados para ejecución / pasados / fallidos / bloqueados ·
tasa de ejecución · tasa de aprobación · **tasa de bloqueo sobre planificados** ·
defectos por severidad y prioridad · cumplimiento de Criterios de Salida (CS1–CS4 declarados ANTES) ·
estado frente a los criterios de salida CS1–CS4 (sin etiqueta GO/NO GO, según la formulación de la docente) · reflexión de automatización · Lecciones Aprendidas.

## 2. Convención de nombres de evidencia
`CP-XXX-NN_pasoNN_<descripcion-corta>_AAAAMMDD.png` — toda captura fechada, porque el demo es compartido.
Defectos: `DEF-NN` con título `[Módulo/Funcionalidad] + [qué falla] + [bajo qué condición]`.

## 3. Dependencia crítica de mi bloque
CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01 exigen **completar un pedido real**; CP-ADM-01 exige **escribir en el panel**.
En demo.opencart.com el usuario `demo` no puede modificar y el checkout se bloqueaba por stock → riesgo de que casi todo
mi bloque quede Bloqueado. Alternativa documentada: instancia propia desde el acceso oficial al demo
(https://www.opencart.com/index.php?route=cms/demo). Decisión pendiente del recon en vivo.

## 4. Datos pendientes de Granit
Grupo e integrantes · plantilla oficial del plan · herramienta de gestión (Jira/Zephyr/TestLink) o tablas · fecha de entrega.

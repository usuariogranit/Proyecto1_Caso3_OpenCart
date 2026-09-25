# 1. Planificación de pruebas

## 1.1 Objetivos

Objetivo general: evaluar con pruebas trazables y priorizadas por riesgo la consistencia del flujo comercial y su relación con administración en el demo OpenCart, produciendo evidencia reproducible que sustente hallazgos y decisiones de continuación.

Objetivos específicos: (1) separar requisitos de observaciones; (2) cubrir en diseño los 11 requisitos clave; (3) diseñar al menos 15 casos en 4 funcionalidades, con técnicas de caja negra distintas; (4) intentar todos los casos Alta y registrar paso alcanzado, esperado, obtenido y veredicto; (5) detectar inconsistencias de importes, stock y descuentos; (6) identificar bloqueos sin presentarlos como aprobaciones; (7) proponer automatización fundada en lo observado.

## 1.2 Alcance incluido y excluido

Incluido: FUN-01 catálogo y orden; FUN-02 ficha/opciones; FUN-03 cantidades y recálculo; FUN-04 cupones y diseño complementario de certificados; FUN-05 invitado; FUN-06 confirmación; FUN-07 stock administrativo; FUN-08 pedidos; RNF-01 propagación público a panel; RNF-02 compatibilidad seleccionada; RNF-03 respuesta de catálogo. Filtros y certificados tienen casos complementarios Media para mantener alcance sin ampliar la ejecución obligatoria.

Excluido de esta iteración: desarrollo o modificación del código OpenCart; pagos reales; pruebas de carga/estrés contra el demo; auditoría de seguridad; pruebas unitarias sin código; combinatoria completa de navegadores/dispositivos; CRUD general de categorías y productos, registro/login exhaustivo, devoluciones, afiliados y newsletters. La administración se usa para lectura y la prueba específica de agotados si existen permisos. Estas exclusiones no eliminan ninguno de los 11 requisitos clave.

## 1.3 Estrategia y niveles

Estrategia principal analítica basada en riesgos: priorizar dinero, inventario, descuentos y finalización de compra. Se complementa con diseño basado en requisitos y exploración acotada para reconocer datos y bloqueos. La frecuencia de cambios del demo exige volver a verificar stock, cupones y opciones antes de cada caso; la incertidumbre del ambiente no reduce artificialmente su prioridad.

| Nivel | Profundidad y justificación |
| --- | --- |
| Componente | No ejecutado: no se dispone de código, aislamiento ni instrumentación de unidades. Recomendado para cálculos en ambiente del desarrollador. |
| Integración | Observación a través de UI de carrito-checkout y sitio público-panel. No se atribuye cobertura de APIs internas ni bases de datos. |
| Sistema | Nivel principal: comportamiento externo del sistema desplegado con flujos positivos y negativos. |
| Aceptación | Validación orientada a los criterios del caso; no equivale a aceptación firmada por cliente ni liberación de producción. |

Tipos: funcionales positivos/negativos; no funcionales de rendimiento y compatibilidad planificados; revisión estática de requisitos, casos y evidencias; confirmación de defectos cuando exista corrección y regresión futura sobre funciones relacionadas. La revisión del informe sí se realizó; no se afirma haber ejecutado pruebas de componente ni cobertura estructural de código.

## 1.4 Criterios de entrada, salida, suspensión y reanudación

| Criterio | Regla verificable |
| --- | --- |
| Entrada común | Base y casos versionados; acceso al demo; captura de configuración relevante; datos ficticios; carrito controlado; evidencia con fecha/URL. |
| Entrada específica | Producto/opciones válidos; stock y política para fronteras; cupón vigente para positivo; orden propia para pedidos/sincronización; instrumento para rendimiento. Si falta, registrar Bloqueado. |
| Salida académica | Plan, riesgos, 26 condiciones, 18 casos con campos completos, registro para 14 Alta, hallazgos con evidencia y reflexión de automatización dentro del PDF. Los bloqueos son resultados permitidos por el enunciado; no se cuentan como pruebas superadas. |
| Salida para afirmar calidad | No se recomienda la aceptación del sistema mientras existan fallos monetarios o de checkout y riesgos de prioridad Alta sin verificar. |
| Suspensión | Desafío de acceso no resuelto, pérdida de sesión, cambio concurrente de fixture, falta de permiso o precondición, instrumento inválido. Suspender el caso afectado; continuar independientes. |
| Reanudación | Acceso normal y fixture revalidado; permisos concedidos por proveedor; pago/cupón/opciones disponibles; registrar nueva corrida y repetir dependientes sin sobrescribir evidencia anterior. |

La tasa de aprobación se calcula sobre los casos con veredicto Pasó o Falló. Los casos Bloqueados se informan por separado.

## 1.5 Recursos, responsabilidades y esfuerzo

| Responsable/recurso | Asignación |
| --- | --- |
| Franco | Catálogo, producto, carrito y cupones; riesgos asociados; condiciones FUN-01 a FUN-04; apoyo en RNF-03. |
| Granit | Checkout, confirmación, administración y pedidos; condiciones FUN-05 a FUN-08; RNF-01 y RNF-02. |
| Ambos | Revisión cruzada, consistencia del documento, control de versiones y decisión de entrega. |
| Herramientas | OpenCart Demo y panel administrativo; navegador de escritorio en Windows; capturas PNG y registros de resultados. |
| Dependencias externas | Permisos del panel, productos con opciones, cupones vigentes, medios de pago e instrumentación para rendimiento. |

| Actividad | Franco(h) | Granit(h) | Total estimado |
| --- | --- | --- | --- |
| Adecuación y base | 1 | 1 | 2 |
| Plan, riesgos, condiciones | 2 | 2 | 4 |
| Diseño y datos | 3 | 3 | 6 |
| Ejecución Alta/evidencias | 3 | 3 | 6 |
| Hallazgos, cierre, revisión | 2 | 2 | 4 |
| Reserva por bloqueos | 1 | 1 | 2 |
| Total | 12 | 12 | 24 |

La estimación total es de 24 horas para dos integrantes. La reserva se destina a revalidar precondiciones y reejecutar los casos bloqueados.

| Fecha | Hito | Resultado |
| --- | --- | --- |
| 18/09 | Exploración inicial | Identificación de funcionalidades y datos disponibles. |
| 24/09 | Planificación, análisis y diseño | Condiciones, riesgos y casos de prueba definidos. |
| 25/09 | Ejecución y consolidación | Casos de prioridad Alta registrados con evidencias y veredictos. |
| Después de habilitar el ambiente | Reejecución de casos bloqueados | Pendiente de datos, permisos e instrumentación. |

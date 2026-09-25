# 5. Cierre y recomendaciones de automatización

## 5.1 Conclusión de pruebas

El ordenamiento por precio, la validación de una opción obligatoria y el control de cantidad superior al stock funcionaron en las condiciones evaluadas. El carrito presentó una diferencia entre el total de línea y el total general al utilizar dos unidades. El checkout invitado no pudo continuar porque no ofreció un método de pago aplicable.

Los casos relacionados con opciones válidas, cupones vigentes, confirmación de pedidos, sincronización con administración, cambio de stock y rendimiento permanecen bloqueados por las condiciones del ambiente. Por esa razón, los resultados no son suficientes para recomendar el sistema como listo para producción. Los casos bloqueados deben reejecutarse cuando se habiliten sus precondiciones.

## 5.2 Recomendaciones de automatización basadas en observación

| Caso ejecutado/intentado | Recomendación para Proyecto 2 | Sustento observado |
| --- | --- | --- |
| CP-CAT-02 | Automatizar regresión asc/desc con fixture estable. | Ambos selectores funcionan y la comparación de 12 precios es determinista; no fijar catálogo público mutable. |
| CP-PRO-01 | Automatizar omisión aislada. | Mensaje Select required y carrito vacío observables. Prever variación de idioma. |
| CP-PRO-02 | Condicionar automatización a fixture con opciones. | 3 candidatos no permiten selección completa; automatizar ahora sólo produciría bloqueos de datos. |
| CP-CAR-01 | Prioridad alta para regresión monetaria. | Discrepancia 122 x 2 vs 242 reproducida; usar cálculos decimales y comparar bases fiscales iguales. |
| CP-CAR-02 | Automatizar clases y frontera en entorno controlado. | 147/148 producen diferencia observable; demo compartido vuelve S volátil. Acordar normalización antes de exigir mensaje específico. |
| CP-CUP-01/02 | Automatizar con cupones creados y restaurados por fixture. | Los rechazos inválidos son observables, pero los tres cupones disponibles estaban vencidos y no permitieron evaluar el caso positivo. |
| CP-CHK-01 | Automatizar validaciones y smoke de pago tras habilitar flujo. | Apellido vacío es estable; ausencia de pago bloquea cadena. Reportar bloqueo, no reintentar indefinidamente. |
| CP-CON-01/02;CP-PED-01 | No implementar todavía sobre este demo como test estable. | No existe orden propia. Requiere ambiente con pago de prueba e identificadores trazables. |
| CP-ADM-01 | Reservar una prueba controlada con restauración. | El permiso de modificación fue denegado; no conviene automatizar cambios globales sobre el demo compartido. |
| CP-RNF-01/03 | Instrumentar después de resolver precondiciones. | Sin orden ni medidas crudas no hay baseline real para umbrales automatizados. |

Mantener manual la exploración de opciones mal configuradas y la revisión de claridad de mensajes, porque requieren interpretar intención y configuración. El diseño de automatización no se entrega como si ya estuviera implementado. Certificados, filtros y navegadores de prioridad Media no se justifican como candidatos a partir de ejecuciones inexistentes.

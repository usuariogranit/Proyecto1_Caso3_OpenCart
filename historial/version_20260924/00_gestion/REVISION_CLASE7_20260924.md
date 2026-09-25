# Revisión v1.1: gestión de pruebas y evidencia

Fuentes: `Clase 7 - Gestion de pruebas.pdf` (material docente, 33 diapositivas) y `psicologia_del_docente_v2.txt` (guía local, Parte II). La clase prevalece en terminología; las interpretaciones psicológicas no se presentan como reglas de evaluación.

| Exigencia | Implementación | Estado |
|---|---|---|
| Monitoreo, control, finalización; diap. 4–5 | Aplicación al bloque y acciones con dependencias en `informe/gestion_clase7.typ` | Incorporado |
| Métricas y criterios; diap. 6, 10–13 | 25 % ejecución, 50 % aprobación, 62.5 % bloqueo, 28.6 % Alta ejecutada; 6 pendientes | Corregido |
| Capacidad real; diap. 13 | Fórmula y datos faltantes declarados; no copiar ritmo del ejemplo PagaFácil | Pendiente ritmo y fecha |
| Informes y audiencias; diap. 8 | Finalización de hito, desarrollo/negocio/auditoría, riesgo sin aceptación inventada | Incorporado |
| Configuración; diap. 9 | Versión v1.1 y manifiesto SHA-256 de capturas | Incorporado |
| Defectos reproducibles; diap. 19–22 | Entorno/reportante, prioridades propuestas, hipótesis separadas de observación | Incorporado; versión histórica de Chrome no consignada |
| Triage; diap. 25 | Revisar DEF-02 por configuración de stock y DEF-03 por botón deshabilitado | Pendiente decisión humana |
| Herramienta; diap. 29–32 | Siete criterios de selección de Qase y evidencia real del estado inicial | Carga de proyecto pendiente de autorización |
| IA; diap. 15, 26–27 | Contribución concreta y decisiones humanas aún pendientes | Incorporado |

## Capturas

Carpeta: `informe/evidencias/gestion-20260924/`. Fechas exactas y huellas en `manifest.json`.

- QASE-01: listado inicial, solo proyecto de ejemplo; no es evidencia de ejecución OpenCart.
- OC-01: lista de pagos habilitados.
- OC-02 / E-04: configuración Cash On Delivery, All Zones, habilitado.
- OC-03 / E-05 parcial: formulario existente de stock del producto 28; no se guardaron cambios ni se verificó persistencia mediante recarga.
- OC-04 / E-01: carrito con dos iPod Nano; línea USD 242 frente a total USD 244.
- OC-05 / E-03: checkout sin opciones de pago y Confirm Order deshabilitado.

Estas capturas complementan el registro previo. No constituyen una nueva corrida completa, una prueba de confirmación tras una corrección ni una validación de todos los países/clientes. E-02 sigue pendiente.

## Entregable

Se actualiza el fuente editable, casos y documentación. El PDF existente corresponde a la versión anterior; no se genera una nueva entrega PDF en esta revisión, según la indicación del usuario.

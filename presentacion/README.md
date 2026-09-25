# Presentación del Grupo 5

La PPT editable está en `../entrega/Proyecto1_Caso3_Grupo5/Proyecto1_Caso3_Grupo5_Exposicion.pptx`.
El guion cronometrado está en la misma carpeta y en las notas del PowerPoint.

- Fuente: informe final integrado del 25/09/2026, recibido en el commit `e1f8597` de Franco.
- Duración acordada: 12 minutos, 6 para Franco y 6 para Granit. Preguntas después.
- 14 diapositivas, texto editable, 5 tablas editables, gráfico editable y 4 capturas originales del 25/09/2026.
- Las cifras vigentes son 18 casos diseñados, 14 Alta con registro, 3 Pasó, 2 Falló, 9 Bloqueados y 4 Media sin ejecutar.
- Las fuentes y las limitaciones del resultado aparecen en las notas de cada diapositiva.

## Fuente de generación

`generar.mjs` usa JavaScript, `@oai/artifact-tool` y las herramientas de finalización de la habilidad Presentations del runtime de Codex. No requiere PowerPoint para construir el archivo.

Variables de entorno requeridas:

| Variable | Contenido |
| --- | --- |
| `PROJECT_DIR` | Ruta absoluta de este repositorio, incluyendo su espacio final si existe |
| `SKILL_DIR` | Directorio de la habilidad Presentations que contiene `container_tools` |
| `BUILD_DIR` | Directorio nuevo y privado para borrador, revisión y salida |
| `RUNTIME_PYTHON` | Ejecutable Python del runtime |
| `RUNTIME_NODE_MODULES` | Directorio de paquetes Node del runtime |

Ejecutar con el Node del runtime, resolviendo `@oai/artifact-tool` desde el directorio de paquetes. El generador produce el PowerPoint y el guion en `BUILD_DIR/output`. La finalización exige un destino nuevo y no sobrescribe una PPT existente. Las capturas originales se leen de `informe/evidencias/franco-20260925`.

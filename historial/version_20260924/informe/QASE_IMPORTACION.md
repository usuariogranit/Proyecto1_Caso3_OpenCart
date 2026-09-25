# Importación en Qase — 8 casos del Integrante 2 (Granit)

## 0. Estado verificado el 24-09-2026
La cuenta está abierta en Chrome y muestra una prueba de Qase Teams con 14 días restantes. Solo se observó Getting Started (DEMO); aún no se ha creado el proyecto OpenCart. La creación y carga requieren autorización explícita pendiente. No se verificó la cobertura de un plan gratuito.

## 1. Crear el proyecto
`Projects > Create new project`. Nombre: *CS5383 Proyecto 1 — OpenCart*; código: `OC`; acceso privado.

## 2. Importador CSV
Dentro del proyecto: menú `⋯` junto al nombre > **Import** > pestaña **CSV**
(`app.qase.io/project/OC/settings/import`). Sube `informe/qase_casos_granit.csv` con separador **coma**,
codificación **UTF-8** y la opción *first row is a header* activada.

## 3. Mapeo de columnas
El CSV tiene 17 columnas. El mapeo siguiente es propuesto y debe comprobarse en el importador real; no se ha validado reconocimiento automático:
`title`, `description`, `preconditions`, `postconditions`, `priority`, `severity`, `type`, `layer`, `is_flaky`,
`behavior`, `automation_status`, `status`, `suite`, `milestone`, `steps_actions`, `steps_expected_result`.
`suite` crea las cinco carpetas (FUN-05 a FUN-08 y Requisitos no funcionales). La columna **`id`** (CP-CHK-01 …
CP-RNF-03) no es un campo nativo: mapéala a un campo personalizado *ID de diseño* (`Settings > Fields > Create`)
o déjala sin mapear: el ID CP también se conserva al inicio del título, para mantenerlo visible después de importar. Los pasos vienen en una sola celda
multilínea; si prefieres pasos individuales, divídelos después en el editor del caso.

## 4. Test Run con los 8 casos
`Test runs > Start new test run`. Título: *Ejecución 24-09-2026 — Bloque Granit*. En *Select cases* marca la raíz
del repositorio para incluir los ocho. Ambiente: OpenCart Demo.

## 5. Registrar los veredictos reales
Abre el run y asigna a cada caso:

| Caso | Estado en Qase | Comentario |
|---|---|---|
| CP-RNF-03 | **Passed** | Cuatro mediciones bajo 2000 ms |
| CP-CHK-01 | **Failed** | Sin método de pago; importes contradictorios |
| CP-CON-01, CP-CON-02, CP-PED-01 | **Blocked** | Bloqueados por DEF-04 |
| CP-ADM-01, CP-RNF-01 | **Blocked** | Sin permisos de escritura en el panel |
| CP-RNF-02 | **In progress** si está disponible; en otro caso mantener sin completar y documentar el parcial | Parcial: Chrome verificado, faltan Edge y Firefox |

## 6. Enlazar los defectos DEF-01 … DEF-04
Crea los cuatro en `Defects > Create defect` copiando título, pasos, severidad y estado desde
`05_defectos/HALLAZGOS.md`. Desde el resultado de un caso en el run usa *Attach defect* para vincularlos:
DEF-01 y DEF-02 al registro histórico de CP-CHK-01; DEF-03 como observación exploratoria vinculada a CP-CON-01, que permanece bloqueado; DEF-04 a CP-CHK-01 y como impedimento de CP-CON-01, CP-CON-02 y CP-PED-01. CP-RNF-01 tiene como bloqueo inmediato la falta de permisos.
Así queda trazable la cadena requisito ↔ caso ↔ ejecución ↔ defecto.

## 7. Evidencia y veracidad de la carga
Registrar la corrida como **transcripción del cierre histórico del 24-09-2026**, no como ocho casos ejecutados de nuevo. Las capturas complementarias están en `informe/evidencias/gestion-20260924/`. No usar Skipped como equivalente silencioso de ejecución parcial. No presentar porcentajes nativos de Qase sin comprobar sus denominadores contra 2/8, 1/2 y 5/8.

DEF-02 y DEF-03 requieren triage según la evidencia complementaria; importar sus observaciones y límites, sin ratificarlos artificialmente. Las prioridades son propuestas de QA.

Al completar la carga, registrar URL del proyecto, IDs de casos, corrida y defectos, más capturas de repositorio, resultados y enlaces. Hasta entonces, la captura del proyecto DEMO solo prueba el estado inicial.

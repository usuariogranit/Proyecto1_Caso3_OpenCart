# Importación en Qase — 8 casos del Integrante 2 (Granit)

## 0. Cuenta (la crea el usuario)
**La cuenta debes crearla tú.** Regístrate en `app.qase.io` con tu correo y tu propia contraseña; nadie más debe
introducir tus credenciales. El plan gratuito basta para este proyecto.

## 1. Crear el proyecto
`Projects > Create new project`. Nombre: *CS5383 Proyecto 1 — OpenCart*; código: `OC`; acceso privado.

## 2. Importador CSV
Dentro del proyecto: menú `⋯` junto al nombre > **Import** > pestaña **CSV**
(`app.qase.io/project/OC/settings/import`). Sube `informe/qase_casos_granit.csv` con separador **coma**,
codificación **UTF-8** y la opción *first row is a header* activada.

## 3. Mapeo de columnas
Las 17 cabeceras ya usan los nombres nativos del importador, así que el asistente las reconoce solas:
`title`, `description`, `preconditions`, `postconditions`, `priority`, `severity`, `type`, `layer`, `is_flaky`,
`behavior`, `automation_status`, `status`, `suite`, `milestone`, `steps_actions`, `steps_expected_result`.
`suite` crea las cinco carpetas (FUN-05 a FUN-08 y Requisitos no funcionales). La columna **`id`** (CP-CHK-01 …
CP-RNF-03) no es un campo nativo: mapéala a un campo personalizado *ID de diseño* (`Settings > Fields > Create`)
o déjala sin mapear y consérvala solo como referencia del documento de diseño. Los pasos vienen en una sola celda
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
| CP-RNF-02 | **In progress** *(o Skipped)* | Parcial: Chrome verificado, faltan Edge y Firefox |

## 6. Enlazar los defectos DEF-01 … DEF-04
Crea los cuatro en `Defects > Create defect` copiando título, pasos, severidad y estado desde
`05_defectos/HALLAZGOS.md`. Desde el resultado de un caso en el run usa *Attach defect* para vincularlos:
DEF-01 y DEF-02 a CP-CHK-01; DEF-03 a CP-CON-01; DEF-04 a CP-CHK-01, CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01.
Así queda trazable la cadena requisito ↔ caso ↔ ejecución ↔ defecto.

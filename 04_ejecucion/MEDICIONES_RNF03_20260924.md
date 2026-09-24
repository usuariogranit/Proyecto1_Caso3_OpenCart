# CP-RNF-03 · Medición del tiempo de respuesta del catálogo
Requisito: **RNF 03** — el catálogo debe responder en menos de dos segundos.
Fecha: 24-09-2026 · Origen: navegador local del responsable · Sistema: demo.opencart.com

## Criterio de medición declarado
Se mide **carga completa de la página de categoría** (`loadEventEnd` menos inicio de navegación, Navigation Timing API
del navegador), por ser el instante en que el cliente dispone del catálogo completo. Se registran también TTFB
(`responseStart - requestStart`), respuesta del HTML (`responseEnd - requestStart`) y DOMContentLoaded, para separar
tiempo de servidor de tiempo de render. Se realizan cuatro mediciones, incluyendo una primera visita sin caché.

## Resultados
| # | Categoría | Condición | TTFB | HTML | DOMContentLoaded | Carga completa | ¿< 2000 ms? |
|---|---|---|---|---|---|---|---|
| 1 | Cameras (path=33) | Primera visita, sin caché | 862 ms | 863 ms | 1339 ms | **1932 ms** | Sí (margen 68 ms) |
| 2 | Desktops (path=20) | Navegación subsecuente | 434 ms | 437 ms | 595 ms | **1757 ms** | Sí |
| 3 | Laptops & Notebooks (path=18) | Navegación subsecuente | 420 ms | 422 ms | 523 ms | **898 ms** | Sí |
| 4 | Cameras (path=33) | Repetición con caché | 401 ms | 403 ms | 494 ms | **645 ms** | Sí |

Recursos cargados en la medición 1: 17.

## Veredicto
**Pasó.** Las cuatro mediciones cumplen el umbral de dos segundos.

## Hallazgo de confirmación (no es defecto)
La primera visita sin caché queda **a 68 ms del umbral** (1932 ms contra 2000 ms), mientras que la misma página con
caché responde en 645 ms. El requisito se cumple, pero el margen en la peor condición observada es de apenas 3.4 %:
cualquier degradación de red o de servidor lo incumple. Se recomienda fijar con el negocio si el umbral aplica a la
primera visita o a la navegación con caché, ya que el resultado depende por completo de esa definición.

## Limitación
Mediciones tomadas desde una única red y un único equipo, sin control sobre la carga concurrente del demo público.
No sustituyen una prueba de rendimiento formal; sirven como verificación puntual del requisito no funcional.

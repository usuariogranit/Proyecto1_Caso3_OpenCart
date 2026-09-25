# Línea base previa a la corrida de Franco

Grupo 5. Diseño v2.0. Fecha: 24-09-2026. Entrega: 25-09-2026.
Ejecución asistida mediante interfaz del demo oficial, sin scripts de prueba de producto. Los valores actuales de producto, opciones, stock y cupón se verifican como precondiciones antes de cada caso. Las observaciones históricas no se convierten en resultados de esta corrida.

| ID | Prioridad | Requisito original / detallado | Condiciones | Técnica | Datos y pasos planificados | Resultado esperado |
|---|---|---|---|---|---|---|
| CP-CAT-01 | Media | E-RF01 / RF CAT02–03 | CT-CAT02–03 | Particiones por criterio de orden | Categoría con ≥2 nombres; seleccionar A–Z y Z–A; comparar secuencia y conjunto | Orden correcto en ambas variantes; no pérdidas ni duplicados |
| CP-CAT-02 | Alta | E-RF01 / RF CAT04–05 | CT-CAT04–05 | Particiones por criterio de orden | Categoría con ≥2 precios distintos; menor→mayor y mayor→menor; comparar precios de venta visibles | Monotonía correcta; elementos conservados; empates permitidos |
| CP-PRO-01 | Alta | E-RF02 / RF PRO02 | CT-PRO02 | Partición válida/inválida | Producto con opción requerida; resto válido y omitir una; añadir; repetir por opción disponible | No se agrega; mensaje identifica opción omitida |
| CP-PRO-02 | Alta | E-RF02 derivado / RF PRO03–04 | CT-PRO03–04 | Particiones de opciones | Mismo producto, todas las opciones válidas; registrar ajuste antes de añadir; verificar carrito | Se agrega una vez; opciones preservadas y precio calculado con ajustes configurados |
| CP-CAR-01 | Alta | E-RF03 / RF CAR01–03 | CT-CAR01–03 | Partición válida | Producto apto sin opciones, carrito limpio, cantidades 1 y 2; registrar precio/impuestos antes; actualizar | Línea, subtotal, impuestos y total coherentes con cantidad y reglas; total línea=unitario mostrado×cantidad si ambos incluyen mismos impuestos |
| CP-CAR-02 | Alta | E-RF03 y E-RF08 derivados / RF CAR04–05 | CT-CAR04–05 | Equivalencia y valores límite | Variantes independientes 0, -1, 1.5, texto/vacío si interfaz admite; stock S, S+1 cuando S verificable; restaurar entre variantes | Cero puede eliminar según contrato de UI; negativos/no enteros no producen pedido inválido; sobre stock muestra aviso y bloquea compra si política lo prohíbe; sin stock/política verificable variante bloqueada |
| CP-CUP-01 | Alta | E-RF04 / RF CUP01 | CT-CUP01 | Partición válida | Consultar cupón 2222 o equivalente vigente, valor Discount real y restricciones; carrito elegible; aplicar una vez | Una línea de descuento; importe corresponde a base elegible, porcentaje/fijo y política fiscal; total correcto |
| CP-CUP-02 | Alta | E-RF04 y riesgo duplicación / RF CUP02–06 | CT-CUP02–06 | Tabla de decisión + transición | Variantes independientes: código inexistente QA-NO-EXISTE-20260924; cupón válido pero carrito no elegible; repetir cupón aplicado; alterar elegibilidad | Inexistente/no aplicable: error y ningún descuento nuevo; repetir: no acumula descuento; cambio: revalida; variantes sin cupón verificable se bloquean |

RNF-03 se conserva como CP-RNF-03 único del grupo. No se declara probado el tiempo a partir del tiempo de una llamada de automatización; requiere medición instrumentada de navegación. CP-CAT-01 Media permanece diseñado, fuera de la ejecución obligatoria Alta.

Se registrará resultado por variante, paso alcanzado, esperado/obtenido, hora, URL y evidencia. Un bloqueo no se contabiliza como aprobado. Los datos faltantes del demo se documentan, no se inventan.

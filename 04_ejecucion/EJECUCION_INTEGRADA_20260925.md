# 4. Ejecución y hallazgos

## 4.1 Ambiente y método de registro

Fecha de ejecución: 25/09/2026. Ambiente: sitio público y panel de OpenCart Demo 4.0.2.3, interfaz en inglés, moneda USD y navegador de escritorio en Windows. Las pruebas se ejecutaron caso por caso a través de la interfaz web; no se utilizó una suite automatizada ni se realizaron pruebas de carga.

Cada registro conserva el caso, la fecha, los datos efectivos, el resultado obtenido, el veredicto y la evidencia. Las horas y URL de las capturas se encuentran en informe/evidencias/franco-20260925/registro.json. Los archivos de evidencia están inventariados con SHA-256 en manifest_integrado.json.

## 4.2 Registro de casos Alta

| Caso / fecha | Veredicto | Obtenido / paso alcanzado | Evidencia |
| --- | --- | --- | --- |
| CP-CAT-02; 25/09 | Pasó | 12 precios ascienden 98..1202 y descienden 1202..98; mismo conjunto. | CP-CAT-02_asc; CP-CAT-02_desc |
| CP-PRO-01; 25/09 | Pasó | Canon muestra Select required! y mantiene carrito vacío. | CP-PRO-01_resultado |
| CP-PRO-02; 25/09 | Bloqueado | Apple sin alternativas Radio; Canon y Product 8 con selectores vacíos. No hay configuración completa para comparar precio. | PRO-APPLE; CP-PRO-02_bloqueo |
| CP-CAR-01; 25/09 | Falló | 1 unidad: 122/122.2 unidades: unit 122, línea 242, total 244. Diferencia 2 en línea; DEF-01 reproducido. | CP-CAR-01_qty1; CP-CAR-01_qty2 |
| CP-CAR-02; 25/09 | Pasó | 0,-1, abc retiran línea; 1.5 y vacío quedan en 1.147 sin***; 148 con*** y checkout retorna carrito. Observación de normalización silenciosa; no demuestra corrección monetaria ni compra final. | CP-CAR-02_cero; decimal; negativo; texto; vacio; stock 147; stock S; stock Smas 1; stock-bloquea-checkout |
| CP-CUP-01; 25/09 | Bloqueado | Los 3 cupones del panel están deshabilitados y vencidos.2222 no es dato válido. | CP-CUP-01_cupones-no-vigentes |
| CP-CUP-02; 25/09 | Bloqueado | A(inexistente) y B(vencido) pasan con aviso y total 122. C(no elegible), D(duplicado), E(revalidación) bloqueadas por falta de cupón válido. | CP-CUP-02_error-visible; CP-CUP-02_vencido-error; CP-CUP-01_admin.txt |
| CP-CHK-01; 25/09 | Falló | Apellido vacío validado; invitado completo guardado; Choose indica No Payment options are available. Confirm Order deshabilitado. | CP-CHK-01_apellido-vacio; CP-CHK-01_sin-pago |
| CP-CON-01; 25/09 | Bloqueado | No hay pago seleccionable ni confirmación posible; no se generó ID propio. | CP-CHK-01_sin-pago |
| CP-CON-02; 25/09 | Bloqueado | No existe primera orden de prueba; no se ensayaron reintentos de confirmación. | CP-CHK-01_sin-pago |
| CP-ADM-01; 24/09 | Bloqueado | El panel denegó el guardado por falta de permisos. La captura demuestra el bloqueo, pero no un cambio persistido. | H-ADM permiso-modificar-productos |
| CP-PED-01; 25/09 | Bloqueado | No hay orden propia para comparar con Orders. | CP-CHK-01_sin-pago |
| CP-RNF-01; 25/09 | Bloqueado | Sin evento público de orden confirmada no puede medirse latencia público->panel. | CP-CHK-01_sin-pago |
| CP-RNF-03; 25/09 | Bloqueado | No se contó con instrumentación de navegación exportable ni con datos brutos verificables para aplicar el protocolo definido. | Sin evidencia instrumental suficiente |

Regla de agregación: si una variante obligatoria falla, el caso Falla; si no hay fallo demostrado pero falta una variante obligatoria, queda Bloqueado; sólo Pasó cuando se verificaron las aserciones previstas. Por elloCP-CUP-02 no se aprueba a partir de sus dos variantes negativas. EnCP-CAR-02Pasó se limita a integridad de cantidades y frontera, no a la aritmética cubierta porCP-CAR-01.

## 4.3 Detalle de variantes y desviaciones

| Caso/variante | Esperado | Obtenido | Dictamen |
| --- | --- | --- | --- |
| CAT02 A/B | Monotonía y conjunto igual | 98, 110, 122, 122, 122, 122, 123.20, 242, 337.99, 602, 1202, 1202; inversa en descendente. | Pasó |
| PRO01 omisión | Rechazo con campo identificado | Select required!; carrito 0. | Pasó |
| PRO02 positivo | Opciones válidas y precio verificable | Opciones requeridas vacías en 3 candidatos. | Bloqueado |
| CAR01 1->2 | Línea 122->244; total 122->244 | Línea 122->242; total 122->244. | Falló |
| CAR02 0/-1/abc | No persistir cantidad inválida | Retira línea, total 0. | Pasó con OBS |
| CAR02 1.5/vacío | No persistir cantidad inválida | Normaliza a 1, total 122. | Pasó con OBS |
| CAR02 147/148 | S sin insuficiencia; S+1 restringido | 147 sin***; 148 con*** y checkout retorna carrito. | Pasó |
| CUP01 válido | Descuento correcto | No existe cupón vigente entre 3 leídos. | Bloqueado |
| CUP02 A/B | Error sin descuento | Aviso invalid/expired/usage; total 122. | Pasó variante |
| CUP02 C/D/E | No elegible/repetición/revalidación correctas | Sin cupón válido no se alcanzó condición. | Bloqueado |
| CHK01 campos/pago | Apellido requerido y pago aplicable | Validación apellido correcta; sin método de pago. | Falló caso |

CP-PRO-01 utiliza Canon EOS 5 D porque permite aislar la omisión de una sola opción requerida. CP-PRO-02 permanece bloqueado porque los tres productos candidatos no permiten completar todas sus opciones. En CP-CAR-02 se utilizaron el stock observado S = 147 y su límite superior S + 1 = 148. La variante de texto se ejecutó después de la prueba con 148 unidades y sólo demuestra que una entrada no numérica no queda como cantidad comprable.

CP-ADM-01 permanece bloqueado porque el panel rechazó el guardado. La evidencia confirma la restricción de permisos, pero no permite evaluar la propagación de un cambio administrativo. CP-RNF-01 también permanece bloqueado porque no fue posible generar una orden propia en el sitio público.

## 4.4 Métricas y límites

| Métrica | Cálculo / resultado |
| --- | --- |
| Diseño | 18 casos únicos; 14 Alta y 4 Media; 26 condiciones; 11/11 requisitos clave con diseño. |
| Alta con registro | 14/14=100%, incluidos 9 Bloqueados. Registro no equivale a ejecución completa. |
| Alta con veredicto concluyente | 3 Pasó+2 Falló=5/14=35.7%. |
| Bloqueo | 9/14=64.3%. |
| Aprobación entre concluyentes | 3/5=60.0%; no 3/14 como tasa de aprobación. |
| Bloque Franco central | 7 Alta: 3 Pasó, 1 Falló, 3 Bloqueados; 1 Media no seleccionado. |
| Bloque Granit | 7 Alta: 0 Pasó, 1 Falló, 6 Bloqueados; 1 Media no seleccionado. |
| Complementarios | CAT03 y VAL01 Media sólo diseñados. |

CP-RNF-03 permanece bloqueado porque no se dispone de datos instrumentales que identifiquen la red, la caché, la versión del navegador y el evento de navegación medido. El tiempo de respuesta del catálogo deberá evaluarse con el protocolo de 18 muestras definido en el caso.

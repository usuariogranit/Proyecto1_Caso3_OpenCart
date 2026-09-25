# 3. Diseño de pruebas

18 casos únicos: 8 centrales Franco, 8 Granit y 2 complementarios Media. Se cubren las 8 funcionalidades y 3 RNF. Selección: 14 Alta se intentan/registran; 4 Media permanecen diseñados. La línea base Franco se guardó antes de la corrida; las mejoras de redacción y trazabilidad se versionan sin alterar retroactivamente sus oráculos.

| Caso | Responsable | Prioridad | Técnica |
| --- | --- | --- | --- |
| CP-CAT-01 Ordenamiento por nombre | Franco | Media | Partición de equivalencia |
| CP-CAT-02 Ordenamiento por precio | Franco | Alta | Partición de equivalencia |
| CP-PRO-01 Omisión de opción obligatoria | Franco | Alta | Partición de equivalencia |
| CP-PRO-02 Opciones válidas y variación de precio | Franco | Alta | Partición de equivalencia |
| CP-CAR-01 Actualización de cantidad válida | Franco | Alta | Partición de equivalencia |
| CP-CAR-02 Cantidad inválida o superior al stock | Franco | Alta | Partición de equivalencia y valores límite |
| CP-CUP-01 Aplicación de cupón válido | Franco | Alta | Partición de equivalencia |
| CP-CUP-02 Cupón inválido, no aplicable o duplicado | Franco | Alta | Tabla de decisión y transición de estados |
| CP-CHK-01 Checkout invitado hasta pago | Granit | Alta | Partición de equivalencia |
| CP-CON-01 Número y resumen del pedido | Granit | Alta | Prueba de caso de uso |
| CP-CON-02 Prevención de pedidos duplicados | Granit | Alta | Transición de estados |
| CP-ADM-01 Agotado en panel reflejado públicamente | Granit | Alta | Tabla de decisión |
| CP-PED-01 Pedido público visible en panel | Granit | Alta | Prueba de caso de uso |
| CP-RNF-01 Tiempo de actualización público a administración | Granit | Alta | Transición de estados y medición temporal |
| CP-RNF-02 Compatibilidad en navegadores | Granit | Media | Partición de equivalencia |
| CP-RNF-03 Tiempo de respuesta del catálogo | Granit / Franco | Alta | Medición de rendimiento con umbral |
| CP-CAT-03 Categoría y filtros del catálogo | Franco | Media | Partición de equivalencia |
| CP-VAL-01 Certificados de regalo | Franco | Media | Tabla de decisión |

## 3.1 Técnicas y oráculos

Partición de equivalencia: criterios de orden, campo presente/ausente y cupones válidos/inválidos. Valores límite:CP-CAR-02 usa 0/1 y 147/148 junto a la frontera real de stock; no se confunde un umbral temporal con generar entradas controladas alrededor de él. Tabla de decisión:CP-CUP-02 cruza validez y elegibilidad;CP-ADM-01 cruza stock y política. Transición de estados: reaplicación de cupón y reintento de orden. Casos de uso complementan la comparación entre interfaces.

| Regla cupón | Vigente/activo | Elegible | Ya aplicado | Acción esperada |
| --- | --- | --- | --- | --- |
| A/B | No | Indiferente | No | Error, sin nuevo descuento |
| C | Sí | No | No | Error, sin nuevo descuento |
| D1 | Sí | Sí | No | Aplicar una vez |
| D2 | Sí | Sí | Sí | No acumular |
| E | Sí | De Sí a No | Sí | Retirar o recalcular según regla |

Datos volátiles: recapturar precios, stock, opciones, cupones, pago y hora antes de cada ejecución. No reutilizar 147 o 122 como constante permanente. Moneda USD e idioma inglés en corrida actual. Datos personales usados son ficticios; no se completaron compras ni se enviaron correos. Tokens de sesión no son datos de prueba y se eliminan de registros exportados cuando aparecen.

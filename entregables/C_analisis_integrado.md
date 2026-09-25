# 2. Análisis de pruebas y trazabilidad

Matriz vigente: 26 condiciones, cada una vinculada a requisito o alcance/riesgo explícito y a caso. Alta incluye justificación de impacto. Todos los 11 requisitos originales tienen al menos un caso de diseño; esto no significa que los 11 hayan sido verificados satisfactoriamente.

| Condición / qué comprobar | Base / origen | Prioridad / riesgo | Caso(s) / razón |
| --- | --- | --- | --- |
| CT-CAT-01: Orden correcto por nombre en ambos sentidos. | E-RF01; Directa | Media; R11 | CP-CAT-01. Afecta localización; impacto monetario indirecto. |
| CT-CAT-02: Precios de venta monótonos, mismos productos, ascendente y descendente. | E-RF01; Directa | Alta; R09 | CP-CAT-02. Un orden incorrecto distorsiona la comparación económica de productos. |
| CT-CAT-03: Categoría/filtro limita el conjunto y comunica resultado vacío. | Alcance p.4; Derivada | Media; R11 | CP-CAT-03. Cobertura complementaria del catálogo. |
| CT-PRO-01: Omisión aislada de opción requerida impide añadir y señala el campo. | E-RF02; Directa | Alta; R04 | CP-PRO-01. Evita pedidos de variantes incompletas o imposibles de preparar. |
| CT-PRO-02: Selección válida se conserva y se añade una sola línea correcta. | E-RF02; Derivada | Alta; R04 | CP-PRO-02. La variante comprada determina qué se entrega. |
| CT-PRO-03: El ajuste de precio de opción coincide con configuración y política fiscal. | E-RF02 / E-RF03; Derivada | Alta; R03 | CP-PRO-02. El error altera el importe cobrado. |
| CT-CAR-01: Cantidad válida actualiza línea, subtotal, impuestos y total coherentemente. | E-RF03; Directa | Alta; R03 | CP-CAR-01. Discrepancias monetarias afectan directamente al cliente. |
| CT-CAR-02: Cero, negativo, decimal, texto y vacío no dejan cantidades inválidas comprables. | E-RF03; Derivada | Alta; R03 | CP-CAR-02. Evita totales o unidades imposibles; normalizaciones se registran aparte. |
| CT-CAR-03: S es admisible y S+1 señala insuficiencia; bloqueo según política de stock. | E-RF08 / riesgo p.5; Derivada | Alta; R05 | CP-CAR-02. La sobreventa es una queja central del caso. |
| CT-CUP-01: Código vigente y elegible aplica el descuento correcto una vez. | E-RF04; Directa | Alta; R02 | CP-CUP-01. Protege el margen comercial y el importe final. |
| CT-CUP-02: Código inexistente, vencido o deshabilitado muestra error sin descuento nuevo. | E-RF04; Directa | Alta; R02 | CP-CUP-02. Una aceptación indebida reduce el ingreso sin autorización comercial. |
| CT-CUP-03: Cupón vigente pero no elegible se rechaza sin descuento. | E-RF04; Derivada | Alta; R02 | CP-CUP-02. Impide extender promociones a productos no cubiertos. |
| CT-CUP-04: Reaplicar el mismo cupón no acumula el descuento. | Riesgo p.5; Derivada | Alta; R06 | CP-CUP-02. La duplicación de descuentos es riesgo expreso del caso. |
| CT-CUP-05: Cambiar cantidad/productos revalida mínimo y elegibilidad. | E-RF04; Derivada | Alta; R06 | CP-CUP-02. Evita conservar beneficios cuando desaparece su precondición. |
| CT-CUP-06: Certificado válido respeta saldo y certificado inválido no descuenta. | Alcance p.4; Derivada | Media; R12 | CP-VAL-01. Complemento de alcance; sin evidencia de exposición alta en esta corrida. |
| CT-CHK-01: Invitado avanza sin crear cuenta ni imponer contraseña. | E-RF05; Directa | Alta; R07 | CP-CHK-01; CP-CON-01. Es el recorrido de compra exigido por el caso. |
| CT-CHK-02: Apellido obligatorio vacío se identifica; datos válidos se guardan. | E-RF05; Derivada | Alta; R07 | CP-CHK-01. Datos incompletos comprometen el procesamiento del pedido. |
| CT-CHK-03: Hay método de pago aplicable antes de confirmar. | E-RF05; Derivada | Alta; R07 | CP-CHK-01. Su ausencia interrumpe el flujo crítico. |
| CT-CON-01: Confirmación genera un identificador de orden no vacío. | E-RF06; Directa | Alta; R08 | CP-CON-01. Sin identificador no hay seguimiento confiable. |
| CT-CON-02: Resumen confirmado conserva productos, opciones, cantidades e importes. | E-RF06; Directa | Alta; R03 | CP-CON-01. Evita divergencias entre intención de compra y pedido. |
| CT-CON-03: Doble clic, recarga y retorno no crean pedidos adicionales. | E-RF06; Derivada | Alta; R08 | CP-CON-02. Evita cobro y preparación duplicados. |
| CT-PED-01: Orden propia aparece en panel con igual ID y detalle. | E-RF07; Directa | Alta; R08 | CP-PED-01. Una orden invisible impide su atención operativa. |
| CT-ADM-01: Stock cero guardado y estado agotado se reflejan en interfaz pública. | E-RF08; Directa | Alta; R01 / R05 | CP-ADM-01. Evita anunciar disponibilidad contradictoria al inventario confirmado. |
| CT-RNF-01: Orden pública se refleja en panel sin reinicio; medir contra referencia interna de 60 s. | E-RNF01; Operacionalizada | Alta; R08 | CP-RNF-01. La demora puede causar pérdida de atención o reintentos. |
| CT-RNF-02: Mismo recorrido funciona en Chrome, Edge y Firefox seleccionados. | E-RNF02; Operacionalizada | Media; R10 | CP-RNF-02. Se prioriza después de los riesgos transaccionales comunes. |
| CT-RNF-03: Carga completa de catálogo inferior a 2000 ms bajo protocolo declarado. | E-RNF03; Operacionalizada | Alta; R09 | CP-RNF-03. La lentitud afecta la operación de entrada al flujo de compra. |

## 2.1 Cobertura de requisitos clave

| Base | Casos | Resultado de cobertura |
| --- | --- | --- |
| E-RF01 | CP-CAT-01/02 | Diseño completo de nombre/precio; sólo precio ejecutado por prioridad. |
| E-RF02 | CP-PRO-01/02 | Omisión pasa; positivo/opciones bloqueado. |
| E-RF03 | CP-CAR-01/02 | Recálculo falla; cantidades/frontera ensayadas. |
| E-RF04 | CP-CUP-01/02 | Rechazo inválido observado; descuento válido/duplicación bloqueados. |
| E-RF05 | CP-CHK-01; CP-CON-01 | Preparación de invitado falla en pago; compra final bloqueada. |
| E-RF06 | CP-CON-01/02 | Confirmación e idempotencia bloqueadas. |
| E-RF07 | CP-PED-01 | Bloqueado por falta de orden propia. |
| E-RF08 | CP-ADM-01; CP-CAR-02 | Cambio administrativo bloqueado; frontera de stock sólo cubre detalle derivado. |
| E-RNF01 | CP-RNF-01 | Dirección corregida; bloqueado sin orden pública. |
| E-RNF02 | CP-RNF-02 | Diseñado Media; no ejecutado en selección actual. |
| E-RNF03 | CP-RNF-03 | Diseñado; medición verificable bloqueada. |

La cobertura se calcula sobre los 8 requisitos funcionales y los 3 requisitos no funcionales del Caso 3. Cada requisito tiene al menos una condición y un caso de prueba relacionado. Las variantes de datos se registran dentro de su caso y no se contabilizan como casos adicionales.

Escala: probabilidad P1 baja, P2 media, P3 alta; impacto I1 menor, I2 operacional, I3 dinero/flujo crítico. Exposición=P×I; 6-9 Alta, 3-4 Media, 1-2 Baja. Estimaciones cualitativas del equipo, no probabilidades estadísticas. La prioridad de condiciones/casos sigue esa exposición; un bloqueo no reduce riesgo. R12 queda Media, coherente conCP-VAL-01, sin condición Alta contradictoria.

| ID / riesgo | P×I / nivel | Responsable | Tratamiento / casos |
| --- | --- | --- | --- |
| R01 Inventario divergente entre ficha, carrito y panel | 3 x 3=9 / Alta | Franco / Granit | Verificar S y S+1; contrastar estado guardado con sitio público. CP-CAR-02; CP-ADM-01 |
| R02 Cupón válido rechazado o descuento incorrecto | 3 x 3=9 / Alta | Franco | Confirmar vigencia, estado, elegibilidad, base y tipo de descuento antes de probar. CP-CUP-01; CP-CUP-02 |
| R03 Importes de línea, impuestos o total inconsistentes | 3 x 3=9 / Alta | Franco / Granit | Comparar magnitudes con igual tratamiento fiscal y recalcular a dos decimales. CP-CAR-01; CP-PRO-02; CP-CON-01 |
| R04 Compra con opción obligatoria ausente o distinta | 2 x 3=6 / Alta | Franco | Omitir campo aislado; comparar opción elegida y conservada en carrito. CP-PRO-01; CP-PRO-02 |
| R05 Venta por encima de stock real | 3 x 3=9 / Alta | Franco / Granit | Leer stock actual y política; no equiparar botón activo a venta completada. CP-CAR-02; CP-ADM-01 |
| R06 Acumulación indebida o permanencia de descuentos | 2 x 3=6 / Alta | Franco | Reaplicar código y cambiar elegibilidad; exigir una sola aplicación. CP-CUP-02 |
| R07 Checkout invitado no completado | 3 x 3=9 / Alta | Granit | Validar campos, pago disponible y confirmación sin cuenta. CP-CHK-01; CP-CON-01 |
| R08 Pedido perdido o duplicado en administración | 2 x 3=6 / Alta | Granit | Usar orden propia, contar coincidencias y medir público a panel. CP-CON-02; CP-PED-01; CP-RNF-01 |
| R09 Catálogo lento o precio ordenado incorrectamente | 2 x 3=6 / Alta | Franco / Granit | Secuencia de precios de venta y medición instrumentada del catálogo. CP-CAT-02; CP-RNF-03 |
| R10 Incompatibilidad en navegador seleccionado | 2 x 2=4 / Media | Granit | Diseño común en Chrome, Edge y Firefox; no generalizar un motor a los demás. CP-RNF-02 |
| R11 Orden por nombre o filtros confusos | 2 x 2=4 / Media | Franco | Comparar conjuntos y orden; vacíos y filtros sin resultados. CP-CAT-01; CP-CAT-03 |
| R12 Certificado de regalo aceptado indebidamente | 1 x 3=3 / Media | Franco | Verificar saldo y vigencia; no probar certificados ajenos. CP-VAL-01 |

Riesgos de proyecto: demo compartido cambia datos, permisos limitados, bloqueo de acceso, ausencia de instrumentos y fecha de entrega. Mitigación: identificar precondiciones por corrida, conservar capturas, ejecutar independientes, reportar bloqueos y preparar fixtures para un ambiente controlado. Responsable de coordinación: ambos integrantes.

# 4.5 Hallazgos relevantes

Severidad estima impacto; prioridad propone urgencia de atención, sin atribuir decisión a un Product Owner no consultado. Defecto confirmado aquí significa comportamiento observable contrario al oráculo, no causa de código demostrada. Estado de DEF-01: abierto/reproducido. DEF-04: abierto, en análisis de causa/configuración. Los demás son observaciones o confirmaciones, no errores de código inventados.

## DEF-01 - Total de línea inconsistente al aumentar cantidad

Clasificación: Defecto observable reproducido; causa raíz no confirmada. Severidad: Alta. Prioridad propuesta: Alta.

Trazabilidad: E-RF03 -> CT-CAR-01 -> CP-CAR-01. Pasos: Añadir iPod Nano 1; abrir carrito; cambiar a 2 y actualizar.

Esperado: 122 por 2 =244 en la línea, misma semántica fiscal; total general 244. Obtenido: Línea 242; unitario 122; total 244; subtotal 200, Eco Tax 4 y VAT40. Reproducido 25/09.

Evidencia (Anexo A): CP-CAR-01_qty1 / qty 2; H-OC04. Recomendación: Revisar cálculo/presentación de línea, especialmente tasa fija por cantidad como hipótesis. Reprobar 1, 2 y frontera de stock tras corrección.

## DEF-04 - Checkout invitado sin método de pago seleccionable

Clasificación: Fallo del recorrido probado; configuración/causa en análisis. Severidad: Crítica para el recorrido ensayado. Prioridad propuesta: Alta.

Trazabilidad: E-RF05 -> CT-CHK-03 -> CP-CHK-01. Pasos: Carrito Nano 1; elegir Guest; completar dirección ficticia UK/London; continuar; Choose en Payment Method.

Esperado: Método aplicable seleccionable que permita continuar. Obtenido: No Payment options are available. Please contact us for assistance! Confirm Order deshabilitado. Historial 24/09 muestra COD habilitado en All Zones; no demuestra todas las condiciones de aplicabilidad.

Evidencia (Anexo A): CP-CHK-01_sin-pago; H-OC01, H-OC02, H-OC05. Recomendación: Investigar aplicabilidad, producto/envío/configuración y permisos. No afirmar que ningún cliente puede comprar ni que la causa sea sincronización.

## OBS-02 - Disponibilidad de ficha no garantiza stock utilizable

Clasificación: Observación; reemplaza clasificación automática de DEF-02. Severidad: Alta potencial. Prioridad propuesta: Alta de investigación.

Trazabilidad: E-RF08 -> CT-CAR-03 -> CP-CAR-02 (preparación). Pasos: Abrir HTC In Stock; añadir 1; abrir carrito; contrastar inventario administrativo 0.

Esperado: Comunicación coherente del stock disponible. Obtenido: Ficha In Stock, carrito***; panel 0. Una etiqueta de agotado configurada como In Stock puede explicar presentación. No hay venta sin stock demostrada.

Evidencia (Anexo A): CAR-precondicion-HTC; historial de configuración. Recomendación: Revisar etiqueta Out Of Stock Status y regla comercial antes de declarar defecto de código.

## OBS-03 - Confirmación deshabilitada cuando falta pago

Clasificación: Comportamiento observado; no se confirma como defecto. Severidad: Informativa. Prioridad propuesta: Baja.

Trazabilidad: E-RF06 -> CT-CON-01 -> CP-CON-01. Pasos: Llegar al checkout sin método de pago y observar Confirm Order.

Esperado: No confirmar sin pago y comunicar el impedimento. Obtenido: El botón aparece deshabilitado y el aviso de pago es visible.

Evidencia (Anexo A): CP-CHK-01_sin-pago; H-OC05. Recomendación: Mantener esta validación en la regresión del checkout cuando exista un método de pago aplicable.

## OBS-F01 - Opciones requeridas sin alternativas seleccionables

Clasificación: Impedimento de datos/configuración; defecto de código no confirmado. Severidad: Alta en productos afectados. Prioridad propuesta: Alta.

Trazabilidad: E-RF02 -> CT-PRO-02/03 -> CP-PRO-02. Pasos: Abrir Apple Cinema, Canon y Product 8; inspeccionar Radio/Select/Size.

Esperado: Para caso positivo, todas las opciones requeridas deben ser seleccionables. Obtenido: Radio de Apple sin valores; Canon y Product 8 sólo placeholder. Se bloquea configuración válida.

Evidencia (Anexo A): PRO-APPLE; CP-PRO-02_bloqueo; CP-PRO-01_resultado. Recomendación: Provisionar producto de prueba con opciones activas y stock por opción; repetirCP-PRO-02.

## OBS-F02 - No hay cupón vigente para prueba positiva

Clasificación: Impedimento de datos. Severidad: Alta para cobertura. Prioridad propuesta: Alta.

Trazabilidad: E-RF04 -> CT-CUP-01/03/04/05 -> CP-CUP-01/02. Pasos: Administración Marketing>Coupons; revisar los 3 registros.

Esperado: Cupón de prueba vigente y elegible disponible. Obtenido: 1111, 2222, 3333 deshabilitados; vencen en 2014/2020. No hay representante válido.

Evidencia (Anexo A): CP-CUP-01_cupones-no-vigentes; CP-CUP-01_admin.txt. Recomendación: Proveedor del ambiente debe habilitar fixture controlado; no convertir 2222 en válido por su nombre.

## OBS-F03 - Cantidades inválidas se normalizan sin aviso específico

Clasificación: Observación de usabilidad; no fallo contra oráculo mínimo previo. Severidad: Media. Prioridad propuesta: Media.

Trazabilidad: E-RF03 -> CT-CAR-02 -> CP-CAR-02. Pasos: En Nano 1 probar 1.5,-1, abc y vacío, restableciendo línea entre variantes.

Esperado: No conservar cantidad inválida comprable; sería preferible error explícito. Obtenido: 1.5 y vacío quedan 1; -1 yabc retiran línea. No quedan cantidades inválidas comprables, pero cambia intención sin explicación.

Evidencia (Anexo A): CP-CAR-02_decimal; negativo; texto; vacio. Recomendación: Acordar regla de negocio explícita y mejorar validación; no cambiar retroactivamente el oráculo para fabricar fallo.

## CONF-F01 - Orden por precio y omisión obligatoria funcionan en la muestra

Clasificación: Confirmación relevante. Severidad: Informativa. Prioridad propuesta: Baja.

Trazabilidad: E-RF01/E-RF02 -> CT-CAT-02/CT-PRO-01 -> CP-CAT-02/CP-PRO-01. Pasos: Ordenar 12 productos asc/desc; omitir Select en Canon y añadir.

Esperado: Monotonía y rechazo de omisión. Obtenido: Ambos criterios cumplen en la muestra; no demuestra cobertura de todos los productos.

Evidencia (Anexo A): CP-CAT-02_asc; desc; CP-PRO-01_resultado. Recomendación: Candidatos a regresión automatizada con conjunto estable.

## CONF-F02 - Cantidad superior al stock bloquea checkout

Clasificación: Confirmación relevante. Severidad: Informativa. Prioridad propuesta: Baja.

Trazabilidad: E-RF08 derivado -> CT-CAR-03 -> CP-CAR-02. Pasos: Leer 147 enpanel; actualizar carrito a 147 y luego 148; intentar Checkout.

Esperado: Sin insuficiencia en S; restricción al exceder S. Obtenido: 147 sin***; 148 con*** y regreso a carrito con advertencia. No se creó orden.

Evidencia (Anexo A): CP-CAR-02_stock147; stock S; stock Smas 1; stock-bloquea-checkout. Recomendación: Automatizar frontera en ambiente donde el stock pueda fijarse y restaurarse.

Gestión propuesta: Nuevo -> En análisis -> Asignado -> En corrección -> Listo para reprueba -> Cerrado; rechazo, duplicado, diferido y reabierto se registran con motivo. Nadie corrigió código del demo en este proyecto. Sólo una nueva ejecución satisfactoria después de la corrección permitiría cerrar un defecto; mejorar este informe no cierra DEF-01/04.

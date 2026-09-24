# BITÁCORA DE AMBIENTE — Caso 3 OpenCart
Registro fechado del estado del sistema bajo prueba. Toda ejecución debe citar la entrada de bitácora vigente.
Responsable: Granit (Integrante 2).

| Fecha | Hora aprox. | Origen de acceso | Evento observado | Evidencia literal | Efecto sobre las pruebas |
|---|---|---|---|---|---|
| 18-09-2026 | — | Navegador del equipo | Usuario admin `demo` sin permisos de escritura | "Warning: You do not have permission to modify coupons" | Bloquea condiciones que requieren configuración administrativa |
| 18-09-2026 | — | Navegador del equipo | Checkout bloqueado por advertencia de stock | "Products marked with *** are not available in the desired quantity or not in stock!" | Impide generar orden |
| 24-09-2026 | — | Entorno de automatización (IP de datacenter) | Dominio del demo responde HTTP 403 tras desafío de Cloudflare | "Sorry, you have been blocked" · Ray ID a3ffd6a6fe936f20 y a3ffdaf1d8966f2f | Indisponibilidad total desde ese origen |
| 24-09-2026 | — | Navegador local del estudiante (IP residencial) | Acceso restablecido; el bloqueo es por origen de red, no del sitio | Portada "Your Store" con catálogo completo; footer "Your Store © 2026" | Ejecución posible solo desde el origen autorizado |
| 24-09-2026 | — | Navegador local | Ruta real del panel administrativo | `https://demo.opencart.com/TlbeVW/` (no `/admin/`); credenciales publicadas por opencart.com: demo/demo | Requiere autenticación manual del responsable |
| 24-09-2026 | — | Navegador local | Checkout sin métodos de pago ni de envío configurados | "No Payment options are available. Please contact us for assistance!" · no existe sección "Shipping Method" | **Bloquea CP-CON-01, CP-CON-02, CP-PED-01 y CP-RNF-01** |

## Regla de registro
1. Ninguna ejecución se considera válida sin entrada de bitácora del día.
2. El estado del inventario y de los cupones del demo es volátil y compartido: se documenta el valor observado y su hora.
3. Un impedimento del ambiente se registra como **Bloqueado**, nunca como **Fallido**. La distinción se sostiene en esta bitácora.

## Entrada adicional — 24-09-2026, 02:45
| Fecha | Hora | Origen | Evento | Evidencia literal | Efecto |
|---|---|---|---|---|---|
| 24-09-2026 | 02:45 | Panel administrativo autenticado (usuario `demo`) | Intento de fijar `Quantity = 0` en el producto HP LP3065 y guardar | **"Warning: You do not have permission to modify products!"** | El cambio **no se persistió**: el formulario conserva `Quantity = 1000` y `Out Of Stock Status = Out Of Stock`. **Bloquea CP-ADM-01 y CP-RNF-01** |

Consecuencia: el ambiente no fue alterado por el equipo; no se requirió restauración de datos. La restricción es del
ambiente público de prueba y **no constituye un defecto del producto**, a diferencia de DEF-04.
Evidencia: `evidencias/CP-ADM-01/CP-ADM-01_paso03_warning-permiso-modificar-productos_20260924.png`

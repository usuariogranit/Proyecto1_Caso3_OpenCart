# ESTRATEGIA DE RESILIENCIA DEL AMBIENTE DE PRUEBAS
### Tropicalización: prácticas reales de la industria aplicadas a este proyecto

El sistema bajo prueba es un demo público, compartido, volátil y fuera de nuestro control. La industria ya
resolvió problemas de esta familia; adoptamos sus decisiones de diseño en lugar de improvisar.

| Práctica real de la industria | Qué problema resuelve allá | Cómo la aplicamos aquí |
|---|---|---|
| **Instalación parcial + descarga de caché por región** (videojuegos: se instala el núcleo y los assets llegan después desde un CDN cercano) | El origen puede estar lejos, saturado o caído; el usuario no puede quedar bloqueado | **Snapshot local de cada página evaluada** en `snapshots/`. La evidencia deja de depender de que el demo siga vivo o con los mismos datos |
| **Mirror / réplica de origen** (paquetes npm, apt, Steam) | Si el origen falla, el trabajo continúa desde la réplica | **Instancia local de OpenCart** como ambiente espejo declarado, solo para las condiciones que el demo bloquea por permisos |
| **Feature flag y degradación controlada** (Netflix, Amazon) | Cuando un servicio cae, la app sigue funcionando con menos capacidad, no se cae entera | **Plan de ejecución por capas:** primero todo lo ejecutable sin permisos ni pedido; lo demás se marca Bloqueado con causa, sin detener el avance |
| **Datos sintéticos propios, no datos de producción** (banca, salud) | No depender de datos ajenos ni exponer información real | **Datos de prueba fijos y ficticios** definidos por nosotros (`Test / QA CS5383 / qa.cs5383.test@example.com`), nunca datos personales reales |
| **Canary / smoke test previo al despliegue** | Detectar temprano que el ambiente no sirve antes de gastar el esfuerzo grande | **Verificación de ambiente obligatoria** al inicio de cada sesión: portada carga, producto en stock existe, admin responde. Si falla, se registra en bitácora y no se ejecuta |
| **Idempotencia y control de reintentos** (APIs de pago) | Evitar cobros o pedidos duplicados por reintento | Es justamente lo que evalúa **CP-CON-02**: el sistema debe resistir doble clic y recarga sin duplicar el pedido |
| **Observabilidad y trazas fechadas** (SRE) | Poder explicar después qué pasó y cuándo | **Bitácora de ambiente** con hora, origen de acceso, texto literal del sistema e identificadores (Ray ID) |
| **Congelar versión del entorno** (contenedores, lockfiles) | Que el resultado sea reproducible mañana | **Gestión de la Configuración** del testware: versión del documento, fecha de ejecución y estado del demo declarados en cada caso |

## Consecuencia metodológica
La indisponibilidad y la falta de permisos **no son excusas, son resultados de prueba**: alimentan el registro de
riesgos, la tasa de bloqueo y, al final, el dictamen. Un bloqueo bien documentado y trazable vale más que un caso
aprobado sin evidencia.

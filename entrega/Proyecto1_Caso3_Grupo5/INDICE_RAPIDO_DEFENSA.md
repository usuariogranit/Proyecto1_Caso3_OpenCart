# ÍNDICE RÁPIDO DE DEFENSA — Grupo 5
Para tener abierto durante la exposición. **Las páginas son del PDF único**
`Proyecto1_Caso3_Grupo5_PRESENTACION_E_INFORME.pdf` (68 páginas: láminas 1–17, informe 18–68).
Entre paréntesis, la página equivalente del informe suelto.

## Respuestas por pregunta

| Si pregunta… | Está en | PDF | Informe |
|---|---|---|---|
| ¿Cuáles son los requisitos? | §2 Análisis y trazabilidad — matriz de 26 condiciones | **23–24** | 6–7 |
| ¿Cómo saben que cubrieron los requisitos? | §2.1 Cobertura de requisitos clave | **24** | 7 |
| ¿Qué técnicas usaron y por qué? | §3.1 Técnicas y oráculos | **26** | 9 |
| ¿Dónde están los casos de prueba? | §3.2 Fichas — una página por caso | **28–45** | 11–28 |
| ¿Dónde y cómo ejecutaron? | §4.1 Ambiente y método de registro | **46** | 29 |
| ¿Cuáles pasaron y cuáles no? | §4.2 Registro de los 14 casos Alta | **46** | 29 |
| ¿Qué pasó en cada variante? | §4.3 Detalle de variantes y desviaciones | **47** | 30 |
| ¿De dónde salen los porcentajes? | §4.4 Métricas y límites | **48** | 31 |
| ¿Cuáles son los defectos? | §4.5 Hallazgos relevantes | **49–51** | 32–34 |
| ¿Cuál es la conclusión? | §5.1 Conclusión de pruebas | **52** | 35 |
| ¿Qué automatizarían? | §5.2 Recomendaciones de automatización | **52** | 35 |
| ¿Qué quedó fuera del alcance? | §1.2 Alcance incluido y excluido | **19** | 2 |
| ¿Qué nivel de prueba fue? | §1.3 Estrategia y niveles | **19–20** | 2–3 |
| ¿Cuáles son los criterios de salida? | §1.4 Criterios de entrada, salida, suspensión y reanudación | **20** | 3 |
| ¿Cómo priorizaron? | §1.6 Registro de riesgos de producto | **21** | 4 |

## Ficha de cada caso

| Caso | PDF | Responsable | Veredicto |
|---|---|---|---|
| CP-CAT-01 Ordenamiento por nombre | 28 | Franco | No ejecutado (Media) |
| CP-CAT-02 Ordenamiento por precio | 29 | Franco | **Pasó** |
| CP-PRO-01 Omisión de opción obligatoria | 30 | Franco | **Pasó** |
| CP-PRO-02 Opciones válidas y variación de precio | 31 | Franco | Bloqueado |
| CP-CAR-01 Actualización de cantidad válida | 32 | Franco | **Falló** → DEF-01 |
| CP-CAR-02 Cantidad inválida o superior al stock | 33 | Franco | **Pasó** |
| CP-CUP-01 Aplicación de cupón válido | 34 | Franco | Bloqueado |
| CP-CUP-02 Cupón inválido, no aplicable o duplicado | 35 | Franco | Bloqueado |
| CP-CHK-01 Checkout invitado hasta pago | 36 | Granit | **Falló** → DEF-04 |
| CP-CON-01 Número y resumen del pedido | 37 | Granit | Bloqueado |
| CP-CON-02 Prevención de pedidos duplicados | 38 | Granit | Bloqueado |
| CP-ADM-01 Agotado en panel reflejado públicamente | 39 | Granit | Bloqueado |
| CP-PED-01 Pedido público visible en panel | 40 | Granit | Bloqueado |
| CP-RNF-01 Tiempo de actualización público → panel | 41 | Granit | Bloqueado |
| CP-RNF-02 Compatibilidad en navegadores | 42 | Granit | No ejecutado (Media) |
| CP-RNF-03 Tiempo de respuesta del catálogo | 43 | Granit | Bloqueado |
| CP-CAT-03 Categoría y filtros | 44 | complementario | No ejecutado (Media) |
| CP-VAL-01 Certificados de regalo | 45 | complementario | No ejecutado (Media) |

## Casos por requisito (§2.1, p. 24)

| Requisito | Casos | Cuáles |
|---|---|---|
| E-RF01 catálogo y orden | 2 | CP-CAT-01, CP-CAT-02 |
| E-RF02 ficha y opciones | 2 | CP-PRO-01, CP-PRO-02 |
| E-RF03 recálculo de importes | **3** | CP-CAR-01, CP-CAR-02, CP-PRO-02 |
| E-RF04 cupones | 2 | CP-CUP-01, CP-CUP-02 |
| E-RF05 checkout invitado | 2 | CP-CHK-01, CP-CON-01 |
| E-RF06 confirmación | 2 | CP-CON-01, CP-CON-02 |
| E-RF07 pedidos en panel | 1 | CP-PED-01 |
| E-RF08 stock administrativo | 2 | CP-ADM-01, CP-CAR-02 |
| RNF-01 / RNF-02 / RNF-03 | 1 c/u | CP-RNF-01 / CP-RNF-02 / CP-RNF-03 |

11 requisitos clave · 18 casos · 26 condiciones · promedio 1.7 casos por requisito · ninguno sin cobertura de diseño.

## Cifras de memoria
18 diseñados · 14 Alta · 4 Media · **3 Pasó · 2 Falló · 9 Bloqueado**
Ejecución concluyente **5/14 = 35.7 %** · Aprobación **3/5 = 60 %** · Bloqueo **9/14 = 64.3 %**
Denominadores: bloqueo sobre planificados Alta · aprobación sobre concluyentes.
Defectos abiertos: **DEF-01** (Alta) y **DEF-04** (Crítica para el recorrido). Observaciones: OBS-02, OBS-03, OBS-F01, OBS-F02, OBS-F03. Confirmaciones: CONF-F01, CONF-F02.

## Tipo de verificación
Pruebas **dinámicas, de caja negra, a nivel de sistema**, funcionales y no funcionales, con enfoque **basado en riesgos** y **ejecución manual**. Integración observada desde la interfaz (sitio ↔ panel). Cinco técnicas: partición de equivalencia, valores límite, tabla de decisión, transición de estados y casos de uso.
Excluido y declarado: unitarias, carga/estrés, seguridad, pagos reales, caja blanca, combinatoria completa de navegadores.

## Trazabilidad de la evidencia
Fila del registro (§4.2) → archivo de evidencia → hora y URL en `informe/evidencias/franco-20260925/registro.json` (25 entradas) → hash SHA-256 en `informe/evidencias/manifest_integrado.json` (65 archivos).
Ambiente: `demo.opencart.com` y panel `demo.opencart.com/TlbeVW/`, OpenCart **4.0.2.3**, 24 y 25 de septiembre de 2026, manual por interfaz web.

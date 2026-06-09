# Harness Engineering — Índice de Documentación Extraída

> **ÍNDICE MAESTRO** de todos los documentos generados. Úsalo para navegar según lo que necesites entender.

---

## 📚 Documentos Generados

Este proyecto contiene **4 documentos complementarios** sobre la implementación del Harness:

| Documento | Ubicación | Propósito | Para quién | Tamaño |
|-----------|-----------|----------|-----------|--------|
| **Guía Completa** | `IMPLEMENTACION_HARNESS.md` | Referencia exhaustiva, técnica | Arquitectos, líderes | 📖📖📖 (Grande) |
| **Resumen Visual** | `RESUMEN_HARNESS_VISUAL.md` | Visión rápida, diagramas ASCII | Todos (empieza aquí) | 📄 (Mediano) |
| **Referencias Rápidas** | `REFERENCIAS_RAPIDAS_POR_ROL.md` | Checklists por rol | Cada agente (spec_author, implementer, reviewer) | 📋 (Pequeño) |
| **Este índice** | `INDICE_DOCUMENTOS.md` | Navegar entre documentos | Todos | 📌 (Mínimo) |

---

## 🎯 Cómo Usar Esta Documentación

### Si recién empiezas...

```
START HERE: Lee en este orden:
  1. RESUMEN_HARNESS_VISUAL.md (15 min)
     → Entiende los 4 pilares y el flujo general
  
  2. REFERENCIAS_RAPIDAS_POR_ROL.md (10 min)
     → Ve qué corresponde a tu rol
  
  3. IMPLEMENTACION_HARNESS.md (30 min)
     → Si necesitas detalle sobre algo específico
```

### Si eres LEADER...

```
LEE PRIMERO:
  → Sección "Para el LEADER" en REFERENCIAS_RAPIDAS_POR_ROL.md
  → Sección "Orquestación Multi-Agente" en IMPLEMENTACION_HARNESS.md
  → Sección "Protocolo de arranque" en RESUMEN_HARNESS_VISUAL.md

CUANDO NECESITES DETALLES:
  → "Flujo de Trabajo Completo" en IMPLEMENTACION_HARNESS.md
  → "Los 4 Agentes" en RESUMEN_HARNESS_VISUAL.md
```

### Si eres SPEC AUTHOR...

```
LEE PRIMERO:
  → Sección "Para el SPEC AUTHOR" en REFERENCIAS_RAPIDAS_POR_ROL.md
  → Sección "Spec Driven Development" en RESUMEN_HARNESS_VISUAL.md

CUANDO REDACTES SPECS:
  → "requirements.md — EARS estricto" en IMPLEMENTACION_HARNESS.md
  → "design.md — Decisiones técnicas" en IMPLEMENTACION_HARNESS.md
  → "tasks.md — Checklist ejecutable" en IMPLEMENTACION_HARNESS.md
```

### Si eres IMPLEMENTER...

```
LEE PRIMERO:
  → Sección "Para el IMPLEMENTER" en REFERENCIAS_RAPIDAS_POR_ROL.md
  → Sección "Verificación y Control de Calidad" en IMPLEMENTACION_HARNESS.md

CUANDO IMPLEMENTES:
  → "El Script init.sh" en IMPLEMENTACION_HARNESS.md
  → "Los Tests" en IMPLEMENTACION_HARNESS.md
  → "Reglas Duras para el Implementer" en REFERENCIAS_RAPIDAS_POR_ROL.md
```

### Si eres REVIEWER...

```
LEE PRIMERO:
  → Sección "Para el REVIEWER" en REFERENCIAS_RAPIDAS_POR_ROL.md
  → Sección "CHECKPOINTS.md — Criterios de Estado Final Correcto" en IMPLEMENTACION_HARNESS.md

CUANDO REVISES:
  → "Trazabilidad (Regla Dura)" en IMPLEMENTACION_HARNESS.md
  → "Reglas de oro" en REFERENCIAS_RAPIDAS_POR_ROL.md
  → "Los 6 Checkpoints" en RESUMEN_HARNESS_VISUAL.md
```

---

## 📖 Contenido por Documento

### RESUMEN_HARNESS_VISUAL.md (Empieza aquí)

**Secciones:**
1. ¿Qué es un Harness?
2. Los 4 Archivos Clave
3. Estructura de Directorios
4. Los 4 Agentes y Sus Roles
5. El Proceso SDD
6. Flujo de Trabajo en 4 Pasos
7. La Trazabilidad (R<n> ↔ Test)
8. Los 6 Checkpoints
9. Reglas Duras
10. Checklist Rápida para Implementar
11. Un Ejemplo Real (Ficticio)
12. Diferencia con Código Tradicional
13. Resumen de Archivos Necesarios
14. La Frase Clave

**Usa esto para:** Entender rápidamente qué es un Harness y cómo funciona.

---

### REFERENCIAS_RAPIDAS_POR_ROL.md (Consulta durante trabajo)

**Secciones:**
- Para el LEADER (protocolo, flujo de decisión, instrucciones para subagentes)
- Para el SPEC AUTHOR (qué hacer, qué NO hacer, estructuras de archivos)
- Para el IMPLEMENTER (protocolo, qué hacer si te atascas)
- Para el REVIEWER (checklist, formato de veredicto, reglas de oro)
- Tabla rápida: Qué hace cada agente
- Abreviaturas
- Cosas que NO hacer
- Cosas que SÍ hacer

**Usa esto para:** Verificar qué toca hacer en cada momento.

---

### IMPLEMENTACION_HARNESS.md (Referencia técnica completa)

**Secciones:**
1. Concepto de Harness
2. Los 4 Pilares del Harness
3. Estructura de Directorios Requerida
4. Archivos Base (Obligatorios) — Detalle completo de cada archivo:
   - CLAUDE.md
   - AGENTS.md
   - feature_list.json
   - init.sh
   - progress/current.md
   - progress/history.md
   - CHECKPOINTS.md
   - docs/architecture.md
   - docs/conventions.md
   - docs/specs.md
   - docs/verification.md
   - .claude/settings.json
5. Orquestación Multi-Agente — Detalle de cada agente
6. Spec Driven Development (SDD) — Proceso, EARS, trazabilidad
7. Flujo de Trabajo Completo — Día 1 (Spec), Día 2 (Implementación)
8. Verificación y Control de Calidad
9. Reglas Duras (No Negociables)
10. Checklist de Implementación

**Usa esto para:** Entender cada componente en profundidad, implementar desde cero, resolver dudas técnicas.

---

### INDICE_DOCUMENTOS.md (Este archivo)

**Propósito:** Navegar entre documentos según tu necesidad.

---

## 🔍 Búsqueda Rápida por Tema

### Quiero entender...

**"¿Qué es un Harness?"**
→ RESUMEN_HARNESS_VISUAL.md § 1

**"¿Cómo fluye el trabajo?"**
→ RESUMEN_HARNESS_VISUAL.md § 4 (Flujo de Trabajo en 4 Pasos)
→ IMPLEMENTACION_HARNESS.md § 7 (Flujo de Trabajo Completo)

**"¿Cómo redacto specifications?"**
→ REFERENCIAS_RAPIDAS_POR_ROL.md § "Para el SPEC AUTHOR"
→ IMPLEMENTACION_HARNESS.md § 6 (Spec Driven Development - SDD)

**"¿Qué es EARS?"**
→ IMPLEMENTACION_HARNESS.md § "requirements.md — EARS estricto"

**"¿Cómo verifico que funciona?"**
→ REFERENCIAS_RAPIDAS_POR_ROL.md § "Para el IMPLEMENTER"
→ IMPLEMENTACION_HARNESS.md § 8 (Verificación y Control de Calidad)

**"¿Qué son los Checkpoints?"**
→ RESUMEN_HARNESS_VISUAL.md § 8
→ IMPLEMENTACION_HARNESS.md § "CHECKPOINTS.md"

**"¿Cuáles son las reglas duras?"**
→ REFERENCIAS_RAPIDAS_POR_ROL.md § "Reglas de oro"
→ RESUMEN_HARNESS_VISUAL.md § 9
→ IMPLEMENTACION_HARNESS.md § 9

**"¿Cuál es la trazabilidad?"**
→ RESUMEN_HARNESS_VISUAL.md § 7
→ IMPLEMENTACION_HARNESS.md § "Trazabilidad (Regla Dura)"

**"¿Cómo implemento un Harness desde cero?"**
→ RESUMEN_HARNESS_VISUAL.md § 10
→ IMPLEMENTACION_HARNESS.md § 10

---

## 📋 Resumen de Roles

### LEADER (Orquestador)

**Necesitas:** REFERENCIAS_RAPIDAS_POR_ROL.md § "Para el LEADER"

**Flujo de decisión:**
```
pending + sdd: true    → spec_author
spec_ready + aprobado  → implementer → reviewer
spec_ready + no aprobado → [PAUSA]
in_progress            → [ERROR: pregunta al humano]
```

---

### SPEC AUTHOR (Diseñador)

**Necesitas:** REFERENCIAS_RAPIDAS_POR_ROL.md § "Para el SPEC AUTHOR"

**Produces:**
- `specs/<name>/requirements.md` (EARS)
- `specs/<name>/design.md` (decisiones técnicas)
- `specs/<name>/tasks.md` (checklist)

**Key:** Cada R<n> verificable por test.

---

### IMPLEMENTER (Constructor)

**Necesitas:** REFERENCIAS_RAPIDAS_POR_ROL.md § "Para el IMPLEMENTER"

**Produces:**
- Código en `src/`
- Tests en `tests/`
- Trazabilidad en `progress/impl_<name>.md`

**Key:** Cada task acompañada de su test. `./init.sh` verde después de cada task.

---

### REVIEWER (Inspector)

**Necesitas:** REFERENCIAS_RAPIDAS_POR_ROL.md § "Para el REVIEWER"

**Verifica:**
- Trazabilidad: cada R<n> → test
- Tasks: todas [x] o justificadas [ ]
- `./init.sh` verde
- CHECKPOINTS.md C1-C6

**Key:** Concreto. Cita líneas y archivos. No apruebes con rojo.

---

## 📁 Estructura de Directorios

Todos estos documentos explican cómo generar:

```
.
├── .claude/
│   ├── agents/
│   │   ├── leader.md
│   │   ├── spec_author.md
│   │   ├── implementer.md
│   │   └── reviewer.md
│   └── settings.json
│
├── docs/
│   ├── architecture.md
│   ├── conventions.md
│   ├── specs.md
│   └── verification.md
│
├── specs/
│   └── <feature-name>/
│       ├── requirements.md
│       ├── design.md
│       └── tasks.md
│
├── progress/
│   ├── current.md
│   ├── history.md
│   └── <phase>_<feature>.md
│
├── src/         (Tu código)
├── tests/       (Tus tests)
│
├── CLAUDE.md
├── AGENTS.md
├── CHECKPOINTS.md
├── feature_list.json
├── init.sh
├── README.md
│
└── DOCUMENTOS EXTRAÍDOS:
    ├── IMPLEMENTACION_HARNESS.md ← Guía técnica completa
    ├── RESUMEN_HARNESS_VISUAL.md ← Resumen ejecutivo
    ├── REFERENCIAS_RAPIDAS_POR_ROL.md ← Checklists por rol
    └── INDICE_DOCUMENTOS.md ← Este archivo
```

---

## ✅ Checklist: ¿He Entendido el Harness?

```
[ ] ¿Puedo explicar los 4 pilares? (Repo = Sistema, Multi-agente, SDD, Verificable)
[ ] ¿Sé qué hace cada agente? (Leader, Spec Author, Implementer, Reviewer)
[ ] ¿Entiendo el flujo SDD? (pending → spec_ready → ⏸ HUMANO → in_progress → done)
[ ] ¿Sé qué es EARS? (5 patrones: Ubicuo, Evento, Estado, Opcional, No deseado)
[ ] ¿Sé qué es trazabilidad? (R<n> → test)
[ ] ¿Sé qué son los Checkpoints? (C1-C6, criterios objetivos)
[ ] ¿Puedo nombrar los 4 archivos base? (CLAUDE.md, AGENTS.md, feature_list.json, init.sh)
[ ] ¿Entiendo por qué el estado vive en `progress/`? (Sobrevive reinicios, versionable, en disco)
[ ] ¿Sé qué hace `./init.sh`? (Verifica entorno, specs, tests; exit 0 o 1)
[ ] ¿Puedo explicar la diferencia con código tradicional? (Menos sorpresas, menos retrabajos)
```

---

## 🎓 Pasos Siguientes

### Para aprender

1. Lee RESUMEN_HARNESS_VISUAL.md (15 min)
2. Lee REFERENCIAS_RAPIDAS_POR_ROL.md completo (20 min)
3. Busca en IMPLEMENTACION_HARNESS.md los temas que no entiendas (30 min)
4. ¡Implementa tu primer Harness! (2 horas)

### Para implementar

Sigue el **Checklist de Implementación** en:
- RESUMEN_HARNESS_VISUAL.md § 10
- IMPLEMENTACION_HARNESS.md § 10

### Para usar

1. Ejecuta `./init.sh`
2. Abre Claude Code en la raíz: `claude`
3. Pide: "implementa la siguiente feature pendiente"
4. El flujo empieza automáticamente

---

## 🔗 Referencias Internas Cruzadas

**RESUMEN_HARNESS_VISUAL.md** hace referencia a:
- IMPLEMENTACION_HARNESS.md (para detalles técnicos)
- REFERENCIAS_RAPIDAS_POR_ROL.md (para qué hacer ahora)

**REFERENCIAS_RAPIDAS_POR_ROL.md** hace referencia a:
- IMPLEMENTACION_HARNESS.md (para contexto)
- RESUMEN_HARNESS_VISUAL.md (para visión general)

**IMPLEMENTACION_HARNESS.md** hace referencia a:
- Todos los otros documentos (para resumen y referencias)
- El proyecto real (CLAUDE.md, AGENTS.md, etc.)

---

## 📝 Notas Importantes

### Estos documentos NO son el Harness

El Harness vive en:
- `CLAUDE.md`, `AGENTS.md`, `feature_list.json`, `init.sh`
- `.claude/agents/`, `docs/`, `specs/`, `progress/`

**Estos documentos** son un **análisis y extracción** de cómo está implementado el Harness en el proyecto de ejemplo. Son **para entender** la implementación, no **la implementación misma**.

### Cómo usar estos documentos en otro proyecto

1. Toma `IMPLEMENTACION_HARNESS.md` como guía
2. Copia los patrones a tu proyecto
3. Adapta `docs/architecture.md` a tu tech stack
4. Adapta `docs/conventions.md` a tu estilo de código
5. Ejecuta `./init.sh` y verifica que todo esté verde

---

## 🆘 Preguntas Frecuentes

**P: ¿Por dónde empiezo?**
R: RESUMEN_HARNESS_VISUAL.md, sección 1-4.

**P: ¿Cuál es la diferencia entre requirements.md y tasks.md?**
R: IMPLEMENTACION_HARNESS.md § "Los 3 Archivos de Spec"

**P: ¿Qué hago si me atasco como implementer?**
R: REFERENCIAS_RAPIDAS_POR_ROL.md § "Qué hacer si te atascas"

**P: ¿Cuándo aprueba el reviewer?**
R: REFERENCIAS_RAPIDAS_POR_ROL.md § "Reglas de oro"

**P: ¿Cómo documento la trazabilidad?**
R: IMPLEMENTACION_HARNESS.md § "Trazabilidad (Regla Dura)"

**P: ¿init.sh es obligatorio?**
R: SÍ. Es la única verificación objetiva. Lee IMPLEMENTACION_HARNESS.md § "init.sh".

---

## 📞 Contacto / Dudas

Si algo no está claro en estos documentos:

1. Relee la sección relevante en otro documento
2. Busca en IMPLEMENTACION_HARNESS.md con Ctrl+F
3. Consulta el proyecto real: lee los archivos en `.claude/agents/`

---

**Fin del índice de documentación.**

👉 **Siguiente paso:** Abre **RESUMEN_HARNESS_VISUAL.md** y empieza a leer.

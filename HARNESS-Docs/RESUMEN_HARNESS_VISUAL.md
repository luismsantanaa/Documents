# Harness Engineering — Resumen Visual y Rápida

> Este documento es un **resumen visual y ejecutivo** de la implementación del Harness.
> Lee esto primero para entender la estructura. Luego lee `IMPLEMENTACION_HARNESS.md` para detalle completo.

---

## 1. ¿Qué es un Harness?

Un **Harness** es una estructura de repositorio que permite a **agentes de IA trabajar de forma autónoma y verificable**.

```
┌─────────────────────────────────────────────────────────────┐
│                      HARNESS                                │
│  Infraestructura que permite a agentes actuar sin saltos.    │
│  NO es código. Es PROCESO + ESTADO + VERIFICACION.          │
└─────────────────────────────────────────────────────────────┘

4 PILARES:
  1. Repositorio = Sistema (alcance, estado, doctrina en disco)
  2. Orquestación Multi-Agente (4 roles especializados)
  3. Spec Driven Development (especificaciones antes de código)
  4. Supervisión Ejecutable (verificación en cada paso)
```

---

## 2. Los 4 Archivos Clave

| Archivo | Propósito | Contenido |
|---------|-----------|----------|
| **CLAUDE.md** | Fuerza el rol | Instrucciones al modelo: actúa como `leader`, no edites `src/` |
| **AGENTS.md** | Mapa de navegación | Dónde está cada cosa, reglas duras, flujo SDD |
| **feature_list.json** | Alcance | Todas las features, estado, flags SDD |
| **init.sh** | Verificación ejecutable | Chequea entorno, specs, tests (exit code 0 o 1) |

```
┌────────────────┐
│   CLAUDE.md    │  ← Carga automáticamente al iniciar sesión
└────────────────┘
         ↓
┌────────────────────────────────────────────┐
│  ¿Soy leader? (sí)                         │
│  ¿Qué tengo que hacer? → Lee AGENTS.md    │
│  ¿Cuál es la siguiente feature? → Lee FLJ │
│  ¿Está todo sano? → Ejecuta init.sh       │
└────────────────────────────────────────────┘
```

---

## 3. Estructura de Directorios

```
.
├── .claude/                     ← Configuración para el agente
│   ├── agents/
│   │   ├── leader.md           # Orquestador
│   │   ├── spec_author.md      # Redactor de specs
│   │   ├── implementer.md      # Constructor
│   │   └── reviewer.md         # Inspector
│   └── settings.json           # Hooks de verificación automática
│
├── docs/                        ← Doctrina del proyecto
│   ├── architecture.md         # Qué significa "buen trabajo"
│   ├── conventions.md          # Estilo, nombres, estructura
│   ├── specs.md               # Cómo redactar specs (EARS)
│   └── verification.md        # Cómo demostrar que funciona
│
├── specs/                       ← Especificaciones por feature
│   └── <feature-name>/
│       ├── requirements.md    # QUÉ (EARS notation)
│       ├── design.md          # CÓMO (decisiones técnicas)
│       └── tasks.md           # PASOS (checklist)
│
├── progress/                    ← Estado vivo + bitácora
│   ├── current.md             # Estado de ESTA sesión
│   ├── history.md             # Bitácora append-only
│   └── <phase>_<feature>.md   # Informes de subagentes
│
├── src/                         ← Tu código de aplicación
│   └── *.py
│
├── tests/                       ← Tests reales (no mocks)
│   └── test_*.py
│
├── CLAUDE.md                    # Instrucciones para Claude
├── AGENTS.md                    # Mapa de navegación
├── CHECKPOINTS.md              # 6 criterios de "estado sano"
├── feature_list.json           # Alcance
├── init.sh                      # Verificación ejecutable
└── README.md                    # Guía para humanos
```

---

## 4. Los 4 Agentes y Sus Roles

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUJO SDD (Spec Driven Development)          │
│                                                                  │
│  pending                                                         │
│    ↓                                                             │
│  [SPEC AUTHOR redacta specs]                                    │
│    ↓                                                             │
│  spec_ready                                                      │
│    ↓                                                             │
│  ⏸ HUMANO LEE Y APRUEBA SPECS ← PUERTA DE APROBACION HUMANA   │
│    ↓                                                             │
│  in_progress                                                     │
│    ↓                                                             │
│  [IMPLEMENTER escribe código + tests siguiendo spec]            │
│    ↓                                                             │
│  [REVIEWER verifica trazabilidad R<n> ↔ test]                   │
│    ↓                                                             │
│  done                                                            │
└─────────────────────────────────────────────────────────────────┘

QUIÉN HACE QUÉ:

┌──────────────┬──────────────────┬──────────────┬──────────────────┐
│ LEADER       │ SPEC AUTHOR      │ IMPLEMENTER  │ REVIEWER         │
├──────────────┼──────────────────┼──────────────┼──────────────────┤
│ Orquesta     │ Diseña antes     │ Construye    │ Inspecciona      │
│ Descompone   │ de código        │ siguiendo    │ antes de cerrar  │
│ Coordina     │                  │ diseño       │                  │
│              │ ✅ Lee docs      │              │ ✅ Verifica R<n> │
│ ❌ NO edita  │ ✅ Redacta 3     │ ✅ Escribe   │ ✅ Tests verdes  │
│    código    │    archivos      │    código    │ ✅ Trazabilidad │
│              │ ❌ NO toca       │ ✅ Escribe   │ ❌ NO edita       │
│              │    código        │    tests     │    código        │
│              │ ✅ Cambia status │ ❌ NO marca  │ ✅ Aprueba o     │
│              │    → spec_ready  │    done      │    rechaza       │
└──────────────┴──────────────────┴──────────────┴──────────────────┘
```

---

## 5. El Proceso SDD (Spec Driven Development)

### ¿Por qué 3 archivos?

```
requirements.md (EARS)
├── QUÉ necesita el sistema
├── Cada requirement: R1, R2, R3, ...
├── Verificable por test
└── Ejemplo: "CUANDO usuario ejecuta 'cli recent',
            el sistema DEBE listar 5 notas últimas"

design.md
├── CÓMO se construirá técnicamente
├── Archivos a tocar, firmas nuevas, excepciones
├── Alternativa descartada (siempre una)
└── Ejemplo: "Usamos sorted() nativo. No: crear clase Recent (innecesaria)."

tasks.md (Checklist)
├── PASOS concretos en orden
├── Cada paso referencia R<n> que cubre
├── [ ] para incomplete, [x] para complete
└── Ejemplo: "T1: Añadir cmd_recent(). Cubre: R1, R2."
```

### ¿Por qué antes de código?

```
SIN Harness:
  Código → Review → "Necesitamos cambiar arquitectura"
  [Retrabajar todo]
  DESPERDICIO

CON Harness (SDD):
  Spec (30 min) → HUMANO APRUEBA → Código (1 hora)
  [Menos sorpresas, menos retrabajos]
  EFICIENCIA
```

---

## 6. Flujo de Trabajo en 4 Pasos

### PASO 1: Inicio (Leader + init.sh)

```bash
$ ./init.sh
[OK]    python3 -> Python 3.11.5
[OK]    Existe AGENTS.md
[OK]    feature_list.json válido (8 features)
[OK]    Todos los tests pasan
[OK]    Entorno listo.
```

### PASO 2: Spec (Spec Author)

```markdown
# specs/cli_recent/requirements.md

## R1
CUANDO el usuario ejecuta `python -m src.cli recent`,
el sistema DEBE listar las 5 notas más recientes.

## R2
SI `--limit` <= 0 ENTONCES el sistema DEBE
imprimir error en stderr y salir con código != 0.

# specs/cli_recent/design.md

## Decisiones
- Archivo: src/cli.py (función cmd_recent)
- Flag: --limit (int, default 5)
- Alternativa descartada: crear clase Recent (innecesaria)

# specs/cli_recent/tasks.md

- [ ] T1 — Implementar cmd_recent(). Cubre: R1, R2.
- [ ] T2 — Añadir test para default limit. Cubre: R1.
- [ ] T3 — Añadir test para invalid limit. Cubre: R2.
```

**Salida:** `spec_ready -> specs/cli_recent/`

### PASO 3: Aprobación Humana

```
Humano lee:
  specs/cli_recent/requirements.md
  specs/cli_recent/design.md
  specs/cli_recent/tasks.md

Humano dice: "Aprobado" (o "Cambiar R1 a ...")
```

### PASO 4: Implementación + Review

```
Implementer:
  Para cada T<n>:
    - Escribe código
    - Escribe test
    - Marca [x] T<n>
    - Ejecuta ./init.sh → verde
  
  Salida: progress/impl_cli_recent.md (código + trazabilidad)

Reviewer:
  Verifica:
    ✅ R1 → test_recent_default_limit
    ✅ R2 → test_recent_invalid_limit
    ✅ Todas las tasks [x]
    ✅ ./init.sh → verde
    ✅ Todos los checkpoints [x]
  
  Salida: progress/review_cli_recent.md (APPROVED)
```

---

## 7. La Trazabilidad (R<n> ↔ Test)

**Regla:** Cada requirement debe poder mapearse a un test concreto.

```
requirements.md
├── R1: "Sistema DEBE listar 5 notas por defecto"
│   └─→ test_recent_default_limit (tests/test_cli.py)
│
└── R2: "Sistema DEBE rechazar --limit <= 0"
    └─→ test_recent_invalid_limit (tests/test_cli.py)

El reviewer comprueba esta correspondencia.
Si falta: RECHAZA la feature.
```

---

## 8. Los 6 Checkpoints (Criterios de "Estado Sano")

| Checkpoint | Qué verifica |
|-----------|------------|
| **C1** | ¿Arnés completo? (archivos base presentes, init.sh OK) |
| **C2** | ¿Estado coherente? (máximo 1 en-progress, tests verdes) |
| **C3** | ¿Código sano? (módulos previstos, sin dependencias externas) |
| **C4** | ¿Verificación real? (tests verdaderos, no mocks) |
| **C5** | ¿Sesión cerrada? (sin archivos temporales, history actualizado) |
| **C6** | ¿SDD cumplido? (specs completas, trazabilidad R↔test) |

El **reviewer** marca cada checkpoint `[x]` o `[ ]` antes de aprobar.

---

## 9. Reglas Duras (No Negociables)

```
┌─────────────────────────────────────────────────────────────┐
│ PARA EL LEADER                                              │
├─────────────────────────────────────────────────────────────┤
│ ❌ No editar src/ o tests/                                  │
│ ❌ No marcar features como done                             │
│ ❌ No saltar puerta de aprobación humana (spec_ready)       │
│ ✅ Lanzar subagentes con contexto claro                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ PARA EL SPEC AUTHOR                                         │
├─────────────────────────────────────────────────────────────┤
│ ❌ No editar src/ o tests/                                  │
│ ❌ No marcar como in_progress o done                        │
│ ✅ Redactar 3 archivos (requirements, design, tasks)        │
│ ✅ Cada R<n> verificable por test                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ PARA EL IMPLEMENTER                                         │
├─────────────────────────────────────────────────────────────┤
│ ❌ Feature DEBE estar en in_progress con spec aprobado      │
│ ❌ No lanzar reviewer                                        │
│ ✅ Código + test para cada task                             │
│ ✅ ./init.sh verde antes de pasar a next task               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ PARA EL REVIEWER                                            │
├─────────────────────────────────────────────────────────────┤
│ ❌ Nunca aprobar con tests rojos                             │
│ ❌ Nunca editar código                                       │
│ ❌ Nunca aprobar si R<n> sin test                            │
│ ✅ Sé concreto: cita líneas y archivos                       │
│ ✅ Rechaza o aprueba, sin grises                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ PARA TODOS                                                  │
├─────────────────────────────────────────────────────────────┤
│ ❌ Una sola feature por sesión                              │
│ ❌ No marcar done sin tests verdes                          │
│ ❌ No documentar en chat: usa progress/                      │
│ ✅ El repo es el sistema (estado en disco)                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 10. Checklist Rápida para Implementar un Harness

### Crear directorios

```bash
mkdir -p .claude/agents docs specs progress src tests
```

### Crear 4 archivos base

- ✅ **CLAUDE.md** — Fuerza rol leader
- ✅ **AGENTS.md** — Mapa de navegación
- ✅ **feature_list.json** — Alcance (proyecto, features con `"sdd": true`)
- ✅ **init.sh** — Script de verificación (must be executable)

### Crear documentación

- ✅ **docs/architecture.md** — Qué significa "buen trabajo"
- ✅ **docs/conventions.md** — Estilo, nombres
- ✅ **docs/specs.md** — Cómo redactar specs (EARS)
- ✅ **docs/verification.md** — Cómo demostrar que funciona

### Crear configuración de agentes

- ✅ **.claude/agents/leader.md**
- ✅ **.claude/agents/spec_author.md**
- ✅ **.claude/agents/implementer.md**
- ✅ **.claude/agents/reviewer.md**
- ✅ **.claude/settings.json** — Hooks

### Crear checkpoints + estado

- ✅ **CHECKPOINTS.md** — 6 criterios de estado sano
- ✅ **progress/current.md** — Template vacío
- ✅ **progress/history.md** — Archivo vacío
- ✅ **.gitignore** — `__pycache__`, `*.tmp`

### Verificar

```bash
./init.sh
# Debe decir: [OK]    Entorno listo.
```

### Usar

```bash
# Terminal 1: Iniciar sesión
claude

# Chat: Pedir
# "implementa la siguiente feature pendiente"

# El flujo empieza automáticamente:
# 1. spec_author redacta specs
# 2. [PAUSA] Humano aprueba en specs/
# 3. implementer escribe código
# 4. reviewer verifica trazabilidad
# 5. done
```

---

## 11. Un Ejemplo Real (Ficticio)

### feature_list.json

```json
{
  "features": [
    {
      "id": 7,
      "name": "cli_recent",
      "title": "Comando recent",
      "description": "Listar N notas más recientes",
      "sdd": true,
      "status": "pending"
    }
  ]
}
```

### Día 1: Spec Author

```
Claude (leader):
  "Veo feature #7 pending con sdd: true.
   Lanzando spec_author..."

Spec Author:
  Crea specs/cli_recent/{requirements,design,tasks}.md
  Cambia status → spec_ready
  "spec_ready -> specs/cli_recent/"

Humano:
  Lee los 3 archivos en el editor
  Dice: "Aprobado" (o pide cambios)
```

### Día 2: Implementación

```
Claude (leader):
  "Humano aprobó spec.
   Cambiando status → in_progress.
   Lanzando implementer..."

Implementer:
  Por cada task:
    - Escribe código (src/cli.py)
    - Escribe test (tests/test_cli.py)
    - Marca [x] en tasks.md
    - ./init.sh → verde
  
  "done -> progress/impl_cli_recent.md"

Claude (leader):
  "Lanzando reviewer..."

Reviewer:
  Verifica R1 → test_recent_default_limit ✅
  Verifica R2 → test_recent_invalid_limit ✅
  Verifica todas las tasks [x] ✅
  Verifica ./init.sh verde ✅
  Verifica C1-C6 checkpoints ✅
  
  "APPROVED -> progress/review_cli_recent.md"

Feature #7: done ✅
```

---

## 12. Diferencia con Código Tradicional

| Aspecto | Tradicional | Con Harness |
|--------|-------------|-----------|
| **Proceso** | Ad-hoc | Explícito en AGENTS.md |
| **Specs** | (Ninguno o por email) | 3 archivos, EARS formal, aprobación humana |
| **Estado** | En la cabeza | En `progress/current.md` |
| **Verificación** | Manual ("parece que funciona") | Automática (`./init.sh`) |
| **Trazabilidad** | "Creo que esto lo cubre" | R1 → test_xxx (documentado) |
| **Interrupciones** | ¿Dónde quedé? | `progress/` lo sabe |
| **Retrabajos** | Frecuentes (sorpresa en review) | Raros (spec aprobado antes) |

---

## 13. Resumen de Archivos Necesarios

```
✅ CLAUDE.md                    ← Fuerza rol
✅ AGENTS.md                    ← Mapa
✅ feature_list.json            ← Alcance
✅ CHECKPOINTS.md               ← Criterios
✅ init.sh                       ← Verificación
✅ README.md                     ← Guía humana

✅ docs/architecture.md         ← Qué es "buen trabajo"
✅ docs/conventions.md          ← Estilo
✅ docs/specs.md               ← Cómo hacer specs
✅ docs/verification.md        ← Cómo verificar

✅ .claude/agents/leader.md    ← Agente orquestador
✅ .claude/agents/spec_author.md ← Agente diseñador
✅ .claude/agents/implementer.md ← Agente constructor
✅ .claude/agents/reviewer.md  ← Agente inspector
✅ .claude/settings.json       ← Hooks automáticos

✅ progress/current.md          ← Estado vivo
✅ progress/history.md          ← Bitácora

(Los demás archivos: .gitignore, src/*, tests/*, dependen de tu proyecto)
```

---

## 14. La Frase Clave

> **El Harness no es código. Es infraestructura que permite a agentes trabajar de forma autónoma, verificable y sin saltos.**

---

**Fin del resumen ejecutivo.**

Lee `IMPLEMENTACION_HARNESS.md` para detalles completos.

# Harness Engineering — Guía Completa de Implementación

> **IMPORTANTE:** Este documento es una **extracción exhaustiva** de los componentes, estructura, pasos y archivos necesarios para implementar un **Harness completo** (arnés) que permita a agentes de IA trabajar de forma autónoma y verificable sobre un proyecto de software.
>
> El código de la aplicación es irrelevante. Lo importante es **cómo está estructurado el repositorio** para que un agente pueda autoorquestarse.

---

## Índice

1. [Concepto de Harness](#concepto-de-harness)
2. [Los 4 Pilares del Harness](#los-4-pilares-del-harness)
3. [Estructura de Directorios Requerida](#estructura-de-directorios-requerida)
4. [Archivos Base (Obligatorios)](#archivos-base-obligatorios)
5. [Orquestación Multi-Agente](#orquestación-multi-agente)
6. [Spec Driven Development (SDD)](#spec-driven-development-sdd)
7. [Flujo de Trabajo Completo](#flujo-de-trabajo-completo)
8. [Verificación y Control de Calidad](#verificación-y-control-de-calidad)
9. [Reglas Duras (No Negociables)](#reglas-duras-no-negociables)
10. [Checklist de Implementación](#checklist-de-implementación)

---

## Concepto de Harness

Un **Harness** (arnés) es una estructura de repository que permite a **agentes de IA trabajar de forma autónoma** manteniendo:

- **Verificación ejecutable**: Todo debe poder probarse sin interpretación humana.
- **Trazabilidad**: Cada línea de código debe poder rastrearse a un requisito específico.
- **Estado persistente**: El progreso sobrevive a reinicios, cambios de contexto y límites de tokens.
- **Paradas seguras**: El trabajo se detiene en puntos controlados (ej: para aprobación humana).
- **Orquestación multi-agente**: Diferentes agentes tienen roles específicos y verificables.

**El Harness NO es código**. Es la **infraestructura** que rodea el código.

---

## Los 4 Pilares del Harness

### 1. El Repositorio ES el Sistema

El repositorio no es solo almacenamiento de código. Es el **cerebro compartido**:

- `feature_list.json` → Alcance declarativo (una feature a la vez).
- `progress/current.md` → Estado vivo de la sesión actual.
- `progress/history.md` → Bitácora append-only de sesiones cerradas.
- `specs/<feature>/` → Especificaciones por feature.
- `docs/` → Doctrina del proyecto.
- `.claude/` → Configuración y definiciones de agentes.

**Beneficio:** El agente no necesita hacerlo "de cabeza". Todo está en disco, es versionable, y sobrevive a los cambios de contexto.

### 2. Orquestación Multi-Agente

El trabajo se distribuye entre **4 roles especializados**, cada uno con instrucciones claras y verificables:

| Agente | Rol | Responsabilidad | Entrada | Salida |
|--------|-----|-----------------|---------|--------|
| **leader** | Orquestador | Descomposición, coordinación, decisiones de flujo | Tarea principal (p. ej., "implementa siguiente feature") | Decisiones de qué sub-agente lanzar |
| **spec_author** | Diseñador | Redacta especificaciones (requirements, design, tasks) | Feature `pending` con `"sdd": true` | `specs/<name>/{requirements,design,tasks}.md` |
| **implementer** | Constructor | Escribe código y tests siguiendo el spec | Feature en `in_progress` con spec aprobado | Código, tests, documentación de trazabilidad |
| **reviewer** | Inspector | Verifica trazabilidad, cobertura de tests, cumplimiento de checkpoints | Feature completada (tests verdes) | Aprobación/Rechazo con checklist detallado |

**Beneficio:** Separación clara de responsabilidades. Cada agente tiene una barrera de entrada clara ("solo trabajo si se cumple X") y una salida verificable.

### 3. Spec Driven Development (SDD)

Antes de escribir **una línea de código**, existe una **puerta de aprobación humana**:

```
pending → [spec_author] → spec_ready → ⏸ HUMANO APRUEBA → in_progress → [implementer → reviewer] → done
```

Cada feature requiere **3 archivos** en `specs/<name>/`:

- **requirements.md** — QUÉ se necesita (EARS strict notation).
- **design.md** — CÓMO se construirá (decisiones técnicas).
- **tasks.md** — PASOS concretos a ejecutar (checklist).

El humano tiene **tiempo para leer y decidir** en un punto seguro. No es una sorpresa cuando termina el código.

**Beneficio:** Menos sorpresas en code review. El diseño está validado antes de gastar computación en implementación.

### 4. Supervisión y Mejora

El sistema es **self-verifying**:

- `./init.sh` → Verificación ejecutable al inicio y cierre de sesión.
- `tests/` → Suite de tests real (no mocks de FS, sin prints sueltos).
- `CHECKPOINTS.md` → 6 criterios objetivos de "estado sano".
- `.claude/settings.json` → Hooks que automatizan verificaciones (sin workarounds).
- `docs/architecture.md`, `docs/conventions.md`, `docs/verification.md` → Doctrina explicita.

**Beneficio:** El agente no "inventa" lo que significa "estar hecho". Todo está escrito. El reviewer rechaza si no se cumple.

---

## Estructura de Directorios Requerida

```
.
├── .claude/
│   ├── agents/
│   │   ├── leader.md           # Orquestador (cómo descomponer)
│   │   ├── spec_author.md      # Redactor de specs
│   │   ├── implementer.md      # Constructor
│   │   └── reviewer.md         # Inspector
│   ├── settings.json           # Hooks de verificación automática
│   └── rules.md                # (Opcional) Reglas en Cursor
│
├── docs/
│   ├── architecture.md         # Qué significa "hacer un buen trabajo"
│   ├── conventions.md          # Estilo, nombres, estructura
│   ├── specs.md               # El proceso SDD explicado
│   └── verification.md        # Cómo demostrar que funciona
│
├── specs/
│   └── <feature-name>/        # Por cada feature con "sdd": true
│       ├── requirements.md    # EARS notation (R1, R2, ...)
│       ├── design.md          # Decisiones técnicas
│       └── tasks.md           # Checklist de implementación
│
├── progress/
│   ├── current.md             # Estado vivo de la sesión actual
│   ├── history.md             # Bitácora append-only de sesiones cerradas
│   └── <phase>_<feature>.md   # Informes de subagentes (impl_*, review_*, spec_*)
│
├── src/
│   ├── __init__.py            # (Puede estar vacío)
│   └── *.py                   # Módulos de aplicación (depende del proyecto)
│
├── tests/
│   └── test_*.py              # Tests unitarios (uno por módulo en src/)
│
├── .gitignore                 # Ignorar __pycache__, *.tmp, etc.
├── AGENTS.md                  # Mapa de navegación para agentes
├── CLAUDE.md                  # Instrucciones para Claude (fuerza el rol leader)
├── CHECKPOINTS.md             # Criterios objetivos de "estado final correcto"
├── feature_list.json          # Alcance: features con estado y config
├── init.sh                    # Verificación e inicialización (ejecutable)
└── README.md                  # Guía para humanos y ejemplos de uso
```

---

## Archivos Base (Obligatorios)

### 1. `CLAUDE.md` — Instrucciones para Claude (Fuerza el rol)

**Propósito:** Se carga automáticamente al inicio de cada sesión. Fuerza al modelo a actuar como `leader` (orquesta, no edita código).

**Contenido clave:**

```markdown
# Instrucciones para Claude

> Este archivo se carga automáticamente al inicio de cada sesión.

## Rol obligatorio: leader

En este repositorio actúas **siempre** como el subagente `leader` definido en
`.claude/agents/leader.md`. Tu trabajo es **descomponer y coordinar**, nunca
implementar.

### Reglas duras

- ❌ **No edites** archivos en `src/` ni `tests/` directamente.
- ❌ **No marques** features como `done` en `feature_list.json`.
- ❌ **No saltes la fase de spec.** Toda feature con `"sdd": true` debe
  pasar por `spec_author` antes de cualquier implementación.
- ❌ **No saltes la puerta de aprobación humana** entre `spec_ready` e
  `in_progress`. Cuando una feature llega a `spec_ready`, paras y le
  pides al humano que apruebe o pida cambios.
```

**Ubicación:** `CLAUDE.md` (raíz del repo)

---

### 2. `AGENTS.md` — Mapa de Navegación

**Propósito:** Punto de entrada para cualquier agente. Divulgación progresiva de reglas. Los agentes leen lo que necesitan, cuando lo necesitan.

**Secciones obligatorias:**

1. **Antes de empezar (obligatorio)**
   - Ejecutar `./init.sh`
   - Leer `progress/current.md`
   - Leer `feature_list.json`
   - Leer `docs/specs.md`

2. **Mapa del repositorio**
   - Tabla con archivos/carpetas → qué contienen → cuándo leer

3. **Reglas duras (no negociables)**
   - Una sola feature a la vez
   - No marcar `done` sin tests verdes
   - No saltar fase de spec
   - No saltar puerta de aprobación humana
   - Documentar en `progress/current.md`

4. **Flujo de trabajo (SDD)**
   - Diagrama ASCII: `pending → [spec_author] → spec_ready → ⏸ HUMANO → in_progress → [implementer → reviewer] → done`
   - Descripción de cada fase

5. **Cierre de sesión (lifecycle)**
   - Ejecutar `./init.sh` — todo verde
   - Marcar `status: "done"` si aplica
   - Mover resumen a `progress/history.md`
   - Vaciar `progress/current.md`

6. **Si te bloqueas**
   - Relee la sección relevante de `docs/`
   - Documenta el bloqueo en `progress/current.md`

**Ubicación:** `AGENTS.md` (raíz del repo)

---

### 3. `feature_list.json` — Alcance Declarativo

**Propósito:** Lista de todas las features con estado. Valida que solo una esté en `in_progress`. Declara cuáles requieren SDD.

**Estructura:**

```json
{
  "project": "nombre-del-proyecto",
  "description": "Descripción breve",
  "rules": {
    "one_feature_at_a_time": true,
    "require_tests_to_close": true,
    "require_approved_spec_to_implement": true,
    "valid_status": ["pending", "spec_ready", "in_progress", "done", "blocked"],
    "sdd_required_when": "feature has \"sdd\": true"
  },
  "features": [
    {
      "id": 1,
      "name": "identificador_corto",
      "title": "Título legible",
      "description": "Qué hace esta feature",
      "acceptance": [
        "Criterio 1",
        "Criterio 2",
        "Criterio 3"
      ],
      "sdd": true,           // true si requiere Spec Driven Development
      "status": "pending"    // pending | spec_ready | in_progress | done | blocked
    },
    { ... }
  ]
}
```

**Reglas:**

- Máximo **una** feature en `in_progress` a la vez.
- Toda feature con `"sdd": true` en estado `spec_ready`, `in_progress` o `done` **debe** tener carpeta `specs/<name>/` con 3 archivos.
- Estados válidos: `pending`, `spec_ready`, `in_progress`, `done`, `blocked`.

**Ubicación:** `feature_list.json` (raíz del repo)

---

### 4. `init.sh` — Verificación e Inicialización

**Propósito:** Script verificable que se ejecuta al inicio y cierre de sesión. No tiene workarounds — falla si algo está mal.

**Verificaciones que debe hacer:**

1. **Entorno Python**
   - `python3` disponible
   - Python >= 3.9

2. **Archivos base del arnés**
   - `AGENTS.md`, `feature_list.json`, `progress/current.md`
   - `docs/architecture.md`, `docs/conventions.md`, `docs/verification.md`
   - `CHECKPOINTS.md`

3. **Validar feature_list.json y specs**
   - Estados válidos
   - Máximo una feature en `in_progress`
   - Toda feature con `"sdd": true` en estado no-`pending` tiene carpeta `specs/<name>/` completa

4. **Ejecutar tests**
   - `python3 -m unittest discover -s tests -v`
   - Debe haber al menos un test
   - Todos deben pasar (exit code 0)

5. **Salida clara**
   - `[OK]` para pasos exitosos
   - `[FAIL]` para errores (y exit code 1)
   - `[WARN]` para advertencias (exit code 0)

**Ubicación:** `init.sh` (raíz del repo, ejecutable)

**Ejemplo de salida:**

```
── 1. Verificando entorno ────────────────────────
[OK]    python3 -> Python 3.11.5
[OK]    Versión de Python compatible

── 2. Verificando archivos base del arnés ───────
[OK]    Existe AGENTS.md
[OK]    Existe feature_list.json
[OK]    Existe progress/current.md
...

── 3. Validando feature_list.json y specs ──────
[OK]    feature_list.json válido (8 features)
[OK]    Specs presentes para features sdd con estado no-pending

── 4. Ejecutando tests ─────────────────────────
[OK]    Todos los tests pasan

── 5. Resumen ───────────────────────────────────
[OK]    Entorno listo. Puedes empezar a trabajar.
```

---

### 5. `progress/current.md` — Estado Vivo de la Sesión

**Propósito:** Registro vivo de qué está pasando en **esta sesión**. Se puede estar escribiendo mientras trabaja.

**Estructura obligatoria:**

```markdown
# Sesión — [fecha/hora]

## Estado actual

- **Feature en curso:** (id) nombre (status: pending/spec_ready/in_progress)
- **Agente activo:** leader/spec_author/implementer/reviewer
- **Último paso:** (breve descripción)

## Plan

- [ ] Paso 1
- [ ] Paso 2
- [x] Paso completado

## Bloqueadores

(Vacío si no hay. Si hay, describe el problema y next steps.)

## Notas

(Contexto relevante para la próxima sesión.)
```

**Ubicación:** `progress/current.md` (en progress/)

---

### 6. `progress/history.md` — Bitácora Append-Only

**Propósito:** Registro histórico de sesiones cerradas. Se escribe al final de cada sesión.

**Formato:**

```markdown
# Bitácora de Sesiones Cerradas

## [2026-06-09] Feature #7 — cli_recent

- **Estado inicial:** pending
- **Fases:** spec → aprobación humana → implementación → review → done
- **Resultado:** ✅ DONE
- **Tests:** 5/5 pasan
- **Tiempo:** ~45 min
- **Notas:** Spec mejorado en base a feedback humano. Implementación sin cambios.

---

## [2026-06-08] Feature #6 — cli_edit

...
```

**Ubicación:** `progress/history.md` (en progress/)

---

### 7. `CHECKPOINTS.md` — Criterios de "Estado Final Correcto"

**Propósito:** 6 checklists objetivos que un reviewer puede validar sin interpretación subjetiva.

**Checkpoints obligatorios:**

```markdown
# CHECKPOINTS — Evaluación del estado final

## C1 — El arnés está completo

- [ ] Existen: AGENTS.md, init.sh, feature_list.json, progress/current.md
- [ ] Existen: docs/architecture.md, docs/conventions.md, docs/verification.md
- [ ] ./init.sh termina con exit code 0

## C2 — El estado es coherente

- [ ] Máximo una feature en `in_progress` en feature_list.json
- [ ] Toda feature `done` tiene tests que pasan
- [ ] progress/current.md está vacío o describe la sesión activa

## C3 — El código respeta la arquitectura

- [ ] src/ solo contiene módulos previstos en docs/architecture.md
- [ ] Sin dependencias externas (requirements.txt vacío)
- [ ] Sin print() sueltos, sin TODOs sin contexto

## C4 — La verificación es real

- [ ] tests/ tiene test por módulo de src/
- [ ] Tests usan tempfile.TemporaryDirectory(), no mocks
- [ ] python3 -m unittest discover -s tests -v muestra tests verdes

## C5 — La sesión se cerró bien

- [ ] Sin archivos sin trackear sospechosos
- [ ] progress/history.md tiene entrada de la última sesión
- [ ] Feature trabajada está en su estado correcto

## C6 — Spec Driven Development

- [ ] Toda feature con "sdd": true en estados no-pending tiene specs/<name>/
- [ ] requirements.md usa EARS estricto
- [ ] tasks.md tiene todas las tareas marcadas [x]
- [ ] Cada R<n> está cubierto por un test concreto
```

**Ubicación:** `CHECKPOINTS.md` (raíz del repo)

---

### 8. `docs/architecture.md` — Qué Significa "Hacer un Buen Trabajo"

**Propósito:** Define los estándares de calidad del proyecto. El reviewer evalúa código contra este archivo.

**Secciones clave:**

1. **Principios arquitectónicos**
   - Capas del proyecto
   - Dependencias permitidas
   - Patrones de error

2. **Flujo de datos**
   - Diagrama ASCII de cómo los datos fluyen

3. **Qué NO hacer**
   - Anti-patrones explícitos

**Ubicación:** `docs/architecture.md` (en docs/)

---

### 9. `docs/conventions.md` — Estilo y Nombres

**Propósito:** Homogeneidad extrema. El agente predice mejor código cuando el repo se parece a sí mismo.

**Secciones clave:**

1. **Estilo de código**
   - Versión de lenguaje
   - Longitud de líneas
   - Comillas, strings

2. **Convenciones de nombres**
   - Módulos: `snake_case`
   - Clases: `PascalCase`
   - Funciones: `snake_case`
   - Constantes: `UPPER_SNAKE`

3. **Estructura de archivo**
   - Qué va al inicio (docstring, imports)
   - Orden de imports

4. **Tests**
   - Estructura: `Test<Cosa>(unittest.TestCase)`
   - Nombres descriptivos

5. **Manejo de errores**
   - Excepciones del dominio
   - Cómo capturar en CLI

6. **Comentarios**
   - Solo cuando explican un *por qué* no obvio

**Ubicación:** `docs/conventions.md` (en docs/)

---

### 10. `docs/specs.md` — El Proceso SDD Explicado

**Propósito:** Define cómo se redactan specs. Explica EARS, los 3 archivos, la puerta de aprobación.

**Secciones clave:**

1. **Estructura**
   - 3 archivos por feature

2. **Estados de una feature**
   - pending → spec_ready → in_progress → done

3. **La puerta de aprobación humana**
   - Dónde se detiene el flujo

4. **requirements.md — EARS estricto**
   - 5 patrones: Ubicuo, Evento, Estado, Opcional, No deseado
   - Ejemplo de requirement bien formado

5. **design.md — Decisiones técnicas**
   - Qué archivos se tocan
   - Firmas nuevas
   - Excepciones
   - Alternativa descartada

6. **tasks.md — Checklist ejecutable**
   - Pasos en orden
   - Cada task referencia R<n> que cubre

7. **Trazabilidad**
   - Cada test → R<n>
   - Cada R<n> → al menos un test

**Ubicación:** `docs/specs.md` (en docs/)

---

### 11. `docs/verification.md` — Cómo Demostrar que Funciona

**Propósito:** Define qué evidencia ejecutable es necesaria.

**Niveles de verificación:**

1. **Nivel 1 — Tests unitarios (obligatorio)**
   - Al menos un test por función pública
   - Camino feliz + error

2. **Nivel 2 — Tests de integración (obligatorio para UI)**
   - Ejecutar CLI real contra archivo temporal

3. **Nivel 3 — Smoke test manual (opcional pero recomendado)**
   - End-to-end con archivo temporal

4. **Nivel 4 — Trazabilidad requirements ↔ tests (obligatorio para SDD)**
   - Cada R<n> mapeable a un test

**Anti-patrones:**

- "He añadido el comando, debería funcionar" → falta test
- Test que solo verifica que no lanza excepción
- Mock del filesystem → usar `tempfile.TemporaryDirectory()`
- Marcar `done` sin pasar `./init.sh`

**Ubicación:** `docs/verification.md` (en docs/)

---

### 12. `.claude/settings.json` — Hooks de Verificación Automática

**Propósito:** Hooks que se ejecutan automáticamente (el harness los ejecuta, no el agente). No se pueden saltar.

**Estructura:**

```json
{
  "$schema_comment": "Hooks que automatizan la verificación...",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -m unittest discover -s tests -q 2>&1 | tail -3",
            "description": "Tras editar o escribir archivos, corre los tests y muestra resumen"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "./init.sh > /tmp/harness_init.log 2>&1 && echo '[harness] init.sh OK' || ...",
            "description": "Antes de cerrar sesión, fuerza verificación completa"
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(./init.sh)",
      "Bash(python3 -m unittest*)",
      "Bash(python3 -m src.cli*)"
    ]
  }
}
```

**Ubicación:** `.claude/settings.json` (en .claude/)

---

## Orquestación Multi-Agente

### Los 4 Agentes

#### **1. Leader (Orquestador)**

**Archivo:** `.claude/agents/leader.md`

**Rol:** Descomponer y coordinar. NUNCA implementa.

**Entrada:** Tarea principal (p. ej., "implementa la siguiente feature pendiente")

**Salida:** Decisión de qué sub-agente lanzar

**Protocolo:**

1. Lee `AGENTS.md`, `feature_list.json`, `progress/current.md`
2. Ejecuta `./init.sh`
3. Mira el status de la primera feature no-`done` / no-`blocked`:
   - Si `pending` → lanza `spec_author`
   - Si `spec_ready` + humano aprobó → cambia a `in_progress`, lanza `implementer`, luego `reviewer`
   - Si `spec_ready` SIN aprobación → paras, recuerdas al humano que toca
   - Si `in_progress` → pregunta si reanuda o aborta

**Regla anti-teléfono-descompuesto:**

Instrúye a subagentes para que escriban resultados en archivos. Solo recibes referencias:

- `spec_author` → `spec_ready -> specs/<name>/`
- `implementer` → `done -> progress/impl_<name>.md`
- `reviewer` → `APPROVED -> progress/review_<name>.md`

**Qué NO hace:**

- ❌ Edita archivos en `src/` o `tests/`
- ❌ Marca features como `done`
- ❌ Salta puerta de aprobación humana
- ❌ Acepta resultados de subagentes que vengan en chat sin referencia a archivo

---

#### **2. Spec Author (Diseñador)**

**Archivo:** `.claude/agents/spec_author.md`

**Rol:** Redacta especificaciones (requirements, design, tasks).

**Entrada:** Feature `pending` con `"sdd": true`

**Salida:** 3 archivos en `specs/<name>/` + status cambiado a `spec_ready`

**Protocolo:**

1. Lee documentación: `AGENTS.md`, `docs/architecture.md`, `docs/conventions.md`, `docs/specs.md`
2. Toma la feature `pending` de menor `id` con `"sdd": true`
3. Redacta `requirements.md` en EARS estricto
   - Cada criterio del `acceptance` debe estar cubierto por un R<n>
4. Redacta `design.md`
   - Archivos a tocar, firmas nuevas, excepciones, alternativa descartada
5. Redacta `tasks.md`
   - Pasos discretos en orden, cada uno con `[ ]`
   - Cada task referencia R<n> que cubre
6. Cambia `status` a `spec_ready` en `feature_list.json`
7. **PARA**. No invoques implementer.

**Salida final:**

```
spec_ready -> specs/<name>/
```

o si se bloquea:

```
blocked -> progress/spec_<name>.md
```

**Reglas duras:**

- ❌ NUNCA edites `src/` o `tests/`
- ❌ NUNCA marques como `in_progress` o `done`, solo `spec_ready`
- ✅ Cada R<n> DEBE ser verificable por un test concreto

---

#### **3. Implementer (Constructor)**

**Archivo:** `.claude/agents/implementer.md`

**Rol:** Escribe código y tests siguiendo el spec aprobado.

**Entrada:** Feature en `in_progress` con spec aprobado en `specs/<name>/`

**Salida:** Código, tests, documentación de trazabilidad en `progress/impl_<name>.md`

**Protocolo:**

1. Lee documentación
2. Lee el spec completo en `specs/<name>/`
3. Anota en `progress/current.md` la feature en curso y plan
4. **Para cada task T<n> en orden:**
   - Implementa el cambio
   - Si la task incluye test, escríbelo
   - Marca `[x] T<n>` en `tasks.md`
   - Verifica con `./init.sh`
5. Documenta trazabilidad R<n> → test en `progress/impl_<name>.md`
6. **NO marques `done`**. Espera al reviewer.

**Salida final:**

```
done -> progress/impl_<name>.md
```

o si se bloquea:

```
blocked -> progress/impl_<name>.md
```

**Reglas duras:**

- ❌ Si la feature NO está en `in_progress` con spec aprobado, paras
- ❌ Una sola feature por sesión
- ❌ Si una task no se puede completar sin desviarse del spec, reportas (no inventes)
- ✅ Toda escritura de código con su test

---

#### **4. Reviewer (Inspector)**

**Archivo:** `.claude/agents/reviewer.md`

**Rol:** Verifica trazabilidad, cobertura de tests, cumplimiento de checkpoints.

**Entrada:** Feature completada (tests verdes)

**Salida:** Aprobación/Rechazo con checklist detallado en `progress/review_<name>.md`

**Protocolo:**

1. Lee documentación
2. Identifica feature en `in_progress` (debería ser la única)
3. **Trazabilidad:** por cada R<n> de `requirements.md`, localiza al menos un test que lo verifique
4. **Tasks completas:** comprueba que TODAS las tasks están `[x]`
5. **Revisa cada archivo modificado:**
   - ¿Respeta `docs/architecture.md`?
   - ¿Respeta `docs/conventions.md`?
   - ¿Tiene su test correspondiente?
6. Ejecuta `./init.sh` (debe estar verde)
7. Recorre `CHECKPOINTS.md` (marca `[x]` o `[ ]`)
8. Emite veredicto

**Formato de veredicto:**

Escribe en `progress/review_<name>.md`:

```markdown
# Review — feature <id>

**Veredicto:** APPROVED | CHANGES_REQUESTED

## Trazabilidad requirements ↔ tests
- R1: [x] cubierto por `test_xxx`
- R2: [x] cubierto por `test_yyy`
- R3: [ ]  ← Sin test

## Tasks completas
- T1: [x]
- T2: [x]
- T3: [ ]  ← Sigue en [ ] sin justificación

## Checkpoints
- C1: [x]
- C2: [x]
- ...

## Cambios requeridos
1. Añadir test para R3
2. Completar T3 o documentar justificación
```

**Salida final:**

```
APPROVED -> progress/review_<name>.md
```

o

```
CHANGES_REQUESTED -> progress/review_<name>.md
```

**Reglas duras:**

- ❌ Nunca apruebes con tests rojos
- ❌ Nunca apruebes con `./init.sh` en rojo
- ❌ Nunca apruebes si algún R<n> queda sin cobertura
- ❌ Nunca apruebes si tareas están en `[ ]` sin justificación
- ❌ NUNCA edites el código
- ✅ Sé concreto: cita líneas y archivos

---

## Spec Driven Development (SDD)

### Flujo Completo

```
pending
  ↓
  [spec_author redacta specs/<name>/{requirements,design,tasks}.md]
  ↓
spec_ready
  ↓
  ⏸ HUMANO LEE specs/<name>/ Y APRUEBA (o pide cambios)
  ↓
in_progress
  ↓
  [implementer sigue tasks.md, escribe código y tests]
  ↓
  [tests verdes]
  ↓
  [reviewer verifica trazabilidad y checkpoints]
  ↓
APPROVED
  ↓
done
```

### Los 3 Archivos de Spec

#### **requirements.md — QUÉ se necesita (EARS Estricto)**

**EARS** = Easy Approach to Requirements Syntax

**5 patrones:**

| Patrón | Plantilla | Ejemplo |
|--------|-----------|---------|
| **Ubicuo** | `El sistema DEBE <acción>.` | `El sistema DEBE almacenar todas las notas en JSON.` |
| **Evento** | `CUANDO <disparador>, el sistema DEBE <acción>.` | `CUANDO el usuario ejecuta `cli recent`, el sistema DEBE listar las 5 notas más recientes.` |
| **Estado** | `MIENTRAS <estado>, el sistema DEBE <acción>.` | `MIENTRAS no hay notas, el sistema DEBE imprimir `sin notas`.` |
| **Opcional** | `DONDE <feature opcional>, el sistema DEBE <acción>.` | `DONDE se pasa `--limit`, el sistema DEBE cambiar el número de notas a mostrar.` |
| **No deseado** | `SI <evento no deseado> ENTONCES el sistema DEBE <acción>.` | `SI `--limit` <= 0 ENTONCES el sistema DEBE imprimir error en stderr y salir con código 1.` |

**Reglas:**

- Cada requirement tiene id estable: `R1`, `R2`, ...
- Cada requirement DEBE ser verificable por al menos un test concreto
- No mezcles varios `DEBE` en un mismo requirement
- Solo verbos fuertes: `DEBE` / `NO DEBE` (no "podría", "puede", "soporta")

**Ejemplo:**

```markdown
## R1
CUANDO el usuario ejecuta `python -m src.cli recent`, el sistema DEBE
imprimir hasta 5 notas ordenadas por `created_at` descendente.

## R2
SI el flag `--limit` recibe un valor <= 0 ENTONCES el sistema DEBE
imprimir un mensaje de error en stderr y salir con código != 0.

## R3
DONDE el flag `--limit` se pasa ENTONCES el sistema DEBE cambiar el
número de notas a mostrar al valor especificado.
```

---

#### **design.md — CÓMO se construirá**

Captura **antes** de tocar código:

1. **Qué archivos se crean/modifican**
   - `src/cli.py` → nueva función `cmd_recent(args)`
   - `tests/test_cli.py` → nuevos tests

2. **Qué firmas nuevas aparecen**
   - Función: `cmd_recent(args: argparse.Namespace) → None`
   - Flag: `--limit` (tipo int, default 5)

3. **Qué excepciones se reutilizan o se añaden**
   - Se reutiliza: `ValueError` para limit inválido
   - Nuevas: ninguna

4. **Qué alternativa se descartó y por qué**
   - Alternativa: "Crear clase `Recent` con lógica. Descartada: añade complejidad innecesaria cuando `sorted()` ya existe."

**Ejemplo:**

```markdown
## Decisiones técnicas

### Archivos a modificar
- `src/cli.py` — nueva función `cmd_recent(args)` en el parser
- `tests/test_cli.py` — nuevos tests para el comando

### Firmas nuevas
```python
def cmd_recent(args: argparse.Namespace) -> None:
    """Listar las N notas más recientes."""
    ...
```

### Excepciones
- Se reutiliza `ValueError` (levantada si `--limit` <= 0)

### Alternativa descartada
- **Opción A:** Crear clase `Recent` con lógica. **Descartada:** innecesaria complejidad.
```

---

#### **tasks.md — PASOS concretos a ejecutar**

Checklist ejecutable en orden. Cada task:

- Tiene id: `T1`, `T2`, ...
- Tiene checkbox: `[ ]` (pending) o `[x]` (done)
- Referencia R<n> que cubre

**Ejemplo:**

```markdown
## Implementación

- [ ] T1 — Añadir `cmd_recent` en `src/cli.py`. Cubre: R1, R3.
- [ ] T2 — Registrar subparser `recent` con flag `--limit`. Cubre: R1, R2.
- [ ] T3 — Implementar lógica: cargar notas, ordenar, limitar. Cubre: R1, R3.
- [ ] T4 — Añadir `test_recent_default_limit` en `tests/test_cli.py`. Cubre: R1.
- [ ] T5 — Añadir `test_recent_invalid_limit` en `tests/test_cli.py`. Cubre: R2.
- [ ] T6 — Añadir `test_recent_custom_limit` en `tests/test_cli.py`. Cubre: R3.
- [ ] T7 — Ejecutar `./init.sh` y verificar todo verde.
```

El `implementer` marca `[x]` cada task al completarla. El `reviewer` rechaza si queda alguna `[ ]` sin justificación.

---

### Trazabilidad (Regla Dura)

Cada test en `tests/` → mapeable a un R<n>  
Cada R<n> → al menos un test concreto

El `implementer` documenta el mapa en `progress/impl_<name>.md`:

```markdown
## Trazabilidad

- R1 → `test_recent_default_limit`
- R2 → `test_recent_invalid_limit`
- R3 → `test_recent_custom_limit`
```

El `reviewer` verifica esta correspondencia explícitamente.

---

## Flujo de Trabajo Completo

### Día 1: Spec

1. **Humano:** Lanza el harness: `claude` en raíz
2. **Claude (leader):** Ejecuta `./init.sh` → todo verde
3. **Claude (leader):** Lee `feature_list.json` → feature #7 está `pending` con `"sdd": true`
4. **Claude (leader):** Lanza `spec_author`
5. **Spec Author:**
   - Lee `docs/architecture.md`, `docs/conventions.md`, `docs/specs.md`
   - Redacta `specs/cli_recent/requirements.md` en EARS
   - Redacta `specs/cli_recent/design.md` con decisiones técnicas
   - Redacta `specs/cli_recent/tasks.md` con checklist
   - Cambia `feature_list.json` → status `spec_ready`
   - Responde: `spec_ready -> specs/cli_recent/`
6. **Humano:** Lee `specs/cli_recent/{requirements,design,tasks}.md` en su editor
7. **Humano:** Dice "aprobado" (o pide cambios)

---

### Día 2: Aprobación + Implementación

1. **Humano:** Dice "aprobado" en el chat
2. **Claude (leader):** Cambia `feature_list.json` → status `in_progress`
3. **Claude (leader):** Lanza `implementer` con `specs/cli_recent/` como contexto
4. **Implementer:**
   - Lee el spec completo
   - Anota en `progress/current.md`
   - **Para cada T<n>:**
     - Implementa el cambio
     - Escribe test
     - Marca `[x] T<n>` en `tasks.md`
     - Ejecuta `./init.sh` → verde
   - Documenta trazabilidad R<n> → test en `progress/impl_cli_recent.md`
   - Responde: `done -> progress/impl_cli_recent.md`
5. **Claude (leader):** Lanza `reviewer` con `specs/cli_recent/` y `progress/impl_cli_recent.md`
6. **Reviewer:**
   - Verifica R<n> → test por cada requirement
   - Verifica tasks `[x]`
   - Ejecuta `./init.sh` → verde
   - Recorre `CHECKPOINTS.md` → todo `[x]`
   - Escribe veredicto en `progress/review_cli_recent.md`
   - Responde: `APPROVED -> progress/review_cli_recent.md` o `CHANGES_REQUESTED`
7. **Si APPROVED:**
   - **Implementer** cambia `feature_list.json` → status `done`
   - **Implementer** mueve resumen a `progress/history.md`
   - **Implementer** vacía `progress/current.md`

---

## Verificación y Control de Calidad

### El Script `init.sh`

Se ejecuta:

1. **Al inicio de sesión** — para verificar que el entorno está sano
2. **Al cierre de sesión** — para verificar que se dejó todo verde

**Salida esperada:** `[OK]    Entorno listo. Puedes empezar a trabajar.` (exit code 0)

**Si falla:** El agente detiene todo y reporta.

### Los Tests

- Un archivo de test por módulo: `tests/test_<módulo>.py`
- Cada test es una clase: `Test<Cosa>(unittest.TestCase)`
- Cada test usa `tempfile.TemporaryDirectory()` (no mocks)
- Nombres descriptivos: `test_load_returns_empty_when_file_missing`

**Comando:** `python3 -m unittest discover -s tests -v`

### Los Checkpoints

6 criterios que un juez (humano o IA) valida:

- **C1:** Arnés completo (archivos base presentes)
- **C2:** Estado coherente (máximo 1 en-progress, tests verdes)
- **C3:** Código respeta arquitectura (módulos previstos, sin dependencias externas)
- **C4:** Verificación real (tests verdaderos, no mocks)
- **C5:** Sesión cerrada bien (sin archivos temporales, history.md actualizado)
- **C6:** SDD cumplido (specs completas, trazabilidad R↔test)

---

## Reglas Duras (No Negociables)

### Para el Leader

- ❌ No editar `src/` o `tests/`
- ❌ No marcar features como `done`
- ❌ No saltar puerta de aprobación humana entre `spec_ready` e `in_progress`
- ❌ No lanzar implementer si feature está en `pending`
- ✅ Lanzar subagentes con contexto claro

### Para el Spec Author

- ❌ No editar `src/` o `tests/`
- ❌ No marcar como `in_progress` o `done`
- ❌ No lanzar implementer
- ✅ Cada R<n> verificable por test

### Para el Implementer

- ❌ Si feature NO en `in_progress`, paras
- ❌ Una sola feature por sesión
- ❌ Si task no se puede completar sin desviarse del spec, reportas (no inventes)
- ✅ Código + test para cada task

### Para el Reviewer

- ❌ Nunca apruebes con tests rojos
- ❌ Nunca apruebes sin `./init.sh` verde
- ❌ Nunca apruebes si R<n> sin test
- ❌ Nunca apruebes si tasks en `[ ]` sin justificación
- ❌ NUNCA editar código
- ✅ Sé concreto: cita líneas y archivos

### Para Todos

- ❌ No mezclar múltiples features en una sesión
- ❌ No marcar `done` sin tests verdes
- ❌ No saltar la fase de spec para features con `"sdd": true`
- ✅ Documentar todo en archivos (no en chat)
- ✅ Usar `progress/` como registro vivo

---

## Checklist de Implementación

Para crear un Harness desde cero, sigue este checklist:

### Fase 1: Estructura Base

- [ ] Crear directorios:
  - `mkdir -p .claude/agents`
  - `mkdir -p docs`
  - `mkdir -p specs`
  - `mkdir -p progress`
  - `mkdir -p src`
  - `mkdir -p tests`

### Fase 2: Archivos Obligatorios

- [ ] **CLAUDE.md** — Fuerza rol leader
- [ ] **AGENTS.md** — Mapa de navegación (con todas las secciones)
- [ ] **feature_list.json** — Alcance (proyecto, reglas, features)
- [ ] **CHECKPOINTS.md** — 6 criterios de estado sano
- [ ] **init.sh** — Script de verificación (ejecutable)
- [ ] **README.md** — Guía para humanos

### Fase 3: Documentación

- [ ] **docs/architecture.md** — Qué significa "buen trabajo"
- [ ] **docs/conventions.md** — Estilo, nombres, estructura
- [ ] **docs/specs.md** — Proceso SDD explicado
- [ ] **docs/verification.md** — Cómo demostrar que funciona

### Fase 4: Configuración de Agentes

- [ ] **.claude/agents/leader.md** — Orquestador
- [ ] **.claude/agents/spec_author.md** — Redactor de specs
- [ ] **.claude/agents/implementer.md** — Constructor
- [ ] **.claude/agents/reviewer.md** — Inspector
- [ ] **.claude/settings.json** — Hooks de verificación

### Fase 5: Estado Inicial

- [ ] **progress/current.md** — Template vacío
- [ ] **progress/history.md** — Archivo vacío
- [ ] **.gitignore** — Ignorar `__pycache__`, `*.tmp`, `.notes.json`

### Fase 6: Verificación

- [ ] Ejecutar `./init.sh` — debe terminar verde
- [ ] Si rojo, leer el error y corregir

### Fase 7: Uso

- [ ] Crear feature base en `feature_list.json` con `status: "pending"` y `"sdd": true`
- [ ] Lanzar agente: `claude` en raíz
- [ ] Pedir: "implementa la siguiente feature pendiente"

---

## Resumen Ejecutivo

Un **Harness** es una estructura de repo que permite a agentes de IA trabajar autónomamente manteniendo verificación, trazabilidad y estado persistente.

**Los 4 Pilares:**

1. **Repositorio = Sistema** — Alcance, estado, doctrina en disco
2. **Orquestación Multi-Agente** — Leader, Spec Author, Implementer, Reviewer (roles claros)
3. **Spec Driven Development** — Especificaciones aprobadas antes de código
4. **Supervisión Ejecutable** — `init.sh`, tests reales, checkpoints objetivos

**Flujo:**

```
pending → [spec_author] → spec_ready → ⏸ HUMANO → in_progress → [implementer → reviewer] → done
```

**No es sobre código. Es sobre proceso.**

---

**Fin de la guía de implementación.**

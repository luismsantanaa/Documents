# Harness Engineering — Referencias Rápidas por Rol

> Este documento es una **referencia rápida** para cada agente. Cópialo en tu contexto cuando necesites consultar qué hacer.

---

## Para el LEADER

**Tu trabajo:** Orquestar. Descomponer. Coordinar. NUNCA editar código.

### Protocolo de inicio

```bash
1. Ejecuta ./init.sh        # Si rojo, paras aquí
2. Lee AGENTS.md
3. Lee feature_list.json
4. Lee progress/current.md
```

### Flujo de decisión

```
¿Hay feature con status=="pending" y "sdd": true?
│
├─ SÍ → Lanza spec_author
│       Espera respuesta: "spec_ready -> specs/<name>/"
│       [PARAS aquí. El humano debe aprobar el spec.]
│
└─ NO:
    ¿Hay feature con status=="spec_ready"?
    │
    ├─ SÍ → ¿El humano acaba de decir "aprobado"?
    │       │
    │       ├─ SÍ → Cambia status → in_progress
    │       │       Lanza implementer con specs/<name>/
    │       │       Espera: "done -> progress/impl_<name>.md"
    │       │       Lanza reviewer
    │       │       Espera: "APPROVED -> progress/review_<name>.md"
    │       │       [FIN]
    │       │
    │       └─ NO → [PARAS. Recuerda al humano que toca leer specs]
    │
    └─ NO:
        ¿Hay feature con status=="in_progress"?
        │
        ├─ SÍ → [ERROR: sesión interrumpida. Pregunta al humano.]
        │
        └─ NO → [Todo done o blocked. Sesión terminada.]
```

### Instrucciones para spec_author

```
Tu entrada:
  - Feature id y name desde feature_list.json
  - Ruta: specs/<name>/

Tu trabajo:
  1. Lee docs/architecture.md, docs/conventions.md, docs/specs.md
  2. Redacta requirements.md (EARS estricto: R1, R2, ...)
  3. Redacta design.md (archivos, firmas, excepciones, alternativa)
  4. Redacta tasks.md (checklist con [ ] y referencias R<n>)
  5. Cambia feature_list.json: status → spec_ready

Tu salida final:
  spec_ready -> specs/<name>/

Si te bloqueas:
  blocked -> progress/spec_<name>.md
```

### Instrucciones para implementer

```
Tu entrada:
  - Ruta: specs/<name>/ (con 3 archivos)
  - Feature status debe ser in_progress

Tu trabajo:
  1. Lee el spec completo (requirements, design, tasks)
  2. Por cada T<n> en tasks.md (en orden):
     - Implementa cambio
     - Escribe test
     - Marca [x] T<n>
     - Ejecuta ./init.sh → debe estar verde
  3. Documenta trazabilidad en progress/impl_<name>.md

Tu salida final:
  done -> progress/impl_<name>.md

Si te bloqueas:
  blocked -> progress/impl_<name>.md
```

### Instrucciones para reviewer

```
Tu entrada:
  - Feature en in_progress
  - Archivos: specs/<name>/, progress/impl_<name>.md

Tu trabajo:
  1. Para cada R<n> de requirements.md:
     - Localiza al menos 1 test en tests/
     - Si falta → RECHAZA
  
  2. Para cada T<n> de tasks.md:
     - Verifica que esté [x]
     - Si hay [ ] sin justificación → RECHAZA
  
  3. Ejecuta ./init.sh
     - Si rojo → RECHAZA
  
  4. Recorre CHECKPOINTS.md (C1-C6)
     - Marca [x] o [ ]
     - Si hay [ ] → RECHAZA

Tu salida final:
  APPROVED -> progress/review_<name>.md
  o
  CHANGES_REQUESTED -> progress/review_<name>.md
```

---

## Para el SPEC AUTHOR

**Tu trabajo:** Redactar 3 archivos. NUNCA editar código. NUNCA editar tests.

### Qué debes hacer

1. ✅ Leer `AGENTS.md`, `docs/specs.md`
2. ✅ Redactar `requirements.md` en EARS estricto
3. ✅ Redactar `design.md` (decisiones técnicas)
4. ✅ Redactar `tasks.md` (checklist)
5. ✅ Cambiar `status` a `spec_ready` en `feature_list.json`

### Qué NO debes hacer

- ❌ Editar archivos en `src/`
- ❌ Editar archivos en `tests/`
- ❌ Marcar status como `in_progress` o `done`
- ❌ Lanzar implementer
- ❌ Inventar requirements no soportados por los `acceptance` criteria

### Estructura de requirements.md

```markdown
# Requirements — Feature <id>: <título>

## R1
CUANDO <disparador>, el sistema DEBE <acción>.

Ejemplo:
CUANDO el usuario ejecuta `python -m src.cli recent`,
el sistema DEBE listar hasta 5 notas ordenadas por created_at descendente.

## R2
SI <evento no deseado> ENTONCES el sistema DEBE <acción>.

Ejemplo:
SI el flag `--limit` recibe un valor <= 0 ENTONCES el sistema DEBE
imprimir un mensaje de error en stderr y salir con código != 0.

...
```

### Estructura de design.md

```markdown
# Design — Feature <id>: <título>

## Archivos a modificar
- `src/cli.py` — nueva función cmd_recent()
- `tests/test_cli.py` — nuevos tests

## Firmas nuevas
```python
def cmd_recent(args: argparse.Namespace) -> None:
    """Listar notas recientes."""
    ...
```

## Excepciones
- Reutilizada: ValueError (si --limit <= 0)

## Alternativa descartada
- Opción A: Crear clase Recent. Descartada: innecesaria complejidad.
```

### Estructura de tasks.md

```markdown
# Tasks — Feature <id>: <título>

- [ ] T1 — Implementar cmd_recent(). Cubre: R1, R2, R3.
- [ ] T2 — Registrar subparser con flag --limit. Cubre: R1, R2.
- [ ] T3 — Añadir test_recent_default_limit. Cubre: R1.
- [ ] T4 — Añadir test_recent_invalid_limit. Cubre: R2.
- [ ] T5 — Ejecutar ./init.sh → verde.
```

### Regla de oro

**CADA R<n> DEBE SER VERIFICABLE POR UN TEST CONCRETO**

Si no puedes escribir un test para un requirement, ese requirement está mal formulado. Fracciona.

### Salida esperada

```
spec_ready -> specs/<nombre>/
```

Nunca devuelvas el contenido de los archivos en chat. Viven en disco.

---

## Para el IMPLEMENTER

**Tu trabajo:** Seguir el spec. Escribir código + tests. Marcar tasks [x].

### Pre-condiciones

- ✅ La feature está en `in_progress` (el leader debería haberte lanzado)
- ✅ Existen los 3 archivos en `specs/<name>/`
- ✅ El humano aprobó el spec

### Protocolo

1. Lee el spec completo (requirements, design, tasks)
2. Anota plan en `progress/current.md`:
   ```markdown
   ## Feature en curso
   
   Feature: #7 cli_recent
   Status: in_progress
   
   Plan:
   - [ ] T1: Implementar cmd_recent()
   - [ ] T2: Registrar subparser
   - [ ] T3: Escribir tests
   - [ ] T4: Verificar verde
   ```

3. **Para cada T<n> en orden:**
   ```
   a) Implementa el cambio que dice la task
   b) Si incluye test, escríbelo ahora
   c) Marca [x] T<n> en specs/<name>/tasks.md
   d) Ejecuta ./init.sh
      - Si rojo → vuelve a 3a
      - Si verde → siguiente task
   ```

4. Cuando termines todas las tasks, documenta trazabilidad en `progress/impl_<name>.md`:
   ```markdown
   ## Trazabilidad
   
   - R1 → test_recent_default_limit
   - R2 → test_recent_invalid_limit
   - R3 → test_recent_custom_limit
   ```

5. **NO marques `done` tú mismo.** Espera al reviewer.

### Qué hacer si te atascas

```
¿Se puede completar esta task SIN desviarse del spec?

SÍ → Completa la task.

NO → PARA.
    Documenta el problema en progress/impl_<name>.md
    Cambia status a "blocked" en feature_list.json
    Reporta al leader
    NO inventes requirements ni decisiones nuevas.
```

### Salida esperada

```
done -> progress/impl_<name>.md
```

O si hay problema:

```
blocked -> progress/impl_<name>.md
```

---

## Para el REVIEWER

**Tu trabajo:** Verificar trazabilidad, checkpoints, tests verdes. Aprobar o rechazar. NUNCA editar código.

### Pre-condiciones

- ✅ Feature en `in_progress`
- ✅ Existe `progress/impl_<name>.md`
- ✅ Tests ejecutados (implementer debería haberlos dejado verdes)

### Checklist de verificación

```
┌─ TRAZABILIDAD (Regla dura)
│
├─ [ ] Leer requirements.md
│      Por cada R1, R2, ... :
│         - [ ] ¿Existe un test que lo verifique?
│           - Sí → cita test en progress/review_<name>.md
│           - NO → RECHAZA (cita R<n> sin test)
│
├─ TASKS COMPLETAS
│  ├─ [ ] Leer tasks.md
│  └─ [ ] ¿Todas las tasks están [x]?
│         - Sí → Continúa
│         - NO → ¿Hay justificación en impl_<name>.md?
│           - Sí → Documenta
│           - NO → RECHAZA
│
├─ VERIFICACIÓN EJECUTABLE
│  ├─ [ ] Ejecutar ./init.sh
│  └─ [ ] ¿Exit code 0?
│         - Sí → Continúa
│         - NO → RECHAZA (cita salida de init.sh)
│
└─ CHECKPOINTS (CHECKPOINTS.md)
   ├─ [ ] C1: Arnés completo
   ├─ [ ] C2: Estado coherente
   ├─ [ ] C3: Código respeta arquitectura
   ├─ [ ] C4: Verificación real
   ├─ [ ] C5: Sesión cerrada
   └─ [ ] C6: SDD cumplido
        - ¿Todos [x]?
        - Sí → APPROVED
        - NO → CHANGES_REQUESTED (cita cuáles no se cumplen)
```

### Formato de veredicto

Escribe en `progress/review_<name>.md`:

```markdown
# Review — Feature <id>: <nombre>

**Veredicto:** APPROVED | CHANGES_REQUESTED

## Trazabilidad requirements ↔ tests
- R1: [x] cubierto por `test_xxx`
- R2: [x] cubierto por `test_yyy`
- R3: [ ] ← SIN TEST (RECHAZA)

## Tasks completas
- T1: [x]
- T2: [x]
- T3: [ ] ← Sin justificación (RECHAZA)

## Checkpoints
- C1: [x]
- C2: [x]
- C3: [x]
- C4: [x]
- C5: [x]
- C6: [x]

## Cambios requeridos (si CHANGES_REQUESTED)
1. Añadir test para R3 (está en requirements.md sin cobertura)
2. Completar T3 o documentar justificación en progress/impl_<name>.md

## init.sh output
```
[OK]    Entorno listo.
```
```

### Reglas de oro (Reglas duras)

```
❌ NUNCA apruebes con tests rojos
   "Déjame arreglar..." → NO. Es trabajo del implementer.

❌ NUNCA apruebes con ./init.sh fallando

❌ NUNCA apruebes si algún R<n> queda SIN TEST
   Aunque el código esté perfecto, sin test → RECHAZA.

❌ NUNCA apruebes si tareas están [ ] SIN JUSTIFICACIÓN
   "Hacemos después" → NO. Ahora o documenta por qué no ahora.

❌ NUNCA edites el código
   Si hay problema: RECHAZA y cita qué está mal.
   El implementer lo arregla.

✅ SÉ CONCRETO
   "Hay un problema" → Vago.
   "Línea 45 de src/cli.py: variable sin usar" → Concreto.
```

### Salida esperada

```
APPROVED -> progress/review_<name>.md
```

o

```
CHANGES_REQUESTED -> progress/review_<name>.md
```

Nunca devuelvas el contenido del review en chat. Vive en `progress/review_<name>.md`.

---

## Tabla Rápida: Qué Hace Cada Agente

| Agente | Lee | Escribe | Estado inicial | Estado final | Puede editar |
|--------|-----|---------|---|---|---|
| **Leader** | AGENTS.md, FLJ, current.md | progress/current.md, FLJ status | any | any | src/tests? **NO** |
| **Spec Author** | docs/*, acceptance criteria | specs/<name>/*.md, FLJ status | pending | spec_ready | src/tests? **NO** |
| **Implementer** | specs/<name>/*, docs/* | src/*, tests/*, progress/impl_*.md | in_progress | (wait for reviewer) | src/tests? **YES** |
| **Reviewer** | specs/<name>/*, impl_*.md, tests/* | progress/review_*.md | in_progress | (feedback) | src/tests? **NO** |

---

## Abreviaturas

- **FLJ** = `feature_list.json`
- **SDD** = Spec Driven Development
- **EARS** = Easy Approach to Requirements Syntax
- **R<n>** = Requirement #n (R1, R2, ...)
- **T<n>** = Task #n (T1, T2, ...)
- **C<n>** = Checkpoint #n (C1-C6)

---

## Cosas que NO hacer

```
❌ Editar src/ siendo spec_author o reviewer
❌ Marcar feature como done siendo implementer
❌ Saltar init.sh (siempre ejecutar)
❌ Documentar en chat lo que va a progress/
❌ Una sola feature a la vez (regla hard)
❌ Inventar requirements nuevos (están en acceptance)
❌ Crear tests que solo usan mocks de FS
❌ Aprobar con tests rojos
❌ Editar código siendo reviewer
❌ Saltar la puerta de aprobación humana (spec_ready)
```

---

## Cosas que SÍ hacer

```
✅ Ejecutar ./init.sh con frecuencia
✅ Documentar bloqueos en progress/current.md
✅ Usar tempfile.TemporaryDirectory() en tests
✅ Cada R<n> mapeable a al menos 1 test
✅ Cada task referencia R<n> que cubre
✅ init.sh verde antes de pasar a next task
✅ Reviewers rechaza si hay [ ] sin justificación
✅ El estado vive en disco (progress/), no en chat
✅ Parar y reportar si algo no funciona
✅ Usar EARS estricto en requirements (5 patrones)
```

---

**Fin de referencias rápidas.**

Imprime esta tabla y cuelgala cerca. La necesitarás.

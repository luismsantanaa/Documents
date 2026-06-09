# 🎯 BIENVENIDO — Comienza Aquí

> **Este proyecto contiene una extracción COMPLETA y EXHAUSTIVA del Harness Engineering implementado en el ejemplo.**
>
> Se han analizado, documentado y explicado TODOS los componentes, archivos, flujos y patrones necesarios para entender e implementar un Harness.

---

## 📖 ¿Por Dónde Empiezo?

### Opción 1: "Quiero entender rápido" (30 minutos)

```
1. Lee este archivo (5 min)
2. Lee: RESUMEN_EXTRACCION_FINAL.md (10 min)
3. Lee: RESUMEN_HARNESS_VISUAL.md (15 min)
4. ¡Listo! Entiendes qué es un Harness
```

### Opción 2: "Quiero aprender en profundidad" (2 horas)

```
1. Lee este archivo (5 min)
2. Lee: RESUMEN_HARNESS_VISUAL.md (20 min)
3. Lee: REFERENCIAS_RAPIDAS_POR_ROL.md (20 min)
4. Lee: IMPLEMENTACION_HARNESS.md (60 min)
5. ¡Listo! Puedes implementar un Harness
```

### Opción 3: "Necesito referencias ahora" (5 minutos)

```
Abre: REFERENCIAS_RAPIDAS_POR_ROL.md
→ Busca tu rol
→ Sigue el checklist
```

---

## 📚 Los 5 Documentos Extraídos

| # | Nombre | Tamaño | Lectura | Para quién |
|---|--------|--------|---------|-----------|
| 1 | **RESUMEN_EXTRACCION_FINAL.md** | 📄 | 10 min | **VE PRIMERO** |
| 2 | **RESUMEN_HARNESS_VISUAL.md** | 📘 | 15 min | Todos (visión rápida) |
| 3 | **REFERENCIAS_RAPIDAS_POR_ROL.md** | 📋 | Consulta | Cada agente/rol |
| 4 | **IMPLEMENTACION_HARNESS.md** | 📖 | 60 min | Arquitectos, técnicos |
| 5 | **INDICE_DOCUMENTOS.md** | 📑 | Referencia | Navegar entre docs |

**Total extraído:** 3400+ líneas, 85 KB de documentación

---

## ⚡ 30 Segundos: Qué es un Harness

Un **Harness** es una estructura de repositorio que permite a **agentes de IA trabajar de forma autónoma y verificable**.

Se construye sobre **4 pilares**:

```
1. REPOSITORIO = SISTEMA
   El estado, alcance y doctrina viven en disco (no en chat)

2. ORQUESTACION MULTI-AGENTE
   4 roles especializados: Leader, Spec Author, Implementer, Reviewer

3. SPEC DRIVEN DEVELOPMENT
   Especificaciones aprobadas ANTES de escribir código

4. VERIFICACION EJECUTABLE
   ./init.sh → rojo o verde (no interpretación)
```

**Beneficio:** Menos sorpresas, menos retrabajos, agentes autónomos.

---

## 📋 Checklist Rápido

```
¿Necesitas...?

[ ] Entender qué es un Harness
    → Ve a: RESUMEN_EXTRACCION_FINAL.md § "Lo Que Hace Especial Este Harness"

[ ] Ver diagramas y explicaciones visuales
    → Ve a: RESUMEN_HARNESS_VISUAL.md

[ ] Saber qué toca hacer en tu rol (Leader, Spec Author, etc)
    → Ve a: REFERENCIAS_RAPIDAS_POR_ROL.md

[ ] Implementar un Harness desde cero
    → Ve a: IMPLEMENTACION_HARNESS.md § "Checklist de Implementación"

[ ] Entender EARS notation (cómo redactar requirements)
    → Ve a: IMPLEMENTACION_HARNESS.md § "requirements.md — EARS estricto"

[ ] Entender qué son los Checkpoints
    → Ve a: RESUMEN_HARNESS_VISUAL.md § 8

[ ] Entender la trazabilidad (R<n> ↔ test)
    → Ve a: RESUMEN_HARNESS_VISUAL.md § 7

[ ] Buscar algo específico
    → Ve a: INDICE_DOCUMENTOS.md
```

---

## 🎯 Los 3 Archivos Que DEBES Leer

### 1. RESUMEN_EXTRACCION_FINAL.md (10 min)

**¿Qué contiene?**
- Resumen ejecutivo de toda la extracción
- Los 4 pilares explicados
- Archivos requeridos
- Flujo SDD
- Los 4 roles
- Reglas duras
- Comparación con código tradicional

**Lee esto primero.** Te da contexto.

---

### 2. RESUMEN_HARNESS_VISUAL.md (15 min)

**¿Qué contiene?**
- Explicación visual con diagramas ASCII
- Estructura de directorios
- Los 4 archivos clave
- Flujo de trabajo en 4 pasos
- Ejemplo ficticio real
- Checklist de implementación

**Lee esto segundo.** Te muestra cómo funciona.

---

### 3. REFERENCIAS_RAPIDAS_POR_ROL.md (10-20 min)

**¿Qué contiene?**
- Protocolo específico para cada rol
- Checklists de verificación
- Qué hacer/NO hacer
- Reglas de oro
- Tablas de referencia

**Lee la sección de tu rol.** Te dice qué toca hacer ahora.

---

## 🔄 El Flujo (Resumen de 30 Segundos)

```
pending
  ↓
[Spec Author redacta requirements.md, design.md, tasks.md]
  ↓
spec_ready
  ↓
⏸ HUMANO LEE Y APRUEBA
  ↓
in_progress
  ↓
[Implementer escribe código + tests según spec]
  ↓
[Reviewer verifica: cada R<n> → test, CHECKPOINTS OK]
  ↓
done
```

**Clave:** Spec aprobada ANTES de código. Sin sorpresas.

---

## 👥 Los 4 Roles (En 1 Línea Cada Uno)

| Rol | Qué Hace | Qué NO Hace |
|-----|----------|-----------|
| **Leader** | Orquesta: ve feature pendiente, lanza spec_author | Edita código |
| **Spec Author** | Redacta 3 archivos: requirements, design, tasks | Edita código |
| **Implementer** | Escribe código + tests siguiendo spec | Se auto-aprueba |
| **Reviewer** | Verifica trazabilidad R<n> ↔ test, aprueba | Edita código |

---

## 🔐 Las 3 Reglas MÁS Duras

```
1. UNA SOLA FEATURE A LA VEZ
   No mezcles cambios de varias features en una sesión

2. CADA R<n> DEBE TENER UN TEST
   El reviewer rechaza si falta cobertura

3. NO MARQUES DONE SIN TESTS VERDES
   ./init.sh debe pasar. Sino, bloqueado.
```

---

## 📁 Archivos Requeridos (16 Obligatorios)

```
✅ CLAUDE.md                   # Fuerza rol
✅ AGENTS.md                   # Mapa
✅ feature_list.json           # Alcance
✅ CHECKPOINTS.md              # 6 criterios
✅ init.sh                      # Verificación ejecutable

✅ docs/architecture.md        # Qué es "buen trabajo"
✅ docs/conventions.md         # Estilo, nombres
✅ docs/specs.md              # Cómo hacer specs
✅ docs/verification.md       # Cómo verificar

✅ .claude/agents/leader.md       # Agente
✅ .claude/agents/spec_author.md  # Agente
✅ .claude/agents/implementer.md  # Agente
✅ .claude/agents/reviewer.md     # Agente
✅ .claude/settings.json          # Hooks

✅ progress/current.md        # Estado vivo
✅ progress/history.md        # Bitácora
```

---

## 💡 El "Eureka" Moment

**Sin Harness:**
```
Código → Review → "Necesita cambiar arquitectura"
[Retrabajar TODO]
[Frustración]
```

**Con Harness (SDD):**
```
Spec (aprobado) → Código (sigue spec) → Review (verificación)
[Menos sorpresas, menos retrabajos]
[Eficiencia]
```

La magia está en la **puerta de aprobación humana** después del spec, ANTES del código.

---

## 🚀 Próximos 5 Pasos

1. **Lee** RESUMEN_EXTRACCION_FINAL.md (10 min)
2. **Lee** RESUMEN_HARNESS_VISUAL.md (15 min)
3. **Consulta** REFERENCIAS_RAPIDAS_POR_ROL.md para tu rol (10 min)
4. **Implementa** siguiendo IMPLEMENTACION_HARNESS.md § "Checklist" (2 horas)
5. **Usa** el Harness: `claude` en raíz y pide "implementa siguiente feature"

---

## ❓ Preguntas Frecuentes

**P: ¿Es complicado?**
R: No. Los 4 pilares son simples. La complejidad está en evitar que el agente se pierda.

**P: ¿Cuánto tiempo toma implementar un Harness?**
R: 2-3 horas para copiar estructura y adaptar documentación.

**P: ¿Funciona solo con IA?**
R: Sí y no. Es para agentes IA, pero requiere aprobación humana en puntos críticos.

**P: ¿Y si el agente se ataska?**
R: `progress/current.md` documenta bloqueos. El agente paras y reporta. El humano decide.

**P: ¿Es obligatorio usar todos los 16 archivos?**
R: SÍ (para features con `"sdd": true`). Sin ellos, el agente no tiene guía.

---

## 📞 Navegación Rápida

```
¿Dónde está...?

RESUMEN_EXTRACCION_FINAL.md    ← Ve PRIMERO (10 min)
RESUMEN_HARNESS_VISUAL.md      ← Ve SEGUNDO (15 min)
REFERENCIAS_RAPIDAS_POR_ROL.md ← Consulta según rol
IMPLEMENTACION_HARNESS.md      ← Referencia técnica completa
INDICE_DOCUMENTOS.md           ← Navega entre documentos
```

---

## ✨ Lo Más Importante

> **El Harness no es código. Es PROCESO + ESTADO + VERIFICACION.**
>
> Es infraestructura que permite a agentes trabajar de forma autónoma sin inventar qué hacer.

---

## 🎯 TU SIGUIENTE PASO

**Abre este archivo ahora:**

# 👉 RESUMEN_EXTRACCION_FINAL.md

(Es el resumen ejecutivo de toda la documentación. Te toma 10 minutos.)

---

**¡Bienvenido al Harness Engineering!**

Esta documentación es tu guía. Los patrones aquí descritos funcionan. La práctica lo demuestra.

Buena suerte. 🚀

---
name: refactor-code
description: Apply behavior-preserving code refactoring using Fowler-style smell detection, small verified steps, and practical refactoring patterns. Use this skill when improving existing code structure, readability, maintainability, and design without changing externally observable behavior.
---

# Refactor Code

## Purpose

Use this skill to refactor existing code while preserving external behavior. This skill is optimized for IDE and coding-agent workflows where code remains in English and code comments or documentation also remain in English.

This skill follows a Fowler-aligned approach:
- preserve observable behavior
- separate refactoring from feature work and bug fixing
- work in very small reversible steps
- use tests or equivalent verification as a safety net
- detect code smells first, then choose the appropriate refactoring

## When to use this skill

Use this skill when:
- a function, class, or module is hard to understand or change
- duplicated logic appears in multiple places
- conditionals, switches, or branching logic are growing out of control
- classes or functions have too many responsibilities
- parameter lists are too long or recurring data travels together
- responsibilities appear to belong to another class or module
- refactoring is needed before adding new behavior
- technical debt is blocking safe evolution
- code review reveals maintainability or design issues

## When not to use this skill

Do not use this skill when:
- the real task is to add a new feature
- the main task is to fix a production bug and no safe baseline exists yet
- behavior is currently unknown and cannot be verified
- the code is so unstable that characterization tests or equivalent checks must be created first
- the request is primarily about performance tuning rather than structure
- the request is primarily about style-only formatting without structural improvement

If the user asks for refactoring plus a feature, split the work conceptually:
1. stabilize and refactor
2. verify behavior
3. add the feature separately

## Core operating rules

### Mandatory

1. Preserve externally observable behavior.
2. Prefer the smallest safe refactoring step.
3. Refactor only after identifying the code smell or design problem.
4. Verify after each meaningful step using tests, type checks, linting, build checks, or behavior comparison.
5. Keep code, names, and comments in English.
6. Prefer self-documenting code over explanatory comments.
7. If behavior is unclear, document current behavior before changing structure.

### Prohibited

1. Do not mix refactoring with feature addition in the same change set.
2. Do not silently change business rules, data contracts, side effects, or error semantics.
3. Do not perform large speculative rewrites when smaller local refactorings are sufficient.
4. Do not introduce abstraction only for its own sake.
5. Do not rely on rigid numeric rules alone, such as maximum line counts, to justify a refactor.

## Working sequence

### Step 1: Understand current behavior

Before changing structure, identify:
- inputs and outputs
- side effects
- invariants
- error behavior
- dependencies
- important edge cases

If tests do not exist, prefer characterization tests or equivalent behavior checks before structural changes.

Use this structure when needed:

```md
## Behavior Analysis

### Inputs
- [parameters and constraints]

### Outputs
- [return values]
- [state changes]
- [I/O or persistence side effects]

### Invariants
- [facts that must remain true]

### Edge Cases
- [null, empty, boundary, exceptional flows]

### Dependencies
- [APIs, services, files, DB, environment, shared state]
```

### Step 2: Detect the smell first

Identify one or more primary smells before proposing refactorings.

Common smells and likely first refactorings:

| Smell | Likely Refactorings |
|---|---|
| Duplicated Code | Extract Method, Extract Class, Form Template Method, Substitute Algorithm |
| Long Method | Extract Method, Replace Temp with Query, Introduce Parameter Object, Replace Method with Method Object, Decompose Conditional |
| Large Class | Extract Class, Extract Subclass, Extract Interface |
| Long Parameter List | Introduce Parameter Object, Preserve Whole Object, Replace Parameter with Method |
| Divergent Change | Extract Class |
| Shotgun Surgery | Move Method, Move Field, Inline Class |
| Feature Envy | Move Method, Extract Method |
| Data Clumps | Extract Class, Introduce Parameter Object, Preserve Whole Object |
| Primitive Obsession | Replace Data Value with Object, Replace Type Code with Class/Subclass/State-Strategy, Replace Array with Object |
| Switch Statements | Replace Conditional with Polymorphism, Replace Type Code with Subclasses, Replace Type Code with State/Strategy, Introduce Null Object |
| Message Chains | Hide Delegate, Extract Method, Move Method |
| Middle Man | Remove Middle Man, Inline Method, Replace Delegation with Inheritance |
| Data Class | Encapsulate Field, Encapsulate Collection, Move Method, Hide Method |
| Refused Bequest | Push Down Method, Push Down Field, Replace Inheritance with Delegation |
| Comments explaining unclear code | Extract Method, Rename Method, better names and decomposition |

If multiple smells are present, prioritize the one that blocks safe understanding first.

### Step 3: Choose the smallest suitable refactoring

Prefer a sequence of micro-refactorings over one large transformation.

Typical order:
1. Rename for clarity
2. Extract small coherent logic
3. Reduce local variable complexity
4. Move responsibilities to the correct object or module
5. Simplify conditionals
6. Improve data modeling
7. Reassess whether additional abstraction is still needed

### Step 4: Apply the change in small verified steps

After each meaningful step:
- run tests if available
- run type checks if available
- run linting if available
- ensure public behavior still matches baseline

### Step 5: Summarize the refactor

Document:
- what smell was detected
- which refactorings were applied
- what behavior was intentionally preserved
- any remaining risks or follow-up opportunities

## Refactoring catalog by category

### Composing methods

Use when methods are too long or too hard to read.

Primary options:
- Extract Method
- Inline Method
- Inline Temp
- Replace Temp with Query
- Introduce Explaining Variable
- Split Temporary Variable
- Remove Assignments to Parameters
- Replace Method with Method Object
- Substitute Algorithm

### Moving responsibilities between objects

Use when behavior lives in the wrong place.

Primary options:
- Move Method
- Move Field
- Extract Class
- Inline Class
- Hide Delegate
- Remove Middle Man
- Introduce Foreign Method
- Introduce Local Extension

### Organizing data

Use when primitives, arrays, records, or public fields are doing too much work.

Primary options:
- Self Encapsulate Field
- Replace Data Value with Object
- Change Value to Reference
- Replace Array with Object
- Duplicate Observed Data
- Change Unidirectional Association to Bidirectional
- Change Bidirectional Association to Unidirectional
- Replace Magic Number with Symbolic Constant
- Encapsulate Field
- Encapsulate Collection
- Replace Record with Data Class
- Replace Type Code with Class
- Replace Type Code with Subclasses
- Replace Type Code with State/Strategy
- Replace Subclass with Fields

### Simplifying conditionals

Use when control flow is hard to follow or repeated.

Primary options:
- Decompose Conditional
- Consolidate Conditional Expression
- Consolidate Duplicate Conditional Fragments
- Remove Control Flag
- Replace Nested Conditional with Guard Clauses
- Replace Conditional with Polymorphism
- Introduce Null Object
- Introduce Assertion

### Making method calls simpler

Use when interfaces are confusing or too noisy.

Primary options:
- Rename Method
- Add Parameter
- Remove Parameter
- Separate Query from Modifier
- Parameterize Method
- Replace Parameter with Explicit Methods
- Preserve Whole Object
- Replace Parameter with Method
- Introduce Parameter Object
- Remove Setting Method
- Hide Method
- Replace Constructor with Factory Method
- Encapsulate Downcast
- Replace Error Code with Exception
- Replace Exception with Test

### Handling generalization

Use when inheritance or delegation structures are wrong or unclear.

Primary options:
- Pull Up Field
- Pull Up Method
- Pull Up Constructor Body
- Push Down Method
- Push Down Field
- Extract Subclass
- Extract Superclass
- Extract Interface
- Collapse Hierarchy
- Form Template Method
- Replace Inheritance with Delegation
- Replace Delegation with Inheritance

## Practical examples

### Example 1: Extract Method

Before:

```ts
function renderInvoice(invoice: Invoice) {
  if (!invoice.items || invoice.items.length === 0) {
    throw new Error('Invoice must contain items');
  }

  let subtotal = 0;
  for (const item of invoice.items) {
    subtotal += item.price * item.quantity;
  }

  const tax = subtotal * 0.18;
  const total = subtotal + tax;

  console.log(`Customer: ${invoice.customerName}`);
  console.log(`Subtotal: ${subtotal}`);
  console.log(`Tax: ${tax}`);
  console.log(`Total: ${total}`);
}
```

After:

```ts
function renderInvoice(invoice: Invoice) {
  validateInvoice(invoice);
  const subtotal = calculateSubtotal(invoice.items);
  const tax = calculateTax(subtotal);
  printInvoiceSummary(invoice.customerName, subtotal, tax, subtotal + tax);
}

function validateInvoice(invoice: Invoice) {
  if (!invoice.items || invoice.items.length === 0) {
    throw new Error('Invoice must contain items');
  }
}

function calculateSubtotal(items: InvoiceItem[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

function calculateTax(subtotal: number): number {
  return subtotal * 0.18;
}

function printInvoiceSummary(customerName: string, subtotal: number, tax: number, total: number) {
  console.log(`Customer: ${customerName}`);
  console.log(`Subtotal: ${subtotal}`);
  console.log(`Tax: ${tax}`);
  console.log(`Total: ${total}`);
}
```

Why:
- long method
- mixed responsibilities
- clearer names reveal intent

### Example 2: Remove Duplication

Before:

```ts
async function getActiveCustomers() {
  return db.customer.findMany({
    where: { isActive: true, deletedAt: null },
    select: { id: true, name: true, email: true }
  });
}

async function getActivePremiumCustomers() {
  return db.customer.findMany({
    where: { isActive: true, deletedAt: null, plan: 'premium' },
    select: { id: true, name: true, email: true }
  });
}
```

After:

```ts
type CustomerFilter = {
  plan?: string;
};

async function getActiveCustomers(filter: CustomerFilter = {}) {
  return db.customer.findMany({
    where: {
      isActive: true,
      deletedAt: null,
      ...filter
    },
    select: { id: true, name: true, email: true }
  });
}
```

Why:
- duplicated query structure
- one clearer variation point

### Example 3: Replace Conditional with Polymorphism

Before:

```ts
class DiscountCalculator {
  calculate(order: Order): number {
    if (order.customerType === 'regular') {
      return order.total * 0.02;
    }
    if (order.customerType === 'premium') {
      return order.total * 0.10;
    }
    if (order.customerType === 'vip') {
      return order.total * 0.18;
    }
    return 0;
  }
}
```

After:

```ts
interface DiscountPolicy {
  calculate(order: Order): number;
}

class RegularDiscountPolicy implements DiscountPolicy {
  calculate(order: Order): number {
    return order.total * 0.02;
  }
}

class PremiumDiscountPolicy implements DiscountPolicy {
  calculate(order: Order): number {
    return order.total * 0.10;
  }
}

class VipDiscountPolicy implements DiscountPolicy {
  calculate(order: Order): number {
    return order.total * 0.18;
  }
}
```

Why:
- switch/conditional smell
- behavior varies by type
- easier extension without editing branching logic everywhere

### Example 4: Introduce Parameter Object

Before:

```ts
function createShipment(
  customerId: string,
  originPort: string,
  destinationPort: string,
  vesselCode: string,
  eta: Date,
  priority: string
) {
  // ...
}
```

After:

```ts
interface RouteInfo {
  originPort: string;
  destinationPort: string;
  vesselCode: string;
  eta: Date;
}

interface CreateShipmentRequest {
  customerId: string;
  route: RouteInfo;
  priority: string;
}

function createShipment(request: CreateShipmentRequest) {
  // ...
}
```

Why:
- long parameter list
- data clumps travel together
- easier future extension

### Example 5: Single Responsibility decomposition

Before:

```ts
class UserService {
  saveUser(user: User) {
    // persistence
  }

  sendWelcomeEmail(user: User) {
    // email
  }

  generateAuditReport(user: User) {
    // reporting
  }
}
```

After:

```ts
class UserRepository {
  save(user: User) {
    // persistence
  }
}

class WelcomeEmailService {
  send(user: User) {
    // email
  }
}

class UserAuditReportService {
  generate(user: User) {
    // reporting
  }
}
```

Why:
- large class / mixed responsibilities
- clearer ownership and easier testing

## Behavior validation

Choose commands that fit the stack. Use what exists in the repository rather than inventing new tooling.

Typical validation sequence:

```bash
# tests
npm test
# or
pytest
# or
dotnet test

# type / compile validation
npx tsc --noEmit
# or
dotnet build
# or
mvn test

# lint / static analysis
npm run lint
# or
ruff check .
# or
sonar-scanner
```

Also validate:
- same public inputs produce same outputs
- same errors are thrown for the same invalid cases unless explicitly justified
- same side effects occur in the same order when order matters
- no contract changes in API, persistence shape, or event payloads unless explicitly requested

## Refactoring checklist

Use this as guidance, not dogma.

- [ ] The code is easier to read than before
- [ ] Names reveal intent
- [ ] One clear responsibility per function or class where practical
- [ ] Duplication was reduced or isolated
- [ ] Conditionals were simplified where appropriate
- [ ] Data that belongs together is modeled together
- [ ] Magic numbers were replaced when meaningful
- [ ] Public behavior remains unchanged
- [ ] Tests or equivalent checks were run
- [ ] Comments were reduced where naming/decomposition made them unnecessary

## Output format

When performing refactoring work, respond using this structure:

```md
## Refactoring Analysis
- Primary smell(s): ...
- Why this is a problem: ...
- Chosen refactoring(s): ...

## Plan
1. ...
2. ...
3. ...

## Changes Made
1. ...
2. ...
3. ...

## Behavior Preservation Notes
- Inputs/outputs preserved: yes/no + notes
- Side effects preserved: yes/no + notes
- Error behavior preserved: yes/no + notes

## Validation
- Tests: passed / not run / unavailable
- Type check/build: passed / not run / unavailable
- Lint/static analysis: passed / not run / unavailable

## Risks / Follow-ups
- ...
```

## Troubleshooting

### Tests fail after refactoring
- likely cause: behavior changed or hidden dependency surfaced
- response: revert the last step, isolate the failing change, re-verify, then continue in smaller increments

### Code is still too complex after one refactor
- likely cause: more than one smell is present
- response: identify the next dominant smell instead of forcing one pattern to solve everything

### Performance regressed
- likely cause: abstraction introduced extra work on a hot path
- response: preserve the design improvement if possible, then optimize with measurement instead of guessing

### Too many delegate methods appeared
- likely cause: Hide Delegate may have gone too far
- response: reconsider Remove Middle Man or move the boundary

## Best practices

- Follow Boy Scout Rule: leave the code cleaner than you found it
- Prefer red-green-refactor when tests exist
- Prefer focused commits or reviewable units
- Stop when the code is clearly better; do not chase perfection
- Prefer explicit tradeoff notes when a smell cannot be fully removed safely

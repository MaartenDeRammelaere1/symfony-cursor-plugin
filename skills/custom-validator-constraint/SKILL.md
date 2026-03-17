---
name: custom-validator-constraint
description: Add a custom Symfony Validator constraint and validator class. Use when validating DTOs or objects with rules not covered by built-in or existing constraints (e.g. cross-field or entity-existence checks).
---

# Custom Validator Constraint

## 1. Constraint class

- **Namespace**  
  Place in your validator constraints namespace (e.g. `App\Validator\Constraints\` or a shared module).

- **Class**  
  `final class` extending `Symfony\Component\Validator\Constraint`.

- **Constructor**  
  Accept options (e.g. `entity`, `fieldId`). Call `parent::__construct($options)` or pass options. Throw `MissingOptionsException` when a required option is missing.

- **Message**  
  Define a `public const string MESSAGE = 'translation_key';` (or a literal message) for the violation.

- **Validator**  
  Implement `validatedBy(): string` and return the validator class name (e.g. `MyConstraintValidator::class`).

## 2. Validator class

- **Class**  
  `final class MyConstraintValidator extends ConstraintValidator`. Name: constraint name + `Validator`.

- **Method**  
  `validate($value, Constraint $constraint): void`. Use `$this->context->buildViolation($constraint::MESSAGE)` (and `setParameter(...)` if needed), then `addViolation()` on failure. For **class-level** constraints, `$value` is the whole object; read other fields from it. For **property** constraints, `$value` is the property value; read the parent object from the context if needed.

- **Options**  
  Read constraint options (e.g. `$constraint->entity`, `$constraint->fieldId`) to perform repository or cross-field checks. Use the validator’s dependencies (injected via constructor) to load entities or run queries.

## 3. Using the constraint

- Attach the constraint to the DTO (or object) via **annotation/attribute** on the property or class, or in your project’s **constraint collection** (e.g. in a `getConstraints()` method that returns a constraint list per field). For class-level constraints, add them to the root.

## Example (entity existence)

- Constraint: e.g. `EntityExists(entity: User::class)`.
- Validator: resolve the repository for the given entity class, load by ID (from the value or another field); if not found, add a violation. Reuse a generic entity-exists validator if your project has one.

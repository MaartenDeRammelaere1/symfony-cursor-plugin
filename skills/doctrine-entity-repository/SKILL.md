---
name: doctrine-entity-repository
description: Create or modify Doctrine ORM entities and repositories (ORM and DBAL). Use when adding new entities, tables, relations, or list/report repositories in a Symfony + Doctrine backend.
---

# Doctrine Entity & Repository

## New entity

1. **Class and namespace**  
   Place the entity in your domain/entity namespace (e.g. `App\Entity\*`). Use Doctrine ORM **attributes**: `#[ORM\Entity(repositoryClass: ...)]`, `#[ORM\Table(name: '...')]`, `#[ORM\Column(...)]`, `#[ORM\ManyToOne]` / `#[ORM\OneToMany]` / `#[ORM\JoinColumn]`. Prefer **readonly** and constructor promotion for required fields where the domain allows.

2. **Identifiers**  
   Use `Symfony\Component\Uid\Uuid` for single-column primary keys when you need stable IDs; expose in the API as `->toRfc4122()`. For **composite keys**, put `#[ORM\Id]` on each part and configure `JoinColumn` appropriately.

3. **Timestamps**  
   In the constructor, set created/updated via an **injectable clock** or shared time service, not `new \DateTimeImmutable()`. Use column type `datetime_immutable`.

4. **Repository**  
   Create a repository class extending Doctrine’s `ServiceEntityRepository` and set it in the entity’s `repositoryClass`. Use it for loading single entities and simple, intent-named queries.

5. **Migration**  
   Generate a migration after entity changes; do not skip migrations or edit the schema by hand without a migration.

## New list or report repository (DBAL)

1. **Class**  
   Create a repository (e.g. in `Repository\Dbal\*` or your project’s equivalent) that uses the DBAL connection and query builder (or raw SQL) for complex filters, sorting, and pagination.

2. **List interface**  
   If this list backs an API endpoint, implement your project’s list contract (e.g. `findAll(filters, sort)`, `getPaginatorAdapter`, `getFilterValues`) and return a paginator adapter (e.g. Pagerfanta) and filter options. This keeps controllers and services independent of persistence details.

3. **Reuse**  
   Reuse existing traits or base classes for common filter logic and naming so queries stay consistent and maintainable.

## Relations

- Use `targetEntity: Other::class` and `JoinColumn(nullable: true|false)`. For one-to-many collections, use `OneToMany` with `mappedBy` and the inverse `ManyToOne` to avoid orphans.
- For enum-like fields, use **PHP backed enums** and map them to string/int in the database via your Doctrine enum or scalar type setup.

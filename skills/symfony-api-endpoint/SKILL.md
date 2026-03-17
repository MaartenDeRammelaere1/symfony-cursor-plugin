---
name: symfony-api-endpoint
description: Add a new REST endpoint in a Symfony API using controller, service, DTO, and response objects. Use when adding a new API route, CRUD action, or resource endpoint in a Symfony backend that uses thin controllers and service/DTO/response layering.
---

# Add a Symfony REST API Endpoint

Use when adding a new REST endpoint that follows: **Controller → validate DTO → Service → build response → return JSON**.

## Checklist

- [ ] **DTO (input)**  
  Create or reuse a DTO with constructor-promoted readonly properties. Attach **validation constraints** (Symfony Validator) so the same rules apply for API and other entry points. Optionally implement an API-docs interface (e.g. OpenAPI schema) on the DTO.

- [ ] **Service (business logic)**  
  Create or extend a service class (e.g. in `Service\` or `Handler\`). Use a **final readonly** class; inject EntityManager, repositories, and EventDispatcher. Methods accept the DTO and return the entity or void. After persist/flush, dispatch domain or audit events. No business logic in the controller.

- [ ] **Representation (output)**  
  Create or reuse a representation object (View/Resource) that maps entity → array/JSON. Use a static factory (e.g. `fromEntity(Entity $e): self`) and `JsonSerializable`. Optionally add OpenAPI schema for documentation.

- [ ] **Response**  
  Use your project’s response base class (e.g. implements `getStatusCode()` and `JsonSerializable`). For lists, use a consistent list response type with items and pagination metadata.

- [ ] **Controller**  
  New action (or new controller). Use `#[Route(..., methods: ['GET'|'POST'|...])]`. Validate the request (body/query) into the DTO with the Validator; on failure return validation errors (e.g. 422). Call the service with the DTO; build the representation and response; return JSON. On not-found or forbidden, return 404/403 using your standard helpers.

- [ ] **Security**  
  Ensure the route is covered by your security configuration (firewall, access control or voters). Use attributes (e.g. `#[IsGranted]`) where applicable.

## Conventions

- Use **UUIDs** for resource IDs in the API when your domain uses them; expose as strings (e.g. `->toRfc4122()`).
- For **list endpoints**, use a single list DTO (filters, sort, page size) and a repository or service that returns a paginator adapter and filter options. Keep the controller thin.
- Do not put business logic or direct repository writes in the controller.

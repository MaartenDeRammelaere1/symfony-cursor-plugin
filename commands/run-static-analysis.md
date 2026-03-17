---
name: run-static-analysis
description: Run PHPStan (and optionally ECS or PHP-CS-Fixer) in the PHP project; use Ddev or Docker when the project uses them
---

# Run static analysis

When the user wants to validate PHP code or fix static analysis issues:

1. **Ddev / Docker**  
   If the project uses **Ddev** or **Docker** for local PHP, run all PHP tools **inside the container** so the same PHP version and `vendor/` are used:
   - **Ddev**: From the repo root use `ddev phpstan` (if the project defines it), or `ddev exec "php backend/bin/phpstan analyse"` when the Composer root is `backend/`. For PHP-CS-Fixer or ECS: `ddev exec "php backend/bin/php-cs-fixer fix"` or `ddev exec "php backend/vendor/bin/ecs"` (adjust paths to the project’s Composer root).
   - **Docker Compose**: Use `docker compose exec <service> php bin/phpstan analyse` (or the project’s equivalent) from the directory that contains the Compose file. Use the service and paths that match the project.
   If unsure, check for `.ddev/` or `docker-compose.*` and any custom commands (e.g. `.ddev/commands/web/phpstan`).

2. **PHPStan**  
   From the Composer root (or repo root if same), run:
   - A project command such as `ddev phpstan` or `composer phpstan` if defined, or  
   - `vendor/bin/phpstan analyse` (or `php bin/phpstan analyse` with the correct path when Composer root is a subdir).  
   Fix reported errors by level; do not change intended behavior.

3. **Code style (ECS or PHP-CS-Fixer)**  
   If the project uses **Easy Coding Standard (ECS)** or **PHP-CS-Fixer**, run the project’s style command inside the container when applicable (e.g. `ddev exec "php backend/bin/php-cs-fixer fix"` or `ddev exec "php backend/vendor/bin/ecs check --fix"`). Change only style, not behavior.

4. **Scope**  
   Run from the repository root; Composer root may be a subdirectory (e.g. `backend/`). Use the paths and commands that match the project. Report any config or path issues to the user.

Interpret PHPStan output (e.g. missing types, wrong generics, Symfony/Doctrine extension messages) and suggest minimal code changes to satisfy the tool without altering behavior.

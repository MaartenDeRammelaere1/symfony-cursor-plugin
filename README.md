# Symfony PHP Backend – Cursor Plugin

A **generic** Cursor plugin with **rules**, **skills**, **agents**, **commands**, and **hooks** for working with Symfony and PHP 8+ REST API backends. It encodes common best practices: PSR-12, strict types, thin controllers, service/DTO/response layering, Doctrine ORM, and Symfony conventions. It is **not** tied to any specific project structure (e.g. no references to admin/platform or custom folder names).

## Contents

| Component | Description |
|-----------|-------------|
| **Rules** | PHP & Symfony standards (strict types, PSR-12, DI, naming); REST API layer (thin controllers, services, DTOs, responses); Doctrine entities and repositories (ORM/DBAL, UUIDs, timestamps, migrations). |
| **Skills** | Adding a REST endpoint (controller → service → DTO → response); Doctrine entity and repository; custom validator constraint. |
| **Agents** | Backend API reviewer (layers, security, conventions); general Symfony backend helper. |
| **Commands** | Run static analysis (PHPStan, ECS, or PHP-CS-Fixer); use Ddev or Docker when the project uses them. |
| **Hooks** | Optional: format PHP after edit (ECS or PHP-CS-Fixer via `scripts/cs-fix.sh`). Scripts are Ddev- and Docker-aware. |

## Installation

1. Add the plugin from the [Cursor marketplace](https://cursor.com/marketplace) or from a Git repository that contains this plugin folder.
2. Enable the plugin in Cursor so rules, skills, and agents are available to the agent.

## Usage

- **Rules**: Apply when working in PHP files (globs: `**/*.php`) or when selected. They are generic and do not assume a specific directory layout.
- **Skills**: Invoke by describing the task (e.g. “add a new REST endpoint for X”, “add a Doctrine entity for Y”, “add a custom validator for Z”).
- **Agents**: Choose “Backend API Reviewer” for code review or “Symfony Backend Helper” for general backend tasks.
- **Commands**: Ask the agent to “run static analysis” or “run PHPStan” to use the run-static-analysis command.
- **Hooks**: The default `hooks/hooks.json` runs `scripts/cs-fix.sh` after PHP file edits (format with ECS or PHP-CS-Fixer). You can add `sessionEnd` to run PHPStan (see below). Hook commands are relative to the **plugin root** (e.g. `./scripts/cs-fix.sh`).

## Ddev and Docker

When your project uses **Ddev** or **Docker** for local PHP, run PHP tools **inside the container** so the same PHP version and `vendor/` are used. The plugin’s **rules** (see `rules/php-ddev-docker.mdc`) and **scripts** support this:

- **Scripts** `scripts/cs-fix.sh` and `scripts/phpstan.sh` detect Ddev (`ddev describe`); when Ddev is running they run the tool via `ddev exec` so execution is inside the container. If your Composer root is a subdirectory (e.g. `backend/`), the scripts auto-detect `backend/composer.json` or you can set `COMPOSER_ROOT=backend`.
- **Commands** (e.g. run-static-analysis): the agent is instructed to use `ddev phpstan`, `ddev exec "php backend/bin/php-cs-fixer fix"`, or the project’s custom Ddev commands when applicable.

## Hooks and scripts

- **`scripts/cs-fix.sh`** – Runs ECS or PHP-CS-Fixer (whichever is present under the Composer root). Usage: `./symfony-plugin/scripts/cs-fix.sh` or `./symfony-plugin/scripts/cs-fix.sh [path]` when the plugin lives in a subfolder; otherwise `./scripts/cs-fix.sh`. Ddev-aware.
- **`scripts/phpstan.sh`** – Runs PHPStan. Usage: `./symfony-plugin/scripts/phpstan.sh` (or `./scripts/phpstan.sh` from the plugin root). Ddev-aware.
- **Default hook**: `afterFileEdit` with matcher `.*\.php$` runs `./scripts/cs-fix.sh` (plugin-relative) so edited PHP files are formatted.
- **Optional**: To run PHPStan at the end of each agent session, add to `hooks/hooks.json`: `"sessionEnd": [{ "command": "./scripts/phpstan.sh" }]`. Can be noisy; enable only if you want it.

Make the scripts executable (`chmod +x scripts/*.sh`) if your environment requires it.

## Plugin structure

The plugin follows both [Cursor](https://cursor.com/docs/plugins) (`.cursor-plugin/`) and [Open Plugins](https://open-plugins.com/) (`.plugin/`) conventions. When you change the manifest, keep both in sync by running `./scripts/sync-manifest.sh`.

```
symfony-plugin/
├── .cursor-plugin/
│   └── plugin.json       # Cursor manifest (source of truth)
├── .plugin/
│   └── plugin.json       # Open Plugins manifest (copy; sync via scripts/sync-manifest.sh)
├── rules/
│   ├── php-symfony-backend.mdc
│   ├── api-layer-conventions.mdc
│   ├── doctrine-entities.mdc
│   └── php-ddev-docker.mdc
├── skills/
│   ├── symfony-api-endpoint/
│   │   └── SKILL.md
│   ├── doctrine-entity-repository/
│   │   └── SKILL.md
│   └── custom-validator-constraint/
│       └── SKILL.md
├── agents/
│   ├── backend-api-reviewer.md
│   └── symfony-backend-helper.md
├── commands/
│   └── run-static-analysis.md
├── hooks/
│   └── hooks.json
├── scripts/
│   ├── cs-fix.sh         # ECS or PHP-CS-Fixer (Ddev-aware)
│   ├── phpstan.sh       # PHPStan (Ddev-aware)
│   └── sync-manifest.sh  # Sync .cursor-plugin/plugin.json → .plugin/plugin.json
└── README.md
```

## Standards and references

The rules align with:

- **PHP**: PSR-1, PSR-4, PSR-12; strict types; modern PHP 8+ features (readonly, enums, etc.).
- **Symfony**: [Symfony best practices](https://symfony.com/doc/current/best_practices.html), [Symfony coding standards](https://symfony.com/doc/current/contributing/code/standards.html), [Symfony conventions](https://symfony.com/doc/current/contributing/code/conventions.html).

The plugin does not reference Laravel, project-specific namespaces, or custom folder layouts (e.g. api/app/common); it is intended for any Symfony + PHP REST backend.

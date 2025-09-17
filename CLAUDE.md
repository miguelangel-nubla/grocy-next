# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Grocy is a web-based self-hosted groceries & household management solution built with PHP and Slim Framework 4. It uses SQLite as the database and follows a traditional MVC architecture pattern.

## Architecture

- **Backend**: PHP 8.2+ with Slim Framework 4
- **Database**: SQLite 3.34.0+ (stored in `data/grocy.db`)
- **Frontend**: jQuery, Bootstrap 4, various JS libraries (Chart.js, DataTables, etc.)
- **Dependency Management**: Composer for PHP, Yarn for JavaScript
- **Routing**: Defined in `routes.php` using Slim's routing system
- **Controllers**: Located in `controllers/` directory, namespaced as `Grocy\Controllers\`
- **Services**: Business logic in `services/` directory, namespaced as `Grocy\Services\`
- **Views**: Blade templates in `views/` directory
- **Database**: Schema migrations in `migrations/` directory
- **Configuration**: `config-dist.php` for defaults, `data/config.php` for user overrides

## Key Directories

- `controllers/` - MVC controllers handling HTTP requests
- `services/` - Business logic and database operations  
- `views/` - Blade template files
- `public/` - Web-accessible files (CSS, JS, images)
- `helpers/` - Utility functions and classes
- `middleware/` - Slim middleware components
- `migrations/` - Database schema migration files
- `data/` - SQLite database and user configuration
- `localization/` - Translation files for internationalization

## Development Commands

### Install Dependencies
```bash
composer install
yarn install
```

### Code Style & Quality
```bash
# Format PHP code using PHP-CS-Fixer
./packages/bin/php-cs-fixer fix --config=.php-cs-fixer.php

# The project uses PSR-2 coding standards with custom rules
# Configuration is in .php-cs-fixer.php
```

### Database
- Database migrations run automatically when visiting the root route (`/`)
- SQLite database is stored in `data/grocy.db`
- Schema changes go in `migrations/` directory

### Configuration
- Copy `config-dist.php` to `data/config.php` and modify as needed
- Default settings are in `config-dist.php`
- User settings override defaults in `data/config.php`

## Code Style Guidelines

- PHP code follows PSR-2 with custom formatting rules (see `.php-cs-fixer.php`)
- Use tabs for indentation (not spaces)
- Single quotes for strings where possible
- Array short syntax `[]` instead of `array()`
- Opening braces on new lines for control structures and functions

## Key Components

### Authentication
- Disabled in dev/demo/prerelease mode
- Can be completely disabled via `GROCY_DISABLE_AUTH` setting
- User management in `controllers/UsersController.php`

### API
- RESTful API available at `/api/` endpoints
- Swagger documentation served at `/api`
- API uses the same controllers as the web frontend

### Localization
- Default language is English (embedded in code)
- Translations managed via Transifex
- Gettext-based translation system
- Translation files in `localization/` directory

## Testing & Quality

- No formal test suite mentioned in documentation
- Use PHP-CS-Fixer for code style validation
- Database migrations are tested by running them on startup

## Branch Management

### Rebasing my-modifications Branch
The `my-modifications` branch should always be based on the latest upstream tag, not master. When a new Grocy release is available, simply rebase to the new tag:

```bash
# Fetch latest upstream changes and tags
git fetch upstream

# Find the latest upstream tag
LATEST_TAG=$(git tag -l --sort=-version:refname | head -1)

# Rebase your modifications onto the new tag
git rebase $LATEST_TAG

# Force push the rebased branch
git push origin my-modifications --force-with-lease
```

**Important**: The `my-modifications` branch contains custom Docker support and CI/CD workflows that will be preserved during rebase.

## Deployment Notes

- Web server document root should point to `public/` directory
- Ensure `data/` directory is writable
- For nginx, include `try_files $uri /index.php$is_args$query_string;`
- Default login: admin/admin (change immediately)
- Update script available at `update.sh` for Linux deployments
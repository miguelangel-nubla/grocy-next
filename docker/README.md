# Grocy Development Tools

This directory contains development-specific tools and configurations for working on Grocy.

## Files

### `compose.dev.yaml`
Development Docker Compose configuration with:
- Live code mounting for instant changes
- Different port (9285) to avoid conflicts
- Frontend packages preserved from container build

### `dev-clear-cache.sh`
Helper script to clear Grocy's route cache during development.

**Usage:**
```bash
cd dev-tools
chmod +x dev-clear-cache.sh
./dev-clear-cache.sh
```

**When to use:**
- After modifying `routes.php`
- When getting route mismatch errors
- When routes return wrong responses

## Development Workflow

1. **Start development environment:**
   ```bash
   cd dev-tools
   docker-compose -f compose.dev.yaml up -d
   ```

2. **Access Grocy:**
   - URL: http://localhost:9285
   - Development features work with live code changes

3. **Clear cache when needed:**
   ```bash
   ./dev-clear-cache.sh
   ```

4. **Stop development environment:**
   ```bash
   docker-compose -f compose.dev.yaml down
   ```

## Notes

- Development environment runs in 'dev' mode (auth disabled)
- Code changes reflect immediately (except route changes need cache clear)
- Frontend packages are preserved from container build
- Logs available via `docker-compose -f compose.dev.yaml logs`
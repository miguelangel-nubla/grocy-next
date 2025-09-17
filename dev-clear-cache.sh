#!/bin/bash

# Development helper script to clear Grocy route cache
# Use this when you modify routes.php during development

echo "🧹 Clearing Grocy route cache..."

if docker exec grocy-dev rm -rf /config/data/viewcache/* 2>/dev/null; then
    echo "✅ Route cache cleared successfully"
    echo "🔄 Routes will be reloaded on next request"
else
    echo "❌ Failed to clear cache (container might not be running)"
    echo "💡 Try: docker-compose -f compose.dev.yaml up -d"
fi
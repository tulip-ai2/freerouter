#!/bin/bash
set -e

# FreeRouter — Railway Deployment Init Script
# Railway injects PORT and RAILWAY_PUBLIC_DOMAIN automatically

echo "🚀 FreeRouter starting..."
echo "   PORT: ${PORT:-20128}"
echo "   RAILWAY_PUBLIC_DOMAIN: ${RAILWAY_PUBLIC_DOMAIN:-not set (localhost fallback)}"
echo "   HOSTNAME: ${HOSTNAME:-0.0.0.0}"

# Railway assigns PORT dynamically — validate it
if [ -z "$PORT" ]; then
    echo "⚠️  PORT not set, defaulting to 20128"
    export PORT=20128
fi

# Create data directory if not exists (volume mount point)
mkdir -p /var/lib/freerouter
chown -R bun:bun /var/lib/freerouter 2>/dev/null || {
    echo "   (non-root data dir setup skipped)"
}

# Generate random JWT_SECRET if not set (development fallback)
if [ -z "$JWT_SECRET" ] || [ "$JWT_SECRET" = "CHANGE_ME_GENERATE_STRONG_PASSWORD" ]; then
    echo "⚠️  WARNING: JWT_SECRET not set! Generating temporary one..."
    export JWT_SECRET=$(openssl rand -hex 32 2>/dev/null || cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
fi

echo "✅ Init complete. Starting server on port $PORT..."
exec bun server.js

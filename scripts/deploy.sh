#!/bin/bash

# DAV Project - Deployment Script
# Uso: bash scripts/deploy.sh

set -e  # Exit on error

echo "==================================="
echo "  DAV Project - Deployment"
echo "==================================="
echo ""

# Variables
PROJECT_DIR="/opt/dav-project"
FRONTEND_DIR="$PROJECT_DIR/frontend"
BACKEND_DIR="$PROJECT_DIR/backend"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funciones
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Verificar directorio
if [ ! -d "$PROJECT_DIR" ]; then
    log_error "Directorio del proyecto no existe: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"
log_info "Working directory: $(pwd)"

# 2. Git pull (si es repositorio)
if [ -d ".git" ]; then
    log_info "Pulling latest changes from git..."
    git pull origin main || log_warn "Git pull failed or not configured"
else
    log_warn "Not a git repository"
fi

# 3. Build Frontend
if [ -d "$FRONTEND_DIR" ]; then
    log_info "Building frontend..."
    cd "$FRONTEND_DIR"

    if [ -f "package.json" ]; then
        npm install
        npm run build
        log_info "Frontend build completed"
    else
        log_warn "package.json not found, skipping frontend build"
    fi
else
    log_warn "Frontend directory not found"
fi

# 4. Build Backend (opcional, depende del stack)
cd "$BACKEND_DIR"
log_info "Preparing backend..."

# Descomentar según tu stack:

# Node.js
# npm install
# npm run build

# Go
# go build -o dav-backend main.go

# Python (no build, solo deps)
# pip install -r requirements.txt

# 5. Restart backend service
if systemctl is-active --quiet dav-backend; then
    log_info "Restarting dav-backend service..."
    sudo systemctl restart dav-backend
    sleep 2

    if systemctl is-active --quiet dav-backend; then
        log_info "Backend service restarted successfully"
    else
        log_error "Backend service failed to start"
        sudo journalctl -u dav-backend -n 20 --no-pager
        exit 1
    fi
else
    log_warn "dav-backend service not running or not configured"
fi

# 6. Reload NGINX
log_info "Reloading NGINX..."
sudo nginx -t && sudo systemctl reload nginx
log_info "NGINX reloaded successfully"

# 7. Verificación
echo ""
log_info "Deployment completed!"
echo ""
echo "Verify deployment:"
echo "  Frontend: https://dav.div.software"
echo "  Backend:  https://dav.div.software/api/health"
echo ""
echo "Check logs:"
echo "  sudo journalctl -u dav-backend -f"
echo "  sudo tail -f /var/log/nginx/error.log"
echo ""

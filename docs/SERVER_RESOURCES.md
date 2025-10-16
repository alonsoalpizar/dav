# Inventario de Recursos del Servidor

Servidor: **vmi2796511** (Contabo)
Fecha: 2025-10-16

---

## 💻 Hardware y Sistema

```
CPU:              4 cores
RAM:              7.8GB (5.1GB disponible)
SWAP:             4GB (configurado)
Disco:            72GB total / 52GB libre (28% uso)
OS:               Linux 6.8.0-71-generic (Ubuntu)
Uptime:           39 días
```

---

## 🛠️ Software Instalado

### Lenguajes y Runtimes

| Software | Versión | Estado | Notas |
|----------|---------|--------|-------|
| **Go** | 1.23.0 | ✅ Instalado | Más nuevo que requerido (1.21+) |
| **Node.js** | v22.20.0 | ✅ Instalado | Más nuevo que requerido (18+) |
| **npm** | 10.9.3 | ✅ Instalado | |
| **Python** | (varias) | ✅ Instalado | Puerto 9999 en uso |

### Servicios de Infraestructura

| Servicio | Versión | Estado | Puerto |
|----------|---------|--------|--------|
| **PostgreSQL** | 18.0 | ✅ Running | 5432 |
| **NGINX** | 1.24.0 | ✅ Running | 80, 443 |
| **Git** | 2.43.0 | ✅ Instalado | - |
| **Docker** | - | ❌ No instalado | - |

### Servicios DIV Activos

| Servicio | Puerto | PID | Estado |
|----------|--------|-----|--------|
| div-backend | 30000 | 2190022 | ✅ Running |
| div-backend-motor | 50000 | 2105709 | ✅ Running |
| div-motor canales | 51001, 51058, 51500, 51698 | 2105709 | ✅ Running |
| div-frontend (dev) | 5173 | 775367 | ✅ Running |

---

## 🔌 Puertos en Uso

### Puertos del Sistema

| Puerto | Servicio | Uso |
|--------|----------|-----|
| 22 | SSH | Sistema |
| 53 | systemd-resolved | DNS local |
| 80 | NGINX | HTTP |
| 443 | NGINX | HTTPS |
| 631 | CUPS | Impresión |

### Puertos de Aplicaciones

| Puerto | Servicio | Descripción |
|--------|----------|-------------|
| 5173 | Vite | DIV Frontend (desarrollo) |
| 5432 | PostgreSQL | Base de datos |
| 9999 | Python | Servicio desconocido |
| 30000 | div-backend | DIV Backend API |
| 50000 | div-backend-motor | DIV Motor principal |
| 51001-51698 | backendmotor | Canales DIV Motor |

### Puertos Internos (localhost)

| Puerto | Servicio |
|--------|----------|
| 17149 | VSCode Server |
| 40073 | VSCode |
| 6274, 6277 | Node (MCP) |

---

## 🎯 Puertos Asignados para DAV

### Backend DAV

| Puerto | Uso | Disponibilidad |
|--------|-----|----------------|
| **8080** | DAV Backend API | ✅ **LIBRE** |
| 8081 | DAV WebSocket (futuro) | ✅ Libre |
| 8082 | DAV Admin (futuro) | ✅ Libre |

### Frontend DAV

| Puerto | Uso | Disponibilidad |
|--------|-----|----------------|
| 5174 | DAV Frontend Dev | ✅ Libre |

**Recomendación**: Usar puerto **8080** para DAV backend.

---

## 🗄️ Base de Datos PostgreSQL

### Configuración Actual

```
Host:     localhost
Port:     5432
Version:  PostgreSQL 18.0
Owner:    divuser
```

### Bases de Datos

| Database | Owner | Encoding | Uso |
|----------|-------|----------|-----|
| **divdb** | divuser | UTF8 | ⚠️ DIV System (NO TOCAR) |
| **dav** | postgres | UTF8 | ✅ DAV Project |
| postgres | postgres | UTF8 | Sistema |
| template0 | postgres | UTF8 | Template |
| template1 | postgres | UTF8 | Template |

### Usuarios

| User | Attributes | Database |
|------|------------|----------|
| **postgres** | Superuser, Create role, Create DB | Todas |
| **divuser** | Create DB | divdb |
| **dav_user** | - | dav |

### Base de Datos DAV

**✅ Ya creada**: Base de datos `dav` dedicada

```sql
-- Verificar
sudo -u postgres psql -l | grep dav

-- Conectar
psql -U dav_user -d dav -h localhost

-- Cambiar password de dav_user
sudo -u postgres psql << EOF
ALTER USER dav_user WITH PASSWORD 'tu_password_seguro_aqui';
EOF
```

**Importante**:
- DAV usa su propia base de datos: `dav`
- Schema: `public` (default)
- **NO tocar**: `divdb` (es del sistema DIV principal)

---

## 🌐 NGINX y Dominios

### Dominios Configurados

| Dominio | Backend | Puerto | SSL |
|---------|---------|--------|-----|
| dev.div.software | DIV | 30000 | ✅ Certbot |
| (pendiente) dav.div.software | DAV | 8080 | ⏳ Por configurar |

### Configuración SSL

- **Certbot**: Instalado y funcional
- **Renovación**: Automática vía systemd timer

---

## 📦 Dependencias a Instalar

### Backend DAV (Go)

**Todas las dependencias ya definidas en `go.mod`:**

```bash
cd /opt/dav-project/backend
go mod download
```

**Paquetes principales**:
- github.com/gin-gonic/gin v1.10.0
- gorm.io/gorm v1.25.7
- gorm.io/driver/postgres v1.5.7
- github.com/golang-jwt/jwt/v5 v5.2.0
- golang.org/x/crypto (bcrypt)
- go.uber.org/zap v1.27.0

### Frontend DAV (React)

**Todas las dependencias ya definidas en `package.json`:**

```bash
cd /opt/dav-project/frontend
npm install
```

**Paquetes principales**:
- react v18.2.0
- typescript v5.3.3
- vite v5.1.0
- tailwindcss v3.4.1
- zustand v4.5.0
- axios v1.6.7

---

## 🚀 Comandos de Setup

### 1. Base de Datos DAV

**✅ Ya creada** - Base de datos `dav` con usuario `dav_user`

**Solo cambiar password**:

```bash
sudo -u postgres psql << EOF
ALTER USER dav_user WITH PASSWORD 'Tu_Password_Seguro_Aqui_123!';
EOF
```

**Verificar conexión**:

```bash
psql -U dav_user -d dav -h localhost -c "\dt"
# Password: dav_temp_password_123 (cambiar después)
```

### 2. Configurar Variables de Entorno Backend

```bash
cd /opt/dav-project/backend
cp .env.example .env

# Generar JWT secret
JWT_SECRET=$(openssl rand -base64 32)

# Editar .env
nano .env
# Actualizar:
# - DB_NAME=dav (✅ ya está correcto)
# - DB_USER=dav_user (✅ ya está correcto)
# - DB_PASSWORD=tu_password_seguro
# - JWT_SECRET=$JWT_SECRET
```

### 3. Instalar Dependencias Backend

```bash
cd /opt/dav-project/backend
go mod download
go mod tidy
```

### 4. Instalar Dependencias Frontend

```bash
cd /opt/dav-project/frontend
npm install
```

### 5. Configurar Subdominio NGINX

Ver: `docs/SUBDOMAIN_SETUP.md`

```bash
# Crear config NGINX
sudo nano /etc/nginx/sites-available/dav.div.software

# Activar
sudo ln -s /etc/nginx/sites-available/dav.div.software /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Configurar SSL
sudo certbot --nginx -d dav.div.software
```

### 6. Crear Servicio Systemd

```bash
sudo nano /etc/systemd/system/dav-backend.service

# Contenido en backend/README.md

sudo systemctl daemon-reload
sudo systemctl enable dav-backend
```

---

## 📊 Monitoreo de Recursos

### Comandos Útiles

```bash
# CPU y memoria
htop

# Puertos en uso
netstat -tlnp | grep LISTEN

# Espacio en disco
df -h

# Servicios activos
systemctl list-units --type=service --state=running

# Logs de servicio
sudo journalctl -u dav-backend -f

# PostgreSQL
sudo -u postgres psql -d divdb -c "\dn"
sudo -u postgres psql -d divdb -c "SELECT schemaname, tablename FROM pg_tables WHERE schemaname = 'dav_schema';"
```

---

## ✅ Checklist de Preparación

- [x] Go instalado (v1.23.0)
- [x] Node.js instalado (v22.20.0)
- [x] PostgreSQL instalado (v18.0)
- [x] NGINX instalado (v1.24.0)
- [x] Puerto 8080 disponible
- [x] Base de datos `dav` creada
- [x] Usuario `dav_user` creado
- [ ] Variables .env configuradas
- [ ] Dependencias Go instaladas
- [ ] Dependencias npm instaladas
- [ ] Subdominio NGINX configurado
- [ ] SSL con Certbot configurado
- [ ] Servicio systemd creado

---

## 🔒 Seguridad

### Configuraciones Actuales

- ✅ SSH puerto 22 (cambiar a no estándar recomendado)
- ✅ Firewall UFW (verificar reglas)
- ✅ SSL con Let's Encrypt en NGINX
- ✅ PostgreSQL solo en localhost

### Recomendaciones

1. Cambiar puerto SSH (22 → 2222 o similar)
2. Configurar UFW si no está activo
3. Fail2ban para protección SSH
4. Rate limiting en NGINX para DAV API

---

## 📝 Notas

- Base de datos DIV usa `divdb`, no `div`
- Puerto 8080 confirmado libre para DAV
- Frontend dev puede usar 5174 (5173 usado por DIV)
- Todos los recursos de software ya están disponibles
- No se requiere instalar nada adicional excepto dependencias de proyecto

# DAV - Sistema de Autenticación y Control de Acceso

Sistema empresarial de autenticación segura y gestión de permisos con arquitectura escalable.

## Stack Tecnológico

### Backend
- **Runtime**: Go 1.21+
- **Framework**: Gin
- **ORM**: GORM
- **Base de datos**: PostgreSQL 15
- **Autenticación**: JWT (expiración 24h)
- **Hashing**: bcrypt (coste 12)
- **Logging**: Zap (structured logging)

### Frontend
- **Framework**: React 18
- **Lenguaje**: TypeScript 5+
- **Build**: Vite
- **Styling**: Tailwind CSS
- **Paleta de colores**:
  - Primario: `#DC2626` (rojo)
  - Secundario: `#991B1B` (rojo oscuro)
  - Fondo: `#FEE2E2` (rojo claro)

### Infraestructura
- **Servidor**: Puerto 8080 (backend)
- **Proxy**: NGINX (reverse proxy con SSL)
- **Dominio**: https://dav.div.software
- **Base de datos**: PostgreSQL (schema: `dav_schema`)

## Características Principales

### 1. Sistema de Autenticación Seguro
- Login con validación JWT
- Protección contra brute force (5 intentos en 15 minutos)
- Contraseñas hasheadas con bcrypt (coste 12)
- Cumplimiento OWASP Top 10
- Tiempo de respuesta < 2 segundos

### 2. Panel de Administración
- CRUD completo de usuarios
- Gestión visual de permisos
- Reset de contraseñas con verificación por email
- Auditoría de acciones administrativas

### 3. Matriz de Permisos Escalable
- **Estructura**: `usuario:recurso:acción`
  - Ejemplo: `admin:users:delete`
- **Roles predefinidos**:
  - SuperAdmin (acceso total)
  - Admin (gestión de usuarios y permisos)
  - Usuario (acceso limitado)
- Gestión dinámica de permisos vía API
- Middleware de autorización en endpoints

### 4. Auditoría y Seguridad
- Logs estructurados de todas las acciones
- Auditoría de cambios administrativos
- Validación contra OWASP Top 10
- Protección XSS, CSRF, SQL Injection

## Estructura del Proyecto

```
dav-project/
├── backend/                # API en Go
│   ├── cmd/
│   │   └── server/        # Entry point
│   ├── internal/
│   │   ├── api/           # Handlers HTTP
│   │   ├── auth/          # JWT y autenticación
│   │   ├── models/        # Modelos GORM
│   │   ├── middleware/    # Auth, logging, CORS
│   │   ├── services/      # Lógica de negocio
│   │   └── database/      # Configuración DB
│   ├── migrations/        # Migraciones SQL
│   ├── tests/             # Tests unitarios
│   ├── go.mod
│   └── go.sum
│
├── frontend/              # Aplicación React
│   ├── src/
│   │   ├── components/    # Componentes React
│   │   ├── pages/         # Páginas/Vistas
│   │   ├── services/      # API clients
│   │   ├── hooks/         # Custom hooks
│   │   ├── types/         # TypeScript types
│   │   └── utils/         # Utilidades
│   ├── public/            # Assets estáticos
│   ├── package.json
│   ├── tsconfig.json
│   └── tailwind.config.js
│
├── docs/                  # Documentación
│   ├── ARCHITECTURE.md    # Arquitectura del sistema
│   ├── API.md            # Especificación API
│   ├── SECURITY.md       # Seguridad y OWASP
│   ├── DATABASE.md       # Esquema de base de datos
│   └── ADMIN_MANUAL.md   # Manual de administrador
│
└── scripts/              # Scripts de utilidad
    ├── deploy.sh         # Deployment
    └── backup.sh         # Backup de base de datos
```

## Base de Datos

### Esquema
- **Schema**: `dav_schema`
- **Tablas**:
  - `users` - Usuarios del sistema
  - `roles` - Roles disponibles
  - `permissions` - Permisos disponibles
  - `user_roles` - Asignación usuario-rol
  - `role_permissions` - Asignación rol-permiso
  - `audit_logs` - Auditoría de acciones

### Índices
- `users.email` (único)
- `users.username` (único)
- `audit_logs.user_id`
- `audit_logs.created_at`

## Setup Rápido

### 1. Configurar Base de Datos

```bash
# Crear base de datos y schema
sudo -u postgres psql
CREATE SCHEMA dav_schema;
CREATE USER dav_user WITH PASSWORD 'password_seguro';
GRANT ALL PRIVILEGES ON SCHEMA dav_schema TO dav_user;
```

### 2. Backend (Go)

```bash
cd backend

# Configurar variables de entorno
cp .env.example .env
nano .env

# Instalar dependencias
go mod download

# Ejecutar migraciones
go run cmd/migrate/main.go

# Ejecutar en desarrollo
go run cmd/server/main.go
```

### 3. Frontend (React)

```bash
cd frontend

# Instalar dependencias
npm install

# Ejecutar en desarrollo
npm run dev

# Build para producción
npm run build
```

## URLs

- **Producción**: https://dav.div.software
- **API**: https://dav.div.software/api
- **API Health**: https://dav.div.software/api/health

## Criterios de Éxito

- [x] Estructura de proyecto completa
- [ ] Login funcional responde en < 2 segundos
- [ ] Panel admin permite CRUD completo de usuarios
- [ ] Matriz de permisos permite asignar/revocar dinámicamente
- [ ] Interfaz usa paleta roja especificada
- [ ] Sistema bloquea después de 5 intentos fallidos
- [ ] Contraseñas hasheadas con bcrypt (coste 12)
- [ ] JWT implementado correctamente
- [ ] 10 casos de prueba de autenticación pasan
- [ ] Cobertura de tests > 80%

## Desarrollo

### Estándares de Código

- **Go**: GoDoc para documentación, fmt para formato
- **TypeScript**: JSDoc para componentes, Prettier para formato
- **Tests**: Cobertura mínima 80%
- **Logging**: Estructurado con Zap (Go)
- **No datos mock**: Desarrollo con datos reales

### Comandos Útiles

```bash
# Backend
go test ./...                    # Ejecutar tests
go test -cover ./...            # Tests con cobertura
go run cmd/server/main.go       # Ejecutar servidor

# Frontend
npm test                        # Ejecutar tests
npm run lint                    # Linter
npm run build                   # Build producción

# Deployment
bash scripts/deploy.sh          # Deploy completo
bash scripts/backup.sh          # Backup de DB
```

## Integración con DIV

DAV puede integrarse con DIV Platform para:
- Orquestación de procesos externos
- Envío de emails de verificación vía DIV Motor
- Sincronización de datos con sistemas externos

**Endpoints DIV**:
- DIV Backend: https://dav.div.software/div/api
- DIV Motor: https://dav.div.software/div/motor

## Seguridad

### Implementaciones
- JWT con expiración de 24 horas
- Bcrypt con coste 12 para hashing
- Rate limiting: 5 intentos en 15 minutos
- Validación contra OWASP Top 10
- CORS configurado para producción
- Sanitización de inputs
- Prepared statements (SQL Injection)

### Auditoría
- Todas las acciones administrativas son auditadas
- Logs de autenticación (login, logout, intentos fallidos)
- Tracking de cambios en permisos
- Retención de logs: 90 días

## Documentación

- [Arquitectura del Sistema](docs/ARCHITECTURE.md)
- [Especificación API](docs/API.md)
- [Seguridad y OWASP](docs/SECURITY.md)
- [Esquema de Base de Datos](docs/DATABASE.md)
- [Manual de Administrador](docs/ADMIN_MANUAL.md)

## Contribución

Ver documento de baseline en `docs/BASELINEPROYECTO.MD` para contexto completo del proyecto.

## Licencia

Propietario - Uso interno únicamente

## Contacto

- **Proyecto**: DAV System
- **Dominio**: https://dav.div.software
- **Entorno Dev**: https://dev.div.software

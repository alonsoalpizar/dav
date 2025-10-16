# DAV API - Especificación de Endpoints

API RESTful para el sistema DAV de autenticación y control de acceso.

**Base URL**: `https://dav.div.software/api`
**Formato**: JSON
**Autenticación**: JWT Bearer Token

---

## Health Check

### GET /health

Health check del servidor.

**Auth**: No requerida

**Response**: `200 OK`
```json
{
  "status": "ok",
  "timestamp": "2025-01-16T14:30:00Z",
  "database": "connected",
  "uptime": 864000
}
```

---

## Autenticación

### POST /auth/login

Login de usuario.

**Auth**: No requerida

**Request Body**:
```json
{
  "email": "admin@dav.com",
  "password": "SecurePass123!"
}
```

**Response**: `200 OK`
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_at": "2025-01-17T14:30:00Z",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@dav.com",
    "active": true,
    "roles": [
      {
        "id": 1,
        "name": "SuperAdmin"
      }
    ]
  }
}
```

**Errors**:
- `400 Bad Request`: Datos inválidos
- `401 Unauthorized`: Credenciales incorrectas
- `429 Too Many Requests`: Demasiados intentos (rate limit)

---

### POST /auth/logout

Logout de usuario (invalida token).

**Auth**: Requerida

**Headers**:
```
Authorization: Bearer {token}
```

**Response**: `204 No Content`

---

### POST /auth/refresh

Refrescar token JWT.

**Auth**: Requerida

**Response**: `200 OK`
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_at": "2025-01-17T16:00:00Z"
}
```

---

### POST /auth/reset-password

Solicitar reset de contraseña.

**Auth**: No requerida

**Request Body**:
```json
{
  "email": "user@dav.com"
}
```

**Response**: `200 OK`
```json
{
  "message": "Email de recuperación enviado"
}
```

---

### POST /auth/reset-password-confirm

Confirmar reset de contraseña con token.

**Auth**: No requerida

**Request Body**:
```json
{
  "token": "reset_token_from_email",
  "new_password": "NewSecurePass123!"
}
```

**Response**: `200 OK`

---

## Usuarios

### GET /users

Listar usuarios (paginado).

**Auth**: Requerida
**Permiso**: `users:read`

**Query Params**:
- `page` (int): Página (default: 1)
- `limit` (int): Items por página (default: 20, max: 100)
- `sort` (string): Campo de ordenamiento (default: created_at)
- `order` (string): asc | desc (default: desc)
- `search` (string): Búsqueda en username/email
- `active` (bool): Filtrar por activos

**Response**: `200 OK`
```json
{
  "users": [
    {
      "id": 1,
      "username": "admin",
      "email": "admin@dav.com",
      "active": true,
      "roles": [
        {
          "id": 1,
          "name": "SuperAdmin"
        }
      ],
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-15T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 156,
    "pages": 8
  }
}
```

---

### GET /users/:id

Obtener usuario por ID.

**Auth**: Requerida
**Permiso**: `users:read`

**Response**: `200 OK`
```json
{
  "id": 1,
  "username": "admin",
  "email": "admin@dav.com",
  "active": true,
  "roles": [
    {
      "id": 1,
      "name": "SuperAdmin",
      "permissions": [
        {
          "id": 1,
          "resource": "users",
          "action": "create"
        }
      ]
    }
  ],
  "created_at": "2025-01-01T00:00:00Z",
  "updated_at": "2025-01-15T10:30:00Z",
  "last_login": "2025-01-16T14:00:00Z"
}
```

**Errors**:
- `404 Not Found`: Usuario no existe

---

### POST /users

Crear nuevo usuario.

**Auth**: Requerida
**Permiso**: `users:create`

**Request Body**:
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "active": true,
  "role_ids": [2]
}
```

**Response**: `201 Created`
```json
{
  "id": 45,
  "username": "johndoe",
  "email": "john@example.com",
  "active": true,
  "roles": [
    {
      "id": 2,
      "name": "Admin"
    }
  ],
  "created_at": "2025-01-16T14:45:00Z"
}
```

**Errors**:
- `400 Bad Request`: Datos inválidos
- `409 Conflict`: Email o username ya existe

---

### PUT /users/:id

Actualizar usuario.

**Auth**: Requerida
**Permiso**: `users:update`

**Request Body**:
```json
{
  "username": "johndoe_updated",
  "email": "john.new@example.com",
  "active": false
}
```

**Response**: `200 OK`
```json
{
  "id": 45,
  "username": "johndoe_updated",
  "email": "john.new@example.com",
  "active": false,
  "updated_at": "2025-01-16T15:00:00Z"
}
```

---

### DELETE /users/:id

Eliminar usuario (soft delete).

**Auth**: Requerida
**Permiso**: `users:delete`

**Response**: `204 No Content`

---

## Roles

### GET /roles

Listar roles.

**Auth**: Requerida
**Permiso**: `roles:read`

**Response**: `200 OK`
```json
{
  "roles": [
    {
      "id": 1,
      "name": "SuperAdmin",
      "description": "Acceso total al sistema",
      "users_count": 2,
      "permissions_count": 25,
      "created_at": "2025-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "name": "Admin",
      "description": "Gestión de usuarios y permisos",
      "users_count": 15,
      "permissions_count": 12,
      "created_at": "2025-01-01T00:00:00Z"
    },
    {
      "id": 3,
      "name": "User",
      "description": "Usuario estándar",
      "users_count": 120,
      "permissions_count": 5,
      "created_at": "2025-01-01T00:00:00Z"
    }
  ]
}
```

---

### GET /roles/:id

Obtener rol con permisos.

**Auth**: Requerida
**Permiso**: `roles:read`

**Response**: `200 OK`
```json
{
  "id": 2,
  "name": "Admin",
  "description": "Gestión de usuarios y permisos",
  "permissions": [
    {
      "id": 1,
      "resource": "users",
      "action": "create",
      "description": "Crear usuarios"
    },
    {
      "id": 2,
      "resource": "users",
      "action": "read",
      "description": "Ver usuarios"
    },
    {
      "id": 3,
      "resource": "users",
      "action": "update",
      "description": "Actualizar usuarios"
    }
  ],
  "users_count": 15,
  "created_at": "2025-01-01T00:00:00Z"
}
```

---

### POST /roles

Crear nuevo rol.

**Auth**: Requerida
**Permiso**: `roles:create`

**Request Body**:
```json
{
  "name": "Moderator",
  "description": "Rol de moderación",
  "permission_ids": [1, 2, 3]
}
```

**Response**: `201 Created`

---

### PUT /roles/:id

Actualizar rol.

**Auth**: Requerida
**Permiso**: `roles:update`

**Response**: `200 OK`

---

### DELETE /roles/:id

Eliminar rol.

**Auth**: Requerida
**Permiso**: `roles:delete`

**Response**: `204 No Content`

**Errors**:
- `400 Bad Request`: No se puede eliminar rol con usuarios asignados

---

## Permisos

### GET /permissions

Listar todos los permisos disponibles.

**Auth**: Requerida
**Permiso**: `permissions:read`

**Query Params**:
- `resource` (string): Filtrar por recurso (users, roles, permissions)

**Response**: `200 OK`
```json
{
  "permissions": [
    {
      "id": 1,
      "resource": "users",
      "action": "create",
      "description": "Crear usuarios",
      "format": "users:create"
    },
    {
      "id": 2,
      "resource": "users",
      "action": "read",
      "description": "Ver usuarios",
      "format": "users:read"
    },
    {
      "id": 3,
      "resource": "users",
      "action": "update",
      "description": "Actualizar usuarios",
      "format": "users:update"
    },
    {
      "id": 4,
      "resource": "users",
      "action": "delete",
      "description": "Eliminar usuarios",
      "format": "users:delete"
    }
  ]
}
```

---

## Gestión de Permisos de Usuario

### POST /users/:id/roles

Asignar rol a usuario.

**Auth**: Requerida
**Permiso**: `users:update`

**Request Body**:
```json
{
  "role_id": 2
}
```

**Response**: `200 OK`

---

### DELETE /users/:id/roles/:roleId

Revocar rol de usuario.

**Auth**: Requerida
**Permiso**: `users:update`

**Response**: `204 No Content`

---

## Gestión de Permisos de Rol

### POST /roles/:id/permissions

Asignar permiso a rol.

**Auth**: Requerida
**Permiso**: `roles:update`

**Request Body**:
```json
{
  "permission_id": 5
}
```

**Response**: `200 OK`

---

### DELETE /roles/:id/permissions/:permId

Revocar permiso de rol.

**Auth**: Requerida
**Permiso**: `roles:update`

**Response**: `204 No Content`

---

## Auditoría

### GET /audit-logs

Obtener logs de auditoría.

**Auth**: Requerida
**Permiso**: `audit:read`

**Query Params**:
- `page` (int): Página
- `limit` (int): Items por página
- `user_id` (int): Filtrar por usuario
- `action` (string): Filtrar por acción
- `resource` (string): Filtrar por recurso
- `date_from` (string): Fecha inicio (ISO 8601)
- `date_to` (string): Fecha fin (ISO 8601)

**Response**: `200 OK`
```json
{
  "logs": [
    {
      "id": 1234,
      "user_id": 1,
      "username": "admin",
      "action": "create_user",
      "resource": "users",
      "resource_id": 45,
      "details": {
        "username": "johndoe",
        "email": "john@example.com"
      },
      "ip_address": "192.168.1.100",
      "created_at": "2025-01-16T14:45:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 50,
    "total": 5678,
    "pages": 114
  }
}
```

---

### GET /audit-logs/user/:id

Obtener logs de un usuario específico.

**Auth**: Requerida
**Permiso**: `audit:read`

**Response**: `200 OK`

---

## Errores Comunes

### Estructura de Error

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Mensaje descriptivo del error",
    "details": {
      "field": "Detalle específico del campo"
    }
  }
}
```

### Códigos de Error

| Status | Code | Descripción |
|--------|------|-------------|
| 400 | `VALIDATION_ERROR` | Datos de entrada inválidos |
| 401 | `UNAUTHORIZED` | Token inválido o expirado |
| 403 | `FORBIDDEN` | Sin permisos para esta acción |
| 404 | `NOT_FOUND` | Recurso no encontrado |
| 409 | `CONFLICT` | Conflicto (ej: email duplicado) |
| 429 | `RATE_LIMIT_EXCEEDED` | Demasiadas solicitudes |
| 500 | `INTERNAL_ERROR` | Error del servidor |

---

## Autenticación JWT

### Headers

Todos los endpoints protegidos requieren:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### JWT Claims

```json
{
  "user_id": 1,
  "email": "admin@dav.com",
  "roles": ["SuperAdmin"],
  "exp": 1642420800,
  "iat": 1642334400
}
```

### Token Expiration

- **Duración**: 24 horas
- **Renovación**: Usar `/auth/refresh` antes de expiración
- **Invalidación**: Automática en `/auth/logout`

---

## Rate Limiting

**Límites**:
- Login: 5 intentos por 15 minutos
- API General: 100 requests por minuto por IP
- API SuperAdmin: 1000 requests por minuto

**Headers de Respuesta**:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642334400
```

---

## Paginación

**Request Query Params**:
```
?page=1&limit=20&sort=created_at&order=desc
```

**Response Structure**:
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 156,
    "pages": 8
  }
}
```

---

## Testing con cURL

### Login
```bash
TOKEN=$(curl -s -X POST https://dav.div.software/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@dav.com","password":"password"}' \
  | jq -r '.token')
```

### Listar Usuarios
```bash
curl -H "Authorization: Bearer $TOKEN" \
  https://dav.div.software/api/users
```

### Crear Usuario
```bash
curl -X POST https://dav.div.software/api/users \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"username":"newuser","email":"new@example.com","password":"Pass123!","role_ids":[3]}'
```

### Auditoría
```bash
curl -H "Authorization: Bearer $TOKEN" \
  "https://dav.div.software/api/audit-logs?page=1&limit=10"
```

---

## Integración con DIV Platform

DAV puede orquestar procesos externos vía DIV:

```bash
# Enviar email de bienvenida vía DIV Motor
curl -X POST https://dav.div.software/div/motor/ejecutar \
  -H "Content-Type: application/json" \
  -d '{
    "flujo": "enviar_email_bienvenida",
    "parametros": {
      "email": "user@example.com",
      "username": "newuser"
    }
  }'
```

---

## Versionado

**Versión actual**: v1

Futuras versiones usarán path `/api/v2/...`

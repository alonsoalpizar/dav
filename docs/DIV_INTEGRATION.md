# Integración con DIV

DAV puede consumir servicios de DIV Backend y DIV Motor.

## DIV Backend API (Puerto 30000)

**Base URL**: `http://localhost:30000` (interno)
**Público**: `https://dav.div.software/div/api`

### Endpoints útiles

```bash
# Health check
GET /health

# Listar procesos
GET /api/procesos

# Ejecutar proceso
POST /api/procesos/ejecutar
{
  "proceso_id": 123,
  "datos": { ... }
}

# Listar canales
GET /api/canales
```

## DIV Motor (Puerto 50000)

**Base URL**: `http://localhost:50000` (interno)
**Público**: `https://dav.div.software/div/motor`

### Endpoints útiles

```bash
# Health check
GET /health

# Ejecutar flujo asíncrono
POST /motor/ejecutar
{
  "flujo": "nombre_flujo",
  "parametros": { ... }
}

# Status de ejecución
GET /motor/status/:job_id
```

## Casos de Uso

### 1. Orquestar proceso externo desde DAV

```javascript
// En tu backend DAV
async function triggerExternalProcess(data) {
  const response = await fetch('http://localhost:30000/api/procesos/ejecutar', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      proceso_id: 456,
      datos: data
    })
  });

  return response.json();
}
```

### 2. Delegar tarea asíncrona al Motor

```javascript
async function sendEmailAsync(userId, template) {
  const response = await fetch('http://localhost:50000/motor/ejecutar', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      flujo: 'enviar_email',
      parametros: { userId, template }
    })
  });

  const { job_id } = await response.json();

  // Guardar job_id para tracking
  return job_id;
}
```

### 3. Consumir datos sincronizados por DIV

```javascript
// DIV Motor puede alimentar tu DB DAV con datos externos
// Configurar un flujo programado en DIV que:
// 1. Fetch datos de API externa
// 2. Transform
// 3. Insert en dav_schema.tabla
```

## Base de Datos Compartida

DIV y DAV usan la misma instancia PostgreSQL pero schemas separados:

- **DIV**: `public` schema
- **DAV**: `dav_schema` schema

```sql
-- Cross-schema query (si necesario)
SELECT d.name, dav.status
FROM public.procesos d
JOIN dav_schema.items dav ON dav.proceso_id = d.id;
```

## Seguridad

**Consideraciones**:
- Comunicación interna (localhost) no requiere auth adicional
- Si expones endpoints públicos, implementar API keys
- Rate limiting en NGINX si es necesario

```nginx
# Ejemplo: rate limit en NGINX
location /div/api/ {
    limit_req zone=api burst=10 nodelay;
    proxy_pass http://localhost:30000/;
}
```

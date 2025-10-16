# ROL
Arquitecto de seguridad especializado en sistemas de autenticación y control de acceso
agentes disponibles
	backend-motor-architect
	DIV-Validador de Codigo
	devops-sre-security
	react-flow-integration-expert
	ux-ui-design-system

# CONTEXTO
Proyecto nuevo que requiere implementación completa de sistema de seguridad desde cero 
para aplicación empresarial

# STACK TECNOLÓGICO
- **Backend**: Go (Gin framework)
- **Frontend**: React 18 + TypeScript
- **Styling**: Tailwind CSS con paleta roja (#DC2626 primario, #991B1B secundario, #FEE2E2 fondo)
- **Base de datos**: PostgreSQL 15 ---USAR EL MOTOR DE POSTGREE DEL SERVIDOR ACTUAL CON DB INDEPENDIENTE.
- **ORM**: GORM para Go

Actualmente no existe el sistema a nivel funcional y esta será la primera capa desarrollada.
Tiene que existir la posibilidad que todo esté disponible mientras se van agregando funcionalidades


# TAREAS PRINCIPALES

## 1. Sistema de Autenticación Seguro
- Implementar login con validación JWT (expiración 24 horas)
- Hashear contraseñas con bcrypt (coste 12)
- Protección contra brute force (máximo 5 intentos en 15 minutos)
- Validar contra OWASP Top 10 (especialmente A2: Broken Authentication)
- Tiempo de respuesta login < 2 segundos

## 2. Panel de Administración
- CRUD completo de usuarios (crear, leer, actualizar, desactivar)
- Gestión de permisos mediante interfaz visual
- Reset de contraseñas con email de verificación
- Auditoría de acciones administrativas

## 3. Matriz de Permisos Escalable
- Estructura: `usuario:recurso:acción` (ej: "admin:users:delete")
- Tablas: usuarios, roles, permisos, usuario_roles, rol_permisos
- API para gestión dinámica de permisos
- Endpoints protegidos por middleware de autorización

## 4. Requisitos de Base de Datos
- Esquema normalizado con índices en email y usuario_id
- Tablas: users, roles, permissions, user_roles, role_permissions, audit_logs
- Constraints de unicidad en email y username

## 5. Usuarios y permisos
- Todavia no hay tareas o procesos en el sistema pero se iran agregando despues de esta fase de seguridad.
		lo que significa que :
		* despues de esta etapa se tiene el esquema de seguridad al 100%
		* despues de esta etapa se iran agregando funcionalidades que estaran disponibles al 100%
		* a solicitud y gestion las funcionalidades se iran agregando a la matriz de seguridad.
		* deberian existir tres perfiles: SuperAdmin, Admin , usuarios finales .(eventualmente se podrian agregar mas perfiles)
		
# RESTRICCIONES TÉCNICAS
- No usar datos mock - desarrollo con datos reales
- Código documentado (GoDoc y JSDoc)
- Logging estructurado Zap para Go
- Tests unitarios cubriendo 80% del código
- No sobreingenieria

# CRITERIOS DE ÉXITO VERIFICABLES
- [ ] Login funcional responde en < 2 segundos
- [ ] Panel admin permite CRUD completo de usuarios
- [ ] Matriz de permisos permite asignar/revocar dinámicamente
- [ ] Interfaz usa paleta roja especificada
- [ ] Sistema bloquea después de 5 intentos fallidos
- [ ] Contraseñas hasheadas con bcrypt
- [ ] JWT implementado correctamente
- [ ] 10 casos de prueba de autenticación pasan

# ENTREGABLES
- Código fuente completo backend y frontend
- Diagrama de arquitectura del sistema
- Documentación SIMPLE técnica API
- Manual de usuario administrador - EXPLICACION BASICA
- Scripts de base de datos - PUEDE SER GENERAR BACKUP DIARIO

=== ESTRUCTURA DEL PLAN A GENERAR ===
- Estructurado en secciones claras y específicas
- Stack tecnológico completamente definido sin ambigüedades
- Paleta de colores especificada con códigos hexadecimales exactos
- Criterios de éxito convertidos en lista verificable con checkboxes
- Tiempos de respuesta cuantificados y medibles
- Estándares de seguridad específicos (OWASP Top 10, bcrypt cost 12)
- Estructura de permisos definida exactamente ("usuario:recurso:acción")
- Requisitos de base de datos específicos (tablas, índices, constraints)
- Herramientas concretas especificadas (Gin, GORM, Zap)
- Casos de prueba definidos como requisito
- Entregables claramente listados

=== SUGERENCIAS ===
- Agregar diagrama de secuencia para flujo de autenticación
- Especificar versiones exactas de dependencias en package.json y go.mod
- Incluir configuración de CORS para entorno de producción
- Definir políticas de retención para logs de auditoría
- Especificar mecanismo de recuperación ante caídas de base de datos
- Agregar requisitos de monitorización (métricas de rendimiento)
- Incluir checklist de seguridad pre-producción
- Especificar requisitos de backup automático de base de datos
- Agregar guía de escalabilidad horizontal del sistema
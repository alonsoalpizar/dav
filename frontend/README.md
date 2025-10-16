# DAV Frontend - React + TypeScript

Interfaz web del sistema DAV con React 18 y TypeScript.

## Stack Tecnológico

- **Framework**: React 18
- **Lenguaje**: TypeScript 5+
- **Build Tool**: Vite
- **Styling**: Tailwind CSS
- **State Management**: Zustand (ligero y simple)
- **HTTP Client**: Axios
- **Router**: React Router v6
- **Forms**: React Hook Form + Zod (validación)
- **UI Icons**: Lucide React
- **Testing**: Vitest + React Testing Library

## Paleta de Colores

```css
/* Primario (rojo) */
--primary: #DC2626;        /* bg-red-600 */
--primary-dark: #991B1B;   /* bg-red-800 */
--primary-light: #FEE2E2;  /* bg-red-50 */

/* Configurado en tailwind.config.js */
theme: {
  extend: {
    colors: {
      primary: {
        DEFAULT: '#DC2626',
        dark: '#991B1B',
        light: '#FEE2E2',
      }
    }
  }
}
```

## Estructura del Proyecto

```
frontend/
├── src/
│   ├── components/           # Componentes reutilizables
│   │   ├── common/          # Botones, inputs, modales
│   │   │   ├── Button.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── Modal.tsx
│   │   │   └── Loading.tsx
│   │   ├── layout/          # Layout components
│   │   │   ├── Header.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   └── Footer.tsx
│   │   └── forms/           # Form components
│   │       ├── LoginForm.tsx
│   │       └── UserForm.tsx
│   │
│   ├── pages/               # Páginas/Vistas
│   │   ├── Login.tsx
│   │   ├── Dashboard.tsx
│   │   ├── Users/
│   │   │   ├── UserList.tsx
│   │   │   ├── UserDetail.tsx
│   │   │   └── UserEdit.tsx
│   │   ├── Roles/
│   │   │   ├── RoleList.tsx
│   │   │   └── RoleEdit.tsx
│   │   └── Permissions/
│   │       └── PermissionMatrix.tsx
│   │
│   ├── services/            # API clients
│   │   ├── api.ts          # Axios instance
│   │   ├── auth.service.ts
│   │   ├── users.service.ts
│   │   ├── roles.service.ts
│   │   └── permissions.service.ts
│   │
│   ├── hooks/               # Custom hooks
│   │   ├── useAuth.ts
│   │   ├── useUsers.ts
│   │   └── usePermissions.ts
│   │
│   ├── store/               # Zustand stores
│   │   ├── authStore.ts
│   │   └── appStore.ts
│   │
│   ├── types/               # TypeScript types
│   │   ├── user.types.ts
│   │   ├── role.types.ts
│   │   └── api.types.ts
│   │
│   ├── utils/               # Utilidades
│   │   ├── validators.ts
│   │   ├── formatters.ts
│   │   └── constants.ts
│   │
│   ├── App.tsx             # Componente raíz
│   ├── main.tsx            # Entry point
│   └── index.css           # Tailwind imports
│
├── public/                  # Assets estáticos
│   ├── favicon.ico
│   └── logo.svg
│
├── .env.example            # Template de variables
├── index.html
├── package.json
├── tsconfig.json
├── tailwind.config.js
├── vite.config.ts
└── README.md
```

## Instalación y Setup

### 1. Instalar Node.js

```bash
# Verificar versión
node -v  # Debe ser v18+
npm -v   # v9+

# Si necesita instalar:
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 2. Instalar Dependencias

```bash
cd /opt/dav-project/frontend
npm install
```

### 3. Configurar Variables de Entorno

```bash
# Crear archivo .env.local
cat > .env.local << EOF
VITE_API_URL=https://dav.div.software/api
VITE_DIV_API_URL=https://dav.div.software/div/api
VITE_APP_NAME=DAV System
EOF
```

### 4. Ejecutar en Desarrollo

```bash
npm run dev
# Acceder a http://localhost:5173
```

## Scripts Disponibles

```bash
npm run dev          # Desarrollo con hot reload
npm run build        # Build de producción
npm run preview      # Preview del build
npm run lint         # ESLint
npm run type-check   # TypeScript type checking
npm run test         # Tests con Vitest
npm run test:ui      # Tests con UI
npm run format       # Prettier format
```

## Estructura de Componentes

### Button Component (Ejemplo)

```typescript
// src/components/common/Button.tsx
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger';
  loading?: boolean;
}

export function Button({
  variant = 'primary',
  loading,
  children,
  ...props
}: ButtonProps) {
  const baseClasses = 'px-4 py-2 rounded font-medium transition-colors';

  const variantClasses = {
    primary: 'bg-primary hover:bg-primary-dark text-white',
    secondary: 'bg-gray-200 hover:bg-gray-300 text-gray-800',
    danger: 'bg-red-600 hover:bg-red-700 text-white',
  };

  return (
    <button
      className={`${baseClasses} ${variantClasses[variant]}`}
      disabled={loading}
      {...props}
    >
      {loading ? 'Cargando...' : children}
    </button>
  );
}
```

## Routing

```typescript
// src/App.tsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ProtectedRoute } from './components/auth/ProtectedRoute';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />

        <Route element={<ProtectedRoute />}>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/users" element={<UserList />} />
          <Route path="/users/:id" element={<UserDetail />} />
          <Route path="/roles" element={<RoleList />} />
          <Route path="/permissions" element={<PermissionMatrix />} />
        </Route>

        <Route path="/" element={<Navigate to="/dashboard" />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}
```

## State Management con Zustand

```typescript
// src/store/authStore.ts
import create from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: number;
  email: string;
  username: string;
  roles: string[];
}

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  login: (user: User, token: string) => void;
  logout: () => void;
  hasPermission: (permission: string) => boolean;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      isAuthenticated: false,

      login: (user, token) => {
        set({ user, token, isAuthenticated: true });
      },

      logout: () => {
        set({ user: null, token: null, isAuthenticated: false });
      },

      hasPermission: (permission) => {
        const { user } = get();
        // Lógica de verificación de permisos
        return user?.roles.includes('SuperAdmin') || false;
      },
    }),
    {
      name: 'auth-storage',
    }
  )
);
```

## API Service

```typescript
// src/services/api.ts
import axios from 'axios';
import { useAuthStore } from '../store/authStore';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor para agregar token
api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Interceptor para manejar errores
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout();
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;
```

```typescript
// src/services/auth.service.ts
import api from './api';

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  user: {
    id: number;
    email: string;
    username: string;
    roles: string[];
  };
}

export const authService = {
  login: async (data: LoginRequest): Promise<LoginResponse> => {
    const response = await api.post('/auth/login', data);
    return response.data;
  },

  logout: async (): Promise<void> => {
    await api.post('/auth/logout');
  },

  getCurrentUser: async () => {
    const response = await api.get('/auth/me');
    return response.data;
  },
};
```

## Forms con React Hook Form + Zod

```typescript
// src/pages/Login.tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { authService } from '../services/auth.service';
import { useAuthStore } from '../store/authStore';

const loginSchema = z.object({
  email: z.string().email('Email inválido'),
  password: z.string().min(8, 'Mínimo 8 caracteres'),
});

type LoginFormData = z.infer<typeof loginSchema>;

export function Login() {
  const { login } = useAuthStore();
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  });

  const onSubmit = async (data: LoginFormData) => {
    try {
      const response = await authService.login(data);
      login(response.user, response.token);
      // Redirect to dashboard
    } catch (error) {
      console.error('Login failed:', error);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-primary-light">
      <form
        onSubmit={handleSubmit(onSubmit)}
        className="bg-white p-8 rounded-lg shadow-lg w-full max-w-md"
      >
        <h2 className="text-2xl font-bold text-primary mb-6">
          Iniciar Sesión
        </h2>

        <div className="mb-4">
          <label className="block text-gray-700 mb-2">Email</label>
          <input
            {...register('email')}
            type="email"
            className="w-full px-4 py-2 border rounded focus:border-primary"
          />
          {errors.email && (
            <p className="text-red-600 text-sm mt-1">{errors.email.message}</p>
          )}
        </div>

        <div className="mb-6">
          <label className="block text-gray-700 mb-2">Contraseña</label>
          <input
            {...register('password')}
            type="password"
            className="w-full px-4 py-2 border rounded focus:border-primary"
          />
          {errors.password && (
            <p className="text-red-600 text-sm mt-1">{errors.password.message}</p>
          )}
        </div>

        <button
          type="submit"
          disabled={isSubmitting}
          className="w-full bg-primary hover:bg-primary-dark text-white py-2 rounded font-medium transition-colors"
        >
          {isSubmitting ? 'Iniciando...' : 'Iniciar Sesión'}
        </button>
      </form>
    </div>
  );
}
```

## TypeScript Types

```typescript
// src/types/user.types.ts
export interface User {
  id: number;
  username: string;
  email: string;
  active: boolean;
  roles: Role[];
  created_at: string;
  updated_at: string;
}

export interface Role {
  id: number;
  name: string;
  description: string;
  permissions: Permission[];
}

export interface Permission {
  id: number;
  resource: string;
  action: string;
  description: string;
}

export interface CreateUserRequest {
  username: string;
  email: string;
  password: string;
  role_ids: number[];
}
```

## Testing

```typescript
// src/components/common/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { Button } from './Button';

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick handler', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledOnce();
  });

  it('shows loading state', () => {
    render(<Button loading>Submit</Button>);
    expect(screen.getByText('Cargando...')).toBeInTheDocument();
  });
});
```

```bash
# Ejecutar tests
npm test

# Con coverage
npm test -- --coverage

# Watch mode
npm test -- --watch
```

## Build para Producción

```bash
# Build
npm run build

# Output en /dist
# Copiado automáticamente a /opt/dav-project/frontend/dist por NGINX
```

## Tailwind CSS Configuration

```javascript
// tailwind.config.js
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#DC2626',
          dark: '#991B1B',
          light: '#FEE2E2',
        },
      },
    },
  },
  plugins: [],
}
```

## Vite Configuration

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
  },
});
```

## Deployment

```bash
# Build automático con script
bash /opt/dav-project/scripts/deploy.sh

# O manual
npm run build
sudo systemctl reload nginx
```

## Comandos Útiles

```bash
# Instalar nueva dependencia
npm install package-name

# Remover dependencia
npm uninstall package-name

# Limpiar cache
npm cache clean --force
rm -rf node_modules package-lock.json
npm install

# Analizar bundle size
npm run build -- --mode analyze
```

## Integración con DIV

```typescript
// Ejemplo: consumir DIV API
import axios from 'axios';

const divApi = axios.create({
  baseURL: import.meta.env.VITE_DIV_API_URL,
});

export const divService = {
  executeFlow: async (flowName: string, params: any) => {
    const response = await divApi.post('/motor/ejecutar', {
      flujo: flowName,
      parametros: params,
    });
    return response.data;
  },
};
```

## Troubleshooting

### Error: "Module not found"
- Ejecutar `npm install`
- Verificar imports y paths

### Error: "Port 5173 already in use"
```bash
# Encontrar proceso
lsof -i :5173
# Kill proceso
kill -9 <PID>
```

### Build falla
```bash
npm run type-check  # Verificar errores TypeScript
npm run lint        # Verificar errores ESLint
```

## Documentación Adicional

- [React Docs](https://react.dev)
- [TypeScript Docs](https://www.typescriptlang.org)
- [Tailwind CSS](https://tailwindcss.com)
- [Vite Docs](https://vitejs.dev)

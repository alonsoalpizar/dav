# Configuración Subdominio: dav.div.software

Ver documento completo de requerimientos técnicos.

## Quick Start

### 1. Configurar DNS
```
Tipo: A
Nombre: dav
Valor: [IP_SERVIDOR]
```

### 2. Crear configuración NGINX
```bash
sudo nano /etc/nginx/sites-available/dav.div.software
# Copiar configuración del documento de requerimientos
```

### 3. Activar sitio
```bash
sudo ln -s /etc/nginx/sites-available/dav.div.software /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Configurar SSL
```bash
sudo certbot --nginx -d dav.div.software
```

### 5. Verificar
```bash
curl -I https://dav.div.software
```

## URLs Finales

- **Web**: https://dav.div.software
- **API**: https://dav.div.software/api
- **DIV Bridge**: https://dav.div.software/div/api
- **DIV Motor**: https://dav.div.software/div/motor

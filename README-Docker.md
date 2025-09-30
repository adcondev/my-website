# Hugo Bootstrap Website - Docker Development Environment

Este proyecto utiliza Hugo con el tema Bootstrap y está configurado para desarrollo con Docker.

## Requisitos Previos

- Docker Desktop
- Docker Compose

## Desarrollo Local con Docker

### Opción 1: Usar Docker Compose (Recomendado)

```bash
# Construir y levantar el contenedor de desarrollo
docker-compose up --build

# O en segundo plano
docker-compose up -d --build

# Ver logs
docker-compose logs -f

# Detener el contenedor
docker-compose down
```

### Opción 2: Usar Docker directamente

```bash
# Construir la imagen
docker build -t my-website-hugo .

# Ejecutar el contenedor de desarrollo
docker run -p 1313:1313 -v ${PWD}:/src my-website-hugo

# En Windows PowerShell
docker run -p 1313:1313 -v ${PWD}:/src my-website-hugo

# En Windows CMD
docker run -p 1313:1313 -v %cd%:/src my-website-hugo
```

## Acceso al Sitio

Una vez que el contenedor esté ejecutándose, puedes acceder al sitio en:

- **URL Local**: http://localhost:1313
- **Hot Reload**: Los cambios se reflejan automáticamente

## Comandos Útiles

### Construir para Producción

```bash
# Usar el perfil de build
docker-compose --profile build run hugo-build

# O directamente con Docker
docker run -v ${PWD}:/src my-website-hugo hugo --minify
```

### Acceder al Contenedor

```bash
# Ejecutar comandos dentro del contenedor
docker-compose exec hugo sh

# O con Docker directamente
docker exec -it my-website-hugo sh
```

### Limpiar

```bash
# Detener y remover contenedores
docker-compose down

# Remover imagen
docker rmi my-website-hugo

# Limpiar todo Docker
docker system prune -a
```

## Estructura del Proyecto

```
.
├── Dockerfile              # Configuración del contenedor
├── docker-compose.yml      # Orquestación de servicios
├── .dockerignore           # Archivos excluidos del build
├── config/                 # Configuración de Hugo
├── content/                # Contenido del sitio
├── static/                 # Archivos estáticos
├── themes/                 # Temas (via Hugo modules)
└── public/                 # Sitio generado (ignorado en Git)
```

## Configuración

- **Hugo Version**: v0.150.1 Extended
- **Theme**: hugo-theme-bootstrap v1.13.2
- **Port**: 1313
- **Languages**: English (en), Chinese Simplified (zh-hans)

## Troubleshooting

### Puerto en uso

Si el puerto 1313 está en uso, cambia el puerto en docker-compose.yml:

```yaml
ports:
  - "3000:1313"  # Cambia 1313 por otro puerto
```

### Problemas de permisos

En Linux/Mac, puede ser necesario ajustar permisos:

```bash
sudo chown -R $USER:$USER .
```

### Reconstruir contenedor

Si hay cambios en Dockerfile o dependencias:

```bash
docker-compose up --build --force-recreate
```

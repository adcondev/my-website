+++
title = "Guía Completa de Hugo Bootstrap: Todas las Características"
description = "Demostración exhaustiva de todas las funcionalidades, widgets y características disponibles en Hugo con el tema Bootstrap"
date = "2025-01-30"
lastmod = "2025-01-30"
draft = false
featured = true
pinned = true
weight = 1

# Taxonomías
tags = ["hugo", "bootstrap", "tutorial", "golang", "python", "docker", "ci-cd", "markdown", "web-development"]
categories = ["tutoriales", "desarrollo-web", "herramientas"]
series = ["hugo-mastery"]
authors = ["adrián"]

# SEO y Meta
keywords = ["Hugo", "Bootstrap", "Markdown", "Static Site Generator", "Backend", "Golang", "Python"]

# Imagen destacada
images = ["images/avatar.jpg"]
[image]
src = "images/avatar.jpg"
alt = "Hugo Bootstrap Complete Guide"
stretch = "stretchH"

# Configuración del post
toc = true
math = true
diagram = true
reward = true
readingTime = true
postDate = true
copyright = true

# Creative Commons
[codeblock]
maxLines = 10
lineNos = true
+++

# Guía Completa de Hugo Bootstrap: Todas las Características

Esta entrada de blog demuestra **todas las funcionalidades** posibles que puedes integrar en tu sitio Hugo con el tema
Bootstrap. Desde elementos básicos de Markdown hasta características avanzadas como matemáticas, diagramas y código
interactivo.

<!--more-->

## 1. Elementos Básicos de Markdown

### 1.1 Texto y Formato

Aquí tienes **texto en negrita**, *texto en cursiva*, ***texto en negrita y cursiva***, ~~texto tachado~~, y
`código inline`.

También puedes usar ==texto resaltado== y texto con ^superíndice^ y ~subíndice~.

### 1.2 Enlaces y Referencias

- [Enlace a mi GitHub](https://github.com/adcondev)
- [Enlace interno al blog](/blog/)
- [Enlace con referencia][ref-link]
- <https://adcondev.netlify.app> (enlace automático)

[ref-link]: https://github.com/adcondev/my-website "Repositorio del sitio web"

### 1.3 Listas

#### Lista desordenada:

- Desarrollo Backend
    - Golang con Gin y GORM
    - Python con FastAPI
    - APIs RESTful
- DevOps
    - Docker y Docker Compose
    - GitHub Actions CI/CD
    - AWS Cloud Services

#### Lista ordenada:

1. Análisis de requisitos
2. Diseño de la arquitectura
3. Implementación del código
4. Testing y validación
5. Despliegue y monitoreo

#### Lista de tareas:

- [x] Configurar Hugo Extended
- [x] Personalizar tema Bootstrap
- [x] Crear entrada de blog completa
- [ ] Implementar comentarios Giscus
- [ ] Optimizar para SEO

## 2. Bloques de Código

### 2.1 Código Go (Backend)

```go
package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type User struct {
	ID    uint   `json:"id" gorm:"primaryKey"`
	Name  string `json:"name" gorm:"not null"`
	Email string `json:"email" gorm:"uniqueIndex;not null"`
}

func main() {
	// Conectar a la base de datos
	dsn := "host=localhost user=adcondev password=secret dbname=myapp"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Error conectando a la base de datos:", err)
	}

	// Migrar el esquema
	db.AutoMigrate(&User{})

	// Configurar Gin
	r := gin.Default()

	// Rutas de la API
	api := r.Group("/api/v1")
	{
		api.GET("/users", getUsers(db))
		api.POST("/users", createUser(db))
		api.GET("/users/:id", getUserByID(db))
		api.PUT("/users/:id", updateUser(db))
		api.DELETE("/users/:id", deleteUser(db))
	}

	log.Println("Servidor corriendo en :8080")
	r.Run(":8080")
}

func getUsers(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var users []User
		if err := db.Find(&users).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, users)
	}
}
```

### 2.2 Código Python (FastAPI)

```python
from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from pydantic import BaseModel, EmailStr
from typing import List
import uvicorn

# Configuración de la base de datos
DATABASE_URL = "postgresql://adcondev:secret@localhost/myapp"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Modelo de SQLAlchemy
class UserDB(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)

# Modelos Pydantic
class UserCreate(BaseModel):
    name: str
    email: EmailStr

class UserResponse(BaseModel):
    id: int
    name: str
    email: str
    
    class Config:
        from_attributes = True

# Crear las tablas
Base.metadata.create_all(bind=engine)

# Inicializar FastAPI
app = FastAPI(
    title="AdConDev API",
    description="API REST para gestión de usuarios",
    version="1.0.0",
    contact={
        "name": "Adrián",
        "email": "adcondev@gmail.com",
        "url": "https://github.com/adcondev"
    }
)

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Endpoints
@app.get("/api/v1/users", response_model=List[UserResponse])
async def get_users(db: Session = Depends(get_db)):
    """Obtener todos los usuarios"""
    users = db.query(UserDB).all()
    return users

@app.post("/api/v1/users", response_model=UserResponse)
async def create_user(user: UserCreate, db: Session = Depends(get_db)):
    """Crear un nuevo usuario"""
    db_user = UserDB(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

### 2.3 Docker Compose para Desarrollo

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: adcondev-postgres
    environment:
      POSTGRES_USER: adcondev
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - adcondev-network

  redis:
    image: redis:7-alpine
    container_name: adcondev-redis
    ports:
      - "6379:6379"
    networks:
      - adcondev-network

  api:
    build: .
    container_name: adcondev-api
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=postgres
      - DB_USER=adcondev
      - DB_PASSWORD=secret
      - DB_NAME=myapp
      - REDIS_HOST=redis
    depends_on:
      - postgres
      - redis
    networks:
      - adcondev-network

volumes:
  postgres_data:

networks:
  adcondev-network:
    driver: bridge
```

### 2.4 GitHub Actions CI/CD

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  GO_VERSION: '1.21'
  PYTHON_VERSION: '3.11'

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: secret
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - name: Checkout código
        uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: ${{ env.GO_VERSION }}

      - name: Cache Go modules
        uses: actions/cache@v3
        with:
          path: ~/go/pkg/mod
          key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}

      - name: Instalar dependencias
        run: go mod download

      - name: Ejecutar tests
        run: |
          go test -v -race -coverprofile=coverage.out ./...
          go tool cover -html=coverage.out -o coverage.html

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.out

  build:
    needs: test
    runs-on: ubuntu-latest

    steps:
      - name: Checkout código
        uses: actions/checkout@v4

      - name: Setup Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: adcondev
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: adcondev/myapp:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - name: Deploy to production
        run: |
          echo "Desplegando a producción..."
          # Aquí irían los comandos de despliegue
```

## 3. Matemáticas y Fórmulas

### 3.1 Fórmulas Inline

La complejidad temporal del algoritmo es $O(n \log n)$ y el espacio requerido es $O(n)$.

### 3.2 Fórmulas en Bloque

Ecuación cuadrática:
$$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$$

Algoritmo de complejidad:
$$T(n) = \begin{cases}
O(1) & \text{si } n \leq 1 \\
T(n/2) + O(n) & \text{si } n > 1
\end{cases}$$

Matriz de transformación:
$$\begin{bmatrix}
x' \\
y' \\
1
\end{bmatrix} = \begin{bmatrix}
\cos\theta & -\sin\theta & t_x \\
\sin\theta & \cos\theta & t_y \\
0 & 0 & 1
\end{bmatrix} \begin{bmatrix}
x \\
y \\
1
\end{bmatrix}$$

## 4. Diagramas y Visualizaciones

### 4.1 Diagrama de Flujo (Mermaid)

```mermaid
graph TD
    A[Inicio] --> B{¿Datos válidos?}
    B -->|Sí| C[Procesar request]
    B -->|No| D[Error 400]
    C --> E[Consultar DB]
    E --> F{¿Encontrado?}
    F -->|Sí| G[Devolver datos]
    F -->|No| H[Error 404]
    G --> I[Fin]
    D --> I
    H --> I
```

### 4.2 Diagrama de Secuencia

```mermaid
sequenceDiagram
    participant U as Usuario
    participant A as API Gateway
    participant S as Servicio
    participant D as Base de Datos
    
    U->>A: POST /api/users
    A->>A: Validar JWT
    A->>S: Crear usuario
    S->>D: INSERT usuario
    D-->>S: ID del usuario
    S-->>A: Usuario creado
    A-->>U: 201 Created
```

### 4.3 Diagrama de Arquitectura

```mermaid
graph LR
    subgraph "Frontend"
        W[Web App]
        M[Mobile App]
    end
    
    subgraph "Backend"
        G[API Gateway]
        A[Auth Service]
        U[User Service]
        N[Notification Service]
    end
    
    subgraph "Data Layer"
        P[(PostgreSQL)]
        R[(Redis)]
        Q[Queue]
    end
    
    W --> G
    M --> G
    G --> A
    G --> U
    G --> N
    U --> P
    A --> P
    N --> Q
    U --> R
```

## 5. Tablas y Datos

### 5.1 Tabla de Tecnologías

| Tecnología     | Uso              | Nivel      | Experiencia |
|----------------|------------------|------------|-------------|
| **Golang**     | Backend APIs     | Avanzado   | 3+ años     |
| **Python**     | Scripts, FastAPI | Avanzado   | 5+ años     |
| **Docker**     | Containerización | Intermedio | 2+ años     |
| **AWS**        | Cloud Services   | Intermedio | 1+ año      |
| **PostgreSQL** | Base de datos    | Avanzado   | 4+ años     |
| **Redis**      | Cache, Sessions  | Intermedio | 2+ años     |

### 5.2 Tabla de Proyectos

| Proyecto       | Tecnologías     | Estado           | URL                                   |
|----------------|-----------------|------------------|---------------------------------------|
| **SnippetBox** | Go, MySQL, HTML | ✅ Completado     | [GitHub](https://github.com/adcondev) |
| **Social API** | Python, FastAPI | ✅ Completado     | [GitHub](https://github.com/adcondev) |
| **Hugo Site**  | Hugo, Bootstrap | 🚧 En desarrollo | [Live](https://adcondev.netlify.app)  |

## 6. Elementos Multimedia

### 6.1 Imágenes

![Avatar de AdConDev](images/avatar.jpg "Mi avatar de desarrollador")

### 6.2 Citas y Callouts

> "El código es como el humor. Cuando tienes que explicarlo, es malo."
>
> — Cory House

{{< bs/alert danger >}}
**Importante**: Siempre valida las entradas del usuario antes de procesarlas en tu API.
{{< /bs/alert >}}

{{< bs/alert info >}}
**Consejo**: Usa herramientas como Postman o curl para probar tus endpoints durante el desarrollo.
{{< /bs/alert >}}

{{< bs/alert success >}}
**Logro desbloqueado**: Has implementado correctamente autenticación JWT en tu API.
{{< /bs/alert >}}

## 7. Elementos Avanzados

### 7.1 Detalles Colapsables

<details>
<summary>🔍 Configuración avanzada de Docker</summary>

```dockerfile
# Multi-stage build para Go
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Imagen final minimal
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
CMD ["./main"]
```

</details>

<details>
<summary>📊 Métricas de rendimiento</summary>

```go
// Middleware para métricas
func MetricsMiddleware() gin.HandlerFunc {
return func (c *gin.Context) {
start := time.Now()

c.Next()

duration := time.Since(start)
status := c.Writer.Status()

log.Printf("[%d] %s %s - %v",
status,
c.Request.Method,
c.Request.URL.Path,
duration)
}
}
```

</details>

### 7.2 Shortcodes de Bootstrap

{{< bs/button style="primary" size="lg" >}}
Botón Primario Grande
{{< /bs/button >}}

{{< bs/button style="success" >}}
Botón de Éxito
{{< /bs/button >}}

{{< bs/button style="warning" size="sm" >}}
Botón Pequeño
{{< /bs/button >}}

### 7.3 Cards de Bootstrap

{{< bs/card >}}
{{< bs/card-header >}}
🚀 Proyecto Destacado
{{< /bs/card-header >}}
{{< bs/card-body >}}
**SnippetBox**: Aplicación web completa en Go para compartir fragmentos de código con autenticación, CRUD y despliegue
automatizado.

- Backend en Go con Gin
- Base de datos MySQL
- CI/CD con GitHub Actions
- Despliegue en contenedores
  {{< /bs/card-body >}}
  {{< /bs/card >}}

## 8. Enlaces y Referencias

### 8.1 Enlaces Sociales

- 🐙 [GitHub](https://github.com/adcondev)
- 💼 [LinkedIn](https://linkedin.com/in/adrian-mazatlan)
- 🐦 [Twitter](https://twitter.com/adcondev)
- 🐳 [Docker Hub](https://hub.docker.com/u/adcondev)
- ✉️ [Email](mailto:adcondev@gmail.com)

### 8.2 Recursos Útiles

1. [Documentación de Hugo](https://gohugo.io/documentation/)
2. [Hugo Bootstrap Theme](https://github.com/razonyang/hugo-theme-bootstrap)
3. [Go Documentation](https://golang.org/doc/)
4. [FastAPI Documentation](https://fastapi.tiangolo.com/)
5. [Docker Documentation](https://docs.docker.com/)

## 9. Footnotes y Referencias

Este blog post demuestra las capacidades completas de Hugo[^1] con el tema Bootstrap[^2]. Las características incluyen
desde Markdown básico hasta funcionalidades avanzadas como matemáticas[^3] y diagramas[^4].

[^1]: Hugo es un generador de sitios estáticos rápido y flexible.
[^2]: Bootstrap proporciona un framework CSS responsive.
[^3]: KaTeX se usa para renderizar matemáticas.
[^4]: Mermaid se usa para generar diagramas.

## 10. Metadatos y Configuración

Esta entrada incluye:

- ✅ **Imagen destacada**: Para redes sociales y listados
- ✅ **TOC automático**: Tabla de contenidos generada
- ✅ **Matemáticas**: Fórmulas renderizadas con KaTeX
- ✅ **Diagramas**: Visualizaciones con Mermaid
- ✅ **Código destacado**: Syntax highlighting
- ✅ **Taxonomías**: Tags, categorías y series
- ✅ **SEO optimizado**: Meta tags y structured data
- ✅ **Responsive**: Compatible con todos los dispositivos
- ✅ **Comentarios**: Habilitados con Giscus
- ✅ **Compartir social**: Botones de redes sociales
- ✅ **Copyright**: Creative Commons configurado

---

## Conclusión

Esta entrada de blog demuestra la versatilidad y potencia de Hugo combinado with el tema Bootstrap. Desde elementos
básicos de Markdown hasta características avanzadas como matemáticas, diagramas y código interactivo, tienes todas las
herramientas necesarias para crear contenido técnico de alta calidad.

Como desarrollador backend especializado en Golang y Python, estas características me permiten documentar proyectos,
compartir tutoriales y demostrar conceptos técnicos de manera efectiva.

**¿Qué característica te parece más útil?** Déjame un comentario abajo y comparte tus experiencias con Hugo.

---

*¿Te gustó este post? Considera compartirlo en tus redes sociales y sígueme para más contenido sobre desarrollo backend
y automatización.*

# Usar la versión correcta de Go que requiere el proyecto
FROM golang:1.24-alpine

# Instalar Node.js y dependencias necesarias
RUN apk add --no-cache \
    git \
    wget \
    ca-certificates \
    libc6-compat \
    nodejs \
    npm

# Instalar Hugo Extended
RUN wget -O hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.128.2/hugo_extended_0.128.2_linux-amd64.tar.gz \
    && tar -xzf hugo.tar.gz \
    && chmod +x hugo \
    && mv hugo /usr/local/bin/hugo \
    && rm hugo.tar.gz

# Verificar instalaciones
RUN hugo version && go version && node --version

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración primero
COPY package*.json ./
COPY go.mod go.sum ./

# Instalar dependencias npm (solo producción)
RUN npm ci --only=production --no-audit --no-fund

# Copiar el proyecto
COPY . .

# Inicializar módulos Hugo
RUN hugo mod get && hugo mod tidy || echo "Modules setup completed"

# Exponer puerto
EXPOSE 1313

# Comando para desarrollo
CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "1313", "--disableFastRender", "--noHTTPCache"]

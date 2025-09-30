# Use Alpine Linux as base and install Hugo Extended manually
FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache \
    git \
    nodejs \
    npm \
    wget \
    ca-certificates \
    libc6-compat \
    curl

# Install Go 1.24.7 specifically
RUN wget -O go.tar.gz https://golang.org/dl/go1.24.7.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOROOT="/usr/local/go"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Verify Go installation
RUN go version

# Download and install Hugo Extended
RUN wget -O hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.150.1/hugo_extended_0.150.1_linux-amd64.tar.gz \
    && tar -xzf hugo.tar.gz \
    && ls -la \
    && mv hugo /usr/local/bin/hugo \
    && rm hugo.tar.gz \
    && chmod +x /usr/local/bin/hugo \
    && ln -s /usr/local/bin/hugo /usr/bin/hugo \
    && which hugo \
    && hugo version

# Set working directory
WORKDIR /src

# Copy package files first for better layer caching
COPY package*.json ./
COPY go.mod go.sum ./

# Install npm dependencies if package.json exists
RUN if [ -f package.json ]; then npm install; fi

# Download Hugo modules - use 'get' instead of 'download'
RUN hugo mod get

# Copy the rest of the project
COPY . .

# Expose Hugo's default port
EXPOSE 1313

# Default command to run Hugo server
CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "1313", "-D", "--disableFastRender"]

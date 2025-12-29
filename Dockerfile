FROM golang:1.23-alpine AS base

# Define o diretório de trabalho
WORKDIR /app

# Instala o Air para hot reload
RUN go install github.com/air-verse/air@v1.52.3

# Copia arquivos de dependências
COPY go.mod go.sum ./
RUN go mod download

# Copia o código fonte
COPY . .

# Expõe a porta
EXPOSE 8080

# Comando padrão
CMD ["air", "-c", ".air.toml"]
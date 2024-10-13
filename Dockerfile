# Usa una imagen oficial de Go como imagen base para construir la aplicación
FROM golang:1.20 AS builder

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Instala Git para clonar el repositorio
RUN apt-get update && apt-get install -y git

# Clona el repositorio desde GitHub usando HTTPS
RUN git clone https://github.com/a355149/dockerizando-app.git

# Cambia al directorio del proyecto
WORKDIR /app/dockerizando-app

# Descarga las dependencias del proyecto Go
RUN go mod tidy

# Compila la aplicación
RUN go build -o app

# Utiliza una imagen más ligera para ejecutar la aplicación
FROM debian:buster-slim

# Establece el directorio de trabajo en el contenedor final
WORKDIR /app

# Copia el binario de la fase de compilación
COPY --from=builder /app/dockerizando-app/app .

# Expone el puerto en el que correrá la aplicación (ajusta si es necesario)
EXPOSE 8080

# Ejecuta la aplicación
ENTRYPOINT ["./app"]
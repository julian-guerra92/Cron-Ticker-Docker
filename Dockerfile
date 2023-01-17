
# Método de creación de imagen mediate el uso de state

# Etapa 1: Dependencias de desarrollo
FROM node:19.2-alpine3.16 as dependencies

# cd app ---> nos movemos a este directorio
WORKDIR /app

# copìar ---> copia los archivos de mi proyecto al destino deseado (WORKDIR)
COPY package.json ./

# Instalar las dependencias
RUN npm install



# Etapa 2: Build y Test
FROM node:19.2-alpine3.16 as builder

# cd app ---> nos movemos a este directorio
WORKDIR /app

# copiar modulos de node del stage anterior
COPY --from=dependencies /app/node_modules ./node_modules

# copìar ---> copia todo el directorio
COPY . .

# Realizar testing
RUN npm run test



# Etapa 3: Dependencias de producción
FROM node:19.2-alpine3.16 as dependencies-prod

# cd app ---> nos movemos a este directorio
WORKDIR /app

# Copia del package.json
COPY package.json ./

# Únicamente las dependencias de prod
RUN npm install --prod



# Etapa 4: Ejecución de la app
FROM node:19.2-alpine3.16 as runner

# cd app ---> nos movemos a este directorio
WORKDIR /app

# copiar modulos de node del stage anterior
COPY --from=dependencies-prod /app/node_modules ./node_modules

# copiar archivos necesarios para la ejecución de la imagen
COPY app.js ./
COPY tasks/ ./tasks

# Comando run de la imagen
CMD [ "node", "app.js" ]
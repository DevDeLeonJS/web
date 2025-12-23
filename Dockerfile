# Etapa 1: build
FROM node:20-alpine AS build

WORKDIR /app

# Copiamos dependencias
COPY package*.json ./
RUN npm install

# Copiamos el resto del proyecto
COPY . .

# Construimos la app
RUN npm run build

# Etapa 2: servidor estático
FROM nginx:alpine

# Eliminamos la config por defecto
RUN rm /etc/nginx/conf.d/default.conf

# Copiamos una config mínima de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiamos el build de Vite
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

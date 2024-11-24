# Используем базовый образ
FROM node:20-alpine as builder

# Рабочая директория
WORKDIR /app

# Копируем package.json и устанавливаем зависимости
COPY package*.json ./
RUN npm install

# Копируем код приложения и собираем его
COPY . .

# Передаем ARG в процессе сборки
ARG BACKEND_HOST
ARG BACKEND_PORT

# Эти переменные будут доступны в React
ENV REACT_APP_BACKEND_HOST=$BACKEND_HOST
ENV REACT_APP_BACKEND_PORT=$BACKEND_PORT

RUN npm run build

# Продакшен-образ
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html

# Экспорт порта из .env
ENV PORT=$PORT_FRONTEND
EXPOSE $PORT
CMD ["nginx", "-g", "daemon off;"]

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

# Эти переменные будут доступны в React
ENV REACT_APP_BACKEND_HOST=$BACKEND_HOST

RUN npm run build

# Продакшен-образ
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Экспорт порта из .env
ENV PORT=$PORT_FRONTEND
EXPOSE $PORT
CMD ["nginx", "-g", "daemon off;"]

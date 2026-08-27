# ---------------------------------------------------------
# Stage 1: Build the React application
# ---------------------------------------------------------

FROM node:22-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

ARG VITE_API_BASE_URL=http://localhost:8000
ARG VITE_USE_MOCK_DATA=false

ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
ENV VITE_USE_MOCK_DATA=${VITE_USE_MOCK_DATA}

RUN npm run build


# ---------------------------------------------------------
# Stage 2: Serve the React build using Nginx
# ---------------------------------------------------------

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
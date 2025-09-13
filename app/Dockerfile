# Step 1: Build  App
FROM node:20-bullseye AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# Step 2: Serve with NGINX
FROM nginx:alpine
RUN apk update && apk upgrade && apk add --no-cache curl
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html
RUN echo "OK" > /usr/share/nginx/html/healthz
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
CMD curl --fail http://localhost/healthz || exit 1
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

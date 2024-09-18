FROM node:16-alpine as builder

WORKDIR /app
COPY . .
RUN npm install --include=dev && npm run build

FROM nginx:stable-alpine as deploy

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx","-g", "daemon off;"]

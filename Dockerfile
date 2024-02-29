FROM node:16-alpine as builder
WORKDIR /srv/
COPY . .
RUN npm install && npm run build
FROM node:16-alpine
WORKDIR /srv/
COPY --from=builder /srv /srv
CMD ["npm","start"]
EXPOSE 8080

FROM node:23 AS builder

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN npm ci
RUN npm run build


# CMD ["tail", "-f", "/dev/null"]

FROM nginx:1.27.2-alpine

COPY --from=builder /usr/src/app/dist /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

FROM node:23 as builder

WORKDIR /usr/src/app

COPY ./ /usr/src/app

ENV NODE_ENV=production

RUN npm ci
RUN npm run build


# CMD ["tail", "-f", "/dev/null"]

FROM nginx:1.27.2-alpine

COPY --from=builder /usr/src/app/dist /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

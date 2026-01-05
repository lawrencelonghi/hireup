FROM node:20-alpine AS tailwind
RUN apk add --no-cache bash
WORKDIR /tw

COPY package*.json ./

RUN npm i -D -g tailwindcss @tailwindcss/cli 

COPY . .
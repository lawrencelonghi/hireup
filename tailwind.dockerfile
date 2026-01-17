FROM node:20-alpine AS tailwind
RUN apk add --no-cache bash
WORKDIR /tw

RUN npm install -g tailwindcss @tailwindcss/cli


COPY . .

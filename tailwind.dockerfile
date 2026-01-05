FROM node:20-alpine AS tailwind
WORKDIR /tw

COPY package*.json ./

RUN npm i -D -g tailwindcss @tailwindcss/cli 

RUN npm install --no-audit --no-fund --silent

COPY . .
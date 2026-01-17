FROM node:20-alpine AS tailwind
RUN apk add --no-cache bash
WORKDIR /tw

COPY package*.json ./
RUN npm install

COPY . .

CMD ["npm", "run", "dev"]
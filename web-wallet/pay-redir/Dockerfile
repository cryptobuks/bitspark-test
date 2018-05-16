FROM node:9

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY ./server.js ./

WORKDIR /app

CMD [ "npm", "start" ]

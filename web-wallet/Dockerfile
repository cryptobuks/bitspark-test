FROM node:9

WORKDIR /app

COPY ./ui/package*.json ./ui/
RUN cd ui && npm install
COPY ./ui/ ./ui/
RUN cd ui && npm run build

COPY server/package*.json ./server/
RUN cd server && npm install
COPY ./server/ ./server/

ENV PORT 8080
EXPOSE 8080

WORKDIR /app/server

CMD [ "npm", "start" ]

FROM node:17.8.0-alpine3.14

WORKDIR /usr/src/app

COPY package.json .
RUN npm install

COPY app.js .
CMD [ "node", "app.js" ]
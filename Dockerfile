FROM node:14.13.1-alpine
RUN apk add --no-cache bash
RUN apk add --update curl
RUN apk add dos2unix --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh
WORKDIR /usr/src/app

# Install the good ol' NPM modules and get Adonis CLI in the game
COPY package.json .
RUN npm install
COPY . .
RUN npm run build
RUN cd build && npm ci --production
RUN cat .env
COPY .env ./build/.env

# Let all incoming connections use the port below
EXPOSE 3333
CMD node build/server.js

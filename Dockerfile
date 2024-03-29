FROM node:18-alpine as build

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm install
RUN npm audit fix

COPY . .

ENV NODE_ENV=production
# ENV VITE_CMS_HOST=${VITE_CMS_HOST}
RUN npm run build

FROM node:18-alpine

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm install --omit dev
RUN npm audit fix

COPY --from=build /usr/src/app/dist/*.js ./
# COPY --from=build /usr/src/app/node_modules ./node_modules

COPY data ./data
VOLUME /usr/src/app/data
RUN mkdir stats
VOLUME /usr/src/app/stats

# RUN echo '{"type": "module"}' > package.json

USER 1337:1337
ENV NODE_ENV=production
ENTRYPOINT [ "node", "/usr/src/app/app.js" ]
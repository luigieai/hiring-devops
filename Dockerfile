# BUILD APPLICATION STEP
FROM node:18.14.1-alpine3.17

RUN mkdir -p /app && chown -R node:node /app

WORKDIR /app

USER node

ENV NODE_ENV production

COPY --chown=node:node package.json .
COPY --chown=node:node package-lock.json .

RUN npm ci --only=production && npm cache clean --force

COPY --chown=node:node . .

EXPOSE 3000

ENTRYPOINT [ "npm", "run", "start" ] 
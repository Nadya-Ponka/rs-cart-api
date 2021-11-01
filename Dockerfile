FROM node:14.18.1-alpine as dev
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force
COPY . .
RUN npm run build

FROM node:14.18.1-alpine as prod
COPY --from=dev /app/package*.json ./
RUN npm install --only=prod
COPY --from=dev /app/dist ./dist
USER node
ENV PORT=8080
EXPOSE 8080
CMD ["node", "dist/main.js"]

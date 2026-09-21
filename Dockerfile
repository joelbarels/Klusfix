FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund
COPY index.html app.js style.css server.js sw.js icon.svg manifest.webmanifest ./
ENV NODE_ENV=production
USER node
EXPOSE 8080
CMD ["node","server.js"]

FROM node:24-alpine
WORKDIR /app
COPY index.html app.js style.css server.js icon.svg sw.js manifest.webmanifest ./
RUN mkdir -p /data && chown -R node:node /data /app
USER node
ENV NODE_ENV=production DB_PATH=/data/klusfix.sqlite PORT=8080
EXPOSE 8080
CMD ["node", "server.js"]

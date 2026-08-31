FROM node:24
WORKDIR /app
COPY app/server.js .
EXPOSE 8080
CMD ["node", "server.js"]
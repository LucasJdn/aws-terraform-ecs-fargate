const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(`Hello from ECS Fargate! Host: ${require('os').hostname()}\n`);
});

server.listen(8080, () => {
  console.log('Server running on port 8080');
});
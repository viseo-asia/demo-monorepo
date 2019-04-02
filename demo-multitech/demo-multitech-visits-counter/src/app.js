const express = require('express');
const NATS = require('nats');

const natsServers = ['nats://demo-multitech-nats-node:4222'];
const nc = NATS.connect({ servers: natsServers });

const app = express();
const port = 80;
let nbVisits = 0;

nc.on('error', err => {
  console.log(err);
});

nc.subscribe('demo-multitech.users.visits', msg => {
  console.log('Received a message: ' + msg);
  nbVisits++;
});

app.get('/', (req, res) => {
  res.send(`${nbVisits}`);
});

app.listen(port, () => console.log(`App istening on port ${port}!`));

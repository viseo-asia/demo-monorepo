const express = require('express');
const NATS = require('nats');

const natsServers = ['nats://demo-multitech-nats-node:4222'];
const nc = NATS.connect({ servers: natsServers });

const app = express();
const port = 80;

nc.on('error', err => {
  console.log(err);
});

app.get('/', (req, res) => {
  nc.publish('demo-multitech.users.visits', '{add_count: 1}');
  console.log('+1 visit');
  res.send('Visit logged');
});

app.listen(port, () => console.log(`App istening on port ${port}!`));

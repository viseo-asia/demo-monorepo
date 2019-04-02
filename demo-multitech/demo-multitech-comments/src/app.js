const express = require('express');
const bodyParser = require('body-parser');
const fse = require('fs-extra');
const mongodb = require('mongodb');

const app = express();
const port = 80;
let database;

const DB_FILE = '/opt/data/comments.json';

if (!fse.existsSync(DB_FILE)) {
  fse.ensureFileSync(DB_FILE);
  fse.writeJSON(DB_FILE, []);
}

const MongoClient = mongodb.MongoClient;
const url = 'mongodb://demo-multitech-mongodb-node-1:27017/comments';

MongoClient.connect(url, { useNewUrlParser: true }, (err, client) => {
  if (err) {
    console.log(err);
  } else {
    database = client.db('comments');
  }
});

app.use(bodyParser.json());

app.get('/', async (req, res) => {
  const collection = database.collection('comments');
  res.send({
    origin: process.env.HOSTNAME,
    items: await collection.find().toArray()
  });
});

app.put('/', async (req, res) => {
  const collection = database.collection('comments');
  await collection.insert({ text: req.body.text, date: new Date() });
  res.send();
});

app.listen(port, () => console.log(`App istening on port ${port}!`));

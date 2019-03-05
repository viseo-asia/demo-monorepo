const express = require("express");
const bodyParser = require("body-parser");
const fse = require("fs-extra");
const app = express();
const port = 80;

const DB_FILE = "/opt/data/comments.json";

if (!fse.existsSync(DB_FILE)) {
  fse.ensureFileSync(DB_FILE);
  fse.writeJSON(DB_FILE, []);
}

app.use(bodyParser.json());

app.get("/", async (req, res) => {
  const comments = await fse.readJSON(DB_FILE);
  res.send({
    origin: process.env.HOSTNAME,
    items: comments
  });
});

app.put("/", async (req, res) => {
  if (!req.body || !req.body.text) {
    res.send();
    return;
  }
  let comments = await fse.readJSON(DB_FILE);
  comments.unshift({ text: req.body.text, date: new Date() });
  comments = comments.splice(0, 5);
  await fse.writeJSON(DB_FILE, comments);
  res.send();
});

app.listen(port, () => console.log(`App istening on port ${port}!`));

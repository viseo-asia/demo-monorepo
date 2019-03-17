const express = require("express");
const app = express();
const port = 80;

app.get("/", (req, res) => {
  res.send(`nodejs @${process.env.HOSTNAME} (NodeJS v2)`);
});

app.listen(port, () => console.log(`App istening on port ${port}!`));
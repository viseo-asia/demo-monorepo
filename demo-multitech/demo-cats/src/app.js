const express = require("express");
const app = express();
const port = 80;

app.get("/", (req, res) => {
  res.send(`Cats @${process.env.HOSTNAME} (NodeJS)`);
});

app.listen(port, () => console.log(`App istening on port ${port}!`));

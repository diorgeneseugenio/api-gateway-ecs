require("dotenv").config();
var express = require("express");
var app = express();

app.get("/", function (req, res) {
  res.send(`Response from Service B`);
});

const port = process.env.PORT || 3000;

app.listen(port, function () {
  console.log(`🚀 (Service B) - Listening on port ${port}`);
});

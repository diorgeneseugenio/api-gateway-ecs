require("dotenv").config();
var express = require("express");
var app = express();

app.get("/", function (req, res) {
  res.send(`Response from ${process.env.npm_package_name}`);
});

const port = process.env.PORT || 3000;

app.listen(port, function () {
  console.log(
    `🚀 (${process.env.npm_package_name}) - Listening on port ${port}`
  );
});

const express = require("express");
const mongoose = require("mongoose");
require("dotenv").config(); //to create private variables
const port = process.env.PORT || 5000;
const app = express();

const uri = process.env.ATLAS_URI; //uri is supposed to be got from mongo atlas
mongoose.connect(uri, {
  useNewUrlParser: true,
  useCreateIndex: true,
  useUnifiedTopology: true,
});

const connection = mongoose.connection;
connection.once("open", () => {
  console.log("MongoDb connected");
});

app.route("/").get((req, res) => res.json("your first rest api"));

app.listen(port, () => console.log(`listening at port ${port}`));

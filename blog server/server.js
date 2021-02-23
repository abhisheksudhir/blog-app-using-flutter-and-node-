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
  useFindAndModify: false
});

const connection = mongoose.connection;
connection.once("open", () => {
  console.log("MongoDb connected");
});

app.use("/uploads", express.static("uploads")); //to make this folder accessible to browser

app.use(express.json());    //to parse json

const userRoute = require("./routes/user");
const profileRoute = require("./routes/profile");

app.use("/user", userRoute);
app.use("/profile", profileRoute);

app.route("/").get((req, res) => res.json("your first rest api"));

app.listen(port, () => console.log(`listening at port ${port}`));

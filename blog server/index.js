const express = require("express");
const port = process.env.PORT || 5000;
const app = express();

app.route("/").get((req, res) => res.json("your first rest api"));

app.listen(port, () => console.log(`listening at port ${port}`));

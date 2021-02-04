const express = require("express");
const User = require("../models/user.model");

const router = express.Router();

// router.post("/register", (req, res) => {
//   const { username, password, email } = req.body;
//   User.findOne({ username: username, email: email }).then((user) => {
//     if (user) {
//       return res.status(400).json({ msg: "User already exists" });
//     }
//     const newuser = new User({
//       username: username,
//       password: password,
//       email: email,
//     });
//     newuser
//       .save()
//       .then((_) => {
//         const { password, ...profile } = _.toJSON();
//         res.status(200).json({ msg: profile });
//       })
//       .catch((err) => {
//         res.status(403).json({ msg: err });
//       });
//   });
// });

router.post("/register", async (req, res, next) => {
  try {
    const userexist = await User.findOne({
      email: req.body.email,
    });
    if (userexist !== null) {
      throw new Error("Email already taken");
    }
    const user = await User.create(req.body);
    const { id, username, email } = user;
    res.status(201).json({ id, username, email });
  } catch (err) {
    if (err.message != "Email already taken") {
      err.message = "Username already taken";
    }
    res.status(403).json({ msg: err.message });
    next(err);
  }
});

router.patch("/update/:username", async (req, res, next) => {
  try {
    const userexist = await User.findOne({ username: req.params.username });
    if (userexist === null) {
      throw new Error("user does not exist");
    }
    const user = await User.findOneAndUpdate(
      { username: req.params.username },
      { $set: { password: req.body.password } }
    );
    const msg = {
      msg: "password successfully updated",
      id: user._id,
      username: user.username,
      email: user.email,
    };
    res.status(200).json({ msg });
  } catch (err) {
    res.status(403).json({ msg: err.message });
    next(err);
  }
});

router.delete("/delete/:username", async (req, res, next) => {
  try {
    const userexist = await User.findOne({ username: req.params.username });
    if (userexist === null) {
      throw new Error("user does not exist");
    }
    const user = await User.findOneAndDelete({ username: req.params.username });
    const msg = {
      msg: "user successfully deleted",
      id: user._id,
      username: user.username,
      email: user.email,
    };
    res.status(200).json({ msg });
  } catch (err) {
    res.status(403).json({ msg: err.message });
    next(err);
  }
});

module.exports = router;

const express = require("express");
const User = require("../models/user.model");
const jwt = require("jsonwebtoken");
const middleware = require("../middlewares/auth");
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

router.get("/:username", middleware.checkToken, async (req, res, next) => {
  try {
    const user = await User.findOne({ username: req.params.username });

    if (!user) {
      throw new Error("No such user found");
    }

    const { password, ...profile } = user.toJSON();

    res.status(200).json({ data: profile, username: req.params.username });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.get("/checkusername/:username", async (req, res, next) => {
  try {
    const user = await User.findOne({ username: req.params.username });
    if (user !== null) {
      return res.json({
        Status: true,
      });
    } else
      return res.json({
        Status: false,
      });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.post("/login", async (req, res, next) => {
  try {
    const user = await User.findOne({ username: req.body.username });

    if (user === null) {
      throw new Error("user does not exist");
    }

    const { id, username } = user;
    const valid = await user.comparePassword(req.body.password); //comparing if passwords match. returns true if they match

    if (valid) {
      const token = jwt.sign({ id, username }, process.env.SECRET);
      res.status(200).json({ token: token, msg: "success" });
    } else {
      throw new Error("Invalid password");
    }
  } catch (err) {
    let num = 500;
    if (err.message != "user does not exist") {
      num = 403;
    }
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

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

router.patch(
  "/update/:username",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      const userexist = await User.findOne({ username: req.params.username });
      if (userexist === null) {
        throw new Error("user does not exist");
      }
      if (userexist._id.toString() !== req.user.id) {
        throw new Error("Not authorised to update username");
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
  }
);

router.delete(
  "/delete/:username",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      const userexist = await User.findOne({ username: req.params.username });
      if (userexist === null) {
        throw new Error("user does not exist");
      }
      if (userexist._id.toString() !== req.user.id) {
        throw new Error("Not authorised to delete user");
      }
      const user = await User.findOneAndDelete({
        username: req.params.username,
      });
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
  }
);

// router.use(function (err, req, res, next) {
//   res.status(500).json(err.message);
// });

module.exports = router;

const express = require("express");
const router = express.Router();
const Profile = require("../models/profile.model");
const middleware = require("../middlewares/auth");

router.post("/add", middleware.checkToken, async (req, res, next) => {
  try {
    const profileexist = await Profile.findOne({
      username: req.body.username,
    });
    if (profileexist !== null) {
      throw new Error("Username already taken");
    }
    const profile = await Profile.create({
      username: req.user.username,
      name: req.body.name,
      profession: req.body.profession,
      DOB: req.body.DOB,
      titleline: req.body.titleline,
      about: req.body.about,
    });
    // const { id, username, email } = user;
    res
      .status(201)
      .json({ msg: "Sucessfully created profile", data: profile.toJSON() });
  } catch (err) {
    res.status(400).json({ msg: err.message });
    next(err);
  }
});

module.exports = router;

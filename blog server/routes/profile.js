const express = require("express");
const router = express.Router();
const multer = require("multer");
const Profile = require("../models/profile.model");
const middleware = require("../middlewares/auth");
const path = require("path");

const storage = multer.diskStorage({
  destination: (req, file, callback) => {
    callback(null, "./uploads");
  },
  filename: (req, file, callback) => {
    callback(null, req.user.username + ".jpg");
  },
});

const fileFilter = (req, file, callback) => {
  if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
    callback(null, true);
  } else {
    callback(null, false);
  }
};

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 6, //1024kb*1024kb = 1mb; 1mb * 6 = 6mb
  },
  // fileFilter: fileFilter, // removing filter as the type we get from frontend isn't jpeg or png
});

router.get("/checkProfile", middleware.checkToken, async (req, res, next) => {
  try {
    const profile = await Profile.findOne({ username: req.user.username });
    if (profile !== null) {
      return res.json({
        Status: true,
        username: req.user.username,
      });
    } else
      return res.json({
        Status: false,
        username: req.user.username,
      });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.post("/add", middleware.checkToken, async (req, res, next) => {
  try {
    const profileexist = await Profile.findOne({
      username: req.user.username,
    });
    if (profileexist !== null) {
      throw new Error("User already has created the profile");
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

router.patch(
  "/add/image",
  middleware.checkToken,
  upload.single("img"), // image is used as key in form body
  async (req, res, next) => {
    try {
      const profile_exist = await Profile.findOne({
        username: req.user.username,
      });
      if (profile_exist === null) {
        throw new Error("Profile does not exist");
      }
      const profile = await Profile.findOneAndUpdate(
        { username: req.user.username },
        { $set: { img: req.file.path } },
        { new: true }
      );
      const msg = {
        msg: "image updated successfully",
        data: profile.toJSON(),
      };
      res.status(200).json({ msg });
    } catch (err) {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
);

module.exports = router;

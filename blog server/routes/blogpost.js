const express = require("express");
const middleware = require("../middlewares/auth");
const router = express.Router();
const BlogPost = require("../models/blogpost.model");
const User = require("../models/user.model");

router.post("/createBlog", middleware.checkToken, async (req, res, next) => {
  try {
    const userexist = await User.findById(req.user.id);
    if (userexist === null) {
      throw new Error("User doesn't exist");
    }
    const blogPost = await BlogPost.create({
      user: userexist,
      title: req.body.title,
      body: req.body.body,
    });
    userexist.blogs.push(blogPost._id);
    await userexist.save();
    const { password, blogs, ...user } = userexist.toJSON();
    blogPost.user = user;
    res.status(201).json({ blog: blogPost });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

module.exports = router;

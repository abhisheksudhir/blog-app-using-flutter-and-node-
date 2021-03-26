const express = require("express");
const middleware = require("../middlewares/auth");
const router = express.Router();

const cloud = require("../cloudinaryconfig");
const file = require("../fileupload");

const BlogPost = require("../models/blogpost.model");
const User = require("../models/user.model");

router.get("/getUserBlogs", middleware.checkToken, async (req, res, next) => {
  try {
    // const user = await User.findById(req.user.id, {
    //   fields: { blogs: 1 },
    // }).populate("blogs");
    const blogs = await BlogPost.find({
      user: req.user.id,
    });
    res.status(200).json({ data: blogs });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.get("/getOtherBlogs", middleware.checkToken, async (req, res, next) => {
  try {
    const blogs = await BlogPost.find({
      user: { $ne: req.user.id },
    });
    res.status(200).json({ data: blogs });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.get("/getAllBlogs", async (req, res, next) => {
  try {
    const blogs = await BlogPost.find({});
    res.status(200).json({ data: blogs });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

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

router.patch(
  "/add/coverImage/:id",
  middleware.checkToken,
  file.multerUpload.single("img"), // image is used as key in form body
  async (req, res, next) => {
    try {
      if (req.file) {
        const blog_exist = await BlogPost.findOne({
          _id: req.params.id,
        });
        if (blog_exist === null) {
          throw new Error("Blog does not exist");
        }
        const old_public_id = blog_exist.coverImage.public_id;
        const image = file.dataUri(req).content;
        const result = await cloud.uploader.upload(image, {
          folder: "blog_app/blogs",
          // use_filename: true,
          unique_filename: true,
        });
        if (old_public_id != "") {
          console.log("deleting image");
          const del = await cloud.uploader.destroy(old_public_id);
        }
        const blog = await BlogPost.findOneAndUpdate(
          { _id: req.params.id },
          {
            $set: {
              "coverImage.url": result.url,
              "coverImage.public_id": result.public_id,
            },
          },
          { new: true }
        );
        const msg = {
          msg: "image updated successfully",
          data: blog.toJSON(),
        };
        res.status(200).json({ msg });
      } else {
        throw new Error("File not added");
      }
    } catch (err) {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
);

router.delete("/delete/:id", middleware.checkToken, async (req, res, next) => {
  try {
    const blogexist = await BlogPost.findOne({ _id: req.params.id });
    if (blogexist === null) {
      throw new Error("Blog does not exist");
    }
    const old_public_id = blogexist.coverImage.public_id;
    if (blogexist.user.toString() !== req.user.id) {
      throw new Error("Not authorised to delete blog");
    }
    const blog = await BlogPost.findOneAndDelete({
      username: req.params.username,
    });
    if (old_public_id != "") {
      console.log("deleting image");
      const del = await cloud.uploader.destroy(old_public_id);
    }
    await User.updateOne(
      { _id: req.user.id },
      { $pull: { blogs: req.params.id } }
    );
    // await campSchema.Partner.update(
    //   { products: req.body.productId },
    //   { $pull: { products: req.body.productId } }
    // );
    const msg = {
      msg: "Blog successfully deleted",
      id: blog._id,
      title: blog.title,
      body: blog.body,
    };
    res.status(200).json({ msg });
  } catch (err) {
    res.status(403).json({ msg: err.message });
    next(err);
  }
});

module.exports = router;

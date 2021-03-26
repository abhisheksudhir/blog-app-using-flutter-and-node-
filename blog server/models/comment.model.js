const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const Comment = new Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  blog: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Blog",
  },
  content: { type: String, required: true },
  created: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Comment", Comment);

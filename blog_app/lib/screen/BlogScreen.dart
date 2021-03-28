import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  static const routeName = '/blog-screen';

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Blog title",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text("blog details"),
      ),
    );
  }
}

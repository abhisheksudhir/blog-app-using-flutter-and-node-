import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          null;
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    null;
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.white,
                  onPressed: () {
                    null;
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text("Welcome to Blog App"),
        ),
      ),
    );
  }
}

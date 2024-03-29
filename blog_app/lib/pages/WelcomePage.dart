import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import 'package:blog_app/pages/SignUpPage.dart';
import 'package:blog_app/pages/SignInPage.dart';

class WelcomePage extends StatefulWidget {
  static const routeName = '/welcome-page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  Animation<Offset> animation1;
  AnimationController _controller2;
  Animation<Offset> animation2;
  bool _isLogin = false;
  Map data;
  final facebookLogin = FacebookLogin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //animation 1
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0), //(x1,y1)
      end: Offset(0.0, 0.0), //(x2,y2)
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    );

    //animation 2
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0), //(x1,y1)
      end: Offset(0.0, 0.0), //(x2,y2)
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    );

    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // alignment: Alignment.center,
          height: double.infinity,
          // width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green[200]],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              children: [
                SlideTransition(
                  position: animation1,
                  child: Text(
                    "Blogosphere",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                SlideTransition(
                  position: animation2,
                  child: Text(
                    "Intriguing blogs for great people",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 38,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                boxContainer("assets/google.png", "Sign Up with Google", null),
                SizedBox(
                  height: 20,
                ),
                boxContainer(
                    "assets/facebook1.png", "Sign Up with Facebook", onFBLogin),
                SizedBox(
                  height: 20,
                ),
                boxContainer(
                    "assets/email2.png", "Sign Up with Email", onEmailClick),
                SizedBox(
                  height: 20,
                ),
                SlideTransition(
                  position: animation2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(SignInPage.routeName);
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onFBLogin() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken;
        final response = await http.get(
            "https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token");
        final data1 = json.decode(response.body);
        print(data);
        setState(() {
          _isLogin = true;
          data = data1;
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          _isLogin = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          _isLogin = false;
        });
        break;
    }
  }

  onEmailClick() {
    Navigator.of(context).pushNamed(SignUpPage.routeName);
  }

  Widget boxContainer(String path, String text, onClick) {
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * (0.8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  Image.asset(
                    path,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

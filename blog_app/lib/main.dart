import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blog_app/pages/WelcomePage.dart';
import 'package:blog_app/pages/SignUpPage.dart';
import 'package:blog_app/pages/SignInPage.dart';
import 'package:blog_app/pages/HomePage.dart';
import 'package:blog_app/screen/HomeScreen.dart';
import 'package:blog_app/profile/ProfileScreen.dart';
import 'package:blog_app/profile/CreateProfile.dart';
import 'package:blog_app/profile/MainProfile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      setState(() {
        page = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: page,
        routes: {
          SignUpPage.routeName: (ctx) => SignUpPage(),
          SignInPage.routeName: (ctx) => SignInPage(),
          HomePage.routeName: (ctx) => HomePage(),
          WelcomePage.routeName: (ctx) => WelcomePage(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          CreateProfile.routeName: (ctx) => CreateProfile(),
          MainProfile.routeName: (ctx) => MainProfile(),
        },
      ),
    );
  }
}

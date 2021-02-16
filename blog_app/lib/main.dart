import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blog_app/pages/WelcomePage.dart';
import 'package:blog_app/pages/SignUpPage.dart';
import 'package:blog_app/pages/SignInPage.dart';
import 'package:blog_app/pages/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        home: WelcomePage(),
        routes: {
          SignUpPage.routeName: (ctx) => SignUpPage(),
          SignInPage.routeName: (ctx) => SignInPage(),
          HomePage.routeName: (ctx) => HomePage(),
        },
      ),
    );
  }
}

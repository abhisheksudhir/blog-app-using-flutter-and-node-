import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blog_app/pages/WelcomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: WelcomePage(),
    );
  }
}

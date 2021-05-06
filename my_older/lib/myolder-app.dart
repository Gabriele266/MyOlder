import 'package:flutter/material.dart';

import './pages/login-page.dart';
import './pages/root-create-page.dart';
import './pages/splash-page.dart';
import './pages/login-info-page.dart';
import './pages/newuser-info-page.dart';

class MyOlderApp extends StatelessWidget {
  // The bluet color of this theme
  Color get _bluet => const Color(0xff87b6a7);

  // The brown color accent
  Color get _brown => const Color(0xff5b5941);

  // The light yellow color
  Color get _lightYellow => const Color(0xffe3f09b);

  // The orange shadow
  Color get _orangeAccent => const Color(0xfff7d08a);

  // The red color
  Color get _redAccent => const Color(0xfff7f79);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyOlderApp',
      // Theme informations for the application
      // TODO: Make this theme more consistent and with better colors
      theme: ThemeData(
        iconTheme: IconThemeData(size: 25, color: Colors.white),
        backgroundColor: _orangeAccent,
        primaryColor: _bluet,
        accentColor: _lightYellow,
        canvasColor: Colors.grey[600],
        errorColor: Colors.red[800],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.redAccent,
          textTheme: ButtonTextTheme.normal,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: _brown,
            fontSize: 20,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier New',
          ),
          headline2: TextStyle(
            color: _orangeAccent,
            fontSize: 15,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
            fontFamily: 'Times new Roman',
          ),
          headline3: TextStyle(
            color: Colors.tealAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times new Roman',
          ),
          headline4: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Times new Roman',
              letterSpacing: 1.2),
          headline5: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          overline: TextStyle(
            color: Colors.red[800],
            fontSize: 15,
            letterSpacing: 0.4,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times new Roman',
          ),
          bodyText1: TextStyle(
            color: Colors.yellow[800],
            fontSize: 20,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.amberAccent,
          titleTextStyle: TextStyle(
            color: _brown,
            fontFamily: 'Courier New',
            fontWeight: FontWeight.bold,
          ),
          actionsIconTheme: IconThemeData(
            color: _brown,
            size: 40,
            opacity: 1,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.orange,
          backgroundColor: Colors.red[800],
          elevation: 1.2,
        ),
      ),
      routes: {
        '/splash': (context) =>
            SplashPage(message: 'Loading application... please wait. '),
        '/login': (context) => LoginPage(),
        '/create': (context) => RootCreatePage(),
        '/create/info': (context) => NewUserInfoPage(),
        '/login/info': (context) => LoginInfoPage(),
      },
      home: SplashPage(),
    );
  }
}

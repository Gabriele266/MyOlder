import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/login-page.dart';
import 'pages/root-create-page.dart';
import 'pages/splash-page.dart';
import 'pages/login-info-page.dart';
import 'pages/newuser-info-page.dart';
import 'safe-zone-home.dart';

class MyOlderApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'MyOlderApp',

      // Theme informations for the application
      theme: ThemeData(
        iconTheme: IconThemeData(
            size: 25,
          color: Colors.white
        ),
        backgroundColor: Colors.grey[700],
        primaryColor: Colors.white,
        accentColor: Colors.yellow[800],
        canvasColor: Colors.grey[600],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.redAccent,
          textTheme: ButtonTextTheme.normal
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold
          ),
          headline2: TextStyle(
            color: Colors.yellow[800],
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
            letterSpacing: 1.2
          ),
          headline5: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
          overline: TextStyle(
            color: Colors.red[800],
            fontSize: 15,
            letterSpacing: 0.4,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times new Roman'
          ),
          bodyText1: TextStyle(
            color: Colors.yellow[800],
            fontSize: 20,
            letterSpacing: 1,
            fontWeight: FontWeight.w600
          )
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          actionsIconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
            opacity: 1
          )
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.orange,
          backgroundColor: Colors.red[800],
          elevation: 1.2,
        )
      ),
      routes: {
        '/splash':(context) => SplashPage(message: 'Loading application... please wait. '),
        '/login':(context) => LoginPage(),
        '/create':(context) => RootCreatePage(),
        '/create/info': (context) => NewUserInfoPage(),
        '/login/info' : (context) => LoginInfoPage(),
      },
      // Home della applicazione
      home: SplashPage(),
    );
  }
}
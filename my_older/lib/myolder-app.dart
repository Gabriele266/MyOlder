import 'package:flutter/material.dart';

import './pages/login-page.dart';
import './pages/root-create-page.dart';
import './pages/splash-page.dart';
import './pages/login-info-page.dart';
import './pages/newuser-info-page.dart';

import './global/theme.dart';

class MyOlderApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyOlderApp',
      // Theme informations for the application
      theme: AppTheme.normalTheme,
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

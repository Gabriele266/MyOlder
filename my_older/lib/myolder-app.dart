import 'package:flutter/material.dart';
import 'package:myolder/pages/faq-page.dart';
import 'package:myolder/pages/safe-zone-home.dart';
import 'package:myolder/pages/user-tools-page.dart';
import 'package:provider/provider.dart';

import './pages/application-informations-page.dart';
import './pages/login-page.dart';
import './pages/root-create-page.dart';
import './pages/splash-page.dart';
import './pages/login-info-page.dart';
import './pages/newuser-info-page.dart';
import './pages/settings-page.dart';
import './providers/user-file-manager.dart';
import './global/theme.dart';

class MyOlderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          UserFileManager(rootFile: 'root.cfg', safeFolder: 'safe-dir'),
      child: MaterialApp(
        title: 'MyOlderApp',
        // Theme informations for the application
        theme: AppTheme.normalTheme,

        initialRoute: SplashPage.routeName,

        routes: {
          SplashPage.routeName: (context) => SplashPage(),
          LoginPage.routeName: (context) => LoginPage(),
          RootCreatePage.routeName: (context) => RootCreatePage(),
          NewUserInfoPage.routeName: (context) => NewUserInfoPage(),
          SafeZoneHome.routeName: (context) => SafeZoneHome(),
          LoginInfoPage.routeName: (context) => LoginInfoPage(),
          UserToolsPage.routeName: (context) => UserToolsPage(),
          SettingsPage.routeName: (context) => SettingsPage(),
          ApplicationInformationsPage.routeName: (context) =>
              ApplicationInformationsPage(),
          FaqPage.routeName: (context) => FaqPage(),
        },
      ),
    );
  }
}

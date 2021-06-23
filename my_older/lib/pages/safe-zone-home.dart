import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restart/flutter_restart.dart';

import '../widgets/page-components/home-body.dart';
import '../constructs/providers-couple.dart';
import '../widgets/page-components/home-fltbutton.dart';
import '../drawers/home-drawer.dart';
import '../providers/user-file-manager.dart';

class SafeZoneHome extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    // Get the manager
    final couple = ModalRoute.of(context).settings.arguments as ProvidersCouple;

    return ChangeNotifierProvider(
      create: (_) => couple.userFileManager,
      child: ChangeNotifierProvider(
        create: (_) => couple.safeFileManager,
        child: Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeZoneHomeBody(),
          drawer: HomeDrawer(),
          floatingActionButton: HomeFloatingActionButton(),
        ),
      ),
    );
  }

  /// Builds the app bar
  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      centerTitle: true,
      title: Text('Safe zone', style: theme.appBarTheme.titleTextStyle),
      actions: [
        IconButton(
          icon: Icon(
            Icons.logout,
            color: theme.primaryColorDark,
          ),
          onPressed: () {
            _doLogout(context);
          },
        ),
      ],
    );
  }

  /// Executes the logout to the application
  Future<void> _doLogout(BuildContext context) async {
    UserFileManager.of(context).logout();
    FlutterRestart.restartApp();
  }
}

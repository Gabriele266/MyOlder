import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';

import '../pages/login-page.dart';
import '../providers/user-file-manager.dart';
import '../widgets/drawer-components/drawer-list-tile-button.dart';
import '../widgets/drawer-components/myolder-user-widget.dart';
import '../providers/safe-file-manager.dart';

// TODO: Implement settings page
// TODO: Implement application faq
// TODO: Implement application informations
// TODO: Implement application settings
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: media.padding.top + 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyOlderUserWidget(),
              Divider(
                color: theme.primaryColorDark,
                height: 20,
                indent: media.size.width * 0.05,
                endIndent: media.size.width * 0.05,
              ),
              DrawerListTileButton(
                text: 'Application informations',
                icon: Icons.info,
                callBack: () {
                  _showApplicationInformations();
                },
              ),
              DrawerListTileButton(
                text: 'Settings',
                icon: Icons.settings,
                callBack: () {
                  _showApplicationSettings();
                },
              ),
              DrawerListTileButton(
                text: 'Add new safe file',
                icon: Icons.add,
                callBack: () {
                  SafeFileManager.of(context, listen: false).importNewFile();
                  Navigator.of(context).pop();
                },
              ),
              DrawerListTileButton(
                text: 'Clear safe zone',
                icon: Icons.delete,
                callBack: () {
                  SafeFileManager.of(context, listen: false)
                      .clearAllSafeFiles();
                  Navigator.of(context).pop();
                },
              ),
              DrawerListTileButton(
                text: 'MyOlder FAQ',
                icon: Icons.question_answer,
                callBack: () {
                  _showApplicationFAQ();
                },
              ),
              DrawerListTileButton(
                text: 'Logout',
                icon: Icons.logout,
                callBack: () {
                  UserFileManager.of(context).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows the application faq
  Future<void> _showApplicationFAQ() async {}

  /// Shows the user settings page
  Future<void> _showUserSettings() async {}

  /// Shows the application informations
  Future<void> _showApplicationInformations() async {}

  /// Shows the application settings
  Future<void> _showApplicationSettings() async {}
}

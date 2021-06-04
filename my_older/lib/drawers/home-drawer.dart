import 'package:flutter/material.dart';

import '../widgets/drawer-long-button.dart';
import '../widgets/myolder-user-widget.dart';

import '../managers/safe-file-manager.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: media.size.height * 0.20,
              child: DrawerHeader(
                child: MyOlderUserWidget(
                  safeFilesCount: SafeFileManager.of(context).safeFilesCount,
                  user: SafeFileManager.of(context).allowedUser,
                  showUserSettings: () {
                    print('User settings');
                  },
                ),
              ),
            ),
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
                Navigator.pop(context);
              },
            ),
            DrawerListTileButton(
              text: 'Clear safe zone',
              icon: Icons.delete,
              callBack: () {
                SafeFileManager.of(context, listen: false).clearAllSafeFiles();
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
                // TODO: Implement logout
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Clears the [SafeZone] removing all the files
  // Future<void> _clearSafeZone(BuildContext context) async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ClearAllSafeFilesDialog(_onClearSafeZoneAccepted),
  //     ),
  //   );
  // }

  /// Shows the application faq
  Future<void> _showApplicationFAQ() async {
    // TODO: Implement application faq
  }

  /// Shows the user settings page
  Future<void> _showUserSettings() async {
    // TODO: Implement user settings
  }

  /// Shows the application informations
  Future<void> _showApplicationInformations() async {
    // TODO: Implement application informations
  }

  /// Shows the application settings
  Future<void> _showApplicationSettings() async {
    // TODO: Implement application settings
  }

  
}

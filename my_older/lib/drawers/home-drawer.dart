import 'package:flutter/material.dart';

import '../providers/user-file-manager.dart';
import '../widgets/drawer-components/drawer-list-tile-button.dart';
import '../widgets/drawer-components/myolder-user-widget.dart';
import '../providers/safe-file-manager.dart';
import '../pages/application-informations-page.dart';

// TODO: Implement application faq
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
                  _showApplicationInformations(context);
                },
              ),
              DrawerListTileButton(
                text: 'Settings',
                icon: Icons.settings,
                callBack: () {
                  _showApplicationSettings();
                },
              ),
              // DrawerListTileButton(
              //   text: 'Add new safe file',
              //   icon: Icons.add,
              //   callBack: () {
              //     SafeFileManager.of(context, listen: false)
              //         .importNewFile(context);
              //     Navigator.of(context).pop();
              //   },
              // ),
              DrawerListTileButton(
                text: 'Clear safe zone',
                icon: Icons.delete,
                callBack: () {
                  _clearSafeZone(context);
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

  /// Clears the safe zone
  Future<void> _clearSafeZone(BuildContext context) async {
    // Check if there are files to remove
    if (SafeFileManager.of(context, listen: false).safeFilesCount > 0) {
      final dial = AlertDialog(
        title: const Text('This operation will remove all your files'),
        content: const Text(
            'By clicking on \'Continue\' you will loose all your files. Do you agree?'),
        actions: [
          TextButton(
            child: const Text('Deny'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Continue'),
            onPressed: () {
              SafeFileManager.of(context, listen: false).clearAllSafeFiles();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );

      showDialog(context: context, builder: (_) => dial);
    }
  }

  /// Shows the application faq
  Future<void> _showApplicationFAQ() async {}

  /// Shows the user settings page
  Future<void> _showUserSettings() async {}

  /// Shows the application informations
  Future<void> _showApplicationInformations(BuildContext context) async =>
      Navigator.of(context).pushNamed(ApplicationInformationsPage.routeName);

  /// Shows the application settings
  Future<void> _showApplicationSettings() async {}
}

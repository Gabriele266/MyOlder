import 'package:flutter/material.dart';

import '../pages/faq-page.dart';
import '../widgets/dialogs/continue-cancel-dialog.dart';
import '../providers/user-file-manager.dart';
import '../widgets/drawer-components/drawer-list-tile-button.dart';
import '../widgets/drawer-components/myolder-user-widget.dart';
import '../providers/safe-file-manager.dart';
import '../pages/application-informations-page.dart';
import '../pages/settings-page.dart';

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
                callBack: () => _showApplicationInformations(context),
              ),
              DrawerListTileButton(
                text: 'Settings',
                icon: Icons.settings,
                callBack: () => _showApplicationSettings(context),
              ),
              DrawerListTileButton(
                text: 'Clear safe zone',
                icon: Icons.delete,
                callBack: () => _clearSafeZone(context),
              ),
              DrawerListTileButton(
                text: 'MyOlder FAQ',
                icon: Icons.question_answer,
                callBack: () => _showApplicationFAQ(context),
              ),
              DrawerListTileButton(
                text: 'Logout',
                icon: Icons.logout,
                callBack: () => _showLogout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows the logout
  Future<void> _showLogout(BuildContext context) async {
    // Show the dialog to check if the user is shure
    showDialog(
      context: context,
      builder: (context) => ContinueCancelDialog(
        title: 'Are you shure?',
        icon: Icons.question_answer,
        content:
            'If you log out, the application will request you the password another time. ',
        onAccept: () {
          UserFileManager.of(context).logout();
          Navigator.of(context).pop();
        },
        onDismiss: () {},
      ),
    );
  }

  /// Clears the safe zone
  Future<void> _clearSafeZone(BuildContext context) async {
    // Check if there are files to remove
    if (SafeFileManager.of(context, listen: false).safeFilesCount > 0) {
      showDialog(
        context: context,
        builder: (_) => ContinueCancelDialog(
          title: 'This operation will remove all your files',
          content:
              'By clicking on \'Continue\' you will loose all your files. Do you agree?',
          onAccept: () {
            SafeFileManager.of(context, listen: false).clearAllSafeFiles();
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  /// Shows the application faq
  Future<void> _showApplicationFAQ(BuildContext context) async => Navigator.of(context).pushNamed(FaqPage.routeName);

  /// Shows the application informations
  Future<void> _showApplicationInformations(BuildContext context) async =>
      Navigator.of(context).pushNamed(ApplicationInformationsPage.routeName);

  /// Shows the application settings
  Future<void> _showApplicationSettings(BuildContext context) async =>
      Navigator.of(context).pushNamed(SettingsPage.routeName);
}

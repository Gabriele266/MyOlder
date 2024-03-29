import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../pages/user-tools-page.dart';
import '../../providers/safe-file-manager.dart';
import '../../providers/user-file-manager.dart';

class MyOlderUserWidget extends StatelessWidget {
  final bool enabled;

  /// Creates a new instance of a [MyOlderUserWidget]
  ///
  ///[enabled] Specifies if this widget should redirect the user to the
  ///[UserToolsPage].
  MyOlderUserWidget({
    Key key,
    this.enabled = true,
  }) : super(key: key);

  /// Creates a disabled [MyOlderUserWidget] (not clickable)
  MyOlderUserWidget.disabled() : this.enabled = false;

  @override
  Widget build(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final manager = SafeFileManager.of(context);
    final user = manager.allowedUser;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.05),
      child: ListTile(
        onTap: enabled ? () => _showUserSettings(context) : null,
        tileColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: theme.primaryColorDark, width: 1 * media.textScaleFactor),
          borderRadius: BorderRadius.circular(media.size.width * 0.03),
        ),
        leading: CircleAvatar(
          radius: media.size.height * 0.025,
          backgroundColor: theme.primaryColorDark,
          child: CircleAvatar(
            child: const Icon(Icons.person),
            radius: media.size.height * 0.02,
          ),
        ),
        title: Text('${user.name}', style: theme.textTheme.headline2),
        subtitle: Text(
          '${manager.safeFilesCount} Locked Files',
          style: theme.textTheme.headline3,
        ),
      ),
    );
  }

  /// Shows the user settings
  void _showUserSettings(BuildContext context) {
    final userM = UserFileManager.of(context, listen: false);
    final safeFM = SafeFileManager.of(context, listen: false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: userM,
          child: ChangeNotifierProvider.value(
            value: safeFM,
            child: UserToolsPage(),
          ),
        ),
      ),
    );
  }
}

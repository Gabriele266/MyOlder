import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../constructs/myolder-user.dart';
import '../../providers/safe-file-manager.dart';

// TODO: Adjust widget size to avoid overflow (Issue #)
class MyOlderUserWidget extends StatelessWidget {
  /// Creates a new instance of a [MyOlderUserWidget]
  ///
  MyOlderUserWidget({
    Key key,
  }) : super(key: key);

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
  void _showUserSettings() {
    print('To be implemented. ');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../constructs/myolder-user.dart';

class MyOlderUserWidget extends StatelessWidget {
  // Application user
  final MyOlderUser user;

  // Shows the user settings
  final void Function() showUserSettings;

  // Number of safefiles into the safe zone
  final int safeFilesCount;

  /// Creates a new instance of a [MyOlderUserWidget]
  ///
  ///  [user] The user informations
  ///  [showUserSettings] The fuction to use for displaying the user settings page
  ///   [safeFilesCount] The number of safefiles
  MyOlderUserWidget({
    Key key,
    @required this.user,
    @required this.showUserSettings,
    @required this.safeFilesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: MaterialButton(
            splashColor: theme.backgroundColor,
            color: theme.primaryColor,
            onPressed: showUserSettings,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.primaryColorDark,
                width: 2 * media.textScaleFactor,
              ),
              borderRadius: BorderRadius.circular(media.size.width * 0.03),
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.01),
              leading: CircleAvatar(
                radius: media.size.height * 0.05,
                backgroundColor: theme.primaryColorDark,
                child: CircleAvatar(
                  child: const Icon(Icons.person),
                  radius: media.size.height * 0.03,
                ),
              ),
              title: Text('${user.name}', style: theme.textTheme.headline2),
              subtitle: Padding(
                padding: EdgeInsets.only(top: media.size.height * 0.009),
                child: Text(
                  '$safeFilesCount Locked Files',
                  style: theme.textTheme.headline3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

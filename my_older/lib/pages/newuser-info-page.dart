import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/text-section.dart';

/// TODO: Make NewUserInfoPage page responsive and adaptive
class NewUserInfoPage extends StatelessWidget {
  /// Route name
  static const String routeName = '/create/info';

  /// Creates a new [NewUserInfoPage]
  ///
  /// The page shows informations about the creation of a new user
  const NewUserInfoPage();

  @override
  Widget build(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'New user informations',
          style: theme.textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: media.size.width * 0.02),
            child: Column(
              children: [
                TextSection(
                  title: 'Creation informations',
                  titleIcon: Icons.info,
                  content:
                      'To set up a safe-zone you need to create a user that can access the files. ',
                  maxHeight: media.size.height * 0.2,
                ),
                TextSection(
                  title: 'User informations',
                  content:
                      'In order to create a new user for this safe zone, you have to provide us some informations. You should give it a '
                      'username and assign a password. These will be asked at every log-in. ',
                  maxHeight: media.size.height * 0.25,
                ),
                TextSection(
                  title: 'Rules',
                  content:
                      'Follow this simple rules: The username must only contain lower case characters or numbers, and the password should be longer than 6 characters. Thank you!!!',
                  maxHeight: media.size.height * 0.2,
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Understood',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

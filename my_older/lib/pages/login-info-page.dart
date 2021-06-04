import 'package:flutter/material.dart';

import '../widgets/textual/text-section.dart';

class LoginInfoPage extends StatelessWidget {
  /// The name of this page
  static const String routeName = '/login/info';

  @override
  Widget build(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Login informations',
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
                  title: 'Credentials needed',
                  content:
                      'To access the safe zone you need to insert your credentials. Theme manager should give you a username and a password to use this application. ',
                  maxHeight: media.size.height * 0.25,
                ),
                TextSection(
                  title: 'The only way to access data is using this',
                  content:
                      'If you have lost them, you won\'t be able to access all your data!!!! Pay attention!!!',
                  maxHeight: media.size.height * 0.2,
                ),
                TextSection(
                  title: 'Additional informations',
                  content:
                      'The user name couldn\'t contain spaces or special characters. The password should be longer than 5 characters.',
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

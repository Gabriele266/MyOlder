import 'dart:ui';

import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'New user informations',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  'New user creation informations',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'To set up a safe-zone you need to create a user that can access the files. ',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'User informations',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'In order to create a new user for this safe zone, you have to provide us some informations. You should give it a '
                  'UserName and assign a password. This two will be asked at every log-in. ',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Rules',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Follow this simple rules: The username must only contain lower case characters or numbers, and the password should be longer than 6 characters. Thank you!!!',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

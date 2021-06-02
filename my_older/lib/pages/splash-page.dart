import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:ui';

import '../managers/user-file-manager.dart';
import '../constructs/myolder-user.dart';
import '../widgets/double-action-alert.dart';
import '../pages/login-page.dart';
import '../pages/root-create-page.dart';

class SplashPage extends StatefulWidget {
  /// Route name
  static const String routeName = '/splash';

  // The message of this widget
  final String message;

  /// Creates a new instance of a SplashPage to display during the application startup.
  ///
  /// [message] A optional message to display. <br>
  /// The page should display informations about the operation in progress,<br>
  /// and has the same color of the appBar. <br>
  /// It shows the login page or the rootcreatepage if there aren't users
  SplashPage({
    Key key,
    this.message = ' ',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// Gets the correct main page for the application
  /// TODO: Make getMainPage private
  /// TODO: Use final and const members
  Future<void> getMainPage(BuildContext context) async {
    // Create a user file reader
    var fileReader = UserFileManager(file: 'root.cfg', user: MyOlderUser());
    // Check if files and folders exist or not
    bool root = await fileReader.checkRootExists();
    bool config = await fileReader.checkConfigurationExists('safe-dir');

    if (root && config) {
      // Allow login
      // Push the widget into the navigator
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      print('File esiste');
    } else if (!root && !config) {
      // No configuration for this appilcation.
      // Create one
      Navigator.pushReplacementNamed(context, RootCreatePage.routeName);
      print('File non esiste');
    } else if ((root && !config) || (!root && config)) {
      // Show alert and ask if should remove the configuration file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DoubleActionAlert(
              title: 'Problems detected',
              contents:
                  'MyOlder has detected some file issues, resolve them by deleting all? You will lose all your data. '
                  'If you won\'t perform this operation, you won\'t be able to use them anymore. ',
              firstActionText: 'Yes, i accept',
              firstAction: () {
                // Delete all configurations
                deleteAllConfigurations(fileReader);
              },
              secondActionText: 'No, leave all',
              secondAction: () {
                Navigator.pop(context);
                exit(0);
              },
            );
          },
        ),
      );
    }
  }

  /// Deletes all the configuration files from all the directories
  /// TODO: Make deleteAllConfigurations private
  Future<void> deleteAllConfigurations(UserFileManager fileReader) async {
    // Remove all the configuration and file and re execute this login
    fileReader.removeFile();
    fileReader.removeConfigurationFolder('safe-dir');

    print('Deleting all the application-configuring files. ');
    print('Operation started at: ${DateTime.now().toString()}');

    Navigator.pop(context);
    // Re do the login
    getMainPage(context);
  }

  @override
  Widget build(BuildContext context) {
    getMainPage(context);
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: Center(
        child: Text(
          widget.message,
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

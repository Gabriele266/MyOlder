import 'dart:io';

import 'package:flutter/material.dart';

import '../managers/user-file-manager.dart';
import '../constructs/myolder-user.dart';
import '../widgets/double-action-alert.dart';
import '../pages/login-page.dart';
import '../pages/root-create-page.dart';

class SplashPage extends StatefulWidget {
  /// Route name
  static const String routeName = '/splash';

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    _getMainPage(context);
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: Center(
        child: Text(
          'Loading application... please wait. ',
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Gets the correct main page for the application
  Future<void> _getMainPage(BuildContext context) async {
    // Create a user file reader
    final fileReader = UserFileManager(file: 'root.cfg', user: MyOlderUser());
    // Check if files and folders exist or not
    final root = await fileReader.checkRootExists();
    final config = await fileReader.checkConfigurationExists('safe-dir');

    if (root && config) {
      // Allow login
      // Push the widget into the navigator
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      print('File exists');
    } else if (!root && !config) {
      // No configuration for this appilcation.
      // Create one
      Navigator.pushReplacementNamed(context, RootCreatePage.routeName);
      print('File doesn\'t exist');
    } else if ((root && !config) || (!root && config)) {
      // Show alert and ask if should remove the configuration file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _buildProblemsDialog(context, fileReader),
        ),
      );
    }
  }

  /// Deletes all the configuration files from all the directories
  Future<void> _deleteAllConfigurations(UserFileManager fileReader) async {
    // Remove all the configuration and file and re execute this login
    fileReader.removeFile();
    fileReader.removeConfigurationFolder('safe-dir');

    print('Deleting all the application-configuring files. ');
    print('Operation started at: ${DateTime.now().toString()}');

    Navigator.pop(context);
    // Re do the login
    _getMainPage(context);
  }

  /// Builds the problems dialog
  Widget _buildProblemsDialog(
      BuildContext context, UserFileManager fileReader) {
    return DoubleActionAlert(
      title: 'Problems detected',
      contents:
          'MyOlder has detected some file issues, resolve them by deleting all? You will lose all your data. '
          'If you won\'t perform this operation, you won\'t be able to use them anymore. ',
      firstActionText: 'Yes, i accept',
      firstAction: () {
        // Delete all configurations
        _deleteAllConfigurations(fileReader);
      },
      secondActionText: 'No, leave all',
      secondAction: () {
        Navigator.pop(context);
        exit(0);
      },
    );
  }
}

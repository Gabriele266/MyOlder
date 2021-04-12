import 'dart:ui';

import 'package:flutter/material.dart';
import '../user-file-manager.dart';
import '../myolder-user.dart';

class SplashPage extends StatefulWidget{
  String _message = ' ';

  /// Creates a new instance of a SplashPage to display during the application startup.
  ///
  /// [message] A optional message to display. <br>
  /// The page should display informations about the operation in progress,<br>
  /// and has the same color of the appBar. <br>
  /// It shows the login page or the rootcreatepage if there aren't users
  SplashPage({String message = ' '}) : super(){
    _message = message;
  }

  @override
  State<StatefulWidget> createState(){
    return _SplashPageState(message: _message);
  }
}

class _SplashPageState extends State<SplashPage>{
  // Message of the application
  String _message = ' ';

  _SplashPageState({String message = ' '}) : super(){
    _message = message;
  }

  /// Gets the correct main page for the application
  Future<void> getMainPage(BuildContext context) async {
    // Create a user file reader
    var fileReader = UserFileManager(file: 'root.cfg', user: MyOlderUser());

    if(await fileReader.checkRootExists() && !await fileReader.checkHacks()){
      // Push the widget into the navigator
      Navigator.pushReplacementNamed(context, '/login');
      print('File esiste');
    }
    else if(await fileReader.checkHacks()){
      print('HACK DETECTED. ABORT APPLICATION');
      setState(() {
        _message = 'HACK DETECTED OR APPLICATION FATAL ERROR. SEE DOCUMENTATION. \nYOU WON\'T BE ABLE TO ACCESS YOUR DATA '
            'OR USE THIS APPLICATION. IN CASE OF NEW USER REQUIRMENT ALL YOUR DATA WILL BE ERASED FROM DISK.\n'
            '\n'
            'DONT TRY TO HACK THIS APPLICATION, YOU ONLY WILL CAUSE DATA LOSS FOR THE USER. IF YOU THINK THAT THIS IS AN ERROR, SEND A '
            'BUG REPORT TO THE DEVELOPER. DO NOT TOUCH THE APPLICATION FILES. ' ;
      });
    }
    else{
      Navigator.pushReplacementNamed(context, '/create');
      print('File non esiste');
    }
  }

  @override
  Widget build(BuildContext context) {
    getMainPage(context);
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: Center(
        child: Text(
          _message,
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        )
      )
    );
  }
}
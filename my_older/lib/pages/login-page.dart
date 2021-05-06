import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'dart:math';
import 'dart:async';

import 'package:myolder/constructs/myolder-user.dart';
import 'package:myolder/managers/user-file-manager.dart';
import 'package:myolder/managers/safe-file-manager.dart';
import 'package:myolder/pages/safe-zone-home.dart';

class LoginPage extends StatefulWidget {
  // Banner to show at top
  final MaterialBanner banner;

  /// Creates a new instance of a LoginPage
  ///
  /// [banner] A banner to show at page display
  const LoginPage({
    this.banner,
  });

  @override
  State<StatefulWidget> createState() => _LoginNormalState();
}

// TODO: Make LoginPage page responsive and adaptive
// TODO: Add use of theme for the various colors
class _LoginNormalState extends State<LoginPage> {
  // Valore del padding superiore
  var _topPadding = 30.0;

  // Number of failed logins
  int _failedLogins = 0;

  // Controller dell' editing delle caselle
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  // Keyboard input controller
  final _keyboardController = KeyboardVisibilityNotification();
  var _onPressedHandler;

  // Login timer to control access times
  Timer _loginTimer;

  // Utente inserito in input
  var _userInfo = MyOlderUser();

  // Indica se nascondere la password
  bool _hidePassword = true;
  bool _showBanner = false;

  // This string contains eventual errors during the login phase
  String _errorString = '';

  // TODO: Move listeners into separated internal functions into state class
  @override
  void initState() {
    super.initState();
    _keyboardController.addNewListener(onShow: () {
      setState(() {
        _topPadding = 28;
      });
    }, onHide: () {
      setState(() {
        _topPadding = 30.0;
      });
    });

    // Set default login action
    _onPressedHandler = onLoginRequest;

    // Add listeners to the keyboard to see when it is shown
    _userController.addListener(() {
      _userInfo.name = _userController.text;
    });
    _passController.addListener(() {
      _userInfo.password = _passController.text;
    });
  }

  // TODO: Adapt build using function to build the banner if necessary
  @override
  Widget build(BuildContext context) {
    if (widget.banner != null) {
      _showBanner = true;
      widget.banner.actions.add(
        TextButton(
          child: Text(
            'Ok',
          ),
          onPressed: () {
            setState(() {
              _showBanner = false;
            });
          },
        ),
      );
    }

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Safe area access',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              size: theme.appBarTheme.actionsIconTheme.size,
            ),
            onPressed: () => Navigator.pushNamed(context, '/login/info'),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            _showBanner
                ? widget.banner
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: _topPadding,
                    bottom: _topPadding / 2,
                  ),
                  child: Text(
                    'Insert login credentials',
                    style: theme.textTheme.headline1,
                  ),
                ),
                _errorString != ''
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          _errorString,
                          style: theme.textTheme.overline,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.accentColor,
                              width: 2,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10),
                            ),
                          ),
                          labelText: 'User name',
                          labelStyle: theme.textTheme.bodyText1,
                        ),
                        controller: _userController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextField(
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.accentColor,
                                width: 2,
                              ),
                            ),
                            suffix: IconButton(
                              icon: Icon(
                                _hidePassword == true
                                    ? Icons.remove_red_eye
                                    : Icons.clear_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    // Invert the state of the password visibility
                                    _hidePassword = !_hidePassword;
                                  },
                                );
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.insert_link,
                              size: 20,
                              color: Colors.white,
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                const Radius.circular(10),
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: theme.textTheme.bodyText1,
                          ),
                          controller: _passController,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: 150,
                      height: 50,
                      child: MaterialButton(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.redAccent,
                        disabledColor: Colors.grey,
                        child: Row(
                          children: [
                            Icon(
                              Icons.login,
                              size: 30,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Login',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: _onPressedHandler,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Performs the login process
  /// TODO: Make this function private
  Future<void> performLogin() async {
    // Execute the login
    var reader = UserFileManager(file: 'root.cfg', user: _userInfo);
    final bool result = await reader.doControl();

    if (result) {
      // Start loading the safe-zone-files
      final SafeFileManager man = await SafeFileManager.readConfigurationFile(
          'safe-dir', 'rc&MEuFiMoZBB8Ru*Sa8');
      // Check if the two users are equal
      final MyOlderUser usr = man.user;

      if (_userInfo.equals(usr)) {
        // print('VERY GOOD, LOGIN SUPER SUCCESSFUL');
        setState(
          () {
            _errorString = '';
            _onPressedHandler = onLoginRequest;
            // Start the login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SafeZoneHome(
                    usr,
                    man,
                  );
                },
              ),
            );
          },
        );
      } else {
        setState(
          () {
            _errorString = 'Problems during login. Login aborted. ';
            _onPressedHandler = onLoginRequest;
          },
        );
      }
    } else {
      setState(
        () {
          _failedLogins++;
          _errorString =
              'Invalid user name or password. Retry or see the login info page for more details.';
          _onPressedHandler = onLoginRequest;
        },
      );
    }
  }

  /// Handles the button pression
  /// TODO: Make this function private
  Future<void> onLoginRequest() async {
    // Calculate access time
    // The function that represents this is y = 5 ^ (x - 1) - 1
    final int delay = (pow(5, _failedLogins - 1) - 1).ceil();
    // Elapsed time in seconds
    int elapsed = 0;

    // Disable login button
    setState(
      () {
        _onPressedHandler = null;
        _errorString = '';
      },
    );

    // Check if there is time to wait
    if (delay > 0) {
      // Start timer to slow down login
      _loginTimer = Timer.periodic(
        Duration(seconds: 1),
        (timer) async {
          if (elapsed < delay) {
            // Increase elapsed time
            setState(
              () {
                elapsed++;
                _errorString =
                    'Login has been suspended. \nTime before next login: ${delay - elapsed}';
              },
            );
          } else {
            // Cancel the timer
            setState(() => timer.cancel());
            // Perform the login
            performLogin();
          }
        },
      );
    }
    // Otherwise execute login
    else
      performLogin();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose text editing controllers
    _userController.dispose();
    _passController.dispose();
    // Dispose the keyboardcontroller
    _keyboardController.dispose();
  }
}

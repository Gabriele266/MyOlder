import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flushbar/flushbar.dart';

import '../constructs/providers-couple.dart';
import '../constructs/myolder-user.dart';
import '../providers/user-file-manager.dart';
import '../providers/safe-file-manager.dart';
import '../pages/login-info-page.dart';
import '../pages/safe-zone-home.dart';

class LoginPage extends StatefulWidget {
  /// The name of this page
  static const String routeName = '/login';

  @override
  State<StatefulWidget> createState() => _LoginNormalState();
}

class _LoginNormalState extends State<LoginPage> {
  // Number of failed logins
  int _failedLogins = 0;

  // Controller dell' editing delle caselle
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  // Keyboard input controller
  final _keyboardController = KeyboardVisibilityNotification();

  bool _loginBlocked = false;

  // Indica se nascondere la password
  bool _hidePassword = true;

  // This string contains eventual errors during the login phase
  String _errorString = '';

  bool _keepLogged = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to the keyboard to see when it is shown
    _userController.addListener(() {});
    _passController.addListener(() {});

    // Check if the login should be kept
    UserFileManager.of(context).isLoginKept().then((value) {
      _keepLogged = value;
      _onLoginRequest();
    });
  }

  /// Displays the 'userjustcreated message'
  void _displayTemporaryMessage() {
    try {
      Flushbar(
        title: 'New user created',
        message: 'The new user has been created. Use the credentials to log-in',
        duration: Duration(
          seconds: 5,
        ),
        isDismissible: true,
      )..show(context);
    } catch (o) {}
  }

  /// Displays the login info page
  void _displayLoginInfo() =>
      Navigator.pushNamed(context, LoginInfoPage.routeName);

  @override
  Widget build(BuildContext context) {
    // Optimize device/application informations
    final theme = Theme.of(context);
/*     final media = MediaQuery.of(context);
 */
    // build appbar to have it's height
    final appBar = _buildAppBar();

    final showMsg = ModalRoute.of(context).settings.arguments as bool;

    // Check if i have to display the message
    if (showMsg) _displayTemporaryMessage();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeading(),
            _buildErrorMessage(),
            _buildLoginCredentialsInput(),
            _buildKeepLoggedSwitch(),
            _buildLoginButton(),
            _buildAdditionalSpace(),
          ],
        ),
      ),
    );
  }

  /// Builds the additional space based on the keyboard insets
  Widget _buildAdditionalSpace() {
    final media = MediaQuery.of(context);
    final height = media.viewInsets.top;
    print(height);
    return SizedBox(
      height: height,
    );
  }

  /// Builds the password suffix icon
  IconData _buildPasswordSuffixIcon() {
    if (_hidePassword) {
      return Icons.remove_red_eye;
    }
    return Icons.security;
  }

  /// Build the page heading
  Widget _buildHeading() {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(top: media.size.height * 0.04),
      child: Text(
        'Insert login credentials',
        style: theme.textTheme.headline1,
      ),
    );
  }

  /// Builds the login button
  Widget _buildLoginButton() {
    // Simplify
/*     final theme = Theme.of(context);
 */
    final media = MediaQuery.of(context);

    final landscape = media.orientation == Orientation.landscape;

    return Container(
      width: media.size.width * (landscape ? 0.20 : 0.30),
      height: media.size.height * (landscape ? 0.10 : 0.06),
      child: TextButton.icon(
        onPressed: !_loginBlocked ? () => _onLoginRequest() : null,
        icon: const Icon(
          Icons.login,
          size: 30,
        ),
        label: const FittedBox(
          child: const Text(
            'Login',
          ),
        ),
      ),
    );
  }

  Widget _buildKeepLoggedSwitch() {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Container(
      width: media.size.width * 0.5,
      padding: EdgeInsets.only(bottom: media.size.height * 0.01),
      child: SwitchListTile(
        title: Text('Keep logged', style: theme.textTheme.headline3),
        value: _keepLogged,
        onChanged: (final val) {
          setState(() {
            _keepLogged = val;
          });
        },
      ),
    );
  }

  /// Builds the appbar making it consistent
  AppBar _buildAppBar() {
    // Theme smart access
    final theme = Theme.of(context);

    return AppBar(
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
          onPressed: _displayLoginInfo,
        ),
      ],
    );
  }

  /// Builds the error message text widget if there are errors
  Widget _buildErrorMessage() {
    // Optimize and simplyfy
    final theme = Theme.of(context);

    return _errorString != ''
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _errorString,
              style: theme.textTheme.overline,
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  /// Builds the login credentials input
  Widget _buildLoginCredentialsInput() {
    // Simplyfy and optimize information fetching
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: media.size.height * 0.05,
        horizontal: media.size.width * 0.05,
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person,
              ),
              labelText: 'Username',
            ),
            controller: _userController,
            enabled: !_loginBlocked,
          ),
          SizedBox(height: media.size.height * 0.05),
          TextField(
            controller: _passController,
            obscureText: _hidePassword,
            enabled: !_loginBlocked,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock,
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                    _buildPasswordSuffixIcon(),
                    size: theme.iconTheme.size,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  }),
              labelText: 'Password',
            ),
          ),
        ],
      ),
    );
  }

  /// Performs the login process
  Future<void> _performLogin() async {
    // Get the user informations
    final logUser = MyOlderUser(
      name: _userController.text,
      password: _passController.text,
    );

    // Check the result of the loging
    final bool result =
        await UserFileManager.of(context).login(logUser, _keepLogged);

    if (result) {
      // Start loading the safe-zone-files
      final man = await SafeFileManager.readConfigurationFile(
          'safe-dir', 'rc&MEuFiMoZBB8Ru*Sa8');

      // Check if the two users are equal
      final usr = man.allowedUser;

      // Do inverted control
      if (!_keepLogged) {
        if (logUser.equals(usr))
          _onLoginSuccess(man);
        else
          _onLoginProblems();
      } else
        _onLoginSuccess(man);
    } else
      _onLoginFail();
  }

  /// Executed when the login is successful
  ///
  /// [man] The created [SafeFileManager]
  void _onLoginSuccess(SafeFileManager man) {
    // setState(
    //   () {
    //     _errorString = '';
    //     _loginBlocked = false;
    // Start the login
    Navigator.of(context).pushReplacementNamed(
      SafeZoneHome.routeName,
      arguments: ProvidersCouple(man, UserFileManager.of(context)),
    );
    //   },
    // );
  }

  /// Executed when there are problems during the login
  void _onLoginProblems() => setState(
        () {
          _errorString = 'Problems during login. Login aborted. ';
          _loginBlocked = false;
        },
      );

  /// Executed when the login fails
  void _onLoginFail() => setState(
        () {
          _failedLogins++;
          _errorString =
              'Invalid user name or password. Retry or see the login info page for more details.';
          _loginBlocked = false;
        },
      );

  /// Handles the button pression
  Future<void> _onLoginRequest() async {
    // Calculate access time
    // The function that represents this is y = 5 ^ (x - 1) - 1
    final int delay = (pow(5, _failedLogins - 1) - 1).ceil();
    // Elapsed time in seconds
    int elapsed = 0;

    // Disable login button
    setState(
      () {
        _loginBlocked = true;
        _errorString = '';
      },
    );

    // Check if there is time to wait
    if (delay > 0) {
      // Start timer to slow down login
      Timer.periodic(
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
            _performLogin();
          }
        },
      );
    }
    // Otherwise execute login
    else
      _performLogin();
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

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flushbar/flushbar.dart';

import '../constructs/providers-couple.dart';

import 'dart:math';
import 'dart:async';

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

  // Indica se nascondere la password
  bool _hidePassword = true;
  bool _showBanner = false;

  // This string contains eventual errors during the login phase
  String _errorString = '';

  @override
  void initState() {
    super.initState();
    // Keyboard controllers
    _keyboardController.addNewListener(
        onShow: _onKeyboardShow, onHide: _onKeyboardHide);

    // Set default login action
    _onPressedHandler = _onLoginRequest;

    // Add listeners to the keyboard to see when it is shown
    _userController.addListener(() {});
    _passController.addListener(() {});
  }

  /// Called when the keyboard is shown
  void _onKeyboardShow() {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double pad = landscape ? 28 : 20;

    setState(() {
      _topPadding = pad;
    });
  }

  /// Called when the keyboard is hidded
  void _onKeyboardHide() {
    setState(() {
      _topPadding = 30.0;
    });
  }

  /// Displays the 'userjustcreated message'
  void _displayTemporaryMessage() {
    try {
      Flushbar(
        title: 'New user created',
        message: 'The new user has been created. Use the credentials to log-in',
        duration: Duration(
          seconds: 8,
        ),
        isDismissible: true,
      )..show(context);
    } catch (o) {}
  }

  /// Displays the login info page
  void _displayLoginInfo() {
    Navigator.pushNamed(context, LoginInfoPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Optimize device/application informations
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    // build appbar to have it's height
    final appBar = _buildAppBar();

    final showMsg = ModalRoute.of(context).settings.arguments as bool;

    // Check if i have to display the message
    if (showMsg) _displayTemporaryMessage();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          width: media.size.width,
          height: media.size.height - (appBar.preferredSize.height),
          child: Column(
            children: [
              _buildHeading(),
              _buildErrorMessage(),
              _buildLoginCredentialsInput(),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the password suffix icon
  IconData _buildPasswordSuffixIcon() {
    if (_hidePassword) {
      return Icons.search;
    }
    return Icons.search_off_rounded;
  }

  /// Build the page heading
  Widget _buildHeading() {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: _topPadding,
        bottom: _topPadding / 2,
      ),
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
        onPressed: _onPressedHandler,
        icon: const Icon(
          Icons.login,
          size: 30,
        ),
        label: const Text(
          'Login',
        ),
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
          ),
          SizedBox(height: media.size.height * 0.05),
          TextField(
            controller: _passController,
            obscureText: _hidePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock,
              ),
              suffixIcon: Icon(
                _buildPasswordSuffixIcon(),
                size: theme.primaryIconTheme.size,
                color: theme.primaryIconTheme.color,
              ),
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

    final bool result = await UserFileManager.of(context).login(logUser);

    if (result) {
      // Start loading the safe-zone-files
      SafeFileManager man = await SafeFileManager.readConfigurationFile(
          'safe-dir', 'rc&MEuFiMoZBB8Ru*Sa8');

      // Check if the two users are equal
      MyOlderUser usr = man.allowedUser;

      if (logUser.equals(usr)) {
        setState(
          () {
            _errorString = '';
            _onPressedHandler = _onLoginRequest;
            // Start the login
            Navigator.of(context).pushReplacementNamed(
              SafeZoneHome.routeName,
              arguments: ProvidersCouple(man, UserFileManager.of(context)),
            );
          },
        );
      } else {
        setState(
          () {
            _errorString = 'Problems during login. Login aborted. ';
            _onPressedHandler = _onLoginRequest;
          },
        );
      }
    } else {
      setState(
        () {
          _failedLogins++;
          _errorString =
              'Invalid user name or password. Retry or see the login info page for more details.';
          _onPressedHandler = _onLoginRequest;
        },
      );
    }
  }

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
        _onPressedHandler = null;
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

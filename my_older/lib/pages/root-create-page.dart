import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:myolder/pages/newuser-info-page.dart';

import '../constructs/myolder-user.dart';
import '../managers/user-file-manager.dart';
import '../pages/login-page.dart';
import '../managers/safe-file-manager.dart';
import '../constructs/status-text-indicator.dart';
import '../dialogs/save-informations-dialog.dart';

class RootCreatePage extends StatefulWidget {
  /// The page name
  static const String routeName = '/create';

  @override
  State<StatefulWidget> createState() => _RootCreatePageState();
}

class _RootCreatePageState extends State<RootCreatePage> {
  // Spazio tra i controlli attuale
  var spaceBetween = 30.0;

  // Determina se nascondere la password
  bool hidePassword = true;

  // Controllore del nome utente
  var _userController = TextEditingController();

  // Controller password
  var _passController = TextEditingController();

  // The internal message
  StatusTextIndicator _internalMessage;

  /// Called when the keyboard is shown
  void _onKeyboardShow() {
    setState(() {
      spaceBetween = 5;
    });
  }

  /// Called when the keyboard is hidden
  void _onKeyboardHide() {
    setState(() {
      spaceBetween = 30;
    });
  }

  @override
  void initState() {
    super.initState();
    // Keyboard listeners
    KeyboardVisibilityNotification().addNewListener(
      onShow: _onKeyboardShow,
      onHide: _onKeyboardHide,
    );

    _userController.addListener(() {
      _checkNewUserCredentials();
    });

    _passController.addListener(() {
      _checkNewUserCredentials();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format the internal message
    _internalMessage = StatusTextIndicator.stateful(
        'The user informations will be used for controlling the safe-zone access. ',
        StatusType.Success);

    // Simplify
    final theme = Theme.of(context);

    // Pre build app bar to have its size
    final appBar = _buildAppBar();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Expanded(
          // width: media.size.width,
          // height: media.size.height - (appBar.preferredSize.height),
          child: Column(
            children: [
              _buildHeader(),
              _buildConditionalMessage(),
              _buildRootCredentialsInput(),
              _buildCreateRootButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the [_internalMessage] for  displaying an optional
  /// error message or information message
  Widget _buildConditionalMessage() {
    final theme = Theme.of(context);

    return _internalMessage.getText().isNotEmpty
        ? FittedBox(
            child: Text(
              _internalMessage.getText(),
              textAlign: TextAlign.center,
              style: (_internalMessage.isSuccessMessage())
                  ? theme.textTheme.headline2
                  : theme.textTheme.overline,
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  /// Builds the [appBar] for this page
  AppBar _buildAppBar() {
    // Simplify
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Text(
        'Add new user',
        style: theme.appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.info,
            size: theme.appBarTheme.actionsIconTheme.size,
            color: theme.appBarTheme.actionsIconTheme.color,
          ),
          onPressed: () =>
              Navigator.pushNamed(context, NewUserInfoPage.routeName),
        ),
      ],
    );
  }

  Widget _buildCreateRootButton() {
    final media = MediaQuery.of(context);
    final landscape = media.orientation == Orientation.landscape;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: media.size.width * (landscape ? 0.20 : 0.30),
      height: media.size.height * (landscape ? 0.10 : 0.06),
      child: TextButton.icon(
        onPressed: _onCreateRequest,
        icon: const Icon(
          Icons.edit,
        ),
        label: const Text(
          'Create user',
        ),
      ),
    );
  }

  /// Builds the root credentials input boxes
  Widget _buildRootCredentialsInput() {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: media.size.height * 0.03,
        horizontal: media.size.width * 0.05,
      ),
      child: Column(
        children: [
          TextField(
            controller: _userController,
            decoration: InputDecoration(
              labelText: 'User name',
              prefixIcon: Icon(
                Icons.person_add,
                size: theme.iconTheme.size,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: media.size.height * 0.05),
            child: TextField(
              obscureText: hidePassword,
              keyboardType: TextInputType.text,
              controller: _passController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, size: theme.iconTheme.size),
                suffix: IconButton(
                  icon: Icon(
                    hidePassword == true
                        ? Icons.remove_red_eye
                        : Icons.security,
                    size: theme.iconTheme.size,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() => hidePassword = !hidePassword);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the header of the page
  Widget _buildHeader() {
    // Simplify
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: media.size.width * 0.05,
          vertical: media.size.height * 0.03),
      child: Text(
        'Insert the new user informations below',
        style: theme.textTheme.headline1,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Checks the new user credentials added into the boxes and shows state
  void _checkNewUserCredentials() {}

  /// Performs the operations for creating the new user
  Future<void> _onCreateRequest() async {
    // Show the alert dialog
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SaveInformationsDialog(
            content: 'The new user will be created. Do you wish to continue? ',
            title: 'New user creation',
            onDialogAccepted: _onNewUserAccepted,
            onDialogCanceled: _onNewUserCanceled,
          );
        },
      ),
    );
    // Switch to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          banner: MaterialBanner(
            content: const Text('New user successfully created. '),
            actions: [],
          ),
        ),
      ),
    );
  }

  /// Called when the user cancels the [SaveInformationsDialog]
  void _onNewUserCanceled() {
    // Hide this dialog
    Navigator.of(context).pop();
  }

  /// Called when the user accepts the [SaveInformationsDialog]
  void _onNewUserAccepted() {
    Navigator.pop(context);

    final createUser = MyOlderUser(
      name: _userController.text,
      password: _passController.text,
    );

    // Start the saving of the content
    var manager = UserFileManager(file: 'root.cfg', user: createUser);
    manager.writeFile();

    // Configure the safe directory and the configuration file
    var configurator = SafeFileManager(
      user: createUser,
      safeDirectory: 'safe-dir',
    );
    configurator.configureSafeDirectory();
    // Save all the informations
    configurator.saveInformations();
  }
}

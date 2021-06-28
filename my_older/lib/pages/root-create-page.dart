import 'package:flutter/material.dart';
import 'package:myolder/pages/newuser-info-page.dart';

import '../constructs/myolder-user.dart';
import '../providers/user-file-manager.dart';
import '../pages/login-page.dart';
import '../providers/safe-file-manager.dart';
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

  @override
  void initState() {
    super.initState();

    _userController.addListener(() {});

    _passController.addListener(() {});
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
        child: Column(
          children: [
            _buildHeader(),
            _buildConditionalMessage(),
            _buildRootCredentialsInput(),
            _buildCreateRootButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the [_internalMessage] for  displaying an optional
  /// error message or information message
  Widget _buildConditionalMessage() {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return _internalMessage.getText().isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.05),
            child: Text(
              _internalMessage.getText(),
              textAlign: TextAlign.center,
              style: (_internalMessage.isSuccessMessage())
                  ? theme.textTheme.headline6
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

  /// Builds the button to actually create the user
  Widget _buildCreateRootButton() {
    final media = MediaQuery.of(context);
    final landscape = media.orientation == Orientation.landscape;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: media.size.width * (landscape ? 0.20 : 0.30),
      height: media.size.height * (landscape ? 0.10 : 0.06),
      child: TextButton.icon(
        onPressed: () => _onCreateRequest(),
        icon: const Icon(
          Icons.edit,
        ),
        label: const FittedBox(
          child: const Text(
            'Create user',
          ),
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

  /// Performs the operations for creating the new user
  Future<void> _onCreateRequest() async {
    final name = _userController.text;
    final pass = _passController.text;

    if (name == null || pass == null)
      _onNoCredentialsWritten();
    else if (name.isEmpty || pass.isEmpty)
      _onNoCredentialsWritten();
    else if (name.contains(' '))
      _onNameContainsSpaces();
    else if (pass.contains(' '))
      _onPasswordContainsSpaces();
    else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return SaveInformationsDialog(
              content:
                  'The new user will be created. Do you wish to continue? ',
              title: 'New user creation',
              onDialogAccepted: _onNewUserAccepted,
              onDialogCanceled: _onNewUserCanceled,
            );
          },
        ),
      );
      // Switch to the login page
      Navigator.of(context).pushReplacementNamed(
        LoginPage.routeName,
        arguments: true,
      );
    }
  }

  /// Executed when there aren't the user credentials
  void _onNoCredentialsWritten() => setState(() {
        _internalMessage.changeText(
            'No credentials written! The user can\'t be with an empty name or password. ',
            status: StatusType.Error);
      });

  /// Executed when the username contains some spaces
  void _onNameContainsSpaces() => setState(() {
        _internalMessage.changeText(
            'The username can\'t contain spaces. Try removing them or using _',
            status: StatusType.Error);
      });

  /// Executed when the username contains some spaces
  void _onPasswordContainsSpaces() => setState(() {
        _internalMessage.changeText(
            'The password can\'t contain spaces. Try removing them or using _',
            status: StatusType.Error);
      });

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
    final manager =
        UserFileManager(rootFile: 'root.cfg', safeFolder: 'safe-dir');
    manager.user = createUser;

    manager.writeFile(false);

    // Configure the safe directory and the configuration file
    var configurator = SafeFileManager(
      allowedUser: createUser,
      safeDirectory: 'safe-dir',
    );
    configurator.configureSafeDirectory();
    // Save all the informations
    configurator.saveInformations();
  }
}

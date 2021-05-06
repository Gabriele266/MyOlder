import 'package:flutter/material.dart';
import '../user-file-manager.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'package:myolder/myolder-user.dart';
import 'package:myolder/pages/login-page.dart';
import 'package:myolder/safe-file-manager.dart';
import 'package:myolder/widgets/icon-text-button.dart';
import 'package:myolder/constructs/status-text-indicator.dart';

class RootCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootCreatePageState();
}

// TODO: Make RootCreatePage page responsive and adaptive
class _RootCreatePageState extends State<RootCreatePage> {
  // Spazio tra i controlli attuale
  var spaceBetween = 30.0;

  // Determina se nascondere la password
  bool hidePassword = true;

  // Informazioni create
  var _user = MyOlderUser();

  // Controllore del nome utente
  var _userController = TextEditingController();

  // Controller password
  var _passController = TextEditingController();

  // The internal message
  StatusTextIndicator _internalMessage;

  @override
  void initState() {
    super.initState();
    // Keyboard listeners
    KeyboardVisibilityNotification().addNewListener(onShow: () {
      setState(() {
        spaceBetween = 5;
      });
    }, onHide: () {
      setState(() {
        spaceBetween = 30;
      });
    });

    _userController.addListener(() {
      _user.name = _userController.text;
      checkNewUserCredentials();
    });

    _passController.addListener(() {
      _user.password = _passController.text;
      checkNewUserCredentials();
    });
  }

  // TODO: Optimize build function using final variables for [Theme.of] and [MediaQuery.of]
  @override
  Widget build(BuildContext context) {
    // Format the internal message
    _internalMessage = StatusTextIndicator.stateful(
        'The user informations will be used for controlling the safe-zone access. ',
        StatusType.Success);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Add new user',
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              size: Theme.of(context).appBarTheme.actionsIconTheme.size,
              color: Theme.of(context).appBarTheme.actionsIconTheme.color,
            ),
            onPressed: () => Navigator.pushNamed(context, '/create/info'),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'Insert the new user informations below',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  // TODO: Implement use of multistate text
                  _internalMessage.getText(),
                  textAlign: TextAlign.center,
                  style: (_internalMessage.isSuccessMessage())
                      ? Theme.of(context).textTheme.headline2
                      : Theme.of(context).textTheme.overline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                right: 20,
                bottom: 20,
              ),
              child: TextField(
                controller: _userController,
                // TODO: Use Theme decoration instead of custom one
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: 'User name',
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  prefixIcon: Icon(
                    Icons.person_add,
                    size: Theme.of(context).iconTheme.size,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: spaceBetween,
                left: 10,
                right: 20,
              ),
              child: TextField(
                obscureText: hidePassword,
                keyboardType: TextInputType.text,
                controller: _passController,
                // TODO: Use Theme decoration instead of custom one
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10),
                    ),
                  ),
                  labelText: 'Password',
                  prefixIcon:
                      Icon(Icons.lock, size: Theme.of(context).iconTheme.size),
                  suffix: SizedBox(
                    width: 40,
                    height: 30,
                    child: IconButton(
                      icon: Icon(
                        hidePassword == true
                            ? Icons.remove_red_eye
                            : Icons.security,
                        size: Theme.of(context).iconTheme.size,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() => hidePassword = !hidePassword);
                      },
                    ),
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                width: 180,
                height: 60,
                child: IconTextButton(
                  text: 'Create user',
                  icon: const Icon(
                    Icons.create,
                    size: 20,
                    color: Colors.white,
                  ),
                  callback: createNewUser,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks the new user credentials added into the boxes and shows state
  void checkNewUserCredentials() {
    // TODO: Implement multistate text
  }

  /// Performs the operations for creating the new user
  /// TODO: Implement use of separated widget
  Future<void> createNewUser() async {
    // Show the alert dialog
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Saving...',
            ),
            content:
                Text('The following informations will be written:\n\n$_user'),
            actions: [
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.pop(context);
                  // Start the saving of the content
                  final manager =
                      UserFileManager(file: 'root.cfg', user: _user);
                  manager.writeFile();

                  // Configure the safe directory and the configuration file
                  final configurator = SafeFileManager(
                    user: _user,
                    safeDirectory: 'safe-dir',
                  );
                  configurator.configureSafeDirectory();
                  // Save all the informations
                  configurator.saveInformations();
                },
              ),
            ],
          );
        },
      ),
    );
    // Switch to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          banner: const MaterialBanner(
            content: const Text('New user successfully created. '),
            actions: const [],
          ),
        ),
      ),
    );
  }
}

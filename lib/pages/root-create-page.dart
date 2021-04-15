import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../user-file-manager.dart';
import '../myolder-user.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'newuser-info-page.dart';
import 'login-page.dart';
import '../safe-file-manager.dart';
import 'package:myolder/widgets/icon-text-button.dart';
import 'package:myolder/constructs/status-text-indicator.dart';

class RootCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RootCreatePageState();
  }
}

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
    // Attacco il listener per la tastiera
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

  @override
  Widget build(BuildContext context) {

    // Format the internal message
    _internalMessage = StatusTextIndicator.stateful('The user informations will be used for controlling the safe-zone access. ', StatusType.Success);

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text('Add new user',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              )),
          actions: [
            IconButton(
              icon: Icon(
                Icons.info,
                size: Theme.of(context).appBarTheme.actionsIconTheme.size,
                color: Theme.of(context).appBarTheme.actionsIconTheme.color,
              ),
              onPressed: () {
                // Push the information window
                Navigator.pushNamed(context, '/create/info');
              },
            )
          ],
        ),
        body: Center(
            child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text('Insert the new user informations below',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    // TODO: Implement use of multistate text
                    _internalMessage.getText(),
                    textAlign: TextAlign.center,
                    style: (_internalMessage.isSuccessMessage()) ? Theme.of(context).textTheme.headline2 : Theme.of(context).textTheme.overline,
                  )),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 20),
                child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'User name',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        prefixIcon: Icon(
                          Icons.person_add,
                          size: Theme.of(context).iconTheme.size,
                        )))),
            Padding(
                padding:
                    EdgeInsets.only(top: spaceBetween, left: 10, right: 20),
                child: TextField(
                    obscureText: hidePassword,
                    controller: _passController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock,
                          size: Theme.of(context).iconTheme.size),
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
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            }),
                      ),
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                    ))),

            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                width: 180,
                height: 60,
                child: IconTextButton(
                  text: 'Create user',
                  icon: Icon(
                    Icons.create,
                    size: 20,
                    color: Colors.white,
                  ),
                  callback: createNewUser,
                ),
              )
            )
          ],
        )));
  }

  /// Checks the new user credentials added into the boxes and shows state
  void checkNewUserCredentials(){
    // TODO: Implement multistate text
    // Check username
    // if(_userController.text != ''){
    //   if(!_userController.text.contains(' ')){
    //     // Username is correct
    //     setState(() {
    //       _internalMessage.text = null;
    //     });
    //   }else{
    //     setState(() {
    //       _internalMessage.text = 'The username must not contain spaces. ';
    //       _internalMessage.status = StatusType.Error;
    //       print(_internalMessage);
    //     });
    //   }
    // }else{
    //   setState(() {
    //     _internalMessage.text = 'Please insert a valid username.';
    //     _internalMessage.status = StatusType.Error;
    //     print(_internalMessage);
    //   });
    // }

    // // Check password
    // if(_passController.text != ''){
    //   if(!_passController.text.contains(' ')){
    //     // Username is correct
    //     setState(() {
    //       _internalMessage.text = '';
    //     });
    //   }else{
    //     setState(() {
    //       _internalMessage.text = 'The username must not contain spaces. ';
    //       _internalMessage.status = StatusType.Error;
    //     });
    //   }
    // }else{
    //   setState(() {
    //     _internalMessage.text = 'Please insert a valid username.';
    //     _internalMessage.status = StatusType.Error;
    //   });
    // }
  }

  /// Performs the operations for creating the new user
  Future<void> createNewUser() async {
    // Show the alert dialog
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Saving...',
        ),
        content: Text('The following informations will be written:\n\n$_user'),
        actions: [
          TextButton(
            child: Text('Save'),
            onPressed: () {
              Navigator.pop(context);
              // Start the saving of the content
              var manager = UserFileManager(file: 'root.cfg', user: _user);
              manager.writeFile();

              // Configure the safe directory and the configuration file
              var configurator = SafeFileManager(user: _user, dirName: 'safe-dir');
              configurator.configureSafeDirectory();
              // Save all the informations
              configurator.saveInformations();
            },
          )
        ],
      );
    }));
    // Switch to the login page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginPage(banner: MaterialBanner(
        content: Text(
          'New user successfully created. '
        ),
        actions: [
        ]
      ));
    }));
  }
}

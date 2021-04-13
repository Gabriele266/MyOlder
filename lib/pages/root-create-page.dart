import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../user-file-manager.dart';
import '../myolder-user.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'newuser-info-page.dart';
import 'login-page.dart';
import '../safe-file-manager.dart';

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

  // Controllore della password
  var _passController = TextEditingController();

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
    });

    _passController.addListener(() {
      _user.password = _passController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    'The user informations will be used for controlling the safe-zone access. ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
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
            Padding(
                padding: EdgeInsets.only(top: spaceBetween),
                child: Container(
                    width: 200,
                    height: 60,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        textTheme: Theme.of(context).buttonTheme.textTheme,
                        onPressed: saveInformations,
                        child: Row(
                          children: [
                            Icon(Icons.create,
                                size: Theme.of(context).iconTheme.size,
                                color: Theme.of(context).iconTheme.color),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('Safe informations',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)))
                          ],
                        ))))
          ],
        )));
  }

  /// Performs the operations for saving the informations
  Future<void> saveInformations() async {
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
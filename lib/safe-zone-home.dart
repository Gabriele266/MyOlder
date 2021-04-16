import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'widgets/safe-file-widget.dart';
import 'safe-file.dart';
import 'safe-file-manager.dart';
import 'pages/login-page.dart';
import 'widgets/drawer-long-button.dart';
import 'myolder-user.dart';


class SafeZoneHome extends StatefulWidget {
  // Logged User informations
  final MyOlderUser _user;

  // The safefile manager inherited from other controls
  final SafeFileManager _manager;

  /// Creates a new instance of a safezonehome page with a logged user.
  SafeZoneHome(this._user, this._manager);

  /// Creates the state of this of
  @override
  State<StatefulWidget> createState() => _SafeZoneHome(_user, _manager);
}

class _SafeZoneHome extends State<SafeZoneHome> {
  // Logged user informations
  final MyOlderUser _user;

  // Text edit controller for the input search box
  var _searchController = TextEditingController();

  // Safe file manager
  final SafeFileManager _manager;

  /// Creates a new instance of this state
  _SafeZoneHome(this._user, this._manager);

  /// Initializes the state of the page
  @override
  void initState() {
    // Add an empty listenter
    _searchController.addListener(() {});
    // Init user state informations
    super.initState();

    setState(() {
      // Load widgets
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe zone', style: Theme.of(context).textTheme.headline1),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              size: Theme.of(context).iconTheme.size,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              doLogout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            height: 65,
            child: TextField(
              controller: _searchController,
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.text_format,
                  size: Theme.of(context).iconTheme.size,
                ),
                suffix: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: Theme.of(context).iconTheme.size,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      // Start research for files with this name
                      startSearch(_searchController.text);
                    }),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _manager.safeFilesCount,
              itemBuilder: (context, index) {
                return SafeFileWidget(
                  safeFile: _manager.safeFiles[index],
                  showByTag: (String tag) {},
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: Drawer(
          child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: Text('MyOlder Safe Zone',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: MaterialButton(
              onPressed: () {
                showUserSettings();
              },
              color: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(width: 1.5, color: Colors.black),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(20) - EdgeInsets.only(left: 15),
                    child:
                        Icon(Icons.person, size: 70, color: Colors.tealAccent),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          '${_user.name}',
                          style: Theme.of(context).textTheme.headline4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('Authenticated user'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          DrawerLongButton(
            text: 'Application informations',
            icon: Icon(
              Icons.info,
              size: 20,
              color: Colors.black,
            ),
            callBack: () {
              showApplicationInformations();
            },
          ),
          DrawerLongButton(
            text: 'Settings',
            icon: Icon(
              Icons.settings,
              size: 20,
              color: Colors.black,
            ),
            callBack: () {
              showApplicationSettings();
            },
          ),
          DrawerLongButton(
            text: 'Add new safe file',
            icon: Icon(
              Icons.add,
              size: 20,
              color: Colors.black,
            ),
            callBack: () {
              addNewFile(context);
              Navigator.pop(context);
            },
          ),
          DrawerLongButton(
            text: 'Clear safe zone',
            icon: Icon(Icons.delete, size: 20, color: Colors.black),
            callBack: () {
              clearSafeZone();
            },
          ),
          DrawerLongButton(
            text: 'MyOlder FAQ',
            icon: Icon(Icons.question_answer, size: 20, color: Colors.black),
            callBack: () {
              showApplicationFAQ();
            },
          ),
          DrawerLongButton(
            text: 'Logout',
            icon: Icon(Icons.logout, color: Colors.black, size: 20),
            callBack: () {
              doLogout(context);
            },
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addNewFile(context);
          },
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          child: Icon(
            Icons.add,
            size: Theme.of(context).iconTheme.size + 10,
            color: Theme.of(context).iconTheme.color,
          ),
          splashColor: Theme.of(context).floatingActionButtonTheme.splashColor),
    );
  }

  /// Adds a new file to the safe zone
  Future<void> addNewFile(BuildContext context) async {
    // Get a file from the default file-picker
    FilePickerResult file = await FilePicker.platform
        .pickFiles(withData: true, withReadStream: true);

    if (file != null) {
      // The the single file to add
      PlatformFile object = file.files.first;
      print('File suffix: ${object.extension}');
      // Create the safefile object
      var safe = SafeFile(
        name: object.name,
        suffix: object.extension,
        savePath: '',
        addedDateTime: DateTime.now(),
        color: Colors.blue,
      );

      // Add the file and encrypt it
      _manager.addSafeFile(safe, object.bytes);
      // Set the new state
      setState(() {});
    }
  }

  /// Clears the safezone removing all the files
  Future<void> clearSafeZone() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AlertDialog(
        title: Text('Alert: clear all files?'),
        content: Text(
            'This operation will remove all your data from the disk, this means that you wont be able to access your files anymore. ARE YOU SHURE??'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              // Remove this alert
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Yes i am shure. '),
            onPressed: () {
              _manager.clearAllSafeFiles();
              Navigator.pop(context);
              Navigator.pop(context);
              setState(() {});
            },
          )
        ],
      );
    }));
  }

  /// Shows the application faq
  Future<void> showApplicationFAQ() async {
    // TODO: Implement application faq
  }

  /// Shows the user settings page
  Future<void> showUserSettings() async {
    // TODO: Implement user settings
  }

  /// Shows the application informations
  Future<void> showApplicationInformations() async {
    // TODO: Implement application informations
  }

  /// Shows the application settings
  Future<void> showApplicationSettings() async {
    // TODO: Implement application settings
  }

  /// Starts the research for a file with a given name
  Future<void> startSearch(String search_text) async {
    // TODO: Implement file search by name
    print('Search by name not yet implemented. File name: $search_text');
  }

  /// Executes the logout to the application
  Future<void> doLogout(BuildContext context) async {
    dispose();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  /// Disposes all the resources used by this main page
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

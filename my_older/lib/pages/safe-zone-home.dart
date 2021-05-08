import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../exceptions/element-not-found-exception.dart';
import '../constructs/safe-file.dart';
import '../managers/safe-file-manager.dart';
import './login-page.dart';
import '../widgets/drawer-long-button.dart';
import '../constructs/myolder-user.dart';
import '../widgets/safe-file-list-viewer.dart';
import '../dialogs/clear-all-files-dialog.dart';

class SafeZoneHome extends StatefulWidget {
  // Logged User informations
  final MyOlderUser user;

  // The safefile manager inherited from other controls
  final SafeFileManager manager;

  /// Creates a new instance of a safezonehome page with a logged user.
  ///
  /// [user] The logged user
  /// [manager] The safefile manager
  SafeZoneHome(this.user, this.manager);

  /// Creates the state of this of
  @override
  State<StatefulWidget> createState() => _SafeZoneHome();
}

// TODO: Make _SafeZoneHome responsive and adaptive
class _SafeZoneHome extends State<SafeZoneHome> {
  // Text edit controller for the input search box
  final _searchController = TextEditingController();

  /// Initializes the state of the page
  @override
  void initState() {
    // Init user state informations
    super.initState();
    // Add an empty listenter
    _searchController.addListener(() {});
  }

  /// Builds the [AppBar] for this page
  AppBar _buildAppBar() {
    final theme = Theme.of(context);

    return AppBar(
      centerTitle: true,
      title: Text('Safe zone', style: theme.appBarTheme.titleTextStyle),
      actions: [
        IconButton(
          icon: Icon(
            Icons.logout,
            size: theme.appBarTheme.actionsIconTheme.size,
            color: theme.primaryColorDark,
          ),
          onPressed: () {
            _doLogout(context);
          },
        ),
      ],
    );
  }

  /// Builds the [SearchBox] for this page
  Widget _buildSearchBox() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      height: 65,
      child: TextField(
        controller: _searchController,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.text_format,
            size: theme.primaryIconTheme.size,
          ),
          suffix: IconButton(
              icon: Icon(
                Icons.search,
                size: theme.primaryIconTheme.size,
                color: theme.primaryIconTheme.color,
              ),
              onPressed: () {
                // Start research for files with this name
                _startSearch(_searchController.text);
              }),
        ),
      ),
    );
  }

  // TODO: Optimize device / theme informations fetching with final variables
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBox(),
          SafeFileListViewer(
              files: widget.manager.safeFiles, deleteSafeFile: _deleteSafeFile),
        ],
      ),
      drawer: _buildDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Builds the [FloatingActionButton]
  FloatingActionButton _buildFloatingActionButton() {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () {
        _addNewFile(context);
      },
      backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
      child: Icon(
        Icons.add,
        size: theme.primaryIconTheme.size + 10,
        color: theme.primaryIconTheme.color,
      ),
      splashColor: theme.floatingActionButtonTheme.splashColor,
    );
  }

  /// Builds the [Drawer]
  Drawer _buildDrawer() {
    return Drawer(
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
                _showUserSettings();
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
                          '${widget.user.name}',
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
              _showApplicationInformations();
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
              _showApplicationSettings();
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
              _addNewFile(context);
              Navigator.pop(context);
            },
          ),
          DrawerLongButton(
            text: 'Clear safe zone',
            icon: Icon(Icons.delete, size: 20, color: Colors.black),
            callBack: () {
              _clearSafeZone();
            },
          ),
          DrawerLongButton(
            text: 'MyOlder FAQ',
            icon: Icon(Icons.question_answer, size: 20, color: Colors.black),
            callBack: () {
              _showApplicationFAQ();
            },
          ),
          DrawerLongButton(
            text: 'Logout',
            icon: Icon(Icons.logout, color: Colors.black, size: 20),
            callBack: () {
              _doLogout(context);
            },
          ),
        ],
      ),
    );
  }

  /// Adds a new file to the safe zone
  Future<void> _addNewFile(BuildContext context) async {
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
        path: '',
        dateTime: DateTime.now(),
        color: Colors.blue,
      );

      // Add the file and encrypt it
      widget.manager.addSafeFile(safe, object.bytes);
      // Set the new state
      setState(() {});
    }
  }

  /// Deletes a [file] from the safezone
  void _deleteSafeFile(SafeFile file) {
    try {
      // Search for the file
      final fileIndex = widget.manager.searchSafeFile(file);

      // Set the new state
      setState(() {
        widget.manager.removeSafeFile(fileIndex);
      });
    } on ElementNotFoundException catch (exc) {
      print(
          'Element not found exception. Exception during removing file $file');
      print(exc);
    }
  }

  /// Clears the [SafeZone] removing all the files
  Future<void> _clearSafeZone() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClearAllSafeFilesDialog(_onClearSafeZoneAccepted),
      ),
    );
  }

  /// Called when the user accepts the [ClearAllSafeFilesDialog]
  void _onClearSafeZoneAccepted() {
    widget.manager.clearAllSafeFiles();
    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {});
  }

  /// Shows the application faq
  Future<void> _showApplicationFAQ() async {
    // TODO: Implement application faq
  }

  /// Shows the user settings page
  Future<void> _showUserSettings() async {
    // TODO: Implement user settings
  }

  /// Shows the application informations
  Future<void> _showApplicationInformations() async {
    // TODO: Implement application informations
  }

  /// Shows the application settings
  Future<void> _showApplicationSettings() async {
    // TODO: Implement application settings
  }

  /// Starts the research for a file with a given name
  Future<void> _startSearch(String search_text) async {
    // TODO: Implement file search by name
    print('Search by name not yet implemented. File name: $search_text');
  }

  /// Executes the logout to the application
  Future<void> _doLogout(BuildContext context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    dispose();
  }

  /// Disposes all the resources used by this main page
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}

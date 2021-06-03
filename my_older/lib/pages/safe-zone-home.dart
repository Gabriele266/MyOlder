import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../managers/user-file-manager.dart';

import '../exceptions/element-not-found-exception.dart';
import '../constructs/safe-file.dart';
import '../managers/safe-file-manager.dart';
import '../widgets/drawer-long-button.dart';
import '../constructs/myolder-user.dart';
import '../widgets/safe-file-list-viewer.dart';
import '../widgets/myolder-user-widget.dart';
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

  /// General [build] method, calls all the other private builders
  /// for the various elements of this page. More documentation can
  /// be found into the [homeDocumentation.html] file into the [documentation]
  /// folder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBox(),
          SafeFileListViewer(
            files: widget.manager.safeFiles,
            deleteSafeFile: _deleteSafeFile,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      // drawer: _buildSecondDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
    );
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
    final media = MediaQuery.of(context);

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: media.size.width * 0.08,
          vertical: media.size.height * 0.025,
        ),
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
              onPressed: () =>
                  // Start research for files with this name
                  _startSearch(_searchController.text),
            ),
          ),
        ),
      ),
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

  /// Builds the [Drawer] for this page
  Drawer _buildDrawer() {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: media.size.height * 0.20,
              child: DrawerHeader(
                child: MyOlderUserWidget(
                  safeFilesCount: widget.manager.safeFilesCount,
                  user: widget.user,
                  showUserSettings: () {
                    print('User settings');
                  },
                ),
              ),
            ),
            Divider(
              color: theme.primaryColorDark,
              height: 20,
              indent: media.size.width * 0.05,
              endIndent: media.size.width * 0.05,
            ),
            DrawerListTileButton(
              text: 'Application informations',
              icon: Icons.info,
              callBack: () {
                _showApplicationInformations();
              },
            ),
            DrawerListTileButton(
              text: 'Settings',
              icon: Icons.settings,
              callBack: () {
                _showApplicationSettings();
              },
            ),
            DrawerListTileButton(
              text: 'Add new safe file',
              icon: Icons.add,
              callBack: () {
                _addNewFile(context);
                Navigator.pop(context);
              },
            ),
            DrawerListTileButton(
              text: 'Clear safe zone',
              icon: Icons.delete,
              callBack: () {
                _clearSafeZone();
              },
            ),
            DrawerListTileButton(
              text: 'MyOlder FAQ',
              icon: Icons.question_answer,
              callBack: () {
                _showApplicationFAQ();
              },
            ),
            DrawerListTileButton(
              text: 'Logout',
              icon: Icons.logout,
              callBack: () {
                _doLogout(context);
              },
            ),
          ],
        ),
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
  /// TODO: Avoid passing data via constructor
  Future<void> _doLogout(BuildContext context) async {
    UserFileManager.of(context).logout();
  }

  /// Disposes all the resources used by this main page
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}

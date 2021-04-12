import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'widgets/safe-file-widget.dart';
import 'safe-file.dart';
import 'safe-file-manager.dart';
import 'pages/login-page.dart';
import 'myolder-user.dart';

class SafeZoneHome extends StatefulWidget {
  // Logged User informations
  final MyOlderUser _user;

  /// Creates a new instance of a safezonehome page with a logged user.
  SafeZoneHome(this._user);

  @override
  State<StatefulWidget> createState() {
    return _SafeZoneHome(_user);
  }
}

class _SafeZoneHome extends State<SafeZoneHome> {
  // Logged user informations
  final MyOlderUser _user;
  var _searchController = TextEditingController();

  // SafeFileManager
  SafeFileManager _fileManager;

  _SafeZoneHome(this._user);

  /// Initializes the state of the page
  @override
  void initState() {
    // Add an empty listenter
    _searchController.addListener(() {});
    // Init user state informations
    _fileManager = SafeFileManager(user: _user, dirName: 'safe-dir');
    super.initState();
  }

  /// Carica la lista dei file da mostrare e gestire nella safe zone
  Future<void> loadSafeFilesList() {
    // TODO: Implement loading files from container file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('Safe zone', style: Theme.of(context).textTheme.headline1),
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
            )
          ],
        ),
        body: Column(
          children: [
            Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                            borderSide:
                                BorderSide(color: Colors.black, width: 1))))),
            Expanded(
                child: ListView.builder(
                    itemCount: _fileManager.safeFilesCount,
                    itemBuilder: (context, index) {
                      return SafeFileWidget(
                          _fileManager.safeFiles[index], (String tag) {});
                    }))
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
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
            splashColor:
                Theme.of(context).floatingActionButtonTheme.splashColor));
  }

  /// Adds a new file to the safe zone
  Future<void> addNewFile(BuildContext context) async {
    // Get a file from the default file-picker
    FilePickerResult file = await FilePicker.platform
        .pickFiles(withData: true, withReadStream: true);

    if (file != null) {
      // The the single file to add
      PlatformFile object = file.files.first;
      // Create the safefile object
      var safe = SafeFile(
        name: object.name,
        savePath: '',
        addedDateTime: DateTime.now(),
        color: Colors.blue,
      );

      // Add the file and encrypt it
      _fileManager.addSafeFile(safe, object.bytes);
      // Set the new state
      setState(() {});
    }
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

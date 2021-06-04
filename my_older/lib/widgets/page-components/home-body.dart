import 'package:flutter/material.dart';

import '../../exceptions/element-not-found-exception.dart';
import '../../constructs/safe-file.dart';
import '../../providers/safe-file-manager.dart';
import '../safe-files/safe-file-list-viewer.dart';
import '../../dialogs/clear-all-files-dialog.dart';

class SafeZoneHomeBody extends StatefulWidget {
  /// Creates the state of this of
  @override
  State<StatefulWidget> createState() => _SafeZoneHomeBody();
}

class _SafeZoneHomeBody extends State<SafeZoneHomeBody> {
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
    return Column(
      children: [
        _buildSearchBox(),
        SafeFileListViewer(),
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

  /// Starts the research for a file with a given name
  Future<void> _startSearch(String search_text) async {
    // TODO: Implement file search by name
    print('Search by name not yet implemented. File name: $search_text');
  }

  /// Deletes a [file] from the safezone
  void _deleteSafeFile(SafeFile file) {
    try {
      // Search for the file
      final fileIndex = SafeFileManager.of(context).searchSafeFile(file);

      // Set the new state
      setState(() {
        SafeFileManager.of(context).removeSafeFile(fileIndex);
      });
    } on ElementNotFoundException catch (exc) {
      print(
          'Element not found exception. Exception during removing file $file');
      print(exc);
    }
  }

  

  /// Called when the user accepts the [ClearAllSafeFilesDialog]
  void _onClearSafeZoneAccepted() {
    SafeFileManager.of(context).clearAllSafeFiles();
    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {});
  }

  
  /// Disposes all the resources used by this main page
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}

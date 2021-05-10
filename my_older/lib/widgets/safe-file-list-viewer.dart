import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../constructs/safe-file.dart';
import './safe-file-widget.dart';

class SafeFileListViewer extends StatelessWidget {
  // The files to display
  final List<SafeFile> files;

  // Function to call for deleting a safefile
  final void Function(SafeFile) deleteSafeFile;

  /// Creates a new instance of a [SafeFileListViewer]
  ///
  /// [files] The list of files to display
  /// [deleteSafeFile] The function to call for deleting a [SafeFile]
  SafeFileListViewer({
    Key key,
    @required this.files,
    @required this.deleteSafeFile,
  }) : super(key: key);

  /// Builds the list view, when there are items to display
  Widget _buildListView() {
    return Scrollbar(
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: files.length,
        itemBuilder: (context, index) {
          return SafeFileWidget(
            safeFile: files[index],
            showByTag: (String tag) {},
            deleteSafeFile: deleteSafeFile,
          );
        },
      ),
    );
  }

  /// Builds some information informing the user that there aren't [SafeFiles] into the
  /// [SafeZone].
  Widget _buildNoFilesView(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No files into the safe zone!! Add one!',
          style: theme.textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        Image(
          image: AssetImage('images/nofiles.png'),
          width: media.size.width * 0.7,
          height: media.size.height * 0.3,
          color: theme.primaryColorLight,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: (files != null && files.length > 0)
          ? _buildListView()
          : _buildNoFilesView(context),
    );
  }
}

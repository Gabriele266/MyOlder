import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/safe-file-manager.dart';
import 'safe-file-widget.dart';

class SafeFileListViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: (SafeFileManager.of(context).safeFiles != null &&
              SafeFileManager.of(context).safeFiles.length > 0)
          ? _buildListView(context)
          : _buildNoFilesView(context),
    );
  }

  /// Builds the list view, when there are items to display
  Widget _buildListView(BuildContext context) {
    final manager = SafeFileManager.of(context);

    return Scrollbar(
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: manager.safeFiles.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: manager.safeFiles[index],
            child: SafeFileWidget(
              showByTag: (String tag) {},
            ),
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

  
}

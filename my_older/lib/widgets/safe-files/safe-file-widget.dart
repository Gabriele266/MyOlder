import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myolder/global/colors.dart';
import 'package:provider/provider.dart';

import '../../constructs/safe-file.dart';
import '../../modals/safe-file-info-modal.dart';
import '../../providers/safe-file-manager.dart';

// FIXME: Fix NoSuchMethodError when displaying the details page
class SafeFileWidget extends StatefulWidget {
  // A function to show widgets by tag
  final void Function(String) showByTag;

  /// Creates a new [SafeFileWidget] to display informations about a [SafeFile]
  ///
  /// [showByTag] The function to display the files by tag
  SafeFileWidget({
    this.showByTag,
  });

  @override
  State<StatefulWidget> createState() => _SafeFileWidgetState();
}

class _SafeFileWidgetState extends State<SafeFileWidget> {
  /// General [build] method. Constructs this widget
  /// More informations about this widget can be found into the
  /// [SafeFileWidget.html] file.
  @override
  Widget build(BuildContext context) {
    final file = SafeFile.of(context, listen: false);

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: media.size.width * 0.05,
        vertical: media.size.height * 0.01,
      ),
      child: ListTile(
        leading: const Icon(Icons.file_present),
        onTap: _onWidgetPressed,
        onLongPress: () => _showInfo(file),
        title: Text(
          file.name,
          style: theme.textTheme.headline3,
        ),
        shape: theme.buttonTheme.shape,
        subtitle: Text(DateFormat.yMd().format(file.dateTime)),
        tileColor: CustomColors.redAccent,
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: theme.errorColor,
            size: theme.primaryIconTheme.size,
          ),
          onPressed: _deleteFile,
        ),
      ),
    );
  }

  /// Handles the pression of this widget
  ///
  /// When this widget is pressed, the [safeFile] is unlocked and opened using the
  /// system viewer. Lib: [OpenFile].
  void _onWidgetPressed() {
    SafeFile.of(context, listen: false).unlockAndOpen(context);
  }

  /// Shows the informations relative to this [safeFile]
  void _showInfo(SafeFile file) {
    var safeFile = SafeFile.of(context);
    var fManager = SafeFileManager.of(context, listen: false);
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(media.size.width * 0.1),
        side: BorderSide(
          color: theme.primaryColorDark,
          width: 2,
        ),
      ),
      builder: (context) => ChangeNotifierProvider.value(
        value: fManager,
        child: ChangeNotifierProvider.value(
          value: safeFile,
          child: SafeFileInfoModal(),
        ),
      ),
    );
  }

  /// Deletes this [safeFile]
  ///
  void _deleteFile() {
    SafeFileManager.of(context, listen: false)
        .removeSafeFile(SafeFile.of(context));
  }
}

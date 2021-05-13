import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constructs/safe-file.dart';
import './tag-widget.dart';
import '../modals/safe-file-info-modal.dart';

// FIXME: Fix NoSuchMethodError when displaying the details page
class SafeFileWidget extends StatefulWidget {
  // The file to show widget for
  final SafeFile safeFile;

  // A function to show widgets by tag
  final void Function(String) showByTag;

  // Function to delete this widget
  final void Function(SafeFile) deleteSafeFile;

  /// Creates an instance of a new SafeFileWidget
  ///
  /// This instance represents a widget to display informations about a safe file.
  /// [safeFile] The file to show informations on
  /// [showByTag] The function to call for showing all the widget by their tag
  /// [deleteSafeFile] The function to call for deleting this safefile
  SafeFileWidget({
    @required this.safeFile,
    this.showByTag,
    this.deleteSafeFile,
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
    // Load a list with the showable tags
    const List<TagWidget> tagWidgets = [];

    // Check if file has tags
    if (widget.safeFile.hasTags()) {
      for (int x = 0; x < 2; x++) {
        if (widget.safeFile.existsTag(x)) {
          tagWidgets.add(
            TagWidget(
              showByTag: widget.showByTag,
              tag: widget.safeFile.tags[x],
            ),
          );
        }
      }
    }

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
        onLongPress: _showInfoPage,
        title: Text(widget.safeFile.name, style: theme.textTheme.headline3),
        shape: theme.buttonTheme.shape,
        subtitle: Text(DateFormat.yMd().format(widget.safeFile.dateTime)),
        tileColor: theme.primaryColor,
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
    widget.safeFile.unlockAndOpen();
  }

  /// Shows the informations page relative to this [safeFile]
  void _showInfoPage() => showModalBottomSheet(
        context: context,
        builder: (context) => SafeFileInfoModal(widget.safeFile),
        backgroundColor: Theme.of(context).backgroundColor,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 2 * MediaQuery.of(context).textScaleFactor,
          ),
        ),
      );

  /// Deletes this [safeFile]
  ///
  void _deleteFile() {
    widget.deleteSafeFile(widget.safeFile);
  }
}

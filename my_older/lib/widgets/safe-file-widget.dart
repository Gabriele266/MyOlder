import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../pages/safe-file-info-page.dart';
import '../constructs/safe-file.dart';
import './tag-widget.dart';
import '../formatters/date-time-formatter.dart';

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

  // TODO: Avoid this horrible pattern
  @override
  State<StatefulWidget> createState() => _SafeFileWidgetState(
        safeFile: safeFile,
        showByTag: showByTag,
        deleteSafeFile: deleteSafeFile,
      );
}

class _SafeFileWidgetState extends State<SafeFileWidget> {
  SafeFile safeFile;
  final void Function(String) showByTag;
  final void Function(SafeFile) deleteSafeFile;

  /// Creates a new instance of the state for the safe file widget
  ///
  /// [safeFile] Represents the file to show informations for. <br>
  /// [showByTag] represents a function to call to order other widgets by tag <br>
  _SafeFileWidgetState({
    @required this.safeFile,
    this.showByTag,
    this.deleteSafeFile,
  });

  // TODO: Switch to ListTile for displaying informations
  // TODO: Optimize theme fetching using final variables
  // TODO: Make this widget responsive
  // TODO: Use 'const' where possible
  @override
  Widget build(BuildContext context) {
    // Load a list with the showable tags
    const List<TagWidget> tagWidgets = [];

    // Check if file has tags
    if (safeFile.hasTags()) {
      for (int x = 0; x < 2; x++) {
        if (safeFile.existsTag(x)) {
          tagWidgets.add(
            TagWidget(
              showByTag: showByTag,
              tag: safeFile.tags[x],
            ),
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        width: 360,
        height: 120,
        child: MaterialButton(
          onPressed: onWidgetPressed,
          color: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20),
            ),
            side: const BorderSide(width: 1, color: Colors.black),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Icon(
                  Icons.file_present,
                  size: Theme.of(context).iconTheme.size * 1.5,
                  color: Colors.tealAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        safeFile.name,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline3,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 150,
                        child: Center(
                          child: Text(
                            DateTimeFormatter.onlyDate(
                              safeFile.addedDateTime,
                            ).format(),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 18),
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: tagWidgets,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: Theme.of(context).iconTheme.size,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: showInfoPage,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: Theme.of(context).iconTheme.size,
                      color: Colors.red,
                    ),
                    onPressed: deleteFile,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Make onWidgetPressed private
  void onWidgetPressed() {
    safeFile.unlockAndOpen();
  }

  /// Shows the informations page relative to this file
  // TODO: Make showInfoPage private
  // TODO: Switch to a modalbottomdialog instead of creating a new standalone page
  void showInfoPage() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SafeFileInfoPage(
            file: safeFile,
          ),
        ),
      );

  /// Deletes this file
  /// 
  /// TODO: Make deleteFile private
  void deleteFile() {
    deleteSafeFile(safeFile);
  }
}

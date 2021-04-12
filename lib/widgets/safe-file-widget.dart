import '../pages/safe-file-info-page.dart';
import 'package:flutter/material.dart';
import '../safe-file.dart';
import 'tag-widget.dart';

class SafeFileWidget extends StatefulWidget {
  // The file to show widget for
  final SafeFile _safeFile;

  // A function to show widgets by tag
  final void Function(String) _showByTag;

  /// Creates an instance of a new SafeFileWidget
  ///
  /// This instance represents a widget to display informations about a safe file.
  /// Parameter safeFile It represents the file from witch it sould take all the informations.
  SafeFileWidget(this._safeFile, this._showByTag);

  @override
  State<StatefulWidget> createState() {
    return _SafeFileWidgetState(file: _safeFile, showByTagFunction: _showByTag);
  }
}

class _SafeFileWidgetState extends State<SafeFileWidget> {
  SafeFile _safeFile;
  void Function(String) _showByTag;

  /// Creates a new instance of the state for the safe file widget
  ///
  /// [file] Represents the file to show informations for. <br>
  /// [showByTagFunction] represents a function to call to order other widgets by tag <br>
  _SafeFileWidgetState(
      {@required SafeFile file, void Function(String) showByTagFunction}) {
    _safeFile = file;
    _showByTag = showByTagFunction;
  }

  @override
  Widget build(BuildContext context) {
    // Load a list with the showable tags
    List<TagWidget> tagWidgets = [];
    // Check if file has tags
    if (_safeFile.hasTags()) {
      for (int x = 0; x < 2; x++) {
        if (_safeFile.existsTag(x)) {
          tagWidgets.add(TagWidget(_showByTag, _safeFile.tags[x]));
        }
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: 360,
        height: 120,
        child: MaterialButton(
            onPressed: onWidgetPressed,
            color: Colors.grey[800],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(width: 1, color: Colors.black)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Icon(Icons.file_present,
                      size: Theme.of(context).iconTheme.size * 1.5,
                      color: Colors.tealAccent),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 220,
                          child: Text(
                            _safeFile.formatVisibleName(18),
                            style: Theme.of(context).textTheme.headline3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(_safeFile.savePath,
                              style: Theme.of(context).textTheme.headline4),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 18),
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: tagWidgets,
                            ))
                      ],
                    )),
                Expanded(child: Text('')),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search,
                          size: Theme.of(context).iconTheme.size,
                          color: Theme.of(context).iconTheme.color),
                      onPressed: showInfoPage,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: Theme.of(context).iconTheme.size,
                        color: Colors.red,
                      ),
                      onPressed: deleteFile,
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void onWidgetPressed() {
    print('Required open file. FileName: ${_safeFile.name}');
    // TODO: Implement open file and unlock it
  }

  /// Shows the informations page relative to this file
  void showInfoPage() {
    // Show the informations page
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SafeFileInfoPage(_safeFile);
    }));
  }

  /// Deletes this file
  void deleteFile() {
    print('Required delete file. FileName: ${_safeFile.name}');
    // TODO: Implement delete file
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constructs/safe-file.dart';
import '../widgets/infoproperty-line-action.dart';
import '../widgets/infoproperty-line.dart';
import '../widgets/metal-panel.dart';
import '../widgets/tag-widget.dart';

class SafeFileInfoPage extends StatefulWidget {
  final SafeFile file;

  /// Creates a new instance of the class SafeFileInfoPage, that shows the informations <br>
  /// about a SafeFile.
  ///
  /// [file] The file to show informations on
  SafeFileInfoPage({@required this.file});

  @override
  State<StatefulWidget> createState() => _SafeFileInfoPageState(file);
}

class _SafeFileInfoPageState extends State<StatefulWidget> {
  // File to show informations for
  final SafeFile _file;

  // TextEditingController
  TextEditingController controller;

  /// Initializes a new instance of a page to show informations about a safe file
  ///
  /// The file should be given and shouldn't be null.
  _SafeFileInfoPageState(this._file) {
    // Create the textediting controller and give it an initial value text
    controller = TextEditingController(text: _file.description);
    controller.addListener(() {});
  }

  /// TODO: Implement function to show files by tag in main view
  @override
  Widget build(BuildContext context) {
    String description;
    if (_file.description != null)
      description = _file.description;
    else
      description = "";

    if (_file != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('File details',
              style: Theme.of(context).textTheme.headline1),
        ),
        body: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image(
                  image: AssetImage('images/magnify.png'),
                ),
              ),
              ListView(
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 20,
                  left: 30,
                  right: 30,
                ),
                children: [
                  MetalPanelContainer(
                    titleTopMargin: 20,
                    title: Text(
                      'Details',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                            bottom: 30,
                          ),
                          child: Column(
                            children: [
                              InfoPropertyLine(
                                name: 'Name',
                                value: _file.name,
                              ),
                              InfoPropertyLine(
                                name: 'Path',
                                value: _file.savePath,
                              ),
                              InfoPropertyLineAction(
                                name: 'Info',
                                value: description,
                                actionIcon: Icon(
                                  Icons.edit,
                                  size: Theme.of(context).iconTheme.size,
                                ),
                                overlayWidget: TextField(
                                  maxLines: 4,
                                  controller: controller,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      ),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                overlayIcon: Icon(
                                  Icons.check,
                                  size: Theme.of(context).iconTheme.size,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onOverlayPerformed: (name, value) {
                                  // Give informations about the accepted text
                                  print('Overlay accepted: ${controller.text}');
                                  // Set it as new
                                  setState(
                                    () => _file.description = controller.text,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MetalPanelContainer(
                    child: Column(
                      children: [
                        InfoPropertyLine(
                          name: 'Date',
                          value: DateFormat.yMd().format(_file.addedDateTime),
                        ),
                        InfoPropertyLine(
                          name: 'Time',
                          value: DateFormat.Hm().format(_file.addedDateTime),
                        ),
                        InfoPropertyLine(
                          name: 'Suffix',
                          value: _file.suffix,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 30),
                  ),
                  MetalPanelContainer(
                    title: Text(
                      'Tags',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    child: Column(
                      children: (_file.tags.isNotEmpty)
                          ? _file.tags.map((tag) {
                              return TagWidget(
                                tag: tag,
                                showByTag: null,
                              );
                            }).toList()
                          : [
                              InfoPropertyLine(
                                name: 'Tags',
                                value: 'No tags provided. Add one!',
                              ),
                            ],
                    ),
                    margin: const EdgeInsets.only(top: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    // Throw exception
    throw NullFileException(' ');
  }
}

/// Represents an exception thrown when a null file is passed to this widget
class NullFileException implements Exception {
  String _text;

  NullFileException(this._text);

  @override
  String toString() =>
      'NullFileException: A null file was passed to a SafeFileInfoPage. $_text';
}

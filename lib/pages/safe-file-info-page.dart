import '../widgets/infoproperty-line-action.dart';
import '../widgets/infoproperty-line.dart';
import 'package:flutter/material.dart';
import '../safe-file.dart';
class SafeFileInfoPage extends StatefulWidget{
  final SafeFile _file;

  /// Creates a new instance of the class SafeFileInfoPage, that shows the informations <br>
  /// about a SafeFile.
  SafeFileInfoPage(this._file);

  @override
  State<StatefulWidget> createState(){
    return _SafeFileInfoPageState(_file);
  }
}

class _SafeFileInfoPageState extends State<StatefulWidget> {
  // File to show informations for
  final SafeFile _file;
  // TextEditingController
  var controller;

  /// Initializes a new instance of a page to show informations about a safe file
  ///
  /// The file should be given and shouldn't be null.
  _SafeFileInfoPageState(this._file){
    // Create the textediting controller and give it an initial value text
    controller = TextEditingController(text: _file.description);
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    String description;
    if(_file.description != null)
      description = _file.description;
    else
      description = "";

    if (_file != null) {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
              title: Text('File details',
                  style: Theme.of(context).textTheme.headline1)),
          body: Center(
              child: Stack(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Image(image: AssetImage('images/magnify.png')),
            ),
            ListView(
              padding:
                  EdgeInsets.only(top: 40, bottom: 20, left: 30, right: 30),
              children: [
                Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    color: Theme.of(context).canvasColor,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Details',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 30),
                          child: Column(
                            children: [
                              InfoPropertyLine('Name', _file.name),
                              InfoPropertyLine('Path', _file.savePath),
                              // InfoPropertyLine('Added time', _file.addedDateTime())
                              InfoPropertyLineAction(
                                name: 'Info',
                                value: description,
                                actionIcon: Icon(
                                    Icons.edit,
                                    size: Theme.of(context).iconTheme.size
                                ),
                                overlay: TextField(
                                    maxLines: 4,
                                    controller: controller,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2)))
                                ),
                                overlayIcon: Icon(
                                  Icons.check,
                                  size: Theme.of(context).iconTheme.size,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onOverlayPerformed: (name, value){
                                  // Give informations about the accepted text
                                  print('Overlay accepted: ${controller.text}');
                                  // Set it as new
                                  setState(() {
                                    _file.description = controller.text;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ])));
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

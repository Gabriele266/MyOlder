import 'package:xml/xml.dart';
import 'formatters/rgb-color-formatter.dart';
import 'package:flutter/material.dart';
import 'formatters/date-time-formatter.dart';

/// Represents a protected file into the application
class SafeFile {
  // File name
  String _name;

  // File description
  String _description;

  // Creation time
  DateTime _addedDateTime;

  // Associated color
  Color _color;

  // path of the saved file
  String _savePath;

  // List of file tags
  List<String> _tags;

  // File access password
  String _password;

  /// Creates a new instance of a safe file
  ///
  /// This instance represents a file that is protected into the application <br>
  /// all the files are encrypted using aes encryption method. <br>
  /// [name] : A string that contains the name of the file <br>
  /// [savePath] : The original file path (the file will be moved into a safe zone) <br>
  /// [description] : An optional description to assign at the file <br>
  /// [color] : A label color to tag this file <br>
  /// [addedDateTime] : A datetime instance that represents the time when the file was added (if not given it will be the current date <b>
  ///
  SafeFile(
      {@required String name,
      @required String savePath,
      String description,
      DateTime addedDateTime,
      Color color,
      List<String> tags}) {
    _name = name;
    _description = description;
    _addedDateTime = addedDateTime;
    _color = color;
    _savePath = savePath;
    _tags = tags;
  }

  /// Creates a new empty instance of safe file
  ///
  /// All the internal members will be set to null or to the default values.
  /// To assign something use the default constructor.
  SafeFile.empty() {
    _name = '';
    _description = '';
    _addedDateTime = null;
    _savePath = '';
    _color = null;
    _tags = [];
  }

  String get name => _name;

  String get description => _description;

  DateTime get addedDateTime => _addedDateTime;

  String get savePath => _savePath;

  Color get color => _color;

  String get password => _password;

  List<String> get tags => _tags;

  set name(String name) => _name = name;

  set description(String description) => _description = description;

  set addedDateTime(DateTime added) => _addedDateTime = added;

  set savePath(String original) => _savePath = original;

  set color(Color color) => _color = color;

  set tags(List<String> tags) => _tags = tags;

  set password (String passwd) => _password = passwd;

  /// Returns the tag with the given index
  String getTag(int index) => _tags[index];

  /// Adds the tag to the tag list of this file
  void appendTag(String tag) {}

  /// Returns the number of tags assigned to this file
  int tagsCount() => _tags.length;

  /// Checks if there is a tag with the given index
  ///
  /// [index] The index of the tag <br>
  /// returns true if there is a tag with this index, false otherwise
  bool existsTag(int index) => index >= 0 && index < _tags.length;

  /// Checks if this safe file has some tags
  ///
  /// returns true if there are almost one tag, false otherwise
  bool hasTags() => _tags != null;

  /// Formats a name that is displayable in low-space widgets with a centertext applied.
  ///
  /// Divides the name in sections on [blockSize] characters and puts some spaces between all the sections
  /// returns the new displayable name
  String formatVisibleName(int blockSize) {
    int size = _name.length;
    if (size > blockSize) {
      print('Start divide string of $size elements. ');
      String newName = '';
      // Number of used characters in name
      int elapsedChars = 0;
      // Number of blocks divided
      int blocks = 0;

      for (int x = 0; x < size / blockSize; x++) {
        // Get the starting point of the substring
        var start = blockSize * x;
        // Get the number of characters that haven't been used
        int others = size - elapsedChars;
        // Check blocks
        if (others > blockSize && blocks < 2) {
          newName += _name.substring(start, start + blockSize);
          newName += ' ';
          elapsedChars += blockSize;
          blocks++;
        } else {
          break;
        }
      }

      if (blocks < 2) {
        if (_name.length > elapsedChars) {
          // Put the remaining part
          newName += _name.substring(elapsedChars - 1);
        }
      } else {
        newName += '...';
      }

      print('Name has been divided: $newName|');
      return newName;
    }
    return _name;
  }

  /// Converts the informations of this safe file into a save-able string
  /// to be used into text files. It is composed of a series of property-value lines
  /// separated by a :.
  String toXmlString() {
    // Create document tree
    final builder = XmlBuilder();
    builder.element('safe-file', nest: () {
      builder.element('display-name', nest: () {
        builder.text(_name);
      });
      builder.element('save-path', nest: () {
        builder.text(_savePath);
      });
      builder.element('added-on', nest: (){
        builder.text(DateTimeFormatter.complete(_addedDateTime).format());
      });
      builder.element('description', nest: (){
        builder.text(_description);
      });
      builder.element('color', nest: () {
        builder.attribute('format', 'rgb');
        builder.text(RgbColorFormatter.fromColor(_color).formatString());
      });
      builder.element('tags', nest: (){
        for(var tag in _tags){
          builder.element('tag', nest: (){
            builder.text(tag);
          });
        }
      });
    });

    // Build the document and return his string
    var document = builder.buildDocument();

    return document.toXmlString();
  }

  /// Loads the information about a safe file from a string (ideologically
  /// taken from a text file) and assigns all the information to a new instance of
  /// this class.
  ///
  /// The parameter [sourceStr] is mandatory and represents the string to use for
  /// reading the informations. It should follow the [toSaveString] format
  static SafeFile fromSaveString(String sourceStr) {
    // TODO: Impelemnt use of xml instead of raw string
    // // File instance
    // var file = SafeFile.empty();
    // // Divide the string into lines
    // var lines = sourceStr.split('\n');
    // // Determinate if we are into a block
    // bool block = false;
    //
    // // Iterate all the lines
    // for (var line in lines) {
    //   // Check if line contains something
    //   if (line != '') {
    //     if (line == 'safe-file') {
    //       block = true;
    //     } else if (line == 'end-safe-file')
    //       block = false;
    //     else {
    //       try {
    //         // calculate parameter name and value
    //         var paramName = line.split(':')[0];
    //         var paramValue = line.split(':')[1];
    //
    //         if (paramName == 'name')
    //           file.name = paramValue;
    //         else if (paramName == 'source')
    //           file.originalPath = paramValue;
    //         else if (paramName == 'description')
    //           file.description = paramValue;
    //         else if (paramName == 'added_on') {
    //           // Create formatter
    //           var formatter = DateTimeFormatter.completePattern();
    //           file.addedDateTime = formatter.fromString(paramValue);
    //         }
    //         else if (paramName == 'color') {
    //           // Create a formatter
    //           var formatter = RgbColorFormatter(0, 0, 0);
    //           file.color = formatter.fromString(paramValue);
    //         }
    //       } on IndexError {
    //         print('Errore nella divisione della riga $line');
    //       }
    //     }
    //   }
    // }
    // return file;
  }

  @override
  String toString() =>
      'SafeFile $_name. Created on: $_addedDateTime. Optional description: $_description. Original file path: $_savePath. '
      ' Label color: $_color';
}

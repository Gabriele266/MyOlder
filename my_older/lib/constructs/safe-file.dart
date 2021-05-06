import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../formatters/rgb-color-formatter.dart';
import '../formatters/date-time-formatter.dart';

/// Represents a protected file into the application
/// TODO: Make all fields public and remove getters/setters
class SafeFile {
  // File name
  String _name;

  // File suffix
  String _suffix;

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
      @required String suffix,
      @required String savePath,
      String description,
      DateTime addedDateTime,
      Color color,
      List<String> tags}) {
    _name = name;
    _description = description;
    _suffix = suffix;
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
    _suffix = '';
  }

  String get name => _name;

  String get description => _description;

  DateTime get addedDateTime => _addedDateTime;

  String get savePath => _savePath;

  Color get color => _color;

  String get password => _password;

  List<String> get tags => _tags;

  String get suffix => _suffix;

  set name(String name) => _name = name;

  set description(String description) => _description = description;

  set addedDateTime(DateTime added) => _addedDateTime = added;

  set savePath(String original) => _savePath = original;

  set color(Color color) => _color = color;

  set tags(List<String> tags) => _tags = tags;

  set password(String passwd) => _password = passwd;

  set suffix(String suffix) => _suffix = suffix;

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

  /// Converts the informations of this safe file into a save-able string
  /// to be used into text files. It is composed of a series of property-value lines
  /// separated by a :.
  /// TODO: Fix return type issues
  String toXmlString() {
    // Create document tree
    final builder = XmlBuilder();
    try {
      builder.element('safe-file', nest: () {
        builder.element('display-name', nest: () {
          builder.text(_name);
        });
        builder.element('save-path', nest: () {
          builder.text(_savePath);
        });
        builder.element('added-on', nest: () {
          builder.text(DateTimeFormatter.complete(_addedDateTime).format());
        });
        builder.element('description', nest: () {
          try {
            builder.text(_description);
          } on NoSuchMethodError catch (exception) {
            // Nothing
            print('No description given for the safefile $_name');
          }
        });
        builder.element('suffix', nest: () {
          builder.text(_suffix);
        });
        builder.element('color', nest: () {
          builder.attribute('format', 'rgb');
          try {
            builder.text(RgbColorFormatter.fromColor(_color).formatString());
          } on NoSuchMethodError catch (exception) {
            print('No color given for the safefile $_name');
          }
        });
        builder.element('password', nest: () {
          builder.text(_password);
        });
        builder.element('tags', nest: () {
          try {
            for (var tag in _tags) {
              builder.element('tag', nest: () {
                builder.text(tag);
              });
            }
          } on NoSuchMethodError catch (i) {
            print(
                'Exception while formatting the tag elements for the safefile: $this');
          }
        });
      });

      // Build the document and return his string
      var document = builder.buildDocument();

      return document.toXmlString();
    } catch (exc) {
      print('Failed loading of a safefile. ');
    }
  }

  /// Loads the information about a safe file from a string (ideologically
  /// taken from a text file) and assigns all the information to a new instance of
  /// this class.
  ///
  /// The parameter [sourceStr] is mandatory and represents the element to use for
  /// reading the informations. It should follow the [toSaveString] format
  static SafeFile fromXmlElement(XmlElement source) {
    var file = SafeFile.empty();

    try {
      file.name = source.findElements('display-name').single.text;
      file.password = source.findElements('password').single.text;
      file.savePath = source.findElements('save-path').single.text;
      file.addedDateTime = DateTimeFormatter.completePattern()
          .fromString(source.findElements('added-on').single.text);
      file.suffix = source.findElements('suffix').single.text;
      file.description = source.findElements('description').single.text;
      file.color = RgbColorFormatter.empty()
          .fromString(source.findElements('color').single.text);
    } on NoSuchMethodError catch (i) {
      print('Exception during requesting informations from an XmlString. ');
      print(i);
      print(i.stackTrace);
    } catch (i) {
      print('Exception during loading file a file');
    }

    return file;
  }

  /// Opens this file, decrypts his contents and opens it with the default app
  Future<String> unlockAndOpen() async {
    try {
      // Search the safefile index into this object
      // Read the file
      var crt = AesCrypt(_password);
      crt.setOverwriteMode(AesCryptOwMode.on);
      // Get the temporary path
      String path = '${(await getExternalStorageDirectory()).path}/$_name';
      print('Decrypted file path: $path');
      print('Decrypted file suffix: $_suffix');
      // Decrypt all
      crt.decryptFile(_savePath, path);

      // Launch default viewer
      OpenFile.open(path);
    } catch (i) {
      print('Exception during unlocking file $_name');
    }

    return ' ';
  }

  /// Checks if this file is equal to another
  bool isEqual(SafeFile file) {
    return (_name == file.name &&
        _savePath == file.savePath &&
        _addedDateTime == file.addedDateTime);
  }

  @override
  String toString() =>
      'SafeFile $_name. Created on: $_addedDateTime. Optional description: $_description. Original file path: $_savePath. '
      ' Label color: $_color';
}

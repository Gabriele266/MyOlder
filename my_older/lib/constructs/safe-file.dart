import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../formatters/rgb-color-formatter.dart';
import '../formatters/date-time-formatter.dart';

/// Represents a protected file into the application
class SafeFile {
  // File name
  String name;

  // File suffix
  String suffix;

  // File description
  String description;

  // Creation time
  DateTime dateTime;

  // Associated color
  Color color;

  // path of the saved file
  String path;

  // List of file tags
  List<String> tags;

  // File access password
  String password;

  /// Creates a new instance of a safe file
  ///
  /// This instance represents a file that is protected into the application <br>
  /// all the files are encrypted using aes encryption method. <br>
  /// [name] : A string that contains the name of the file <br>
  /// [savePath] : The original file path (the file will be moved into a safe zone) <br>
  /// [description] : An optional description to assign at the file <br>
  /// [color] : A label color to tag this file <br>
  /// [addedDateTime] : A datetime instance that represents the time when the file was added (if not given it will be the current date <b>
  /// [password] The password to use for crypt / decrypt this file
  SafeFile({
    @required this.name,
    @required this.path,
    this.color,
    this.dateTime,
    this.description,
    this.password,
    this.suffix,
  });

  /// Creates a new empty instance of safe file
  ///
  /// All the internal members will be set to null or to the default values.
  /// To assign something use the default constructor.
  SafeFile.empty() {
    name = '';
    description = '';
    dateTime = null;
    path = '';
    color = null;
    tags = [];
    suffix = '';
    password = '';
  }

  /// Returns the tag with the given index
  String getTag(int index) => tags[index];

  /// Adds the tag to the tag list of this file
  void appendTag(String tag) {}

  /// Returns the number of tags assigned to this file
  int tagsCount() => tags.length;

  /// Checks if there is a tag with the given index
  ///
  /// [index] The index of the tag <br>
  /// returns true if there is a tag with this index, false otherwise
  bool existsTag(int index) => index >= 0 && index < tags.length;

  /// Checks if this safe file has some tags
  ///
  /// returns 'true' if there are almost one tag, 'false' otherwise
  bool hasTags() => tags != null;

  /// Converts the informations of this safe file into an xml string
  ///
  ///
  /// The returned string can be used into [xml] files.
  String toXmlString() {
    // Create document tree
    final builder = XmlBuilder();
    try {
      builder.element('safe-file', nest: () {
        builder.element('display-name', nest: () {
          builder.text(name);
        });
        builder.element('save-path', nest: () {
          builder.text(path);
        });
        builder.element('added-on', nest: () {
          builder.text(DateTimeFormatter.complete(dateTime).format());
        });
        builder.element('description', nest: () {
          try {
            builder.text(description);
          } on NoSuchMethodError catch (exception) {
            // Nothing
            print('No description given for the safefile $name');
            print(exception);
          }
        });
        builder.element('suffix', nest: () {
          builder.text(suffix);
        });
        builder.element('color', nest: () {
          builder.attribute('format', 'rgb');
          try {
            builder.text(RgbColorFormatter.fromColor(color).formatString());
          } on NoSuchMethodError catch (exception) {
            print('No color given for the safefile $name');
            print(exception);
          }
        });
        builder.element('password', nest: () {
          builder.text(password);
        });
        builder.element('tags', nest: () {
          try {
            for (var tag in tags) {
              builder.element('tag', nest: () {
                builder.text(tag);
              });
            }
          } on NoSuchMethodError catch (i) {
            print(
                'Exception while formatting the tag elements for the safefile: $this');
            print(i);
          }
        });
      });

      // Build the document and return his string
      var document = builder.buildDocument();

      return document.toXmlString();
    } catch (exc) {
      print('Failed loading of a safefile. ');
    }

    return null;
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
      file.path = source.findElements('save-path').single.text;
      file.dateTime = DateTimeFormatter.completePattern()
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
  ///
  /// Requires that [password] is given and also [path] and [name]
  Future<String> unlockAndOpen() async {
    try {
      // Search the safefile index into this object
      // Read the file
      final crt = AesCrypt(password);
      crt.setOverwriteMode(AesCryptOwMode.on);
      // Get the temporary path
      final path = '${(await getExternalStorageDirectory()).path}/$name';
      // Decrypt all
      crt.decryptFile(path, path);

      // Launch default viewer
      OpenFile.open(path);
    } catch (i) {
      print('Exception during unlocking file $name');
    }

    return ' ';
  }

  /// Checks if [file] has the same properties as this current object
  ///
  /// The checked properties are [name], [path], [dateTime]
  /// The others are ignored
  /// Returns 'true' if the two objects are equal, 'false' otherwise
  bool isEqual(final SafeFile file) =>
      (name == file.name && path == file.path && dateTime == file.dateTime);

  @override
  String toString() =>
      'SafeFile $name. Created on: $dateTime. Optional description: $description. Original file path: $path. '
      ' Label color: $color';
}

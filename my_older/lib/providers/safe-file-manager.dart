import 'dart:io';
import 'dart:convert';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../constructs/safe-file.dart';
import '../constructs/myolder-user.dart';

import '../formatters/date-time-formatter.dart';
import '../exceptions/manager-add-list-exception.dart';
import '../exceptions/element-not-found-exception.dart';
import '../exceptions/directory-not-found-exception.dart';
import '../exceptions/file-not-found-exception.dart';

class SafeFileManager with ChangeNotifier {
  static SafeFileManager of(BuildContext context, {bool listen = true}) =>
      Provider.of<SafeFileManager>(context, listen: listen);

  // List of safe files
  List<SafeFile> _safeFiles = [];

  final String safeDirectory;

  final MyOlderUser allowedUser;

  // Date this safefilemanager was created
  final DateTime creationDateTime;

  /// Returns a copy of the safe file list
  List<SafeFile> get safeFiles => [..._safeFiles];

  /// The number of safe files
  int get safeFilesCount => _safeFiles.length;

  /// Initializes a new instance of a safefilemanager
  ///
  /// This instance represents a manager for a list of safe files in the application <br>
  /// It requires a [user] that will represent the only user that can open this list <br>
  /// [safeDirectory] represents the name of the safe dir to use for encrypted files.
  SafeFileManager({
    this.creationDateTime,
    @required this.safeDirectory,
    @required this.allowedUser,
  });

  /// Adds a new safe file to the safe zone
  ///
  /// [file] The object retreived from the file picker that stores all the info
  /// about the file
  /// [context] The build context to use for retreiving informations about the user, etc...
  Future<void> addSafeFile(
    PlatformFile file,
  ) async {
    // Check if list isn't null
    if (_safeFiles == null) throw ManagerAddToListException(file, 'safeFiles');

    // Run the method to configure it
    // Generate a file ID from it's path to use for encryption
    // Get file path
    final String filePath =
        '${(await getApplicationDocumentsDirectory()).path}/${safeDirectory}/${_safeFiles.length}.file';

    // Get the bytes of the string to hash and hash it
    var bytes = utf8.encode(filePath);
    final String password = sha256.convert(bytes).toString();

    // Crete the file object
    final safeFile = SafeFile(
      name: file.name,
      password: password,
      path: filePath,
      suffix: file.extension,
      color: Colors.blue,
      dateTime: DateTime.now(),
    );

    // Use it as file encrypt password
    final crypt = AesCrypt(password);
    crypt.setOverwriteMode(AesCryptOwMode.on);

    // Start file encrypt
    crypt.encryptDataToFile(file.bytes, filePath);

    _safeFiles.add(safeFile);
    notifyListeners();
    // Save all the informations
    saveInformations();
  }

  /// Removes the given file index from the list
  ///
  /// [index] The index of the file to remove
  void removeSafeFile(int index) {
    try {
      // Delete the file from the disk
      final file = File(_safeFiles[index].path);
      file.deleteSync();
    } on IOException catch (exc) {
      print(
          'Unable to delete the safefile at index $index. \nSafeFile informations: ${_safeFiles[index]}\n');
      print('The file to delete was: $exc');
    }
    // Remove the object
    _safeFiles.removeAt(index);
    notifyListeners();
  }

  /// Search a specific safe file into this manager
  ///
  /// [file] The file to search for
  /// Returns his 'index' into the list
  int searchSafeFile(SafeFile file) {
    for (int x = 0; x < _safeFiles.length; x++) {
      if (file.isEqual(_safeFiles[x])) {
        return x;
      }
    }

    // Throw a precise exception
    throw ElementNotFoundException(
        file.toString(), 'SafeFile', 'SafeFileManager._safeFiles');
  }

  /// Configures a directory to be used for the safe zone of the application
  ///
  /// The directory will be used for saving file and for saving the information file about all
  /// the elements that a sepecific user want's to protect.
  Future<void> configureSafeDirectory() async {
    // Get complete directory path
    Directory dir = Directory(
        (await getApplicationDocumentsDirectory()).path + '/$safeDirectory');
    // Create the directory
    dir.create();
  }

  /// Adds a new file to the safe zone
  Future<void> importNewFile() async {
    // Get a file from the default file-picker
    FilePickerResult file = await FilePicker.platform
        .pickFiles(withData: true, withReadStream: true);

    if (file != null) {
      // The the single file to add
      PlatformFile object = file.files.first;
      print('File suffix: ${object.extension}');

      // Add the file and encrypt it
      addSafeFile(object);
    }
  }

  /// Starts the process for saving all the safe files informations into the encrypted file.
  Future<void> saveInformations() async {
    // calculate file path
    String filePath =
        '${(await getApplicationDocumentsDirectory()).path}/$safeDirectory/$safeDirectory.cfg';

    // Create the xml document
    var builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('configure-file', nest: () {
      builder.element('created-on', nest: () {
        var formatter = DateTimeFormatter.complete(DateTime.now());
        builder.text(formatter.format());
        builder.attribute('pattern', formatter.pattern);
      });
      builder.element('allowed-user', nest: () {
        builder.xml(allowedUser.toXmlString());
      });
      builder.element('safe-files', nest: () {
        if (_safeFiles.length > 0) {
          for (var file in _safeFiles) {
            builder.xml(file.toXmlString());
          }
        }
      });
    });

    try {
      // Write all in the file
      var crt = AesCrypt('rc&MEuFiMoZBB8Ru*Sa8');
      crt.setOverwriteMode(AesCryptOwMode.on);

      var content = builder.buildDocument().toXmlString();

      crt.encryptTextToFile(content, filePath);
    } catch (exception) {
      print('Exception during configuring the configurationFile. ');
    }
  }

  /// Adds a new safefile to the memory
  void appendSafeFile(SafeFile file) {
    _safeFiles.add(file);
    notifyListeners();
  }

  /// Removes all the safe files from the safe zone
  ///
  Future<void> clearAllSafeFiles() async {
    if (_safeFiles.length > 0) {
      _safeFiles.clear();
      notifyListeners();
      // Save the informations again
      saveInformations();
    }
  }

  /// Reads the configuration file into his path and returns a safefilemanager object
  ///
  /// [older_name] is the name given to the directory and the file (must be equal for each)
  // ignore: missing_return
  static Future<SafeFileManager> readConfigurationFile(
      String name, String password) async {
    // Get the directory path
    String dirPath = '${(await getApplicationDocumentsDirectory()).path}/$name';
    // print('Start loading from the directory $dirPath');
    // Check if directory exists
    if (Directory(dirPath).existsSync()) {
      // Check file existance
      String filePath = '$dirPath/$name.cfg';

      if (File(filePath).existsSync()) {
        // Load the buffer of the file
        // Encryption object
        final crt = AesCrypt(password);

        // Read data and decrypt it
        final String fileBuffer = await crt.decryptTextFromFile(filePath);

        // Create the document object and parse from the text file
        try {
          final document = XmlDocument.parse(fileBuffer);

          // Get the root element
          final root = document.rootElement;

          // Get child elements
          final alUser = root.findAllElements('allowed-user').single;
          final safeFilesList = root
              .findAllElements('safe-files')
              .single
              .findAllElements('safe-file');

          // Creation datetime informations
          final creationDateTimeElement =
              root.findElements('created-on').single;

          final String dateTimePattern =
              creationDateTimeElement.getAttribute('pattern');

          // Load use information
          var user =
              MyOlderUser.fromXmlElement(alUser.findElements('user').single);

          // Create the user manager
          final manager = SafeFileManager(
            safeDirectory: name,
            allowedUser: user,
            creationDateTime: DateTimeFormatter(pattern: dateTimePattern)
                .fromString(creationDateTimeElement.text),
          );

          // Get all the safefiles
          for (var obj in safeFilesList) {
            manager.appendSafeFile(SafeFile.fromXmlElement(obj));
          }

          return manager;
        } on XmlParserException catch (exc) {
          print(
              '\n\nexception during parsing the configuration file for the SafeFileManager. Exception information: $exc. '
              'File used: $filePath');
        }
      } else
        throw FileNotFoundException(file: filePath, path: filePath);
    } else
      throw DirectoryNotFoundException(
          directory: dirPath,
          additionalMessage:
              ' readConfigurationFile needs a working directory for the configuration file. ');
  }
}

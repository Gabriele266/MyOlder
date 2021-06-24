import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:xml/xml.dart';

import '../constructs/myolder-user.dart';
import '../exceptions/exceptions.dart';

class UserFileManager with ChangeNotifier {
  final String rootFile;
  final String safeFolder;
  MyOlderUser user;
  bool userLogged = false;

  static UserFileManager of(BuildContext context, {bool listen = false}) =>
      Provider.of<UserFileManager>(context, listen: listen);

  /// Creates a new [UserFileManager] to manage the user informations and files
  ///
  /// [rootFile] The name of the root file to use for saving all the credentials
  /// [safeFolder] The name of the folder to put safe files into.
  UserFileManager({
    @required this.rootFile,
    @required this.safeFolder,
  });

  /// Starts the control of the user and checks if it is allowed to access the application
  ///
  /// Needs [file] to pick up the file from the file system and [user] to check the informations
  /// Returns 'true' if this user is allowed to access the application, 'false' otherwise.
  /// In case of errors an exception is thrown.
  ///
  /// If the configuration file doesn't exists, a [FileNotFoundException] is thrown
  /// If the [rootFile] is empty, then a [NullDataException] is thrown
  /// [logUser] The user informations
  /// [keepLogin] Indicates if the login should be kept
  Future<bool> login(MyOlderUser logUser, bool keepLogin) async {
    if (rootFile.isNotEmpty) {
      // Get the file object
      var oFile =
          File('${(await getApplicationDocumentsDirectory()).path}/$rootFile');

      // Check if file exists
      if (oFile.existsSync()) {
        // Leggo le righe del file
        final decr = AesCrypt(
          '%#^363#&3696^&^543&5335&73&55&2@6%232!^432!^6%&842427@!7%98^@824#969#836^@2889!862^@77#2!72355%',
        );

        final value = await decr.decryptTextFromFile(oFile.path);

        try {
          final doc = XmlDocument.parse(value);

          // The root element
          final root = doc.findAllElements('credentials').single;

          // Check errors
          if (root == null) {
            return false;
          }

          final bool fKeep =
              root.findAllElements('keep-login').single.text == 'true';

          // Load the user informations
          user = MyOlderUser(
            name: root.findAllElements('username').first.text,
            password: root.findAllElements('password').first.text,
          );

          final logged =
              (logUser.name == user.name && logUser.password == user.password);

          notifyListeners();


          if (logged && fKeep != keepLogin) {
            writeFile(keepLogin);
          }

          if (fKeep)
            return true;
          else
            // return the result of the check
            return logged;
        } on XmlParserException catch (_) {
          throw RootFileWrongEncodingException();
        }
      } else
        throw FileNotFoundException(
          file: rootFile,
          path: oFile.path,
        );
    } else
      throw NullDataException(
        data: 'file',
        operationDescription:
            'Executing the first control step for the credentials.',
        function: 'doControl',
      );
  }

  /// Executes the logout
  void logout() {
    userLogged = false;
    notifyListeners();
  }

  /// Checks if the login is kept or not
  Future<bool> isLoginKept() async {
    if (rootFile.isNotEmpty) {
      // Get the file object
      var oFile =
          File('${(await getApplicationDocumentsDirectory()).path}/$rootFile');

      // Check if file exists
      if (oFile.existsSync()) {
        // Leggo le righe del file
        final decr = AesCrypt(
          '%#^363#&3696^&^543&5335&73&55&2@6%232!^432!^6%&842427@!7%98^@824#969#836^@2889!862^@77#2!72355%',
        );

        final value = await decr.decryptTextFromFile(oFile.path);

        try {
          // Parse the document and get
          final doc = XmlDocument.parse(value);

          // The root element
          final root = doc.findAllElements('credentials').single;

          // Check errors
          if (root == null) {
            return false;
          }

          final bool fKeep =
              root.findAllElements('keep-login').single.text == 'true';

          return fKeep;
        } on XmlParserException catch (_) {
          throw RootFileWrongEncodingException();
        }
      } else {
        throw FileNotFoundException(
          file: rootFile,
          path: oFile.path,
        );
      }
    } else {
      throw NullDataException(
        data: 'file',
        operationDescription:
            'Executing the first control step for the credentials.',
        function: 'doControl',
      );
    }
  }

  /// Checks if the configuration file for the application exists
  ///
  /// [name] The name of the configuration
  Future<bool> checkConfigurationExists() async {
    // Directory path
    final dir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/$safeFolder');

    return dir.existsSync();
  }

  /// Removes the configuration folder with the given name
  Future<void> removeConfigurationFolder() async {
    // Get directory path
    final dir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/$safeFolder');
    dir.delete(recursive: true);
  }

  /// Checks if the user credentials are allowed to access the application or not
  ///
  /// [file] represents the the file to search
  ///
  /// If the [file] is empty (no file specified) then a [NullDataException] is thrown
  Future<bool> checkRootExists() async {
    if (rootFile.isNotEmpty) {
      // Get the file formatting his path
      final oFile =
          File('${(await getApplicationDocumentsDirectory()).path}/$rootFile');

      // Check if file exists
      return oFile.existsSync();
    } else
      throw NullDataException(
        data: 'file',
        operationDescription: 'checking if the root file exists',
        function: 'UserFileManager::checkRootExists',
      );
  }

  /// Starts writing the user informations on the file
  ///
  /// Needs that the member file and user of this class are set.
  /// TODO: Implement password generation
  Future<void> writeFile(bool keepLogged) async {
    // Formatto il percorso del file da creare
    if (rootFile.isNotEmpty) {
      // Check if the user informations are set
      if (user != null && user.isNotEmpty()) {
        final String filePath =
            '${(await getApplicationDocumentsDirectory()).path}/$rootFile';

        // Encrypt all the informations
        final crt = AesCrypt(
          '%#^363#&3696^&^543&5335&73&55&2@6%232!^432!^6%&842427@!7%98^@824#969#836^@2889!862^@77#2!72355%',
        );

        // Enable overwrite
        crt.setOverwriteMode(AesCryptOwMode.on);

        // Format the document
        var builder = XmlBuilder();
        builder.processing('xml', 'version="1.0"');
        builder.element('credentials', nest: () {
          builder.element('keep-login', nest: () {
            builder.text(keepLogged.toString());
          });
          builder.element('username', nest: () {
            builder.text(user.name);
          });
          builder.element('password', nest: () {
            builder.text(user.password);
          });
          builder.element('datetime', nest: () {
            builder.text(DateTime.now().toString());
          });
        });

        crt.encryptTextToFile(
          builder.buildDocument().toXmlString(),
          filePath,
        );
      } else
        throw UserNotDefinedException('writeFile() async');
    } else
      throw FileNotDefinedException('writeFile() async');
  }

  /// Checks if it's ready to make a login
  Future<bool> readyToLogin() async {
    final root = await checkRootExists();
    final config = await checkConfigurationExists();

    return (root && config);
  }

  /// Removes the configuration file
  Future<void> removeRootFile() async {
    final String filePath =
        '${(await getApplicationDocumentsDirectory()).path}/$rootFile';
    final oFile = File(filePath);
    // Check if file exists and delete it
    if (oFile.existsSync()) oFile.deleteSync();
  }
}

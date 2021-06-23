import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:aes_crypt/aes_crypt.dart';

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
  /// TODO: Implement use of xml for the root file
  Future<bool> login(MyOlderUser logUser) async {
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

        // Get the file lines
        final fileLines =
            (await decr.decryptTextFromFile(oFile.path)).split('\n');

        // Nome utente
        var usr = '';
        // Password
        var password = '';

        // Read credentials
        for (var line in fileLines) {
          if (!line.startsWith('#')) {
            // Controllo se si tratta di una riga che definisce il nome utente per l'accesso
            if (line.startsWith('user-name')) {
              usr = line.split(':')[1];
            } else if (line.startsWith('password')) {
              password = line.split(':')[1];
              break;
            }
          }
        }

        // Load the user informations
        user = MyOlderUser(
          name: usr,
          password: password,
        );

        userLogged =
            (logUser.name == user.name && logUser.password == user.password);

        notifyListeners();

        // return the result of the check
        return userLogged;
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
  Future<void> writeFile() async {
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

        crt.encryptTextToFile(
          '# user informations. \n'
          'creation-time:${DateTime.now().toString()}\n'
          'user-name:${user.name}\n'
          'password:${user.password}\n',
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

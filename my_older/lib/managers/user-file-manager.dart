import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aes_crypt/aes_crypt.dart';

import '../exceptions/null-data-exception.dart';
import '../constructs/myolder-user.dart';
import '../exceptions/file-not-defined-exception.dart';
import '../exceptions/file-not-found-exception.dart';
import '../exceptions/user-not-defined-exception.dart';

class UserFileManager {
  String file;
  MyOlderUser user;

  /// Inizializza una [UserFileManager] impostando il file da cui leggere e l'utente con cui confrontarlo
  ///
  /// [file] : Rappresenta il file da cui leggere
  /// [user] : Le informazioni dell' utente con cui controllare
  UserFileManager({@required this.file, @required this.user});

  /// Starts the control of the user and checks if it is allowed to access the application
  ///
  /// Needs [file] to pick up the file from the file system and [user] to check the informations
  /// Returns 'true' if this user is allowed to access the application, 'false' otherwise.
  /// In case of errors an exception is thrown.
  ///
  /// If the configuration file doesn't exists, a [FileNotFoundException] is thrown
  /// If the [file] is empty, then a [NullDataException] is thrown
  /// TODO: Implement use of xml for the root file
  Future<bool> doControl() async {
    if (file.isNotEmpty) {
      // Get the file object
      var oFile =
          File('${(await getApplicationDocumentsDirectory()).path}/$file');

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

        // return the result of the check
        return (user.name == usr && user.password == password);
      } else
        throw FileNotFoundException(
          file: file,
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

  /// Checks if the configuration file for the exists
  Future<bool> checkConfigurationExists(String name) async {
    // Directory path
    final dir =
        Directory('${(await getApplicationDocumentsDirectory()).path}/$name');

    return dir.existsSync();
  }

  /// Removes the configuration folder with the given name
  Future<void> removeConfigurationFolder(String name) async {
    // Get directory path
    final dir =
        Directory('${(await getApplicationDocumentsDirectory()).path}/$name');
    dir.delete(recursive: true);
  }

  /// Checks if the user credentials are allowed to access the application or not
  ///
  /// Needs that the internal member file is set.
  /// [file] represents the the file to search
  /// 
  /// If the [file] is empty (no file specified) then a [NullDataException] is thrown
  Future<bool> checkRootExists() async {
    if (file.isNotEmpty) {
      // Get the file formatting his path
      final oFile =
          File('${(await getApplicationDocumentsDirectory()).path}/$file');

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
    if (file.isNotEmpty) {
      // Check if the user informations are set
      if (user != null && user.isNotEmpty()) {
        final String filePath =
            '${(await getApplicationDocumentsDirectory()).path}/$file';

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

  /// Removes the configuration file
  Future<void> removeFile() async {
    final String filePath =
        '${(await getApplicationDocumentsDirectory()).path}/$file';
    final oFile = File(filePath);
    // Check if file exists and delete it
    if (oFile.existsSync()) oFile.deleteSync();
  }
}

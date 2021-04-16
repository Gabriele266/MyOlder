import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aes_crypt/aes_crypt.dart';

import 'dart:io';

import 'exceptions/null-data-exception.dart';
import 'myolder-user.dart';
import 'exceptions/file-not-defined-exception.dart';
import 'exceptions/file-not-found-exception.dart';
import 'exceptions/user-not-defined-exception.dart';

class UserFileManager {
  String _file;
  MyOlderUser _user;

  /// Inizializza una lettore impostando il file da cui leggere e l'utente con cui confrontarlo
  ///
  /// [file] : Rappresenta il file da cui leggere
  /// [user] : Le informazioni dell' utente con cui controllare
  UserFileManager({String file, MyOlderUser user}) {
    _file = file;
    _user = user;
  }

  /// Starts the control of the user and checks if it is allowed to access the application
  ///
  /// Needs **_file** to pick up the file from the file system and **_user** to check the informations
  /// Returns true if this user is allowed to access the application, false otherwise. In case of errors an exception is
  /// thrown
  /// TODO: Implement use of xml for the root file
  Future<bool> doControl() async {
    if (_file.isNotEmpty) {
      // Get the file object
      var file =
          File('${(await getApplicationDocumentsDirectory()).path}/$_file');

      // Check if file exists
      if (file.existsSync()) {
        // Leggo le righe del file
        final decr = AesCrypt(
          '%#^363#&3696^&^543&5335&73&55&2@6%232!^432!^6%&842427@!7%98^@824#969#836^@2889!862^@77#2!72355%',
        );

        // Get the file lines
        final fileLines =
            (await decr.decryptTextFromFile(file.path)).split('\n');

        // Nome utente
        var user = '';
        // Password
        var password = '';

        for (var line in fileLines) {
          if (!line.startsWith('#')) {
            // Controllo se si tratta di una riga che definisce il nome utente per l'accesso
            if (line.startsWith('user-name')) {
              user = line.split(':')[1];
            } else if (line.startsWith('password')) {
              password = line.split(':')[1];
              break;
            }
          }
        }

        if (_user.name == user && _user.password == password) {
          return true;
        }
        return false;
      } else {
        throw FileNotFoundException(file: _file, path: file.path);
      }
    } else
      throw NullDataException(
        data: '_file',
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
  /// Needs that the internal member _file is set.
  /// [_file] represents the the file to search
  Future<bool> checkRootExists() async {
    if (_file.isNotEmpty) {
      // Get the file formatting his path
      final file =
          File('${(await getApplicationDocumentsDirectory()).path}/$_file');

      // Check if file exists
      return file.existsSync();
    } else
      throw NullDataException(
        data: '_file',
        operationDescription: 'checking if the root file exists',
        function: 'UserFileManager::checkRootExists',
      );
  }

  /// Starts writing the user informations on the file
  ///
  /// Needs that the member _file and _user of this class are set.
  /// TODO: Implement password generation
  Future<void> writeFile() async {
    // Formatto il percorso del file da creare
    if (_file.isNotEmpty) {
      // Check if the user informations are set
      if (_user != null && _user.isNotEmpty()) {
        final String filePath =
            '${(await getApplicationDocumentsDirectory()).path}/$_file';

        // Encrypt all the informations
        final crt = AesCrypt(
          '%#^363#&3696^&^543&5335&73&55&2@6%232!^432!^6%&842427@!7%98^@824#969#836^@2889!862^@77#2!72355%',
        );

        crt.encryptTextToFile(
          '# user informations. \n'
          'creation-time:${DateTime.now().toString()}\n'
          'user-name:${_user.name}\n'
          'password:${_user.password}\n',
          filePath,
        );
      } else
        throw UserNotDefinedException(operation: 'writeFile() async');
    } else
      throw FileNotDefinedException(operation: 'writeFile() async');
  }

  /// Removes the configuration file
  Future<void> removeFile() async {
    final String filePath =
        '${(await getApplicationDocumentsDirectory()).path}/$_file';
    final file = File(filePath);
    // Check if file exists and delete it
    if (file.existsSync()) file.deleteSync();
  }
}



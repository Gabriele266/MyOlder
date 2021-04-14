import 'package:flutter/material.dart';
import 'dart:io';
import 'myolder-user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aes_crypt/aes_crypt.dart';

class UserFileManager {
  String _file;
  MyOlderUser _user;

  /// Inizializza una lettore impostando il file da cui leggere e l'utente con cui confrontarlo
  ///
  /// [file] : Rappresenta il file da cui leggere
  /// [user] : Le informazioni dell' utente con cui controllare
  UserFileManager({String file, MyOlderUser user}){
    _file = file;
    _user = user;
  }

  /// Starts the control of the user and checks if it is allowed to access the application
  ///
  /// Needs **_file** to pick up the file from the file system and **_user** to check the informations
  /// Returns true if this user is allowed to access the application, false otherwise. In case of errors an exception is
  /// thrown
  Future<bool> doControl() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    if (_file.isNotEmpty) {
      var file = File('$path/$_file');

      if (file.existsSync()) {
        // Leggo le righe del file
        var decr = AesCrypt('%#^363#&3696^&^543&5335&73&55&2@6%232!^432!^6%&842427@!7%98^@824#969#836^@2889!862^@77#2!72355%');
        var fileLines = (await decr.decryptTextFromFile(file.path)).split('\n');

        // Nome utente
        var user = '';
        // Password
        var password = '';

        for (var line in fileLines) {
          if (!line.startsWith('#')) {
            // Controllo se si tratta di una riga che definisce il nome utente per l'accesso
            if (line.startsWith('user-name')) {
              user = line.split(':')[1];
            }
            else if (line.startsWith('password')) {
              password = line.split(':')[1];
              break;
            }
          }
        }

        if (_user.name == user && _user.password == password) {
          print('LOGGED IN SUCCESSFULLY');
          return true;
        }
        print('NOT LOGGED');
        return false;
      } else {
        throw FileNotFoundException(file: _file, path: path);
      }
    }
  }

  /// Checks if the configuration file for the exists
  Future<bool> checkConfigurationExists(String name) async{
    // Directory path
    var dir = Directory('${(await getApplicationDocumentsDirectory()).path}/$name');
    print('check existance of ${dir.path}');
    return dir.existsSync();
  }

  Future<void> removeConfigurationFolder(String name) async{
    // Get directory path
    var dir = Directory('${(await getApplicationDocumentsDirectory()).path}/$name');
    dir.delete(recursive: true);
  }
  /// Checks if the user credentials are allowed to access the application or not
  ///
  /// Needs that the internal member _file is set.
  /// [_file] represents the the file to search
  Future<bool> checkRootExists() async{
    String path = (await getApplicationDocumentsDirectory()).path;
    if(_file.isNotEmpty){
    var file = File('$path/$_file');

    if(file.existsSync()){
      return true;
    }
      return false;
    }
  }

  /// Starts writing the user informations on the file
  ///
  /// Needs that the member _file and _user of this class are set.
  Future<void> writeFile() async{
    String path = (await getApplicationDocumentsDirectory()).path;
    // Formatto il percorso del file da creare
    if(_file.isNotEmpty){
      // Check if the user informations are set
      if(_user != null && _user.isNotEmpty()){
        String filePath = '$path/$_file';

        // Encrypt all the informations
        var crt = AesCrypt('%#^363#&3696^&^543&5335&73&55&2@6%232!^432!^6%&842427@!7%98^@824#969#836^@2889!862^@77#2!72355%');
        crt.encryptTextToFile('# user informations. \n'
            'creation-time:${DateTime.now().toString()}\n'
            'user-name:${_user.name}\n'
            'password:${_user.password}\n', filePath);

        print('File successfully created on disk');
      }else{
        throw UserNotDefinedException('writeFile() async');
      }
    }else{
      throw FileNotDefinedException('writeFile() async');
    }
  }

  /// Removes the configuration file
  Future<void> removeFile() async{
    String path = (await getApplicationDocumentsDirectory()).path;
    String filePath = '$path/$_file';

    var file = File(filePath);
    if(file.existsSync())
      file.deleteSync();
  }
}

class FileNotFoundException implements Exception{
  String _file;
  String _path;

  FileNotFoundException ({String file, String path}){_file = file; _path = path;}

  @override
  String toString() => 'Eccezione FileNotFoundException. File non trovato. \nFile richiesto: $_file\nPercorso di ricerca: $_path';
}

class UserNotDefinedException implements Exception{
  String _operation;

  UserNotDefinedException(this._operation);

  @override
  String toString(){
    return 'UserNotDefinedException: During the operation $_operation a null user was given to the function. ';
  }
}

class FileNotDefinedException implements Exception{
  String _operation;

  FileNotDefinedException(this._operation);

  @override
  String toString() => 'FileNotFoundException: a null file was given during the operation $_operation. ';
}

class DirectoryNotFoundException implements Exception {
  String _directory;
  String _additionalMessage;

  DirectoryNotFoundException({String directory, String additionalMessage}){
    _directory = directory;
    _additionalMessage = additionalMessage;
  }

  @override
  String toString() => 'DirectoryNotFoundException: A required directory was not found. The directory is: '
      '$_directory. The operation was: $_additionalMessage';
}
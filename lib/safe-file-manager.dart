import 'exceptions/element-not-found-exception.dart';
import 'exceptions/null-data-exception.dart';
import 'package:flutter/material.dart';
import 'safe-file.dart';
import 'myolder-user.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';
import 'user-file-manager.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:xml/xml.dart';
import 'exceptions/manager-add-list-exception.dart';
import 'formatters/date-time-formatter.dart';

/// Represents a manager for safe files
class SafeFileManager{
  // List of safe files
  List<SafeFile> _safeFiles = [];
  // SafeDirectory name
  String _safeDirName = '';
  // Related user
  MyOlderUser _user;
  // Date this safefilemanager was created
  DateTime _creationDateTime;

  MyOlderUser get user => _user;

  List<SafeFile> get safeFiles => _safeFiles;

  String get safeDirectory => _safeDirName;

  int get safeFilesCount => _safeFiles.length;

  DateTime get creationInformations => _creationDateTime;

  set user(MyOlderUser user) {
    _user = user;
  }

  set safeFiles(List<SafeFile> files) {
    _safeFiles = files;
  }

  set creationInformations (DateTime dateTime){
    _creationDateTime = dateTime;
  }

  /// Initializes a new instance of a safefilemanager
  ///
  /// This instance represents a manager for a list of safe files in the application <br>
  /// It requires a [user] that will represent the only user that can open this list <br>
  /// [dirName] represents the name of the safe dir to use for encrypted files.
  SafeFileManager({@required MyOlderUser user, String dirName = 'newdir'}){
    _user = user;
    _safeDirName = dirName;
  }

  /// Adds a new safe file to the safe zone
  Future<void> addSafeFile(SafeFile file, Uint8List data) async{
    if(data != null){
      // Add the file to the list
      if(_safeFiles != null){
        _safeFiles.add(file);
        // Run the method to configure it
        // Generate a file ID from it's path to use for encryption
        // 2: Create an encrypted copy of the file
        // Get file path
        String filePath = '${(await getApplicationDocumentsDirectory()).path}/$_safeDirName/${_safeFiles.length}.file';

        // Get the bytes of the string to hash and hash it
        var bytes = utf8.encode(filePath);
        String password = sha256.convert(bytes).toString();
        // Save password to use it
        _safeFiles.last.password = password;
        _safeFiles.last.savePath = filePath;
        // Use it as file encrypt password
        var crypt = AesCrypt(password);
        crypt.setOverwriteMode(AesCryptOwMode.on);

        // Path to the safe zone file
        print('Added new safe file into the safe directory at the path: $filePath');
        // Start file encrypt
        crypt.encryptDataToFile(data, filePath);
        // Save
        saveInformations();
      }
      else{
        throw ManagerAddToListException(file);
      }
    }
    else{
      throw NullDataException('addSafeFile', ' Adding a new SafeFile to the safe zone. ');
    }
  }

  /// Removes the given file index from the list
  void removeSafeFile(int index){
    _safeFiles.removeAt(index);
  }

  int searchSafeFile(SafeFile file){
    for(int x = 0; x < _safeFiles.length; x++){
      if(file.isEqual(_safeFiles[x])){
        return x;
      }
    }

    // Throw a precise exception
    throw ElementNotFoundException(file.toString(), 'SafeFile', 'SafeFileManager._safeFiles');
  }

  /// Configures a directory to be used for the safe zone of the application
  ///
  /// The directory will be used for saving file and for saving the information file about all
  /// the elements that a sepecific user want's to protect.
  Future<void> configureSafeDirectory() async{
    // Get complete directory path
    Directory dir = Directory((await getApplicationDocumentsDirectory()).path + '/$_safeDirName');
    // Create the directory
    dir.create();
  }

  /// Opens a file, decrypts his contents and returns the decrypted file name
  Future<String> unlockFile(SafeFile file){
    // Search the safefile index into this object
    // TODO: Implement unlocking file
  }

  /// Starts the process for saving all the safe files informations into the encrypted file.
  Future<void> saveInformations() async{
    // calculate file path
    String filePath = '${(await getApplicationDocumentsDirectory()).path}/$_safeDirName/$_safeDirName.cfg';

    // Create the xml document
    var builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('configure-file', nest: (){
      builder.element('created-on', nest: (){
        var formatter = DateTimeFormatter.complete(DateTime.now());
        builder.text(formatter.format());
        builder.attribute('pattern', formatter.pattern);
      });
      builder.element('allowed-user', nest: (){
        builder.xml(_user.toXmlString());
      });
      builder.element('safe-files', nest: (){
        if(_safeFiles.length > 0){
          for(var file in _safeFiles){
            builder.xml(file.toXmlString());
          }
        }
      });
    });

    try{
      // Write all in the file
      var crt = AesCrypt('rc&MEuFiMoZBB8Ru*Sa8');
      crt.setOverwriteMode(AesCryptOwMode.on);

      var content = builder.buildDocument().toXmlString();

      crt.encryptTextToFile(content, filePath);
    }
    catch (exception){
      print('Exception during configuring the configurationFile. ');
    }
  }

  /// Adds a new safefile to the memory
  void appendSafeFile(SafeFile file){
    _safeFiles.add(file);
  }

  /// Reads the configuration file into his path and returns a safefilemanager object
  ///
  /// [older_name] is the name given to the directory and the file (must be equal for each)
  static Future<SafeFileManager> readConfigurationFile(String name, String password) async{
    // Get the directory path
    String dirPath = '${(await getApplicationDocumentsDirectory()).path}/$name';
    // print('Start loading from the directory $dirPath');
    // Check if directory exists
    if(Directory(dirPath).existsSync()){
      // Check file existance
      String filePath = '$dirPath/$name.cfg';

      if(File(filePath).existsSync()){
        // Load the buffer of the file
        // File buffer
        String fileBuffer;
        // Encryption object
        var crt = AesCrypt(password);
        // Mangager instance
        var manager = SafeFileManager(user: null);

        // Read data and decrypt it
        fileBuffer = await crt.decryptTextFromFile(filePath);
        print('$fileBuffer');

        // Create the document object and parse from the text file
        var document = XmlDocument.parse(fileBuffer);
        // Get the root element
        var root = document.rootElement;

        // Get child elements
        var al_user = root.findElements('allowed-user').first;
        var safe_files_list = root.findElements('safe-files').first.findAllElements('safe-file');

        // Creation datetime informations
        var creationDateTimeElement = root.findElements('created-on').first;
        String dateTimePattern = creationDateTimeElement.getAttribute('pattern');

        // Load use informations
        var user = MyOlderUser.fromXmlElement(al_user.findElements('user').first);

        // Save user informations
        manager.user = user;
        // Get the datetime this folder was created
        manager.creationInformations = DateTimeFormatter(pattern: dateTimePattern).fromString(creationDateTimeElement.text);

        // Get all the safefiles
        for(var obj in safe_files_list){
          manager.appendSafeFile(SafeFile.fromXmlElement(obj));
        }

        print('This safedirectory was created on ${manager.creationInformations.toString()}');
        return manager;
      }
    }
    else{
      throw DirectoryNotFoundException(directory: dirPath, additionalMessage: ' readConfigurationFile needs a working directory for the configuration file. ');
    }
  }
}
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

/// Represents a manager for safe files
class SafeFileManager{
  // List of safe files
  List<SafeFile> _safeFiles = [];
  // SafeDirectory name
  String _safeDirName = '';
  // Related user
  MyOlderUser _user;

  MyOlderUser get user => _user;

  List<SafeFile> get safeFiles => _safeFiles;

  String get safeDirectory => _safeDirName;


  set user(MyOlderUser user) {
    _user = user;
  }

  set safeFiles(List<SafeFile> files) {
    _safeFiles = files;
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

  /// Configures the configuration file to save a list of the safe files of the safe area
  ///
  /// The name of the safe file is the same of the safe directory name
  /// The [overwrite] parameter indicates if this configuration should overwrite any pre-existing file
  /// ** requires that the method [configureSafeDirectory] has already been executed. **
  Future<void> configureSafeConfigFile(AesCryptOwMode overwrite) async{
    // TODO: Implementare algoritmo generazione password
    var config = AesCrypt('rc&MEuFiMoZBB8Ru*Sa8');
    // Set overwrite mode for this file
    config.setOverwriteMode(overwrite);

    // Original informations buffer
    String fileBuffer = '# safezone configuration file\n# the buffer of this file is very restricted. it is encrypted'
        'with the aes alogithm. GG if you can open this file. \n'
        'created: ${DateTime.now().toString()}\n'
        'allowed_user_name:${_user.name}\n'
        'allowed_user_password:${_user.password}\n'
        'safe_files:[]\n'
        '# end safezone configuration file\n';
    // Start encrypt
    config.encryptTextToFileSync(fileBuffer, '${(await getApplicationDocumentsDirectory()).path}/$_safeDirName/$_safeDirName.cfg');
  }

  /// Starts the process for saving all the safe files informations into the encrypted file.
  Future<void> saveInformations() async{
    // calculate file path
    String filePath = '${(await getApplicationDocumentsDirectory()).path}/$_safeDirName/$_safeDirName.cfg';

    // Create the xml document
    var builder = XmlBuilder();
    builder.processing('xml', 'version="1.1"');
    builder.element('allowed-user', nest: (){
      builder.xml(_user.toXmlString());
    });
    builder.element('safe-files', nest: (){
      for(var file in _safeFiles){
        builder.xml(file.toXmlString());
      }
    });

  }
  /// Starts the operations to configure the new safe file
  Future<void> configureSafeFile(SafeFile file) async{
    // Create a new file into the safe directory
  }

  /// Reads the configuration file into his path and returns a safefilemanager object
  ///
  /// [older_name] is the name given to the directory and the file (must be equal for each)
  static Future<SafeFileManager> readConfigurationFile(String name, String password) async{
    // TODO: Implement use of xml instead of simple text
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
        var user = MyOlderUser();

        // Read data and decrypt it
        fileBuffer = await crt.decryptTextFromFile(filePath);
        // print('Decripted file content: $fileBuffer');

        // Separete file into his lines
        var lines = fileBuffer.split('\n');

        // Pass all his lines
        for(var line in lines){
          if(line.startsWith('allowed_user_name')) {
            user.name = line.split(':').last;
          } else if(line.startsWith('allowed_user_password')){
            user.password = line.split(':').last;
          }else if(line.startsWith('safe_files')){
            // TODO: Implement loading files into application
          }
        }
        // Save user informations
        manager.user = user;
        return manager;
      }
    }
    else{
      throw DirectoryNotFoundException(directory: dirPath, additionalMessage: ' readConfigurationFile needs a working directory for the configuration file. ');
    }
  }
}
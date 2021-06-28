import 'dart:isolate';

import 'package:aes_crypt/aes_crypt.dart';

import './encrypt-isolate-data.dart';

class EncryptIsolate {
  Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();

  /// Function to call when the isolate ends
  final void Function(EncryptIsolateData) onExit;

  /// Creates a new [EncryptIsolate]
  EncryptIsolate(this.onExit);

  /// Initializes the isolate
  Future<void> initIsolate(EncryptIsolateData data) async {
    _isolate = await Isolate.spawn(computeEncrypt, data);
    _isolate.addOnExitListener(_receivePort.sendPort);

    _receivePort.listen((message) {
      print('Message on close of isolate: $message');
      // Call manager
      if (onExit != null) onExit(data);
    });
  }

  static Future<void> computeEncrypt(EncryptIsolateData data) async {
    // Use it as file encrypt password
    final crypt = AesCrypt(data.password);
    crypt.setOverwriteMode(AesCryptOwMode.on);

    // Start file encrypt
    crypt.encryptDataToFile(data.bytes, data.filePath);
  }
}

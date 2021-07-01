import 'dart:isolate';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../isolates/decrypt-isolate-data.dart';

class DecryptIsolate {
  Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();

  final void Function(DecryptIsolateData) onExit;

  /// Creates a new [DecryptIsolate]
  DecryptIsolate(this.onExit);

  /// Initializes the isolate
  Future<void> initIsolate(DecryptIsolateData data) async {
    _isolate = await Isolate.spawn(computeDecrypt, data);
    _isolate.addOnExitListener(_receivePort.sendPort);

    _receivePort.listen((message) {
      if (onExit != null) onExit(data);
    });
  }

  static Future<void> computeDecrypt(DecryptIsolateData data) async {
    print('Init isolate');
    // Configure various paths and decrypt it
    final crt = AesCrypt(data.password);
    crt.setOverwriteMode(AesCryptOwMode.on);

    // Decrypt the file and open it
    crt.decryptFile(data.originalPath, data.destinationPath);
  }
}

import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';

class EncryptIsolateData {
  final String password;
  final String filePath;
  final Uint8List bytes;

  /// Creates a new [EncryptIsolateData]
  EncryptIsolateData({@required this.password, @required this.filePath, @required this.bytes});
}

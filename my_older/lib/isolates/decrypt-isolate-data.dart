import 'dart:isolate';

import 'package:flutter/widgets.dart';

class DecryptIsolateData {
  final String originalPath;
  final String password;
  final String fileName;
  final String destinationPath;

  DecryptIsolateData({
    @required this.originalPath,
    @required this.fileName,
    @required this.password,
    @required this.destinationPath,
  });
}

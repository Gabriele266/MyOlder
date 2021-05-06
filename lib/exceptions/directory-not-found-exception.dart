import 'package:flutter/foundation.dart';

class DirectoryNotFoundException implements Exception {
  final String directory;
  final String additionalMessage;

  // TODO: Document this constructor
  const DirectoryNotFoundException({@required this.directory, this.additionalMessage});

  @override
  String toString() =>
      'DirectoryNotFoundException: A required directory was not found. The directory is: '
      '$directory. The operation was: $additionalMessage';
}

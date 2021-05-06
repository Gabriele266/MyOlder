import 'package:flutter/foundation.dart';

class FileNotDefinedException implements Exception {
  final String operation;

  /// Creates a new [FileNotDefinedException]
  ///
  /// This exception can be thrown when a needed [file]
  /// isn't defined for a specific  [operation].
  const FileNotDefinedException(this.operation);

  @override
  String toString() =>
      'FileNotFoundException: a null file was given during the operation $operation. ';
}

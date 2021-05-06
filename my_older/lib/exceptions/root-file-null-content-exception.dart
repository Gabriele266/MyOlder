import 'package:flutter/foundation.dart';

class RootFileNullContentException implements Exception {
  // The file path
  final String file;

  // Operation
  final String operation;

  /// Creates a new [RootFileNullContentException]
  /// 
  /// This exception can be thrown when a root [file] for the application
  /// doesn't contain the needed informations (e.g) it's empty. The [operation] represents the
  /// function that needed this informations. 
  const RootFileNullContentException({@required this.file, this.operation});

  @override
  String toString() =>
      'RootFileNullContentException: The root file at path $file wasn\' t found from an executor. \nThe operation was: $operation';
}

import 'package:flutter/foundation.dart';

// TODO: Update documentation
class RootFileNullContentException implements Exception {
  // The file path
  final String file;

  // Operation
  final String operation;

  RootFileNullContentException({@required this.file, this.operation});

  @override
  String toString() =>
      'RootFileNullContentException: The root file at path $file wasn\' t found from an executor. \nThe operation was: $operation';
}

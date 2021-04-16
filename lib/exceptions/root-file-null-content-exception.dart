/// Created on 16/04/21 from gabriele
/// Project myolder

class RootFileNullContentException implements Exception {
  // The file path
  final String file;

  // Operation
  final String operation;

  RootFileNullContentException({this.file, this.operation});

  @override
  String toString() =>
      'RootFileNullContentException: The root file at path $file wasn\' t found from an executor. \nThe operation was: $operation';
}

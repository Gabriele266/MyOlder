class DirectoryNotFoundException implements Exception {
  final String directory;
  final String additionalMessage;

  DirectoryNotFoundException({this.directory, this.additionalMessage});

  @override
  String toString() =>
      'DirectoryNotFoundException: A required directory was not found. The directory is: '
      '$directory. The operation was: $additionalMessage';
}

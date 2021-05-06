import 'package:flutter/foundation.dart';

class DirectoryNotFoundException implements Exception {
  final String directory;
  final String additionalMessage;

  /// Creates a new [DirectoryNotFoundException] 
  /// 
  /// Represents an exception thrown when a required [directory]
  /// isn't found. If you wish you can add an [additionalMessage] to display among with this exception
  const DirectoryNotFoundException({@required this.directory, this.additionalMessage});

  @override
  String toString() =>
      'DirectoryNotFoundException: A required directory was not found. The directory is: '
      '$directory. The operation was: $additionalMessage';
}

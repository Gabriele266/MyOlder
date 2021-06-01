import '../constructs/safe-file.dart';

/// An exception thrown when 2 safefiles have the same origin
class SameOriginException implements Exception {
  final SafeFile first;
  final String message;

  /// Creates a new [SameOriginException] exception.
  ///
  /// [first] The first safeFile
  /// [second] The second safefile
  /// [message] The message to display
  SameOriginException(this.message, this.first);

  @override
  String toString() =>
      'SameOriginException: Two safeFiles have the same origin. This is a critical error. \nFirst file info: $first\n';
}

/// Represents an exception thrown when a null file is passed to this widget
class NullFileException implements Exception {
  final String _text;

  /// Creates a new [NullFileException] with the given data
  const NullFileException(this._text);

  @override
  String toString() =>
      'NullFileException: A null file was passed to a SafeFileInfoPage. $_text';
}

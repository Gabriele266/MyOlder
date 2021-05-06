import 'package:flutter/foundation.dart';

class FileNotFoundException implements Exception {
  final String file;
  final String path;

  /// Creates a new [FileNotFoundException]
  ///
  /// This exception can be thrown when a [file] isn't found
  /// into a specific [path] during an operation.
  const FileNotFoundException({@required this.file, @required this.path});

  @override
  String toString() =>
      'Eccezione FileNotFoundException. File non trovato. \nFile richiesto: $file\nPercorso di ricerca: $path';
}

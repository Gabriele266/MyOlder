import 'package:flutter/foundation.dart';

// TODO: Update documentation
class FileNotFoundException implements Exception {
    String file;
    String path;

    FileNotFoundException({@required this.file, @required this.path});

    @override
    String toString() =>
        'Eccezione FileNotFoundException. File non trovato. \nFile richiesto: $file\nPercorso di ricerca: $path';
}
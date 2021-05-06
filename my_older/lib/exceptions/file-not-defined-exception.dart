import 'package:flutter/foundation.dart';

// TODO: Update documentation
class FileNotDefinedException implements Exception {
    final String operation;

    FileNotDefinedException({@required this.operation});

    @override
    String toString() =>
        'FileNotFoundException: a null file was given during the operation $operation. ';
}
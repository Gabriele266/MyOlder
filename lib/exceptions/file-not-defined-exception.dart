class FileNotDefinedException implements Exception {
    final String operation;

    FileNotDefinedException({this.operation});

    @override
    String toString() =>
        'FileNotFoundException: a null file was given during the operation $operation. ';
}
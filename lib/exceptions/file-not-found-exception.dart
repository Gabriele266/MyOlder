class FileNotFoundException implements Exception {
    String file;
    String path;

    FileNotFoundException({this.file, this.path});

    @override
    String toString() =>
        'Eccezione FileNotFoundException. File non trovato. \nFile richiesto: $file\nPercorso di ricerca: $path';
}
import 'package:flutter/foundation.dart';

// TODO: Update documentation
class UserNotDefinedException implements Exception {
    final String operation;

    UserNotDefinedException({@required this.operation});

    @override
    String toString() {
        return 'UserNotDefinedException: During the operation $operation a null user was given to the function. ';
    }
}
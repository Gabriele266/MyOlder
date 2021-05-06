import 'package:flutter/foundation.dart';

class UserNotDefinedException implements Exception {
    final String operation;

    /// Creates a new [UserNotDefinedException]
    /// 
    /// This exception can be thrown when a user isn't specified during an [operation]
    /// e.g an authenticating operation. 
    const UserNotDefinedException({@required this.operation});

    @override
    String toString() {
        return 'UserNotDefinedException: During the operation $operation a null user was given to the function. ';
    }
}
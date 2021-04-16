class UserNotDefinedException implements Exception {
    final String operation;

    UserNotDefinedException({this.operation});

    @override
    String toString() {
        return 'UserNotDefinedException: During the operation $operation a null user was given to the function. ';
    }
}
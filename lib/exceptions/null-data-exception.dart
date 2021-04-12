/// Created on 31/03/21 from gabriele
/// Project myolder
/// NullDataException
import 'package:flutter/material.dart';

class NullDataException implements Exception{

    /// Creates a new instance of a NullDataException with a function name and
    /// an operation description.
    NullDataException(this._function, this._operationDescription);

    final String _function;
    final String _operationDescription;

    String get function => _function;
    String get operation => _operationDescription;

    @override
    String toString() => '\nNullDataException: A null data object was passed to the function $_function during '
        'the operation: $_operationDescription. ';
}

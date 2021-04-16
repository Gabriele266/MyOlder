/// Created on 31/03/21 from gabriele
/// Project myolder
/// NullDataException
import 'package:flutter/material.dart';

class NullDataException implements Exception{
    final String function;
    final String operationDescription;
    final String data;

    /// Creates a new instance of a NullDataException with a function name and
    /// an operation description.
    ///
    /// [function] The function that has been executed
    /// [operationDescription] A description to the operation
    /// [data] The data that was needed
    NullDataException({this.function, this.operationDescription, this.data});

    @override
    String toString() => '\nNullDataException: A null data object was passed to the function $function during '
        'the operation: $operationDescription. ';
}

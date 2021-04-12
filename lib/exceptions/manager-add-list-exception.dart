/// Created on 31/03/21 from gabriele
/// Project myolder
import 'package:flutter/material.dart';

class ManagerAddToListException implements Exception{
    /// Creates a new instance of a ManagerAddToListException, that represents an error
    /// during adding an element to the list
    ManagerAddToListException(this._object);

    final Object _object;

    Object get object => _object;

    @override
    String toString() => 'ManagerAddToListException: Exception during add object to a manager list. '
        'Object to add: $_object';
}

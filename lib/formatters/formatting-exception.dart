/// Created on 25/03/21 from gabriele
/// Project myolder
import 'package:flutter/material.dart';

class FormattingException implements Exception{
    final String _operation;

    /// Creates a new formatting exception with a specific message. 
    ///
    FormattingException(this._operation);
    
    @override
    String toString() => 'FormattingException. Exception during the operation of $_operation';
}

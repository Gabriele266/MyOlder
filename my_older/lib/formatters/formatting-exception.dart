
class FormattingException implements Exception{
    final String operation;

    /// Creates a new formatting exception with a specific message. 
    ///
    FormattingException(this.operation);
    
    @override
    String toString() => 'FormattingException. Exception during the operation of $operation';
}

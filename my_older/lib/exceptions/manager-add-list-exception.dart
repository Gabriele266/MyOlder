
// TODO: Make all fields public and use a named constructor
class ManagerAddToListException implements Exception{
    final Object _object;
    final String _managerList;

    /// Creates a new instance of a ManagerAddToListException, that represents an error during adding an element to the list
    ///
    /// [_object] The object that had to be added to the container
    /// [_managerList] The list where the manager tryed to add the object
    /// TODO: Update documentation
    ManagerAddToListException(this._object, this._managerList);

    Object get object => _object;

    @override
    String toString() => 'ManagerAddToListException: Exception during add object to a manager list. '
        'Object to add: $_object\n'
        'The manager list was: $_managerList';
}
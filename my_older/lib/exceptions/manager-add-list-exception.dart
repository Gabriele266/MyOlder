class ManagerAddToListException implements Exception{
    final Object object;
    final String managerList;

    /// Creates a new instance of a ManagerAddToListException, that represents an error during adding an element to the list
    ///
    /// [object] The object that had to be added to the container
    /// [managerList] The list where the manager tryed to add the object
    const ManagerAddToListException(this.object, this.managerList);

    @override
    String toString() => 'ManagerAddToListException: Exception during add object to a manager list. '
        'Object to add: $object\n'
        'The manager list was: $managerList';
}

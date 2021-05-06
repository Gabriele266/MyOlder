/// Created on 12/04/21 from gabriele
/// Project myolder

// TODO: Make all fields public and use named constructor for the exception
class ElementNotFoundException implements Exception{
    final String _elementName;
    final String _elementType;
    final String _container;

    /// Creates a new instance of an element not found exception
    ///
    /// [_elementName] Represents the element that wasn't found
    /// [_elementType] Represents the type of the element that wasn't found
    /// [_container] The place where the element should be saved
    /// TODO: Update documentation
    ElementNotFoundException(this._elementName, this._elementType, this._container);
    
    @override
    String toString() => 'ElementNotFoundException. The element $_elementName wasnt found in the list $_container. The type is: $_elementType';
}

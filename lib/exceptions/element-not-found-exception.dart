/// Created on 12/04/21 from gabriele
/// Project myolder

class ElementNotFoundException implements Exception{
    final String _elementName;
    final String _elementType;
    final String _container;

    /// Creates a new instance of an element not found exception
    ElementNotFoundException(this._elementName, this._elementType, this._container);
    
    @override
    String toString() => 'ElementNotFoundException. The element $_elementName wasnt found in the list $_container. The type is: $_elementType';
}

/// Created on 12/04/21 from gabriele
/// Project myolder

class ElementNotFoundException implements Exception{
    final String elementName;
    final String elementType;
    final String container;

    /// Creates a new instance of an element not found exception
    ///
    /// [elementName] Represents the element that wasn't found
    /// [elementType] Represents the type of the element that wasn't found
    /// [container] The place where the element should be saved
    ElementNotFoundException(this.elementName, this.elementType, this.container);
    
    @override
    String toString() => 'ElementNotFoundException. The elementName wasnt found in the list $container. The type is: $elementType';
}

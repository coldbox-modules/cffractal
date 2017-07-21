/**
* @name        Item
* @package     cffractal.models.resources
* @description Defines how to convert single items in to serializable data.
*/
component extends="cffractal.models.resources.AbstractResource" {

    /**
    * Processes the conversion of a resource to serializable data.
    * Also processes any default or requested includes.
    *
    * @scope   A Fractal scope instance.  Used to determinal requested
    *          includes and handle nesting identifiers.
    *
    * @returns The transformed data. 
    */
    function process( scope ) {
        var transformedItem = processItem(
            scope,
            isNull( data ) ? javacast( "null", "" ) : data
        );

        arrayEach( postTransformationCallbacks, function( callback ) {
            transformedItem = paramNull(
                callback(
                    transformedItem,
                    isNull( data ) ? javacast( "null", "" ) : data,
                    this
                ),
                scope.getNullDefaultValue()
            );
        } );

        return transformedItem;
    }

    /**
    * Returns false as an item is never paged.
    *
    * @returns false
    */
    function hasPagingData() {
        return false;
    }

}
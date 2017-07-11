/**
* @name        Collection
* @package     cffractal.models.resources
* @description Defines how to convert collections in to serializable data.
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
        if ( isNull( data ) ) {
            var transformedItem = processItem(
                scope,
                javacast( "null", "" )
            );

            arrayEach( postTransformationCallbacks, function( callback ) {
                callback(
                    isNull( transformedItem ) ? javacast( "null", "" ) : transformedItem,
                    isNull( data ) ? javacast( "null", "" ) : data,
                    this
                );
            } );

            return isNull( transformedItem ) ? javacast( "null", "" ) : transformedItem;
        }

        var transformedDataArray = [];
        for ( var value in data ) {
            var transformedItem = processItem( scope, value );
            for ( var callback in postTransformationCallbacks ) {
                transformedItem = callback(
                    isNull( transformedItem ) ? javacast( "null", "" ) : transformedItem,
                    isNull( value ) ? javacast( "null", "" ) : value,
                    this
                );
            }
            arrayAppend(
                transformedDataArray,
                isNull( transformedItem ) ? javacast( "null", "" ) : transformedItem
            );
        }
        return transformedDataArray;
    }

}
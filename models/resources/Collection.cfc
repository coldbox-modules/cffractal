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
        if ( isNull( variables.data ) ) {
            return [];
        }

        var transformedDataArray = [];

        arrayEach( variables.data, function( value ){
        	var transformedItem = processItem( scope, value );
            for ( var callback in variables.postTransformationCallbacks ) {
                transformedItem = paramNull(
                    callback(
                        transformedItem,
                        isNull( value ) ? javacast( "null", "" ) : value,
                        this
                    ),
                    scope.getNullDefaultValue()
                );
            }
            arrayAppend(
                transformedDataArray,
                transformedItem
            );
        } );

        return transformedDataArray;
    }

}

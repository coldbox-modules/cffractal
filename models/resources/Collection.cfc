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
            return processItem( scope, javacast( "null", "" ) );
        }

        var transformedDataArray = [];
        for ( var value in data ) {
            arrayAppend(
                transformedDataArray,
                processItem( scope, value )
            );
        }
        return transformedDataArray;
    }

}
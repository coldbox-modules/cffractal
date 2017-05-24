/**
* @name        Collection
* @package     fractal.models.resources
* @description Defines how to convert collections in to serializable data.
*/
component
    accessors="true"
    extends="fractal.models.resources.AbstractResource"
{

    /**
    * Defines the method for transforming a collection
    * of data into a serializable format.
    *
    * @returns The transformed data.
    */
    function transform() {
        var transformedData = [];
        for ( var value in getData() ) {
            arrayAppend(
                transformedData,
                transformData( getTransformer(), value )
            );
        }
        return transformedData;
    }

}
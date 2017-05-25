/**
* @name        AbstractResource
* @package     fractal.models.resources
* @description Defines the common methods for processing
*              resources into serializable data.
*/
component {

    /**
    * The item to transform into serializable data. 
    */
    property name="data";

    /**
    * The transformer component or callback used to transform the data.
    */
    property name="transformer";

    /**
    * Creates a new Fractal resource.
    *
    * @data        The data to be transformed into serializable data.
    * @transformer The transformer component or callback to
    *              use to transform the data.
    *
    * @returns     A Fractal resource.
    */
    function init( data, transformer ) {
        variables.data = arguments.data;
        variables.transformer = arguments.transformer;
        return this;
    }

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
        var transformedData = transform();
        
        if ( isClosure( transformer ) ) {
            return transformedData;
        }

        if ( ! transformer.hasIncludes() ) {
            return transformedData;
        }

        var includedData = transformer.processIncludes( scope, data );
        
        for ( var includedDataSet in includedData ) {
            structAppend( transformedData, includedDataSet, true /* overwrite */ );
        }

        return transformedData;
    }

    /**
    * @abstract
    * Defines the method for transforming a specific kind of resource.
    *
    * @returns The transformed data.
    */
    function transform() {
        throw(
            type = "MethodNotImplemented",
            message = "The method `transform()` must be implemented in a subclass."
        );
    }

    /**
    * Handles the calling of the transformer,
    * whether a callback or a component.
    *
    * @transformer The callback or component to use to transform the data.
    * @data        The data to transform.
    *
    * @returns     The transformed data.
    */
    private function transformData( transformer, data ) {
        return isClosure( transformer ) ?
            transformer( data ) :
            transformer.transform( data );
    }

}
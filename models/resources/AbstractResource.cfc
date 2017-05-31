/**
* @name        AbstractResource
* @package     cffractal.models.resources
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
    * Creates a new cffractal resource.
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
    * @abstract
    * Processes the conversion of a resource to serializable data.
    * Also processes any default or requested includes.
    *
    * @scope   A Fractal scope instance.  Used to determinal requested
    *          includes and handle nesting identifiers.
    *
    * @returns The transformed data. 
    */
    function process( scope ) {
        throw(
            type = "MethodNotImplemented",
            message = "The method `process()` must be implemented in a subclass."
        );
    }

    /**
    * Processes the conversion of a single item to serializable data.
    * Also processes any default or requested includes.
    *
    * @scope   A Fractal scope instance.  Used to determinal requested
    *          includes and handle nesting identifiers.
    * @item    A single item instance to transform.
    *
    * @returns The transformed data. 
    */
    function processItem( scope, item ) {
        var transformedData = transformData( transformer, item );

        if ( isClosure( transformer ) ) {
            return transformedData;
        }

        if ( ! transformer.hasIncludes() ) {
            return transformedData;
        }

        var includedData = transformer.processIncludes( scope, item );

        for ( var includedDataSet in includedData ) {
            structAppend( transformedData, includedDataSet, true /* overwrite */ );
        }

        return transformedData;    
    }

    /**
    * Handles the calling of the transformer,
    * whether a callback or a component.
    *
    * @transformer The callback or component to use to transform the item.
    * @item        The item to transform.
    *
    * @returns     The transformed data.
    */
    private function transformData( transformer, item ) {
        return isClosure( transformer ) ?
            transformer( item ) :
            transformer.transform( item );
    }

}
/**
* @name        AbstractTransformer
* @package     cffractal.models.transformers
* @description Defines the common methods for transforming
*              resources, including processing includes,
*              and creating new resources.
*/
component {

    /**
    * A WireBox instance for ColdBox users to easily
    * retrieve new transformers for includes.
    */
    property name="wirebox" inject="wirebox";
    property name="manager" inject="Manager@cffractal";

    /**
    * Define includes properties to allow for accessors
    **/
    property name="defaultIncludes";
    property name="availableIncludes";
    
    /**
    * The array of default includes.
    * These includes are always return whether requested or not.
    * These are normally set by setting the `variables.defaultIncludes`
    * inside a concrete Transformer component.
    */
    variables.defaultIncludes = [];

    /**
    * The array of available includes.
    * These includes are only returned if requested in the Fractal Manager.
    * These are normally set by setting the `variables.availableIncludes`
    * inside a concrete Transformer component.
    */
    variables.availableIncludes = [];

    /**
    * @abstract
    * Defines the method for transforming a specific resource.
    *
    * @data    The data or component to transform.
    *
    * @returns The transformed data.
    */
    function transform( data ) {
        throw(
            type = "MethodNotImplemented",
            message = "The method `transform()` must be implemented in a subclass."
        );
    }

    /**
    * Allows the user to set a custom fractal Manager
    **/
    function setManager( required any manager ){
        variables.manager = arguments.manager;
        return this;
    }

    /**
    * Determines if a transformer has any available or default includes.
    *
    * @returns True if a transformer has any available or default includes.
    */
    function hasIncludes() {
        return ! arrayIsEmpty( variables.availableIncludes ) ||
               ! arrayIsEmpty( variables.defaultIncludes );
    }

    /**
    * Processes any available includes and returns the transformed data.
    *
    * @scope   The current Fractal scope.  Used to find request includes
    *          and to set the current nesting identifier.
    * @data    The data or component off of which to base the include.
    *
    * @returns An array of transformed data to merge in to the current scope.
    */
    function processIncludes( scope, data ) {
        var allIncludes = filterIncludes( scope );
        var includedData = [];
        for ( var include in allIncludes ) {
            var resource = invoke( this, "include#include#", { 1 = data } );
            var childScope = scope.embedChildScope( include, resource );
            arrayAppend( includedData, childScope.convert() );
        }
        return includedData;
    }

    /**
    * Filters all includes down to default includes and requested available includes.
    *
    * @scope   The current Fractal scope.  Used to determine if
    *          an available includes was requested.
    *
    * @returns An array of includes to fetch for the transformer.
    */
    private array function filterIncludes( scope ) {
        var filteredIncludes = variables.defaultIncludes;
        for ( var include in variables.availableIncludes ) {
            if ( scope.requestedInclude( include ) ) {
                arrayAppend( filteredIncludes, include );
            }
        }
        return filteredIncludes;
    }

    /**
    * Returns a new item resource with the given data and transformer.
    * Used primarily inside a includes method.
    *
    * @data        The data or component to transform.
    * @transformer The transformer callback or component to use
    *              transforming the above data.
    *
    * @returns A new cffractal Item wrapping the given data and transformer.
    */
    private function item( data, transformer, serializer ) {
        return manager.item( argumentCollection = arguments );
    }

    /**
    * Returns a new collection resource with the given data and transformer.
    * Used primarily inside a includes method.
    *
    * @data        The data or component to transform.
    * @transformer The transformer callback or component to use
    *              transforming the above data.
    *
    * @returns A new cffractal Collection wrapping the given data and transformer.
    */
    private function collection( data, transformer, serializer ) {
        return manager.collection( argumentCollection = arguments );
    }
}

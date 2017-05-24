/**
* @name        AbstractTransformer
* @package     fractal.models.transformers
* @description Defines the common methods for transforming
*              resources, including processing includes,
*              and creating new resources.
*/
component {

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

    function transform( scope ) {
        throw(
            type = "MethodNotImplemented",
            message = "The method `transform()` must be implemented in a subclass."
        );
    }

    function hasIncludes() {
        return ! arrayIsEmpty( variables.defaultIncludes ) || ! arrayIsEmpty( variables.availableIncludes );
    }

    function processIncludes( scope, data ) {
        var allIncludes = filterIncludes( scope );
        var includedData = [];
        for ( var include in allIncludes ) {
            var resource = invoke( this, "include#include#", { 1 = data } );
            var childScope = scope.embedChildScope( include, resource );
            arrayAppend( includedData, childScope.toStruct() );
        }
        return includedData;
    }

    private array function filterIncludes( scope ) {
        var filteredIncludes = variables.defaultIncludes;
        for ( var include in variables.availableIncludes ) {
            if ( scope.requestedInclude( include ) ) {
                arrayAppend( filteredIncludes, include );
            }
        }
        return filteredIncludes;
    }

    private function item( data, transformer ) {
        return new fractal.models.resources.Item( data, transformer );
    }

    private function collection( data, transformer ) {
        return new fractal.models.resources.Collection( data, transformer );
    }
}
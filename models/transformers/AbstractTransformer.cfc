/**
* @name        AbstractTransformer
* @package     fractal.models.transformers
* @description Defines the common methods for processing
*              resources into serializable data.
*/
component accessors="true" {

    property name="defaultIncludes";
    property name="availableIncludes";

    function init() {
        param variables.defaultIncludes = [];
        param variables.availableIncludes = [];
        return this;
    }

    function transform( scope ) {
        throw(
            type = "MethodNotImplemented",
            message = "The method `transform()` must be implemented in a subclass."
        );
    }

    function hasIncludes() {
        return ! arrayIsEmpty( getDefaultIncludes() ) || ! arrayIsEmpty( getAvailableIncludes() );
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
        var filteredIncludes = getDefaultIncludes();
        for ( var include in getAvailableIncludes() ) {
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
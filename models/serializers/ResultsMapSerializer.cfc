/**
* @name        ResultMapSerializer
* @package     cffractal.models.serializers
* @description Nests the data under a "resultMap" key
*              as well as providing an array of ids.
*/
component singleton {

    /**
    * The primary key name for the dataset.
    */
    property name="identitifer";

    /**
    * Creates a new ResultMapSerializer with the given identifier.
    *
    * @identifier The key name for the identifing piece of data.
    *             This data will be stored in an array of results.
    *
    * @returns    The serializer instance.
    */
    function init( identifier = "id" ) {
        variables.identifier = arguments.identifier;
        return this;
    }

    /**
    * Returns an array of primary keys along with a map
    * of the data keyed by those same primary keys.
    *
    * @resource The resource to serialize.
    * @scope    A reference to the current Fractal scope.
    *
    * @returns  The processed resource ids and associated map.
    */
    function data( resource, scope ) {
        var processedData = resource.process( scope );

        if ( ! isArray( processedData ) ) {
            return processedData;
        }

        var ids = [];
        var map = {};
        for ( var item in processedData ) {
            arrayAppend( ids, item[ identifier ] );
            map[ item[ identifier ] ] = item;
        }

        return {
            "results" = ids,
            "resultsMap" = map
        };
    }

    /**
    * Decides how to nest the data under the given identifier.
    *
    * @data       The serialized data.
    * @identifier The current identifier for the serialization process.
    *
    * @returns    The scoped, serialized data.
    */
    function scopeData( data, identifier ) {
        return { "#listLast( arguments.identifier, "." )#" = data };
    }

    /**
    * Decides which key to use (if any) for the root of the serialized data.
    *
    * @data       The serialized data.
    * @identifier The current identifier for the serialization process.
    *
    * @returns    The scoped, serialized data.
    */
    function scopeRootKey( data, identifier ) {
        return data;
    }

    /**
    * Returns the metadata nested under a meta key.
    *
    * @data     The metadata for the response.
    *
    * @response The metadata nested under a "meta" key.
    */
    function meta( resource, scope ) {
        return { "meta" = resource.getMeta() };
    }

}

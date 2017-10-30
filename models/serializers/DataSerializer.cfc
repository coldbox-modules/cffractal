/**
* @name        DataSerializer
* @package     cffractal.models.serializers
* @description Nests the data under a "data" key in a struct.
*/
component singleton {

    /**
    * Nests the data underneath a 'data' key.
    *
    * @resource The resource to serialize.
    * @scope    A reference to the current Fractal scope.
    *
    * @returns  The processed resource nested under a "data" key.
    */
    function data( resource, scope ) {
        return { "data" = resource.process( scope ) };
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
        return { "#listLast( identifier, "." )#" = { "data" = data } };
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
    function meta( resource, scope, data ) {
        structAppend( data, { "meta" = resource.getMeta() }, true );
        return data;
    }

}

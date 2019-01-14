/**
* @name        SimpleSerializer
* @package     cffractal.models.serializers
* @description Does no further transformation to the data.
*/
component singleton {

    /**
    * Does no further transformation to the data.
    *
    * @resource The resource to serialize.
    * @scope    A reference to the current Fractal scope.
    *
    * @returns  The processed resource, unnested.
    */
    function data( resource, scope ) {
        return resource.process( scope );
    }

    /**
    * Decides how to nest the data under the given identifier.
    *
    * @resource   The serializing resource.
    * @scope      The current cffractal scope..
    * @identifier The current identifier for the serialization process.
    *
    * @returns    The scoped, serialized data.
    */
    function scopeData( resource, scope, identifier ) {
        var serializedData = data( resource, scope );

        if ( resource.hasPagingData() ) {
            resource.addMeta( "pagination", resource.getPagingData() );
        }

        if ( resource.hasMeta() ) {
            meta( resource, scope, serializedData );
        }

        return { "#listLast( identifier, "." )#" = serializedData };
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
        return resource.getMeta();
    }

}

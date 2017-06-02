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
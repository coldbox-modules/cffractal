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
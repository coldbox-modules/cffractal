/**
* @name        DataSerializer
* @package     fractal.models.serializers
* @description Nests the data under a "data" key in a struct.
*/
component singleton implements="fractal.models.serializers.ISerializer" {

    /**
    * Nests the data underneath a 'data' key.
    *
    * @data    The array or struct of data to serialize.
    *
    * @returns The transformed data.
    */
    function serialize( data ) {
        return { "data" = data };
    }

}
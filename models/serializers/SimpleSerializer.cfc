/**
* @name        SimpleSerializer
* @package     fractal.models.serializers
* @description Does no further transformation to the data.
*/
component singleton implements="fractal.models.serializers.ISerializer" {

    /**
    * Does no further transformation to the data.
    *
    * @data    The array or struct of data to serialize.
    *
    * @returns The data unmodified.
    */
    function serialize( data ) {
        return data;
    }

}
/**
* @name        ISerializer
* @package     fractal.models.serializers
* @description Defines the required method for serializing Fractal data.
*/
interface {

    /**
    * Transforms the data according to a specific specification.
    *
    * @data    The array or struct of data to serialize.
    *
    * @returns The transformed data.
    */
    function serialize( data );

}
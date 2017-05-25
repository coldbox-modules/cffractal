/**
* @name        Collection
* @package     fractal.models.resources
* @description Defines how to convert single items in to serializable data.
*/
component extends="fractal.models.resources.AbstractResource" {

    /**
    * Defines the method for transforming a single item into a serializable format.
    *
    * @returns The transformed data.
    */    
    function transform() {
        return transformData(
            transformer,
            data
        );
    }

}
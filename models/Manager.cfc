/**
* @name        Manager
* @package     fractal.models
* @description The Manager component is responsible for kickstarting
*              the api transformation process.  It creates the root
*              scope and serializes the transformed value.
*/
component singleton {

    /**
    * The serializer instance.
    */
    property name="serializer";

    /**
    * Create a new Manager instance.
    *
    * @serializer The serializer to use to serialize the data.
    *
    * @returns    The Fractal Manager.
    */
    function init( serializer ) {
        variables.serializer = arguments.serializer;
        return this;
    }


    /**
    * Sets a new serializer to use to serialize the data.
    *
    * @serializer The serializer to use to serialize the data.
    *
    * @returns The Fractal Manager.
    */
    function setSerializer( serializer ) {
        variables.serializer = arguments.serializer;
        return this;
    }

    /**
    * Creates a scope for a given resource and identifier.
    *
    * @resource        A Fractal resource.
    * @includes        A list of includes for the scope.  Includes are
    *                  comma separated and use dots to designate
    *                  nested resources to be included.
    * @identifier The scope identifier defining the nesting level.
    *                  Defaults to the root level.
    *
    * @returns         A Fractal scope primed with the given resource and identifier.
    */
    function createData( resource, includes = "", identifier = "" ) {
        arguments.manager = this;
        return new fractal.models.Scope( argumentCollection = arguments );
    }

    /**
    * Serialize the data through the set serializer.
    *
    * @data    The array or struct of data to serialize.
    *
    * @returns The serialized data.
    */
    function serialize( data ) {
        return serializer.serialize( data );
    }

}
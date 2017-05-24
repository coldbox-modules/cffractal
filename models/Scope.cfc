/**
* @name        Scope
* @package     fractal.models
* @description The Scope component is responsible for encapsulating the api
*              transformation process for a single specific resource
*              and serializing the result.
*/
component {

    /**
    * A reference to the Fractal Manager.
    */
    property name="manager";

    /**
    * The specific resource to transform and serialize.
    */
    property name="resource";

    /**
    * The resource identifier for the specific resource.
    * Used to determine the correct nesting level.
    */
    property name="identifier";

    /**
    * Returns a new scoped resource at a given identifier.
    *
    * @manager    A reference to a Fractal manager that has the needed includes.
    * @resource   The specific resoruce to transform and serialize.
    * @identifier Optional. The resource identifier for the specific resource. Default: "".
    *
    * @returns    A scoped resource instance.
    */
    function init( manager, resource, identifier = "" ) {
        variables.manager = arguments.manager;
        variables.resource = arguments.resource;
        variables.identifier = arguments.identifier;
        return this;
    }

    /**
    * Checks with the manager if the specified include is
    * requested for the scope's current identifier.
    *
    * @include The include to check if it is requested for the scope's current identifier.
    *
    * @returns True, if the include is requested.
    */
    function requestedInclude( include ) {
        return variables.manager.requestedInclude( include, variables.identifier );
    }

    /**
    * Create a new Scope with a given scope identifier.
    *
    * @identifier The resource identifier for the specific resource.
    * @resource   The specific child resoruce to transform and serialize.
    *
    * @returns    A scoped resource instance.
    */
    function embedChildScope( identifier, resource ) {
        return variables.manager.createData( arguments.resource, arguments.identifier );
    }

    /**
    * Converts the scoped resource to a struct.
    * The scoped resource is processed through the
    * assigned transformer and serializer.
    *
    * @returns The transformed and serialized data.
    */
    function toStruct() {
        var serializedData = variables.manager.serialize(
            variables.resource.process( this )
        );

        if ( variables.identifier == "" ) {
            return serializedData;
        }

        return { "#variables.identifier#" = serializedData };
    }

    /**
    * Converts the scoped resource to json.
    * The scoped resource is processed through the
    * assigned transformer and serializer.
    *
    * @returns The transformed and serialized data as json.
    */
    function toJSON() {        
        return serializeJSON( toStruct() );
    }

}
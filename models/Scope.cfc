
component {

    property name="manager";
    property name="resource";
    property name="identifier";

    function init( manager, resource, identifier = "" ) {
        variables.manager = arguments.manager;
        variables.resource = arguments.resource;
        variables.identifier = arguments.identifier;
        return this;
    }

    function requestedInclude( include ) {
        return variables.manager.requestedInclude( include, variables.identifier );
    }

    function embedChildScope( identifier, resource ) {
        return variables.manager.createData( arguments.resource, arguments.identifier );
    }

    function toStruct() {
        var serializedData = variables.manager.serialize(
            variables.resource.process( this )
        );

        if ( variables.identifier == "" ) {
            return serializedData;
        }

        return { "#variables.identifier#" = serializedData };
    }

    function toJSON() {        
        return serializeJSON( toStruct() );
    }

}
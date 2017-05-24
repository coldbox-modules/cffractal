component accessors="true" {

    property name="manager";
    property name="resource";
    property name="identifier";

    function init( manager, resource, identifier = "" ) {
        setManager( manager );
        setResource( resource );
        setIdentifier( identifier );
        return this;
    }

    function requestedInclude( include ) {
        return getManager().requestedInclude( include, getIdentifier() );
    }

    function embedChildScope( identifier, resource ) {
        return getManager().createData( resource, identifier );
    }

    function toStruct() {
        var serializedData = getManager().serialize(
            getResource().process( this )
        );

        if ( getIdentifier() == "" ) {
            return serializedData;
        }

        return { "#getIdentifier()#" = serializedData };
    }

    function toJSON() {        
        return serializeJSON( toStruct() );
    }

}
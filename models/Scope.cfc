component accessors="true" {

    property name="manager";
    property name="resource";
    property name="ScopeIdentifier";

    function init( manager, resource, scopeIdentifier = "" ) {
        setManager( manager );
        setResource( resource );
        setScopeIdentifier( scopeIdentifier );
        return this;
    }

    function requestedInclude( include ) {
        return getManager().requestedInclude( include, getScopeIdentifier() );
    }

    function embedChildScope( scopeIdentifier, resource ) {
        return getManager().createData( resource, scopeIdentifier );
    }

    function toStruct() {
        var serializedData = getManager().serialize(
            getResource().process( this )
        );

        if ( getScopeIdentifier() == "" ) {
            return serializedData;
        }

        return { "#getScopeIdentifier()#" = serializedData };
    }

    function toJSON() {        
        return serializeJSON( toStruct() );
    }

}
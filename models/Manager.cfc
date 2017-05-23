component accessors="true" {

    property name="serializer";
    property name="includes";

    function init( serializer, includes = [] ) {
        setSerializer( serializer );
        setIncludes( includes );
        return this;
    }

    function createData( resource, scopeIdentifier = "" ) {
        return new fractal.models.Scope( this, resource, scopeIdentifier );
    }

    function serialize( data ) {
        return getSerializer().serialize( data );
    }

    function parseIncludes( includes ) {
        variables.includes = includes;
        return this;
    }

    function requestedInclude( needle ) {
        for ( var include in variables.includes ) {
            if ( compareNoCase( needle, include ) == 0 ) {
                return true;
            }
        }
        return false;
    }

}
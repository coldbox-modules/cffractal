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
        variables.includes = listToArray( includes );
        addParentIncludes();
        return this;
    }

    function addParentIncludes() {
        var parentIncludes = [];
        for ( var include in variables.includes ) {
            var scopes = listToArray( include, "." );

            for ( var i = 1; i <= arrayLen( scopes ); i++ ) {
                var selectedScopes = [];
                for ( var j = 1; j <= i; j++ ) {
                    arrayAppend( selectedScopes, scopes[ j ] );
                }
                var scopeString = arrayToList( selectedScopes, "." );
                if ( ! requestedInclude( scopeString ) ) {
                    arrayAppend( parentIncludes, scopeString );
                }
            }
        }
        arrayAppend( variables.includes, parentIncludes, true );
    }

    function requestedInclude( needle, scopeIdentifier = "" ) {
        if ( scopeIdentifier != "" ) {
            arguments.needle = "#scopeIdentifier#.#needle#";
        }

        for ( var include in variables.includes ) {
            if ( compareNoCase( needle, include ) == 0 ) {
                return true;
            }
        }
        return false;
    }

}
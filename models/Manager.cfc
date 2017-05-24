/**
* @name        Manager
* @package     fractal.models
* @description The Manager class is responsible for kickstarting
*              the api transformation process.  It orchestrates
*              the requested includes, creates the root scope,
*              and serializes the transformed value.
*/
component accessors="true" {

    /**
    * The serializer instance.
    */
    property name="serializer";

    /**
    * The array of requested includes.
    */
    property name="includes";

    /**
    * Create a new Manager instance.
    *
    * @serializer The serializer to use to transform the data.
    *
    * @returns    The Fractal Manager.
    */
    function init( serializer ) {
        setSerializer( serializer );
        setIncludes( [] );
        return this;
    }

    /**
    * Creates a scope for a given resource and identifier.
    *
    * @resource        A Fractal resource.
    * @scopeIdentifier The scope identifier defining the nesting level.
    *                  Defaults to the root level.
    *
    * @returns         A Fractal scope primed with the given resource and identifier.
    */
    function createData( resource, scopeIdentifier = "" ) {
        return new fractal.models.Scope( this, resource, scopeIdentifier );
    }

    /**
    * Serialize the data through the set serializer.
    *
    * @data    The array or struct of data to serialize.
    *
    * @returns The serialized data.
    */
    function serialize( data ) {
        return getSerializer().serialize( data );
    }

    /**
    * Parse the list of includes, including parent includes not specified.
    *
    * @includes A list of includes.
    *
    * @returns  The Fractal manager.
    */
    function parseIncludes( includes ) {
        setIncludes( listToArray( includes ) );
        addParentIncludes();
        return this;
    }

    /**
    * Add parent includes not specified in the list of includes.
    *
    * When a nested resource is specified like `author.country` make
    * sure the includes has each parent as well (`author` in this case).
    */
    private function addParentIncludes() {
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

    /**
    * Returns if an include is requested.
    *
    * @needle          The include to see if it is requested.
    * @scopeIdentifier Optional. The scope identifier for the current scope.
    *                  If present, this will be prepended to the needle.
    *
    * @returns         True, if the include is requested.
    */
    function requestedInclude( needle, scopeIdentifier = "" ) {
        if ( scopeIdentifier != "" ) {
            needle = "#scopeIdentifier#.#needle#";
        }

        for ( var include in variables.includes ) {
            if ( compareNoCase( needle, include ) == 0 ) {
                return true;
            }
        }
        return false;
    }

}
/**
* @name        Scope
* @package     cffractal.models
* @description The Scope component is responsible for encapsulating the api
*              transformation process for a single specific resource
*              and serializing the result.
*/
component accessors="true" {

    /**
    * A reference to the Fractal Manager.
    */
    property name="manager";

    /**
    * The specific resource to transform and serialize.
    */
    property name="resource";

    /**
    * The array of requested includes.
    */
    property name="includes";

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
    * @includes   A list of includes for the scope.  Includes are
    *             comma separated and use dots to designate
    *             nested resources to be included.
    * @identifier Optional. The resource identifier for the specific resource. Default: "".
    *
    * @returns    A scoped resource instance.
    */
    function init( manager, resource, includes = "", identifier = "" ) {
        variables.manager = arguments.manager;
        variables.resource = arguments.resource;
        variables.identifier = arguments.identifier;

        parseIncludes( arguments.includes );

        return this;
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
        arguments.identifier = combineIdentifiers( variables.identifier, arguments.identifier );
        arguments.includes = arrayToList( includes );
        return manager.createData( argumentCollection = arguments );
    }

    /**
    * Converts the scoped resource to a struct.
    * The scoped resource is processed through the
    * assigned transformer and serializer.
    *
    * @returns The transformed and serialized data.
    */
    function convert() {
        var serializer = resource.getSerializer();

        if ( identifier != "" ) {
            return serializer.scopeData( resource.process( this ), identifier );
        }

        var serializedData = serializer.data( resource, this );

        serializedData = serializer.scopeRootKey( serializedData, resource.getTransformerResourceKey() );

        if ( resource.hasPagingData() ) {
            resource.addMeta( "pagination", resource.getPagingData() );
        }

        if ( resource.hasMeta() ) {
            serializer.meta( resource, this, serializedData );
        }

        return serializedData;
    }

    /**
    * Converts the scoped resource to json.
    * The scoped resource is processed through the
    * assigned transformer and serializer.
    *
    * @returns The transformed and serialized data as json.
    */
    function toJSON() {
        return serializeJSON( convert() );
    }

    /**
    * Returns the manager's null default value.
    *
    * @returns The null default value.
    */
    function getNullDefaultValue() {
        return variables.manager.getNullDefaultValue();
    }

    /**
    * Returns if an include is requested.
    *
    * @needle          The include to see if it is requested.
    *
    * @returns         True, if the include is requested.
    */
    function requestedInclude( needle ) {
        if ( identifier != "" ) {
            needle = "#identifier#.#needle#";
        }

        for ( var include in includes ) {
            if ( compareNoCase( needle, include ) == 0 ) {
                return true;
            }
        }
        return false;
    }

    /**
    * Parse the list of includes, including parent includes not specified.
    *
    * @includes A list of includes.
    *
    * @returns  The Fractal manager.
    */
    private function parseIncludes( includes ) {
        variables.includes = listToArray( arguments.includes );
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
        // we create a temporary array to store the additional includes in
        // because you cannot concurrently loop over and modify an array.
        var parentIncludes = [];
        for ( var include in includes ) {
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
        arrayAppend( includes, parentIncludes, true );
    }

    private function combineIdentifiers( identifierA, identifierB ) {
        var combinedIdentifier = identifierA & "." & identifierB;
        if ( left( combinedIdentifier, 1 ) == "." ) {
            return mid( combinedIdentifier, 2, len( combinedIdentifier ) - 1 );
        }
        return combinedIdentifier;
    }

}

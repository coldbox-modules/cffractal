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
    * The array of requested excludes.
    */
    property name="excludes";

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
    * @excludes   A list of excludes for the scope.  Excludes are
    *             comma separated and use dots to designate
    *             nested resources to be excluded.
    * @identifier Optional. The resource identifier for the specific resource. Default: "".
    *
    * @returns    A scoped resource instance.
    */
    function init( manager, resource, includes = "", excludes = "", identifier = "" ) {
        variables.manager = arguments.manager;
        variables.resource = arguments.resource;
        variables.identifier = arguments.identifier;

        parseExcludes( arguments.excludes );
        parseIncludes( arguments.includes );

        return this;
    }

    /**
     * Return the includes for the scope.
     *
     * @scoped  If true, only pass the current level of includes with no nesting,
     *
     * @returns An array of includes.
     */
    function getIncludes( scoped = false ) {
        if ( ! scoped ) {
            return variables.includes;
        }

        var scopedIncludes = [];
        for ( var include in variables.includes ) {
            var scopedInclude = include;
            if ( identifier != "" && find( ".", scopedInclude ) <= 0 ) {
                continue;
            }
            if ( identifier != "" ) {
                scopedInclude = replaceNoCase( scopedInclude, identifier & ".", "" );
            }
            if ( scopedInclude != "" && find( ".", scopedInclude ) <= 0  ) {
                arrayAppend( scopedIncludes, listFirst( scopedInclude, "." ) );
            }
        }
        return scopedIncludes;
    }

    /**
     * Return the excludes for the scope.
     *
     * @scoped  If true, only pass the current level of excludes with no nesting,
     *
     * @returns An array of excludes.
     */
    function getExcludes( scoped = false ) {
        if ( ! scoped ) {
            return variables.excludes;
        }

        var scopedExcludes = [];
        for ( var exclude in variables.excludes ) {
            if ( identifier == "" ) {
                if ( find( ".", exclude ) <= 0 ) {
                    arrayAppend( scopedExcludes, exclude );
                }
            }
            else {
                if ( find( ".", exclude ) <= 0 ) {
                    continue;
                }
                var scopedExclude = replaceNoCase( exclude, identifier & ".", "" );
                if ( find( ".", scopedExclude ) <= 0 ) {
                    arrayAppend( scopedExcludes, scopedExclude );
                }
            }
        }

        return scopedExcludes;
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
        arguments.excludes = arrayToList( excludes );
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
            return serializer.scopeData( resource, this, identifier );
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
    * @needle  The include to see if it is requested.
    *
    * @returns True, if the include is requested.
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
    * Returns if an exclude is requested.
    *
    * @needle  The exclude to see if it is requested.
    *
    * @returns True, if the exclude is requested.
    */
    function requestedExclude( needle ) {
        if ( identifier != "" ) {
            needle = "#identifier#.#needle#";
        }

        for ( var exclude in excludes ) {
            if ( compareNoCase( needle, exclude ) == 0 ) {
                return true;
            }
        }

        return false;
    }

    /**
     * Return the excludes for the specified level.
     *
     * @returns The excludes minus the identifier (if any).
     */
    function filteredExcludes() {
        var collection = [];
        for ( var exclude in excludes ) {
            if ( identifier == "" ) {
                arrayAppend( collection, exclude );
            }
            else {
                arrayAppend( collection, replaceNoCase( exclude, identifier & ".", "" ) );
            }
        }
        return arrayFilter( collection, function( item ) {
            return item != "";
        } );
    }

    /**
    * Parse the list of includes, including parent includes not specified.
    *
    * @includes A list of includes.
    *
    * @returns  The Scope instance.
    */
    private function parseIncludes( includes ) {
        variables.includes = listToArray( arguments.includes );
        addParentIncludes();
        return this;
    }

    /**
    * Parse the list of excludes,.
    *
    * @excludes A list of excludes.
    *
    * @returns  The Scope instance.
    */
    private function parseExcludes( excludes ) {
        variables.excludes = listToArray( arguments.excludes );
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
            if ( arrayLen( scopes ) <= 1 ) {
                continue;
            }
            var scopesToAdd = arraySlice( scopes, 1, arrayLen( scopes ) - 1 );
            for ( var i = 1; i <= arrayLen( scopesToAdd ); i++ ) {
                arrayAppend( parentIncludes, arrayToList( arraySlice( scopesToAdd, 1, i ), "." ) );
            }
        }
        for ( var parentInclude in parentIncludes ) {
            if ( ! arrayContains( variables.includes, parentInclude ) ) {
                arrayAppend( variables.includes, parentInclude );
            }
        }
    }

    private function combineIdentifiers( identifierA, identifierB ) {
        var combinedIdentifier = identifierA & "." & identifierB;
        if ( left( combinedIdentifier, 1 ) == "." ) {
            return mid( combinedIdentifier, 2, len( combinedIdentifier ) - 1 );
        }
        return combinedIdentifier;
    }

}

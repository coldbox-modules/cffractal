/**
* @name        AbstractTransformer
* @package     cffractal.models.transformers
* @description Defines the common methods for transforming
*              resources, including processing includes,
*              and creating new resources.
*/
component accessors="true" {

    /**
    * A WireBox instance for ColdBox users to easily
    * retrieve new transformers for includes.
    */
    property name="wirebox" inject="wirebox";
    property name="manager" inject="Manager@cffractal";

    /**
    * Define includes properties to allow for accessors
    **/
    property name="defaultIncludes";
    property name="availableIncludes";

    /**
    * The key used to define the root level key for the serialized data.
    */
    variables.resourceKey = "data";

    /**
    * The array of default includes.
    * These includes are always return whether requested or not.
    * These are normally set by setting the `variables.defaultIncludes`
    * inside a concrete Transformer component.
    */
    variables.defaultIncludes = [];

    /**
    * The array of available includes.
    * These includes are only returned if requested in the Fractal Manager.
    * These are normally set by setting the `variables.availableIncludes`
    * inside a concrete Transformer component.
    */
    variables.availableIncludes = [];

    /**
    * @abstract
    * Defines the method for transforming a specific resource.
    *
    * @data    The data or component to transform.
    *
    * @returns The transformed data.
    */
    function transform( data ) {
        throw(
            type = "MethodNotImplemented",
            message = "The method `transform()` must be implemented in a subclass."
        );
    }

    /**
    * Allows the user to set a custom fractal Manager
    **/
    function setManager( required any manager ){
        variables.manager = arguments.manager;
        return this;
    }

    /**
    * Allows the user to set a custom serializer for the transformer.
    * This method sets both the itemSerializer and the collectionSerializer.
    *
    * @serializer The default custom serializer to use for items and
    *             collections created by this transformer.
    *
    * @returns    The transfomer instance.
    */
    function setSerializer( required any serializer ) {
        setItemSerializer( serializer );
        setCollectionSerializer( serializer );
        return this;
    }

    /**
    * Allows the user to set a custom item serializer for the transformer.
    *
    * @serializer The default custom serializer to use for items created by this transformer.
    *
    * @returns    The transfomer instance.
    */
    function setItemSerializer( required any serializer ) {
        variables.itemSerializer = arguments.serializer;
        return this;
    }

    /**
    * Allows the user to set a custom collection serializer for the transformer.
    *
    * @serializer The default custom serializer to use for collections created by this transformer.
    *
    * @returns    The transfomer instance.
    */
    function setCollectionSerializer( required any serializer ) {
        variables.collectionSerializer = arguments.serializer;
        return this;
    }

    /**
    * Determines if a transformer has any available or default includes.
    *
    * @returns True if a transformer has any available or default includes.
    */
    function hasIncludes() {
        return ! arrayIsEmpty( variables.availableIncludes ) ||
               ! arrayIsEmpty( variables.defaultIncludes );
    }

    /**
    * Processes any available includes and returns the transformed data.
    *
    * @scope   The current Fractal scope.  Used to find request includes
    *          and to set the current nesting identifier.
    * @data    The data or component off of which to base the include.
    *
    * @returns An array of transformed data to merge in to the current scope.
    */
    function processIncludes( scope, data ) {
        var scopedIncludes = filterIncludes( scope );
        var includedData = [];

        var scopedExcludes = scope.getExcludes( scoped = true );
        var allIncludes = scope.getIncludes();
        var allExcludes = scope.getExcludes();

        for ( var include in scopedIncludes ) {
            var resource = invoke( this, "include#include#", {
                1 = data,
                2 = scopedIncludes,
                3 = scopedExcludes,
                4 = allIncludes,
                5 = allExcludes
            } );
            if ( isSimpleValue( resource ) ) {
                resource = item(
                    resource,
                    function( item ) { return item; },
                    new cffractal.models.serializers.SimpleSerializer()
                );
            }
            var childScope = scope.embedChildScope( include, resource );
            arrayAppend( includedData, childScope.convert() );
        }
        return includedData;
    }

    /**
    * Returns the resource key.
    * The resource key is used to define the root level key for the serialized data.
    *
    * @returns The current resource key.
    */
    function getResourceKey() {
        return variables.resourceKey;
    }

    /**
    * Returns the resource key.
    * The resource key is used to define the root level key for the serialized data.
    *
    * @resourceKey The new key to use.
    *
    * @returns The Transformer instance.
    */
    function setResourceKey( resourceKey ) {
        variables.resourceKey = arguments.resourceKey;
        return this;
    }

    /**
    * Filters all includes down to default includes and requested available includes.
    *
    * @scope   The current Fractal scope.  Used to determine if
    *          an available includes was requested.
    *
    * @returns An array of includes to fetch for the transformer.
    */
    public array function filterIncludes( scope ) {
        var filteredIncludes = variables.defaultIncludes;
        for ( var include in variables.availableIncludes ) {
            if ( scope.requestedInclude( include ) ) {
                arrayAppend( filteredIncludes, include );
            }
        }
        var excludes = scope.getExcludes();
        return arrayFilter( filteredIncludes, function( include ) {
            return ! scope.requestedExclude( include );
        } );
    }

    /**
    * Returns a new item resource with the given data and transformer.
    * Used primarily inside a includes method.
    *
    * @data         The data or component to transform.
    * @transformer  The transformer callback or component to use
    *               transforming the above data.
    * @serializer   A custom serializer for this resource.
    * @itemCallback An optional callback to call after each item is serialized.
    *
    * @returns      A new cffractal Item wrapping the given data and transformer.
    */
    private function item( data, transformer, serializer, itemCallback ) {
        if ( isNull( arguments.serializer ) && ! isNull( variables.itemSerializer ) ) {
            arguments.serializer = variables.itemSerializer;
        }
        return manager.item( argumentCollection = arguments );
    }

    /**
    * Returns a new collection resource with the given data and transformer.
    * Used primarily inside a includes method.
    *
    * @data         The data or component to transform.
    * @transformer  The transformer callback or component to use
    *               transforming the above data.
    * @serializer   A custom serializer for this resource.
    * @itemCallback An optional callback to call after each item is serialized.
    *
    * @returns      A new cffractal Collection wrapping the given data and transformer.
    */
    private function collection( data, transformer, serializer, itemCallback ) {
        if ( isNull( arguments.serializer ) && ! isNull( variables.collectionSerializer ) ) {
            writeDump( var = 'here', top = 2 );
            arguments.serializer = variables.collectionSerializer;
        }
        return manager.collection( argumentCollection = arguments );
    }
}

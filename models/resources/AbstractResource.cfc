/**
* @name        AbstractResource
* @package     cffractal.models.resources
* @description Defines the common methods for processing
*              resources into serializable data.
*/
component accessors="true" {

    /**
    * The item to transform into serializable data.
    */
    property name="data";

    /**
    * The transformer component or callback used to transform the data.
    */
    property name="transformer";

    /**
    * The serializer used for this resource.
    */
    property name="serializer";

    /**
    * The collection of metadata for this resource. Default: {}.
    */
    property name="meta";

    /**
    * The paging data for this resource.
    */
    property name="pagingData";

    /**
    * An array of post-transformation callbacks to run
    * on each item after it has been transformed.
    */
    variables.postTransformationCallbacks = [];

    /**
    * Creates a new cffractal resource.
    *
    * @data        The data to be transformed into serializable data.
    * @transformer The transformer component or callback to
    *              use to transform the data.
    *
    * @returns     A Fractal resource.
    */
    function init( data, transformer, serializer, meta = {}, itemCallback ) {
        variables.data = isNull( arguments.data ) ? javacast( "null", "" ) : arguments.data;
        variables.transformer = arguments.transformer;
        variables.serializer = arguments.serializer;
        variables.meta = arguments.meta;
        if ( ! isNull( itemCallback ) ) {
            addPostTransformationCallback( itemCallback );
        }
        return this;
    }

    /**
    * @abstract
    * Processes the conversion of a resource to serializable data.
    * Also processes any default or requested includes.
    *
    * @scope   A Fractal scope instance.  Used to determinal requested
    *          includes and handle nesting identifiers.
    *
    * @returns The transformed data.
    */
    function process( scope ) {
        throw(
            type = "MethodNotImplemented",
            message = "The method `process()` must be implemented in a subclass."
        );
    }

    /**
    * Processes the conversion of a single item to serializable data.
    * Also processes any default or requested includes.
    *
    * @scope   A Fractal scope instance.  Used to determinal requested
    *          includes and handle nesting identifiers.
    * @item    A single item instance to transform.
    *
    * @returns The transformed data.
    */
    function processItem( scope, item ) {
        if ( isNull( item ) ) {
            return scope.getNullDefaultValue();
        }

        var transformedData = transformData( transformer, item );

        if ( isNull( transformedData ) ) {
            return scope.getNullDefaultValue();
        }

        if ( isClosure( transformer ) || isCustomFunction( transformer ) ) {
            return isNull( transformedData ) ? javacast( "null", "" ) : transformedData;
        }

        if ( ! transformer.hasIncludes() ) {
            return isNull( transformedData ) ? javacast( "null", "" ) : transformedData;
        }

        var includedData = transformer.processIncludes(
            scope,
            item
        );

        for ( var includedDataSet in includedData ) {
            structAppend(
                isNull( transformedData ) ? {} : transformedData,
                includedDataSet,
                true /* overwrite */
            );
        }

        return isNull( transformedData ) ? javacast( "null", "" ) : transformedData;
    }

    /**
    * Adds some data under a given identifier in the metadata.
    *
    * @key     The key to nest the data under in the metadata scope.
    * @value   The data to store under the given key.
    *
    * @returns The resource instance.
    */
    function addMeta( key, value ) {
        variables.meta[ key ] = value;
        return this;
    }

    /**
    * Returns whether the resource has any metadata associated with it.
    *
    * @returns True if there are any metadata keys present.
    */
    function hasMeta() {
        return ! structIsEmpty( variables.meta );
    }

    /**
    * Returns whether any paging data has been set.
    *
    * @returns True if there is any paging data set.
    */
    function hasPagingData() {
        return ! isNull( variables.pagingData );
    }

    /**
    * Add a post transformation callback to run after transforming each item.
    * The value returned from the callback becomes the transformed item.
    *
    * @callback A callback to run after the resource has been transformed.
    *           The callback will be passed the transformed data, the
    *           original data, and the resource object as arguments.
    *
    * @returns  The resource instance.
    */
    function addPostTransformationCallback( callback ) {
        arrayAppend( postTransformationCallbacks, callback );
        return this;
    }

    function getTransformerResourceKey() {
        return isClosure( variables.transformer ) ?
            "data" :
            variables.transformer.getResourceKey();
    }

    /**
    * Handles the calling of the transformer,
    * whether a callback or a component.
    *
    * @transformer The callback or component to use to transform the item.
    * @item        The item to transform.
    *
    * @returns     The transformed data.
    */
    private function transformData( transformer, item ) {
        return isClosure( transformer ) || isCustomFunction( transformer ) ?
            transformer( isNull( item ) ? javacast( "null", "" ) : item ) :
            transformer.transform( isNull( item ) ? javacast( "null", "" ) : item );
    }

    /**
    * Returns the original value if it is not null.
    * Otherwise, returns the manager null default value.
    *
    * @returns The original value, if not null, or the manager default null value.
    */
    private function paramNull( value, defaultValue ) {
        return isNull( value ) ? defaultValue : value;
    }

}

component {

    /**
    * The WireBox injector
    */
    property name="wirebox" inject="wirebox";

    /**
    * The metadata struct to add to the resource.
    */
    variables.meta = {};

    /**
    * The post-transformation callbacks to add to the resource.
    */
    variables.postTransformationCallbacks = [];

    /**
     * Creates a new builder instance for fluent fractal transformations.
     *
     * @manager The fractal manager instance.
     * @manager.inject Manager@cffractal
     *
     * @returns The fractal builder.
     */
    function init( required manager ) {
        variables.manager = arguments.manager;
        variables.includes = "";
        variables.excludes = "";
        return this;
    }

    /**
    * Sets the item resource to be transformed.
    *
    * @data    The model to transform.
    *
    * @returns The fractal builder.
    */
    function item( data ) {
        variables.data = arguments.data;
        variables.resourceType = "item";
        return this;
    }

    /**
    * Sets the collection resource to be transformed.
    *
    * @data    The model to transform.
    *
    * @returns The fractal builder.
    */
    function collection( data ) {
        variables.data = !isNull( arguments.data ) ? arguments.data : [];
        variables.resourceType = "collection";
        return this;
    }

    /**
    * Sets the transformer to use.
    * If the transformer is a simple value, the Builder
    * will treat it as a WireBox binding.
    *
    * @transformer The transformer to use.
    *
    * @returns     The fractal builder.
    */
    function withTransformer( transformer ) {
        if ( isSimpleValue( arguments.transformer ) ) {
            arguments.transformer = wirebox.getInstance( arguments.transformer );
        }
        variables.transformer = arguments.transformer;
        return this;
    }

    /**
    * Sets the serializer to use.
    * If the serializer is a simple value, the Builder
    * will treat it as a WireBox binding.
    *
    * @serializer The serializer to use.
    *
    * @returns    The fractal builder.
    */
    function withSerializer( serializer ) {
        if ( isSimpleValue( arguments.serializer ) ) {
            arguments.serializer = wirebox.getInstance( arguments.serializer );
        }
        variables.serializer = arguments.serializer;
        return this;
    }

    /**
    * Sets the includes for the transformation.
    *
    * @includes The includes for the transformation.
    *
    * @returns  The fractal builder.
    */
    function withIncludes( includes ) {
        variables.includes = arguments.includes;
        return this;
    }

    /**
    * Sets the excludes for the transformation.
    *
    * @excludes The excludes for the transformation.
    *
    * @returns  The fractal builder.
    */
    function withExcludes( excludes ) {
        variables.excludes = arguments.excludes;
        return this;
    }

    /**
    * Sets the pagination metadata for the resource.
    *
    * @pagination The pagination metadata.
    *
    * @returns    The fractal builder.
    */
    function withPagination( pagination ) {
        withMeta( "pagination", pagination );
        return this;
    }

    /**
    * Adds a key / value pair to the metadata for the resource.
    *
    * @key     The metadata key.
    * @value   The metadata value.
    *
    * @returns The fractal builder.
    */
    function withMeta( key, value ) {
        variables.meta[ key ] = value;
        return this;
    }

    /**
    * Add a callback to be called after each item is transformed.
    *
    * @callback The callback to run after each item has been transformed.
    *           The callback will be passed the transformed data, the
    *           original data, and the resource object as arguments.
    *
    * @returns  The fractal builder
    */
    function withItemCallback( callback ) {
        arrayAppend( variables.postTransformationCallbacks, callback );
        return this;
    }

    /**
    * Transforms the data using the set properties through the fractal manager.
    *
    * @returns The transformed data.
    */
    function convert() {
        var resource = createResource();
        for ( var callback in variables.postTransformationCallbacks ) {
            resource.addPostTransformationCallback( callback );
        }
        return variables.manager.createData( resource, variables.includes, variables.excludes ).convert();
    }

    /**
    * Transform the data through cffractal and then serialize it to JSON.
    *
    * @returns The transformed data as JSON.
    */
    function toJSON() {
        return serializeJSON( convert() );
    }

    /**
    * Creates a resource instance using the builder state,
    * complete with metadata.
    *
    * @returns The newly created resource instance.
    */
    private function createResource() {
        return addMetadata(
            invoke( variables.manager, resourceType, {
                data = variables.data,
                transformer = variables.transformer,
                serializer = getSerializer()
            } )
        );
    }

    /**
    * Adds metadata to a resource instance,
    *
    * @resource A resource instance
    *
    * @returns  The resource instance with added metadata.
    */
    private function addMetadata( resource ) {
        structEach( variables.meta, function( key, value ) {
            resource.addMeta( key, value );
        } );
        return resource;
    }

    /**
    * Returns the specified serailzer or a default serializer, as needed.
    *
    * @returns  The specified or default serializer.
    */
    private function getSerializer() {
        if ( ! isNull( variables.serializer ) ) {
            return variables.serializer;
        }

        return resourceType == "item" ?
            variables.manager.getItemSerializer() :
            variables.manager.getCollectionSerializer();
    }

}

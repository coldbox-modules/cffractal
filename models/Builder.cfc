component {

    /**
    * The WireBox injector
    */
    property name="wirebox" inject="wirebox";

    variables.meta = {};

    /**
    * Creates a new builder instance for fluent fractal transformations.
    *
    * @manager The fractal manager instance.
    *
    * @returns The fractal builder.
    */
    function init( manager ) {
        variables.manager = arguments.manager;
        variables.includes = "";
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
        variables.data = arguments.data;
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
    * Sets the pagination struct for the resource.
    *
    * @pagination The pagination struct.
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
        meta[ key ] = value;
        return this;
    }

    /**
    * Transforms the data using the set properties through the fractal manager.
    *
    * @returns The transformed data.
    */
    function convert() {
        return manager.createData(
            resource = createResource(),
            includes = includes
        ).convert();
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
            invoke( manager, resourceType, {
                data = data,
                transformer = transformer,
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
        structEach( meta, function( key, value ) {
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
        if ( ! isNull( serializer ) ) {
            return serializer;
        }

        return resourceType == "item" ?
            manager.getItemSerializer() :
            manager.getCollectionSerializer();
    }

}
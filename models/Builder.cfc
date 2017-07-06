component {

    /**
    * The WireBox injector
    */
    property name="wirebox" inject="wirebox";

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
    * Transforms the data using the set properties through the fractal manager.
    *
    * @returns The transformed data.
    */
    function toStruct() {
        return manager.createData(
            resource = invoke( manager, resourceType, {
                data = data,
                transformer = transformer,
                serializer = getSerializer()
            } ),
            includes = includes
        ).toStruct();
    }

    /**
    * Transform the data through cffractal and then serialize it to JSON.
    *
    * @returns The transformed data as JSON.
    */
    function toJSON() {
        return serializeJSON( toStruct() );
    }

    private function getSerializer() {
        if ( ! isNull( serializer ) ) {
            return serializer;
        }

        return resourceType == "item" ?
            manager.getItemSerializer() :
            manager.getCollectionSerializer();

    }

}
/**
* @name        Manager
* @package     cffractal.models
* @description The Manager component is responsible for kickstarting
*              the api transformation process.  It creates the root
*              scope and serializes the transformed value.
*/
component singleton {

    /**
    * The WireBox injector
    */
    property name="wirebox" inject="wirebox";

    /**
    * The serializer instance.
    */
    property name="serializer";

    /**
    * Create a new Manager instance.
    *
    * @itemSerializer       The serializer to use to serialize items.
    * @collectionSerializer The serializer to use to serialize collections.
    *
    * @returns              The Fractal Manager.
    */
    function init( itemSerializer, collectionSerializer ) {
        variables.itemSerializer = arguments.itemSerializer;
        variables.collectionSerializer = arguments.collectionSerializer;
        return this;
    }

    function builder() {
        if ( structKeyExists( variables, "wirebox" ) ) {
            return wirebox.getInstance(
                name = "Builder@cffractal",
                initArguments = {
                    manager = this
                }
            );
        }
        else {
            return new cffractal.models.Builder( this );
        }
    }

    /**
    * Sets a new serializer to use to serialize items.
    *
    * @serializer The serializer to use to serialize items.
    *
    * @returns The Fractal Manager.
    */
    function setCollectionSerializer( serializer ) {
        variables.collectionSerializer = arguments.serializer;
        return this;
    }

    /**
    * Gets the currently set serializer for items.
    *
    * @returns The current serializer for items.
    */
    function getCollectionSerializer() {
        return variables.collectionSerializer;
    }

    /**
    * Sets a new serializer to use to serialize collections.
    *
    * @serializer The serializer to use to serialize collections.
    *
    * @returns The Fractal Manager.
    */
    function setItemSerializer( serializer ) {
        variables.itemSerializer = arguments.serializer;
        return this;
    }

    /**
    * Gets the currently set serializer for collections.
    *
    * @returns The current serializer for collections.
    */
    function getItemSerializer() {
        return variables.itemSerializer;
    }

    /**
    * Creates a scope for a given resource and identifier.
    *
    * @resource        A Fractal resource.
    * @includes        A list of includes for the scope.  Includes are
    *                  comma separated and use dots to designate
    *                  nested resources to be included.
    * @identifier The scope identifier defining the nesting level.
    *                  Defaults to the root level.
    *
    * @returns         A Fractal scope primed with the given resource and identifier.
    */
    function createData( resource, includes = "", identifier = "" ) {
        arguments.manager = this;
        return new cffractal.models.Scope( argumentCollection = arguments );
    }

    /**
    * Returns a new item resource with the given data and transformer.
    *
    * @data        The data or component to transform.
    * @transformer The transformer callback or component to use
    *              transforming the above data.
    *
    * @returns     A new cffractal Item wrapping the given data and transformer.
    */
    function item( data, transformer, serializer = variables.itemSerializer ) {
        return new cffractal.models.resources.Item( argumentCollection = arguments );
    }

    /**
    * Returns a new collection resource with the given data and transformer.
    *
    * @data        The data or component to transform.
    * @transformer The transformer callback or component to use
    *              transforming the above data.
    *
    * @returns     A new cffractal Collection wrapping the given data and transformer.
    */
    function collection( data, transformer, serializer = variables.collectionSerializer ) {
        return new cffractal.models.resources.Collection( argumentCollection = arguments );
    }

}
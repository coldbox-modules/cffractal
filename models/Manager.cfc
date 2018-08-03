/**
* @name        Manager
* @package     cffractal.models
* @description The Manager component is responsible for kickstarting
*              the api transformation process.  It creates the root
*              scope and serializes the transformed value.
*/
component singleton accessors="true" {

    /**
    * The WireBox injector
    */
    property name="wirebox" inject="wirebox";

    /**
    * The default item serializer.
    */
    property name="itemSerializer";

    /**
    * The default collection serializer.
    */
    property name="collectionSerializer";

    /**
    * The serializer instance.
    */
    property name="nullDefaultValue";

    /**
    * Create a new Manager instance.
    *
    * @itemSerializer       The serializer to use to serialize items.
    * @collectionSerializer The serializer to use to serialize collections.
    * @nullDefaultValue     The default value to use when encountering nulls.
    *
    * @returns              The Fractal Manager.
    */
    function init( itemSerializer, collectionSerializer, nullDefaultValue = "" ) {
        variables.itemSerializer = arguments.itemSerializer;
        variables.collectionSerializer = arguments.collectionSerializer;
        variables.nullDefaultValue = arguments.nullDefaultValue;
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
    * Creates a scope for a given resource and identifier.
    *
    * @resource   A Fractal resource.
    * @includes   A list of includes for the scope.  Includes are
    *             comma separated and use dots to designate
    *             nested resources to be included.
    * @excludes   A list of excludes for the scope.  Excludes are
    *             comma separated and use dots to designate
    *             nested resources to be excluded.
    * @identifier The scope identifier defining the nesting level.
    *             Defaults to the root level.
    *
    * @returns    A Fractal scope primed with the given resource and identifier.
    */
    function createData( resource, includes = "", excludes = "", identifier = "" ) {
        arguments.manager = this;
        return new cffractal.models.Scope( argumentCollection = arguments );
    }

    /**
    * Returns a new item resource with the given data and transformer.
    *
    * @data        The data or component to transform.
    * @transformer The transformer callback or component to use
    *              transforming the above data.
    * @serializer   A custom serializer for this resource.
                    Defaults to the manager default for a item.
    * @itemCallback An optional callback to call after each item is serialized.
    *
    * @returns      A new cffractal Item wrapping the given data and transformer.
    */
    function item(
        data,
        transformer,
        serializer = variables.itemSerializer,
        itemCallback
    ) {
        return new cffractal.models.resources.Item( argumentCollection = arguments );
    }

    /**
    * Returns a new collection resource with the given data and transformer.
    *
    * @data         The data or component to transform.
    * @transformer  The transformer callback or component to use
    *               transforming the above data.
    * @serializer   A custom serializer for this resource.
    *               Defaults to the manager default for a collection.
    * @itemCallback An optional callback to call after each item is serialized.
    *
    * @returns      A new cffractal Collection wrapping the given data and transformer.
    */
    function collection(
        data,
        transformer,
        serializer = variables.collectionSerializer,
        itemCallback
    ) {
        return new cffractal.models.resources.Collection( argumentCollection = arguments );
    }

    /**
    * Overload to the accessor, to ensure a struct default will not be copied by reference
    **/
    function getNullDefaultValue() {
        return !isNull( variables.nullDefaultValue ) ? duplicate( variables.nullDefaultValue ) : javacast( "null", 0 );
    }

}

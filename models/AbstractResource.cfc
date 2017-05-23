component accessors="true" {

    property name="data";
    property name="transformer";

    function init( data, transformer ) {
        setData( data );
        setTransformer( transformer );
        return this;
    }

    function transform() {
        throw(
            type = "MethodNotImplemented",
            message = "The method `transform()` must be implemented in a subclass."
        );
    }

    function transformData( transformer, data ) {
        return isClosure( transformer ) ?
            transformer( data ) :
            transformer.transform( data );
    }

}
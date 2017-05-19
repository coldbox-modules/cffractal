component accessors="true" {

    property name="data";
    property name="transformer";

    function init( data, transformer ) {
        setData( data );
        setTransformer( transformer );
        return this;
    }

}
component accessors="true" {

    property name="data";
    property name="transformer";

    function init( data, transformer ) {
        setData( data );
        setTransformer( transformer );
        return this;
    }

    function process( scope ) {
        var transformedData = transform();
        
        if ( isClosure( getTransformer() ) ) {
            return transformedData;
        }

        if ( ! getTransformer().hasIncludes() ) {
            return transformedData;
        }

        var includedData = getTransformer().processIncludes( scope, getData() );
        
        for ( var includedDataSet in includedData ) {
            structAppend( transformedData, includedDataSet, true /* overwrite */ );
        }

        return transformedData;
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
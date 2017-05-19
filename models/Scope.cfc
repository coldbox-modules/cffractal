component accessors="true" {

    property name="manager";
    property name="resource";

    function init( manager, resource ) {
        setManager( manager );
        setResource( resource );
        return this;
    }

    function toJSON() {
        if ( isInstanceOf( getResource(), "fractal.models.Item" ) ) {
            var transformedData = transformData(
                getResource().getTransformer(),
                getResource().getData()
            );
        }
        else {
            var transformedData = [];
            for ( var value in getResource().getData() ) {
                arrayAppend(
                    transformedData,
                    transformData(
                        getResource().getTransformer(),
                        value
                    )
                );
            }
            transformedData = { "data" = transformedData };
        }
        
        return serializeJSON( transformedData );
    }

    function transformData( transformer, data ) {
        return isClosure( transformer ) ?
            transformer( data ) :
            transformer.transform( data );
    }

}
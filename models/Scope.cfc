component accessors="true" {

    property name="manager";
    property name="resource";

    function init( manager, resource ) {
        setManager( manager );
        setResource( resource );
        return this;
    }

    function toStruct() {
        if ( isInstanceOf( getResource(), "fractal.models.Item" ) ) {
            return transformData(
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
            return { "data" = transformedData };
        }
    }

    function toJSON() {        
        return serializeJSON( toStruct() );
    }

    function transformData( transformer, data ) {
        return isClosure( transformer ) ?
            transformer( data ) :
            transformer.transform( data );
    }

}
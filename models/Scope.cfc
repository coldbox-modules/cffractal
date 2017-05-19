component accessors="true" {

    property name="manager";
    property name="resource";

    function init( manager, resource ) {
        setManager( manager );
        setResource( resource );
        return this;
    }

    function toJSON() {
        var transformer = getResource().getTransformer();
        if ( isClosure( transformer ) ) {
            var transformedData = transformer( getResource().getData() ); 
        }
        else {
            var transformedData = transformer.transform( getResource().getData() ); 
        }
        return serializeJSON( transformedData );
    }

}